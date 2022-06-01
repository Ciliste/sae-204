Drop table IF EXISTS Concerner Cascade;
Drop table IF EXISTS Vente     Cascade;
Drop table IF EXISTS BD        Cascade;
Drop table IF EXISTS Serie     Cascade;
Drop table IF EXISTS Auteur    Cascade;
Drop table IF EXISTS Editeur   Cascade;
Drop table IF EXISTS Client    Cascade;

Create table Client (
	numClient serial primary key,
	nomClient varchar(11) ,
	numTelClient text,
	mailClient text
);

Create table Editeur (
	numEditeur serial primary key,
	nomEditeur varChar(23),
	adresseEditeur text,
	numTelEditeur text,
	mailEditeur text
);


Create table Auteur (
	numAuteur serial primary key,
	nomAuteur varchar(15) not null,
	prenomAuteur varchar(15),
	dteNaissAuteur date,
	dteDecesAuteur date,
	pays varchar(10)
);


Create Table Serie (
	numSerie serial primary key,
	nomSerie varchar(50) not null,
	numEditeur int references Editeur(numEditeur)
);

Create Table BD (
	isbn char(17) primary key,
	titre text,
	prixActuel float not null,
	numTome int,
	numSerie int references Serie(numSerie),
	numAuteurDessinateur int references Auteur(numAuteur),
	numAuteurScenariste int references Auteur(numAuteur)
);

Create Table Vente (
	numVente serial primary key,
	dteVente date,
	numClient int references Client(numClient)
);

Create Table Concerner (
	isbn char(17) references BD(isbn),
	numVente int references Vente(numVente),
	prixVente float not null,
	quantite int,
	primary key (isbn, numVente)
);
