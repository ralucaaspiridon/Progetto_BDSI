###############INFORMAZIONI GRUPPO###############
-- Nome e Cognome (Numero di matricola)--
-- Manuele Pipaj (7133958)--
-- Raluca Alexandra Spiridon (7137110)--
-- Data Consegna: 18 Giugno 2025

###############CREAZIONE DELLA BASE DI DATI###############
##DROP DATABASE IF EXISTS CompagniaAerea;
CREATE DATABASE IF NOT EXISTS  CompagniaAerea;
USE CompagniaAerea;

###############DROP###############
DROP TABLE IF EXISTS Offre; 
DROP TABLE IF EXISTS Usa;
DROP TABLE IF EXISTS Richiesta; 
DROP TABLE IF EXISTS Equipaggio;
DROP TABLE IF EXISTS ServizioClienti;
DROP TABLE IF EXISTS Passeggero; 
DROP TABLE IF EXISTS Prenotazione;
DROP TABLE IF EXISTS Prenotante;
DROP TABLE IF EXISTS Servizi;
DROP TABLE IF EXISTS Volo;
DROP TABLE IF EXISTS Gate; 
DROP TABLE IF EXISTS Dipendente;
DROP TABLE IF EXISTS Aeroporto;
DROP PROCEDURE IF EXISTS AnnullaPrenotazione;
DROP PROCEDURE IF EXISTS AggiungiVolo;
DROP PROCEDURE IF EXISTS AssegnaServizioClienti;
DROP TRIGGER IF EXISTS ControllaDataCheckIn;
DROP TRIGGER IF EXISTS VerfificaMembroEquipaggio;
DROP TRIGGER IF EXISTS VerificaServiziPasseggeri;
DROP VIEW IF EXISTS VistaVoliGateAeroporto;
DROP VIEW IF EXISTS VistaServiziPasseggeri;

###############CREAZIONE TABELLE###############
CREATE TABLE IF NOT EXISTS Aeroporto(
	codiceIATA CHAR(3) PRIMARY KEY, 
	nome VARCHAR(50) NOT NULL, 
	via VARCHAR(50) NOT NULL , 
	cap CHAR(5), 
	citta VARCHAR(50) NOT NULL) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS Gate(
	codiceGate VARCHAR(3), 
	codiceIATA CHAR (3), 
	abilitazione ENUM('aperto', 'chiuso'),
	PRIMARY KEY (codiceGate, codiceIATA), 
	FOREIGN KEY (codiceIATA) REFERENCES Aeroporto(codiceIATA)) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS Volo(
	codiceVolo CHAR(6), 
	stato VARCHAR(20) NOT NULL,
	orarioStimato TIME NOT NULL, 
    orarioEffettivo TIME, 
    dataVolo DATE,
    codiceGate VARCHAR(3), 
    codiceIATA CHAR(3),
	PRIMARY KEY (codiceVolo),
    FOREIGN KEY (codiceGate, codiceIATA) references Gate(codiceGate, codiceIATA)) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS Dipendente(
	codiceFiscale CHAR(16) PRIMARY KEY, 
    nome VARCHAR(50) NOT NULL, 
	cognome VARCHAR(50) NOT NULL, 
	dataDiNascita DATE NOT NULL, 
    numeroDiTelefono VARCHAR(20) NOT NULL,
	dataInizioCollaborazione DATE NOT NULL, 
	dataFineCollaborazione DATE, 
	titoloLavorativo VARCHAR(25) NOT NULL,
    stipendio DECIMAL (10,2) NOT NULL) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS Equipaggio(
	codiceFiscale CHAR(16), 
    codiceVolo CHAR(6), 
    numeroPassaporto CHAR(9), 
    monteOrarioMensile DECIMAL(5,2),
    PRIMARY KEY (codiceFiscale, codiceVolo), 
    FOREIGN KEY (codiceFiscale) REFERENCES Dipendente(codiceFiscale),
    FOREIGN KEY (codiceVolo) REFERENCES Volo(codiceVolo)) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS ServizioClienti(
	codiceFiscale CHAR(16), 
    codiceIATA CHAR(3), 
    PRIMARY KEY (codiceFiscale, codiceIATA), 
    FOREIGN KEY (codiceFiscale) REFERENCES Dipendente(codiceFiscale), 
    FOREIGN KEY (codiceIATA) REFERENCES Aeroporto(codiceIATA)) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS Prenotante(
	codiceFiscale CHAR(16) PRIMARY KEY, 
    nome VARCHAR (50), 
    cognome VARCHAR(50), 
    dataNascita DATE, 
    numeroTelefono VARCHAR(20)) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS Prenotazione( 
	codicePrenotazione CHAR(10) PRIMARY KEY, 
	prezzoTotale DECIMAL(10,2) NOT NULL, 
	metodoPagamento VARCHAR(20) NOT NULL) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS Richiesta(
	codiceFiscale CHAR(16), 
    codicePrenotazione CHAR(10),
    PRIMARY KEY (codiceFiscale, codicePrenotazione), 
    FOREIGN KEY (codiceFiscale) REFERENCES Prenotante(codiceFiscale), 
    FOREIGN KEY (codicePrenotazione) REFERENCES Prenotazione(codicePrenotazione)) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS Passeggero(
	documentoIdentita CHAR(9) PRIMARY KEY, 
    nome VARCHAR(50) NOT NULL, 
    cognome VARCHAR(50) NOT NULL, 
    dataNascita DATE, 
    cittadinanza VARCHAR(50),
    codicePrenotazione CHAR(10), 
    dataCheckIn DATE,
    codiceVolo CHAR(6), 
    FOREIGN KEY (codicePrenotazione) REFERENCES Prenotazione(CodicePrenotazione), 
    FOREIGN KEY (codiceVolo) REFERENCES Volo(codiceVolo)) ENGINE = InnoDB;
    
CREATE TABLE IF NOT EXISTS Servizi(
	codiceServizio CHAR(6) PRIMARY KEY, 
    nomeServizio VARCHAR(50) NOT NULL, 
    descrizioneServizio VARCHAR(50)) ENGINE = InnoDB; 
    
CREATE TABLE IF NOT EXISTS Usa(
	documentoIdentita CHAR(9), 
    codiceServizio CHAR(6), 
    PRIMARY KEY (documentoIdentita, codiceServizio), 
    FOREIGN KEY (documentoIdentita) REFERENCES Passeggero(documentoIdentita),
    FOREIGN KEY (codiceServizio) REFERENCES Servizi(codiceServizio)) ENGINE = InnoDB; 
    
CREATE TABLE IF NOT EXISTS Offre(
	codiceVolo CHAR(6), 
    codiceServizio CHAR(6), 
    PRIMARY KEY (codiceVolo, codiceServizio), 
    FOREIGN KEY (codiceVolo) REFERENCES Volo(codiceVolo),
    FOREIGN KEY (codiceServizio) REFERENCES Servizi(codiceServizio)) ENGINE = InnoDB; 
    
############### POPOLAMENTO ###############
INSERT INTO Aeroporto(codiceIATA, nome, via, cap, citta)  VALUES 
	('FCO', 'Leonardo da Vinci', 'Via Aeroporto di Fiumicino', '00054', 'Fiumicino'),
	('MAD', 'Adolfo Suárez Madrid-Barajas', 'Avenida de la Hispanidad', '28042', 'Madrid'),
	('CDG', 'Charles de Gaulle', 'Route de Aéroport', '95700', 'Paris'),
	('BLQ', 'Guglielmo Marconi', 'Via del Triumvirato', '40132', 'Bologna'),
	('PMO', 'Falcone e Borsellino', 'Via Punta Raisi', '90045', 'Palermo'),
	('FRA', 'Frankfurt am Main', 'Frankfurt Flughafen', '60547', 'Frankfurt'),
	('FLR','Amerigo Vespucci', 'Via del Termine', '50127', 'Firenze');
    
INSERT INTO Gate(codiceGate, codiceIATA, abilitazione) VALUES 
	('A01', 'FCO', 'aperto'),
	('A02', 'FCO', 'chiuso'),
	('A03', 'FCO', 'aperto'),
	('A01', 'MAD', 'aperto'),
	('B02', 'MAD', 'chiuso'),
	('B03', 'MAD', 'aperto'),
	('A01', 'CDG', 'aperto'),
	('B01', 'CDG', 'aperto'),
	('C01', 'CDG', 'chiuso'),
	('A01', 'BLQ', 'aperto'),
	('D02', 'BLQ', 'chiuso'),
	('D03', 'BLQ', 'aperto'),
	('E01', 'PMO', 'aperto'),
	('E02', 'PMO', 'aperto'),
	('E03', 'PMO', 'chiuso'),
	('F01', 'FRA', 'aperto'),
	('G03', 'FRA', 'chiuso'),
	('F03', 'FRA', 'aperto'),
	('A01', 'FLR', 'aperto'),
	('A02', 'FLR', 'aperto'),
	('B01', 'FLR', 'chiuso');

INSERT INTO Volo(codiceVolo, stato, orarioStimato, orarioEffettivo, dataVolo, codiceGate, codiceIATA) VALUES 
	('AZ1234', 'boarding', '08:30:00', '08:30:00','2025-06-27','A01', 'FCO'),
	('IB5678', 'in ritardo', '09:00:00', '09:45:00', '2025-06-27', 'B03', 'MAD'),
	('AF4321', 'in orario', '10:15:00', '10:15:00', '2025-06-27','A01', 'CDG'),
	('AZ9876', 'cancellato', '11:00:00', NULL, '2025-06-27','A03', 'FCO'),
	('LH2468', 'partito', '07:00:00', '07:00:00','2025-06-27', 'F01', 'FRA'),
	('FR1111', 'in ritardo', '13:30:00', '14:05:00', '2025-06-27','E02', 'PMO'),
	('VY2244', 'in orario', '15:45:00', '15:45:00', '2025-06-27','D03', 'BLQ'),
	('AZ3344', 'in ritardo', '12:00:00', '12:20:00','2025-06-27', 'A01', 'BLQ'),
	('AF7788', 'cancellato', '16:10:00', NULL, '2025-06-27','B01', 'CDG'),
	('EZY909', 'in orario', '18:00:00', '18:00:00','2025-06-27', 'A01', 'FLR');

LOAD DATA LOCAL INFILE 'dipendenti.csv' -- Inserire percorso--
	INTO TABLE Dipendente
	FIELDS TERMINATED BY ';' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'equipaggio.txt' -- Inserire percorso--
	INTO TABLE equipaggio
	FIELDS TERMINATED BY ',' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'servizioClienti.txt' -- Inserire percorso--
	INTO TABLE servizioclienti
	FIELDS TERMINATED BY ',' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'prenotanti.csv' -- Inserire percorso--
	INTO TABLE prenotante
	FIELDS TERMINATED BY ';' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'prenotazioni.csv' -- Inserire percorso--
	INTO TABLE prenotazione
	FIELDS TERMINATED BY ';' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'richiesta.csv' -- Inserire percorso--
	INTO TABLE richiesta
	FIELDS TERMINATED BY ';' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'passeggeri.csv' -- Inserire percorso--
	INTO TABLE passeggero
	FIELDS TERMINATED BY ';' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;

INSERT INTO Servizi(codiceServizio, nomeServizio, descrizioneServizio) VALUES
	('SRV001', 'Snack a bordo', 'Snack dolci o salati'),
	('SRV002', 'Pasti caldi', 'Pasti caldi su voli internazionali'),
	('SRV003', 'Bevande', 'Acqua, bibite, vino e birra'),
	('SRV004', 'Duty Free', 'Profumi, alcolici e accessori'),
	('SRV005', 'WiFi a bordo', 'Connessione internet in volo'),
	('SRV006', 'Gratta e vinci', 'Biglietti lotteria acquistabili a bordo'),
	('SRV007', 'Cuffie', 'Cuffie per l’intrattenimento'),
	('SRV008', 'Film e musica', 'Sistema di intrattenimento multimediale'),
	('SRV009', 'Riviste e giornali', 'Letture gratuite in volo'),
	('SRV010', 'Kit notte', 'Mascherina, cuscino, coperta'),
	('SRV011', 'Menù vegetariano', 'Opzione pasto vegetariano'),
	('SRV012', 'Menù per bambini', 'Pasto dedicato ai più piccoli');

INSERT INTO Offre(codiceVolo, codiceServizio) VALUES
	('AZ1234', 'SRV002'),
	('AZ1234', 'SRV006'),
	('AZ1234', 'SRV009'),
	('IB5678', 'SRV003'),
	('IB5678', 'SRV008'),
	('IB5678', 'SRV010'),
	('AF4321', 'SRV002'),
	('AF4321', 'SRV003'),
	('AF4321', 'SRV007'),
	('AF4321', 'SRV011'),
	('AZ9876', 'SRV003'),
	('AZ9876', 'SRV004'),
	('AZ9876', 'SRV005'),
	('AZ9876', 'SRV011'),
	('AZ9876', 'SRV012'),
	('LH2468', 'SRV003'),
	('LH2468', 'SRV006'),
	('LH2468', 'SRV008'),
	('LH2468', 'SRV010'),
	('FR1111', 'SRV001'),
	('FR1111', 'SRV005'),
	('FR1111', 'SRV006'),
	('FR1111', 'SRV010'),
	('FR1111', 'SRV011'),
	('VY2244', 'SRV001'),
	('VY2244', 'SRV002'),
	('VY2244', 'SRV008'),
	('VY2244', 'SRV009'),
	('AZ3344', 'SRV001'),
	('AZ3344', 'SRV002'),
	('AZ3344', 'SRV007'),
	('AZ3344', 'SRV009'),
	('AF7788', 'SRV004'),
	('AF7788', 'SRV009'),
	('AF7788', 'SRV010'),
	('AF7788', 'SRV012'),
	('EZY909', 'SRV004'),
	('EZY909', 'SRV005'),
	('EZY909', 'SRV008');

INSERT INTO Usa(documentoIdentita, codiceServizio) VALUES
	('NMKZA3OA5', 'SRV001'),
	('CLYT8W5RT', 'SRV003'),
	('YRUIWQY6Q', 'SRV001'),
	('YRUIWQY6Q', 'SRV004'),
	('YRUIWQY6Q', 'SRV008'),
	('DWB2BNE6L', 'SRV003'),
	('W790PDW5P', 'SRV004'),
	('0FODRO8BN', 'SRV003'),
	('BB9EITNN8', 'SRV012'),
	('X1ZHQIMQO', 'SRV009'),
	('LDSFR4MUE', 'SRV005');

############### INTERROGAZIONI ###############
SELECT codiceVolo,stato, orarioStimato, orarioEffettivo, codiceGate, codiceIATA
	FROM VOLO
	WHERE orarioEffettivo > orarioStimato;

SELECT 
    P.nome,
    P.cognome,
    P.documentoIdentita,
    V.codiceVolo,
    A.nome AS aeroporto
FROM Passeggero P
JOIN Volo V ON P.codiceVolo = V.codiceVolo
JOIN Gate G ON V.codiceGate = G.codiceGate AND V.codiceIATA = G.codiceIATA
JOIN Aeroporto A ON G.codiceIATA = A.codiceIATA;
    
SELECT SUM(prezzoTotale) AS incassoCarta
	FROM Prenotazione 
	WHERE metodoPagamento = 'Carta di Credito';

SELECT nome, cognome
FROM Passeggero
WHERE documentoIdentita IN (
    SELECT documentoIdentita
    FROM Usa
    GROUP BY documentoIdentita
    HAVING COUNT(*) > 1
);
    
SELECT codiceVolo, COUNT(codiceServizio) AS numeroServizi
	FROM Offre
	GROUP BY codiceVolo
	HAVING COUNT(codiceServizio) > 3;
    
SELECT 
    PR.nome,
    PR.cognome,
    P.codicePrenotazione,
    P.prezzoTotale,
    P.metodoPagamento
FROM Richiesta R
JOIN Prenotante PR ON R.codiceFiscale = PR.codiceFiscale
JOIN Prenotazione P ON R.codicePrenotazione = P.codicePrenotazione;

############### PROCEDURE ###############
DELIMITER $$
CREATE PROCEDURE   AnnullaPrenotazione(codicePrenotazioneP CHAR(10))
BEGIN
    IF EXISTS (
        SELECT 1 FROM Prenotazione WHERE codicePrenotazione = codicePrenotazioneP
    ) THEN
        DELETE FROM Usa 
        WHERE documentoIdentita IN (
            SELECT documentoIdentita FROM Passeggero WHERE codicePrenotazione = codicePrenotazioneP
        );
        DELETE FROM Passeggero 
        WHERE codicePrenotazione = codicePrenotazioneP;
        
        DELETE FROM Richiesta 
        WHERE codicePrenotazione = codicePrenotazioneP;

        DELETE FROM Prenotazione 
        WHERE codicePrenotazione = codicePrenotazioneP;

    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La prenotazione specificata non esiste.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AggiungiVolo(
    p_codiceVolo CHAR(6),
    p_stato VARCHAR(20),
    p_orarioStimato TIME,
    p_orarioEffettivo TIME,
    p_dataVolo DATE,
    p_codiceGate VARCHAR(3),
    p_codiceIATA CHAR(3)
)
BEGIN
    DECLARE v_esistente INT;
    DECLARE v_abilitazione ENUM('aperto', 'chiuso');
    DECLARE v_conflitti INT;
   
    SELECT COUNT(*) INTO v_esistente
    FROM Volo
    WHERE codiceVolo = p_codiceVolo;
    
    IF v_esistente > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Codice volo già esistente.';
    END IF;
    
    SELECT abilitazione INTO v_abilitazione
    FROM Gate
    WHERE codiceGate = p_codiceGate AND codiceIATA = p_codiceIATA;

    IF v_abilitazione IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il gate specificato non esiste.';
    END IF;
    
    IF v_abilitazione = 'chiuso' THEN
        UPDATE Gate
        SET abilitazione = 'aperto'
        WHERE codiceGate = p_codiceGate AND codiceIATA = p_codiceIATA;
    END IF;
   
    SELECT COUNT(*) INTO v_conflitti
    FROM Volo
    WHERE codiceGate = p_codiceGate
      AND codiceIATA = p_codiceIATA
      AND dataVolo = p_dataVolo
      AND orarioEffettivo = p_orarioEffettivo;

    IF v_conflitti > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Conflitto: un altro volo è già presente in quel gate alla stessa data e ora.';
    END IF;

    INSERT INTO Volo (
        codiceVolo, stato, orarioStimato, orarioEffettivo, dataVolo,
        codiceGate, codiceIATA
    )
    VALUES (
        p_codiceVolo, p_stato, p_orarioStimato, p_orarioEffettivo, p_dataVolo,
        p_codiceGate, p_codiceIATA
    );
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AssegnaServizioClienti(
    p_codiceIATA CHAR(3),
    p_codiceFiscale CHAR(16)
)
BEGIN
    
    IF NOT EXISTS (
        SELECT 1
        FROM Aeroporto
        WHERE codiceIATA = p_codiceIATA
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: aeroporto non esistente.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM Dipendente
        WHERE codiceFiscale = p_codiceFiscale
          AND dataFineCollaborazione IS NULL
          AND titoloLavorativo IN ('Assistenza Clienti', 'Addetto checkin', 'Addetto imbarco')
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: dipendente non idoneo o inesistente';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM ServizioClienti
        WHERE codiceFiscale = p_codiceFiscale
          AND codiceIATA != p_codiceIATA
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: dipendente già assegnato a un altro aeroporto.';
    END IF;

    INSERT INTO ServizioClienti (codiceFiscale, codiceIATA)
    VALUES (p_codiceFiscale, p_codiceIATA);
END$$
DELIMITER ;

############### TRIGGER ###############
DELIMITER $$
CREATE TRIGGER ControllaDataCheckIn
BEFORE INSERT ON Passeggero
FOR EACH ROW
BEGIN
    DECLARE v_dataVolo DATE;
    SELECT dataVolo INTO v_dataVolo
    FROM Volo
    WHERE codiceVolo = NEW.codiceVolo;
    IF v_dataVolo IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: codice volo non valido.';
    ELSEIF NEW.dataCheckIn > v_dataVolo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: la data del check-in non può essere successiva alla data del volo.';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER VerificaMembroEquipaggio
BEFORE INSERT ON Equipaggio
FOR EACH ROW
BEGIN
    DECLARE v_dataVolo DATE;
    DECLARE v_mese INT;
    DECLARE v_anno INT;
    DECLARE v_oreTotali DECIMAL(5,2);
    DECLARE v_countDipendente INT;
    DECLARE v_countVolo INT;

    SELECT COUNT(*) INTO v_countDipendente
    FROM Dipendente
    WHERE codiceFiscale = NEW.codiceFiscale;

    IF v_countDipendente = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: il codice fiscale inserito non esiste nella tabella Dipendente.';
    END IF;

    SELECT COUNT(*) INTO v_countVolo
    FROM Volo
    WHERE codiceVolo = NEW.codiceVolo;

    IF v_countVolo = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: il codice volo inserito non esiste nella tabella Volo.';
    END IF;

    SELECT dataVolo INTO v_dataVolo
    FROM Volo
    WHERE codiceVolo = NEW.codiceVolo;

    SET v_mese = MONTH(v_dataVolo);
    SET v_anno = YEAR(v_dataVolo);

    SELECT IFNULL(SUM(monteOrarioMensile), 0) INTO v_oreTotali
    FROM Equipaggio E
    JOIN Volo V ON E.codiceVolo = V.codiceVolo
    WHERE E.codiceFiscale = NEW.codiceFiscale
      AND MONTH(V.dataVolo) = v_mese
      AND YEAR(V.dataVolo) = v_anno;

    IF v_oreTotali + NEW.monteOrarioMensile > 150 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: monte orario mensile del dipendente supererebbe 150 ore.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER VerificaServiziPasseggero
BEFORE INSERT ON Usa
FOR EACH ROW
BEGIN
    DECLARE v_codiceVolo CHAR(6);
    DECLARE v_count INT;
   
    SELECT codiceVolo INTO v_codiceVolo
    FROM Passeggero
    WHERE documentoIdentita = NEW.documentoIdentita;
   
    SELECT COUNT(*) INTO v_count
    FROM Offre
    WHERE codiceVolo = v_codiceVolo
      AND codiceServizio = NEW.codiceServizio;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: il servizio non è disponibile per il volo del passeggero.';
    END IF;
END$$
DELIMITER ;

############### VISTE ###############
CREATE OR REPLACE VIEW VistaVoliGateAeroporto AS
SELECT 
    V.codiceVolo,
    V.orarioStimato,
    V.orarioEffettivo,
    V.dataVolo,
    G.codiceGate,
    G.abilitazione AS statoGate,
    A.nome AS nomeAeroporto,
    A.citta,
    A.via,
    A.cap
FROM Volo V
JOIN Gate G ON V.codiceGate = G.codiceGate AND V.codiceIATA = G.codiceIATA
JOIN Aeroporto A ON G.codiceIATA = A.codiceIATA;

CREATE VIEW VistaServiziPasseggeri AS
SELECT 
    P.documentoIdentita,
    P.nome,
    P.cognome,
    P.codiceVolo,
    S.codiceServizio,
    S.nomeServizio
FROM Usa U
JOIN Passeggero P ON U.documentoIdentita = P.documentoIdentita
JOIN Servizi S ON U.codiceServizio = S.codiceServizio;








