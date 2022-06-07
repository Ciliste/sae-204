-- Écrire une procédure qui prend en paramètre un nom d’éditeur et un nom
-- d’auteur dessinateur et un nom d’auteur scénariste, et qui renvoie la liste des BD
-- de ces auteurs éditées par l’éditeur choisi. Si l’éditeur n’a pas édité de BD de ces
-- auteurs, ou qu’il n’existe pas de BD de ces deux auteurs, on devra générer le
-- message suivant « l’éditeur % n’a pas édité de BD des auteurs % et %» où on
-- remplacera les « % » par les noms correspondants.

DROP FUNCTION IF EXISTS procC CASCADE;
CREATE OR REPLACE FUNCTION procC(
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

SELECT * FROM procC('Dargaud', 'Uderzo', 'Goscinny');

/*
\i procC.sql

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