-- Ecrire une procédure qui prend en paramètre un numéro d’auteur dessinateur et
-- qui renvoie pour chaque titre de BD de l’auteur, le nombre d’exemplaires vendus
-- de cette BD.

DROP TYPE IF EXISTS typeProcA CASCADE;
CREATE TYPE typeProcA AS (
    titre VARCHAR,
    nbVendue NUMERIC
);

DROP FUNCTION IF EXISTS procA CASCADE;
CREATE OR REPLACE FUNCTION procA(idAuteur Auteur.numAuteur%TYPE) 
RETURNS SETOF typeProcA AS
$$
DECLARE
    ligne RECORD;
    retType typeProcA;
BEGIN
    PERFORM * FROM Auteur WHERE Auteur.numAuteur = idAuteur;
    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'Aucun Auteur n est enregistré avec ce numéro...';
    END IF;

    FOR ligne IN SELECT BD.titre AS titre, Auteur.numAuteur, SUM(Concerner.quantite) AS quantite FROM Auteur JOIN BD ON Auteur.numAuteur = BD.numAuteurScenariste OR Auteur.numAuteur = BD.numAuteurDessinateur NATURAL JOIN Concerner GROUP BY BD.titre, Auteur.numAuteur HAVING Auteur.numAuteur = idAuteur
    LOOP
        SELECT ligne.titre, ligne.quantite INTO retType;
        RETURN NEXT retType;
    END LOOP;
END
$$
LANGUAGE Plpgsql;

SELECT * FROM procA(1);

/*
\i procA.sql

                titre                | nbvendue 
-------------------------------------+----------
 La malediction des trente deniers 2 |      495
 L onde Septimus                     |      537
(2 lignes)
*/