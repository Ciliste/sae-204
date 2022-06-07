--Créer une procédure qui prend en paramètre un nombre nbBD de BD et une
--année donnée, et qui renvoie la liste des éditeurs ayant vendu au moins ce
--nombre de BD dans l’année en question. Si aucun éditeur ne répond à la requête,
--le signaler par un messa  

DROP FUNCTION IF EXISTS procE CASCADE;
CREATE OR REPLACE FUNCTION procE ( nbBD Editeur.numEditeur%TYPE, annee integer)
    RETURNS setof Editeur
    AS $$

DECLARE

    edi Editeur%RAWTYPE;

BEGIN
    
    FOR edi IN
            SELECT  Editeur.*  
            FROM    Editeur NATURAL JOIN Vente
            WHERE   annee = EXTRACT( YEAR FROM Vente.dteVente) AND (SELECT     
                                                                    FROM        
                                                                    WHERE    )
    LOOP
        RETURN NEXT edi;
    END LOOP;

    IF ( NOT FOUND ) THEN
        RAISE EXCEPTION 'aucun éditeur avec ce nombre de BD vendu cette année là';
    END IF;
END
$$ language plpgsql;
