DROP VIEW IF EXISTS best5 CASCADE;

CREATE VIEW best5 AS 
SELECT 
    Client.numClient AS "Numéro", 
    Client.nomClient AS "Nom",
    Client.mailClient AS "Adresse mail",
    SUM(Concerner.quantite) AS "nbBD",
    SUM(Concerner.prixVente*Concerner.quantite) AS "couta"
FROM
    Client NATURAL JOIN Vente NATURAL JOIN Concerner
GROUP BY
    Client.numClient,
    Client.nomClient,
    Client.mailClient
ORDER BY
    couta DESC
LIMIT 5;



 Numéro |     Nom     |  Adresse mail   | nbBD |   couta   
--------+-------------+-----------------+------+-----------
      4 | Poret       | mail@he.fr      | 8816 | 129209.55
      6 | Timable     | mail@limelo.com | 6639 |   93406.5
      8 | Ohm         | mail@odie.net   | 6159 |   92865.9
      7 | Don Devello | mail@he.fr      | 5664 |   82909.4
      9 | Ginal       | mail@ange.fr    | 4564 |   66003.9
