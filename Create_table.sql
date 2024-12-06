CREATE TABLE Administrateur(
    idAdmin INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50),
    motDePasse VARCHAR(50)
);
CREATE TABLE Adherent(
    idAdherent VARCHAR(11) PRIMARY KEY,
    nom VARCHAR(30),
    prenom VARCHAR(30),
    adresse VARCHAR(100),
    dateNaiss DATE,
    age INT,
    CONSTRAINT ck_age CHECK ( age >= 18 )
);

CREATE TABLE Categorie (
    idCategorie INT AUTO_INCREMENT PRIMARY KEY,
    nomCategorie VARCHAR(30)
);

CREATE TABLE Activite(
    idActivite INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(30),
    coutOrgCli DOUBLE,
    coutVentCli DOUBLE,
    idCategorie INT,
    CONSTRAINT fk_activite_categorie FOREIGN KEY(idCategorie) REFERENCES Categorie(idCategorie)
);
CREATE TABLE Sceance(
    idSceance INT PRIMARY KEY AUTO_INCREMENT,
    date DATE,
    heure TIME,
    nbPlaceDispo INT,
    note DOUBLE,
    idActivite INT,
    CONSTRAINT fk_Sceance_Activite FOREIGN KEY (idActivite) REFERENCES Activite(idActivite)
);

CREATE TABLE ParticipationSceance(
    idSceance INT,
    idAdherent VARCHAR(11),
    noteAppreciation DOUBLE,
    PRIMARY KEY (idSceance,idAdherent),
    CONSTRAINT fk_sceance_ps FOREIGN KEY (idSceance) REFERENCES Sceance(idSceance),
    CONSTRAINT fk_adherent_ps FOREIGN KEY (idAdherent) REFERENCES Adherent(idAdherent)
);
