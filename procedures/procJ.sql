--On souhaite classer tous les clients par leur quantité totale d'achats de BD. Ainsi
--on veut associer à chaque client son rang de classement en tant qu'acheteur dans
--l'ordre décroissant des quantités achetées. Ainsi le client de rang 1 (classé
--premier) aura totalisé le plus grand nombre d'achats.
--Vous devez donc créer un nouveau type de données ‘rangClient’, qui associe
--l'identifiant du client, son nom et son classement dans les acheteurs (attribut
--nommé ‘rang’).
--Ecrire une fonction qui renvoie pour tous les clients, son identifiant, son nom et
--son classement d'acheteur décrit ci-dessus.
--NB : on pourra avantageusement utiliser une boucle FOR ou un curseur... 

DROP TYPE IF EXISTS rangClient CASCADE;
CREATE TYPE rangClient AS (
    idClient NUMERIC,
    nomClient VARCHAR,
    rang NUMERIC
);

DROP FUNCTION IF EXISTS procJBis CASCADE;
CREATE OR REPLACE FUNCTION procJBis() 
RETURNS SETOF rangClient AS
$$
DECLARE
    retType rangClient;
    ordre RECORD;
    cptRang INTEGER := 1;
BEGIN
    FOR ordre IN SELECT Client.numClient, SUM(Concerner.quantite) AS somme FROM Client NATURAL JOIN Vente NATURAL JOIN Concerner GROUP BY Client.numClient ORDER BY somme DESC
    LOOP
        SELECT ordre.numClient  INTO retType.idClient;
        SELECT Client.nomClient INTO retType.nomClient FROM Client WHERE Client.numClient = ordre.numClient;
        SELECT cptRang INTO retType.rang;
        cptRang = cptRang + 1;
        RETURN NEXT retType;
    END LOOP;
END
$$
LANGUAGE Plpgsql;

SELECT * FROM procJBis();

/*
\i procJ.sql

 idclient |  nomclient  | rang 
----------+-------------+------
        4 | Poret       |    1
        6 | Timable     |    2
        8 | Ohm         |    3
        7 | Don Devello |    4
        9 | Ginal       |    5
        3 | Hauraque    |    6
        5 | Menvussa    |    7
       10 | Hautine     |    8
        2 | Fissile     |    9
        1 | Torguesse   |   10
       11 | Kament      |   11
(11 lignes)
*/