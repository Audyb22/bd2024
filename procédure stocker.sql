DELIMITER //
CREATE PROCEDURE ajout_adherent (IN lnom VARCHAR(30),IN lprenom VARCHAR(30) ,IN laddresse VARCHAR(100), IN ldatenaiss DATE)
BEGIN
    INSERT INTO adherent (nom, prenom, adresse, dateNaiss) VALUES (lnom,lprenom,laddresse,ldatenaiss);
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


DELIMITER //
CREATE PROCEDURE ModSceance(
    IN lidSceance INT,
    IN ldate DATE,
    IN lheure TIME,
    IN lnbPlaceDispo INT
)
BEGIN
    UPDATE Sceance
    SET
        date = ldate,
        heure = lheure,
        nbPlaceDispo = lnbPlaceDispo
    WHERE
        idSceance = lidSceance;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModActivite(IN lidActivite INT,IN lnom VARCHAR(30),IN lcoutOrgCli DOUBLE, IN lcoutVentCli DOUBLE,IN lidCategorie INT
)
BEGIN
    UPDATE Activite
    SET
        nom = lnom,
        coutOrgCli = lcoutOrgCli,
        coutVentCli = lcoutVentCli,
        idCategorie = lidCategorie
    WHERE
        idActivite = lidActivite;
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE ModAdherent(
    IN lidAdherent VARCHAR(11),
    IN lnom VARCHAR(30),
    IN lprenom VARCHAR(30),
    IN ladresse VARCHAR(100),
    IN ldateNaiss DATE
)
BEGIN
    UPDATE Adherent
    SET
        nom = lnom,
        prenom = lprenom,
        adresse = ladresse,
        dateNaiss = ldateNaiss
    WHERE
        idAdherent = lidAdherent;
END //

DELIMITER ;

DELIMiTER //
CREATE PROCEDURE supprimerSceance(IN id VARCHAR(5))
BEGIN
    DELETE FROM participationsceance
    WHERE idSceance = id;
    DELETE FROM sceance
    WHERE idSceance = id;
end //
DELIMITER ;

DELIMiTER //
CREATE PROCEDURE supprimerActivite(IN id VARCHAR(5))
BEGIN
    DELETE FROM participationsceance
    WHERE idSceance IN (SELECT idSceance FROM sceance WHERE idActivite = id);
    DELETE FROM sceance
    WHERE idActivite = id;
    DELETE FROM activite
    WHERE idActivite = id;
end //
DELIMITER ;

DELIMiTER //
CREATE PROCEDURE supprimerAdherent( id VARCHAR(50))
BEGIN
    DELETE FROM participationsceance
    WHERE idAdherent = id;
    DELETE FROM adherent
    WHERE idAdherent = id;
end //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE p_Noter(IN lidSceance INT,IN lidAdherent VARCHAR(11), IN lnote DOUBLE
)
BEGIN
    UPDATE ParticipationSceance
    SET noteAppreciation = lnote
    WHERE idSceance = lidSceance AND idAdherent = lidAdherent;
END //
DELIMITER ;


Delimiter //
CREATE TRIGGER noteActivite1
    BEFORE UPDATE ON participationsceance
    FOR EACH ROW
    BEGIN
       UPDATE sceance
        SET note = (note + new.noteAppreciation)/2
       WHERE idSceance = old.idSceance AND note > 0;
    end //
DELIMITER ;
DELIMITER //

Delimiter //
CREATE TRIGGER noteActivite2
    BEFORE UPDATE ON participationsceance
    FOR EACH ROW
    BEGIN
       UPDATE sceance
        SET note = new.noteAppreciation
       WHERE idSceance = old.idSceance AND note = 0;
    end //
DELIMITER ;
DELIMITER //
