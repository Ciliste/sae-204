SELECT SUM(Concerner.prixVente*Concerner.quantite) AS "Chiffre d'affaire", EXTRACT( year 
    FROM Vente.dteVente )  AS "Année" FROM Vente NATURAL JOIN Concerner 
    GROUP BY EXTRACT( year from Vente.dteVente ) 
    ORDER BY EXTRACT( year from Vente.dteVente );

/*
\copy (
    SELECT SUM(Concerner.prixVente*Concerner.quantite) AS "Chiffre d'affaire", EXTRACT( year 
    FROM Vente.dteVente )  AS "Année" FROM Vente NATURAL JOIN Concerner 
    GROUP BY EXTRACT( year from Vente.dteVente ) 
    ORDER BY EXTRACT( year from Vente.dteVente )
) TO './vA.csv' DELIMITER ';' QUOTE '"' CSV HEADER
*/
