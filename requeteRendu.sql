-- CAS          : SAE 204
-- Programmeur  : LE MEUR Pierre; AIREY Théo, KERMAREC Gaetan, GASCOPIN Romain
-- Groupe       : A
-- Date         : 01/06/2022
-- Objectif     : À partir d’un cahier des charges, l’étudiant devra réaliser et étudier une base de données
--                relationnelle. L’étudiant devra aborder les aspects de conception, implémentation,
--                administration, exploitation d’une base de données relationnelle et visualiser les résultats de
--                son analyse
---------------------------------------------------------------------------------------------------------------------------------------------------------------

--Lister les clients (numéro et nom) triés par ordre alphabétique du nom

SELECT numClient AS "Numéro", nomClient AS "Nom"
FROM Client
ORDER BY nomClient;

 Numéro |     Nom     
--------+-------------
      7 | Don Devello
      2 | Fissile
      9 | Ginal
      3 | Hauraque
     10 | Hautine
     11 | Kament
      5 | Menvussa
      8 | Ohm
      4 | Poret
      6 | Timable
      1 | Torguesse

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- b) Lister les clients (numéro, nom) et leur nombre d’achats (que l’on nommera
--nbA) triés par ordre décroissant de leur nombre d’achats (sans prendre en compte
--la quantité achetée) 

SELECT    v.numClient, nomClient, COUNT(*) AS nbA
FROM      Vente v NATURAL JOIN Client c
GROUP BY  v.numClient, nomClient
ORDER BY  nbA DESC;


 numclient |  nomclient  | nba 
-----------+-------------+-----
         4 | Poret       |  19
         6 | Timable     |  12
         7 | Don Devello |  12
         8 | Ohm         |  11
         3 | Hauraque    |  11
         5 | Menvussa    |   9
        11 | Kament      |   9
        10 | Hautine     |   9
         9 | Ginal       |   8
         2 | Fissile     |   8
         1 | Torguesse   |   6

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--Afficher le chiffre d’affaire des ventes effectuées en 2021 (on pourra utiliser la fonction extract pour récupérer l’année seule d’une date)

SELECT SUM(Concerner.prixVente*Concerner.quantite) AS "Chiffre d'affaire"
FROM Vente NATURAL JOIN Concerner
WHERE EXTRACT(YEAR FROM Vente.dteVente) = '2021';


 Chiffre d affaire 
-------------------
           54833.6

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Lister les clients (numéro, nom) avec leur coût total d’achats (que l’on nommera
--coutA) triés par leur coût décroissant, qui ont totalisé au moins 50000€
--d’achats... */

SELECT    v.numClient, nomClient, SUM(cnc.prixVente * cnc.quantite) AS couta
FROM      Vente v JOIN Client cli    ON v.numClient = cli.numClient
                  JOIN Concerner cnc ON v.numVente  = cnc.numVente
GROUP BY  v.numClient, nomClient
HAVING    SUM(cnc.prixVente * cnc.quantite) > 50000
ORDER BY  couta DESC;


 numclient |  nomclient  |   couta   
-----------+-------------+-----------
         4 | Poret       | 129209.55
         6 | Timable     |   93406.5
         8 | Ohm         |   92865.9
         7 | Don Devello |   82909.4
         9 | Ginal       |   66003.9
        10 | Hautine     |   59519.1
         5 | Menvussa    |   56772.3
         3 | Hauraque    |     51684

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--Créer une vue appelée CA qui affiche le chiffre d’affaire réalisé par année en listant dans l’ordre croissant des années (champ appelé annee) et en face le
--chiffre réalisé (appelé chA). 

DROP VIEW CA;

CREATE VIEW CA AS
SELECT      EXTRACT( YEAR FROM dteVente) as "annee", SUM(prixvente * quantite) as "chA"
FROM        Concerner NATURAL JOIN Vente
GROUP BY    EXTRACT( YEAR FROM dteVente)
ORDER BY    EXTRACT( YEAR FROM dteVente);


 annee |   chA    
-------+----------
  2000 |    34059
  2001 | 52773.45
  2002 |    46129
  2003 |  15867.5
  2004 |  45393.9
  2005 |  64904.7
  2006 |  14602.5
  2007 |  34254.8
  2008 |  19389.8
  2009 |  14755.2
  2010 |  15545.4
  2011 |  17137.5
  2012 |  29922.4
  2013 |    11316
  2014 |  46403.7
  2015 |   9294.3
  2016 |  25570.3
  2017 |  23346.3
  2018 |  76295.8
  2019 |    59304
  2020 |    24000
  2021 |  54833.6

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--Lister tous les clients (numéro et nom) ayant acheté des BD de la série ‘Astérix le gaulois’.

SELECT DISTINCT Client.numClient, Client.nomClient
FROM Client NATURAL JOIN Vente NATURAL JOIN Concerner NATURAL JOIN BD NATURAL JOIN Serie
WHERE Serie.nomSerie = 'Asterix le gaulois';


 numclient |  nomclient  
-----------+-------------
         1 | Torguesse
         2 | Fissile
         3 | Hauraque
         4 | Poret
         5 | Menvussa
         6 | Timable
         7 | Don Devello
         8 | Ohm
         9 | Ginal
        10 | Hautine
        11 | Kament

---------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Lister les clients (numéro et nom) qui n’ont acheté que les BD de la série ‘Asterix
--le gaulois’ (en utilisant la clause EXCEPT)

SELECT DISTINCT Client.numClient, Client.nomClient
FROM            Client NATURAL JOIN Vente NATURAL JOIN Concerner NATURAL JOIN BD NATURAL JOIN Serie
WHERE           Serie.nomSerie = 'Asterix le gaulois'

EXCEPT

SELECT DISTINCT Client.numClient, Client.nomClient
FROM            Client NATURAL JOIN Vente NATURAL JOIN Concerner NATURAL JOIN BD NATURAL JOIN Serie
WHERE           Serie.nomSerie != 'Asterix le gaulois';



 numclient | nomclient 
-----------+-----------
         3 | Hauraque

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--Créer et afficher une vue nommée best5 qui liste les 5 meilleurs clients (ayant
--donc dépensé le plus d’argent en BD) en affichant leur numéro, nom et adresse
--mail, ainsi que le nombre total de BD qu’ils ont acheté (champ nbBD en tenant
--compte des quantités achetées), ainsi que le total de leurs achats (champ coutA).

DROP VIEW IF EXISTS best5 CASCADE;

CREATE VIEW best5 AS 
SELECT 
    Client.numClient AS "Numéro", 
    Client.nomClient AS "Nom",
    Client.mailClient AS "Adresse mail",
    SUM(Concerner.quantite) AS "nbBD",
    SUM(Concerner.prixVente*Concerner.quantite) AS "couta"
FROM
    Client NATURAL JOIN Vente NATURAL JOIN Concerner
GROUP BY
    Client.numClient,
    Client.nomClient,
    Client.mailClient
ORDER BY
    couta DESC
LIMIT 5;


 Numéro |     Nom     |  Adresse mail   | nbBD |   couta   
--------+-------------+-----------------+------+-----------
      4 | Poret       | mail@he.fr      | 8816 | 129209.55
      6 | Timable     | mail@limelo.com | 6639 |   93406.5
      8 | Ohm         | mail@odie.net   | 6159 |   92865.9
      7 | Don Devello | mail@he.fr      | 5664 |   82909.4
      9 | Ginal       | mail@ange.fr    | 4564 |   66003.9

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--Construire et afficher une vue bdEditeur qui affiche le nombre de BD vendues
--par an et par éditeur, par ordre croissant des années et des noms d’éditeurs. On y
--affichera le nom de l’éditeur, l’année considérée et le nombre de BD publiées.

DROP VIEW     bdEditeur;

CREATE VIEW   bdEditeur AS
SELECT        EXTRACT( YEAR FROM Vente.dteVente) as "annee", Editeur.nomEditeur, count(titre)
FROM          Editeur NATURAL JOIN Serie NATURAL JOIN Bd NATURAL JOIN Concerner NATURAL JOIN Vente
GROUP BY      EXTRACT( YEAR FROM dteVente), nomEditeur
ORDER BY      EXTRACT( YEAR FROM dteVente), nomEditeur;


 annee |       nomediteur       | count 
-------+------------------------+-------
  2000 | Dargaud                |     3
  2000 | Lombard                |     2
  2001 | Dargaud                |     2
  2001 | Les humanoides associe |     1
  2001 | Lombard                |     2
  2002 | Dargaud                |     3
  2002 | Les humanoides associe |     2
  2002 | Lombard                |     1
  2003 | Dargaud                |     1
  2003 | Lombard                |     1
  2003 | Pika Edition           |     0
  2004 | Dargaud                |     4
  2004 | Lombard                |     1
  2004 | Tonkan                 |     0
  2005 | Bamboo Edition         |     1
  2005 | Dargaud                |     4
  2005 | Tonkan                 |     0
  2006 | Dargaud                |     1
  2006 | Lombard                |     1
  2007 | Bamboo Edition         |     2
  2007 | Dargaud                |     4
  2008 | Dargaud                |     4
  2008 | Lombard                |     1
  2009 | Lombard                |     2
  2010 | Dargaud                |     2
  2010 | Lombard                |     1
  2011 | Dargaud                |     1
  2011 | Delcourt               |     2
  2012 | Dargaud                |     1
  2012 | Delcourt               |     2
  2012 | Lombard                |     1
  2013 | Dargaud                |     2
  2013 | Delcourt               |     2
  2014 | Dargaud                |     1
  2014 | Delcourt               |     3
  2014 | Lombard                |     1
  2015 | Dargaud                |     2
  2015 | Lombard                |     1
  2016 | Dargaud                |     4
  2016 | Lombard                |     1
  2016 | Vents d Ouest          |     1
  2017 | Dargaud                |     3
  2017 | Lombard                |     1
  2018 | Dargaud                |     4
  2018 | Lombard                |     3
  2018 | Vents d Ouest          |     2
  2019 | Dargaud                |     2
  2019 | Lombard                |     2
  2019 | Vents d Ouest          |     1
  2020 | Dargaud                |     1
  2020 | Vents d Ouest          |     1
  2021 | Delcourt               |     1
  2021 | Lombard                |     5
  2021 | Vents d Ouest          |     1

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--Construire et afficher une vue bdEd10 qui affiche les éditeurs qui ont publié plus
--de 10 BD, en donnant leur nom et email, ainsi que le nombre de BD différentes
--qu’ils ont publiées.

DROP VIEW IF EXISTS bdEd10 CASCADE;

CREATE VIEW bdEd10 AS
SELECT
    Editeur.nomEditeur AS "Nom",
    Editeur.mailEditeur AS "Adresse mail",
    COUNT(BD.titre) AS "Nombre BD"
FROM
    Editeur NATURAL JOIN Serie NATURAL JOIN BD
GROUP BY 
    Editeur.nomEditeur, 
    Editeur.mailEditeur
HAVING
    COUNT(BD.titre) > 10;

SELECT * FROM bdEd10;
