-- Trouver le participant ayant le nombre de séances le plus élevé
  CREATE VIEW nb_sceance_plus_eleve
         AS
         SELECT
             a.idAdherent,
             concat(nom,' ',prenom),
             count(sceance.idSceance)
        FROM sceance
            INNER JOIN participationsceance p on sceance.idSceance = p.idSceance
            INNER JOIN adherent a on p.idAdherent = a.idAdherent
        GROUP BY a.idAdherent
     ;

--Trouver le prix moyen par activité pour chaque participant
 CREATE VIEW prix_moy_activité_par_participant
         AS
         SELECT
             concat(a.nom,' ',prenom),
             AVG(coutVentCli)
        FROM sceance
            INNER JOIN participationsceance p on sceance.idSceance = p.idSceance
            INNER JOIN adherent a on p.idAdherent = a.idAdherent
            INNER JOIN activite a2 on sceance.idActivite = a2.idActivite
        GROUP BY a.idAdherent
     ;


--Afficher les notes d’appréciation pour chaque activité (à finir)
CREATE VIEW note_appreciation_activite
AS
SELECT
    nom,
    AVG(noteAppreciation)
    FROM activite
INNER JOIN sceance s on activite.idActivite = s.idActivite
INNER JOIN participationsceance p on s.idSceance = p.idSceance
GROUP BY nom;

-- 
CREATE VIEW moyenne_note_appreciation_activite
AS
    SELECT
        avg(noteAppreciation) as "Moyenne des notes d’appréciations pour toutes les activités"
    FROM activite
INNER JOIN sceance s on activite.idActivite = s.idActivite
INNER JOIN participationsceance p on s.idSceance = p.idSceance;

-- 
CREATE VIEW nb_participant_par_activitee
AS
    SELECT
        count(p.idAdherent) as "Nombre Participant par activité"
        ,nom as "Activité"
FROM activite
INNER JOIN sceance s on activite.idActivite = s.idActivite
INNER JOIN participationsceance p on s.idSceance = p.idSceance
GROUP BY activite.idActivite;

-- 
CREATE VIEW nb_participant_moyen_par_mois
    AS
select count(idAdherent), activite.nom, month(s.date) FROM activite
INNER JOIN sceance s on activite.idActivite = s.idActivite
INNER JOIN participationsceance p on s.idSceance = p.idSceance
GROUP BY  activite.idActivite,month(s.date);



