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
-- Author:		 Ankita Patel
-- Create date:   28-10-2015
-- Description:	
				  -- Update SolrStatus of products on Category, Manufacturer update event
-- =============================================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChangeSolrProductStatusOnUpdateEventById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ChangeSolrProductStatusOnUpdateEventById]
GO

CREATE PROCEDURE [dbo].[ChangeSolrProductStatusOnUpdateEventById]
(
	@Id	int, --where Id is Category Id or Manufacturer Id
	@Name nvarchar(MAX) --Where Name indicates whether it is Category update event or Manufacturer update event
)
AS

	IF(@Name = 'Category')
		BEGIN
			UPDATE Incremental_Solr_Product set SolrStatus = 1 WHERE ProductId IN  (SELECT pc.ProductId FROM Product_Category_Mapping pc
			WHERE pc.CategoryId = @Id) 
		END
	ELSE IF(@Name = 'Manufacturer')
		BEGIN
			UPDATE Incremental_Solr_Product set SolrStatus = 1 WHERE ProductId IN (SELECT pm.ProductId FROM Product_Manufacturer_Mapping pm
			WHERE pm.ManufacturerId = @Id) 
		END
		
GO

