--Écrire une fonction qui prend en paramètre le nom d’une série de BD et qui
--renvoie pour chaque titre de la série le nombre d’exemplaires vendus et le chiffre
--d’affaire réalisé par titre.

DROP TYPE     IF EXISTS typeProcB CASCADE;
DROP FUNCTION IF EXISTS proc_b    CASCADE;

CREATE TYPE typeProcB AS ( titre_serie     text,
                           quantite_vendue bigint,
                           CA              double precision );

CREATE OR REPLACE FUNCTION proc_b  ( nomS Serie.nomSerie%TYPE )
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



