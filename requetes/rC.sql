-- Lister les clients (numéro, nom) avec leur coût total d’achats (que l’on nommera
--coutA) triés par leur coût décroissant, qui ont totalisé au moins 50000€
--d’achats... */

SELECT    v.numClient, nomClient, SUM(cnc.prixVente * cnc.quantite) AS couta
FROM      Vente v JOIN Client cli    ON v.numClient = cli.numClient
                  JOIN Concerner cnc ON v.numVente  = cnc.numVente
GROUP BY  v.numClient, nomClient
HAVING    SUM(cnc.prixVente * cnc.quantite) > 50000
ORDER BY  couta DESC;


 numclient |  nomclient  |   couta   
-----------+-------------+-----------
         4 | Poret       | 129209.55
         6 | Timable     |   93406.5
         8 | Ohm         |   92865.9
         7 | Don Devello |   82909.4
         9 | Ginal       |   66003.9
        10 | Hautine     |   59519.1
         5 | Menvussa    |   56772.3
         3 | Hauraque    |     51684