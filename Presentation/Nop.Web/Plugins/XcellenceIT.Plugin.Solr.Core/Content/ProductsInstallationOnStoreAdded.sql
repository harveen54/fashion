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

-- ======================================================================
-- Author:	Ankita Patel
-- Create date: 05-03-2014
-- Updated date: 10-04-2015
-- Description: Add products to Incremental_Solr_Product when add a new Store and new language is added and if language is updated
-- ======================================================================

DECLARE @pId int
DECLARE @sId int
DECLARE @lId int
DECLARE @IsDeleted bit

CREATE TABLE Temp(
ProductId [int],
StoreId [int],
LanguageId [int],
IsDeleted [bit])

DECLARE tempCursor CURSOR SCROLL FOR
 
SELECT p.Id,s.Id,l.Id FROM Store s, Product p, Language as l LEFT JOIN StoreMapping sm ON sm.EntityId = l.Id 
WHERE (l.LimitedToStores=1 AND s.Id IN (sm.StoreId) AND sm.EntityName='Language') OR l.LimitedToStores=0 	

OPEN tempCursor

FETCH FIRST FROM tempCursor
INTO @pId,@sId,@lId

WHILE @@fetch_status = 0   
 BEGIN     
    INSERT INTO Temp
	SELECT @pId,@sId,@lId,0
    
	INSERT INTO Incremental_Solr_Product
	SELECT @pId,1,0,GETDATE(),@sId,@lId
	WHERE NOT EXISTS (SELECT * FROM Incremental_Solr_Product WHERE ProductId = @pId AND StoreId=@sId AND LanguageId=@lId);

    FETCH NEXT FROM tempCursor
    INTO @pId,@sId, @lId;
 END
CLOSE tempCursor

DEALLOCATE tempCursor

DECLARE fetchCursor CURSOR SCROLL FOR 

SELECT ProductId,StoreId,LanguageId, IsDeleted FROM Incremental_Solr_Product

OPEN fetchCursor
FETCH FIRST FROM fetchCursor INTO @pId,@sId,@lId,@IsDeleted

WHILE @@fetch_status = 0
	
BEGIN

IF (SELECT count(*) FROM Temp WHERE ProductId=@pId AND StoreId=@sId AND LanguageId=@lId) >= 1
BEGIN	
	IF (SELECT count(*) FROM Temp WHERE ProductId=@pId AND StoreId=@sId AND LanguageId=@lId AND IsDeleted=@IsDeleted) = 0
	BEGIN
		UPDATE Incremental_Solr_Product SET IsDeleted=0 WHERE ProductId=@pId AND StoreId=@sId AND LanguageId=@lId
	END
END

ELSE 
	BEGIN
		UPDATE Incremental_Solr_Product SET IsDeleted=1 WHERE ProductId=@pId AND StoreId=@sId AND LanguageId=@lId
END
		
 FETCH NEXT FROM fetchCursor
    INTO @pId,@sId, @lId, @IsDeleted;
 END
CLOSE fetchCursor

DEALLOCATE fetchCursor

DROP TABLE Temp

UPDATE Incremental_Solr_Product SET IsDeleted = 1
WHERE ProductId IN (SELECT p.Id FROM Product AS p WHERE p.Published = 0 OR p.Deleted = 1 OR p.VisibleIndividually = 0) 