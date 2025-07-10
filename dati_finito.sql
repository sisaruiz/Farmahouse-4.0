/*Inserisco un agriturismo*/
INSERT INTO Agriturismo(Nome_agr) VALUES("Agriturismo1");
/*Inserisco quattro stalle*/
INSERT INTO Stalla VALUES(1, 1);
INSERT INTO Stalla VALUES(2, 1);
INSERT INTO Stalla VALUES(3, 1);
INSERT INTO Stalla VALUES(4, 1);
/*Inserisco 3 allestimenti (uno per ogni specie)*/
INSERT INTO Allestimento() VALUES();
INSERT INTO Allestimento() VALUES();
INSERT INTO Allestimento() VALUES();
/*Inserisco 3 specie; per ogni specie inserisco due razze: tutti sono della stessa famiglia*/
INSERT INTO Specie VALUES('mucca', 'calvana', 'bovidi');
INSERT INTO Specie VALUES('mucca', 'chianina', 'bovidi');
INSERT INTO Specie VALUES('pecora', 'sarda', 'bovidi');
INSERT INTO Specie VALUES('pecora', 'massese', 'bovidi');
INSERT INTO Specie VALUES('capra', 'sarda', 'bovidi');
INSERT INTO Specie VALUES('capra', 'frontalasca', 'bovidi');
/*Inserisco 6 locali, due per ogni specie, uno per ogni razza: due locali si trovano nella stalla 1 (mucche), 
2 locali si trovano nella stalla 2 (pecore), 2 locali si trovano nella stalla 3 (capre)
tutti stanno nello stesso agriturismo, tutti localizzati a sud*/
INSERT INTO Locale(Num_stalla, Id_Agr, Pt_card, Coordinate, Tipo_pav, Num_max_an, Id_a, Nome_specie, Nome_razza, num_animali) 
		VALUES(1,1,'sud', "(51,100)", "grigliato", 60, 1, "mucca", "calvana", 2);
INSERT INTO Locale(Num_stalla, Id_Agr, Pt_card, Coordinate, Tipo_pav, Num_max_an, Id_a, Nome_specie, Nome_razza, num_animali) 
		VALUES(2,1,'sud',"(52,100)", "a fessure", 60, 2, "pecora", "sarda", 1);
INSERT INTO Locale(Num_stalla, Id_Agr, Pt_card, Coordinate, Tipo_pav, Num_max_an, Id_a, Nome_specie, Nome_razza, num_animali) 
		VALUES(3,1,'sud',"(53,100)", "a fori", 60, 3, "capra", "sarda", 1);
INSERT INTO Locale(Num_stalla, Id_Agr, Pt_card, Coordinate, Tipo_pav, Num_max_an, Id_a, Nome_specie, Nome_razza, num_animali) 
		VALUES(1,1,'sud', "(54,100)", "grigliato", 60, 1, "mucca", "chianina", 1);
INSERT INTO Locale(Num_stalla, Id_Agr, Pt_card, Coordinate, Tipo_pav, Num_max_an, Id_a, Nome_specie, Nome_razza, num_animali) 
		VALUES(2,1,'sud',"(55,100)", "a fessure", 60, 2, "pecora", "massese", 2);
INSERT INTO Locale(Num_stalla, Id_Agr, Pt_card, Coordinate, Tipo_pav, Num_max_an, Id_a, Nome_specie, Nome_razza, num_animali) 
		VALUES(3,1,'sud',"(56,100)", "a fori", 60, 3, "capra", "frontalasca", 2);
/*Inserisco un fornitore*/
INSERT INTO Fornitore VALUES(00000000001, "Matteo", "FornituraAnimali");
/*Inserisco l'indirizzo del fornitore*/
INSERT INTO Indirizzo_F VALUES(1, "Via Roma", "Pisa", 56126, 00000000001);
/*Inserisco 3 animali per ogni specie, per una totalità di 9 animali, tutti sono stati acquistati dallo
stesso fornitore*/
INSERT INTO Animale(Nome_specie, Nome_razza, Id_loc, Sesso, Peso, Altezza, Data_nascita, Partita_iva, Dt_arr, Dt_acq) 
			VALUES("mucca", "calvana", 1, "Femmina", 500, 150, '2002-02-18', 00000000001, '2002-03-01', '2002-03-01');
INSERT INTO Animale(Nome_specie, Nome_razza, Id_loc, Sesso, Peso, Altezza, Data_nascita, Partita_iva, Dt_arr, Dt_acq)
			VALUES("mucca", "calvana", 1, "Maschio", 510, 160, '2001-02-18', 00000000001, '2001-03-01', '2001-03-01');
INSERT INTO Animale(Nome_specie, Nome_razza, Id_loc, Sesso, Peso, Altezza, Data_nascita, Partita_iva, Dt_arr, Dt_acq)
			VALUES("mucca", "chianina", 1, "Femmina", 900, 165, '2003-02-18', 00000000001, '2003-03-01', '2003-03-01');
INSERT INTO Animale(Nome_specie, Nome_razza, Id_loc, Sesso, Peso, Altezza, Data_nascita, Partita_iva, Dt_arr, Dt_acq)
			VALUES("pecora", "sarda", 2, "Femmina", 40, 65, '2010-02-18', 00000000001, '2010-03-01', '2010-03-01');
INSERT INTO Animale(Nome_specie, Nome_razza, Id_loc, Sesso, Peso, Altezza, Data_nascita, Partita_iva, Dt_arr, Dt_acq)
			VALUES("pecora", "massese", 2, "Femmina", 65 , 75, '2015-02-18', 00000000001, '2015-03-01', '2015-03-01');
INSERT INTO Animale(Nome_specie, Nome_razza, Id_loc, Sesso, Peso, Altezza, Data_nascita, Partita_iva, Dt_arr, Dt_acq)
			VALUES("pecora", "massese", 2, "Maschio", 90, 85, '2015-02-18', 00000000001, '2015-03-01', '2015-03-01');
INSERT INTO Animale(Nome_specie, Nome_razza, Id_loc, Sesso, Peso, Altezza, Data_nascita, Partita_iva, Dt_arr, Dt_acq)
			VALUES("capra", "sarda", 3, "Femmina", 45, 70, '2002-02-18', 00000000001, '2002-03-01', '2002-03-01');
INSERT INTO Animale(Nome_specie, Nome_razza, Id_loc, Sesso, Peso, Altezza, Data_nascita, Partita_iva, Dt_arr, Dt_acq)
			VALUES("capra", "frontalasca", 3, "Femmina", 65, 78, '2003-02-18', 00000000001, '2003-03-01', '2002-03-01');
INSERT INTO Animale(Nome_specie, Nome_razza, Id_loc, Sesso, Peso, Altezza, Data_nascita, Partita_iva, Dt_arr, Dt_acq)
			VALUES("capra", "frontalasca", 3, "Maschio", 75, 80, '2001-02-18', 00000000001, '2001-03-01', '2002-03-01');
/*Inserisco 6 dimensioni locale, una per ogni locale inserito*/
INSERT INTO Dimensione_Locale VALUES(1, 300, 60, 60 );
INSERT INTO Dimensione_Locale VALUES(2, 200, 60, 60 );
INSERT INTO Dimensione_Locale VALUES(3, 200, 60, 60 );
INSERT INTO Dimensione_Locale VALUES(4, 300, 60, 60 );
INSERT INTO Dimensione_Locale VALUES(5, 200, 60, 60 );
INSERT INTO Dimensione_Locale VALUES(6, 200, 60, 60 );
/*Inserisco una rilevazione per ogni locale*/
INSERT INTO Rilevazione_Locale VALUES(1, 1, 0.3, 0.4, '2019-02-19 10:00:00', 0.5, 0.4);
INSERT INTO Rilevazione_Locale VALUES(1, 2, 0.7, 0.4, '2019-02-19 10:00:00', 0.5, 0.5);
INSERT INTO Rilevazione_Locale VALUES(1, 3, 0.3, 0.8, '2019-02-19 10:00:00', 0.6, 0.5);
INSERT INTO Rilevazione_Locale VALUES(1, 4, 0.5, 0.4, '2019-02-19 10:00:00', 0.6, 0.4);
INSERT INTO Rilevazione_Locale VALUES(1, 5, 0.2, 0.7, '2019-02-19 10:00:00', 0.5, 0.5);
INSERT INTO Rilevazione_Locale VALUES(1, 6, 0.3, 0.5, '2019-02-19 10:00:00', 0.5, 0.4);
/*Inserisco 10 zone (tutte quelle di cui è provvisto l'agriturismo*/
INSERT INTO Zona VALUES();
INSERT INTO Zona VALUES();
INSERT INTO Zona VALUES();
INSERT INTO Zona VALUES();
INSERT INTO Zona VALUES();
INSERT INTO Zona VALUES();
INSERT INTO Zona VALUES();
INSERT INTO Zona VALUES();
INSERT INTO Zona VALUES();
INSERT INTO Zona VALUES();
/*Inserisco 3 attività di pascolo per ogni animale dell'agriturismo: 1 nell'ultimo anno, 1 nell'ultimo mese,
1 nell'ultima settimana, con le zone a caso*/
INSERT INTO Pascolo VALUES(1, 1, "2016-02-18", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(2, 1, "2020-02-01", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(3, 1, "2020-02-21", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(4, 2, "2020-02-01", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(5, 2, "2016-02-18", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(6, 2, "2020-02-21", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(7, 3, "2016-02-18", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(8, 3,  "2020-02-01", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(9, 3, "2020-02-21", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(10, 4, "2016-02-17", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(1, 4, "2020-02-02", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(2, 4, "2020-02-22", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(3, 5, "2016-02-17", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(4, 5, "2020-02-02", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(5, 5, "2020-02-22", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(6, 6, "2016-02-17", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(7, 6, "2020-02-02", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(8, 6, "2020-02-22", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(9, 7, "2016-02-16", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(10, 7, "2020-02-03", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(1, 7, "2020-02-23", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(2, 8, "2016-02-16", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(3, 8, "2020-02-03", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(4, 8, "2020-02-23", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(5, 9, "2016-02-16", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(6, 9, "2020-02-03", "10:00:00", "13:00:00");
INSERT INTO Pascolo VALUES(7, 9, "2020-02-23", "10:00:00", "13:00:00");
/*Inserisco una rilevazione GPS per ogni attività di pascolo, per ogni animale che vi ha partecipato*/
INSERT INTO  Rilev_GPS VALUES(1,'2016-02-18 12:00:00',"(0,100)",1,"2016-02-18", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(1, '2020-02-01 12:00:00',"(50,100)", 2, "2020-02-01", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(1,'2020-02-21 12:00:00',"(0,50)",3,"2020-02-21", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(2, '2020-02-01 12:00:00',"(50,50)", 4, "2020-02-01", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(2,'2016-02-18 12:00:00',"(0,75)", 5,"2016-02-18", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(2, '2020-02-21, 12:00:00',"(0,25)", 6, "2020-02-21", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(3, '2016-02-18 12:00:00',"(50,0)", 7,"2016-02-18","10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(3, '2020-02-01 12:00:00',"(100,0)",8, "2020-02-01", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(3, '2020-02-21 12:00:00',"(100,50)", 9,"2020-02-21", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(4, '2016-02-17 12:00:00', "(100,25)", 10,"2016-02-17", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(4, '2020-02-02 12:00:00',"(0,100)", 1,"2020-02-02", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(4, '2020-02-22 12:00:00',"(50,100)", 2,"2020-02-22", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(5, '2016-02-17 12:00:00', "(0,50)", 3, "2016-02-17", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(5, '2020-02-02 12:00:00', "(50,50)", 4, "2020-02-02", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(5, '2020-02-22 12:00:00',"(10,75)", 5,"2020-02-22", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(6, '2016-02-17 12:00:00', "(0,25)", 6, "2016-02-17", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(6, '2020-02-02 12:00:00',"(50,0)", 7,"2020-02-02", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(6, '2020-02-22 12:00:00',"(100,0)", 8, "2020-02-22", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(7, '2016-02-16 12:00:00', "(100,50)", 9, "2016-02-16", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(7, '2020-02-03 12:00:00', "(100,25)", 10,"2020-02-03", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(7, '2020-02-23 12:00:00', "(0,100)",1,"2020-02-23", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(8,'2016-02-16 12:00:00',"(50,100)",2,"2016-02-16", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(8, '2020-02-03 12:00:00', "(0,50)", 3,"2020-02-03", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(8, '2020-02-23 12:00:00',"(0,50)", 4, "2020-02-23", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(9,'2016-02-16 12:00:00', "(0,75)", 5, "2016-02-16", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(9, '2020-02-03 12:00:00', "(0,25)", 6,"2020-02-03", "10:00:00", "13:00:00");
INSERT INTO  Rilev_GPS VALUES(9, '2020-02-23 12:00:00', "(50,0)",7, "2020-02-23", "10:00:00", "13:00:00");
/*Inserisco un veterinario*/
INSERT INTO Veterinario VALUES();
/*Inserisco un tentativo di riproduzione tra la mucca 1 femmina e la mucca 2 maschio*/
INSERT INTO Tentativo_Riproduzione VALUES(1, 1, 2, 1, "2019-06-17", "10:00:00", 1);
/*Inserisco una riga coerente nella tabella Partecipazione*/
INSERT INTO Partecipazione VALUES(1, 1, 2);
/*Inserisco una gravidanza coerente con il tentativo di riproduzione*/
INSERT INTO Gravidanza VALUES(1,1,1);
/*Inserisco una scheda di gestazione coerente con la gravidanza*/
INSERT INTO Scheda_Gestazione VALUES(1,1,1);
/*Inserisco 6 clienti*/
INSERT INTO Cliente VALUES("ABC123");
INSERT INTO Cliente VALUES("DEF456");
INSERT INTO Cliente VALUES("GHI789");
INSERT INTO Cliente VALUES("JKL123");
INSERT INTO Cliente VALUES("MNO456");
INSERT INTO Cliente VALUES("PQR789");
/*Inserisco 3 clienti registrati*/
INSERT INTO Cliente_Registrato VALUES("DEF456", "Marta", "Penna", "Via Trento 32", 000001, "2015-02-17", 34009063);
INSERT INTO Cliente_Registrato VALUES("GHI789", "Ugo", "Gomma", "Via Mazzini 74", 000005, "2015-02-16", 34006090);
INSERT INTO Cliente_Registrato VALUES("JKL123", "Camilla", "Rosa", "Via Carone 5", 000006, "2015-02-16", 34006890);
/*Creo un account per ogni cliente registrato*/
INSERT INTO Account VALUES("Marta99", "Marta99!", "Nome di tuo padre:", "Mario", "DEF456");
INSERT INTO Account VALUES("Ugo99", "Ugo99!", "Data di nascita:","2015-02-17","GHI789");
INSERT INTO Account VALUES("Camilla99", "Camilla99!", "Colore preferito:", "Rosso", "JKL123");
/*Inserisco 4 camere: 3 camere semplici e 1 suite*/
INSERT INTO Camera(Num_Singoli, Num_Matrimoniali, Capienza, Tipo, Costo_gg) VALUES(1, 0, 1, "Semplice", 20);
INSERT INTO Camera(Num_Singoli, Num_Matrimoniali, Capienza, Tipo, Costo_gg) VALUES(1, 0, 1, "Semplice", 20);
INSERT INTO Camera(Num_Singoli, Num_Matrimoniali, Capienza, Tipo, Costo_gg) VALUES(1, 0, 1, "Semplice", 20);
INSERT INTO Camera(Num_Singoli, Num_Matrimoniali, Capienza, Tipo, Costo_gg) VALUES(1, 1, 2, "Suite", 40);
/*Inserisco 1 composizione per ogni ordine, in totale ho 1 ordine per ogni tipologia di formaggio*/
/* ordine 1 di marta: acquista 2 stracchino*/
INSERT INTO Composizione_Ordine VALUES(1, 1, "Marta99", 30,2);
/*ordine 2 di marta: acquista 3 scamorza*/
INSERT INTO Composizione_Ordine VALUES(1, 2, "Marta99", 48 ,3);
/*Ordine 3 di marta: acquista 1 caprino*/
INSERT INTO Composizione_Ordine VALUES(1, 3, "Marta99", 30 ,1);
/*Ordine 1 composizione 1 di camilla, ordina 1 robiola*/
INSERT INTO Composizione_Ordine VALUES(1, 1, "Camilla99", 16 ,1);
/*Ordine 1 composizione 2 di camilla, ordina 1 grana*/
INSERT INTO Composizione_Ordine VALUES(2, 1, "Camilla99", 26 ,1);
/*Ordine 2 composizione 1 di camilla, ordina 7 ricotta*/
INSERT INTO Composizione_Ordine VALUES(1, 2, "Camilla99", 14 ,2);
/*Ordine 1 composizione 1 di ugo, ordina 2 gorgonzola*/
INSERT INTO Composizione_Ordine VALUES(1, 1, "Ugo99", 10 ,2);
/*Ordine 2 composizione 1 di ugo, ordina 1 burrata*/
INSERT INTO Composizione_Ordine VALUES(1, 2, "Ugo99", 20 ,1);
/*Ordine 1 composizione 1 di paolo, ordina 3 caciocavallo*/
INSERT INTO Composizione_Ordine VALUES(1, 1, "Paolo99", 21 ,3);
/*Ordine 1 composizione 2 di paolo, ordina 10 mozzarella*/
INSERT INTO Composizione_Ordine VALUES(2, 1, "Paolo99", 20 ,2);

/*Inserisco 10 silos*/
INSERT INTO Silos(Capacita) VALUES(50.000);
INSERT INTO Silos(Capacita) VALUES(50.000);
INSERT INTO Silos(Capacita) VALUES(50.000);
INSERT INTO Silos(Capacita) VALUES(50.000);
INSERT INTO Silos(Capacita) VALUES(50.000);
INSERT INTO Silos(Capacita) VALUES(50.000);
INSERT INTO Silos(Capacita) VALUES(50.000);
INSERT INTO Silos(Capacita) VALUES(50.000);
INSERT INTO Silos(Capacita) VALUES(50.000);
INSERT INTO Silos(Capacita) VALUES(50.000);

/*Inserisco 1 magazzino*/
INSERT INTO Magazzino VALUES();
/*Inserisco 3 scaffali del magazzino, uno per ogni tipo che non deve stagionare (in un magazzino ho 10 scaffali)*/
/*per mozzarella*/
INSERT INTO Scaf_Magazzino VALUES(1, 1, 300, 2);
/*Per burrata*/
INSERT INTO Scaf_Magazzino VALUES(1, 2, 300, 3);
/*per ricotta*/
INSERT INTO Scaf_Magazzino VALUES(1, 3, 300, 4);
/*Inserisco 1 cantina*/
INSERT INTO Cantina VALUES();
/*Inserisco 7 scaffali della cantina, uno per ogni tipo che deve stagionare (in una cantina
ho 8 scaffali)*/
/*Per stracchino*/
INSERT INTO Scaf_Cantina VALUES(1, 1, 300, 2);
/*Per Scamorza*/
INSERT INTO Scaf_Cantina VALUES(1, 2, 300, 3);
/*Per caprino*/
INSERT INTO Scaf_Cantina VALUES(1, 3, 300, 4);
/*per robiola*/
INSERT INTO Scaf_Cantina VALUES(1, 4, 300, 5);
/*per grana*/
INSERT INTO Scaf_Cantina VALUES(1, 5, 300, 6);
/*per gorgonzola*/
INSERT INTO Scaf_Cantina VALUES(1, 6, 300, 7);
/*per caciocavallo*/
INSERT INTO Scaf_Cantina VALUES(1, 7, 300, 8);

/*Inserisco 10 formaggi*/
INSERT INTO Formaggio VALUES("Stracchino", "Molle", 5, "no", "si", "Lombardia");
INSERT INTO Formaggio VALUES("Scamorza", "Filata", 10, "no", "si", "Campania" );
INSERT INTO Formaggio VALUES("Caprino", "Molle", 5, "no", "si", "Abruzzo");
INSERT INTO Formaggio VALUES("Robiola", "Molle", 5, "no", "si", "Lombardia");
INSERT INTO Formaggio VALUES("Grana", "Dura", 15, "no", "si", "Lombardia");
INSERT INTO Formaggio VALUES("Gorgonzola", "Molle", 10, "no", "si", "Lombardia");
INSERT INTO Formaggio VALUES("Caciocavallo", "Filata", 10, "no", "si", "Puglia");
INSERT INTO Formaggio VALUES("Mozzarella", "Filata", 8, "si", "no", "Campania");
INSERT INTO Formaggio VALUES("Burrata", "Filata", 10, "si", "no", "Puglia");
INSERT INTO Formaggio VALUES("Ricotta", "Molle", 5, "si", "no", "Sardegna");

/*Inserisco un laboratorio*/
INSERT INTO Laboratorio VALUES();

/*Inserisco 10 lotti di produzione, 4 dell'ultimo mese (caciocavallo, gorgonzola, robiola, stracchino) 3 dell'ultima 
settimana (mozzarella, burrata, ricotta), i rimanenti per grana, caprino, scamorza*/
/*Per il grana lotto 1*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2018-02-18", "2023-02-18", 1);
/*Per il caprino lotto 2*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2020-01-18", "2023-01-18", 1);
/*Per la scamorza lotto 3*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2020-02-18", "2022-02-18", 1);
/*Per caciocavallo lotto 4*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2020-02-18", "2022-08-18", 1);
/*Per gorgonzola lotto 5*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2020-01-18", "2022-04-18", 1);
/*Per robiola lotto 6*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2020-02-18", "2021-04-28", 1);
/*Per stracchino lotto 7*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2020-01-18", "2020-08-18", 1);
/*Per mozzarella lotto 8*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2020-01-19", "2020-05-26", 1);
/*Per burrata lotto 9*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2020-02-18", "2020-12-26", 1);
/*Per ricotta lotto 10*/
INSERT INTO Lotto(Data_prod, Data_scad, Id_lab) VALUES("2020-01-18", "2020-05-26", 1);


/*Inserisco tante unità quanti sono i prodotti richiesti negli ordini*/
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina) 
			VALUES(1, "Stracchino", 7, 01, "disponibile", 1, 1, 1 );
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina) 
			VALUES(2, "Stracchino", 7, 01, "disponibile", 1, 1, 1);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina)  
			VALUES(1, "Scamorza", 3, 01, "disponibile", 1, 1, 2 );
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina) 
			VALUES(2,  "Scamorza", 3, 01, "disponibile", 1, 1, 2 );
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina) 
			VALUES(3,  "Scamorza", 3, 01, "disponibile", 1, 1, 2 );
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina) 
			VALUES(1, "Caprino", 2, 08, "disponibile", 1,1, 3 );
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina)  
			VALUES(1, "Robiola", 6, 05, "disponibile", 1, 1,4 );
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina) 
			VALUES(1, "Grana", 1, 01, "disponibile", 1,1, 5);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Magazzino,  Id_Scaff_Magazzino)
			VALUES(1, "Ricotta", 10, 05, "disponibile", 1, 1, 3);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Magazzino,  Id_Scaff_Magazzino)
			VALUES(2, "Ricotta", 10, 05, "disponibile", 1, 1, 3);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina) 
			VALUES(1, "Gorgonzola", 5, 01, "disponibile", 1, 1, 6);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina)
			VALUES(2, "Gorgonzola", 5, 01, "disponibile", 1, 1, 6);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Magazzino,  Id_Scaff_Magazzino)
			VALUES(1, "Burrata", 9, 01, "disponibile", 1, 1, 2);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina)
			VALUES(1, "Caciocavallo", 4, 01, "disponibile", 1, 1, 7);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina)
			VALUES(2, "Caciocavallo", 4, 01, "disponibile", 1, 1, 7);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Cantina, Id_Scaff_Cantina)
			VALUES(3, "Caciocavallo", 4, 01, "disponibile", 1, 1, 7);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Magazzino,  Id_Scaff_Magazzino)
			VALUES(1, "Mozzarella", 8, 01, "disponibile", 1, 1,1);
INSERT INTO Unita(Id_Unita, Nome, Id_Lotto ,  Codice_Silos, Stato, Peso, Id_Magazzino,  Id_Scaff_Magazzino)
			VALUES(2, "Mozzarella", 8, 01, "disponibile", 1,1, 1);
            
/*Inserisco tanti prodotti quanti sono quelli presenti nei vari ordini*/
INSERT INTO Prodotto VALUES(1, "Stracchino",1, 1, "Marta99", 15, "Media");
INSERT INTO Prodotto VALUES(2, "Stracchino", 1, 1, "Marta99", 15, "Media");
INSERT INTO Prodotto VALUES(1, "Scamorza", 1, 2, "Marta99", 16, "Media");
INSERT INTO Prodotto VALUES(2,  "Scamorza", 1, 2, "Marta99", 16, "Media" );
INSERT INTO Prodotto VALUES(3,  "Scamorza", 1, 2, "Marta99", 16, "Media");
INSERT INTO Prodotto VALUES(1, "Caprino", 1, 3, "Marta99", 30, "Alta");
INSERT INTO Prodotto VALUES(1, "Robiola",1, 1, "Camilla99", 16, "Media");
INSERT INTO Prodotto VALUES(1, "Grana", 2, 1, "Camilla99", 26, "Alta");
INSERT INTO Prodotto VALUES(1, "Ricotta",1, 2, "Camilla99", 7, "Economica" );
INSERT INTO Prodotto VALUES(2, "Ricotta", 1, 2, "Camilla99", 7, "Economica" );
INSERT INTO Prodotto VALUES(1, "Gorgonzola", 1, 1, "Ugo99", 5, "Economica");
INSERT INTO Prodotto VALUES(2, "Gorgonzola", 1, 1, "Ugo99", 5, "Economica");
INSERT INTO Prodotto VALUES(1, "Burrata", 1, 2, "Ugo99", 20, "Alta");
INSERT INTO Prodotto VALUES(1, "Caciocavallo", 1, 1, "Paolo99", 7, "Economica");
INSERT INTO Prodotto VALUES(2, "Caciocavallo", 1, 1, "Paolo99", 7, "Economica");
INSERT INTO Prodotto VALUES(3, "Caciocavallo", 1, 1, "Paolo99", 7, "Economica");
INSERT INTO Prodotto VALUES(1, "Mozzarella", 2, 1, "Paolo99", 10, "Media");
INSERT INTO Prodotto VALUES(2, "Mozzarella", 2, 1, "Paolo99", 10, "Media");

/*Inserisco 3 prodotti resi*/
INSERT INTO Prodotto_Reso VALUES(1, "Stracchino", "Colore, Consistenza");
INSERT INTO Prodotto_Reso VALUES(1, "Burrata", "Acidità, Integrità");
INSERT INTO Prodotto_Reso VALUES(1, "Gorgonzola", "Aroma, Acidità, Consistenza");
/*Inserisco 6 recensioni*/
INSERT INTO Recensione VALUES(1, "Scamorza", 5, 5, 5, 5, '');
INSERT INTO Recensione VALUES(1, "Grana", 5, 4, 3, 5, "Molto buono!");
INSERT INTO Recensione VALUES(1, "Ricotta", 3, 4, 5, 5, "Eccellente");
INSERT INTO Recensione VALUES(1, "Gorgonzola", 1, 1, 2, 1, "Ho dovuto restituire!");
INSERT INTO Recensione VALUES(1, "Caciocavallo", 5, 5, 4, 3, '' );
INSERT INTO Recensione VALUES(1, "Mozzarella", 5, 5, 5, 5,"Ottimo Prodotto!");
/*Credo 9 schede mediche, una per ogni animale*/
INSERT INTO Scheda_Medica VALUES(1);
INSERT INTO Scheda_Medica VALUES(2);
INSERT INTO Scheda_Medica VALUES(3);
INSERT INTO Scheda_Medica VALUES(4);
INSERT INTO Scheda_Medica VALUES(5);
INSERT INTO Scheda_Medica VALUES(6);
INSERT INTO Scheda_Medica VALUES(7);
INSERT INTO Scheda_Medica VALUES(8);
INSERT INTO Scheda_Medica VALUES(9);

/*Inserisco 2 farmaci*/
INSERT INTO Farmaco VALUES();
INSERT INTO Farmaco VALUES();

/*Inserisco 2 integratori*/
INSERT INTO Integratore(Sostanze_Nutritive) VALUES("Sali Minerali, Vitamine");
INSERT INTO Integratore(Sostanze_Nutritive) VALUES("Acidi Grassi");

/*Inserisco 6 mungitrici*/
INSERT INTO Mungitrice(Id_Zona, Marca, Modello, Coordinate) VALUES(1, "Mungitrix", "Per Mucche", "(0,100)");
INSERT INTO Mungitrice(Id_Zona, Marca, Modello, Coordinate) VALUES(2, "Mungitrix", "Per Mucche","(50,100)");
INSERT INTO Mungitrice(Id_Zona, Marca, Modello, Coordinate) VALUES(3, "Mungitrix", "Per Capre", "(0,50)");
INSERT INTO Mungitrice(Id_Zona, Marca, Modello, Coordinate) VALUES(4, "Mungitrix", "Per Capre", "(50,50)");
INSERT INTO Mungitrice(Id_Zona, Marca, Modello, Coordinate) VALUES(5, "Mungitrix", "Per Pecore", "(0,75)");
INSERT INTO Mungitrice(Id_Zona, Marca, Modello, Coordinate) VALUES(6, "Mungitrix", "Per Pecore", "(0,25)");

/*Inserisco 5 mungiture totali da mucche femmine, 3 mungiture di capre femmine, 6 mungiture di pecore femmine*/
/*Codice_Mungitrice,  Id_loc,  Id_animale, `Timestamp` */
/*mucche*/
INSERT INTO Mungitura VALUES(1, 1, 1, "2020-02-15 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(1, 1, 1, "2020-02-16 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(2, 4, 3, "2020-02-15 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(2, 4, 3, "2020-02-16 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(1, 1, 1, "2020-02-17 08:00:00",NULL,NULL);
/*capre*/
INSERT INTO Mungitura VALUES(3, 3, 7, "2020-02-15 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(3, 3, 7, "2020-02-16 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(4, 6, 8, "2020-02-17 08:00:00",NULL,NULL);
/*pecore*/
INSERT INTO Mungitura VALUES(5, 2, 4, "2020-02-15 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(5, 2, 4, "2020-02-16 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(5, 2, 4, "2020-02-17 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(6, 5, 5, "2020-02-17 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(6, 5, 5, "2020-02-16 08:00:00",NULL,NULL);
INSERT INTO Mungitura VALUES(6, 5, 5, "2020-02-15 08:00:00",NULL,NULL);

/*L'inserimento in latte lo facciamo fare all'operazione??*/

/*Inserisco la ricetta di ogni formaggio*/
/*Id_Ph_Ricetta, Nome, Temp_latte, Durata_Ideale, Temp_riposo*/
/*Ricetta di formaggi che non necessitano di stagionatura: 1 fase per ognuno*/
INSERT INTO Ph_Ricetta VALUES(1, "Mozzarella", 10, 10, 10);
INSERT INTO Ph_Ricetta VALUES(1, "Burrata", 20, 20, 20);
INSERT INTO Ph_Ricetta VALUES(1, "Ricotta", 30, 30, 30);
/*Ricetta di formaggi che necessitano di stagionatura: 2 fasi per ognuno */
INSERT INTO Ph_Ricetta VALUES(1, "Stracchino", 10, 10, 10);
INSERT INTO Ph_Ricetta VALUES(2, "Stracchino", 20, 40, 1);
INSERT INTO Ph_Ricetta VALUES(1, "Scamorza", 30, 30, 30);
INSERT INTO Ph_Ricetta VALUES(2, "Scamorza", 40, 10, 1);
INSERT INTO Ph_Ricetta VALUES(1, "Caprino", 50, 50, 50);
INSERT INTO Ph_Ricetta VALUES(2, "Caprino", 60, 180, 1);
INSERT INTO Ph_Ricetta VALUES(1, "Robiola", 70, 70, 70);
INSERT INTO Ph_Ricetta VALUES(2, "Robiola", 80, 9, 1);
INSERT INTO Ph_Ricetta VALUES(1, "Grana", 90, 90, 90);
INSERT INTO Ph_Ricetta VALUES(2, "Grana", 100, 6000, 1);
INSERT INTO Ph_Ricetta VALUES(1, "Gorgonzola", 10, 10, 10);
INSERT INTO Ph_Ricetta VALUES(2, "Gorgonzola", 20, 80, 1);
INSERT INTO Ph_Ricetta VALUES(1, "Caciocavallo", 30, 30, 30);
INSERT INTO Ph_Ricetta VALUES(2, "Caciocavallo", 40, 180, 1);

/*Per ogni unità prodotta, descrivo le fasi del processo produttivo*/
/* Timestamp, Temp_latte, Durata_Reale, Temp_riposo)*/
/*1, stracchino : lo stracchino ha 2 fasi, la seconda è la stagionatura, di cui non posso specificare la 
durata reale*/
INSERT INTO Ph_Processo VALUES(1, 1, "Stracchino", '2020-01-18 09:00:00', 10, 15, 12);
INSERT INTO Ph_Processo VALUES(2, 1, "Stracchino", '2020-01-18 09:15:00', 13, 0, 1);
/*2, stracchino, altre due fasi*/
INSERT INTO Ph_Processo VALUES(1, 2, "Stracchino", '2020-01-18 10:00:00', 13, 14, 15);
INSERT INTO Ph_Processo VALUES(2, 2, "Stracchino", '2020-01-18 10:14:00', 10, 0, 1);
/*1, scamorza, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 1, "Scamorza", '2020-02-18 09:00:00', 23, 24, 25);
INSERT INTO Ph_Processo VALUES(2, 1, "Scamorza", '2020-02-18 09:24:00', 20, 0, 1);
/*2, scamorza, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 2, "Scamorza", '2020-02-18 10:00:00', 20, 21, 22);
INSERT INTO Ph_Processo VALUES(2, 2, "Scamorza",'2020-02-18 10:21:00', 20, 0, 1);
/*3, scamorza, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 3, "Scamorza", '2020-02-18 11:00:00', 21, 20, 19);
INSERT INTO Ph_Processo VALUES(2, 3, "Scamorza", '2020-02-18 11:20:00', 21, 0, 1);
/*1, caprino, due fasi*/
INSERT INTO Ph_Processo VALUES(1, 1, "Caprino", '2020-01-18 09:00:00', 31, 30, 29);
INSERT INTO Ph_Processo VALUES(2, 1, "Caprino", '2020-01-18 09:30:00', 30, 0,1);
/*1, robiola, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 1, "Robiola", '2020-02-18 09:00:00', 40, 45, 20);
INSERT INTO Ph_Processo VALUES(2, 1, "Robiola", '2020-02-18 09:45:00', 25,0,1);
/*1, grana, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 1, "Grana", '2018-02-18 09:00:00', 50, 25, 15);
INSERT INTO Ph_Processo VALUES(2, 1, "Grana", '2018-02-18 09:25:00', 50, 0, 1);
/*1 ricotta, 1 fase*/
INSERT INTO Ph_Processo VALUES(1, 1, "Ricotta", '2020-01-18 09:00:00', 10, 15, 20);
/*2, ricotta, 1 fase*/
INSERT INTO Ph_Processo VALUES(1, 2, "Ricotta", '2020-01-18 10:00:00', 10, 15, 20);
/*1, gorgonzola, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 1, "Gorgonzola", '2020-01-18 09:00:00', 20, 25, 30);
INSERT INTO Ph_Processo VALUES(2, 1, "Gorgonzola", '2020-01-18 09:25:00', 30, 0, 1);
/*2, gorgonzola, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 2, "Gorgonzola", '2020-01-18 10:00:00', 20, 25, 30);
INSERT INTO Ph_Processo VALUES(2, 2, "Gorgonzola", '2020-01-18 10:25:00', 20, 0, 1);
/*1 burrata, 1 fase*/
INSERT INTO Ph_Processo VALUES(1, 1, "Burrata", '2020-02-18 09:00:00', 30, 35, 20);
/*1 caciocavallo, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 1, "Caciocavallo", '2020-02-18 09:00:00', 10, 15, 20);
INSERT INTO Ph_Processo VALUES(2, 1, "Caciocavallo", '2020-02-18 09:15:00', 15, 0,1);
/*2 caciocavallo, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 2, "Caciocavallo", '2020-02-18 10:00:00', 10, 15, 20);
INSERT INTO Ph_Processo VALUES(2, 2, "Caciocavallo",'2020-02-18 10:15:00', 10, 0, 1);
/*3 caciocavallo, 2 fasi*/
INSERT INTO Ph_Processo VALUES(1, 3, "Caciocavallo", '2020-02-18 11:00:00', 10, 15, 20);
INSERT INTO Ph_Processo VALUES(2, 3, "Caciocavallo", '2020-02-18 11:15:00', 10, 0, 1);
/*1 mozzarella, 1 fase*/
INSERT INTO Ph_Processo VALUES(1, 1, "Mozzarella", '2020-01-19 09:00:00', 10, 20, 30 );
/*2 mozzarella, 1 fase*/
INSERT INTO Ph_Processo VALUES(1, 2, "Mozzarella", '2020-01-19 10:00:00', 10, 20, 30);
