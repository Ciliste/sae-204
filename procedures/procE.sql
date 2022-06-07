-- Créer une fonction qui prend en paramètre un nombre nbBD de BD et une année
-- donnée, et qui renvoie la liste des éditeurs ayant vendu au moins ce nombre de
-- BD dans l’année en question. Si aucun éditeur ne répond à la requête, le signaler
-- par un message approprié. 

DROP FUNCTION IF EXISTS procE() CASCADE;
CREATE OR REPLACE FUNCTION procE(nbBD Concerner.quantite%TYPE, annee VARCHAR)
RETURNS SETOF Editeur AS
$$
DECLARE
    edit Editeur%ROWTYPE;
    nbVente Concerner.quantite%TYPE;
    auMoinsUnEditeur BOOLEAN := false;
BEGIN
    FOR edit IN SELECT * FROM Editeur
    LOOP
        SELECT 
            SUM(Concerner.quantite) 
        INTO 
            nbVente 
        FROM 
            Editeur 
            NATURAL JOIN 
            Serie 
            NATURAL JOIN 
            BD 
            NATURAL JOIN 
            Concerner 
            NATURAL JOIN
            Vente
        WHERE 
            Editeur.numEditeur = edit.numEditeur 
            AND 
            CAST(EXTRACT(YEAR FROM Vente.dteVente) AS VARCHAR) = annee;
        IF (nbVente >= nbBD) THEN
            auMoinsUnEditeur = true;
            RETURN NEXT edit;
        END IF;
    END LOOP;

    IF (NOT auMoinsUnEditeur) THEN
        RAISE NOTICE 'Aucun éditeur ne répond à ces critères...';
    END IF;
END
$$
LANGUAGE Plpgsql;

SELECT * FROM procE(10, '2005');

/*
\i procE.sql

 numediteur |   nomediteur   |                     adresseediteur                      | numtelediteur  |     mailediteur      
------------+----------------+---------------------------------------------------------+----------------+----------------------
          2 | Dargaud        | 57    rue Gaston Tessier,       75019  Paris            | 01 53 26 32 32 | contact@dargaud.fr
          6 | Bamboo Edition | 290   route des Allognerais     71850 Charnay-les-Mâcon | 03 85 34 99 09 | c.loiselet@bamboo.fr
          9 | Tonkan         |                                                         |                | 
(3 lignes)
*/