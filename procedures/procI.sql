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

SELECT procI(1);

/*
\i procI.sql

 proci 
-------
 
(1 ligne)
*/