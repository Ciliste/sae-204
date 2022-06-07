--Représenter le nombre de BD vendues par éditeur de deux manières : par un
--diagramme de type histogramme (les noms des éditeurs sont en abscisse et le
--nombre de BD est en ordonnée) et par un diagramme de type secteur (on les
--placera sur la même feuille).

SELECT nomEditeur, count(b.*) AS "nombre de BD"
FROM   Editeur e JOIN Serie s ON e.numEditeur = s.numEditeur
                 JOIN BD    b ON b.numSerie   = s.numSerie
GROUP BY nomEditeur;

-- \copy ( SELECT nomEditeur, count(b.*) AS "nombre de BD" FROM Editeur e JOIN Serie s ON e.numEditeur = s.numEditeur JOIN BD    b ON b.numSerie   = s.numSerie GROUP BY nomEditeur ) TO './vB.csv' DELIMITER ';' QUOTE '"' CSV HEADER
