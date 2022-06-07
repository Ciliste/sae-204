SELECT nomEditeur, count(b.*) AS "nombre de BD"
FROM   Editeur e JOIN Serie s ON e.numEditeur = s.numEditeur
                 JOIN BD    b ON b.numSerie   = s.numSerie
GROUP BY nomEditeur;

/* commande à executer dans woody
\copy (
    SELECT nomEditeur, count(b.*) AS "nombre de BD"
    FROM   Editeur e JOIN Serie s ON e.numEditeur = s.numEditeur
                     JOIN BD    b ON b.numSerie   = s.numSerie
    GROUP BY nomEditeur
) TO
'./vB.csv' DELIMITER ';' QUOTE '"' CSV HEADER
*/