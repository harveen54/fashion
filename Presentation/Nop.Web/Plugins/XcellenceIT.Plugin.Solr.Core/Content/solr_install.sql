--*************************************************************************
--*                                                                       *
--* nopAccelerate - Solr Integration Extension for nopCommerce            *
--* Copyright (c) Xcellence-IT. All Rights Reserved.                      *
--*                                                                       *
--*************************************************************************
--*                                                                       *
--* Email: info@nopaccelerate.com                                         *
--* Website: http://www.nopaccelerate.com                                 *
--*                                                                       *
--*************************************************************************
--*                                                                       *
--* This  software is furnished  under a license  and  may  be  used  and *
--* modified  only in  accordance with the terms of such license and with *
--* the  inclusion of the above  copyright notice.  This software or  any *
--* other copies thereof may not be provided or  otherwise made available *
--* to any  other  person.   No title to and ownership of the software is *
--* hereby transferred.                                                   *
--*                                                                       *
--* You may not reverse  engineer, decompile, defeat  license  encryption *
--* mechanisms  or  disassemble this software product or software product *
--* license.  Xcellence-IT may terminate this license if you don't comply *
--* with  any  of  the  terms and conditions set forth in  our  end  user *
--* license agreement (EULA).  In such event,  licensee  agrees to return *
--* licensor  or destroy  all copies of software  upon termination of the *
--* license.                                                              *
--*                                                                       *
--* Please see the  License file for the full End User License Agreement. *
--* The  complete license agreement is also available on  our  website at *
--* http://www.nopaccelerate.com/terms/                                   *
--*                                                                       *
--*************************************************************************

-- =============================================================================================
-- Author:		  Mayank Modi
-- Create date:   04-09-2015
-- Updated date:   04-30-2015
-- Description:	
				  -- Creating all the tables/settings while installing the core plugin
				  -- Makes all products as pending in Incremental_Solr_Product 
-- =============================================================================================


-- Deleting [Incremental_Solr_Product] table if exists before creating because we don't need to keep track of records
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Incremental_Solr_Product'))
BEGIN
DROP TABLE [dbo].[Incremental_Solr_Product]
END

-- Creating [Incremental_Solr_Product] table
CREATE TABLE [dbo].[Incremental_Solr_Product] (
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[SolrStatus] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[InTime] [datetime] NULL,
	[StoreId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	PRIMARY KEY([Id])
);

-- Now Inserting products into [Incremental_Solr_Product] for solr indexing process
DECLARE @pId int
DECLARE @sId int

Truncate Table [dbo].[Incremental_Solr_Product]
	
Insert Into [dbo].[Incremental_Solr_Product] (ProductId, SolrStatus, IsDeleted, InTime, StoreId, LanguageId)
select distinct p.Id,1,1,GETDATE(),s.Id,l.Id from [dbo].[Store] s, [dbo].[Product] p, [dbo].[Language] as l
left join [dbo].[StoreMapping] sm on sm.EntityId = l.Id 
where (l.LimitedToStores=1 and s.Id in(sm.StoreId) and sm.EntityName='Language') or l.LimitedToStores=0 

DECLARE tempCursor CURSOR SCROLL FOR 
select p.Id,sm.StoreId from [dbo].[Product] as p
	   join [dbo].[StoreMapping] as sm on p.Id = sm.EntityId
	   join [dbo].[Store] as s on sm.StoreId=s.Id
	   where p.LimitedToStores=1 and sm.EntityName ='Product'
	
OPEN tempCursor 
FETCH FIRST FROM tempCursor
INTO @pId,@sId

WHILE @@fetch_status = 0   
 BEGIN    
    UPDATE [dbo].[Incremental_Solr_Product] SET IsDeleted=0
    WHERE ProductId=@pId AND StoreId=@sId
    
    FETCH NEXT FROM tempCursor
    INTO @pId, @sId;
 END
CLOSE tempCursor

UPDATE [dbo].[Incremental_Solr_Product]
Set IsDeleted=0
where ProductId in (Select p.Id from [dbo].[Product] as p where p.LimitedToStores=0)

UPDATE [dbo].[Incremental_Solr_Product]
Set IsDeleted=1
where ProductId in (Select p.Id from [dbo].[Product] as p where p.Published = 0 OR p.Deleted = 1 OR p.VisibleIndividually = 0)

DEALLOCATE tempCursor


-- Add SQL index to [Incremental_Solr_Product] table
CREATE NONCLUSTERED INDEX IX_Incremental_Solr_Product ON [dbo].[Incremental_Solr_Product] (ProductId,SolrStatus,IsDeleted)


-- Install Solr Schedule Task for [Incremental_Solr_Product] table solr indexing scheduler
IF NOT EXISTS ( SELECT * FROM [dbo].[ScheduleTask] WHERE Name = 'Solr IDI Process' )
INSERT Into [dbo].[ScheduleTask] (Name,Seconds,Type,Enabled,StopOnError,LastStartUtc,LastEndUtc,LastSuccessUtc) VALUES ('Solr IDI Process', 3600, 'XcellenceIT.Plugin.Solr.Core.Services.SolrScheduleTask, XcellenceIT.Plugin.Solr.Core', 1, 0, null, null, null)

-- Install Solr Schedule Task to write external file of popular products on solr Core
IF NOT EXISTS ( SELECT * FROM [dbo].[ScheduleTask] WHERE Name = 'UpdatePopularProducts' )
INSERT Into [dbo].[ScheduleTask] (Name,Seconds,Type,Enabled,StopOnError,LastStartUtc,LastEndUtc,LastSuccessUtc) VALUES ('UpdatePopularProducts', 86400, 'XcellenceIT.Plugin.Solr.Core.Services.PopularProductsTask, XcellenceIT.Plugin.Solr.Core', 0, 0, null, null, null)


-- Insert Activity Log types
INSERT Into [dbo].[ActivityLogType] (SystemKeyword,Name,Enabled) 
VALUES ('SolrUtility','Start Indexing',1),
('AddSolrProduct','Add new product in solr',1),
('DeleteSolrProduct','Delete product from solr',1),
('AddSolrProductAPI','nopAccelerate API - Add new product',1),
('UpdateSolrProductAPI','nopAccelerate API - Update product',1),
('DeleteSolrProductAPI','nopAccelerate API - Delete product',1),
('SolrUtilityAPI','nopAccelerate API - Start Indexing',1)


-- Deleting [SolrLog] table if exists before creating because we don't need to keep track of log records
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SolrLog'))
BEGIN
DROP TABLE [dbo].[SolrLog]
END


-- Creating [SolrLog] table
CREATE TABLE [dbo].[SolrLog] (
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShortMessage] [nvarchar](max) NULL,
	[FullMessage] [nvarchar](max) NULL,
	[IpAddress] [nvarchar](200) NULL,
	[PageUrl] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime] NOT NULL,
	[StoreId] [int] NOT NULL,
	PRIMARY KEY([Id])
);


-- Check before creating [SolrCoreConfiguration] table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SolrCoreConfiguration'))
BEGIN
CREATE TABLE [dbo].[SolrCoreConfiguration]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[CoreUrl] [nvarchar](500),
	PRIMARY KEY([Id])
);
END

-- Check before creating [nopAccelerateSearchTermLog] table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'NopAccelerateSearchTermLog'))
BEGIN
CREATE TABLE [dbo].[NopAccelerateSearchTermLog]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SearchTerm] [nvarchar](450) NOT NULL,
	[CatID][int] NULL,
	[ManId][int] NULL,
    [StoreId][int] NOT NULL,
	[ResultCount][int] NOT NULL,
	[Clicks][int] NULL,
	[Latency][decimal](18,2) NOT NULL,
	[TermSearchTime][datetime] NOT NULL,
	PRIMARY KEY([Id])

);

-- Add SQL index to [NopAccelerateSearchTermLog] table
CREATE NONCLUSTERED INDEX IX_NopAccelerateSearchTermLog ON [dbo].[NopAccelerateSearchTermLog] (SearchTerm,CatID)

END