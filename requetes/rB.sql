-- b) Lister les clients (numéro, nom) et leur nombre d’achats (que l’on nommera
--nbA) triés par ordre décroissant de leur nombre d’achats (sans prendre en compte
--la quantité achetée) 

SELECT    v.numClient, nomClient, COUNT(*) AS nbA
FROM      Vente v NATURAL JOIN Client c
GROUP BY  v.numClient, nomClient
ORDER BY  nbA DESC;


 numclient |  nomclient  | nba 
-----------+-------------+-----
         4 | Poret       |  19
         6 | Timable     |  12
         7 | Don Devello |  12
         8 | Ohm         |  11
         3 | Hauraque    |  11
         5 | Menvussa    |   9
        11 | Kament      |   9
        10 | Hautine     |   9
         9 | Ginal       |   8
         2 | Fissile     |   8
         1 | Torguesse   |   6
