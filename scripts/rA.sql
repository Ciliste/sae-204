/* a) Lister les clients (numéro et nom) triés par ordre alphabétique du nom */

SELECT      numClient,nomClient 
FROM        Client
ORDER BY    nomClient;

/* Résultat :

 numclient |  nomclient  
-----------+-------------
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
*/