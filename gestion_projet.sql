CREATE DATABASE gestion_projet;

USE gestion_projet;
GO

CREATE SCHEMA mon_projet;
GO 

--DROP TABLE mon_projet.Service;
--DROP DATABASE gestion_projet;


/* Dans l’objectif de créer une application pour la gestion des projets au sein d’une entreprise de développement
informatique, on vous propose le schéma relationnel suivant */


-- CREATIONS DES TABLES 

-- CREATION DE LA TABLE SERVICE

CREATE TABLE mon_projet.Service(

num_serv INT NOT NULL IDENTITY(1,1), 
nom_serv NVARCHAR(100),
date_creation DATE
CONSTRAINT pkNum_servService PRIMARY KEY (num_serv)
);
GO

-- CREATION DE LA TABLE EMPLOYE

CREATE TABLE mon_projet.Employe(

matricule INT NOT NULL IDENTITY(1,1), 
nom NVARCHAR(80), 
prenom NVARCHAR(80), 
dateNaissance DATE, 
adresse NVARCHAR(100), 
salaire MONEY, 
grade NVARCHAR(50), 
num_serv INT,
CONSTRAINT pkMatriculeEmploye PRIMARY KEY (matricule),
CONSTRAINT fkMatriculeEmploye FOREIGN KEY (num_serv) REFERENCES mon_projet.Service(num_serv)

);


-- CREATION DE LA TABLE PROJET

CREATE TABLE mon_projet.Projet(

num_proj int NOT NULL IDENTITY(1,1),
nom_projet NVARCHAR(50),
lieu NVARCHAR(100),
nbr_limite_taches INT,
num_serv INT,
CONSTRAINT pkNumProjet PRIMARY KEY (num_proj),
CONSTRAINT fknumProjet FOREIGN KEY (num_serv) REFERENCES mon_projet.Service(num_serv)

);


-- CREATION DE LA TABLE TACHE

CREATE TABLE mon_projet.Tache(

num_tach INT NOT NULL,
nom_tach NVARCHAR(80),
date_debut DATE,
date_fin DATE,
cout MONEY,
num_proj INT,
CONSTRAINT pkNum_tach PRIMARY KEY (num_tach),
CONSTRAINT fkNum_tach FOREIGN KEY (num_proj) REFERENCES mon_projet.Projet(num_proj)

);


-- CREATION DE LA TABLE TRAVAILLE

CREATE TABLE mon_projet.Travaille(

matricule INT,
num_tach INT,
nombre_heure NUMERIC,
CONSTRAINT pkMatriculeTravaille PRIMARY KEY (matricule, num_tach),
CONSTRAINT fkMatriculeTravaille FOREIGN KEY (matricule) REFERENCES mon_projet.Employe(matricule),
CONSTRAINT fkNum_tachTravaille FOREIGN KEY (num_tach) REFERENCES mon_projet.Tache(num_tach)

);

-- Verifier que les employes ne sont pas mineurs
ALTER TABLE mon_projet.Employe 
ADD CONSTRAINT CK_Employe_date_Naissance 
CHECK (dateNaissance <= DATEADD(YEAR, -18, GETDATE()));


-- Verifier que cout minimal d'une tache est bien 1000 HTG par jour
ALTER TABLE mon_projet.Tache
ADD CONSTRAINT CK_Tache_cout
CHECK (cout<=(DATEDIFF(DAY, date_debut, date_fin))*1000); 


-- verifier que la duree n'est pas strictement inferieure a 3
ALTER TABLE mon_projet.Tache
ADD CONSTRAINT CK_Tache_duree 
CHECK (DATEDIFF(DAY, date_debut, date_fin)>=3);

-- Eviter les valeurs dupliquees
ALTER TABLE mon_projet.Service
ADD CONSTRAINT CK_Nom_serv 
UNIQUE(nom_serv);


-- INSERTION DE DONNEES DANS LES TABLES

-- INSERTION DANS LA TABLE SERVICE

INSERT INTO mon_projet.Service (nom_serv, date_creation) VALUES
('Développement Web', '2015-06-01'),
('Développement Mobile', '2016-08-15'),
('Cloud & DevOps', '2017-03-20'),
('Data Science', '2018-09-12'),
('Cyber Sécurité', '2019-07-07'),
('Support IT', '2020-05-14'),
('Intelligence Artificielle', '2021-10-30'),
('Testing et Qualité', '2022-04-22'),
('Gestion de Projets', '2023-02-18'),
('R&D', '2023-09-05');

-- INSERTION DANS LA TABLE EMPLOYE
INSERT INTO mon_projet.Employe (nom, prenom, dateNaissance, adresse, salaire, grade, num_serv) VALUES
('Dupont', 'Jean', '1990-05-12', 'Paris', 4500, 'Ingénieur', 1),
('Martin', 'Sophie', '1992-07-23', 'Lyon', 4800, 'Chef de projet', 2),
('Durand', 'Paul', '1988-11-05', 'Marseille', 5000, 'Dev Senior', 3),
('Bernard', 'Clara', '1995-01-17', 'Toulouse', 4000, 'Analyste', 4),
('Robert', 'Lucas', '1987-06-29', 'Nice', 5500, 'Architecte', 5),
('Petit', 'Emma', '1993-09-10', 'Nantes', 4200, 'Data Scientist', 6),
('Moreau', 'Hugo', '1991-12-20', 'Strasbourg', 4600, 'Pentester', 7),
('Fournier', 'Elise', '1989-03-15', 'Lille', 4700, 'Testeur', 8),
('Girard', 'Nathan', '1994-08-25', 'Bordeaux', 4300, 'PMO', 9),
('Lemoine', 'Alice', '1985-04-30', 'Grenoble', 6000, 'Chercheur', 10);

-- INSERTION DANS LA TABLE PROJET
INSERT INTO mon_projet.Projet (nom_projet, lieu, nbr_limite_taches, num_serv) VALUES
('Site E-commerce', 'Paris', 5, 1),
('Application Mobile', 'Lyon', 6, 2),
('Infrastructure Cloud', 'Marseille', 4, 3),
('Analyse Big Data', 'Toulouse', 3, 4),
('Sécurisation Réseau', 'Nice', 7, 5),
('Support Utilisateur', 'Nantes', 2, 6),
('Chatbot IA', 'Strasbourg', 5, 7),
('Automatisation Tests', 'Lille', 6, 8),
('Optimisation Process', 'Bordeaux', 4, 9),
('Innovation Technologique', 'Grenoble', 3, 10);

-- INSERTION DANS LA TABLE TACHE
INSERT INTO mon_projet.Tache (num_tach, nom_tach, date_debut, date_fin, cout, num_proj) VALUES
(301, 'Développement Backend', '2024-01-10', '2024-02-15', 15000, 1),
(302, 'Développement Frontend', '2024-01-15', '2024-02-28', 14000, 1),
(303, 'Base de Données', '2024-02-01', '2024-02-25', 13000, 2),
(304, 'Déploiement Cloud', '2024-03-05', '2024-03-30', 12000, 3),
(305, 'Analyse de Données', '2024-04-10', '2024-04-30', 18000, 4),
(306, 'Test Sécurité', '2024-05-15', '2024-06-10', 16000, 5),
(307, 'Assistance Clients', '2024-06-20', '2024-07-05', 9000, 6),
(308, 'Modèle IA', '2024-07-10', '2024-08-15', 20000, 7),
(309, 'Automatisation CI/CD', '2024-08-20', '2024-09-10', 17000, 8),
(310, 'Prototype Innovation', '2024-09-25', '2024-10-30', 22000, 10);

-- INSERTION DANS LA TABLE TRAVAILLE
INSERT INTO mon_projet.Travaille (matricule, num_tach, nombre_heure) VALUES
(1, 301, 35),
(2, 302, 40),
(3, 303, 38),
(4, 304, 30),
(5, 305, 42),
(6, 306, 37),
(7, 307, 25),
(8, 308, 45),
(9, 309, 39),
(10, 310, 50);


-- CREATION DES GROUPES DE FICHIERS

ALTER DATABASE gestion_projet
ADD FILEGROUP Rapport_Avant_2015;

ALTER DATABASE gestion_projet
ADD FILEGROUP Rapport_Avant_2020;

ALTER DATABASE gestion_projet
ADD FILEGROUP Rapport_Avant_2025;

ALTER DATABASE gestion_projet
ADD FILEGROUP Rapport_2025_Et_Apres;


-- CREATION DES FICHIERS
ALTER DATABASE gestion_projet
ADD FILE(NAME='Rapport_avant_2015', FILENAME='C:\DATA_GP\rapport_avant_2015.ndf', SIZE=10MB)
TO FILEGROUP Rapport_Avant_2015;

-- CREATION DES FICHIERS
ALTER DATABASE gestion_projet
ADD FILE(NAME='Rapport_avant_2020', FILENAME='C:\DATA_GP\rapport_avant_2020.ndf', SIZE=10MB)
TO FILEGROUP Rapport_Avant_2020;

-- CREATION DES FICHIERS
ALTER DATABASE gestion_projet
ADD FILE(NAME='Rapport_avant_2025', FILENAME='C:\DATA_GP\rapport_avant_2025.ndf', SIZE=10MB)
TO FILEGROUP Rapport_Avant_2025;

-- CREATION DES FICHIERS
ALTER DATABASE gestion_projet
ADD FILE(NAME='Rapport_2025_Et_Apres', FILENAME='C:\DATA_GP\rapport_2025_et_apres.ndf', SIZE=10MB)
TO FILEGROUP Rapport_2025_Et_Apres;


-- CREATION DE LA TABLE PARTIONNEE
-- Creation de la fonction de partionnement
CREATE PARTITION FUNCTION pf_DateRapport(DATE)
AS RANGE RIGHT FOR VALUES ('2015/01/01','2020/01/01','2025/01/01');

-- cration du schema iode partionnement
CREATE PARTITION SCHEME ps_DateRapport
AS PARTITION pf_DateRapport TO (Rapport_Avant_2015, Rapport_Avant_2020, Rapport_Avant_2025, Rapport_2025_Et_Apres);

-- Creation de la table en utilisant le schema de partionnement
CREATE TABLE mon_projet.Rapport(
id_rapport INT,
date_rapport DATE,
num_proj INT,
CONSTRAINT fkNum_ProjetRapport FOREIGN KEY (num_proj)
REFERENCES mon_projet.Projet(num_proj),
CONSTRAINT pkID_Rapport PRIMARY KEY (id_rapport, date_rapport)

) ON ps_DateRapport(date_rapport);



-- REQUETES DE SELECTION

SELECT * FROM [mon_projet].[Employe] AS Employes
WHERE nom LIKE 'El%' AND nom LIKE '%^[a-f]'
ORDER BY dateNaissance;

INSERT INTO [mon_projet].[Employe] 
VALUES('Eliezer', 'Mackendy', '03/28/2006', '', '', '',1);

-- CREATION DE LOGIN
CREATE LOGIN Maitre_oeuvre WITH PASSWORD = '1234' MUST_CHANGE, CHECK_EXPIRATION = ON;
CREATE LOGIN Maitre_oeuvre WITH PASSWORD = '1234' MUST_CHANGE, CHECK_EXPIRATION = ON;
CREATE LOGIN Maitre_oeuvre WITH PASSWORD = '1234' MUST_CHANGE, CHECK_EXPIRATION = ON;
