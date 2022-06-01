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