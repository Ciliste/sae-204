--Ecrire une fonction qui supprime une vente dont l'identifiant est passé enparamètre.
--Vérifier d'abord que la vente associée à l'identifiant existe, si elle n'existe pas
--afficher un message d'erreur le mentionnant; si elle existe on la supprime.
--Cette suppression va générer une violation de clé étrangère dans la table
--‘Concerner’.
--Pour gérer cela, on utilisera le code d'erreur FOREIGN_KEY_VIOLATION
--dans un bloc EXCEPTION dans lequel on supprimera tous les tuples de la table
--‘Concerner’ qui possèdent ce numéro de vente, avant de supprimer la venet ellemême. On pourra au passage afficher aussi un message d'avertissement sur cette
--exception

CREATE OR REPLACE FUNCTION proc_i ( idVente Vente.numVente%TYPE )
    RETURNS void
    AS $$

BEGIN

    