--Créer une procédure stockée qui prend en paramètre le nom d’une série de BD et
--qui renvoie les clients ayants acheté tous les albums de la série (utiliser des
--boucles FOR et/ou des curseurs).
--Si aucun client ne répond à la requête alors on affichera un message
--d’avertissement ‘Aucun client n’a acheté tous les exemplaires de la série %’, en
--complétant le ‘ %’ par le nom de la série.

CREATE OR REPLACE FUNCTION procD ( nomS Serie.nomSerie%TYPE )
    RETURNS setof Client
    AS $$

DECLARE

    clients Client%ROWTYPE;
    bds     BD%ROWTYPE;
    serie   BD.numSerie%TYPE;
    aAchete boolean;

BEGIN

    SELECT Serie.numSerie INTO serie
    FROM   Serie
    WHERE  Serie.nomSerie = nomS; 

    IF ( NOT FOUND ) THEN
        RAISE EXCEPTION 'aucune serie avec le nom % existe', nomS;
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

SELECT procD('Peter Pan');

/* 
\i procD.sql

                    procd                     
----------------------------------------------
 (6,Timable,"06 56 53 01 40",mail@limelo.com)
 */

