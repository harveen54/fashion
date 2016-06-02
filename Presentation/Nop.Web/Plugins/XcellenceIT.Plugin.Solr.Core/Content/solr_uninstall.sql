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
				  -- Droppring all the tables/settings while uninstalling the core plugin
				  -- Removing Incremental_Solr_Products, ScheduleTask, ActivityLogType etc
-- =============================================================================================


-- Deleting incremental solr products from [Incremental_Solr_Product] table, but check if table exists or not before delete to overcome issue table doesn't exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Incremental_Solr_Product'))
BEGIN
DROP TABLE [dbo].[Incremental_Solr_Product]
END


-- Deleting solr logs from [SolrLog] table, but check if table exists or not before delete to overcome issue table doesn't exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SolrLog'))
BEGIN
DROP TABLE [dbo].[SolrLog]
END

-- Deleting nopAccelerate Search TermLog  from [nopAccelerateSearchTermLog] table, but check if table exists or not before delete to overcome issue table doesn't exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'NopAccelerateSearchTermLog'))
BEGIN
DROP TABLE [dbo].[NopAccelerateSearchTermLog]
END

-- Deleting scheduler setting from [ScheduleTask] table
Delete from [dbo].[ScheduleTask] Where Name like 'Solr IDI Process'
Delete from [dbo].[ScheduleTask] Where Name like 'UpdatePopularProducts'


-- Deleting activity log setting from [ActivityLogType] table
Delete from [dbo].[ActivityLogType] Where SystemKeyword like 'SolrUtility';
Delete from [dbo].[ActivityLogType] Where SystemKeyword like 'SolrUtilityAPI';
Delete from [dbo].[ActivityLogType] Where SystemKeyword like 'AddSolrProduct';
Delete from [dbo].[ActivityLogType] Where SystemKeyword like 'AddSolrProductAPI';
Delete from [dbo].[ActivityLogType] Where SystemKeyword like 'UpdateSolrProductAPI';
Delete from [dbo].[ActivityLogType] Where SystemKeyword like 'DeleteSolrProduct';
Delete from [dbo].[ActivityLogType] Where SystemKeyword like 'DeleteSolrProductAPI';