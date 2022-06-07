--Écrire une procédure qui prend en paramètre une année donnée, et un nom
--d’éditeur et qui renvoie le(s) tuple(s) comportant l’année et le nom de l’éditeur
--d’une part, associé au nom et email du(des) client(s) d’autre part ayant acheté le
--plus de BD cette année-là chez cet éditeur. 
DROP TYPE IF EXISTS typeProcF  CASCADE;
DROP FUNCTION IF EXISTS procF CASCADE;


CREATE TYPE typeProcF AS (         annee   varchar(4),
                                   editeur varchar(23),
                                   nom     varchar(11),
                                   email   text        );


CREATE OR REPLACE FUNCTION procF ( anneeAchat integer, nomEdit Editeur.nomEditeur%TYPE )
    RETURNS setof typeProcF
    AS $$

DECLARE 
    
    sRet     typeProcF%ROWTYPE;

    bds       BD%ROWTYPE;
    series    Serie %ROWTYPE;
    client    Client%ROWTYPE;
    clientMax Client%ROWTYPE;
    editeur   Editeur%ROWTYPE;

    qa        Concerner.quantite%TYPE;
    somQa     Concerner.quantite%TYPE;
    maxQa     Concerner.quantite%TYPE;

    
BEGIN

    SELECT * INTO editeur FROM Editeur WHERE nomEditeur = nomEdit;

    IF ( NOT FOUND ) THEN
        RAISE EXCEPTION 'Cet éditeur ne se trouve pas dans la BADO';
    END IF;

    maxQa = 0;
    somQa = 0;
    FOR client IN
        SELECT * FROM Client
    LOOP

        FOR series IN
            SELECT * FROM Serie WHERE Serie.numEditeur = editeur.numEditeur
        LOOP

            FOR bds IN
                SELECT  * FROM BD WHERE BD.numSerie = series.numSerie
            LOOP

                SELECT Concerner.quantite
                INTO   qa
                FROM   Concerner NATURAL JOIN Vente
                WHERE  Concerner.isbn                       = bds.isbn         and
                       Vente.numClient                      = client.numClient and
                       EXTRACT ( YEAR FROM Vente.dteVente ) = anneeAchat ;

                IF ( FOUND ) THEN
                    somQa = somQa + qa;
                END IF;


            END LOOP;

        END LOOP;

        IF (somQa > maxQa) THEN
            clientMax = client;
            maxQa     = somQa;
        END IF;

    END LOOP;  

    sRet.annee   = anneeAchat;
    sRet.editeur = nomEdit;
    sRet.nom     = clientMax.nomClient;
    sRet.email   = clientMax.mailClient;

    IF ( clientMax is null ) THEN
        RAISE EXCEPTION 'Aucun client on acheté chez % en %', nomEdit, anneeAchat;
    END IF;

    RETURN NEXT sRet;

END
$$ language plpgsql;

SELECT procF(2018,'Lombard');

/*
\i procF.sql

              procf               
----------------------------------
 (2018,Lombard,Ohm,mail@odie.net)
*/
