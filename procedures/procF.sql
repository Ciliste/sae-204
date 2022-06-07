--Écrire une procédure qui prend en paramètre une année donnée, et un nom
--d’éditeur et qui renvoie le(s) tuple(s) comportant l’année et le nom de l’éditeur
--d’une part, associé au nom et email du(des) client(s) d’autre part ayant acheté le
--plus de BD cette année-là chez cet éditeur. 

DROP TYPE IF EXISTS typeProcF AS ( annee   varchar(4),
                                   editeur varchar(23),
                                   nom     varchar(11),
                                   email   text        );


CREATE OR REPLACE FUNCTION proc_f ( annee varchar(4), nomEdit Editeur.nomEditeur%TYPE )
    RETURNS setof typeProcF
    AS $$

DECLARE 

    clientMax Client%ROWTYPE;

BEGIN

    SELECT   Client.* INTO clientMax
    FROM     Client NATURAL JOIN Vente
                    NATURAL JOIN Concerner 
                    NATURAL JOIN BD 
    WHERE    