DROP DATABASE FarmHouse;
CREATE DATABASE FarmHouse;
USE FarmHouse;
/* Area Bianca */
CREATE TABLE IF NOT EXISTS Agriturismo(
	Id_Agr INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Nome_agr VARCHAR(20) NOT NULL
);
CREATE TABLE IF NOT EXISTS Stalla(
	Num_stalla INT UNSIGNED NOT NULL,
    Id_Agr INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Num_stalla,Id_Agr),
    FOREIGN KEY(Id_Agr) REFERENCES Agriturismo(Id_Agr)
);
CREATE TABLE IF NOT EXISTS Allestimento(
	Id_a INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
);
CREATE TABLE IF NOT EXISTS Specie(
	Nome_specie VARCHAR(6) NOT NULL,
    Nome_razza  VARCHAR(15) NOT NULL,
    Nome_famiglia  VARCHAR(10) NOT NULL,
    
    PRIMARY KEY(Nome_specie, Nome_razza)
);
CREATE TABLE IF NOT EXISTS Locale(
	Id_loc INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Num_stalla INT UNSIGNED NOT NULL,
    Id_Agr INT UNSIGNED NOT NULL,
    Pt_card VARCHAR(10) NOT NULL,
    Coordinate VARCHAR(27) NOT NULL,
    Tipo_pav VARCHAR(20) DEFAULT '',
    Num_max_an INT UNSIGNED NOT NULL,
    Id_a INT UNSIGNED NOT NULL,
    Nome_specie VARCHAR(6) NOT NULL,
    Nome_razza VARCHAR(15) NOT NULL,
    num_animali INT UNSIGNED DEFAULT 0,
    
    FOREIGN KEY(Num_stalla) REFERENCES Stalla(Num_stalla),
    FOREIGN KEY(Id_Agr) REFERENCES Agriturismo(Id_Agr),
    FOREIGN KEY(Id_a) REFERENCES Allestimento(Id_a)
);
ALTER TABLE Locale
	ADD FOREIGN KEY(Nome_specie,Nome_razza) REFERENCES Specie(Nome_specie,Nome_razza);
    
CREATE TABLE IF NOT EXISTS Fornitore(
	Partita_iva INTEGER UNSIGNED PRIMARY KEY,
    Nome_f VARCHAR(20) NOT NULL,
    Rag_soc VARCHAR(20) NOT NULL
);
CREATE TABLE IF NOT EXISTS Indirizzo_F(	
    N_Civico INT UNSIGNED NOT NULL,
	Via VARCHAR(20) NOT NULL,
    Citta VARCHAR(20) NOT NULL,
    CAP INT UNSIGNED NOT NULL,
    Partita_iva INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(N_Civico,Via,Citta),
    FOREIGN KEY(Partita_iva) REFERENCES Fornitore(Partita_iva)
);
CREATE TABLE IF NOT EXISTS Animale(
	Id_animale INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Nome_specie VARCHAR(6) NOT NULL,
    Nome_razza VARCHAR(15) NOT NULL,
    Id_loc INT UNSIGNED NOT NULL,
    Sesso VARCHAR(7) NOT NULL,
    Peso INT UNSIGNED NOT NULL,
    Altezza INT UNSIGNED NOT NULL,
    Data_nascita DATE NOT NULL,
    Id_gen1 INT UNSIGNED DEFAULT NULL,
    Id_gen2 INT UNSIGNED DEFAULT NULL,
    Dt_morte DATE DEFAULT NULL,
    Partita_iva INT UNSIGNED DEFAULT NULL,
    Dt_arr DATE DEFAULT NULL,
    Dt_acq DATE DEFAULT NULL,
    
    FOREIGN KEY(Id_loc) REFERENCES Locale(Id_loc),
    FOREIGN KEY(Partita_iva) REFERENCES Fornitore(Partita_iva)
);
ALTER TABLE Animale
	ADD FOREIGN KEY(Nome_specie,Nome_razza) REFERENCES Specie(Nome_specie,Nome_razza);
    
CREATE TABLE IF NOT EXISTS Dimensione_Locale(
	Id_loc INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Alt INT UNSIGNED NOT NULL,
    Larg INT UNSIGNED NOT NULL,
    Lung INT UNSIGNED NOT NULL,
    
    FOREIGN KEY(Id_loc) REFERENCES Locale(Id_loc)
);

CREATE TABLE IF NOT EXISTS Rilevazione_Locale(
	Id_ril INT UNSIGNED NOT NULL,
    Id_loc INT UNSIGNED NOT NULL,
    Liv_sporco DOUBLE UNSIGNED NOT NULL,
    Val_composti DOUBLE UNSIGNED NOT NULL,
    `Timestamp` TIMESTAMP NOT NULL,
    Sporco_Max DOUBLE UNSIGNED NOT NULL,
    Composti_Max DOUBLE UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_ril,Id_loc),
    FOREIGN KEY(Id_loc) REFERENCES Locale(Id_loc)
);
CREATE TABLE IF NOT EXISTS Misurazione_Locale(
	Id_misurazione INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Id_loc INT UNSIGNED NOT NULL,
    Liv_temperatura INT UNSIGNED NOT NULL,
    Liv_umido INT UNSIGNED NOT NULL,
    `Timestamp` TIMESTAMP NOT NULL,
    
    FOREIGN KEY(Id_loc) REFERENCES Locale(Id_loc)
);
CREATE TABLE IF NOT EXISTS Pulizia(
	Id_ril INT UNSIGNED NOT NULL,
    Id_loc INT UNSIGNED NOT NULL,
    Firma_Dipendente  VARCHAR(30) DEFAULT '',
    Stato VARCHAR(10) NOT NULL,
    `Mode` VARCHAR(15) NOT NULL,
    
    PRIMARY KEY(Id_ril,Id_loc),
    FOREIGN KEY(Id_ril) REFERENCES Rilevazione_Locale(Id_ril),
    FOREIGN KEY(Id_loc) REFERENCES Locale(Id_loc)
);
CREATE TABLE IF NOT EXISTS Zona(
	Id_Zona INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
);
CREATE TABLE IF NOT EXISTS Pascolo(
	Id_Zona INT UNSIGNED NOT NULL,
    Id_animale INT UNSIGNED NOT NULL,
    `Data` DATE NOT NULL,
    Ora_Inizio TIME NOT NULL,
    Ora_Fine TIME NOT NULL,
    
    PRIMARY KEY(Id_Zona, `Data`, Ora_Inizio, Ora_Fine),
    FOREIGN KEY(Id_animale) REFERENCES Animale(Id_animale),
    FOREIGN KEY(Id_Zona) REFERENCES Zona(Id_Zona)
);
CREATE TABLE IF NOT EXISTS Rilev_Gps(
	Id_animale INT UNSIGNED,
	`Timestamp` TIMESTAMP,
    Coordinate VARCHAR(27) NOT NULL,
    Id_Zona INT UNSIGNED NOT NULL,
    `Data` DATE NOT NULL,
    Ora_Inizio TIME NOT NULL,
    Ora_Fine TIME NOT NULL,
    
    PRIMARY KEY(Id_animale,`Timestamp`),
    FOREIGN KEY(Id_animale) REFERENCES Animale(Id_animale)
);
    
CREATE TABLE IF NOT EXISTS Recinzione(
	Id_Recinzione INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Orientamento INT UNSIGNED NOT NULL,
    Lunghezza INT UNSIGNED NOT NULL,
    Coord_inizio VARCHAR(27) NOT NULL,
    Coord_Fine VARCHAR(27) NOT NULL    
);
CREATE TABLE IF NOT EXISTS Delimitazione(
	Id_Zona INT UNSIGNED NOT NULL,
    Id_Recinzione INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_Zona,Id_Recinzione),
    FOREIGN KEY(Id_Zona) REFERENCES Zona(Id_Zona),
	FOREIGN KEY(Id_Recinzione) REFERENCES Recinzione(Id_Recinzione)
);
CREATE TABLE IF NOT EXISTS Acqua(
	Id_Acqua INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Sali_minerali DOUBLE  NOT NULL,
    Vitamine DOUBLE NOT NULL
);
CREATE TABLE IF NOT EXISTS Abbeveratorio(
	Id_abb INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Tipologia VARCHAR(10) NOT NULL,
    Id_a INT UNSIGNED NOT NULL,
    
    FOREIGN KEY(Id_a) REFERENCES Allestimento(Id_a)    
);
CREATE TABLE IF NOT EXISTS St_Abbeveratorio(
	Id_abb INT UNSIGNED NOT NULL,
	`Timestamp` TIMESTAMP NOT NULL,
	Qt_acq INT UNSIGNED NOT NULL,
    Id_Acqua  INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_abb,`Timestamp`),
    FOREIGN KEY(Id_abb) REFERENCES Abbeveratorio(Id_abb),
    FOREIGN KEY(Id_Acqua) REFERENCES Acqua(Id_Acqua)
);

CREATE TABLE IF NOT EXISTS Mangiatoia(
	Id_mang INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Tipologia VARCHAR(10) NOT NULL,
    Id_a INT UNSIGNED NOT NULL,
    
    FOREIGN KEY(Id_a) REFERENCES Allestimento(Id_a)    
);
CREATE TABLE IF NOT EXISTS Foraggio(
	id_foraggio INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    St_cons VARCHAR(10) NOT NULL,
    Kcal_kg DOUBLE NOT NULL
);
CREATE TABLE IF NOT EXISTS St_Mangiatoia(
	Id_mang INT UNSIGNED NOT NULL,
	`Timestamp` TIMESTAMP NOT NULL,
	Qt_for INT UNSIGNED NOT NULL,
    Id_foraggio  INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_mang,`Timestamp`),
    FOREIGN KEY(Id_mang) REFERENCES Mangiatoia(Id_mang),
    FOREIGN KEY(Id_foraggio) REFERENCES Foraggio(Id_foraggio)
);

CREATE TABLE IF NOT EXISTS Componente_Foraggio(
	Id_foraggio INT UNSIGNED NOT NULL,
    Frutta DOUBLE NOT NULL,
    Piante DOUBLE NOT NULL,
    Cereali DOUBLE NOT NULL,
    
    FOREIGN KEY(Id_foraggio) REFERENCES Foraggio(Id_foraggio)
	
);
CREATE TABLE IF NOT EXISTS Sostanza_Foraggio(
	Id_foraggio INT UNSIGNED NOT NULL,
    Fibre DOUBLE NOT NULL,
    Proteine DOUBLE NOT NULL,
    Glucidi DOUBLE NOT NULL,
    
    FOREIGN KEY(Id_foraggio) REFERENCES Foraggio(Id_foraggio)
	
);
CREATE TABLE IF NOT EXISTS Veterinario(
	Id_Vet INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Tentativo_Riproduzione(
	Id_rip INT UNSIGNED NOT NULL,
    Gen1 INT UNSIGNED NOT NULL,
    Gen2 INT UNSIGNED NOT NULL,
    Stato BOOLEAN DEFAULT 0,
    `Data` DATE NOT NULL,
    Ora TIME NOT NULL,
    Id_Vet INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_rip, Gen1),
    FOREIGN KEY(Id_Vet) REFERENCES Veterinario(Id_Vet)
);
CREATE TABLE IF NOT EXISTS Partecipazione(
	Id_rip INT UNSIGNED NOT NULL,
    Gen1 INT UNSIGNED NOT NULL,
    Gen2 INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_rip,Gen1,Gen2),
    FOREIGN KEY(Gen2) REFERENCES Animale(Id_animale)
   
);
ALTER TABLE Partecipazione
ADD FOREIGN KEY(Id_rip, Gen1) REFERENCES Tentativo_Riproduzione(Id_rip, Gen1); 

CREATE TABLE IF NOT EXISTS Gravidanza(
	Id_rip INT UNSIGNED NOT NULL,
    Gen1 INT UNSIGNED NOT NULL,
    Stato VARCHAR(10),
    
	PRIMARY KEY(Id_rip, Gen1)
);
ALTER TABLE Gravidanza
ADD FOREIGN KEY(Id_rip, Gen1) REFERENCES Tentativo_Riproduzione(Id_rip, Gen1);

CREATE TABLE IF NOT EXISTS Complicanza(
	Id_Complicanza INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Descrizione VARCHAR(255) NOT NULL,
	Id_rip INT UNSIGNED NOT NULL,
    Gen1 INT UNSIGNED NOT NULL
);
ALTER TABLE Complicanza
ADD FOREIGN KEY(Id_rip, Gen1) REFERENCES Gravidanza(Id_rip, Gen1); 

CREATE TABLE IF NOT EXISTS Scheda_Gestazione(
	Id_rip INT UNSIGNED NOT NULL,
    Gen1 INT UNSIGNED NOT NULL,
	Id_Vet INT UNSIGNED NOT NULL,

    PRIMARY KEY(Id_rip, Gen1),
    FOREIGN KEY(Id_Vet) REFERENCES Veterinario(Id_Vet)
);
ALTER TABLE Scheda_Gestazione
ADD FOREIGN KEY(Id_rip, Gen1) REFERENCES Tentativo_Riproduzione(Id_rip, Gen1); 

CREATE TABLE IF NOT EXISTS Controllo(
	Id_Controllo INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Esito VARCHAR(10) NOT NULL,
    Data DATE NOT NULL,
    Stato VARCHAR(10),
	Id_rip INT UNSIGNED NOT NULL,
    Gen1 INT UNSIGNED NOT NULL,
    Data_Prog DATE
);
ALTER TABLE Controllo
ADD FOREIGN KEY(Id_rip, Gen1) REFERENCES Scheda_Gestazione(Id_rip, Gen1); 

CREATE TABLE IF NOT EXISTS Esame(
	Id_Esame INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(20) NOT NULL,
    `Data` DATE NOT NULL,
    Descr_Testuale VARCHAR(255) NOT NULL,
    Macchinario VARCHAR(50) NOT NULL,
    Id_Controllo INT UNSIGNED NOT NULL,
    
    FOREIGN KEY(Id_Controllo) REFERENCES Controllo(Id_Controllo)
);

/* Area Verde */

CREATE TABLE IF NOT EXISTS Cliente(
	CF_Cliente VARCHAR(6) PRIMARY KEY 
);

CREATE TABLE IF NOT EXISTS Cliente_Registrato(
	CF_Cliente VARCHAR(6) PRIMARY KEY,
    Nome VARCHAR(50) DEFAULT '',
    Cognome VARCHAR(50) DEFAULT '',
    Indirizzo VARCHAR(50) DEFAULT '',
    Cod_Carta_Credito INT(11) UNSIGNED NOT NULL,
    Dt_Reg DATE DEFAULT NULL,
    Num_Cell INT(11) UNSIGNED NOT NULL,
    
     FOREIGN KEY(CF_Cliente) REFERENCES Cliente(CF_Cliente)
);

CREATE TABLE IF NOT EXISTS Documento(
	Cod_doc INT UNSIGNED DEFAULT 0,
    Tipo VARCHAR(100) DEFAULT '',
    Ente VARCHAR(100) DEFAULT '',
    Dt_scadenza DATE NOT NULL,
	CF_Cliente VARCHAR(6)
    NOT NULL,
   
   PRIMARY KEY(Cod_doc,Tipo),
   FOREIGN KEY(CF_Cliente) REFERENCES Cliente_Registrato(CF_Cliente)
);

CREATE TABLE IF NOT EXISTS Prenotazione(
	Id_Prenotazione INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Costo_totale_sogg DOUBLE UNSIGNED DEFAULT 0,
    Caparra INT UNSIGNED DEFAULT 0,
    Dt_Prenotazione DATE DEFAULT NULL,
    Dt_partenza DATE DEFAULT NULL,
    Dt_arrivo DATE DEFAULT NULL,
    CF_Cliente VARCHAR(6) NOT NULL,
   
   FOREIGN KEY(CF_Cliente) REFERENCES Cliente(CF_Cliente)
);

CREATE TABLE IF NOT EXISTS Pagamento(
	Id_Pagamento INT UNSIGNED AUTO_INCREMENT,
    DataEOra TIMESTAMP NOT NULL,
    Tipo_Pagamento VARCHAR(100) DEFAULT '',
    Importo_Rimanente INT UNSIGNED DEFAULT 0,
    Cod_Carta_Credito INTEGER UNSIGNED DEFAULT 0,
    Id_Prenotazione INT UNSIGNED DEFAULT 0,
    
	PRIMARY KEY(Id_Pagamento, DataEOra),
    FOREIGN KEY(Id_Prenotazione) REFERENCES Prenotazione(Id_Prenotazione)
);

CREATE TABLE IF NOT EXISTS Servizio_Extra(
	Nome_Servizio VARCHAR(50) NOT NULL,
	Costo_Giornaliero DOUBLE NOT NULL,
	
    PRIMARY KEY(Nome_Servizio)
);

CREATE TABLE IF NOT EXISTS Prenotazione_Servizio(
	Id_Prenotazione INT UNSIGNED NOT NULL,
    Nome_Servizio VARCHAR(50) NOT NULL,
    Dt_Inizio DATE NOT NULL,
    Dt_Fine DATE NOT NULL, 
    Qt_Giorni INT UNSIGNED DEFAULT 0,
    
   PRIMARY KEY(Id_Prenotazione, Nome_Servizio),
   FOREIGN KEY(Id_Prenotazione) REFERENCES Prenotazione(Id_Prenotazione),
   FOREIGN KEY(Nome_Servizio) REFERENCES Servizio_Extra(Nome_Servizio)
);

CREATE TABLE IF NOT EXISTS Camera(
    Id_Camera INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Num_Singoli INT UNSIGNED DEFAULT 0,
    Num_Matrimoniali INT UNSIGNED DEFAULT 0,
    Capienza INT UNSIGNED DEFAULT 0,
    Tipo VARCHAR(20) DEFAULT '',
    Costo_gg DOUBLE UNSIGNED DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Offerta(
	Nome_Servizio VARCHAR(50) NOT NULL,
	Id_Camera INT UNSIGNED NOT NULL,
	
    PRIMARY KEY(Nome_Servizio, Id_Camera),
    FOREIGN KEY(Id_Camera) REFERENCES Camera(Id_Camera),
	FOREIGN KEY(Nome_Servizio) REFERENCES Servizio_Extra(Nome_Servizio)
);

CREATE TABLE IF NOT EXISTS Riservazione(
	Id_Prenotazione INT UNSIGNED NOT NULL,
    Id_Camera INT UNSIGNED NOT NULL,
	
    PRIMARY KEY(Id_Prenotazione, Id_Camera),
	FOREIGN KEY(Id_Prenotazione) REFERENCES Prenotazione(Id_Prenotazione),
	FOREIGN KEY(Id_Camera) REFERENCES Camera(Id_Camera)
);

CREATE TABLE IF NOT EXISTS Account(
	Nome_Utente VARCHAR(50) PRIMARY KEY NOT NULL,
    Psw VARCHAR(100) NOT NULL,
    Domanda_Psw VARCHAR(100) DEFAULT '',
    Risposta_Psw VARCHAR(100) DEFAULT '',
    CF_Cliente VARCHAR(6) DEFAULT 0,
    
    FOREIGN KEY(CF_Cliente) REFERENCES Cliente_Registrato(CF_Cliente)
);

CREATE TABLE IF NOT EXISTS Escursione(
    Id_Escursione INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Ora_Inizio TIMESTAMP NOT NULL,
    Dt_Escursione DATE NOT NULL, 
    Dt_Prenotazione DATE NOT NULL, 
    Num_Partecipanti INT UNSIGNED DEFAULT 0,
    CF_Cliente VARCHAR(6) NOT NULL,
    
    FOREIGN KEY(CF_Cliente) REFERENCES Cliente(CF_Cliente)
);

CREATE TABLE IF NOT EXISTS Itinerario(
	Id_Escursione INT UNSIGNED PRIMARY KEY,
	FOREIGN KEY(Id_Escursione) REFERENCES Escursione(Id_Escursione)
);

CREATE TABLE IF NOT EXISTS Area(
	Id_Area INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Nome_Area VARCHAR(100) DEFAULT '',
    Estensione INT UNSIGNED DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Guida(
	Id_Guida INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Nome_Guida VARCHAR(100) DEFAULT '',
    Cognome_Guida VARCHAR(100) DEFAULT ''
);

CREATE TABLE IF NOT EXISTS Sosta_Escursione(
	Id_Escursione INT UNSIGNED NOT NULL,
    Id_Area INT UNSIGNED NOT NULL,
    Ora_Inizio TIMESTAMP NOT NULL,
    Id_Guida INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_Escursione, Id_Area),
	FOREIGN KEY(Id_Escursione) REFERENCES Itinerario(Id_Escursione),
    FOREIGN KEY(Id_Area) REFERENCES Area(Id_Area),
    FOREIGN KEY(Id_Guida) REFERENCES Guida(Id_Guida)
);

/* Area Viola */

CREATE TABLE IF NOT EXISTS Ordine(
	Nome_Utente VARCHAR(50) NOT NULL,
    Id_Ordine INT UNSIGNED NOT NULL,
    Num_Composizioni INT UNSIGNED DEFAULT 0,
    Stato_Ordine VARCHAR(20) DEFAULT 'in processazione',
    Pagato VARCHAR(2) DEFAULT 'Si',
    Prezzo_Totale INT UNSIGNED DEFAULT 0,
    Data_Ordine DATE NOT NULL, 
    
    PRIMARY KEY(Nome_Utente, Id_Ordine),
    FOREIGN KEY(Nome_Utente) REFERENCES Account(Nome_Utente)
);

CREATE TABLE IF NOT EXISTS Composizione_Ordine(
	Id_Composizione INT UNSIGNED NOT NULL,
    Id_Ordine INT UNSIGNED NOT NULL,
	Nome_Utente VARCHAR(50) NOT NULL,
    Prezzo_Parziale_Ordine DOUBLE DEFAULT 0,
    Qt_Prodotti INT UNSIGNED DEFAULT 0,

    PRIMARY KEY(Id_Composizione, Id_Ordine, Nome_Utente)
);
/*ALTER TABLE Composizione_Ordine
ADD FOREIGN KEY (Nome_Utente,Id_Ordine) REFERENCES Ordine(Nome_Utente,Id_Ordine);*/

CREATE TABLE IF NOT EXISTS Silos(
	Codice_Silos INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Capacita DOUBLE NOT NULL,
    Liv_Riempimento DOUBLE DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Formaggio(
    Nome VARCHAR(15) PRIMARY KEY,
    Tipo_pasta VARCHAR(15) NOT NULL,
    Qt_Latte DOUBLE UNSIGNED NOT NULL,
    Deperibilita VARCHAR(2) NOT NULL,
    Stagionatura VARCHAR(2) NOT NULL,
    Zona_Origine VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS Laboratorio(
	Id_lab INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Lotto(
	Id_Lotto INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Data_prod DATE NOT NULL,
    Data_scad DATE NOT NULL,
    Id_lab INT UNSIGNED NOT NULL,
    
    FOREIGN KEY(Id_lab) REFERENCES Laboratorio(Id_lab)
);

CREATE TABLE IF NOT EXISTS Magazzino(
	Id_Magazzino INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
);
CREATE TABLE IF NOT EXISTS Cantina(
	Id_Cantina INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Scaf_Cantina(
	Id_Cantina INT UNSIGNED,
	Id_Scaff_Cantina INT UNSIGNED,
    Quante_Postazioni INT UNSIGNED NOT NULL,
    Id_Scaff_Succ INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_Cantina,Id_Scaff_Cantina),
    FOREIGN KEY(Id_Cantina) REFERENCES Cantina(Id_Cantina)
);

CREATE TABLE IF NOT EXISTS Scaf_Magazzino(
	Id_Magazzino INT UNSIGNED,
	Id_Scaff_Magazzino INT UNSIGNED,
    Quante_Postazioni INT UNSIGNED NOT NULL,
    Id_Scaff_Succ INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_Magazzino,Id_Scaff_Magazzino),
    FOREIGN KEY(Id_Magazzino) REFERENCES Magazzino(Id_Magazzino)    
);

CREATE TABLE IF NOT EXISTS Unita(
	Id_Unita INT UNSIGNED NOT NULL,
    Nome VARCHAR(15) NOT NULL,
    Id_Lotto INT UNSIGNED NOT NULL,
    Codice_Silos INT UNSIGNED NOT NULL,
    Stato VARCHAR(15) NOT NULL,
    Peso INT UNSIGNED NOT NULL,
    Id_Cantina INT UNSIGNED,
    Id_Scaff_Cantina INT UNSIGNED,
    Id_Magazzino INT UNSIGNED,
    Id_Scaff_Magazzino INT UNSIGNED,
    
    PRIMARY KEY(Id_Unita, Nome),
    FOREIGN KEY(Codice_Silos) REFERENCES Silos(Codice_Silos),
    FOREIGN KEY(Nome) REFERENCES Formaggio(Nome),
    FOREIGN KEY(Id_Lotto) REFERENCES Lotto(Id_lotto)
);
ALTER TABLE Unita
ADD FOREIGN KEY(Id_Cantina,Id_Scaff_Cantina) REFERENCES Scaf_Cantina(Id_Cantina,Id_Scaff_Cantina);
ALTER TABLE Unita
ADD FOREIGN KEY(Id_Magazzino,Id_Scaff_Magazzino) REFERENCES Scaf_Magazzino(Id_Magazzino,Id_Scaff_Magazzino);

CREATE TABLE IF NOT EXISTS Prodotto(
	Id_Unita INT UNSIGNED NOT NULL,
    Nome VARCHAR(20) NOT NULL,
	Id_Composizione INT UNSIGNED NOT NULL,
    Id_Ordine INT UNSIGNED NOT NULL,
    Nome_Utente VARCHAR(50) NOT NULL,
	Prezzo DOUBLE UNSIGNED DEFAULT 0,
    FasciaPrezzo VARCHAR(9) DEFAULT '',
    
    PRIMARY KEY(Id_Unita, Nome)
);
ALTER TABLE Prodotto
ADD FOREIGN KEY(Id_Composizione, Id_Ordine, Nome_Utente) REFERENCES Composizione_Ordine(Id_Composizione, Id_Ordine, Nome_Utente);
ALTER TABLE Prodotto
ADD FOREIGN KEY(Id_Unita, Nome) REFERENCES Unita(Id_Unita, Nome);

CREATE TABLE IF NOT EXISTS Prodotto_Reso(
	Id_Unita INT UNSIGNED NOT NULL,
    Nome VARCHAR(20) NOT NULL,
    Problematiche VARCHAR(2555) DEFAULT '',
    
    PRIMARY KEY(Id_Unita, Nome)
);
ALTER TABLE Prodotto_Reso
ADD FOREIGN KEY(Id_Unita, Nome) REFERENCES Prodotto(Id_Unita, Nome);

CREATE TABLE IF NOT EXISTS Recensione(
	Id_Unita INT UNSIGNED NOT NULL,
    Nome VARCHAR(20) NOT NULL,
    Qualita_percepita INT UNSIGNED DEFAULT 1,
    Gradimento_generale INT UNSIGNED DEFAULT 1,
    Conservazione INT UNSIGNED DEFAULT 1,
    Gusto INT UNSIGNED DEFAULT 1,
    Altro VARCHAR(255) DEFAULT '',
    
    
    PRIMARY KEY(Id_Unita, Nome)
);
ALTER TABLE Recensione
ADD FOREIGN KEY(Id_Unita, Nome) REFERENCES Prodotto(Id_Unita, Nome);

CREATE TABLE IF NOT EXISTS Spedizione(
	Id_Spedizione INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Id_Ordine INT UNSIGNED NOT NULL,
    Nome_Utente VARCHAR(50) NOT NULL,
    Timestamp_Consegna TIMESTAMP NOT NULL,
    Stato VARCHAR(20) DEFAULT '',
    Data_Prevista_Consegna DATE NOT NULL
);
ALTER TABLE Spedizione
ADD FOREIGN KEY( Nome_Utente, Id_Ordine) REFERENCES Ordine(Nome_Utente, Id_Ordine);

CREATE TABLE IF NOT EXISTS Centro_Smistamento(
	Luogo VARCHAR(100) PRIMARY KEY NOT NULL,
    Ultimo_Hub BOOLEAN DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Traccia_Spedizione(
	Id_Spedizione INT UNSIGNED NOT NULL,
    DataEOra_Ril TIMESTAMP NOT NULL,
	Luogo VARCHAR(100) DEFAULT '',
    
    PRIMARY KEY(Id_Spedizione, DataEOra_Ril),
    FOREIGN KEY(Id_Spedizione) REFERENCES Spedizione(Id_Spedizione),
    FOREIGN KEY(Luogo) REFERENCES Centro_Smistamento(Luogo)
);



/* Area Gialla */

CREATE TABLE IF NOT EXISTS Mungitrice(
	Codice INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Id_Zona INT UNSIGNED NOT NULL,
    Marca VARCHAR(15) NOT NULL,
    Modello VARCHAR(15) NOT NULL,
    Coordinate VARCHAR(27) NOT NULL,
    
    FOREIGN KEY(Id_Zona) REFERENCES Zona(Id_Zona)
);
CREATE TABLE IF NOT EXISTS Mungitura(
	Codice_Mungitrice INT UNSIGNED NOT NULL,
    Id_loc INT UNSIGNED NOT NULL,
    Id_animale INT UNSIGNED NOT NULL,
	`Timestamp` TIMESTAMP NOT NULL,
    Qt_latte INT UNSIGNED DEFAULT 0,
    Codice_Silos INT UNSIGNED DEFAULT NULL,
    
    PRIMARY KEY(Codice_Mungitrice,Id_loc,Id_animale,`Timestamp`),
    FOREIGN KEY(Id_loc) REFERENCES Locale(Id_loc),
    FOREIGN KEY(Id_animale) REFERENCES Animale(Id_animale),
    FOREIGN KEY(Codice_Mungitrice) REFERENCES Mungitrice(Codice),
    FOREIGN KEY(Codice_Silos) REFERENCES Silos(Codice_Silos)
);

CREATE TABLE IF NOT EXISTS Sostanza(
	Codice INT UNSIGNED NOT NULL,
    Id_loc INT UNSIGNED NOT NULL,
    Id_animale INT UNSIGNED NOT NULL,
	`Timestamp` TIMESTAMP NOT NULL,
	Nome VARCHAR(15) NOT NULL,
	Quantita DOUBLE UNSIGNED NOT NULL,
    
    PRIMARY KEY(Codice,Id_loc,Id_animale,`Timestamp`,Nome)
);
ALTER TABLE Sostanza 
ADD FOREIGN KEY(Codice, Id_loc,Id_animale,`Timestamp`) REFERENCES Mungitura(Codice_Mungitrice,Id_loc,Id_animale,`Timestamp`);

CREATE TABLE IF NOT EXISTS Ph_Ricetta(
	Id_Ph_Ricetta INT UNSIGNED NOT NULL,
    Nome VARCHAR(15) NOT NULL,
    Temp_latte DOUBLE UNSIGNED NOT NULL,
    Durata_Ideale DOUBLE UNSIGNED NOT NULL,
    Temp_riposo DOUBLE UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_Ph_Ricetta, Nome),
    FOREIGN KEY(Nome) REFERENCES Formaggio(Nome)
);
CREATE TABLE IF NOT EXISTS Ril_Cantina(
	Id_Cantina INT UNSIGNED NOT NULL,
    `Timestamp` TIMESTAMP NOT NULL,
    Ventilazione DOUBLE NOT NULL,
    Liv_temp DOUBLE NOT NULL,
    Liv_umido DOUBLE NOT NULL,
    
    PRIMARY KEY(Id_Cantina,`Timestamp`),
    FOREIGN KEY(Id_Cantina) REFERENCES Cantina(Id_Cantina)
);

CREATE TABLE IF NOT EXISTS Ph_Processo(
	Id_Ph_Processo INT UNSIGNED NOT NULL,
    Id_Unita INT UNSIGNED NOT NULL,
    Nome VARCHAR(15) NOT NULL,
	`Timestamp` TIMESTAMP NOT NULL,
    Temp_latte DOUBLE UNSIGNED NOT NULL,
    Durata_Reale DOUBLE UNSIGNED NOT NULL,
    Temp_riposo DOUBLE UNSIGNED NOT NULL,
    
    PRIMARY KEY(Id_Ph_Processo, Id_Unita, Nome)
);
ALTER TABLE Ph_Processo
ADD FOREIGN KEY(Id_Unita, Nome) REFERENCES Unita(Id_Unita, Nome);


CREATE TABLE IF NOT EXISTS Dipendente(
	Id_dip INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Id_lab INT UNSIGNED NOT NULL,
    
    FOREIGN KEY(Id_lab) REFERENCES Laboratorio(Id_lab)
);

/* Area Azzurra */

CREATE TABLE IF NOT EXISTS Scheda_Medica(
	Id_animale INT UNSIGNED PRIMARY KEY NOT NULL,
    
     FOREIGN KEY(Id_animale) REFERENCES Animale(Id_animale)
);

CREATE TABLE IF NOT EXISTS Visita_Controllo(
	Id_visita INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Id_animale INT UNSIGNED NOT NULL,
    Id_Vet INT UNSIGNED NOT NULL,
    Gen1 INT UNSIGNED DEFAULT 0,
    Id_rip INT UNSIGNED DEFAULT 0,
    Vigilanza BOOLEAN DEFAULT 0,
    Pelo VARCHAR(6) DEFAULT '',
    Data DATE NOT NULL,
    Magra DOUBLE DEFAULT 0,
    Grassa DOUBLE DEFAULT 0,
    Idratazione DOUBLE DEFAULT 0,
    Respiro DOUBLE DEFAULT 0,
    Stato BOOLEAN DEFAULT 0,
    Deamb BOOLEAN DEFAULT 0,
    
	 FOREIGN KEY(Id_animale) REFERENCES Animale(Id_animale),
     FOREIGN KEY(Id_Vet) REFERENCES Veterinario(Id_Vet)
);
ALTER TABLE Visita_Controllo
ADD FOREIGN KEY(Id_rip, Gen1) REFERENCES Gravidanza(Id_rip, Gen1);

CREATE TABLE IF NOT EXISTS Misurazione(
	Id_Mis INT UNSIGNED NOT NULL,
    Data_Rilev DATE NOT NULL,
	Id_animale INT UNSIGNED NOT NULL,
    Id_visita INT UNSIGNED NOT NULL,
    Risp_Oculare BOOLEAN DEFAULT 0,
    Pancreas BOOLEAN DEFAULT 0,
    Emocromo VARCHAR(255) DEFAULT '',
    Zoccolo BOOLEAN DEFAULT 0,
    
    PRIMARY KEY(Id_Mis, Data_Rilev),
	FOREIGN KEY(Id_animale) REFERENCES Scheda_Medica(Id_animale),
	FOREIGN KEY(Id_visita) REFERENCES Visita_Controllo(Id_visita)
);

CREATE TABLE IF NOT EXISTS Disturbo(
	Nome VARCHAR(50) NOT NULL,
    Data_Rilev DATE NOT NULL,
    Entita VARCHAR(50) NOT NULL,
	Id_animale INT UNSIGNED NOT NULL,
    Id_visita INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Nome, Data_Rilev, Entita),
	FOREIGN KEY(Id_animale) REFERENCES Scheda_Medica(Id_animale),
	FOREIGN KEY(Id_visita) REFERENCES Visita_Controllo(Id_visita)
);

CREATE TABLE IF NOT EXISTS Lesione(
	Tipo VARCHAR(50) NOT NULL,
    Data_Rilev DATE NOT NULL,
    Entita VARCHAR(50) NOT NULL,
    Parte_Corpo VARCHAR(50) DEFAULT '',
	Id_animale INT UNSIGNED NOT NULL,
    Id_visita INT UNSIGNED NOT NULL,
    
    PRIMARY KEY(Tipo, Data_Rilev, Entita),
	FOREIGN KEY(Id_animale) REFERENCES Scheda_Medica(Id_animale),
	FOREIGN KEY(Id_visita) REFERENCES Visita_Controllo(Id_visita)
);

CREATE TABLE IF NOT EXISTS Quarantena(
	Id_animale INT UNSIGNED NOT NULL,
    Id_visita INT UNSIGNED NOT NULL,
    Data DATE NOT NULL, 
    
    PRIMARY KEY(Id_animale, Data),
	FOREIGN KEY(Id_animale) REFERENCES Animale(Id_animale),
	FOREIGN KEY(Id_visita) REFERENCES Visita_Controllo(Id_visita)
);

CREATE TABLE IF NOT EXISTS Patologia(
	Id_animale INT UNSIGNED NOT NULL,
    Id_Pat INT UNSIGNED NOT NULL,
    Data_Guarigione DATE DEFAULT NULL,
    Nome_Patologia VARCHAR(100) DEFAULT '',
    Id_visita INT UNSIGNED DEFAULT NULL,
    Id_Esame INT UNSIGNED DEFAULT NULL,
    
	PRIMARY KEY(Id_animale, Id_Pat),
    FOREIGN KEY(Id_animale) REFERENCES Animale(Id_animale),
    FOREIGN KEY(Id_visita) REFERENCES Visita_Controllo(Id_visita),
    FOREIGN KEY(Id_Esame) REFERENCES Esame(Id_Esame)
);

CREATE TABLE IF NOT EXISTS Terapia(
	Id_Terapia INT UNSIGNED NOT NULL,
    Id_Pat INT UNSIGNED NOT NULL,
    Id_animale INT UNSIGNED NOT NULL,
    Id_Vet INT UNSIGNED NOT NULL,
    Id_Esame INT UNSIGNED DEFAULT NULL,
    Data_In DATE NOT NULL,
    Durata INT UNSIGNED NOT NULL,
	
    PRIMARY KEY(Id_Terapia, Id_Pat, Id_animale),
	FOREIGN KEY(Id_Vet) REFERENCES Veterinario(Id_Vet),
    FOREIGN KEY(Id_Esame) REFERENCES Esame(Id_Esame)
);
ALTER TABLE Terapia
ADD FOREIGN KEY(Id_animale, Id_Pat) REFERENCES Patologia(Id_animale, Id_Pat);

CREATE TABLE IF NOT EXISTS Posologia(
	Id_Posologia INT UNSIGNED NOT NULL,
	Id_Terapia INT UNSIGNED NOT NULL,
    Id_Pat INT UNSIGNED NOT NULL,
    Id_animale INT UNSIGNED NOT NULL,
    Gg_Pausa INT UNSIGNED NOT NULL,
    
	PRIMARY KEY(Id_Posologia, Id_Terapia, Id_Pat, Id_animale)
);
ALTER TABLE Posologia
ADD FOREIGN KEY(Id_Terapia, Id_Pat, Id_animale) REFERENCES Terapia(Id_Terapia, Id_Pat, Id_animale);

CREATE TABLE IF NOT EXISTS Farmaco(
	Id_Farmaco INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS Integratore(
	Id_Integratore INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Sostanze_Nutritive VARCHAR(255) DEFAULT ''
);

CREATE TABLE IF NOT EXISTS Somministrazione(
	Id_Posologia INT UNSIGNED NOT NULL,
	Id_Terapia INT UNSIGNED NOT NULL,
    Id_Pat INT UNSIGNED NOT NULL,
    Id_animale INT UNSIGNED NOT NULL,
	Dosaggio DOUBLE UNSIGNED NOT NULL,
    Id_Farmaco INT UNSIGNED DEFAULT 0,
    Id_Integratore INT UNSIGNED DEFAULT 0,
	Ora TIMESTAMP NOT NULL,
    
    
	PRIMARY KEY(Ora, Id_Posologia, Id_Terapia, Id_Pat, Id_animale),
     FOREIGN KEY(Id_Farmaco) REFERENCES Farmaco(Id_Farmaco),
    FOREIGN KEY(Id_Integratore) REFERENCES Integratore(Id_Integratore)
	);
ALTER TABLE Somministrazione
ADD FOREIGN KEY(Id_Posologia, Id_Terapia, Id_Pat, Id_animale) REFERENCES Posologia(Id_Posologia, Id_Terapia, Id_Pat, Id_animale);