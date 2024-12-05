-- 3.1: Construction du numéro de l'adhérent
DELIMITER //
CREATE TRIGGER num_identification
BEFORE INSERT ON Adherent
FOR EACH ROW
BEGIN
    SET new.idAdherent = CONCAT(LEFT(new.prenom,1),LEFT(new.nom,1),'-',YEAR(new.dateNaiss),'-',
        ROUND( RAND() * 9 ) + 1,ROUND( RAND() * 9 ) + 1,ROUND( RAND() * 9 ) + 1);
end //
DELIMITER ;


-- 3.2: Création des scéances
Delimiter //
CREATE TRIGGER nbr_place_dispo_seance
    BEFORE INSERT ON participationsceance
    FOR EACH ROW
    BEGIN
        update sceance  
        set nbPlaceDispo=nbPlaceDispo-1
        WHERE NEW.idSceance = sceance.idSceance;
    end //

DELIMITER ;


-- 3.3: Création des scéances
DELIMITER //
CREATE TRIGGER sceance_participants
BEFORE INSERT ON participationsceance
FOR EACH ROW
    IF (SELECT DISTINCT nbPlaceDispo FROM Sceance WHERE Sceance.idSceance = new.idSceance) = 0  THEN
     SIGNAL SQLSTATE '45000' SET message_text="Il n'y a plus de place disponible pour cette scéance";  
    end if //
DELIMITER ;

-- 3.4
Delimiter //
CREATE TRIGGER age_adherent
    BEFORE INSERT ON adherent
    FOR EACH ROW
    BEGIN
       set NEW.age = DATEDIFF(curdate(),NEW.dateNaiss)/365.5;
    end //
DELIMITER ;
-- 3.5
Delimiter //
CREATE TRIGGER age_adherent2
    BEFORE UPDATE ON adherent
    FOR EACH ROW
    BEGIN
       set NEW.age = DATEDIFF(curdate(),NEW.dateNaiss)/365.5;
    end //
DELIMITER ;
DELIMITER //
