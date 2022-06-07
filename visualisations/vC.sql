--Proposer une troisième représentation graphique d’une donnée que vous
--choisirez à visualiser.
--Dans le cas présent nous afficherons une courbe du nombre de BD sorties en fonction de l'année.

    SELECT COUNT(BD.titre) AS "Nombre BD", EXTRACT( year from Vente.dteVente )  AS "Année" 
    FROM Vente NATURAL JOIN BD 
    GROUP BY EXTRACT( year from Vente.dteVente ) 
    ORDER BY EXTRACT( year from Vente.dteVente )

-- \copy (SELECT COUNT(BD.titre) AS "Nombre BD", EXTRACT( year from Vente.dteVente )  AS "Année" FROM Vente NATURAL JOIN BD GROUP BY EXTRACT( year from Vente.dteVente ) ORDER BY EXTRACT( year from Vente.dteVente )) TO './vC.csv' DELIMITER ';' QUOTE '"' CSV HEADER
