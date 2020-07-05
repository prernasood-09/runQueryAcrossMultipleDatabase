DROP PROCEDURE IF EXISTS `runQueryAcrossAllDb`;

DELIMITER $$

CREATE PROCEDURE `runQueryAcrossAllDb` ()
BEGIN

    DROP TEMPORARY TABLE IF EXISTS tempSchemaList;
   CREATE TEMPORARY TABLE tempSchemaList 
    AS
    SELECT 
        schema_name AS schemaName, 0 AS isRun
    FROM
        information_schema.schemata;
    
    WHILE((SELECT count(*) FROM tempSchemaList WHERE isRun = 0)>0) DO
          
          SELECT 
                schemaName
            INTO @schemaName FROM
                tempSchemaList
            WHERE
                isRun = 0
            LIMIT 1;
          
          SET @sql = CONCAT('SELECT 
                               u.id,u.firstName,u.lastName,\'',@schemaName,'\' AS DB
                            FROM
                                ',@schemaName,'.user u
                            WHERE firstName like \'%Prerna%\' OR lastName like  \'%Sood%\' ');
                            
       --   select @sql;
          PREPARE smt FROM @sql;
          EXECUTE smt;
         
          UPDATE tempSchemaList set isRun = 1 where schemaName = @schemaName;
          
          
    END WHILE; 

END$$

DELIMITER ;

