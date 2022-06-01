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
