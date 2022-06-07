/* g) Écrire une procédure SQL utilisant un curseur, qui classe pour un éditeur dont le
nom est donné en entrée, les clients de cet éditeur en trois catégories selon le
nombre de BD qu’ils leur ont achetées : les « très bons clients » (plus de 10
achats strictement), les « bons clients » (entre 2 et 10 BD), les « mauvais
clients » (moins ou égal à 2 BD) */

DROP TYPE IF EXISTS CLIENT_CATEG CASCADE;
CREATE TYPE CLIENT_CATEG AS ( nomClient varchar(20), categ varchar(18) );



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



CREATE OR REPLACE FUNCTION getCategClients( un_editeur Editeur.nomEditeur%TYPE )
    RETURNS SETOF CLIENT_CATEG 
    AS $$

DECLARE

    curs         CURSOR FOR SELECT numClient FROM Client;
    une_categ    CLIENT_CATEG;
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
