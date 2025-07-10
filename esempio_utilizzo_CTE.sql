
DROP FUNCTION IF EXISTS _calcola_zona_preferita_sempre;
DELIMITER $$
CREATE FUNCTION _calcola_zona_preferita_sempre(_animale INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
/*Dichiaro la variabile risultato*/
DECLARE _zona_preferita_sempre VARCHAR(255) DEFAULT '';
/*Controllo che l'animale sia andato almeno una volta al pascolo*/
DECLARE validA INTEGER DEFAULT 0;
SET validA = (
				SELECT COUNT(*)
				FROM Rilev_GPS
				WHERE Id_animale= _animale
				);

WITH
AnalisiZona AS (
SELECT RGPS.Id_Zona AS Zona, COUNT(*) AS RilevazioniZona
FROM Rilev_GPS RGPS
WHERE RGPS.Id_animale = _animale
GROUP BY RGPS.Id_Zona
),
RilevazioneMax AS(
SELECT MAX(AZ.RilevazioniZona) AS Vince
FROM AnalisiZona AZ
)

SELECT GROUP_CONCAT(AZ1.Zona) INTO _zona_preferita_sempre
FROM AnalisiZona AZ1 INNER JOIN RilevazioneMax RM ON  AZ1.RilevazioniZona = RM.Vince;


/*Restituisco il risultato*/
RETURN(_zona_preferita_sempre);
END$$
DELIMITER ; 
SELECT _calcola_zona_preferita_sempre(1);