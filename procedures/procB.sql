--Écrire une fonction qui prend en paramètre le nom d’une série de BD et qui
--renvoie pour chaque titre de la série le nombre d’exemplaires vendus et le chiffre
--d’affaire réalisé par titre.

DROP TYPE     IF EXISTS typeProcB CASCADE;
DROP FUNCTION IF EXISTS procB    CASCADE;

CREATE TYPE typeProcB AS ( titre_serie     text,
                           quantite_vendue bigint,
                           CA              double precision );

CREATE OR REPLACE FUNCTION procB  ( nomS Serie.nomSerie%TYPE )
    RETURNS setof typeProcB
    AS $$

BEGIN

    RETURN QUERY SELECT
        BD.titre,
        SUM  ( Concerner.quantite ),
        SUM  ( Concerner.quantite * Concerner.prixVente)
    FROM
        BD 
            NATURAL JOIN
        Concerner
    WHERE
        BD.numSerie = ( SELECT
                            Serie.numSerie
                        FROM
                            Serie
                        WHERE
                            Serie.nomSerie = nomS 
                      )
    GROUP BY
        BD.titre;
    
    
    IF ( NOT FOUND ) THEN
        RAISE EXCEPTION 'Aucune série ne correspond au numéro donné';
    END IF;

END
$$ language plpgsql;

select procB('Peter Pan');

/*
\i procB.sql

          proc_b           
---------------------------
 ("Mains rouges",456,6384)
 (Opikanoba,1345,18830)
 (Crochet,780,10920)
 (Londres,245,3430)
 (Tempête,745,10430)
 (Destins,406,5684)
*/

