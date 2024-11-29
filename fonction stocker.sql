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