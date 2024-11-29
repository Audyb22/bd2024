DELIMITER //
CREATE PROCEDURE ajout_adherent (IN idadher VARCHAR(11), IN lnom VARCHAR(30),IN lprenom VARCHAR(30) ,IN laddresse VARCHAR(100), IN ldatenaiss DATE)
BEGIN
    INSERT INTO adherent (idAdherent, nom, prenom, adresse, dateNaiss) VALUES (idadher,lnom,lprenom,laddresse,ldatenaiss);
end //
DELIMITER ;

-- Création des catégories
DELIMITER //
CREATE PROCEDURE ajout_categorie(IN lnom VARCHAR(30))
BEGIN
    INSERT INTO categorie (nomCategorie) VALUE (lnom);
end //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ajout_activite(IN lnom VARCHAR(30), IN lcouOrg DOUBLE, IN lcoutVente DOUBLE,IN lidCategorie INT, IN nbSceance INT, IN dateDebut DATE)
BEGIN
    DECLARE nouvDate DATE;
    DECLARE joursSceances INT;
    DECLARE jourSemaine INT;
    DECLARE lheure VARCHAR(15);
    DECLARE lidActivite INT;
    SET lidActivite = (SELECT MAX(idActivite) FROM activite)+1;
    SET joursSceances = 0;
    SET nouvDate = dateDebut;
    INSERT INTO activite (idActivite,nom, coutOrgCli, coutVentCli, idCategorie) VALUE (lidActivite,lnom,lcouOrg,lcoutVente,lidCategorie);
    WHILE joursSceances < nbSceance DO
        SET nouvDate = DATE_ADD(nouvDate, INTERVAL 1 DAY);
        SET jourSemaine = DAYOFWEEK(nouvDate);
        SET lheure = CONCAT(1,ROUND( RAND() * 7 ) + 1,':00:00');
        INSERT INTO sceance (date, heure, nbPlaceDispo, note, idActivite) VALUE (nouvDate,lheure,30,0,lidActivite);
        SET joursSceances = joursSceances + 1;
    END WHILE;
end //
DELIMITER ;

DROP PROCEDURE ajout_activite;
-- Création des Participation aux scéances
DELIMITER //
CREATE PROCEDURE ajout_particip_sceance(IN lidSceance INT, IN lidAdherent VARCHAR(11),IN lnoteAppreciation DOUBLE)
BEGIN
    INSERT INTO participationsceance VALUES (lidSceance,lidAdherent,lnoteAppreciation);
end //
DELIMITER ;