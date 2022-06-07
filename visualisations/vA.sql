--Représenter dans le tableur de Libre Office par une courbe des valeurs
--d’évolution des ventes de BD (chiffre d’affaires) par année de vente (dans l’ordre
--croissant des années). Les années sont en abscisse et le chiffre d’affaire en
--ordonnée.

SELECT      SUM(Concerner.prixVente*Concerner.quantite) AS "Chiffre d'affaire", EXTRACT( year from Vente.dteVente ) AS "Année" 
FROM        Vente NATURAL JOIN Concerner 
GROUP BY    EXTRACT( year from Vente.dteVente ) 
ORDER BY    EXTRACT( year from Vente.dteVente );

-- \copy ( SELECT SUM(Concerner.prixVente*Concerner.quantite) AS "Chiffre d'affaire", EXTRACT( year from Vente.dteVente )  AS "Année" FROM Vente NATURAL JOIN Concerner GROUP BY EXTRACT( year from Vente.dteVente ) ORDER BY EXTRACT( year from Vente.dteVente )) TO './vA.csv' DELIMITER ';' QUOTE '"' CSV HEADER

