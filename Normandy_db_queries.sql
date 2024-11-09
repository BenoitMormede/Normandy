#display tables
use normandy_db;
SELECT * FROM com_normandie_db_2;
SELECT * FROM departement_db;
SELECT * FROM labels_list_db;
SELECT * FROM offres_normandie_db;
SELECT * FROM sites_normandie_db;
SELECT * FROM type_offre_db;

#create a new table com_normandie_db_2 merging com_normandie_db and departement_db
CREATE TABLE com_normandie_db_2 AS
SELECT 
    com_normandie_db.*,
    departement_db.departement AS DepartementText
FROM 
    com_normandie_db
LEFT JOIN 
    departement_db
ON 
    com_normandie_db.code_dpt = departement_db.code_dept;

#displaying the newly created table
SELECT * FROM com_normandie_db_2;

#creating a view for Tableau lodging navigator linking multiple tables
CREATE VIEW lodging_navigator AS
SELECT 
    o.TSID, o.Offre, o.Adresse, o.Commune, o.Code_postal, o.INSEE, o.Latitude, o.Longitude, o.Label,
    o.Services, o.Animaux_acceptes, o.Categorie, o.Capacite, o.Duplicate, o.Label_count, o.Ouverture,
    o.type_offre_ID, d.Descriptif_Cleaned AS Descriptif, 
	t.Type_offre, t.categorie AS Category, c.Departement AS Department
FROM 
    offres_normandie_db o
LEFT JOIN 
    descriptif_db d ON o.TSID = d.TSID
LEFT JOIN 
    type_offre_db t ON o.type_offre_ID = t.type_offre_ID
LEFT JOIN 
    com_normandie_db_2 c ON o.INSEE = c.com_INSEE;
    
#Displaying the view
SELECT * FROM lodging_navigator;    

#creating a view for lodgings with point of interest by "commune"
CREATE OR REPLACE VIEW lodging_interest AS
SELECT 
	s.site AS POI_Name,
    s.visites_an AS POI_Annual_Visits,
    s.Latitude AS POI_Latitude,
    s.Longitude AS POI_Longitude,
    o.TSID AS Lodging_TSID,
    o.Offre AS Lodging_Name,
    o.Adresse AS Lodging_Address,
    o.Commune AS Lodging_Commune,
    o.Latitude AS Lodging_Latitude,
    o.Longitude AS Lodging_Longitude,
    o.Services AS Lodging_Services,
    o.Categorie AS Lodging_Category,
    o.Capacite AS Lodging_Capacity,
    o.Animaux_acceptes AS Pets_Allowed,
    o.Label AS Lodging_Label,
    d.Descriptif_Cleaned AS Lodging_Description
    
   
FROM 
    offres_normandie_db o
LEFT JOIN 
    descriptif_db d ON o.TSID = d.TSID
LEFT JOIN 
    sites_normandie_db s ON o.INSEE = s.Code_Commune_INSEE

WHERE 
    s.site IS NOT NULL
ORDER BY 
    s.visites_an DESC;
    
#Displaying the view
SELECT * FROM lodging_interest
ORDER BY POI_Annual_Visits DESC;

#creating a query to sum the #of lodgings available by commune with point of interest, list POI
SELECT 
    Lodging_Commune AS Commune,
    COUNT(DISTINCT Lodging_TSID) AS Total_Lodgings,
    SUM(Lodging_Capacity) AS Total_Capacity,
    GROUP_CONCAT(DISTINCT POI_Name ORDER BY POI_Name ASC SEPARATOR ', ') AS Points_of_Interest
FROM 
    lodging_interest
GROUP BY 
    Lodging_Commune
ORDER BY 
    Total_Capacity DESC;

#create view Tourism pressure
CREATE OR REPLACE VIEW tourism_pressure AS
SELECT 
    o.code_postal,
    c.nom_com AS commune,
    c.Departement AS departement,
    SUM(o.Capacite) AS total_capacite,
    SUM(c.pop_totale) AS total_population,
    ROUND((SUM(o.Capacite) + SUM(c.pop_totale)) / SUM(c.pop_totale), 2) AS pressure_index
FROM 
    offres_normandie_db o
JOIN 
    com_normandie_db_2 c ON o.code_postal = c.code_postal
GROUP BY 
    o.code_postal, c.nom_com, c.Departement
ORDER BY 
    pressure_index DESC;


    
SELECT * FROM tourism_pressure

