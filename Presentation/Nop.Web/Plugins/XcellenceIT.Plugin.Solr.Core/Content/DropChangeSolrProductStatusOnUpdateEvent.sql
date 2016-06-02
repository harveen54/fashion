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
GO

/****** Object:  StoredProcedure [dbo].[ChangeSolrProductStatusOnUpdateEventById]    Script Date: 04/29/2013 10:42:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChangeSolrProductStatusOnUpdateEventById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ChangeSolrProductStatusOnUpdateEventById]
GO

