use normandy_db;
SELECT * FROM com_normandie_db_2;
SELECT * FROM departement_db;

SELECT * FROM labels_list_db;
SELECT * FROM offres_normandie_db;
SELECT * FROM sites_normandie_db;
SELECT * FROM type_offre_db;

#cleaning offres_normandie with blank values
SELECT INSEE 
FROM normandy_db.offres_normandie_db 
WHERE INSEE NOT IN (SELECT com_INSEE FROM normandy_db.com_normandie_db);

SET SQL_SAFE_UPDATES = 0;
DELETE FROM normandy_db.offres_normandie_db 
WHERE INSEE NOT IN (SELECT com_INSEE FROM normandy_db.com_normandie_db);
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE `normandy_db`.`offres_normandie_db` 
MODIFY COLUMN `TSID` VARCHAR(255);

ALTER TABLE `normandy_db`.`descriptif_db` 
MODIFY COLUMN `TSID` VARCHAR(255);

SELECT *
FROM normandy_db.nr_descriptif_2
WHERE CHAR_LENGTH(TSID) > 18;

SELECT COUNT(*) AS count_of_long_tsid
FROM normandy_db.nr_descriptif_2
WHERE CHAR_LENGTH(TSID) > 18;

SELECT COUNT(*) AS count
FROM normandy_db.descriptif_db;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM normandy_db.descriptif_db
WHERE CHAR_LENGTH(TSID) > 18;
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE `normandy_db`.`offres_normandie_db` 
MODIFY COLUMN `TSID` VARCHAR(255);

ALTER TABLE `normandy_db`.`descriptif_db` 
MODIFY COLUMN `TSID` VARCHAR(255);

ALTER TABLE `normandy_db`.`descriptif_db`
ADD INDEX (`TSID`);

SELECT TSID 
FROM normandy_db.offres_normandie_db 
WHERE TSID NOT IN (SELECT TSID FROM normandy_db.descriptif_db);

SET SQL_SAFE_UPDATES = 0;

DELETE FROM normandy_db.offres_normandie_db 
WHERE TSID NOT IN (SELECT TSID FROM normandy_db.descriptif_db);

ALTER TABLE normandy_db.descriptif_db
MODIFY TSID VARCHAR(255);

SELECT TSID
FROM normandy_db.offres_normandie_db
WHERE TSID NOT IN (SELECT TSID FROM normandy_db.descriptif_db);

INSERT INTO normandy_db.descriptif_db (TSID)
SELECT TSID
FROM normandy_db.offres_normandie_db
WHERE TSID NOT IN (SELECT TSID FROM normandy_db.descriptif_db);



