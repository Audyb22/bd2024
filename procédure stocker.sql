

Delimiter //
CREATE TRIGGER age_adherent
    BEFORE INSERT ON adherent
    FOR EACH ROW
    BEGIN
       set NEW.age = DATEDIFF(curdate(),NEW.dateNaiss)/365.5;
    end //
DELIMITER ;