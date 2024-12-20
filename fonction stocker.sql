DELIMITER //
CREATE FUNCTION nb_cours_de_adherant(AD VARCHAR(11)) RETURNS INT
    BEGIN
        DECLARE nb INT;
        select count(*) INTO nb
        FROM sceance
        INNER JOIN participationsceance p on sceance.idSceance = p.idSceance
        WHERE  p.idAdherent like  AD;
        RETURN nb;
    end //
DELIMITER ;

SELECT nb_cours_de_adherant('JA-1990-729');

DELIMITER //
CREATE FUNCTION nom_cours_plus_participation_de_adherant(AD VARCHAR(11)) RETURNS VARCHAR(30)
    BEGIN
        DECLARE nomCour VARCHAR(30);
        select nom INTO nomCour
        FROM activite
            INNER JOIN sceance s on activite.idActivite = s.idActivite
        INNER JOIN participationsceance p on s.idSceance = p.idSceance
        WHERE  p.idAdherent like  AD
        group by activite.idActivite
        order by count(activite.idActivite)
        LIMIT 1;
        RETURN nomCour;
    end //
DELIMITER ;

SELECT nom_cours_plus_participation_de_adherant('JA-1990-729');


-- 

DELIMITER //
CREATE FUNCTION f_nbr_particip_total() RETURNS INT
BEGIN
    DECLARE nb INT;
    SELECT COUNT(*) INTO nb FROM Adherent;
    RETURN nb;
end //
DELIMITER ;
SELECT f_nbr_particip_total();


-- Fonction de retour du nombre de scéance par activité
DELIMITER //
CREATE FUNCTION f_nbr_sceance_activite(nomActivite VARCHAR(30)) RETURNS INT
BEGIN
    DECLARE nb INT;
    SELECT COUNT(*) INTO nb FROM Sceance WHERE idActivite = (SELECT idActivite FROM activite WHERE nom = nomActivite);
    RETURN nb;
end //
DELIMITER ;
SELECT f_nbr_sceance_activite('Cours de yoga');

-- Fonction de retour du nombre d'adhérent par activite
DELIMITER //
CREATE FUNCTION f_nbr_adherent_activite(nomActivite VARCHAR(30)) RETURNS INT
BEGIN
    DECLARE nb INT;
    SELECT COUNT(*) INTO nb FROM participationsceance WHERE idSceance IN (SELECT idSceance FROM sceance WHERE idActivite = (
        SELECT idActivite FROM activite WHERE nom = nomActivite
        ));
    RETURN nb;
end //
DELIMITER ;
SELECT f_nbr_adherent_activite('Séance de Pilates');



DELIMITER //
CREATE FUNCTION f_nomcat(lid INT) RETURNS VARCHAR(30)
BEGIN
    DECLARE nom VARCHAR(30);
    DECLARE id_non_existant CONDITION FOR SQLSTATE '42000';
    SELECT nomCategorie INTO nom FROM categorie WHERE idCategorie = lid;
    IF nom is null
        THEN
            SIGNAL id_non_existant SET message_text ='L\'identifiant n\'existe pas!';
    END IF;

    RETURN nom;
end //
DELIMITER ;


DELIMITER //
CREATE FUNCTION f_sonnec_adher(lid VARCHAR(30)) RETURNS varchar(30)
BEGIN
    DECLARE lenom VARCHAR(30);
    SELECT nom INTO lenom FROM adherent WHERE idAdherent = lid;
    return lenom;
end //

DELIMITER //
CREATE FUNCTION f_sonnec_admin(lnom VARCHAR(30), lpass VARCHAR(30)) RETURNS INT(30)
BEGIN
    DECLARE lid int;
    SELECT idAdmin INTO lid FROM administrateur WHERE nom = lnom AND motDePasse = lpass;
    return lid;
end //

    
DELIMITER //
CREATE FUNCTION f_nomActiv(lid INT) RETURNS VARCHAR(30)
BEGIN
    DECLARE lnom VARCHAR(30);
    SELECT nom INTO lnom FROM activite WHERE idActivite = lid;
    return lnom;
end //
DELIMITER ;

DELIMITER //
CREATE FUNCTION f_note(lidSe INT, lidAd VARCHAR(30)) RETURNS double
BEGIN
    DECLARE nb double;
    SELECT noteAppreciation INTO nb FROM participationsceance WHERE idAdherent = lidAd AND idSceance = lidSe;
    return nb;
end //
DELIMITER ;


DELIMITER //

CREATE FUNCTION f_adherent_deja_activite(lidA VARCHAR(30), lidActivite INT)
RETURNS VARCHAR(30)
BEGIN
    DECLARE vr VARCHAR(30);
    IF EXISTS (
        SELECT 1
        FROM ParticipationSceance ps
        JOIN Sceance s ON ps.idSceance = s.idSceance
        WHERE ps.idAdherent = lidA AND s.idActivite = lidActivite
    ) THEN
        SET vr = 'OUI';
    ELSE
        SET vr = 'NON';
    END IF;

    RETURN vr;
END //

DELIMITER ;

CALL ajout_activite('Cours de Yoga', 10.00, 15.00, 4,6,'2024-10-10')
CALL ajout_particip_sceance(2, 'KH-1993-574', 4.5)
