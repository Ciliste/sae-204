-- CAS          : SAE 204
-- Programmeur  : LE MEUR Pierre; AIREY Théo, KERMAREC Gaetan, GASCOPIN Romain
-- Groupe       : A
-- Date         : 07/06/2022
-- Objectif     : À partir d’un cahier des charges, l’étudiant devra réaliser et étudier une base de données
--                relationnelle. L’étudiant devra aborder les aspects de conception, implémentation,
--                administration, exploitation d’une base de données relationnelle et visualiser les résultats de
--                son analyse
---------------------------------------------------------------------------------------------------------------------------------------------------------------

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

    FOR ligne IN SELECT BD.titre AS titre, Auteur.numAuteur, SUM(Concerner.quantite) AS quantite 
                 FROM Auteur JOIN BD ON Auteur.numAuteur = BD.numAuteurScenariste
                                     OR Auteur.numAuteur = BD.numAuteurDessinateur 
                             NATURAL JOIN Concerner 
                 GROUP BY BD.titre, Auteur.numAuteur
                 HAVING Auteur.numAuteur = idAuteur
    LOOP
        SELECT ligne.titre, ligne.quantite INTO retType;
        RETURN NEXT retType;
    END LOOP;
END
$$
LANGUAGE Plpgsql;

/*
=> \i procA.sql
=> SELECT * FROM procA(1);

                titre                | nbvendue 
-------------------------------------+----------
 La malediction des trente deniers 2 |      495
 L onde Septimus                     |      537
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Écrire une fonction qui prend en paramètre le nom d’une série de BD et qui
-- renvoie pour chaque titre de la série le nombre d’exemplaires vendus et le chiffre
-- d’affaire réalisé par titre.

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

/*
=> \i procB.sql
=> SELECT procB('Peter Pan');

          proc_b           
---------------------------
 ("Mains rouges",456,6384)
 (Opikanoba,1345,18830)
 (Crochet,780,10920)
 (Londres,245,3430)
 (Tempête,745,10430)
 (Destins,406,5684)
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Écrire une procédure qui prend en paramètre un nom d’éditeur et un nom
-- d’auteur dessinateur et un nom d’auteur scénariste, et qui renvoie la liste des BD
-- de ces auteurs éditées par l’éditeur choisi. Si l’éditeur n’a pas édité de BD de ces
-- auteurs, ou qu’il n’existe pas de BD de ces deux auteurs, on devra générer le
-- message suivant « l’éditeur % n’a pas édité de BD des auteurs % et %» où on
-- remplacera les « % » par les noms correspondants.

DROP FUNCTION IF EXISTS procC CASCADE;


CREATE OR REPLACE FUNCTION procB(
    nomEdit Editeur.nomEditeur%TYPE, 
    nomAuteurDessinateur Auteur.nomAuteur%TYPE,
    nomAuteurScenariste  Auteur.nomAuteur%TYPE)
RETURNS SETOF BD AS
$$
BEGIN
    PERFORM 
        *
    FROM
        BD
    WHERE BD.isbn IN (
        SELECT 
            BD.isbn 
        FROM 
            BD 
            NATURAL JOIN 
            Serie 
            NATURAL JOIN
            Editeur
        WHERE 
            Editeur.nomEditeur = nomEdit
            AND
            BD.numAuteurDessinateur = (
                SELECT 
                    numAuteur
                FROM 
                    Auteur
                WHERE 
                    nomAuteur = nomAuteurDessinateur
            )
            AND
            BD.numAuteurScenariste = (
                SELECT 
                    numAuteur
                FROM 
                    Auteur
                WHERE 
                    nomAuteur = nomAuteurScenariste
            )
    );
    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'L éditeur % n a pas édité de BD des auteurs % et %', nomEdit, nomAuteurScenariste, nomAuteurDessinateur;
    END IF;
    
    RETURN QUERY (
        SELECT 
            *
        FROM
            BD
        WHERE BD.isbn IN (
            SELECT 
                BD.isbn 
            FROM 
                BD 
                NATURAL JOIN 
                Serie 
                NATURAL JOIN
                Editeur
            WHERE 
                Editeur.nomEditeur = nomEdit
                AND
                BD.numAuteurDessinateur = (
                    SELECT 
                        numAuteur
                    FROM 
                        Auteur
                    WHERE 
                        nomAuteur = nomAuteurDessinateur
                )
                AND
                BD.numAuteurScenariste = (
                    SELECT 
                        numAuteur
                    FROM 
                        Auteur
                    WHERE 
                        nomAuteur = nomAuteurScenariste
                )
        )
    );
END
$$
LANGUAGE Plpgsql;

/*
=> \i procC.sql
=> SELECT * FROM procC('Dargaud', 'Uderzo', 'Goscinny');

       isbn        |                       titre                       | prixactuel | numtome | numserie | numauteurdessinateur | numauteurscenariste 
-------------------+---------------------------------------------------+------------+---------+----------+----------------------+---------------------
 978-2-2050-0096-2 | Astérix le gaulois                                |         12 |       1 |        2 |                   31 |                  14
 978-2-0121-0134-0 | La serpe d or                                     |         12 |       2 |        2 |                   31 |                  14
 978-2-0121-0135-7 | Astérix et les Goths                              |         12 |       3 |        2 |                   31 |                  14
 978-2-0121-0136-4 | Astérix Gladiateur                                |         12 |       4 |        2 |                   31 |                  14
 978-2-0121-0137-1 | Le tour de Gaule d Astérix                        |         12 |       5 |        2 |                   31 |                  14
 978-2-0121-0138-8 | Astérix et Cléopâtre                              |         12 |       6 |        2 |                   31 |                  14
 978-2-0121-0139-5 | Le combat des chefs                               |         12 |       7 |        2 |                   31 |                  14
 978-2-0121-0140-1 | Astérix chez les Bretons                          |         12 |       8 |        2 |                   31 |                  14
 978-2-0121-0141-8 | Astérix et les Normands                           |         12 |       9 |        2 |                   31 |                  14
 978-2-0121-0142-5 | Astérix Légionnaire                               |         12 |      10 |        2 |                   31 |                  14
 978-2-0121-0143-2 | Le bouclier Arverne                               |         12 |      11 |        2 |                   31 |                  14
 978-2-0121-0144-9 | Astérix aux jeux Olympiques                       |         12 |      12 |        2 |                   31 |                  14
 978-2-0121-0145-6 | Astérix et le chaudron                            |         12 |      13 |        2 |                   31 |                  14
 978-2-0121-0146-3 | Astérix en Hispanie                               |         12 |      14 |        2 |                   31 |                  14
 978-2-0121-0147-0 | La zizanie                                        |         12 |      15 |        2 |                   31 |                  14
 978-2-0121-0148-7 | Astérix chez les Helvètes                         |         12 |      16 |        2 |                   31 |                  14
 978-2-0121-0149-4 | Le domaine des dieux                              |         12 |      17 |        2 |                   31 |                  14
 978-2-0121-0150-0 | Les lauriers de César                             |         12 |      18 |        2 |                   31 |                  14
 978-2-0121-0151-7 | Le devin                                          |         12 |      19 |        2 |                   31 |                  14
 978-2-0121-0152-4 | Astérix en Corse                                  |         12 |      20 |        2 |                   31 |                  14
 978-2-0121-0153-1 | Le cadeau de César                                |         12 |      21 |        2 |                   31 |                  14
 978-2-0121-0154-8 | La grande traversée                               |         12 |      22 |        2 |                   31 |                  14
 978-2-0121-0155-5 | Obélix et compagnie                               |         12 |      23 |        2 |                   31 |                  14
 978-2-0121-0156-2 | Astérix chez les Belges                           |         12 |      24 |        2 |                   31 |                  14
 978-2-8649-7153-5 | Astérix et la rentrée gauloise                    |         12 |      32 |        2 |                   31 |                  14
 978-2-8649-7230-3 | L Anniversaire d Astérix & Obélix - Le livre d Or |         12 |      34 |        2 |                   31 |                  14
(26 lignes)
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Créer une procédure stockée qui prend en paramètre le nom d’une série de BD et
-- qui renvoie les clients ayants acheté tous les albums de la série (utiliser des
-- boucles FOR et/ou des curseurs).
-- Si aucun client ne répond à la requête alors on affichera un message
-- d’avertissement ‘Aucun client n’a acheté tous les exemplaires de la série %’, en
-- complétant le ‘ %’ par le nom de la série.

CREATE OR REPLACE FUNCTION procD ( nomS Serie.nomSerie%TYPE )
    RETURNS setof Client
    AS $$

DECLARE

    clients Client%ROWTYPE;
    bds     BD%ROWTYPE;
    serie   BD.numSerie%TYPE;

    aAchete  boolean;
    unclient boolean;

BEGIN

    SELECT Serie.numSerie INTO serie
    FROM   Serie
    WHERE  Serie.nomSerie = nomS; 

    IF ( NOT FOUND ) THEN
        RAISE EXCEPTION 'aucune serie avec le nom % existe', nomS;
    END IF;

    aAchete = false;
    unclient= false;

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
            unclient = true;
        END IF;

        aAchete = true;

    END LOOP;

    IF ( unclient ) THEN
        RAISE NOTICE 'Aucun client n’a acheté tous les exemplaires de la série %', nomS;
    END IF;

        
END
$$ language plpgsql;

SELECT procD('Peter Pan');

/* 
\i procD.sql

                    procd                     
----------------------------------------------
 (6,Timable,"06 56 53 01 40",mail@limelo.com)
 */
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Créer une fonction qui prend en paramètre un nombre nbBD de BD et une année
-- donnée, et qui renvoie la liste des éditeurs ayant vendu au moins ce nombre de
-- BD dans l’année en question. Si aucun éditeur ne répond à la requête, le signaler
-- par un message approprié.

DROP FUNCTION IF EXISTS procE() CASCADE;


CREATE OR REPLACE FUNCTION procE(nbBD Concerner.quantite%TYPE, annee VARCHAR)
RETURNS SETOF Editeur AS
$$
DECLARE
    edit Editeur%ROWTYPE;
    nbVente Concerner.quantite%TYPE;
    auMoinsUnEditeur BOOLEAN := false;
BEGIN
    FOR edit IN SELECT * FROM Editeur
    LOOP
        SELECT 
            SUM(Concerner.quantite) 
        INTO 
            nbVente 
        FROM 
            Editeur 
            NATURAL JOIN 
            Serie 
            NATURAL JOIN 
            BD 
            NATURAL JOIN 
            Concerner 
            NATURAL JOIN
            Vente
        WHERE 
            Editeur.numEditeur = edit.numEditeur 
            AND 
            CAST(EXTRACT(YEAR FROM Vente.dteVente) AS VARCHAR) = annee;
        IF (nbVente >= nbBD) THEN
            auMoinsUnEditeur = true;
            RETURN NEXT edit;
        END IF;
    END LOOP;

    IF (NOT auMoinsUnEditeur) THEN
        RAISE NOTICE 'Aucun éditeur ne répond à ces critères...';
    END IF;
END
$$
LANGUAGE Plpgsql;

/*
=> \i procE.sql
=> SELECT * FROM procE(10, '2005');

 numediteur |   nomediteur   |                     adresseediteur                      | numtelediteur  |     mailediteur      
------------+----------------+---------------------------------------------------------+----------------+----------------------
          2 | Dargaud        | 57    rue Gaston Tessier,       75019  Paris            | 01 53 26 32 32 | contact@dargaud.fr
          6 | Bamboo Edition | 290   route des Allognerais     71850 Charnay-les-Mâcon | 03 85 34 99 09 | c.loiselet@bamboo.fr
          9 | Tonkan         |                                                         |                | 
(3 lignes)
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Écrire une procédure qui prend en paramètre une année donnée, et un nom
-- d’éditeur et qui renvoie le(s) tuple(s) comportant l’année et le nom de l’éditeur
-- d’une part, associé au nom et email du(des) client(s) d’autre part ayant acheté le
-- plus de BD cette année-là chez cet éditeur.

DROP TYPE IF EXISTS typeProcF  CASCADE;
DROP FUNCTION IF EXISTS proc_f CASCADE; 


CREATE TYPE typeProcF AS (         annee   varchar(4),
                                   editeur varchar(23),
                                   nom     varchar(11),
                                   email   text        );


CREATE OR REPLACE FUNCTION proc_f ( anneeAchat integer, nomEdit Editeur.nomEditeur%TYPE )
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

/*
=> \i procF.sql
=> SELECT procF(2018, 'Lombard');

              procf               
----------------------------------
 (2018,Lombard,Ohm,mail@odie.net)
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Écrire une procédure SQL utilisant un curseur, qui classe pour un éditeur dont le
-- nom est donné en entrée, les clients de cet éditeur en trois catégories selon le
-- nombre de BD qu’ils leur ont achetées : les « très bons clients » (plus de 10
-- achats strictement), les « bons clients » (entre 2 et 10 BD), les « mauvais
-- clients » (moins ou égal à 2 BD)

DROP TYPE IF EXISTS categClient CASCADE;
CREATE TYPE categClient AS ( nomClient varchar(20), categ varchar(18) );



CREATE OR REPLACE FUNCTION getNbAchatsClients( un_numClient Client.numClient%TYPE, un_nomEditeur Editeur.nomEditeur%TYPE )
    RETURNS numeric 
    AS $$

DECLARE
    nb_achats numeric;
BEGIN
    SELECT   SUM(cn.quantite) INTO nb_achats
    FROM     Editeur e JOIN Serie     s  ON e.numEditeur = s .numEditeur
                       JOIN BD        b  ON b.numSerie   = s .numSerie
                       JOIN Concerner cn ON b.isbn       = cn.isbn
                       JOIN Vente     v  ON v.numVente   = cn.numVente
                       JOIN Client    cl ON v.numClient  = cl.numClient
    WHERE    v.numClient = un_numClient AND
             nomEditeur  = un_nomEditeur
    GROUP BY v.numClient, e.nomEditeur;

    RETURN   nb_achats;

END;
$$ language plpgsql;



CREATE OR REPLACE FUNCTION procG( un_editeur Editeur.nomEditeur%TYPE )
    RETURNS SETOF categClient 
    AS $$

DECLARE

    curs         CURSOR FOR SELECT numClient FROM Client;
    une_categ    categClient;
    un_nb_dachat numeric;
    un_numClient Client.numClient%TYPE;

BEGIN
    OPEN curs;
    LOOP
        FETCH curs INTO un_numClient;
        EXIT WHEN NOT FOUND;

        SELECT nomClient INTO une_categ.nomClient
        FROM   Client
        WHERE  numClient = un_numClient;

        SELECT * INTO un_nb_dachat
        FROM   getNbAchatsClients(un_numClient, un_editeur);


        IF (un_nb_dachat <= 2 or un_nb_dachat is null) THEN
            une_categ.categ = 'mauvais client';
        ELSIF (un_nb_dachat <= 10) THEN
            une_categ.categ = 'bon client';
        ELSE
            une_categ.categ = 'tres bon client';
        END IF;

        RETURN NEXT une_categ;        
    END LOOP;
    CLOSE curs;
    RETURN;
END
$$ language plpgsql;

select * from procG('Delcourt');

/*
=> \i procG.sql
=> select * from procG('Delcourt');

  nomclient  |      categ      
-------------+-----------------
 Torguesse   | tres bon client
 Fissile     | tres bon client
 Hauraque    | mauvais client
 Poret       | mauvais client
 Menvussa    | tres bon client
 Timable     | tres bon client
 Don Devello | mauvais client
 Ohm         | mauvais client
 Ginal       | mauvais client
 Hautine     | mauvais client
 Kament      | mauvais client */


---------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Ecrire une fonction qui supprime une vente dont l'identifiant est passé en
-- paramètre.
-- Vérifier d'abord que la vente associée à l'identifiant existe, si elle n'existe pas
-- afficher un message d'erreur le mentionnant; si elle existe on la supprime.
-- Cette suppression va générer une violation de clé étrangère dans la table
-- ‘Concerner’.
-- Pour gérer cela, on utilisera le code d'erreur FOREIGN_KEY_VIOLATION
-- dans un bloc EXCEPTION dans lequel on supprimera tous les tuples de la table
-- ‘Concerner’ qui possèdent ce numéro de vente, avant de supprimer la venet ellemême. On pourra au passage afficher aussi un message d'avertissement sur cette
-- exception.

DROP FUNCTION IF EXISTS procI CASCADE;


CREATE OR REPLACE FUNCTION procI(idVente Vente.numVente%TYPE)
RETURNS VOID AS
$$
BEGIN
    PERFORM * FROM Vente WHERE Vente.numVente = idVente;
    IF (NOT FOUND) THEN
        RAISE EXCEPTION 'La vente n existe pas...';
    END IF;
    DELETE FROM Vente WHERE Vente.numVente = idVente;
EXCEPTION
    WHEN FOREIGN_KEY_VIOLATION
    THEN
        DELETE FROM Concerner WHERE Concerner.numVente = idVente;
        DELETE FROM Vente     WHERE Vente.numVente     = idVente;
END
$$
LANGUAGE Plpgsql;

/*
=> \i procI.sql
=> SELECT procI(1);

 proci 
-------
 
(1 ligne)
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------

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