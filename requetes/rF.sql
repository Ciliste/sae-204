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
