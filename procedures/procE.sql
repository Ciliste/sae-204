--Créer une procédure qui prend en paramètre un nombre nbBD de BD et une
--année donnée, et qui renvoie la liste des éditeurs ayant vendu au moins ce
--nombre de BD dans l’année en question. Si aucun éditeur ne répond à la requête,
--le signaler par un messa  

DROP FUNCTION IF EXISTS procE CASCADE;
CREATE OR REPLACE FUNCTION procE ( nbBD Editeur.numEditeur%TYPE, annee Vente.dteVente%TYPE)
    RETURNS setof Editeur
    AS $$

DECLARE

    editeur 

BEGIN



    FOR editeur IN
            SELECT *
            FROM   Editeur
    LOOP

        
        

    END LOOP;

    IF ( NOT FOUND ) THEN
        RAISE EXCEPTION 'aucun éditeur avec ce nombre de BD vendu cette année là';
    END IF;

    aAchete = false;

    FOR clients IN
            SELECT *
            FROM   Client
    LOOP
        FOR bds IN
            SELECT  *
            FROM    BD
            WHERE   BD.numSerie = serie
        LOOP
            PERFORM Vente.numVente
            FROM    Vente NATURAL JOIN Concerner
            WHERE   isbn = bds.isbn and
                    Vente.numClient = clients.numClient;

            IF ( NOT FOUND ) THEN
                aAchete = false;
            END IF;
            
        END LOOP;

        IF ( aAchete ) THEN
            RETURN NEXT clients;
        END IF;

        aAchete = true;

    END LOOP;
        
END
$$ language plpgsql;
