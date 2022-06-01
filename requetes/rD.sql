SELECT SUM(Concerner.prixVente*Concerner.quantite) AS "Chiffre d'affaire"
FROM Vente NATURAL JOIN Concerner
WHERE EXTRACT(YEAR FROM Vente.dteVente) = '2021';


 Chiffre d'affaire 
-------------------
           54833.6
(1 ligne)
