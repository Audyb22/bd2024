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
    SELECT nomCategorie INTO nom FROM categorie WHERE idCategorie = lid;
    RETURN nom;
end //
DELIMITER ;

CALL ajout_activite('Cours de Yoga', 10.00, 15.00, 4,6,'2024-10-10')
CALL ajout_particip_sceance(2, 'KH-1993-574', 4.5)
