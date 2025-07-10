/*Controllo Qualità Processo*/

/*Creo una MV che per ogni lotto, contenga il codice del lotto, la data di produzione, l'indice di qualità del 
lotto, il numero di prodotti del lotto che abbiano l'indice di Qualità Prodotto> 0.30*/
DROP TABLE IF EXISTS MV_Qualita_Produzione;
CREATE TABLE MV_Qualita_Produzione(
Id_Lotto INTEGER DEFAULT 0,
Data_Prod DATE,
Indice_Qualità_Lotto DOUBLE DEFAULT 0,
Quanti_Maggiori_30 INTEGER DEFAULT 0
) ENGINE = InnoDB, CHARSET latin1;

/*Scrivo una stored function che dato in ingresso il codice identificativo di una unità, e il suo tipo
 mi restituisca il suo Indice_Qualità_Prodotto*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_indice_prodotto;
CREATE FUNCTION _calcola_indice_prodotto(_unita INT, _tipo CHAR(50))
RETURNS DOUBLE NOT DETERMINISTIC
BEGIN
/*dichiaro la variabile risultato*/
DECLARE Indice_Qualità_Prodotto DOUBLE DEFAULT 0;

/*Faccio un join tra la tabella Ph_Ricetta e la tabella Ph_Processo, in modo che siano sincronizzate sulla
stessa fase e prendano il considerazione l'unità considerata, del tipo considerato*/

WITH 
MostraValori AS
(
SELECT PP.Id_Ph_Processo AS NumeroFase, 
		ABS(((PR.Temp_riposo - PP.Temp_riposo)/PR.Temp_riposo)) AS DifferenzaRiposo,
        ABS(((PR.Temp_latte - PP.Temp_latte)/PR.Temp_latte)) AS DifferenzaLatte,
        ABS(((PR.Durata_Ideale - PP.Durata_Reale)/PR.Durata_Ideale)) AS DifferenzaDurata
FROM Ph_Ricetta PR INNER JOIN Ph_Processo PP
		ON PR.Id_Ph_Ricetta = PP.Id_Ph_Processo
		AND PR.Nome = PP.Nome
WHERE PP.Id_Unita = _unita
		AND PP.Nome = _tipo
)
,
MostraValoriMedi AS 
(
SELECT MV.NumeroFase, ((MV.DifferenzaRiposo+MV.DifferenzaLatte +MV.DifferenzaDurata)/3) AS ValoriMediPerFase
FROM MostraValori MV
GROUP BY MV.NumeroFase
)

SET Indice_Qualità_Prodotto =
SELECT AVG(MVM.ValoriMediPerFase) 
FROM MostraValoriMedi MVM;
/*Restituisco il risultato*/
RETURN(Indice_Qualità_Prodotto);
END $$
DELIMITER ;

/*Scrivo una stored function che dato in ingresso il codice identificativo di un lotto, mi restituisca il suo
Indice_Qualità_Lotto*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_indice_lotto;
CREATE FUNCTION _calcola_indice_lotto(_lotto INT)
RETURNS DOUBLE NOT DETERMINISTIC
BEGIN
/*dichiaro la variabile risultato*/
DECLARE Indice_Qualità_Lotto DOUBLE DEFAULT 0;
/*calcolo dell'indice: dato il codice identificativo del lotto, trovo tutte le unità che ne fanno parte, e
recupero i loro indici di qualita, poi ne faccio la media*/

/*accedo alla tabella UNITA, prendo le unità che hanno come lotto quello che prendo in ingresso*/
/*chiamo la funzione _calcola_indice_prodotto su ogni unità che fa parte di quel lotto e faccio
la media dei valori ottenuti*/
SET Indice_Qualita_Lotto =(
							SELECT AVG(_calcola_indice_prodotto(U.Id_Unita, U.Nome))
							FROM Unita U
							WHERE U.Id_Lotto = _lotto
							);
/*Restituisco il risultato*/
RETURN(Indice_Qualità_Lotto);
END $$
DELIMITER ;

/*Per ogni lotto di produzione, devo contare il numero di prodotti che superano con il loro Indice di Qualita, 
il numero 0.30, che rappresenta il numero di prodotti che ha possibili problemi*/
CREATE OR REPLACE VIEW ContaQuantiSuperano AS 
SELECT U.Id_Lotto AS LottoProduzione,  L.Data_prod AS DataProduzione, COUNT(*) AS NumeroProdottiMaggiori
FROM Unita U NATURAL JOIN Lotto L
WHERE _calcola_indice_prodotto(U.Id_Unita, U.Nome) > 0.30
GROUP BY U.Id_Lotto, L.Data_prod;

/*Inserisco i dati nella materialized view*/
INSERT INTO MV_Qualita_Produzione
SELECT 
		CQS.LottoProduzione,
        CQS.DataProduzione,
        _calcola_indice_lotto(CQS.LottoProduzione),
        CQS.NumeroProdottiMaggiori
FROM ContaQuantiSuperano CQS
GROUP BY CQS.LottoProduzione;

/*gestisco l'aggiornamento della MV: la materialized view viene cancellata e ricostruita
dalla stored procedure*/

DROP PROCEDURE IF EXISTS refresh_MV_Qualita_Produzione;
DELIMITER $$
CREATE PROCEDURE refresh_MV_Qualita_Produzione(OUT esito INTEGER)
BEGIN
/*esito vale 1 se si verifica un errore*/
DECLARE esito INTEGER DEFAULT 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
SET esito = 1;
SELECT 'Impossibile aggiornare la materialized view';
END; 
/*flushing della materialized view*/
TRUNCATE TABLE MV_Qualita_Produzione;

/*full refresh*/
INSERT INTO MV_Qualita_Produzione
SELECT 
		CQS.LottoProduzione,
        CQS.DataProduzione,
        _calcola_indice_lotto(CQS.LottoProduzione),
        CQS.NumeroProdottiMaggiori
FROM ContaQuantiSuperano CQS
GROUP BY CQS.LottoProduzione;

END $$
DELIMITER ;

/*---------------------------------------------------------------------------------------------------------------*/
/*Tracciabilità di Filiera*/

/*Creo una MV che per ogni prodotto che è stato reso, oppure recensito negativamente, contenga il codice 
identificativo del prodotto,  l'indice di qualità del prodotto, il tipo di problematica per cui è stato reso,
il punteggio medio ottenuto nella recensione*/
DROP TABLE IF EXISTS MV_Problematiche_Prodotto;
CREATE TABLE MV_Problematiche_Prodotto(
CodiceProdotto INTEGER DEFAULT 0,
TipoProdotto CHAR(100) DEFAULT '',
Indice_Qualità_Prodotto DOUBLE DEFAULT 0,
TipoProblematica VARCHAR(255) DEFAULT '',
PunteggioMedioRecensione DOUBLE DEFAULT 0
) ENGINE = InnoDB, CHARSET latin1;

/*I prodotti da prendere in considerazione sono quelli tali che il loro codice identificativo e il loro tipo, sono
presenti nella tabella Prodotto Reso, oppure se sono presenti nella tabella Recensione e il Gradimento Generale 
è minore o uguale a 2, nel caso in cui siano presenti in entrambe le tabelle, non è un problema perchè
UNION elimina automaticamente i duplicati*/
CREATE OR REPLACE VIEW MostraProdotti AS 
SELECT R.Id_Unita, R.Nome
FROM Recensione R
WHERE R.Gradimento_generale <=2
UNION 
SELECT PR.Id_Unita, PR.Nome
FROM Prodotto_Reso PR;

/*Per ogni prodotto, devo mostrare il punteggio medio della recensione*/
CREATE OR REPLACE VIEW MostraPunteggioMedio AS
SELECT 	R.Id_Unita, 
		R.Nome
		((R.Qualita_Percepita+R.Gradimento_generale+R.Conservazione+R.Gusto)/4) AS PunteggioMedio
FROM Recensione R 
GROUP BY R.Id_Unita, R.Nome;

/*Per ogni prodotto, devo mostrare il tipo di problematica*/
CREATE OR REPLACE VIEW MostraTipoProblematica AS
SELECT
		PR.Id_Unita, 
        PR.Nome,
        CONCAT(PR.Problematiche) AS Problema
FROM Prodotto_Reso PR
GROUP BY PR.Id_Unita, PR.Nome;

/*INSERISCO NELLA MV*/
INSERT INTO MV_Problematiche_Prodotto
SELECT 
		MP.Id_Unita,
		MP.Nome,
        _calcola_indice_prodotto(MP.Id_Unita, MP.Nome),
		MPT.Problema ,
		MPM.PunteggioMedio
FROM MostraProdotti MP NATURAL JOIN MostraPunteggioMedio MPM NATURAL JOIN MostraTipoProblematica MTP
GROUP BY MP.Id_Unita, MP.Nome;

/*gestione dell'aggiornamento della MV*/
DROP PROCEDURE IF EXISTS refresh_MV_Problematiche_Prodotto;
DELIMITER $$
CREATE PROCEDURE refresh_MV_Problematiche_Prodotto(OUT esito INTEGER)
BEGIN
/*esito vale 1 se si verifica un errore*/
DECLARE esito INTEGER DEFAULT 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
SET esito = 1;
SELECT 'Impossibile aggiornare la materialized view';
END; 
/*flushing della materialized view*/
TRUNCATE TABLE MV_Problematiche_Prodotto;

/*full refresh*/
INSERT INTO MV_Problematiche_Prodotto
SELECT 
		MP.Id_Unita,
		MP.Nome,
        _calcola_indice_prodotto(MP.Id_Unita, MP.Nome),
		MPT.Problema ,
		MPM.PunteggioMedio
FROM MostraProdotti MP NATURAL JOIN MostraPunteggioMedio MPM NATURAL JOIN MostraTipoProblematica MTP
GROUP BY MP.Id_Unita, MP.Nome;

END $$
DELIMITER ;

/*------------------------------------------------------------------------------------------------------*/

/*comportamento degli animali*/
/*Creo una MV contenente, per ogni animale che è andato al pascolo almeno una volta, il suo codice identificativo,
la zona in cui ha preferito pascolare da sempre, nell'ultimo mese e nell'ultima settimana*/
DROP TABLE IF EXISTS MV_Pascolo;
CREATE TABLE MV_Pascolo(
CodiceAnimale INTEGER DEFAULT 0,
ZonaPreferitaSempre VARCHAR(255) DEFAULT '', 
ZonaPreferitaMese VARCHAR(255) DEFAULT '',
ZonaPreferitaSettimana VARCHAR(255) DEFAULT ''
) ENGINE = InnoDB, CHARSET latin1;

/*implemento una stored function che dato un animale, mi conta quante volte l'animale
è stato rilevato in ogni zona, e mi restituisce la zona (o più) in cui è stato rilevato più volte da sempre*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_zona_preferita_sempre;
CREATE FUNCTION _calcola_zona_preferita_sempre(_animale)
RETURNS VARCHAR NOT DETERMINISTIC
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
/*Creo una view che per ogni zona in cui è stato l'animale, mostra il numero di rilevazioni effettuate lì*/
CREATE OR REPLACE VIEW MostraRilevazioniZona AS 
SELECT RGPS.Id_Zona AS Zona, COUNT(*) AS RilevazioniZona
FROM Rilev_GPS RGPS
WHERE RGPS.Id_animale = _animale
GROUP BY RGPS.Id_Zona;

/*Seleziono le zone parimerito in cui sono state effettuate più rilevazioni*/
SET _zona_preferita_sempre = (SELECT GROUP_CONCAT(MRZ.Zona)
FROM MostraRilevazioniZona MRZ
WHERE MRZ.RilevazioniZona = (
								SELECT MAX(MRZ1.RilevazioniZona)
								FROM MostraRilevazioniZona MRZ1

								));
/*Restituisco il risultato*/
RETURN(_zona_preferita_sempre);
END $$
DELIMITER ; 

/*implemento una stored funcion che, dato un animale mi conta quante volte l'animale è stato rilevato
 in ogni zona, e mi restituisce la zona (o più) in cui è stato rilevato più volte nell'ultimo mese*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_zona_preferita_mese;
CREATE FUNCTION _calcola_zona_preferita_mese(_animale)
RETURNS VARCHAR NOT DETERMINISTIC
BEGIN
/*Controllo che l'animale sia andato almeno una volta al pascolo*/
DECLARE validA INTEGER DEFAULT 0;
/*Dichiaro la variabile risultato*/
DECLARE _zona_preferita_mese VARCHAR(255) DEFAULT '';

SET validA = (
				SELECT COUNT(*)
				FROM Rilev_GPS
				WHERE Id_animale= _animale
				);
/*Creo una view che per ogni zona in cui è stato l'animale, mostra il numero di rilevazioni effettuate lì, 
nell'ultimo mese*/
CREATE OR REPLACE VIEW MostraRilevazioniZonaMese AS 
SELECT RGPS.Id_Zona AS ZonaMese, COUNT(*) AS RilevazioniZonaMese
FROM Rilev_GPS RGPS
WHERE 	RGPS.Id_animale = _animale
		AND RGPS.Data BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 MONTH
GROUP BY RGPS.Id_Zona;

/*Seleziono le zone parimerito in cui sono state effettuate più rilevazioni*/
SET _zona_preferita_mese = (SELECT GROUP_CONCAT(MRZ.ZonaMese)
FROM MostraRilevazioniZonaMese MRZM
WHERE MRZM.RilevazioniZonaMese = (
								SELECT MAX(MRZM1.RilevazioniZonaMese)
								FROM MostraRilevazioniZonaMese MRZM1

								));

/*Restituisco il risultato*/
RETURN(_zona_preferita_mese);
END $$
DELIMITER ; 

/*implemento una stored funcion che dato un animale mi conta quante volte l'animale è stato rilevato
 in ogni zona, e mi restituisce la zona (o più) in cui è stato rilevato più volte nell'ultima setimana*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_zona_preferita_settimana;
CREATE FUNCTION _calcola_zona_preferita_settimana(_animale)
RETURNS VARCHAR NOT DETERMINISTIC
BEGIN
/*Controllo che l'animale sia andato almeno una volta al pascolo*/
DECLARE validA INTEGER DEFAULT 0;
/*Dichiaro la variabile risultato*/
DECLARE _zona_preferita_settimana VARCHAR(255) DEFAULT '';

SET validA = (
				SELECT COUNT(*)
				FROM Rilev_GPS
				WHERE Id_animale= _animale
				);
/*Creo una view che per ogni zona in cui è stato l'animale, mostra il numero di rilevazioni effettuate lì,
nell'ultima settimana*/
CREATE OR REPLACE VIEW MostraRilevazioniZonaSett AS 
SELECT RGPS.Id_ZonaSett AS Zona, COUNT(*) AS RilevazioniZonaSett
FROM Rilev_GPS RGPS
WHERE 	RGPS.Id_animale = _animale
		AND RGPS.Data BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 WEEK
GROUP BY RGPS.Id_Zona;

/*Seleziono le zone parimerito in cui sono state effettuate più rilevazioni*/
SET _zona_preferita_settimana= (SELECT GROUP_CONCAT(MRZ.ZonaSett)
									FROM MostraRilevazioniZonaSett MRZS
									WHERE MRZS.RilevazioniZonaSett = (SELECT MAX(MRZS1.RilevazioniZonaSett)
																		FROM MostraRilevazioniZonaSett MRZS1));
/*Restituisco il risultato*/
RETURN (_zona_preferita_settimana);
END $$
DELIMITER ; 
/*Inserisco i dati nella Materialized view*/
INSERT INTO MV_Pascolo
			SELECT  Id_animale,
					_zona_preferita_sempre(Id_animale),
					_zona_preferita_mese(Id_animale),
					_zona_preferita_settimana(Id_animale)
			FROM Rilev_GPS
			GROUP BY Id_animale;

/*Gestisco l'aggiornamento della materialized view*/
DROP PROCEDURE IF EXISTS refresh_MV_Pascolo;
DELIMITER $$
CREATE PROCEDURE refresh_MV_Pascolo(OUT esito INTEGER)
BEGIN
/*esito vale 1 se si verifica un errore*/
DECLARE esito INTEGER DEFAULT 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
SET esito = 1;
SELECT 'Impossibile aggiornare la materialized view';
END; 
/*flushing della materialized view*/
TRUNCATE TABLE MV_Pascolo;

/*full refresh*/
INSERT INTO MV_Pascolo
			SELECT  Id_animale,
					_zona_preferita_sempre(Id_animale),
					_zona_preferita_mese(Id_animale),
					_zona_preferita_settimana(Id_animale)
			FROM Rilev_GPS
			GROUP BY Id_animale;

END $$
DELIMITER ;

/*implemento una stored procedure, che data in ingresso una data ed un intero K, restituisce le k zone in cui
ciascun animale ha preferito stare a partire da quella data */
DELIMITER $$
DROP PROCEDURE IF EXISTS mostra_zone_piu_visitate;
CREATE PROCEDURE mostra_zone_piu_visitate(	IN _data DATE, 
											IN _k INT,
											IN _animale INT
                                            OUT _zone_più_visitate VARCHAR(255)
                                            )
BEGIN
/*Controllo la validità dell'animale in ingresso: deve essere andato almeno una volta al pascolo*/
DECLARE validA INTEGER DEFAULT 0;

SET validA = (
				SELECT COUNT(*)
				FROM Rilev_GPS
				WHERE Id_animale= _animale
				);
/*Creo una view che per ogni zona in cui è stato l'animale, mostra il numero di rilevazioni effettuate lì,
a partire dalla data ricevuta in ingresso*/
CREATE OR REPLACE VIEW MostraQuanteRilevazioni AS 
SELECT RGPS.Id_Zona AS Zona, COUNT(*) AS RilevazioniZona
FROM Rilev_GPS RGPS
WHERE 	RGPS.Id_animale = _animale
		AND RGPS.Data BETWEEN CURRENT_DATE AND _data
GROUP BY RGPS.Id_Zona
/*Prendo le prime k zone che hanno l'indice RilevazioniZona più alto*/
SET _zone_più_visitate = (SELECT GROUP_CONCAT(MQR.Zona)
								FROM MostraQuanteRilevazioni MQR
								ORDER BY RilevazioniZona DESC
								LIMIT _k);

END $$
DELIMITER ; 

/*------------------------------------------------------------------------------------------------------*/

/*Analisi delle vendite*/

/*Creo una materialized view MV_Analisi_Vendite_Formaggi */
DROP TABLE IF EXISTS MV_Analisi_Vendite_Formaggi;
CREATE TABLE MV_Analisi_Vendite_Formaggi(
NomeFormaggio CHAR(50) DEFAULT '',
PercInvendutiSempre DOUBLE DEFAULT 0,
PercInvendutiMese DOUBLE DEFAULT 0,
PercInvendutiSettimana DOUBLE DEFAULT 0
) ENGINE = InnoDB, CHARSET latin1;

/*Creo una materialized view MV_Analisi_Vendite_Fascia */
DROP TABLE IF EXISTS MV_Analisi_Vendite_Fascia;
CREATE TABLE MV_Analisi_Vendite_Fascia (
FasciaPrezzo VARCHAR(20) DEFAULT '',
PercInvendutiSemprePrezzo DOUBLE DEFAULT 0,
PercInvendutiMesePrezzo DOUBLE DEFAULT 0,
PercInvendutiSettimanaPrezzo DOUBLE DEFAULT 0
) ENGINE = InnoDB, CHARSET latin1;

/*Creo una tabella Promozioni */
DROP TABLE IF EXISTS Promozioni;
CREATE TABLE Promozioni(
NomeFormaggio CHAR(50) DEFAULT '',
TipoPromozione VARCHAR(255) DEFAULT ''
) ENGINE = InnoDB, CHARSET latin1;

/*Creo una stored function che dato in ingresso un tipo di formaggio, analizza le view e in uscita
restituisce il tipo di proozione che sarebbe meglio applicare per quel formaggio*/
DELIMITER $$
DROP FUNCTION IF EXISTS _trova_sconto;
CREATE FUNCTION _trova_sconto(_tipo CHAR(50))
RETURNS VARCHAR NOT DETERMINISTIC
BEGIN
DECLARE _tipo_sconto VARCHAR(100) DEFAULT '';

/*Creo una view che mostra la fascia di prezzo del prodotto preso in ingresso*/
CREATE OR REPLACE VIEW MostraTipiPrezzo AS
SELECT P.Nome, P.FasciaPrezzo AS Fascia
FROM Prodotto P 
WHERE P.Nome = _tipo;

/*Accedo alla MV_Fascia e controllo a quale casistica appartiene la fascia di prezzo del prodotto in esame*/
FROM MV_Analisi_Vendite_Fascia MVP INNER JOIN MostraTipiPrezzo MTP ON MVP.FasciaPrezzo = MTP.Fascia
IF MVP.PercInvendutiMesePrezzo > 0.4 THEN
	SET _tipo_sconto = 'Prendi 3 paghi 2';
		ELSE SET _tipo_sconto = 'Prendi 2 paghi 1';
		ELSE IF MVP.PercInvendutiSettimanaPrezzo > 0.4
			SET _tipo_sconto = 'Sconto 5%';
			ELSE SET _tipo_sconto = 'Sconto 2.5%';
				ELSE IF MVP.PercInvendutiSemprePrezzo > 0.4
			SET _tipo_sconto = 'Sconto 75%';
			ELSE SET _tipo_sconto = 'Sconto 50%';
END IF;

RETURN(_tipo_sconto);
END $$
DELIMITER ;

/*Creo una stored function che dato in ingresso un tipo di formaggio, calcoli la percentuale di unità
che sono rimaste invendute da sempre, rispetto a quelle che sono state prodotte da sempre*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_invendute_sempre_unita;
CREATE FUNCTION _calcola_invendute_sempre_unita(_tipo CHAR(50))
RETURNS DOUBLE NOT DETERMINISTIC
BEGIN
/*dichiaro la variabile risultato*/
DECLARE Invendute_Sempre_Unita DOUBLE DEFAULT 0;
DECLARE _quante_prodotte_sempre INT DEFAULT 0;
DECLARE _quante_vendute_sempre INT DEFAULT 0;

/*Conto tutte le unità di quel tipo che sono state prodotte da sempre*/
SET _quante_prodotte_sempre = (
						SELECT COUNT(*)
						FROM Unita U
						WHERE U.Nome = _tipo 
						);

/*Conto tutte le unità di quel tipo che sono state vendute da sempre*/
SET _quante_vendute_sempre = (
						SELECT COUNT(*)
						FROM Unita U
						WHERE U.Nome = _tipo 
							AND U.Stato = 'venduto'
						);
                        
SET Invendute_Sempre_Unita = (_quante_prodotte_sempre-_quante_vendute_sempre)/_quante_prodotte_sempre;

/*Restituisco il risultato*/
RETURN(Invendute_Sempre_Unita);
END $$
DELIMITER ;

/*Creo una stored function che dato in ingresso un tipo di formaggio, calcoli la percentuale di unità
che sono rimaste invendute nell'ultimo mese, rispetto a quelle che sono state prodotte nell'ultimo mese*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_invendute_mese_unita;
CREATE FUNCTION _calcola_invendute_mese_unita(_tipo CHAR(50))
RETURNS DOUBLE NOT DETERMINISTIC
BEGIN
/*dichiaro la variabile risultato*/
DECLARE Invendute_Mese_Unita DOUBLE DEFAULT 0;
DECLARE _quante_prodotte_mese INT DEFAULT 0;
DECLARE _quante_vendute_mese INT DEFAULT 0;

/*Conto tutte le unità di quel tipo che sono state prodotte nell'ultimo mese*/
SET _quante_prodotte_mese = (
						SELECT COUNT(*)
						FROM Unita U INNER JOIN Lotto L ON U.Id_Lotto = L.Id_Lotto
						WHERE U.Nome = _tipo 
							AND L.Data_prod BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 MONTH
						);

/*Conto tutte le unità di quel tipo che sono state vendute nell'ultimo mese*/
SET _quante_vendute_mese = (
						SELECT COUNT(*)
						FROM Unita U INNER JOIN Lotto L ON U.Id_Lotto = L.Id_Lotto
						WHERE U.Nome = _tipo 
							AND U.Stato = 'venduto'
                            AND L.Data_prod BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 MONTH
						);
                        
SET Invendute_Mese_Unita =(_quante_prodotte_mese-_quante_vendute_mese)/_quante_prodotte_mese;


/*Restituisco il risultato*/
RETURN(Invendute_Mese_Unita);
END $$
DELIMITER ;

/*Creo una stored function che dato in ingresso un tipo di formaggio, calcoli la percentuale di unità
che sono rimaste invendute nell'ultima settimana, rispetto a quelle che sono state prodotte nell'ultima 
settimana*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_invendute_sett_unita;
CREATE FUNCTION _calcola_invendute_sett_unita(_tipo CHAR(50))
RETURNS DOUBLE NOT DETERMINISTIC
BEGIN
/*dichiaro la variabile risultato*/
DECLARE Invendute_Sett_Unita DOUBLE DEFAULT 0;
DECLARE _quante_prodotte_sett INT DEFAULT 0;
DECLARE _quante_vendute_sett INT DEFAULT 0;

/*Conto tutte le unità di quel tipo che sono state prodotte nell'ultima settimana*/
SET _quante_prodotte_sett = (
						SELECT COUNT(*)
						FROM Unita U INNER JOIN Lotto L ON U.Id_Lotto = L.Id_Lotto
						WHERE U.Nome = _tipo 
							AND L.Data_prod BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 WEEK
						);

/*Conto tutte le unità di quel tipo che sono state vendute nell'ultima settimana*/
SET _quante_vendute_sett = (
						SELECT COUNT(*)
						FROM Unita U INNER JOIN Lotto L ON U.Id_Lotto = L.Id_Lotto
						WHERE U.Nome = _tipo 
							AND U.Stato = 'venduto'
                            AND L.Data_prod BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 WEEK
						);
                        
SET Invendute_Sett_Unita = (_quante_prodotte_sett-_quante_vendute_sett)/_quante_prodotte_sett;

/*Restituisco il risultato*/
RETURN(Invendute_Sett_Unita);
END $$
DELIMITER ;

/*Creo una stored function che data in ingresso una fascia di prezzo, calcoli la percentuale di unità
che sono rimaste invendute da sempre, rispetto a quelle che sono state prodotte da sempre*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_invendute_sempre_prezzo;
CREATE FUNCTION _calcola_invendute_sempre_prezzo(_fascia_prezzo VARCHAR(20))
RETURNS DOUBLE NOT DETERMINISTIC
BEGIN
/*dichiaro la variabile risultato*/
DECLARE Invendute_Sempre_Prezzo DOUBLE DEFAULT 0;
DECLARE _quanti_prodotti_sempre INT DEFAULT 0;
DECLARE _quanti_venduti_sempre INT DEFAULT 0;

/*Conto tutte le unità con quella fascia di prezzo che sono state prodotte da sempre*/
SET _quanti_prodotti_sempre = (	
								SELECT COUNT(*)
								FROM Unita U NATURAL JOIN Prodotto P 
                                WHERE P.FasciaPrezzo = _fascia_prezzo
							);

/*Conto tutte le unità con quella fascia di prezzo che sono state vendute da sempre*/
SET _quanti_venduti_sempre = (
								SELECT COUNT(*)
								FROM Unita U NATURAL JOIN Prodotto P
								WHERE P.FasciaPrezzo = _fascia_prezzo 
									AND U.Stato = 'venduto'
								);
                        
SET Invendute_Sempre_Prezzo = (_quanti_prodotti_sempre-_quanti_venduti_sempre)/_quanti_prodotti_sempre;


/*Restituisco il risultato*/
RETURN(Invendute_Sempre_Prezzo);
END $$
DELIMITER ;

/*Creo una stored function che data in ingresso una fascia di prezzo, calcoli la percentuale di unità
che sono rimaste invendute nell'ultimo mese, rispetto a quelle che sono state prodotte nell'ultimo mese*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_invendute_mese_prezzo;
CREATE FUNCTION _calcola_invendute_mese_prezzo(_prezzo DOUBLE)
RETURNS DOUBLE NOT DETERMINISTIC
BEGIN
/*dichiaro la variabile risultato*/
DECLARE Invendute_Mese_Prezzo DOUBLE DEFAULT 0;
DECLARE _quanti_prodotti_mese INT DEFAULT 0;
DECLARE _quanti_venduti_mese INT DEFAULT 0;

/*Conto tutte le unità con quella fascia di prezzo che sono state prodotte nell'ultimo mese*/
SET _quanti_prodotti_mese = (	
								SELECT COUNT(*)
								FROM Lotto L INNER JOIN Unita U ON L.Id_Lotto = U.Id_Lotto 
									NATURAL JOIN Prodotto P 
                                WHERE P.FasciaPrezzo = _fascia_prezzo
									AND L.Data_prod BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 MONTH
							);

/*Conto tutte le unità con quella fascia di prezzo che sono state vendute nell'ultimo mese*/
SET _quanti_venduti_mese = (
								SELECT COUNT(*)
								FROM Lotto L INNER JOIN Unita U ON L.Id_Lotto = U.Id_Lotto
									NATURAL JOIN Prodotto P
								WHERE P.FasciaPrezzo = _fascia_prezzo 
									AND U.Stato = 'venduto'
                                    AND L.Data_prod BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 MONTH
								);
                        
SET Invendute_Mese_Prezzo = (_quanti_prodotti_mese-_quanti_venduti_mese)/_quanti_prodotti_mese;

/*Restituisco il risultato*/
RETURN(Invendute_Mese_Prezzo);
END $$
DELIMITER ;
/*Creo una stored function che data in ingresso una fascia di prezzo, calcoli la percentuale di unità
che sono rimaste invendute nell'ultima settimana, rispetto a quelle che sono state prodotte nell'ultima 
settimana*/
DELIMITER $$
DROP FUNCTION IF EXISTS _calcola_invendute_sett_prezzo;
CREATE FUNCTION _calcola_invendute_sett_prezzo(_prezzo DOUBLE)
RETURNS DOUBLE NOT DETERMINISTIC
BEGIN
/*dichiaro la variabile risultato*/
DECLARE Invendute_Sett_Prezzo DOUBLE DEFAULT 0;
DECLARE _quanti_prodotti_sett INT DEFAULT 0;
DECLARE _quanti_venduti_sett INT DEFAULT 0;

/*Conto tutte le unità con quella fascia di prezzo che sono state prodotte nell'ultima settimana*/
SET _quanti_prodotti_sett = (	
								SELECT COUNT(*)
								FROM Lotto L INNER JOIN Unita U ON L.Id_Lotto = U.Id_Lotto 
									NATURAL JOIN Prodotto P 
                                WHERE P.FasciaPrezzo = _fascia_prezzo
									AND L.Data_prod BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 WEEK
							);

/*Conto tutte le unità con quella fascia di prezzo che sono state vendute nell'ultima settimana*/
SET _quanti_venduti_sett = (
								SELECT COUNT(*)
								FROM Lotto L INNER JOIN Unita U ON L.Id_Lotto = U.Id_Lotto
									NATURAL JOIN Prodotto P
								WHERE P.FasciaPrezzo = _fascia_prezzo 
									AND U.Stato = 'venduto'
                                    AND L.Data_prod BETWEEN CURRENT_DATE AND CURRENT_DATE - INTERVAL 1 WEEK
								);
                        
SET Invendute_Sett_Prezzo = (_quanti_prodotti_sett-_quanti_venduti_sett)/_quanti_prodotti_sett;

/*Restituisco il risultato*/
RETURN(Invendute_Sett_Prezzo);
END $$
DELIMITER ;

/*Inserisco i valori nella MV_Analisi_Vendite_Formaggi*/
INSERT INTO MV_Analisi_Vendite_Formaggi
SELECT 	F.Nome,
		_calcola_invendute_sempre_unita(F.Nome),
        _calcola_invendute_mese_unita(F.Nome),
        _calcola_invendute_sett_unita(F.Nome)
FROM Formaggio F
GROUP BY F.Nome;

/*Inserisco i valori nella MV_Analisi_Vendite_Fascia*/
INSERT INTO MV_Analisi_Vendite_Fascia
SELECT 	P.FasciaPrezzo,
		_calcola_invendute_sempre_prezzo(P.FasciaPrezzo),
        _calcola_invendute_mese_prezzo(P.FasciaPrezzo),
        _calcola_invendute_sett_prezzo(P.FasciaPrezzo)
FROM Prodotto P
GROUP BY P.FasciaPrezzo;

/*Creo un event che ogni settimana aggiorna la tabella Promozioni in base all'analisi delle MV riguardanti
la settimana precedente*/
DELIMITER $$
CREATE EVENT _aggiorna_promozioni
ON SCHEDULE EVERY 1 WEEK
DO(
/*Seleziono i tipi di formaggio su cui verranno applicate promozioni*/
CREATE OR REPLACE VIEW MostraTipi AS
SELECT MVF.NomeFormaggio AS DaScontare
FROM MV_Analisi_Vendite_Formaggi MVF
WHERE MVF.PercInvendutiSettimana > 0.4
	AND MVF.PercInvendutiMese > 0.3;

INSERT INTO Promozioni
SELECT 	MT.DaScontare,
		_trova_sconto(MT.DaScontare) 
FROM MostraTipi MT
GROUP BY MT.DaScontare
);

DELIMITER ;

/*Aggiornamento MV_Analisi_Vendite_Formaggi */
DROP PROCEDURE IF EXISTS refresh_MV_Analisi_Vendite_Formaggi;
DELIMITER $$
CREATE PROCEDURE refresh_MV_Analisi_Vendite_Formaggi(OUT esito INTEGER)
BEGIN
/*esito vale 1 se si verifica un errore*/
DECLARE esito INTEGER DEFAULT 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
SET esito = 1;
SELECT 'Impossibile aggiornare la materialized view';
END; 
/*flushing della materialized view*/
TRUNCATE TABLE MV_Analisi_Vendite_Formaggi;

/*full refresh*/
INSERT INTO MV_Analisi_Vendite_Formaggi
SELECT 	F.Nome,
		_calcola_invendute_sempre_unita(F.Nome),
        _calcola_invendute_mese_unita(F.Nome),
        _calcola_invendute_sett_unita(F.Nome)
FROM Formaggio F
GROUP BY F.Nome;


END $$
DELIMITER ;
/*Aggiornamento MV_Analisi_Vendite_Fascia  */
DROP PROCEDURE IF EXISTS refresh_MV_Analisi_Vendite_Fascia;
DELIMITER $$
CREATE PROCEDURE refresh_MV_Analisi_Vendite_Fascia(OUT esito INTEGER)
BEGIN
/*esito vale 1 se si verifica un errore*/
DECLARE esito INTEGER DEFAULT 0;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
SET esito = 1;
SELECT 'Impossibile aggiornare la materialized view';
END; 
/*flushing della materialized view*/
TRUNCATE TABLE MV_Analisi_Vendite_Fascia;

/*full refresh*/
INSERT INTO MV_Analisi_Vendite_Fascia
SELECT 	P.FasciaPrezzo,
		_calcola_invendute_sempre_prezzo(P.FasciaPrezzo),
        _calcola_invendute_mese_prezzo(P.FasciaPrezzo),
        _calcola_invendute_sett_prezzo(P.FasciaPrezzo)
FROM Prodotto P
GROUP BY P.FasciaPrezzo;


END $$
DELIMITER ;