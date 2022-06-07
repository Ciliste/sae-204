-- Script Administrateur
GRANT ALL PRIVILEGES
ON    Serie, BD, Editeur, Auteur, Vente, Client, Concerner
TO    Administrateur;

-- Script Vendeur
GRANT SELECT, INSERT, OPTION
ON    Vente, Client, Concerner
TO    Vendeur;

-- Script Editeur
GRANT SELECT, INSERT, OPTION
ON    Serie, BD, Auteur, Vente, Client, Concerner
TO    Editeur;

