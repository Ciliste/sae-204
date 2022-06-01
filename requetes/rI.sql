DROP VIEW     bdEditeur;

CREATE VIEW   bdEditeur AS
SELECT        EXTRACT( YEAR FROM Vente.dteVente) as "annee", Editeur.nomEditeur, titre
FROM          Editeur NATURAL JOIN Serie NATURAL JOIN Bd NATURAL JOIN Concerner NATURAL JOIN Vente
GROUP BY      EXTRACT( YEAR FROM dteVente), nomEditeur, titre
ORDER BY      EXTRACT( YEAR FROM dteVente), nomEditeur;  