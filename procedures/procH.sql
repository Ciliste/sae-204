-- Ecrire une fonction qui renvoie pour tous les clients sa plus petite quantité
-- achetée (min) et sa plus grande quantité achetée (max) et la somme totale de ses
-- quantités achetées de BD.
-- Vous devrez donc créer un type composite ‘clientBD’ comportant quatre
-- attributs: l'identifiant du client, son nom, sa plus petite quantité achetée, sa plus
-- grande quantité achetée, et la somme totale de ses quantités achetées. Votre
-- procédure devra retourner des éléments de ce type de données.
-- On rajoutera le comportement suivant : si le minimum est égal au maximum pour
-- un client, on affichera le message 'Egalité du minimum et maximum pour le
-- client %' en précisant le nom du client.
-- NB : utiliser une boucle FOR ou un curseur...

DROP TYPE IF EXISTS clientBD CASCADE;
CREATE TYPE clientBD AS (
    idClient NUMERIC,
    nomClient VARCHAR,
    minimum NUMERIC,
    maximum NUMERIC,
    somme NUMERIC
);

CREATE OR REPLACE FUNCTION procH() 
RETURNS SETOF clientBD AS
$$
DECLARE
    retType clientBD;
    cli Client%ROWTYPE;
BEGIN
    FOR cli IN SELECT * FROM Client
    LOOP
        SELECT cli.numClient, cli.nomClient INTO retType.idClient, retType.nomClient; 
        SELECT MIN(achats.somme) INTO retType.minimum FROM (SELECT Vente.numVente, SUM(Concerner.quantite) AS somme FROM Client NATURAL JOIN Vente NATURAL JOIN Concerner GROUP BY Vente.numVente, Client.numClient HAVING Client.numClient = cli.numClient) AS achats;
        SELECT MAX(achats.somme) INTO retType.maximum FROM (SELECT Vente.numVente, SUM(Concerner.quantite) AS somme FROM Client NATURAL JOIN Vente NATURAL JOIN Concerner GROUP BY Vente.numVente, Client.numClient HAVING Client.numClient = cli.numClient) AS achats;
        SELECT SUM(achats.somme) INTO retType.somme   FROM (SELECT Vente.numVente, SUM(Concerner.quantite) AS somme FROM Client NATURAL JOIN Vente NATURAL JOIN Concerner GROUP BY Vente.numVente, Client.numClient HAVING Client.numClient = cli.numClient) AS achats;

        RETURN NEXT retType;
    END LOOP;
END
$$
LANGUAGE Plpgsql;

SELECT * FROM procH();

/*
\i procH.sql

 idclient |  nomclient  | minimum | maximum | somme 
----------+-------------+---------+---------+-------
        1 | Torguesse   |     225 |     938 |  2645
        2 | Fissile     |      35 |     924 |  3651
        3 | Hauraque    |      32 |     742 |  4307
        4 | Poret       |      72 |     784 |  8816
        5 | Menvussa    |     135 |     976 |  4093
        6 | Timable     |      34 |    1345 |  6639
        7 | Don Devello |     253 |     796 |  5664
        8 | Ohm         |     274 |    1346 |  6159
        9 | Ginal       |     447 |     857 |  4564
       10 | Hautine     |     137 |     976 |  3865
       11 | Kament      |     346 |     576 |  1691
(11 lignes)
*/