USE FarmHouse;
SET group_concat_max_len = 2048;

/* OPERAZIONE 1: Prescrizione di un esame diagnostico e di una terapia a seguito di un controllo durante 
una gravidanza */

/*creo una procedura per l'inserimento di un esame*/
DROP PROCEDURE IF EXISTS inserisci_esame;
DELIMITER $$
CREATE PROCEDURE inserisci_esame(IN _date DATE, IN _nome VARCHAR(20), IN _macchinario VARCHAR(50), 
								 IN _descr VARCHAR(100), IN _controllo INT)
	BEGIN
		INSERT INTO Esame(Id_Esame, Data, Nome, Macchinario, Descr_Testuale, Id_Controllo)
			VALUES(_date, _nome, _macchinario, _descr, _controllo); 
	END $$
DELIMITER;

/*creo una procedura per l'inserimento di una terapia*/
DELIMITER $$
DROP PROCEDURE IF EXISTS inserisci_terapia;
CREATE PROCEDURE inserisci_terapia(IN _terapia INT, IN _animale INT, IN _patologia INT, IN _date DATE, 
								   IN _durata INT, IN _vet INT, IN _esame INT)
	BEGIN
		INSERT INTO Terapia(Id_Terapia, Id_Animale, Id_Pat, Id_Vet, Id_Esame, Data_In, Durata)
			VALUES(_terapia, _animale,_patologia, _vet, _esame, _date, _durata); 
	END $$
DELIMITER;

/*creo una procedura per l'inserimento di una posologia*/
DELIMITER $$
DROP PROCEDURE IF EXISTS inserisci_posologia;
CREATE PROCEDURE inserisci_posologia(IN _animale INT, IN _patologia INT, IN _terapia INT, IN _gg_pausa INT, 
									 OUT _posologia INT)
	BEGIN
		INSERT INTO Posologia(Id_Posologia, Id_Animale, Id_Pat, Id_Terapia, Gg_Pausa)
			VALUES(_animale, _patologia, _terapia, _gg_pausa); 
		SET _posologia = (
							SELECT Id_Posologia 
                            FROM Posologia 
                            WHERE Id_Animale=_animale 
								AND Id_Pat=_patologia 
                                AND Id_Terapia=_terapia
							);
	END $$
DELIMITER;

/*creo una procedura per l'inserimento di una somministrazione*/
DELIMITER $$
DROP PROCEDURE IF EXISTS inserisci_somministrazione;
CREATE PROCEDURE inserisci_somministrazione(IN _posologia INT, IN _animale INT, IN _patologia INT, 
											IN _terapia INT, IN _gg_pausa INT, IN _ora TIME, IN _dosaggio INT, 
                                            IN _farmaco INT, IN _integratore INT)
	BEGIN
		INSERT INTO Somministrazione(Id_Posologia Id_Terapia, Id_Animale, Id_Pat, Id_Vet, Id_Esame, Data_In, Durata)
			VALUES(_posologia, _terapia, _animale,_patologia, _vet, _esame, _date, _durata); 
	END $$
DELIMITER;
	
/* Il seguente TRIGGER viene invocato nel momento in cui il controllo viene effettuato nella stessa Data 
di programmazione */
DELIMITER $$
DROP TRIGGER IF EXISTS prescrizione_esame_insert;
CREATE TRIGGER prescrizione_esame_insert
AFTER INSERT ON Controllo FOR EACH ROW
	BEGIN
		/* Dichiarazione parametri */
        DECLARE _date DATE;
        DECLARE _nome VARCHAR(20);
        DECLARE _macchinario VARCHAR(50);
        DECLARE _descri VARCHAR(100);
        
		/* Set parametri esame */
		SET _date="2020/01/20";
        SET _nome="Radiografia";
        SET _macchinario="Macchina Radiografica";
        SET _descr="Radiografia addome";
        
		IF NEW.Esito="negativo" AND NEW.Data_Prog=NEW.'Data' THEN
			call inserisci_esame(_date, _nome, _macchinario, _descr, NEW.Id_Controllo);
		END IF;
	END $$
DELIMITER;

/* Il seguente TRIGGER viene invocato nel momento in cui il controllo viene effettuato in una Data diversa dalla
 Data di programmazione */
DELIMITER $$
DROP TRIGGER IF EXISTS prescrizione_esame_update;
CREATE TRIGGER prescrizione_esame_update
AFTER UPDATE ON Controllo FOR EACH ROW
	BEGIN
		/* Dichiarazione parametri */
        DECLARE _date DATE;
        DECLARE _nome VARCHAR(20);
        DECLARE _macchinario VARCHAR(50);
        DECLARE _descr VARCHAR(100);
        
		/* Set parametri esame */
		SET _date="2020/01/20";
        SET _nome="Radiografia";
        SET _macchinario="Macchina Radiografica";
        SET _descr="Radiografia addome";
              
		IF NEW.Esito="negativo" AND NEW.Data IS NOT NULL AND OLD.DataProg<=NEW.Data THEN
			call inserisci_esame(_date, _nome, _macchinario, _descr, NEW.Id_Controllo);
		END IF;
	END$$
DELIMITER ;

/* Questo TRIGGER viene invocato dopo un esame diagnostico ogni volta che viene inserita una patologia*/
DELIMITER $$
DROP TRIGGER IF EXISTS prescrizione_terapia_insert;
CREATE TRIGGER prescrizione_terapia_insert
AFTER INSERT ON Patologia FOR EACH ROW
	BEGIN
		/* Dichiarazione parametri */
        DECLARE _durata INT DEFAULT 0;
        DECLARE _date DATE;
        DECLARE _vet INT DEFAULT 0;
        DECLARE validV INT DEFAULT 0;
        DECLARE validA INT DEFAULT 0;
        DECLARE esiste INT DEFAULT 0;
        DECLARE _gg_pausa INT DEFAULT 0;
        DECLARE _dosaggio INT DEFAULT 0;
        DECLARE _ora TIME;
        DECLARE _farmaco INT DEFAULT 0;
        DECLARE _integratore INT DEFAULT 0;
        /* Set parametri terapia */
        SET _durata=30;
		SET _date="2020/01/30";
        SET _vet=1;
        SET _farmaco=1;
        SET _integratore=1;
        SET _ora="19:30:00";
        SET _dosaggio=2;
        SET _gg_pausa=3;
        
       /*controllo la validità del veterinario*/ 
        SET validV= (
						SELECT COUNT(*) 
                        FROM Veterinario 
                        WHERE Id_Vet=_vet
					);        
                    
		/*seleziono l'id dell'animale che ha ricevuto l'esame che ho precedentemente inserito*/
		SET _animale= (
						SELECT C.Gen1 
                        FROM Controllo C NATURAL JOIN Esame E 
								
						WHERE Id_Esame=NEW.Id_Esame
                        );
		/*controllo se l'id dell'animale appena trovato, corrisponde ad una femmina del DB*/
        SET validA= (
						SELECT COUNT(*) 
                        FROM Animale  
                        WHERE Id_Animale=_animale 
                            AND Sesso="Femmina"
					);
     /*se l'animale e il veterinario sono validi, procedo con la chiamata delle procedure */
        IF (validA=1 AND validV=1) THEN
			call inserisci_terapia(1, _animale, NEW.Id_Pat, _date, _durata, _vet, NEW.Id_Esame);
            call inserisci_posologia(_animale, NEW.Id_Pat, 1, _gg_pausa, @_posologia);
            call inserisci_somministrazione(_posologia, _animale, NEW.Id_Pat, 1, _gg_pausa, _ora, _dosaggio, 
											_farmaco, _integratore);
		END IF;
	END $$
DELIMITER ;
/* --------------------------------------------------------------------------------------------------------------------------------------------------------- */

/* OPERAZIONE 2:  Controllo pulizia locale */

SET GLOBAL event_scheduler = ON;

/*creo una procedura per l'inserimento di una Rilevazione Locale*/ 
DROP PROCEDURE IF EXISTS inserisci_rilevazione;
DELIMITER $$
CREATE PROCEDURE inserisci_rilevazione(IN _livelloSporco DOUBLE, IN _valoreComposti DOUBLE,
										IN _sporcoMax DOUBLE, IN _compostiMax DOUBLE, IN _locale INT)
BEGIN
	INSERT INTO Rilevazione_Locale(Id_Ril, Timestamp, Liv_sporco, Val_composti, Sporco_Max, Composti_Max, Id_loc)
					VALUES (CURRENT_TIMESTAMP, _livelloSporco, _valoreComposti, _sporcoMax, _compostiMax, _locale);
END $$
DELIMITER;

/*Creo una procedura per l'inserimento di una richiesta di Pulizia*/
DROP PROCEDURE IF EXISTS inserisci_pulizia;
DELIMITER $$
CREATE PROCEDURE inserisci_pulizia( IN _rilevazione INT, IN _locale INT, IN _mode VARCHAR(20), 
									IN _stato VARCHAR(10))
	BEGIN
		INSERT INTO Pulizia(Id_Ril, Id_Locale, Mode, Stato, Firma_Dipendente) 
					VALUES (_rilevazione, _locale, _mode, _stato, NULL);
	END $$
DELIMITER;

/*Il seguente trigger viene invocato prima di inserire una nuova rilevazione del locale;
dobbiamo controllare se i valori rilevati superano o meno la soglia massima*/
DELIMITER $$
DROP TRIGGER IF EXISTS rilevazione_locale_insert;
CREATE TRIGGER rilevazione_locale_insert
BEFORE INSERT ON Rilevazione_Locale FOR EACH ROW 
BEGIN
IF NEW.Liv_sporco>NEW.Sporco_Max OR NEW.Val_composti>NEW.Composti_Max THEN
	call inserisci_rilevazione(_livelloSporco, _valoreComposti, _sporcoMax,
								_compostiMax, _locale);
END $$
DELIMITER; 

DELIMITER $$
DROP TRIGGER IF EXISTS richiesta_pulizia_insert;
CREATE TRIGGER richiesta_pulizia_insert
AFTER INSERT ON Rilevazione_Locale FOR EACH ROW
	BEGIN
		DECLARE _mode VARCHAR(20);
        DECLARE esiste INT DEFAULT 0;
        SET _mode="meccanicamente";
        
        /* Controllo se esiste già una richiesta di pulizia pendente per quel locale, se esiste non ne inserisco
        un'altra */
        SET esiste= (
						SELECT COUNT(*) 
						FROM Pulizia 
                        WHERE Id_loc=NEW.Id_loc 
                        AND Stato="richiesto"
                        );
        IF esiste=1 THEN
        SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = "Esiste già una richiesta di pulizia per questo locale, non è possibile inserirne 
							un'altra";
		ELSE call inserisci_pulizia(NEW.Id_ril, NEW.Id_loc, _mode, 'richiesto');
		END IF;
/*se ho inserito una richiesta di pulizia con mode = meccanicamente, creo un evento che dopo 2 ore dall'inserimento
, quindi dopo 2 ore dal timestamp, mi aggiorna la pulizia ponendo lo stato = effettuato*/

	IF _mode="meccanicamente" THEN
			CREATE EVENT pulizia_meccanica_effettuata
            ON SCHEDULE AT NEW.Timestamp + INTERVAL 2 HOUR
			DO(
				UPDATE Pulizia SET Stato="effettuato" WHERE Mode="meccanicamente" AND Stato="richiesto";
			);
        END IF;
	END $$
DELIMITER ;

  

/* Questo TRIGGER viene invocato quando si deve aggiornare la pulizia per passare allo Stato di effettuato:
quando la firma non sarà più NULL, lo stato verrà posto ad effettuato (questo avviene nel caso in cui la 
modalità sia manuale  */
DELIMITER $$
DROP TRIGGER IF EXISTS pulizia_update;
CREATE TRIGGER pulizia_update
BEFORE UPDATE ON Pulizia FOR EACH ROW
	BEGIN
	
    UPDATE Pulizia
    SET NEW.Stato='Effettuato'
    WHERE 	NEW.Mode = 'Manualmente' AND 
			NEW.Firma_Dipendente<>OLD.Firma_Dipendente AND NEW.Stato=OLD.Stato;
  
    
	END $$
DELIMITER ;

/* --------------------------------------------------------------------------------------------------------------------------------------------------------- */

/* OPERAZIONE 3:  Registrazione di un cliente e creazione del suo account */

DELIMITER $$
/*Creo una procedura che mi permette di registrare un cliente, presi in ingresso i suoi dati anagrafici*/
DROP PROCEDURE IF EXISTS registra_cliente;
CREATE PROCEDURE registra_cliente(  IN CF VARCHAR(6), IN _nome CHAR(100), IN _cognome CHAR(100), 
									IN _indirizzo VARCHAR(100), IN _cartaCredito INT, IN _numCell INT, 
                                    IN _tipoDoc CHAR(50), IN _codDoc VARCHAR (50))
								  
DECLARE _nomUtGiàPresente INT DEFAULT 0;
DECLARE _CFGiàPresente INT DEFAULT 0;

/*Controllo che il nome utente scelto dall'utente non sia già presente*/
SET _nomUtGiàPresente= (
                         SELECT COUNT(*)
						 FROM Account
						 WHERE Nome_Utente= _nomeUt
					   );
                       
/*Controllo che non esista già un account associato a quell'utente*/
SET _CFGiàPresente= (
                      SELECT COUNT(*)
						 FROM Cliente_Registrato
						 WHERE CF_Cliente= CF
					   );		

/*Se è già presente un accoun associato a quell'utente, non gli permetto di crearne uno nuovo*/
ELSE IF _CFGiàPresente=1 THEN
            SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT='Cliente già registrato';
/*In tutti gli altri casi, inserisco il nuovo utente*/
ELSE IF _CFGiàPresente=0 THEN
            INSERT INTO Cliente_Registrato(CF_Cliente, Nome, Cognome, Indrizzo, Cod_Carta_Credito, Num_Cell, 
											Dt_Reg, Cod_doc, Tipo, Nome_Utente)
               VALUES (CF, _nome, _cognome, _indirizzo, _cartaCredito, _numCell, CURRENT_DATE, _codDoc, 
						_tipo)

END IF;
END$$
DELIMITER ;

DELIMITER $$
/*Creo una procedura per inserire un nuovo account*/
DROP PROCEDURE IF EXISTS creazione_account;
CREATE PROCEDURE creazione_account( IN _nomeUt VARCHAR (20), IN CF VARCHAR(6), IN _password VARCHAR(20), IN _domanda VARCHAR(50), IN _risposta VARCHAR(20))
	DECLARE _nomUtGiàPresente INT DEFAULT 0;

/*Controllo che il nome utente scelto dall'utente non sia già presente*/
	SET _nomUtGiàPresente= (
                         SELECT COUNT(*)
						 FROM Account
						 WHERE Nome_Utente= _nomeUt
					   );
	                       
	/*Se il nome utente è già presente, non inserisco il nuovo utente*/
	IF _nomUtGiàPresente=1 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT='Nome Utente già presente';
    ELSE    
		INSERT INTO Account(Nome_Utente, CF_Cliente, Psw, Domanda_Psw, Risposta_Psw)
					VALUES (_nomeUt, CF, _password, _domanda, _risposta);
END $$
DELIMITER;

DELIMITER $$
/*Creo una procedura per l'inserimento di un nuovo documento*/
DROP PROCEDURE IF EXIST creazione_Doc;
CREATE PROCEDURE creazione_Doc( IN codDoc INT, IN _tipo VARCHAR(20), IN _dataScad DATE, IN _ente VARCHAR(20), 
								IN CF VARCHAR(6))
/*Controllo se il documento è scaduto: in quel caso non inserisco, altrimenti inserisco*/
IF _dataScad<CURRENT_DATE THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT='Documento scaduto!';
ELSE
      INSERT INTO Documento(CF_Cliente, Cod_doc, Tipo, Dt_scadenza, Ente)
					VALUES (CF, codDoc, _tipo, _dataScad, _ente);
END IF;
DELIMITER;

DELIMITER $$
/*Il seguente trigger viene invocato ogni volta che inserisco un nuovo cliente, e permette di inserire nel 
DB le informazioni relative al suo account e ad un suo documento valido*/
DROP TRIGGER IF EXISTS associa_account;
CREATE TRIGGER associa_account
AFTER INSERT ON Cliente_Registrato
FOR EACH ROW
BEGIN

/* Parametri Account */
DECLARE _nomeUt VARCHAR(20) NOT NULL;
DECLARE _password VARCHAR(20) DEFAULT '';
DECLARE _domanda VARCHAR(50) DEFAULT '';
DECLARE _risposta VARCHAR(20) DEFAULT '';
SET  _nomeUt="Paolo99";
SET _password="Paolo99!";
SET _domanda="Come si chiama il tuo gatto";
SET _risposta="Tigre";

/* Parametri Documento */
DECLARE _codDoc INT;
DECLARE _tipo VARCHAR(20) DEFAULT '';
DECLARE _dataScad DATE;
DECLARE _ente VARCHAR(20) DEFAULT '';
SET _codDoc="AVPB9999";
SET _tipo="Carta d'identità";
SET _dataScad="2024-10-07";
SET  _ente="Comune";

CALL creazione_account(_nomeUt, NEW.CF_Cliente, _password, _domanda, _risposta);
CALL creazione_Doc(NEW.CF_Cliente, _codDoc, _tipo, _dataScad, _ente);
END $$
DELIMITER;

CALL registra_cliente("DEF456", "Paolo", "Bottiglia", "Via Santa Maria 9", 5333101040456789, 3388194839)
/* ---------------------------------------------------------------------------------------------------------------------------------------------------

/* OPERAZIONE 4:  Inserimento di una prenotazione per soggiorno */

/* La seguente procedure permette di verificare il tipo di cliente che effettua la prenotazione */
DROP PROCEDURE IF EXISTS tipoCliente;
DELIMITER $$
CREATE PROCEDURE  tipoCliente(IN CF VARCHAR(11), OUT tipo INT)
  BEGIN
/*se tipo è 1 allora il cliente è registrato, se 0 no */
     SET tipo= (                     
	            SELECT COUNT(*)
				FROM Cliente_Registrato
				WHERE CF_Cliente=CF
			   );
  END $$
  DELIMITER;

/* La seguente procedura permette di verificare la disponibilità delle camere per le date richieste */
DELIMITER $$
DROP PROCEDURE IF EXISTS disponibilita;
CREATE PROCEDURE disponibilita(IN arrivo DATE, IN partenza DATE, IN suite INT, IN semplici INT, OUT disp BOOLEAN)
  BEGIN
     DECLARE num_camerePerTipo INT DEFAULT 0;
	 DECLARE occupateSemplici INT DEFAULT 0;
	 DECLARE occupateSuite INT DEFAULT 0;
	 SET num_camerePerTipo=51;
     
     /*Conto il numero di suite occupate nelle date richieste*/
	 SET occupateSuite= (
	                     SELECT COUNT(DISTINCT Id_Camera)
					     FROM ( Riservazione R 
					            NATURAL JOIN 
					            Prenotazione P
					          ) NATURAL JOIN Camera C
					     WHERE C.Tipo='Suite' AND (
						        ( P.Dt_arrivo<=arrivo AND P.Dt_partenza>=partenza ) OR
						        ( P.Dt_arrivo>=arrivo AND P.Dt_partenza<=partenza ) OR
							    ( P.Dt_arrivo<arrivo AND P.Dt_partenza BETWEEN arrivo AND partenza ) OR
							    ( P.Dt_arrivo BETWEEN arrivo AND partenza AND P.Dt_partenza> partenza )
							   )
					    );
                        
	 /*Conto il numero di camere semplici occupate nelle date richieste*/
	 SET occupateSemplici= (
	                        SELECT COUNT(DISTINCT Id_Camera)
					        FROM ( Riservazione R 
					               NATURAL JOIN 
					               Prenotazione P
					             ) NATURAL JOIN Camera C
					        WHERE C.Tipo='Semplice' AND (
						           ( P.Dt_arrivo<=arrivo AND P.Dt_partenza>=partenza ) OR
						           ( P.Dt_arrivo>=arrivo AND P.Dt_partenza<=partenza ) OR
							       ( P.Dt_arrivo<arrivo AND P.Dt_partenza BETWEEN arrivo AND partenza ) OR
							       ( P.Dt_arrivo BETWEEN arrivo AND partenza AND P.Dt_partenza> partenza )
							      )
					       );
	/*Controllo la disponibilità, e notifico con la variabile disp*/
	 IF (num_camerePerTipo - occupateSemplici)< semplici OR (num_camerePerTipo - occupateSuite)< suite THEN
	     SET disp = FALSE;
     ELSE 
	     SET disp = TRUE;
	 END IF;
  END $$
  DELIMITER;

/*La seguente procedura permette di inserire la prenotazione */
DELIMITER $$
DROP PROCEDURE IF EXISTS inserisci_prenotazione;
CREATE PROCEDURE inserisci_prenotazione(	IN CodFiscale VARCHAR(6), IN data_arrivo DATE, IN data_partenza DATE, 
											IN nsuite INT, IN nsemplici INT)
	BEGIN
		/*Dichiaro una variabile che contiene il costo totale della prenotazione*/
		DECLARE costoTot DOUBLE DEFAULT 0;
        /*Dichiaro una variabile che contiene la caparra associata alla prenotazione*/
		DECLARE cap DOUBLE DEFAULT 0;
	  
		/* Controllo che siano disponbili camere con i dati inseriti, se c'è disponibilità inserisco una 
        prenotazione */
		call disponibilita(data_arrivo, data_partenza, nsuite, nsemplici, @disp);
		SET costoTot=(
					(DATEDIFF(data_partenza,data_arrivo)*nsemplici*20
                    +DATEDIFF(data_partenza,data_arrivo)*nsuite*40)
                    );
		CALL tipoCliente(CodFiscale,@tipo);
        
        /*Se il cliente è registrato, non è tenuto a versare la caparra in anticipo*/
		IF @tipo=1 THEN
				  SET cap=0;
		ELSE 
        
        /*Se il cliente non è registrato, allora deve pagare anticipatamente il 50% dell'intera prenotazione*/
				  SET cap=costoTot/2;
		 
		IF @disp IS TRUE THEN
			INSERT INTO Prenotazione (Id_Prenotazione, Dt_Prenotazione, Dt_arrivo, Dt_partenza, Costo_totale_sogg, 
										Caparra, CF_Cliente)
							   VALUES (CURRENT_DATE,data_arrivo, data_partenza,costoTot,cap,CodFiscale );
				
		END IF;  
	END $$  
DELIMITER;

call inserisci_prenotazione("ABC123","2020-02-23","2020-02-28",1,2);

/*---------------------------------------------------------------------------------------------------------------------------------------------------

/* OPERAZIONE 5: Inserimento di un nuovo ordine e calcolo della spesa totale*/
 
DELIMITER $$
/*Creo una procedura che permette l'inserimento di un ordine*/
DROP PROCEDURE IF EXISTS inserisci_ordine;
CREATE PROCEDURE inserisci_ordine(IN prossimo_id_ordine INT, IN _utente INT, IN _comp INT, IN _tot DOUBLE, IN _stato VARCHAR(20), IN _pagato VARCHAR(2))
	BEGIN       
		INSERT INTO Ordine(Id_Ordine, Num_Composizioni, Data_Ordine, Prezzo_Totale, Stato_Ordine, Pagato)
					VALUES(prossimo_id_ordine,_utente,_comp,CURRENT_DATE,_tot,_stato,_pagato);
	END $$
	DELIMITER ;
 
 DELIMITER $$
 /*Creo una procedura che mi permette di calcolare i parametri dell'ordine, come il costo totale, il numero
 di composizioni ecc..*/
 DROP PROCEDURE IF EXISTS creazione_ordine;
 CREATE PROCEDURE creazione_ordine(IN nomUt VARCHAR(50))
	BEGIN
		 DECLARE _nomUtValido INT DEFAULT 0;
		 DECLARE _totale INT DEFAULT 0;
		 DECLARE _num_composizioni INT DEFAULT 0;
		 DECLARE _numero_spedibili INT DEFAULT 0;
         /*Ammettiamo che di default, l'utente paga non appena viene inserito l'ordine*/
         DECLARE _pagato VARCHAR(2) DEFAULT "Si";
         /*Ammettiamo che di default, l'ordine venga subito processato*/
		 DECLARE _stato VARCHAR(20) DEFAULT "in processazione";
         
         /*Controllo se il nome utente preso in ingresso è valido*/
         	SET _numUtValido=(	
							SELECT COUNT(*) 
							FROM Account
							WHERE Nome_Utente=nomUt
                            );

		/*Creo una view che mostra: tipo di prodotto (=composizione), somma parziale prezzo (quindi per tipo), 
        conto dei prodotti per tipo (=numero prodotti della composizione) calcolando prima il nuovo Id_ordine*/
         SET @prossimo_id_ordine=(
								SELECT Id_Ordine+1 
								FROM Ordine 
								WHERE Nome_Utente=_utente 
								ORDER BY Id_Ordine DESC 
								LIMIT 1
								);
		CREATE OR REPLACE VIEW Mostra_Parziali AS
		SELECT P.Nome AS Tipo,SUM(P.Prezzo) AS Parziale, COUNT(P.Id_Unita) AS Quanti
		FROM Composizione_Ordine CO INNER JOIN Prodotto P 
					ON CO.Id_Composizione=P.Id_Composizione
					AND CO.Nome_Utente = P.Nome_Utente
		WHERE P.Id_Ordine=@prossimo_id_ordine AND CO.Nome_Utente=nomUt;
		GROUP BY P.Nome;

		/*Creo una view che mostra per ogni tipo di prodotto, il numero di unità disponibili*/
        
		CREATE OR REPLACE VIEW Mostra_Disponibili AS
		SELECT MP.Tipo, COUNT(*) AS Disponibili
		FROM Unita U INNER JOIN Mostra_Parziali MP ON U.Nome=MP.Tipo
		WHERE U.Stato="disponibile";
		GROUP BY MP.Tipo;

		/*Creo una view che mostra i tipi di prodotto tali che il numero di unità richieste sia minore
        o uguale al numero di unità disponibili*/
        
		CREATE OR REPLACE VIEW Mostra_Tipi_Disponibili AS
		SELECT MP.Tipo
		FROM Mostra_Parziali MP INNER JOIN Mostra_Disponibili MD ON MP.Tipo=MD.Tipo
		WHERE MP.Quanti<=MD.Disponibili;


		/*Conto il numero di tipi di prodotto tali che il numero di unità richieste sia minore
        o uguale al numero di unità disponibili, facendo uso della view appena creata */
		SET _numero_spedibili=(SELECT COUNT(*)
								FROM Mostra_Tipi_Disponibili MTD);
                                
		/*Calcolo il costo totale dell'ordine, sommando i vari parziali calcolati per tipo di prodotto*/
		SET _totale=(SELECT SUM(Parziale)
					FROM Mostra_Parziali);
		
        /*Ricavo il numero di tipi diversi (=di composizioni) dell'ordine*/
		SET _num_composizioni= (SELECT COUNT(*)
								FROM Mostra_Parziali);
		/*Se il numero di tipi diversi (=di composizioni) dell'ordine è diverso dal numero di tipi diversi 
        spedibili, allora pongo stato = pendente, e l'ordine non può essere ancora pagato dall'utente*/
		 IF _num_composizioni<>_numero_spedibili
			SET _stato="pendente";
            SET _pagato="No";
		/*chiamo la procedura per l'inserimento dell'ordine*/
        
        /*NomUt è il parametro d'ingresso della procedura più esterna che crea l'ordine, non dovrebbe essere INOUT
        dato che ora vorrei darlo in pasto alla procedura per l'inserimento?*/
		call inserisci_ordine(@prossimo_id_ordine,nomUt,_num_composizioni,_totale,_stato,_pagato);
	END $$
DELIMITER ;

DELIMITER $$
/*Il seguente trigger viene invocato ogni volta che viene aggiornata la tabella Composizione_Ordine, 
dunque ogni volta che viene inserito un nuovo Ordine, e permette di cambiare lo stato di tante unità quante sono
quelle ordinate per ogni tipo, da disponibile a venduta*/
DROP TRIGGER IF EXISTS aggiorna_unita;
CREATE TRIGGER aggiorna_unita
AFTER INSERT ON Ordine
FOR EACH ROW
BEGIN
	DECLARE _tipo VARCHAR(20) DEFAULT '';    
    DECLARE _valido INT DEFAULT 0;
    
    /*Ogni volta che viene aggiornata una riga in Composizione Ordine, recupero il tipo dei prodotti che 
    ne fanno parte*/
	SET _tipo=(SELECT P.Nome
				FROM Composizione_Ordine CO NATURAL JOIN Prodotto P
				WHERE CO.Id_Ordine=NEW.Id_Ordine
				LIMIT 1
                );
	
    /*Conto il numero di ordini in processazione a carico dell'utente in questione*/
    SET _valido=(SELECT COUNT(*)
				FROM Ordine O 
				WHERE O.Id_Ordine=NEW.Id_Ordine 
					AND O.Nome_Utente=NEW.Nome_Utente 
                    AND O.Stato="in processazione"
				);
	/*Se a carico dell'utente c'è almeno un ordine in processazione, allora vado nella tabella Unità, e modifico
    lo stato di tante unita di quel tipo, quanti sono i prodotti ordinati di quel tipo*/
    IF _valido>0
		UPDATE Unita 
        SET Stato="venduto" 
        WHERE Nome=_tipo 
        LIMIT NEW.Qt_Prodotti;
        
	ELSE
    
    /*Altrimenti, notifico che c'è stato un problema*/
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT='Ordine non pronto!';
END $$
DELIMITER ;
call creazione_ordine("Camilla99");

 
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/* OPERAZIONE 6: Inserimento di un Animale a seguito di nascita all'interno dell'agriturismo
e inserimento dei valori registrati durante la prima visita di controllo */

DELIMITER $$
/*Creo una procedura per verificare se per una determinata specie, esiste un locale che abbia spazio a sufficienza
per allocare un animale in più rispetto a quelli che già contiene*/
DROP PROCEDURE IF EXISTS disponibilita_locale;
CREATE PROCEDURE disponibilita_locale(IN _specie VARCHAR(6), OUT _locale INT)
	
    /*Creo una view che per ogni locale adibito a contenere la specie presa in ingresso, mostri il numero di 
    animali contenuti*/
	CREATE OR REPLACE VIEW mostra_quanti AS
	SELECT Id_loc AS locale, COUNT(*) AS Contenuti
    FROM Animale
    WHERE Nome_specie=_specie
    GROUP BY Id_loc;
    
    /*Considero come locale "buono" il primo che trovo che abbia spazio*/
    SET _locale=(
				SELECT L.Id_loc
				FROM Locale L INNER JOIN mostra_quanti MQ ON L.Id_loc=MQ.locale
				WHERE L.Num_max_an>MQ.Contenuti
				LIMIT 1
                );
DELIMITER ;

DELIMITER $$
/*Creo una procedura che mi permette di inserire i dati anagrafici di un nuovo animale, nato all'interno 
dell'agriturismo*/
DROP PROCEDURE IF EXISTS inserisci_animale;
CREATE PROCEDURE inserisci_animale( IN _sesso CHAR(10),IN _gen1 INT ,IN _gen2 INT, IN dt_nasc DATE,IN _alt INT, 
									IN _peso DOUBLE, IN _specie VARCHAR(50), IN _loc INT
                                    )
DECLARE esiste_mom INT DEFAULT 0;
DECLARE esiste_dad INT DEFAULT 0;
DECLARE tentativo INT DEFAULT 0;
DECLARE esiste_gravidanza INT DEFAULT 0;

/*Verifico che gen1, ovvero la madre, sia un animale di sesso femminile valido*/
SET esiste_mom =(
	SELECT COUNT(*)
	FROM Animale
	WHERE Sesso='Femmina' AND Id_animale=_gen1
				);
/*Verifico che gen2, ovvero il padre, sia un animale di sesso maschile valido*/
SET esiste_dad = (
	SELECT COUNT(*)
	FROM Animale
	WHERE Sesso='Maschio' AND Id_animale=_gen2
				);
 /*Verifico che esista un tentativo di riproduzione tale che: gli animali partecipanti al tentativo siano 
 gli effettivi "genitori" dell'animale appena nato, lo stato del tentativo sia 1 (quindi l'animale femmina
 è effettivamente rimasta incinta), e quindi seleziono l'id del tentativo più recente rispetto a tutti 
 i tentativi che rispettano tali requisiti (rispetto alla data di nascita dell'animale)*/
 
SET tentativo=(
	SELECT Id_rip
    FROM Tentativo_Riproduzione TR1
    WHERE 	TR1.Gen1=_gen1 
			AND TR1.Gen2=_gen2 
            AND TR1.Stato=1 
            AND DATEDIFF(dt_nasc,TR1.Data)=( 
												SELECT MIN(DATEDIFF(dt_nasc,TR2.Data))
												FROM Tentativo_Riproduzione2 TR2
												WHERE TR2.Gen1=TR1.Gen1 AND TR2.Gen2=TR1.Gen2 AND TR2.Stato=1 
											)
				);

/*Verifico l'esistenza di una gravidanza conclusasi con parto, del tentativo di riproduzione di cui al punto 
precedente */

SET esiste_gravidanza=(
						SELECT COUNT(*)
						FROM Gravidanza
						WHERE 	Gen1=_gen1 
								AND Id_rip=tentativo 
                                AND Stato=1
						);
/*Se ho verificato la validità di padre, madre e gravidanza, allora posso inserire l'anagrafica del nuovo nato,
prima però devo anche verificare che ci sia spazio per lui */

IF esiste_dad=1 AND esiste_mom=1 AND esiste_gravidanza=1 THEN (
			call disponibilita_locale(_specie,@locale);
            IF @locale!=NULL THEN
				INSERT INTO Animale(Id_animale, Sesso, Id_gen1, Id_gen2, Dt_acq, Dt_arr, Data_nascita, Altezza, 
									Peso, Nome_specie, Id_loc, Partita_iva)
										VALUES (_sesso, _gen1, _gen2, NULL, NULL, dt_nasc, _alt, _peso, _specie, 
                                        @locale, NULL);
			ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT= "Non è disponibile spazio per la specie inserita!";
	   )
END IF;
END$$
DELIMITER ;

DELIMITER $$ 
/*La seguente procedura permette di inserire la prima visita di controllo del nuovo nato*/
DROP PROCEDURE IF EXISTS inserisci_visitaControllo;
CREATE PROCEDURE inserisci_visitaControllo( IN _data DATE, IN _magra DOUBLE, IN _grassa DOUBLE, IN _stato BOOLEAN, 
											IN _idAnimale INT, IN _vet INT, IN _idratazione DOUBLE, 
											IN _respiro DOUBLE, IN _vigilanza BOOLEAN, IN _pelo CHAR(20), 
                                            IN _deamb BOOLEAN)
										   
DECLARE esiste_vet INT DEFUALT 0;

/*Controllo la validità del veterinario preso in ingresso*/
SET esiste_vet= (
                 SELECT COUNT(*)
                 FROM Veterinario
                 WHERE Id_Vet=_vet
                 );
                 
IF esiste_vet=1 THEN 
         INSERT INTO Visita_Controllo(	Id_visita, Data, Magra, Grassa, Stato, Idratazione, Respiro, Vigilanza, 
										Pelo, Deamb, Id_Vet, Id_animale, Gen1, Id_rip)
              VALUES (	_data, _magra, _grassa, _stato, _idratazione, _respiro, _vigilanza, _pelo, _deamb, _vet,
						_idAnimale, NULL, NULL);
			  
END IF;
END$$
DELIMITER ;

DELIMITER $$
/*Il seguente trigger viene invocato ogni volta che viene inserito un nuovo animale, e permette di inserire
i dati relativi alla sua prima visita di controllo*/
DROP TRIGGER IF EXISTS primaVisita;
CREATE TRIGGER primaVisita
AFTER INSERT ON Animale
FOR EACH ROW
BEGIN
DECLARE _data DATE;
DECLARE _magra DOUBLE;
DECLARE _grassa DOUBLE;
DECLARE _idratazione DOUBLE;
DECLARE _respiro DOUBLE;
DECLARE _stato BOOLEAN;
DECLARE _deamb BOOLEAN;
DECLARE _vigilanza BOOLEAN;
DECLARE _pelo VARCHAR(6);
DECLARE _vet INT;

SET _data="2020-02-17";
SET _magra=44.0;
SET _grassa=6.0;
SET _idratazione=32.5;
SET _respiro=0.6;
SET _stato=1;
SET _deamb=1;
SET _vigilanza=1;
SET _pelo="lucido";
SET _vet=1;

CALL inserisci_visitaControllo(	_data, _magra, _grassa, _stato, _idratazione, _respiro, _vigilanza, _pelo, _deamb,
								_vet, NEW.Id_animale);
END$$
DELIMITER ;

CALL inserisci_animale("Femmina",1,2,"2020-02-17",50,50,"mucca");

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*OPERAZIONE 7: Ricerca di un Silos disponibile per l'inserimento di latte appena munto */

DELIMITER $$
/*creo una procedura che dato in ingresso un codice identificativo di un silos, mi calcola il suo livello
di riempimento,e  lo restituisce in uscita*/
DROP PROCEDURE IF EXISTS calcola_riempimento;
CREATE PROCEDURE calcola_riempimento(IN _silos INT, OUT _riempimento DOUBLE)
	BEGIN
		/*La variabile seguente vale 1 se il parametro in ingresso è valido*/
		DECLARE _silosValido INT DEFAULT 0;
		/*La variabile seguente contiene la quantità di latte che è stata utilizzata, quindi prelevata dal silos
		in esame */
		DECLARE _qt_usata DOUBLE DEFAULT 0;
        /*La variabile seguente contiene la quantità di latte che è stata inserita nel silos in esame*/
		DECLARE _qt_inserita DOUBLE DEFAULT 0;
        
        /*Controllo se esiste nel database un silos che abbia il codice identificativo preso in ingresso*/
        SET _silosValido= (
							SELECT COUNT(*)
							FROM Silos S
							WHERE S.Codice_Silos= _silos
							);
		
		/*Calcolo la quantità di latte inserita*/
		SET _qt_inserita=(SELECT SUM(L.Qt_latte) AS quantita_inserita
						FROM Latte L INNER JOIN Silos S ON L.Codice_Silos=S.Codice_Silos 
						WHERE L.Codice_Silos=_silos);

		/*Calcolo la quantità di latte usata*/
		SET _qt_usata=(SELECT SUM(F.Qt_Latte) AS quantita_usata
						FROM Unita U INNER JOIN Formaggio F ON U.Nome=F.Nome 
						WHERE U.Codice_Silos=_silos);
                        
		/*Calcolo il livello di riempimento del silos come differenza tra la quantità di latte inserita
        e la quantità di latte utilizzata*/
        IF _silosValido = 1 THEN
		SET _riempimento=_qt_inserita-_qt_usata;
        ELSE 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = "Il silos non è valido!"
            END IF; 
	END $$
DELIMITER ;

DELIMITER $$
/*La seguente procedura permette, data una specie di animale e la quantità di latte appena munto da un
animale di quella specie, di trovare, e restituire il codice del silos in cui andiamo a travasare il latte*/
DROP PROCEDURE IF EXISTS trova_silos;
CREATE PROCEDURE trova_silos(IN _specie VARCHAR(6), IN _qt_latte DOUBLE, OUT _id_silos DOUBLE)
	BEGIN
		/*La seguente variabile viene settata a True nel momento in cui trovo un silos disponibile*/
		SET @trovato=FALSE;
        SET @id=00;
        /*Per il latte di mucca sono riservati i silos che vanno da 1 a 4*/
		IF _specie="mucca" THEN
			/* range da 1 a 4 */
            @id=01;
			REPEAT 
		/*Chiamo la procedura per il calcolo del livello di riempimento di un silos, passandole uno alla volta,
        i codici dei silos riservati al latte di mucca*/
				call calcola_riempimento(@id,@riempimento);
		/*Confronto il valore della capacità del Silos con il livello di riempimento che otterrei se allo stato
        attuale del silos, sommassi la quantità di latte appena munto: se la quantità ottenuta non supera, o
        è uguale alla capacità del silos, allora ho trovato un silos disponibile*/
				IF (@riempimento+_qt_latte)<=50000
					@trovato=TRUE;
				ELSE     
		/*altrimenti incremento id del silos*/
					@id++;
					UNTIL @trovato=FALSE AND @id<05
				END REPEAT;
		ELSE IF _specie="pecora" THEN
			/* range da 5 a 7 */
            @id=05;
			REPEAT 
				call calcola_riempimento(@id,@riempimento);
				IF (@riempimento+_qt_latte)<=50000
					@trovato=TRUE;
                ELSE                
					@id++;
            UNTIL @trovato=FALSE AND @id<08
            END REPEAT;
		ELSE IF _specie="capra" THEN
			/* range da 8 a 10 */
            @id=08;
			REPEAT 
				call calcola_riempimento(@id,@riempimento);
				IF (@riempimento+_qt_latte)<=50000
					@trovato=TRUE;
                ELSE                
					@id++;
            UNTIL @trovato=FALSE AND @id<11
            END REPEAT;
            /*Se non ho trovato un Silos disponibile, restituisco NULL, altrimenti, restituisco il codice del 
            silos*/
		IF @id=00 THEN
			_id_silos=NULL;
		ELSE
			_id_silos=@id;
    END $$
DELIMITER ;

DELIMITER $$
/*Il seguente trigger viene invocato ogni volta che inseriamo una nuova row in Mungitura*/
DROP TRIGGER IF EXISTS inserisci_latte;
CREATE TRIGGER inserisci_latte
AFTER INSERT ON Mungitura
FOR EACH ROW
BEGIN
	DECLARE _specie VARCHAR(6) DEFAULT '';
    DECLARE _qt_latte DOUBLE DEFAULT 0;
    /*Poichè nella tabella Mungitura ho il codice identificativo dell'animale che è stato munto, posso ricavare
    la sua specie, e di conseguenza, il valore medio di latte che la mungitura ha prodotto (in quanto tale valore
    dipende in buona parte dalla specie*/
    SET _specie=(SELECT Nome_Specie 
				FROM Animale
                WHERE Id_animale=NEW.Id_animale);
                
	IF _specie="mucca" THEN
		_qt_latte=28;
	ELSE IF _specie="pecora" THEN
		_qt_latte=2.5;
    ELSE IF _specie="capra" THEN
		_qt_latte=2;
       
       /*Dopo ogni mungitura inserisco una nuova riga nella tabella Latte, che contiene alcuni dati appartenenti
       al latte appena munto, ma il codice del silos viene inizialmente posto a NULL perchè non sappiamo 
       ancora dove andremo a travasare tale latte*/
	INSERT INTO Latte(Codice, Id_animale, Timestamp, Qt_latte, Id_loc, Codice_Silos)
				VALUES(NEW.Codice, NEW.Id_animale, NEW.Timestamp, _qt_latte, NEW.Id_loc, NULL);
END$$
DELIMITER ;

DELIMITER $$
/*Il seguente trigger viene invocato ogni volta che inseriamo una nuova row nella tabella Latte*/
DROP TRIGGER IF EXISTS controllo_disponibilita;
CREATE TRIGGER controllo_disponibilita
AFTER INSERT ON Latte
FOR EACH ROW
BEGIN
	DECLARE _specie VARCHAR(6) DEFAULT '';
    /*Trovo la specie dell'animale di cui stiamo prendendo in considerazione il latte appena munto*/
    SET _specie=(SELECT Nome_Specie 
				FROM Animale
                WHERE Id_animale=NEW.Id_animale);
	/*Invoco la procedura per trovare il Silos in cui inserire il latte, a cui passo la specie dell'animale
    che è appena stato munto, e la quantità di latte che ha prodotto*/
	call trova_silos(_specie, NEW.Qt_latte, @id_silos);
	UPDATE Latte
	SET NEW.Codice_Silos = @id_silos
	WHERE NEW.Codice_Silos = NULL; 
    
END $$
DELIMITER ;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*OPERAZIONE 8:  Controllo giornaliero delle unità che stanno stagionando*/
DELIMITER $$
/*Creo un evento che ogni giorno, mostri le unità che hanno completato il processo di stagionatura, per
notificare al personale addetto, che tali unità dovranno essere spostate dalla cantina al magazzino*/
CREATE EVENT _controlla_unita_cantina
	ON SCHEDULE EVERY 1 DAY
	DO(
		/*Creo una view che per ogni tipo di formaggio che necessita di stagionatura, mostri il nome del tipo,
        e il numero della fase del processo che riguarda la stagionatura, ovvero l'ultima fase della ricetta*/
		CREATE OR REPLACE VIEW mostra_tipi AS
        SELECT F.Nome AS Da_Stagionare, FIRST(PR.Id_Ph_Ricetta) AS Ultima_Ideale
        FROM Formaggio F NATURAL JOIN Ph_Ricetta PR
        WHERE Stagionatura="Si";
        GROUP BY F.Nome
        ORDER BY Id_Ph_Processo DESC;
        
        /*Creo una view che mostra il codice delle unità che stanno stagionando, e il loro tipo di formaggio*/
        CREATE OR REPLACE VIEW mostra_unita AS
        SELECT U.Id_Unita, MT.Da_Stagionare
        FROM Unita U INNER JOIN mostra_tipi MT ON U.Nome=MT.Da_Stagionare
        WHERE U.Id_Scaff_c IS NOT NULL AND U.Id_cantina IS NOT NULL;
        
        /*Creo una view che per ogni formaggio che sta stagionando, mostri il numero della fase del processo 
        che riguarda la stagionatura */
        CREATE OR REPLACE VIEW fase_stagionatura AS
        SELECT MU.Id_Unita, MU.Da_Stagionare, FIRST(PP.Id_Ph_Processo) AS Ultima_Reale
        FROM mostra_unita MU NATURAL JOIN Ph_Processo PP
        GROUP BY MU.Id_Unita, MU.Da_Stagionare
        ORDER BY PP.Id_Ph_Processo DESC;
        
        /*Creo una view che per ogni unità prodotta e sottoposta a processo di stagionatura, mostri il 
        timestamp in cui il processo ha avuto inizio*/
        CREATE OR REPLACE VIEW durate_reali AS
        SELECT PP.Timestamp, FS.Id_Unita, FS.Da_Stagionare
        FROM fase_stagionatura FS INNER JOIN Ph_Processo PP ON FS.Ultima_Reale=PP.Id_Ph_Processo
        WHERE FS.Da_Stagionare=PP.Nome AND FS.Id_Unita=PP.Id_Unita
        GROUP BY FS.Id_Unita, FS.Da_Stagionare;
        
        /*Creo una view che per ogni formaggio, mostra quale dovrebbe essere la durata reale del processo
        di stagionatura*/
        CREATE OR REPLACE VIEW durate_ideali AS
        SELECT PR.Durata_Ideale, FS.Da_Stagionare
        FROM mostra_tipi MT INNER JOIN Ph_Ricetta PR ON MT.Da_Stagionare=PR.Nome
        WHERE MT.Ultima_Ideale=PR.Id_Ph_Ricetta
        GROUP BY FS.Da_Stagionare;
        
        /*Per ogni unità sottoposta a stagionatura, controllo se è il momento di toglierle dalla cantina,
        in base alla durata specificata nella ricetta di quel tipo di formaggio*/
        CREATE OR REPLACE VIEW unita_da_spostare AS
        SELECT Id_Unita, Da_Stagionare
        FROM durate_reali DR INNER JOIN durate_ideali DI ON DR.Da_Stagionare=DI.Da_Stagionare
        WHERE DATEDIFF(CURRENT_TIMESTAMP,DR.Timestamp)>DI.Durata_Ideale 
			OR DATEDIFF(CURRENT_TIMESTAMP,DR.Timestamp)=DI.Durata_Ideale;
        
        /*Conto il numero di unità che devono essere spostate dalla cantina al magazzino*/
        SET @numero=(
					SELECT COUNT(*) 
					FROM unita_da_spostare
					);
        
        /*Se il numero di unità da spostare è maggiore di 0, allora lo notifico al personale*/
        IF @numero>0 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = CONCAT('Ci sono ' , @numero ,' unità da spostare dalla cantina al magazzino ');
            
            /*Per ogni unità da spostare, mostro lo scaffale e la cantina in cui è posizionata */
            SELECT U.Nome, U.Id_Unita, U.Id_Scaff_c, U.Id_cantina
			FROM unita_da_spostare UDS INNER JOIN Unita U ON UDS.Id_Unita=U.Id_Unita
			WHERE UDS.Da_Stagionare=U.Nome;
		END IF;
        
        /* Per ogni unità che ho spostato, devo aggiornare la durata reale del processo di stagionatura all'interno della tabella Ph_Processo */        
        UPDATE fase_stagionatura NATURAL JOIN unita_da_spostare NATURAL JOIN Ph_Processo
        SET Durata_Reale=DATEDIFF(CURRENT_TIMESTAMP,Timestamp)
        WHERE Id_Ph_Processo=Ultima_Reale;
	);
DELIMITER ;


/*OPERAZIONE 7.1: Ricerca di un Silos disponibile per l'inserimento di latte appena munto (con ridondanza)*/

DELIMITER $$
/*La seguente procedura permette, data una specie di animale e la quantità di latte appena munto da un
animale di quella specie, di trovare, e restituire il codice del silos in cui andiamo a travasare il latte*/
DROP PROCEDURE IF EXISTS trova_silos;
CREATE PROCEDURE trova_silos(IN _specie VARCHAR(6), IN _qt_latte DOUBLE, OUT _id_silos DOUBLE)
	BEGIN
		/*La seguente variabile viene settata a True nel momento in cui trovo un silos disponibile*/
		SET @trovato=FALSE;
        SET @id=00;
        /*Per il latte di mucca sono riservati i silos che vanno da 1 a 4*/
		IF _specie="mucca" THEN
			/* range da 1 a 4 */
            @id=01;
			REPEAT 
            
			SET @riempimento=(SELECT Liv_Riempimento FROM Silos WHERE Codice_Silos=@id);
		/*Confronto il valore della capacità del Silos con il livello di riempimento che otterrei se allo stato
        attuale del silos, sommassi la quantità di latte appena munto: se la quantità ottenuta non supera, o
        è uguale alla capacità del silos, allora ho trovato un silos disponibile*/
				IF (@riempimento+_qt_latte)<=50000
					@trovato=TRUE;
				ELSE     
		/*altrimenti incremento id del silos*/
					@id++;
					UNTIL @trovato=FALSE AND @id<05
				END REPEAT;
		ELSE IF _specie="pecora" THEN
			/* range da 5 a 7 */
            @id=05;
			REPEAT 
				SET @riempimento=(SELECT Liv_Riempimento FROM Silos WHERE Codice_Silos=@id);
				IF (@riempimento+_qt_latte)<=50000
					@trovato=TRUE;
                ELSE                
					@id++;
            UNTIL @trovato=FALSE AND @id<08
            END REPEAT;
		ELSE IF _specie="capra" THEN
			/* range da 8 a 10 */
            @id=08;
			REPEAT 
				SET @riempimento=(SELECT Liv_Riempimento FROM Silos WHERE Codice_Silos=@id);
				IF (@riempimento+_qt_latte)<=50000
					@trovato=TRUE;
                ELSE                
					@id++;
            UNTIL @trovato=FALSE AND @id<11
            END REPEAT;
            /*Se non ho trovato un Silos disponibile, restituisco NULL, altrimenti, restituisco il codice del 
            silos*/
		IF @id=00 THEN
			_id_silos=NULL;
		ELSE
			_id_silos=@id;
    END $$
DELIMITER ;

DELIMITER $$
/*Il seguente trigger viene invocato ogni volta che inseriamo una nuova row in Mungitura*/
DROP TRIGGER IF EXISTS inserisci_latte;
CREATE TRIGGER inserisci_latte
AFTER INSERT ON Mungitura
FOR EACH ROW
BEGIN
	DECLARE _specie VARCHAR(6) DEFAULT '';
    DECLARE _qt_latte DOUBLE DEFAULT 0;
    /*Poichè nella tabella Mungitura ho il codice identificativo dell'animale che è stato munto, posso ricavare
    la sua specie, e di conseguenza, il valore medio di latte che la mungitura ha prodotto (in quanto tale valore
    dipende in buona parte dalla specie*/
    SET _specie=(SELECT Nome_Specie 
				FROM Animale
                WHERE Id_animale=NEW.Id_animale);
                
	IF _specie="mucca" THEN
		_qt_latte=28;
	ELSE IF _specie="pecora" THEN
		_qt_latte=2.5;
    ELSE IF _specie="capra" THEN
		_qt_latte=2;
       
       /*Dopo ogni mungitura inserisco una nuova riga nella tabella Latte, che contiene alcuni dati appartenenti
       al latte appena munto, ma il codice del silos viene inizialmente posto a NULL perchè non sappiamo 
       ancora dove andremo a travasare tale latte*/
	INSERT INTO Latte(Codice, Id_animale, Timestamp, Qt_latte, Id_loc, Codice_Silos)
				VALUES(NEW.Codice, NEW.Id_animale, NEW.Timestamp, _qt_latte, NEW.Id_loc, NULL);
END$$
DELIMITER ;

DELIMITER $$
/*Il seguente trigger viene invocato ogni volta che inseriamo una nuova row nella tabella Latte*/
DROP TRIGGER IF EXISTS controllo_disponibilita;
CREATE TRIGGER controllo_disponibilita
AFTER INSERT ON Latte
FOR EACH ROW
BEGIN
	DECLARE _specie VARCHAR(6) DEFAULT '';
    /*Trovo la specie dell'animale di cui stiamo prendendo in considerazione il latte appena munto*/
    SET _specie=(SELECT Nome_Specie 
				FROM Animale
                WHERE Id_animale=NEW.Id_animale);
	/*Invoco la procedura per trovare il Silos in cui inserire il latte, a cui passo la specie dell'animale
    che è appena stato munto, e la quantità di latte che ha prodotto*/
	call trova_silos(_specie, NEW.Qt_latte, @id_silos);
	UPDATE Latte
	SET NEW.Codice_Silos = @id_silos
	WHERE NEW.Codice_Silos = NULL; 
    
    UPDATE Silos
    SET Liv_Riempimento=Liv_Riempimento+NEW.Qt_latte
    WHERE Codice_Silos=NEW.Codice_Silos;
    
END $$
DELIMITER ;

DELIMITER $$
/*Il seguente trigger viene invocato ogni volta che inseriamo una nuova row nella tabella Unità*/
DROP TRIGGER IF EXISTS aggiorno_riempimento;
CREATE TRIGGER aggiorno_riempimento
AFTER INSERT ON Unita
FOR EACH ROW
BEGIN
	DECLARE _specie VARCHAR(6) DEFAULT '';
    /*Trovo la specie dell'animale di cui stiamo prendendo in considerazione il latte appena munto*/
    SET _specie=(SELECT Nome_Specie 
				FROM Animale
                WHERE Id_animale=NEW.Id_animale);
	/*Invoco la procedura per trovare il Silos in cui inserire il latte, a cui passo la specie dell'animale
    che è appena stato munto, e la quantità di latte che ha prodotto*/
	call trova_silos(_specie, NEW.Qt_latte, @id_silos);
	UPDATE Latte
	SET NEW.Codice_Silos = @id_silos
	WHERE NEW.Codice_Silos = NULL; 
    
    SET @Qt_estrarre=(SELECT F.Qt_Latte
						FROM Formaggio F 
                        WHERE F.Nome=NEW.Nome);
	
    SET @Liv_attuale=(SELECT Liv_Riempimento
						WHERE Codice_Silos=NEW.Codice_Silos);
    IF (@Liv_attuale-@Qt_estrarre)<0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Impossibile prelevare la quantità richiesta';
	ELSE 
		UPDATE Silos S 
		SET Liv_Riempimento=Liv_Riempimento-@Qt_estrarre
		WHERE Codice_Silos=NEW.Codice_Silos;
    
END $$
DELIMITER ;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

/*OPERAZIONE 6: Inserimento di un Animale a seguito di nascita all'interno dell'agriturismo
e inserimento dei valori registrati durante la prima visita di controllo*/

DELIMITER $$
/*Creo una procedura per verificare se per una determinata specie, esiste un locale che abbia spazio a sufficienza
per allocare un animale in più rispetto a quelli che già contiene*/
DROP PROCEDURE IF EXISTS disponibilita_locale;
CREATE PROCEDURE disponibilita_locale(IN _specie VARCHAR(6), OUT _locale INT)
	    
    /*Considero come locale "buono" il primo che trovo che abbia spazio*/
    SET _locale=(
				SELECT L.Id_loc
				FROM Locale L INNER JOIN Animale A ON L.Id_loc=A.Id_loc
				WHERE (L.Num_max_an>(L.num_animali+1) OR L.Num_max_an=(L.num_animali+1)) AND A.Nome_specie=_specie
				LIMIT 1
                );
DELIMITER ;

DELIMITER $$
/*Creo una procedura che mi permette di inserire i dati anagrafici di un nuovo animale, nato all'interno 
dell'agriturismo*/
DROP PROCEDURE IF EXISTS inserisci_animale;
CREATE PROCEDURE inserisci_animale( IN _sesso CHAR(10),IN _gen1 INT ,IN _gen2 INT, IN dt_nasc DATE,IN _alt INT, 
									IN _peso DOUBLE, IN _specie VARCHAR(50))
DECLARE esiste_mom INT DEFAULT 0;
DECLARE esiste_dad INT DEFAULT 0;
DECLARE tentativo INT DEFAULT 0;
DECLARE esiste_gravidanza INT DEFAULT 0;

/*Verifico che gen1, ovvero la madre, sia un animale di sesso femminile valido*/
SET esiste_mom =(
	SELECT COUNT(*)
	FROM Animale
	WHERE Sesso='Femmina' AND Id_animale=_gen1
				);
/*Verifico che gen2, ovvero il padre, sia un animale di sesso maschile valido*/
SET esiste_dad = (
	SELECT COUNT(*)
	FROM Animale
	WHERE Sesso='Maschio' AND Id_animale=_gen2
				);
 /*Verifico che esista un tentativo di riproduzione tale che: gli animali partecipanti al tentativo siano 
 gli effettivi "genitori" dell'animale appena nato, lo stato del tentativo sia 1 (quindi l'animale femmina
 è effettivamente rimasta incinta), e quindi seleziono l'id del tentativo più recente rispetto a tutti 
 i tentativi che rispettano tali requisiti (rispetto alla data di nascita dell'animale)*/
 
SET tentativo=(
	SELECT Id_rip
    FROM Tentativo_Riproduzione TR1
    WHERE 	TR1.Gen1=_gen1 
			AND TR1.Gen2=_gen2 
            AND TR1.Stato=1 
            AND DATEDIFF(dt_nasc,TR1.Data)=( 
												SELECT MIN(DATEDIFF(dt_nasc,TR2.Data))
												FROM Tentativo_Riproduzione2 TR2
												WHERE TR2.Gen1=TR1.Gen1 AND TR2.Gen2=TR1.Gen2 AND TR2.Stato=1 
											)
				);

/*Verifico l'esistenza di una gravidanza conclusasi con parto, del tentativo di riproduzione di cui al punto 
precedente */

SET esiste_gravidanza=(
						SELECT COUNT(*)
						FROM Gravidanza
						WHERE 	Gen1=_gen1 
								AND Id_rip=tentativo 
                                AND Stato=1
						);
/*Se ho verificato la validità di padre, madre e gravidanza, allora posso inserire l'anagrafica del nuovo nato,
prima però devo anche verificare che ci sia spazio per lui */

IF esiste_dad=1 AND esiste_mom=1 AND esiste_gravidanza=1 THEN (
			call disponibilita_locale(_specie,@locale);
            IF @locale!=NULL THEN
				INSERT INTO Animale(Id_animale, Sesso, Id_gen1, Id_gen2, Dt_acq, Dt_arr, Data_nascita, Altezza, 
									Peso, Nome_specie, Id_loc, Partita_iva)
										VALUES (_sesso, _gen1, _gen2, NULL, NULL, dt_nasc, _alt, _peso, _specie, 
                                        @locale, NULL);
			ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT= "Non è disponibile spazio per la specie inserita!";
	   )
END IF;
END$$
DELIMITER ;

DELIMITER $$ 
/*La seguente procedura permette di inserire la prima visita di controllo del nuovo nato*/
DROP PROCEDURE IF EXISTS inserisci_visitaControllo;
CREATE PROCEDURE inserisci_visitaControllo( IN _data DATE, IN _magra DOUBLE, IN _grassa DOUBLE, IN _stato BOOLEAN, 
											IN _idAnimale INT, IN _vet INT, IN _idratazione DOUBLE, 
											IN _respiro DOUBLE, IN _vigilanza BOOLEAN, IN _pelo VARCHAR(6), 
                                            IN _deamb BOOLEAN)
										   
DECLARE esiste_vet INT DEFUALT 0;

/*Controllo la validità del veterinario preso in ingresso*/
SET esiste_vet= (
                 SELECT COUNT(*)
                 FROM Veterinario
                 WHERE Id_Vet=_vet
                 );
                 
IF esiste_vet=1 THEN 
         INSERT INTO Visita_Controllo(	Id_visita, Data, Magra, Grassa, Stato, Idratazione, Respiro, Vigilanza, 
										Pelo, Deamb, Id_Vet, Id_animale, Gen1, Id_rip)
              VALUES (	_data, _magra, _grassa, _stato, _idratazione, _respiro, _vigilanza, _pelo, _deamb, _vet,
						_idAnimale, NULL, NULL);
			  
END IF;
END$$
DELIMITER ;

DELIMITER $$
/*Il seguente trigger viene invocato ogni volta che viene inserito un nuovo animale, e permette di inserire
i dati relativi alla sua prima visita di controllo*/
DROP TRIGGER IF EXISTS primaVisita;
CREATE TRIGGER primaVisita
AFTER INSERT ON Animale
FOR EACH ROW
BEGIN
DECLARE _data DATE;
DECLARE _magra DOUBLE;
DECLARE _grassa DOUBLE;
DECLARE _idratazione DOUBLE,
DECLARE _respiro DOUBLE,
DECLARE _stato BOOLEAN,
DECLARE _deamb BOOLEAN,
DECLARE _vigilanza BOOLEAN,
DECLARE _pelo VARCHAR(6),
DECLARE _vet INT,

SET _data="2020-02-17";
SET _magra=44.0;
SET _grassa=6.0;
SET _idratazione=32.5;
SET _respiro=0.6;
SET _stato=1;
SET _deamb=1;
SET _vigilanza=1;
SET _pelo="lucido";
SET _vet=1;

UPDATE Locale
SET num_animali=num_animali+1
WHERE Id_loc=NEW.Id_loc;

CALL inserisci_visitaControllo(	_data, _magra, _grassa, _stato, _idratazione, _respiro, _vigilanza, _pelo, _deamb,
								_vet, NEW.Id_animale);
END$$
DELIMITER ;

DELIMITER $$
/* Il seguente trigger viene invocato ogni volta che un animale muore */
DROP TRIGGER IF EXISTS aggiorna_num_animali;
CREATE TRIGGER aggiorna_num_animali
AFTER UPDATE ON Animale
FOR EACH ROW
BEGIN
	IF NEW.Dt_morte IS NOT NULL AND NEW.Dt_morte<>OLD.Dt_morte THEN
		UPDATE Locale 
        SET num_animali=num_animali-1
        WHERE Id_loc=NEW.Id_loc;
END$$
DELIMITER ;
/* CALL inserisci_animale("Femmina",1,2,"2020-02-17",50,50,"mucca"); */

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/