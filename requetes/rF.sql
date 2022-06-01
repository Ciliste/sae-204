SELECT DISTINCT Client.numClient, Client.nomClient
FROM Client NATURAL JOIN Vente NATURAL JOIN Concerner NATURAL JOIN BD NATURAL JOIN Serie
WHERE Serie.nomSerie = 'Asterix le gaulois';

--SELECT nomSerie FROM Serie;