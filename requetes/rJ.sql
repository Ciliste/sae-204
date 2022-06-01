DROP VIEW IF EXISTS bdEd10 CASCADE;

CREATE VIEW bdEd10 AS
SELECT
    Editeur.nomEditeur AS "Nom",
    Editeur.mailEditeur AS "Adresse mail",
    COUNT(BD.titre) AS "Nombre BD"
FROM
    Editeur NATURAL JOIN Serie NATURAL JOIN BD
GROUP BY 
    Editeur.nomEditeur, 
    Editeur.mailEditeur
HAVING
    COUNT(BD.titre) > 10;

SELECT * FROM bdEd10;