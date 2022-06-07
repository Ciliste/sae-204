\copy (SELECT SUM(Concerner.prixVente*Concerner.quantite) AS "Chiffre d'affaire", EXTRACT( year from Vente.dteVente )  AS "Année" FROM Vente NATURAL JOIN Concerner GROUP BY EXTRACT( year from Vente.dteVente ) ORDER BY EXTRACT( year from Vente.dteVente )) TO './requete.csv' DELIMITER ';' QUOTE '"' CSV HEADER

