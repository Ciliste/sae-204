DROP VIEW CA;

CREATE VIEW CA AS
SELECT      EXTRACT( YEAR FROM dteVente) as "annee", SUM(prixvente * quantite) as "chA"
FROM        Concerner NATURAL JOIN Vente
GROUP BY    EXTRACT( YEAR FROM dteVente)
ORDER BY    EXTRACT( YEAR FROM dteVente);