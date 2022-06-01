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

SELECT * FROM best5;

SELECT SUM(quantite) FROM