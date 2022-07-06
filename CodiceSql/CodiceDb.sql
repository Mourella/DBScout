-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema DBScout
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema DBScout
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DBScout` DEFAULT CHARACTER SET utf8 ;
USE `DBScout` ;

-- -----------------------------------------------------
-- Table `DBScout`.`Agente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Agente` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Agente` (
  `Codice` VARCHAR(25) NOT NULL,
  `Nome` VARCHAR(20) NOT NULL,
  `Cognome` VARCHAR(20) NOT NULL,
  `Fax` VARCHAR(20) NULL,
  `Cellulare` VARCHAR(20) NULL,
  `E-mail` VARCHAR(50) NULL,
  PRIMARY KEY (`Codice`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBScout`.`Atleta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Atleta` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Atleta` (
  `ID` VARCHAR(25) NOT NULL,
  `Nome` VARCHAR(20) NOT NULL,
  `Cognome` VARCHAR(20) NOT NULL,
  `Nazionalità` VARCHAR(20) NOT NULL,
  `Genere` ENUM('M','F') NOT NULL,
  `Data_di_nascita` DATE NOT NULL,
  `Valore_di_mercato` INT NOT NULL,
  `Agente` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `CodiceAg`
    FOREIGN KEY (`Agente`)
    REFERENCES `DBScout`.`Agente` (`Codice`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `ID_UNIQUE` ON `DBScout`.`Atleta` (`ID` ASC) VISIBLE;

CREATE INDEX `CodiceAg_idx` ON `DBScout`.`Atleta` (`Agente` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DBScout`.`Infortuni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Infortuni` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Infortuni` (
  `Tipologia` VARCHAR(20) NOT NULL,
  `Data_inizio` DATE NOT NULL,
  `Data_fine` DATE NULL,
  `Atleta` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Data_inizio`, `Atleta`),
  CONSTRAINT `ID2`
    FOREIGN KEY (`Atleta`)
    REFERENCES `DBScout`.`Atleta` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `ID_idx` ON `DBScout`.`Infortuni` (`Atleta` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DBScout`.`Competizioni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Competizioni` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Competizioni` (
  `Nome` VARCHAR(25) NOT NULL,
  `Tipo` ENUM('Club','Nazionale') NOT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Nome_UNIQUE` ON `DBScout`.`Competizioni` (`Nome` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DBScout`.`Edizioni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Edizioni` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Edizioni` (
  `Anno` YEAR(4) NOT NULL,
  `CompetizioneNome` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Anno`, `CompetizioneNome`),
  CONSTRAINT `Nome`
    FOREIGN KEY (`CompetizioneNome`)
    REFERENCES `DBScout`.`Competizioni` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBScout`.`Statistiche_Torneo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Statistiche_Torneo` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Statistiche_Torneo` (
  `Atleta` VARCHAR(25) NOT NULL,
  `Gol` INT NOT NULL DEFAULT 0,
  `Assists` INT NOT NULL DEFAULT 0,
  `Presenze` INT NOT NULL DEFAULT 0,
  `Espulsioni` INT NOT NULL DEFAULT 0,
  `Ammonizioni` INT NOT NULL DEFAULT 0,
  `Doppie_Ammonizioni` INT NOT NULL DEFAULT 0,
  `EdizioneA` YEAR(4) NOT NULL,
  `CompetizioneNome` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Atleta`, `EdizioneA`, `CompetizioneNome`),
  CONSTRAINT `ID1`
    FOREIGN KEY (`Atleta`)
    REFERENCES `DBScout`.`Atleta` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Anno0`
    FOREIGN KEY (`EdizioneA`)
    REFERENCES `DBScout`.`Edizioni` (`Anno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Nome1`
    FOREIGN KEY (`CompetizioneNome`)
    REFERENCES `DBScout`.`Edizioni` (`CompetizioneNome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `Nome_idx` ON `DBScout`.`Statistiche_Torneo` (`CompetizioneNome` ASC) INVISIBLE;


-- -----------------------------------------------------
-- Table `DBScout`.`Contratti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Contratti` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Contratti` (
  `IDContratti` VARCHAR(25) NOT NULL,
  `Data_inizio` DATE NOT NULL,
  `Ingaggio` INT NOT NULL,
  `Scadenza` DATE NOT NULL,
  `Scaduto` TINYINT NOT NULL DEFAULT 0,
  `Sponsor` VARCHAR(50) NULL,
  `Atleta` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`IDContratti`),
  CONSTRAINT `ID4`
    FOREIGN KEY (`Atleta`)
    REFERENCES `DBScout`.`Atleta` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `UniqueAtletaContra` ON `DBScout`.`Contratti` (`IDContratti` ASC, `Atleta` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DBScout`.`Trasferimenti`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Trasferimenti` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Trasferimenti` (
  `ID_trasferimento` VARCHAR(25) NOT NULL,
  `Data_fine` DATE NULL,
  `Data_inizio` DATE NOT NULL,
  `Acquirente` VARCHAR(30) NOT NULL,
  `Venditore` VARCHAR(30) NOT NULL,
  `Somma_trasferimento` INT NOT NULL DEFAULT 0,
  `Atleta` VARCHAR(25) NOT NULL,
  `Contratto` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`ID_trasferimento`),
  CONSTRAINT `ID3`
    FOREIGN KEY (`Atleta`)
    REFERENCES `DBScout`.`Atleta` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IDContratti`
    FOREIGN KEY (`Contratto`)
    REFERENCES `DBScout`.`Contratti` (`IDContratti`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `unicità chaive` ON `DBScout`.`Trasferimenti` (`ID_trasferimento` ASC, `Atleta` ASC) VISIBLE;

CREATE UNIQUE INDEX `Contratto_UNIQUE` ON `DBScout`.`Trasferimenti` (`Contratto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DBScout`.`Caratteristiche`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Caratteristiche` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Caratteristiche` (
  `Atleta` VARCHAR(25) NOT NULL,
  `Piede` ENUM('Dx','Sx') NOT NULL,
  `Velocità` INT(100) NOT NULL,
  `Peso` FLOAT NOT NULL,
  `Altezza` FLOAT NOT NULL,
  `Tiro` INT(100) NOT NULL,
  `Resistenza` INT(100) NOT NULL,
  PRIMARY KEY (`Atleta`),
  CONSTRAINT `ID5`
    FOREIGN KEY (`Atleta`)
    REFERENCES `DBScout`.`Atleta` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Atleta_UNIQUE` ON `DBScout`.`Caratteristiche` (`Atleta` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DBScout`.`Palmarès`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Palmarès` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Palmarès` (
  `Atleta` VARCHAR(25) NOT NULL,
  `Numero_trofei_squadra` INT NOT NULL DEFAULT 0,
  `Numero_trofei_personali` INT NOT NULL DEFAULT 0,
  `Anno_ultimo_trofeo` YEAR(4) NULL,
  PRIMARY KEY (`Atleta`),
  CONSTRAINT `ID6`
    FOREIGN KEY (`Atleta`)
    REFERENCES `DBScout`.`Atleta` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBScout`.`Ruolo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Ruolo` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Ruolo` (
  `Posizione` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`Posizione`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBScout`.`Partecipa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Partecipa` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Partecipa` (
  `ID` VARCHAR(25) NOT NULL,
  `Anno` YEAR(4) NOT NULL,
  `CompetizioneNome` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`ID`, `Anno`, `CompetizioneNome`),
  CONSTRAINT `ID7`
    FOREIGN KEY (`ID`)
    REFERENCES `DBScout`.`Atleta` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Anno1`
    FOREIGN KEY (`Anno`)
    REFERENCES `DBScout`.`Edizioni` (`Anno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Com`
    FOREIGN KEY (`CompetizioneNome`)
    REFERENCES `DBScout`.`Edizioni` (`CompetizioneNome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `Anno_idx` ON `DBScout`.`Partecipa` (`Anno` ASC) INVISIBLE;

CREATE UNIQUE INDEX `Partecipa_UNIQUE` ON `DBScout`.`Partecipa` (`ID` ASC, `Anno` ASC, `CompetizioneNome` ASC) VISIBLE;

CREATE INDEX `Com_idx` ON `DBScout`.`Partecipa` (`CompetizioneNome` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DBScout`.`Ricopre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`Ricopre` ;

CREATE TABLE IF NOT EXISTS `DBScout`.`Ricopre` (
  `Posizione` VARCHAR(20) NOT NULL,
  `Atleta` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`Posizione`, `Atleta`),
  CONSTRAINT `Atleta`
    FOREIGN KEY (`Atleta`)
    REFERENCES `DBScout`.`Caratteristiche` (`Atleta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Posizione`
    FOREIGN KEY (`Posizione`)
    REFERENCES `DBScout`.`Ruolo` (`Posizione`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `Atleta_idx` ON `DBScout`.`Ricopre` (`Atleta` ASC) VISIBLE;

CREATE UNIQUE INDEX `Ricopre_UNIQUE` ON `DBScout`.`Ricopre` (`Posizione` ASC, `Atleta` ASC) VISIBLE;

USE `DBScout` ;

-- -----------------------------------------------------
-- Placeholder table for view `DBScout`.`AtletaPosizioni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBScout`.`AtletaPosizioni` (`ID` INT, `Nome` INT, `Cognome` INT, `DataNascita` INT, `Ruolo` INT);

-- -----------------------------------------------------
-- Placeholder table for view `DBScout`.`AgenteAtleta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBScout`.`AgenteAtleta` (`Nome_Agente` INT, `Cognome_Agente` INT, `ID_Atleta` INT);

-- -----------------------------------------------------
-- Placeholder table for view `DBScout`.`AmmonizioniCampionato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBScout`.`AmmonizioniCampionato` (`Atleta` INT, `Ammonizioni` INT);

-- -----------------------------------------------------
-- Placeholder table for view `DBScout`.`TrasferimentiAgente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBScout`.`TrasferimentiAgente` (`Codice` INT, `Nome_Agente` INT, `Cognome_Agente` INT, `ID_Atleta` INT, `ID_trasferimento` INT, `Somma` INT);

-- -----------------------------------------------------
-- Placeholder table for view `DBScout`.`StatisticheTotaliGiocatori`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBScout`.`StatisticheTotaliGiocatori` (`ID` INT, `Nome` INT, `Cognome` INT, `Genere` INT, `Agente` INT, `Gol` INT, `Assist` INT, `Presenze` INT, `Ammonizioni` INT, `Espulsioni` INT, `DoppieAmmonizioni` INT);

-- -----------------------------------------------------
-- Placeholder table for view `DBScout`.`GiocatorePartecipazioni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DBScout`.`GiocatorePartecipazioni` (`ID` INT, `Nome` INT, `Cognome` INT, `Competizione` INT, `Partecipazioni` INT, `AnnoUltimaPartecipazione` INT);

-- -----------------------------------------------------
-- function Trofei_totali
-- -----------------------------------------------------

USE `DBScout`;
DROP function IF EXISTS `DBScout`.`Trofei_totali`;

DELIMITER $$
USE `DBScout`$$
CREATE function `Trofei_totali` ( u int, m  int)
returns int
deterministic
reads sql data
RETURN u+m;$$

DELIMITER ;

-- -----------------------------------------------------
-- View `DBScout`.`AtletaPosizioni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`AtletaPosizioni`;
DROP VIEW IF EXISTS `DBScout`.`AtletaPosizioni` ;
USE `DBScout`;
CREATE  OR REPLACE VIEW `AtletaPosizioni` (ID,Nome,Cognome,DataNascita,Ruolo) AS
select distinct ID,Nome,Cognome,Data_di_nascita,Posizione
from Atleta,Ricopre
where (Atleta.ID=Ricopre.Atleta);

#Vista con atleta e relative posizioni in campo derivate da caratteristiche;

-- -----------------------------------------------------
-- View `DBScout`.`AgenteAtleta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`AgenteAtleta`;
DROP VIEW IF EXISTS `DBScout`.`AgenteAtleta` ;
USE `DBScout`;
CREATE  OR REPLACE VIEW `AgenteAtleta` (Nome_Agente,Cognome_Agente,ID_Atleta) AS
select Agente.Nome,Agente.Cognome,Atleta.ID
from Agente,Atleta
where (Agente.Codice=Atleta.Agente); -- vista che contiene generalità dell'agente con relativo assistito;

-- -----------------------------------------------------
-- View `DBScout`.`AmmonizioniCampionato`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`AmmonizioniCampionato`;
DROP VIEW IF EXISTS `DBScout`.`AmmonizioniCampionato` ;
USE `DBScout`;
CREATE  OR REPLACE VIEW `AmmonizioniCampionato`(Atleta,Ammonizioni) AS      
select Atleta,sum(ammonizioni) as TotaleAmmonizioni 
from Statistiche_torneo 
where (CompetizioneNome='Campionato') 
group by(Atleta);

#vista con la somma di ammonizioni di ogni giocatore in tutti i campionati a  cui hanno partecipato;

-- -----------------------------------------------------
-- View `DBScout`.`TrasferimentiAgente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`TrasferimentiAgente`;
DROP VIEW IF EXISTS `DBScout`.`TrasferimentiAgente` ;
USE `DBScout`;
CREATE  OR REPLACE VIEW `TrasferimentiAgente` (Codice,Nome_Agente,Cognome_Agente,ID_Atleta,ID_trasferimento,Somma) AS
select Agente.Codice,Agente.Nome,Agente.Cognome,Atleta.ID,ID_trasferimento,Trasferimenti.Somma_trasferimento
from Agente,Atleta,Trasferimenti
where (Agente.Codice=Atleta.Agente and Trasferimenti.Atleta=Atleta.ID);
#restituisce una vista con Nome,cognome agente, ID atleta con relativo trasferimento e somma;

-- -----------------------------------------------------
-- View `DBScout`.`StatisticheTotaliGiocatori`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`StatisticheTotaliGiocatori`;
DROP VIEW IF EXISTS `DBScout`.`StatisticheTotaliGiocatori` ;
USE `DBScout`;
CREATE  OR REPLACE VIEW `StatisticheTotaliGiocatori` (ID,Nome,Cognome,Genere,Agente,Gol,Assist,Presenze,Ammonizioni,Espulsioni,DoppieAmmonizioni) AS
select ID,Nome,Cognome,Genere,Agente,sum(Gol),sum(Assists),sum(Presenze),sum(Ammonizioni),sum(Espulsioni),sum(Doppie_Ammonizioni)
from Atleta,Statistiche_torneo
where(ID=Atleta)
group by (ID);

#Per ogni atleta, calcola tutti i gol, tutti assists ...... che ha fatto nella carriera;

-- -----------------------------------------------------
-- View `DBScout`.`GiocatorePartecipazioni`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBScout`.`GiocatorePartecipazioni`;
DROP VIEW IF EXISTS `DBScout`.`GiocatorePartecipazioni` ;
USE `DBScout`;
CREATE  OR REPLACE VIEW `GiocatorePartecipazioni` (ID,Nome,Cognome,Competizione,Partecipazioni,AnnoUltimaPartecipazione) AS
select Atleta.ID,Nome,Cognome,CompetizioneNome,count(CompetizioneNome),max(Anno)
from Atleta,Partecipa
where (Atleta.ID=Partecipa.ID)
group by Atleta.ID,CompetizioneNome
order by (Atleta.ID);
#Crea una tabella con Giocatore, Nome competizione, volte che ha partecipato, anno ultima partecipazione, in ordine di giocatore;
USE `DBScout`;

DELIMITER $$

USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckDataInfortuni` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckDataInfortuni` 
BEFORE INSERT ON `Infortuni` 
FOR EACH ROW
BEGIN
	if(new.Data_fine<new.Data_inizio) Then
		signal sqlstate '45000' set message_text = "Errore: La data di fine di un infortunio non può essere antecedente alla data di inizio";
	end if;
END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckDataInfortuniBU` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckDataInfortuniBU`
BEFORE UPDATE ON `Infortuni` 
FOR EACH ROW
BEGIN
	if(new.Data_fine<old.Data_inizio) Then
		signal sqlstate '45000' set message_text = "Errore: La data di fine di un infortunio non può essere antecedente alla data di inizio";
	end if;
END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckAnno` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckAnno` 
BEFORE INSERT ON `Edizioni` 
FOR EACH ROW
BEGIN
	if (new.Anno<1990) then
		signal sqlstate '45000' set message_text = 'Errore: Edizione del torneo deve essersi verificata dopo il 1990';
	end if;
END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckDAmmonizioniEspulsioni` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckDAmmonizioniEspulsioni` BEFORE INSERT ON `Statistiche_Torneo` FOR EACH ROW
BEGIN
	IF  (new.Doppie_Ammonizioni>(new.Espulsioni)) Then
		 signal sqlstate '45000' set message_text = 'Errore: Le doppie ammonizioni non possono essere maggiori delle espulsioni';
	
		
	end IF;
END;$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckPresenze` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckPresenze` 
BEFORE INSERT ON `Statistiche_Torneo` 
FOR EACH ROW
BEGIN
	if (new.Presenze=0 and (new.Espulsioni + new.Gol + new.Ammonizioni + new.Doppie_Ammonizioni + new.Assists)>0) Then
		signal sqlstate '45000' set message_text = 'Errore: Senza presenze non possono esistere statistiche';
	 end if;
     
END;$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckEdizioneA` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckEdizioneA` 
BEFORE INSERT ON `Statistiche_Torneo` 
FOR EACH ROW
BEGIN

	if(new.EdizioneA<1990) then
		signal sqlstate '45000' set message_text = 'Errore: Anno deve essere maggiore o uguale a 1990';
	end IF;
END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`AggiornamentoTabella` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`AggiornamentoTabella` 
AFTER INSERT ON `Statistiche_Torneo` 
FOR EACH ROW
BEGIN
	insert into Partecipa(ID,Anno,CompetizioneNome) values (new.Atleta,new.EdizioneA,new.CompetizioneNome);
END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckDAmmonizioniEspulsioni1` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckDAmmonizioniEspulsioni1`
BEFORE UPDATE ON `Statistiche_Torneo` FOR EACH ROW
BEGIN
	 IF  (new.Doppie_Ammonizioni>(old.Doppie_Ammonizioni)) Then
		  set new.Espulsioni = (old.Espulsioni + (new.Doppie_Ammonizioni-old.Doppie_Ammonizioni));
         
	 End IF;
END;$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckPresenze1` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckPresenze1`
 BEFORE UPDATE ON `Statistiche_Torneo` 
 FOR EACH ROW
BEGIN
	if ( old.Presenze>0 and new.Presenze<old.Presenze) Then
		 signal sqlstate '45000' set message_text = 'Errore: Le presenze non possono essere minori di quelle già presenti';
	end if;
    if (new.Presenze=0 and old.Presenze=0) Then
		set new.Espulsioni=0,new.Gol=0, new.Ammonizioni=0, new.Doppie_Ammonizioni=0, new.Assists=0;
	end if;
END;$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckData` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckData` 
BEFORE INSERT ON `Contratti` 
FOR EACH ROW
BEGIN
	if(new.Data_inizio > new.Scadenza) Then
		signal sqlstate '45000' set message_text = 'Errore: La scadenza del contratto non può essere antecedente alla data di inizio del contratto';
	end if;
END;$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckContrattoTrasferimento` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckContrattoTrasferimento` 
BEFORE INSERT ON `Contratti` 
FOR EACH ROW
BEGIN
	IF (new.Data_inizio < (select Data_inizio from Trasferimenti where (new.IDContratti=Contratto and new.Atleta=Atleta))) Then
		signal sqlstate '45000' set message_text = "Errore: La data di inizio del contratto non può essere antecedente alla data del trasferimento del giocatore";
	End if;
    
    if (((select Atleta from Contratti where (new.Atleta=Atleta and Scaduto=0 ))=new.Atleta) and new.Scaduto=0) Then
		signal sqlstate '45000' set message_text = ' Esiste già un contratto valido di questo Atleta';
	end if;
    
    
    
    
    
END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckIngaggio&ValoreDiMercato` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckIngaggio&ValoreDiMercato`
BEFORE INSERT ON `Contratti` 
FOR EACH ROW
BEGIN
	if ( new.Ingaggio > (select Valore_di_mercato from Atleta where (new.Atleta=ID))) Then
		signal sqlstate '45000' set message_text = "Errore: L'ingaggio del giocatore non può superare il suo valore di mercato";
	end IF;

	
END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckDateTrasferimento` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckDateTrasferimento` 
BEFORE INSERT ON `Trasferimenti` 
FOR EACH ROW
BEGIN
	If(new.Data_inizio>new.Data_fine) Then
		signal sqlstate '45000' set message_text = ' Errore: Data di inizio non può avvenire dopo la data di fine';
	end IF;
END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckAcquirenteVenditore` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckAcquirenteVenditore` 
BEFORE INSERT ON `Trasferimenti` 
FOR EACH ROW
BEGIN
	IF ( new.Acquirente=new.Venditore) Then
		signal sqlstate '45000' set message_text = 'Un atleta non può essere venduto e acquistato dalla stessa squadra contemporaneamente';
	end If;

END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`UpdateDataFine&AnnullamentoContratto` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`UpdateDataFine&AnnullamentoContratto` BEFORE UPDATE ON `Trasferimenti`
FOR EACH ROW 
BEGIN
	IF (old.Data_fine is Null and ((new.Data_fine > old.Data_inizio) and (new.Data_fine is not Null))) Then 
		update Contratti SET Scaduto=1,Scadenza=new.Data_fine where (old.Contratto=IDContratti); 
		
	end IF;
END;$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckAnnoTrofeo` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckAnnoTrofeo` 
BEFORE INSERT ON `Palmarès` 
FOR EACH ROW
BEGIN
	If(Trofei_totali(new.Numero_trofei_squadra,new.Numero_trofei_personali)>0 and (new.Anno_ultimo_trofeo is Null))Then
		signal sqlstate '45000' set message_text ="Errore: E' necessario l'anno dell'ultimo trofeo vinto";
    end if;
    If (Trofei_totali(new.Numero_trofei_squadra,new.Numero_trofei_personali)=0 and (new.Anno_ultimo_trofeo is not Null)) Then
		signal sqlstate '45000' set message_text ="Errore: Senza alcun trofeo vinto non ci può essere l'anno";
	end IF;
END$$


USE `DBScout`$$
DROP TRIGGER IF EXISTS `DBScout`.`CheckDataTrofeo` $$
USE `DBScout`$$
CREATE DEFINER = CURRENT_USER TRIGGER `DBScout`.`CheckDataTrofeo` 
BEFORE UPDATE ON `Palmarès` 
FOR EACH ROW
BEGIN
	If(new.Anno_ultimo_trofeo<old.Anno_ultimo_trofeo) Then
		signal sqlstate '45000' set message_text ='Errore: Anno non può essere minore di quello già presente';
	End IF;
END;$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `DBScout`.`Agente`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0001', 'Mino', 'Raiola', '390693673', '3456783762', NULL);
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0002', 'Jorge', 'Mendes', NULL, NULL, 'Mendes@gmail.com');
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0003', 'Juan', 'Messi', '072468592', '3457293856', 'JM@live.it');
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0004', 'Jorge', 'Antun', '053524622', NULL, 'AntunAgency@gmail.com');
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0005', 'Ugo', 'Palermo', '097537747', '0526379599', NULL);
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0006', 'Federico', 'Pastorello', '390505255', '3453860734', 'FEagency@live.it');
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0007', 'Giovanna', 'Di Andrea', '390593741', '3280921116', NULL);
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0008', 'Mario', 'Pone', '396257184', '3671827461', 'MarioPone@icloud.com');
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0009', 'Sergìo', 'Ustani', NULL, '8361891048', NULL);
INSERT INTO `DBScout`.`Agente` (`Codice`, `Nome`, `Cognome`, `Fax`, `Cellulare`, `E-mail`) VALUES ('0010', 'Juan', 'Pascana', '769239475', '1247120401', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Atleta`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('R0001', 'Cristiano', 'Ronaldo', 'Portogallo', 'M', '1985-02-01', 350000000, '0002');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('M0002', 'Lionel', 'Messi', 'Argentina', 'M', '1987-06-24', 500000000, '0003');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('L0003', 'Robert', 'Lewandowski', 'Polonia', 'M', '1988-08-21', 50000000, '0005');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('N0004', 'Manuel', 'Neuer', 'Germania', 'M', '1986-03-27', 14000000, '0005');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('D0005', 'Alphonso', 'Davies', 'Canada', 'M', '2000-11-02', 70000000, '0001');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('D0006', 'Matthijs', 'de Ligt', 'Olanda', 'M', '1999-08-12', 65000000, '0001');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('C0007', 'Juan', 'Cuadrado', 'Colombia', 'M', '1988-05-26', 10000000, '0003');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('D0008', 'Paulo', 'Dybala', 'Argentina', 'M', '1993-11-15', 50000000, '0004');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('B0009', 'Leonardo', 'Bonucci', 'Italia', 'M', '1987-05-01', 40000000, '0006');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('F0010', 'Daniel', 'Fontana', 'Argentina', 'M', '1988-04-07', 38363012, '0007');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('P0011', 'Giancarlo', 'Petit', 'Spagna', 'M', '2003-09-24', 54403733, '0001');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('F0012', 'Gennaro', 'Fontana', 'Francia', 'M', '1988-05-31', 10000000, '0004');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('B0013', 'Federico', 'Bianchi', 'Italia', 'M', '1983-04-11', 2000000, '0002');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('G0014', 'Joshua', 'Garcia', 'Germania', 'M', '1984-06-16', 1400000, '0001');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('D0015', 'Giancarlo', 'Dubois', 'Polonia', 'M', '1989-10-15', 500000, '0010');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('G0016', 'Jacob', 'Gonzalez', 'Croazia', 'M', '1997-09-13', 5000000, '0005');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('F0017', 'Valerio', 'Fontana', 'America', 'M', '1987-09-13', 3000000, '0004');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('D0018', 'Stefano', 'Dubois', 'Polonia', 'M', '1999-11-02', 5000000, '0006');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('L0019', 'Ethan', 'Lopez', 'Francia', 'M', '1982-06-21', 300000, '0008');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('B0020', 'Gennaro', 'Bernard', 'Italia', 'M', '2002-11-21', 6000000, '0009');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('W0021', 'Jacob', 'Wagner', 'Portogallo', 'M', '1984-05-16', 20000000, '0010');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('D0022', 'Jacob', 'Durand', 'Francia', 'M', '1990-03-26', 6000000, '0001');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('M0023', 'Sofia', 'Martin', 'Brasile', 'F', '1989-09-29', 235951, '0009');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('M0024', 'Giorgia', 'Martin', 'America', 'F', '1990-02-10', 1170000, '0001');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('T0025', 'Ema', 'Thomas', 'Brasile', 'F', '2003-02-02', 520000, '0003');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('W0026', 'Giuliet', 'Wagner', 'Germania', 'F', '1987-08-28', 1000000, '0002');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('R0027', 'Alice', 'Rodriguez', 'Brasile', 'F', '2002-05-23', 890000, '0004');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('S0028', 'Giorgia', 'Sanchez', 'America', 'F', '1991-12-18', 1805315, '0006');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('C0029', 'Alice', 'Costa', 'Italia', 'F', '1998-10-03', 468922, '0005');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('G0030', 'Ema', 'Gallo', 'Germania', 'F', '1997-08-23', 1600009, '0007');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('S0031', 'Ema', 'Schneider', 'Polonia', 'F', '1989-03-05', 1500010, '0009');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('G0032', 'Giorgia', 'Garcia', 'Spagna', 'F', '1987-06-18', 1610000, '0010');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('G0033', 'Emanuela', 'Gallo', 'Germania', 'F', '1994-06-11', 100000, '0008');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('F0034', 'Beatrice', 'Ferrari', 'Italia', 'F', '1995-03-20', 310000, '0001');
INSERT INTO `DBScout`.`Atleta` (`ID`, `Nome`, `Cognome`, `Nazionalità`, `Genere`, `Data_di_nascita`, `Valore_di_mercato`, `Agente`) VALUES ('W0035', 'Giorgia', 'Weber', 'Germania', 'F', '2003-04-01', 180000, '0006');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Infortuni`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2020-01-03', '2020-01-30', 'R0001');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2006-05-07', '2006-05-10', 'R0001');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2006-01-03', '2006-02-03', 'R0001');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2009-06-02', '2009-08-01', 'R0001');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2015-02-04', '2015-04-03', 'R0001');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2017-05-04', '2017-05-09', 'R0001');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2011-08-09', '2011-08-15', 'D0008');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2019-08-09', '2019-08-15', 'D0008');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2020-02-05', '2020-05-05', 'D0008');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2021-11-21', NULL, 'D0008');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2014-01-05', '2014-01-15', 'L0003');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2020-05-06', '2020-05-12', 'L0003');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2018-05-06', '2018-05-10', 'N0004');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2021-04-05', '2021-10-05', 'N0004');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2010-05-02', '2010-05-12', 'D0006');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2020-05-06', '2020-11-06', 'D0006');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2011-04-05', '2011-04-12', 'C0007');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2012-01-02', '2012-01-15', 'C0007');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2013-12-24', '2013-12-30', 'C0007');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2018-10-10', '2018-12-10', 'C0007');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2021-04-02', '2021-05-07', 'C0007');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2006-10-10', '2006-11-10', 'B0009');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2011-04-02', '2011-04-07', 'B0009');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2017-02-10', '2017-03-10', 'B0009');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2018-04-05', '2018-05-05', 'B0009');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2019-05-24', '2019-06-24', 'B0009');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2020-04-02', '2020-04-19', 'B0009');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2008-04-02', '2008-04-07', 'F0010');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2009-06-06', '2009-06-21', 'F0010');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2010-12-01', '2010-12-30', 'F0010');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2017-11-11', '2017-12-11', 'F0010');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2018-05-05', '2018-05-25', 'F0010');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2021-04-17', NULL, 'F0010');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2020-12-12', '2020-12-21', 'F0010');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2020-02-01', '2020-02-12', 'P0011');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2021-05-05', '2021-06-21', 'P0011');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2021-09-10', NULL, 'P0011');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2007-05-05', '2007-12-05', 'F0012');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2011-03-04', '2011-04-04', 'F0012');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2012-06-05', '2012-06-15', 'F0012');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2001-04-05', '2001-10-05', 'B0013');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2009-03-04', '2009-04-04', 'B0013');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2010-01-04', '2010-01-09', 'B0013');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2012-03-04', '2012-03-07', 'B0013');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2021-06-05', '2021-10-05', 'B0013');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2014-03-04', '2014-03-24', 'G0014');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2020-10-21', '2021-01-06', 'G0014');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2022-01-04', NULL, 'G0014');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2015-06-06', '2015-10-06', 'D0015');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2019-01-03', '2019-04-03', 'D0015');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2021-12-01', '2021-12-21', 'G0016');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2019-06-06', '2019-06-19', 'F0017');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2008-05-05', '2008-08-08', 'D0018');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2021-08-09', '2021-08-15', 'D0018');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2020-01-01', '2020-01-14', 'L0019');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2020-02-01', '2020-02-05', 'L0019');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2022-01-05', NULL, 'L0019');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2020-04-01', '2020-05-01', 'F0034');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Muscolare', '2021-11-04', '2021-12-01', 'W0035');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Frattura', '2021-12-21', NULL, 'C0029');
INSERT INTO `DBScout`.`Infortuni` (`Tipologia`, `Data_inizio`, `Data_fine`, `Atleta`) VALUES ('Indisposizione', '2021-12-04', '2021-12-06', 'G0030');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Competizioni`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Competizioni` (`Nome`, `Tipo`) VALUES ('Campionato', 'Club');
INSERT INTO `DBScout`.`Competizioni` (`Nome`, `Tipo`) VALUES ('Coppa', 'Club');
INSERT INTO `DBScout`.`Competizioni` (`Nome`, `Tipo`) VALUES ('Coppa Europea', 'Club');
INSERT INTO `DBScout`.`Competizioni` (`Nome`, `Tipo`) VALUES ('Mondiale', 'Nazionale');
INSERT INTO `DBScout`.`Competizioni` (`Nome`, `Tipo`) VALUES ('Europeo/Copa Amèrica', 'Nazionale');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Edizioni`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1990, 'Mondiale');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1994, 'Mondiale');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1998, 'Mondiale');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2002, 'Mondiale');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2006, 'Mondiale');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2010, 'Mondiale');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2014, 'Mondiale');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2018, 'Mondiale');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1992, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1996, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2000, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2004, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2008, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2012, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1990 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1991 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1992 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1993 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1994 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1995 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1996 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1997 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1998 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1999 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2000 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2001 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2002 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2003 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2004 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2005 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2006 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2007 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2008 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2009 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2010 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2011 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2012 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2013 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2014 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2015 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2016 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2017 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2018 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2019 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2020 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2021 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2022 , 'Campionato');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1990 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1991 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1992 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1993 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1994 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1995 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1996 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1997 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1998 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1999 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2000 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2001 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2002 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2003 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2004 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2005 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2006 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2007 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2008 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2009 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2010 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2011 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2012 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2013 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2014 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2015 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2016 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2017 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2018 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2019 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2020 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2021 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2022 , 'Coppa');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1990 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1991 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1992 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1993 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1994 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1995 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1996 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1997 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1998 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (1999 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2000 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2001 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2002 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2003 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2004 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2005 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2006 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2007 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2008 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2009 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2010 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2011 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2012 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2013 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2014 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2015 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2016 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2017 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2018 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2019 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2020 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2021 , 'Coppa Europea');
INSERT INTO `DBScout`.`Edizioni` (`Anno`, `CompetizioneNome`) VALUES (2022 , 'Coppa Europea');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Statistiche_Torneo`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 17, 13, 38, 0, 7, 0, 2003, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 18, 9, 9, 0, 5, 0, 2003, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 10, 11, 26, 3, 2, 0, 2004, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 7, 10, 5, 1, 0, 1, 2004, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 24, 15, 4, 2, 1, 1, 2004, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 10, 5, 34, 4, 10, 1, 2005, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 15, 15, 1, 0, 1, 0, 2005, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 6, 13, 21, 5, 9, 3, 2006, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 7, 12, 5, 4, 7, 3, 2006, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 2, 5, 2, 0, 4, 0, 2006, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 16, 15, 17, 4, 0, 0, 2007, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 17, 6, 10, 3, 8, 1, 2007, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 5, 4, 37, 5, 2, 0, 2008, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 19, 12, 9, 2, 3, 1, 2008, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 9, 15, 35, 5, 6, 5, 2009, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 2, 1, 2, 0, 8, 0, 2009, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 0, 0, 0, 0, 0, 0, 2009, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 28, 11, 31, 5, 9, 3, 2010, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 24, 14, 10, 1, 8, 1, 2010, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 20, 11, 20, 0, 8, 0, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 15, 5, 6, 4, 2, 4, 2011, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 10, 9, 15, 2, 4, 1, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 0, 0, 0, 0, 0, 0, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 30, 8, 18, 5, 7, 3, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 15, 3, 8, 3, 4, 0, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 9, 15, 20, 3, 10, 2, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 15, 15, 7, 3, 0, 2, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 2, 5, 2, 3, 6, 1, 2014, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 25, 11, 7, 5, 1, 2, 2014, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 25, 8, 35, 5, 9, 4, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 12, 9, 4, 0, 10, 0, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 23, 6, 7, 0, 3, 0, 2015, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 13, 12, 14, 1, 6, 1, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 15, 8, 10, 1, 6, 1, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 14, 5, 10, 4, 1, 2, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 27, 6, 33, 2, 2, 0, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 16, 11, 3, 4, 2, 2, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 28, 3, 1, 1, 5, 0, 2017, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 23, 11, 14, 3, 9, 2, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 5, 5, 6, 5, 9, 0, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 17, 5, 28, 3, 3, 3, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 29, 4, 5, 4, 8, 1, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 30, 10, 3, 5, 6, 1, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 8, 13, 20, 0, 10, 0, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 19, 10, 4, 2, 8, 1, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 29, 11, 3, 4, 7, 4, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 27, 8, 8, 0, 1, 0, 2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 28, 5, 11, 5, 8, 4, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 18, 7, 10, 0, 8, 0, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 7, 5, 6, 3, 0, 3, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 15, 9, 33, 2, 10, 0, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 28, 11, 2, 3, 6, 0, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 28, 7, 6, 1, 7, 1, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('R0001', 13, 14, 3, 0, 1, 0, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 24, 14, 28, 1, 2, 1, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 6, 5, 1, 0, 4, 0, 2011, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 28, 11, 5, 5, 10, 4, 2011, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 20, 11, 28, 4, 5, 4, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 20, 5, 1, 2, 6, 0, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 14, 13, 36, 0, 0, 0, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 25, 6, 2, 2, 3, 0, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 30, 5, 4, 2, 6, 1, 2013, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 8, 6, 29, 2, 5, 1, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 15, 3, 9, 2, 1, 2, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 27, 10, 6, 3, 1, 3, 2014, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 24, 7, 10, 2, 6, 0, 2014, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 6, 8, 23, 5, 9, 1, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 18, 10, 7, 2, 3, 0, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 12, 9, 24, 1, 9, 1, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 12, 11, 8, 2, 8, 2, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 30, 7, 7, 1, 9, 1, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 8, 11, 1, 3, 5, 2, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 27, 5, 34, 1, 4, 0, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 26, 6, 1, 2, 10, 0, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 23, 4, 27, 1, 2, 0, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 17, 14, 10, 0, 7, 0, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 0, 0, 0, 0, 0, 0, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 8, 7, 16, 5, 6, 3, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 23, 15, 8, 0, 9, 0, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 18, 6, 1, 0, 0, 0, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 17, 5, 29, 0, 1, 0, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 20, 13, 9, 1, 2, 0, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 8, 13, 4, 5, 10, 4, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 14, 6, 4, 4, 10, 2, 2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 30, 13, 30, 3, 5, 3, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 8, 6, 1, 3, 0, 3, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 29, 5, 9, 4, 6, 4, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 12, 5, 25, 3, 0, 2, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 24, 10, 1, 5, 3, 5, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 0, 0, 0, 0, 0, 0, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0008', 13, 12, 3, 4, 4, 3, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 7, 5, 32, 0, 9, 0, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 16, 11, 7, 5, 4, 2, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 0, 0, 0, 0, 0, 0, 2013, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 11, 8, 28, 3, 4, 3, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 20, 5, 7, 0, 8, 0, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 6, 6, 9, 1, 10, 1, 2014, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 17, 15, 1, 0, 5, 0, 2014, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 7, 11, 35, 0, 6, 0, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 20, 5, 7, 2, 0, 1, 2015, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 29, 13, 25, 1, 10, 1, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 20, 4, 8, 3, 10, 2, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 22, 14, 4, 2, 4, 0, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 21, 3, 4, 1, 8, 0, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 25, 13, 14, 1, 2, 1, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 7, 8, 3, 4, 3, 2, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 19, 4, 20, 1, 4, 1, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 13, 7, 1, 3, 6, 2, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 5, 5, 8, 3, 8, 0, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 15, 5, 3, 0, 3, 0, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 26, 6, 28, 2, 6, 0, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 15, 8, 3, 3, 6, 3, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 26, 14, 22, 1, 8, 0, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 16, 13, 2, 4, 3, 4, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 8, 8, 3, 2, 0, 2, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 28, 5, 7, 3, 9, 1, 2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 7, 6, 28, 4, 0, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 29, 6, 4, 0, 5, 0, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 6, 3, 4, 2, 5, 2, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 20, 3, 20, 0, 7, 0, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 26, 10, 8, 1, 9, 1, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0003', 15, 12, 4, 3, 0, 0, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 2, 31, 0, 2, 0, 2010, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 4, 0, 3, 0, 2010, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 29, 2, 2, 1, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 2, 5, 1, 1, 1, 2011, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 13, 1, 2, 0, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 3, 2, 2, 0, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 7, 2, 2, 2, 2012, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 2, 5, 1, 3, 0, 2012, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 13, 1, 1, 0, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 6, 1, 2, 1, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 19, 3, 0, 2, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 2, 6, 3, 0, 2, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 28, 3, 2, 0, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 0, 0, 0, 0, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 20, 1, 0, 1, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 9, 2, 3, 0, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 2, 3, 0, 1, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 2, 14, 0, 3, 0, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 2, 4, 0, 2, 0, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 19, 0, 1, 0, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 2, 6, 0, 3, 0, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 10, 0, 0, 0, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 5, 1, 2, 0, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 32, 3, 2, 2, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 4, 2, 1, 2, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 23, 0, 2, 0, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 9, 3, 1, 0, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 7, 1, 0, 1, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 31, 1, 3, 1, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 2, 1, 3, 3, 1, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 2, 2, 1, 3, 1, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 0, 33, 1, 3, 0, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('N0004', 0, 1, 1, 1, 2, 1, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 6, 3, 16, 1, 1, 0, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 1, 4, 4, 6, 0, 0, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 7, 4, 9, 8, 10, 5, 2017, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 8, 1, 15, 6, 8, 5, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 10, 0, 4, 1, 10, 0, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 9, 0, 6, 0, 10, 0, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 5, 4, 10, 4, 6, 3, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 6, 4, 15, 2, 1, 0, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 2, 3, 6, 7, 2, 1, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 4, 3, 30, 8, 1, 1, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 8, 4, 6, 4, 2, 2, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 3, 2, 30, 5, 6, 1, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 1, 2, 31, 7, 9, 5, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 6, 0, 4, 5, 10, 1, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 6, 0, 7, 6, 3, 1, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0005', 9, 0, 10, 1, 2, 1, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 4, 1, 12, 6, 8, 0, 2008, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 2, 1, 9, 2, 10, 2, 2008, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 5, 5, 29, 6, 2, 4, 2009, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 2, 0, 3, 2, 0, 0, 2009, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 0, 0, 0, 0, 0, 0, 2009, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 1, 1, 17, 8, 9, 8, 2010, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 6, 5, 9, 7, 10, 7, 2010, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 6, 5, 1, 7, 3, 7, 2010, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 9, 1, 11, 4, 1, 0, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 10, 1, 3, 6, 7, 2, 2011, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 8, 1, 30, 2, 0, 2, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 0, 0, 0, 0, 0, 0, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 5, 3, 3, 8, 5, 0, 2012, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 3, 4, 7, 6, 9, 1, 2012, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 6, 0, 33, 0, 4, 0, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 5, 0, 7, 3, 1, 3, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 1, 0, 4, 8, 9, 2, 2013, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 4, 0, 29, 6, 6, 1, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 4, 0, 10, 7, 3, 1, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 2, 1, 7, 5, 1, 3, 2014, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 4, 2, 11, 0, 5, 0, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 4, 3, 7, 4, 3, 1, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 9, 0, 10, 5, 6, 5, 2015, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 1, 0, 11, 1, 8, 0, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 2, 5, 4, 5, 4, 2, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 0, 0, 0, 0, 0, 0, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 8, 4, 7, 5, 4, 4, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 4, 2, 13, 2, 3, 1, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 1, 0, 2, 3, 0, 0, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 7, 5, 38, 0, 8, 0, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 3, 4, 2, 8, 7, 5, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 6, 2, 13, 3, 10, 3, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 6, 2, 7, 5, 10, 5, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 0, 1, 32, 4, 8, 3, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 8, 1, 13, 3, 8, 2, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 6, 2, 1, 2, 1, 0, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 5, 5, 29, 7, 5, 4, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 10, 4, 5, 6, 2, 4, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 2, 5, 4, 7, 0, 7, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0006', 6, 0, 8, 1, 2, 1, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 10, 6, 20, 1, 5, 1, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 12, 20, 7, 2, 2, 1, 2011, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 9, 17, 8, 4, 7, 2, 2011, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 15, 5, 19, 7, 3, 3, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 5, 3, 3, 4, 6, 2, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 14, 7, 2, 7, 10, 3, 2012, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 15, 8, 13, 1, 10, 1, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 10, 3, 4, 4, 6, 1, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 5, 10, 20, 6, 4, 4, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 10, 9, 4, 5, 4, 2, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 15, 19, 35, 6, 7, 0, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 0, 0, 0, 0, 0, 0, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 0, 0, 0, 0, 0, 0, 2015, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 12, 19, 11, 2, 5, 2, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 15, 4, 4, 1, 9, 1, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 6, 18, 22, 8, 5, 7, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 9, 5, 4, 7, 3, 1, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 15, 6, 34, 5, 9, 3, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 6, 6, 8, 1, 1, 0, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 10, 7, 1, 5, 7, 2, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 9, 17, 6, 6, 3, 0, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 5, 13, 19, 5, 9, 4, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 9, 7, 10, 2, 10, 1, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 0, 0, 0, 0, 0, 0, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 5, 9, 27, 2, 8, 0, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 13, 18, 10, 8, 5, 4, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 12, 13, 6, 5, 3, 3, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 12, 15, 4, 8, 6, 4, 2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 12, 5, 22, 3, 6, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 12, 6, 4, 0, 3, 0, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 11, 17, 37, 6, 10, 6, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 6, 6, 3, 0, 4, 0, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 11, 4, 2, 1, 1, 1, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0007', 13, 7, 5, 6, 4, 1, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 5, 2, 16, 7, 7, 7, 2006, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 10, 5, 3, 2, 2, 2, 2006, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 1, 0, 22, 1, 10, 1, 2007, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 8, 1, 11, 0, 1, 0, 2008, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 3, 1, 9, 1, 10, 0, 2008, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 5, 4, 10, 1, 6, 0, 2008, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 8, 3, 7, 8, 5, 1, 2008, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 4, 3, 32, 6, 1, 3, 2009, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 8, 2, 10, 2, 4, 0, 2009, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 4, 0, 5, 5, 4, 4, 2009, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 7, 4, 16, 1, 6, 0, 2010, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 0, 0, 0, 0, 0, 0, 2010, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 5, 0, 13, 2, 1, 1, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 1, 5, 9, 5, 6, 2, 2011, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 0, 0, 0, 0, 0, 0, 2011, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 7, 1, 11, 7, 4, 4, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 0, 0, 0, 0, 0, 0, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 5, 5, 17, 3, 4, 2, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 6, 2, 6, 5, 5, 3, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 2, 2, 5, 7, 7, 2, 2013, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 1, 4, 12, 2, 4, 2, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 2, 3, 5, 0, 0, 0, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 3, 3, 17, 8, 6, 6, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 3, 0, 2, 8, 9, 2, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 0, 1, 13, 1, 0, 1, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 0, 1, 6, 2, 10, 2, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 6, 2, 7, 6, 3, 3, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 4, 5, 10, 7, 1, 2, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 10, 1, 34, 3, 0, 1, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 6, 3, 10, 1, 7, 1, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 0, 5, 4, 2, 6, 1, 2017, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 5, 1, 22, 7, 10, 6, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 0, 2, 2, 7, 2, 4, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 1, 3, 5, 2, 1, 1, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 7, 5, 3, 7, 9, 1, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 1, 3, 30, 3, 9, 3, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 3, 5, 10, 1, 2, 1, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 6, 2, 22, 4, 3, 3, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 9, 1, 10, 0, 1, 0, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 0, 5, 5, 4, 6, 3, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 0, 0, 4, 0, 3, 0, 2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 5, 4, 19, 2, 0, 1, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 1, 4, 6, 8, 10, 5, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 8, 2, 10, 2, 10, 0, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 3, 3, 19, 8, 7, 2, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0009', 8, 1, 10, 3, 9, 3, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 15, 3, 15, 7, 10, 3, 2008, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 13, 11, 2, 0, 7, 0, 2008, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 13, 6, 6, 2, 10, 1, 2008, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 10, 20, 7, 5, 0, 5, 2008, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 15, 20, 11, 4, 8, 1, 2009, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 6, 6, 5, 7, 5, 4, 2009, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 5, 17, 34, 5, 0, 5, 2010, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 8, 16, 3, 0, 4, 0, 2010, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 11, 19, 4, 6, 10, 0, 2010, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 15, 5, 8, 2, 6, 1, 2010, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 6, 4, 25, 1, 2, 1, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 11, 13, 4, 4, 5, 3, 2011, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 8, 5, 2, 3, 7, 2, 2011, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 5, 9, 31, 4, 4, 2, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 13, 18, 7, 8, 1, 3, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 10, 9, 7, 7, 1, 0, 2012, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 8, 14, 22, 0, 7, 0, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 11, 4, 1, 2, 8, 2, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 14, 17, 17, 8, 6, 2, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 0, 0, 0, 0, 0, 0, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 15, 16, 10, 7, 3, 4, 2014, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 9, 6, 15, 6, 3, 4, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 13, 4, 2, 2, 9, 2, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 11, 13, 3, 3, 3, 3, 2015, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 7, 7, 12, 1, 6, 1, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 11, 12, 1, 4, 3, 2, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 5, 14, 4, 2, 6, 2, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 13, 18, 37, 0, 1, 0, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 8, 4, 5, 3, 2, 1, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 12, 20, 19, 5, 4, 4, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 7, 14, 7, 8, 1, 5, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 5, 6, 10, 8, 2, 7, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 7, 16, 3, 0, 10, 0, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 10, 15, 15, 0, 0, 0, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 11, 17, 4, 8, 1, 6, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 7, 15, 2, 2, 9, 2, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 10, 12, 10, 2, 4, 2, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 15, 4, 4, 0, 0, 0, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 9, 8, 5, 8, 0, 7, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 12, 11, 21, 5, 1, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 0, 0, 0, 0, 0, 0, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 11, 17, 7, 7, 3, 3, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 15, 4, 22, 1, 10, 0, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 14, 15, 5, 2, 0, 0, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 7, 16, 3, 1, 6, 1, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0010', 9, 8, 8, 8, 5, 7, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 1, 29, 2, 3, 2, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 2, 6, 2, 2, 0, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 0, 3, 3, 1, 3, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 0, 37, 0, 0, 0, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 1, 6, 1, 1, 1, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 2, 1, 3, 3, 1, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 2, 2, 0, 0, 0, 2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 2, 18, 3, 3, 3, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 0, 2, 2, 1, 2, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 2, 6, 0, 3, 0, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 2, 22, 0, 2, 0, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 2, 4, 0, 2, 0, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 2, 9, 2, 0, 1, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('P0011', 0, 2, 8, 0, 1, 0, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 5, 1, 22, 5, 8, 2, 2005, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 4, 1, 8, 1, 10, 0, 2005, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 1, 0, 32, 0, 10, 0, 2006, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 5, 3, 8, 0, 1, 0, 2006, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 8, 5, 8, 6, 10, 5, 2006, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 7, 2, 2, 2, 6, 0, 2006, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 3, 3, 30, 0, 4, 0, 2007, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 8, 3, 4, 3, 8, 1, 2007, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 8, 3, 3, 0, 4, 0, 2007, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 4, 1, 23, 5, 6, 4, 2008, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 3, 1, 8, 3, 9, 1, 2008, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 10, 0, 36, 2, 9, 2, 2009, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 1, 0, 8, 2, 5, 1, 2009, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 10, 4, 7, 7, 0, 4, 2009, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 10, 2, 29, 3, 10, 3, 2010, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 2, 2, 7, 1, 6, 1, 2010, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 8, 4, 4, 0, 1, 0, 2010, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 5, 4, 10, 2, 7, 2, 2010, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 10, 3, 11, 3, 2, 0, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 5, 3, 1, 8, 4, 8, 2011, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 5, 0, 26, 8, 5, 7, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 8, 2, 6, 3, 5, 0, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 7, 0, 4, 0, 4, 0, 2012, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 6, 2, 2, 0, 1, 0, 2012, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 4, 2, 11, 5, 2, 2, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 0, 2, 9, 7, 1, 2, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 5, 0, 29, 0, 2, 0, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 10, 5, 7, 8, 8, 0, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 4, 5, 35, 4, 6, 2, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 6, 1, 10, 3, 7, 3, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 10, 5, 16, 3, 0, 3, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 0, 0, 0, 0, 0, 0, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 8, 3, 4, 1, 6, 1, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 0, 3, 9, 6, 4, 6, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 4, 4, 27, 8, 4, 5, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 8, 3, 1, 8, 0, 3, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 10, 0, 31, 0, 3, 0, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 1, 3, 5, 2, 6, 2, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 2, 0, 6, 2, 7, 0, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 0, 0, 0, 0, 0, 0, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 8, 2, 26, 1, 8, 1, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 2, 2, 6, 5, 0, 3, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0012', 0, 0, 0, 0, 0, 0, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 38, 0, 3, 0, 2000, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 1, 2, 2, 0, 2000, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 2, 1, 1, 1, 2000, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 30, 3, 2, 1, 2001, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 0, 0, 0, 0, 2001, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 1, 0, 3, 0, 2001, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 17, 2, 3, 1, 2002, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 3, 3, 0, 0, 2002, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 22, 0, 3, 0, 2003, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 2, 2, 0, 1, 2003, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 15, 2, 3, 0, 2004, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 6, 1, 0, 0, 2004, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 13, 0, 0, 0, 2005, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 7, 0, 2, 0, 2005, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 33, 3, 0, 0, 2006, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 3, 1, 3, 1, 2006, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 10, 2, 2, 1, 2006, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 3, 1, 2, 0, 2006, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 12, 0, 1, 0, 2007, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 7, 0, 3, 0, 2007, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 19, 2, 2, 0, 2008, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 8, 1, 0, 0, 2008, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 10, 2, 3, 1, 2008, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 6, 0, 0, 0, 2008, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 11, 3, 0, 3, 2009, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 8, 3, 1, 0, 2009, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 33, 0, 1, 0, 2010, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 6, 2, 0, 1, 2010, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 5, 1, 1, 1, 2010, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 4, 2, 3, 1, 2010, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 31, 3, 2, 1, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 8, 2, 2, 0, 2011, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 18, 1, 3, 0, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 8, 1, 1, 1, 2012, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 0, 0, 0, 0, 2012, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 10, 0, 1, 0, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 10, 2, 1, 0, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 2, 2, 0, 1, 2013, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 27, 1, 3, 1, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 0, 0, 0, 0, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 0, 0, 0, 0, 2014, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 2, 2, 1, 0, 2014, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 12, 0, 1, 0, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 7, 3, 2, 2, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 4, 0, 1, 0, 2015, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 35, 3, 0, 0, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 2, 3, 1, 0, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 3, 2, 0, 0, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 7, 3, 2, 3, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 16, 3, 2, 3, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 10, 3, 2, 0, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 14, 2, 3, 2, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 6, 2, 2, 2, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 8, 2, 2, 1, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 7, 1, 2, 1, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 24, 3, 2, 1, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 3, 2, 1, 2, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 19, 3, 0, 1, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 8, 3, 1, 3, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 0, 3, 1, 0, 0, 2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 15, 3, 2, 2, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 2, 9, 2, 2, 2, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 37, 3, 2, 2, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('B0013', 0, 1, 5, 2, 0, 1, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 8, 18, 31, 2, 3, 2, 2010, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 12, 6, 7, 4, 1, 4, 2010, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 8, 16, 9, 4, 4, 2, 2010, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 14, 16, 1, 7, 4, 2, 2010, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 12, 5, 12, 7, 5, 1, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 14, 11, 8, 5, 8, 1, 2011, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 14, 5, 35, 3, 3, 3, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 7, 3, 6, 3, 2, 0, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 0, 0, 0, 0, 0, 0, 2012, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 14, 15, 38, 7, 2, 7, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 0, 0, 0, 0, 0, 0, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 8, 16, 10, 6, 9, 0, 2013, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 7, 9, 33, 8, 10, 6, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 14, 10, 5, 3, 3, 0, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 13, 9, 19, 4, 1, 1, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 11, 7, 9, 8, 1, 2, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 15, 12, 13, 2, 9, 0, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 7, 10, 4, 3, 6, 0, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 8, 14, 10, 1, 7, 0, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 12, 6, 2, 3, 0, 2, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 8, 10, 10, 2, 6, 0, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 7, 17, 4, 2, 10, 0, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 8, 18, 21, 3, 2, 2, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 11, 5, 5, 7, 0, 4, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 11, 3, 31, 5, 1, 0, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 12, 14, 4, 4, 7, 4, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 13, 10, 1, 8, 1, 3, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 6, 6, 29, 8, 4, 6, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 10, 16, 6, 6, 5, 5, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 12, 8, 9, 4, 9, 3, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 6, 9, 6, 1, 8, 0, 2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 13, 20, 36, 8, 9, 1, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 9, 14, 5, 7, 4, 6, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 5, 5, 15, 5, 10, 2, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0014', 12, 16, 3, 6, 2, 4, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 8, 5, 12, 0, 8, 0, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 1, 4, 3, 8, 4, 6, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 8, 4, 9, 1, 2, 0, 2013, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 6, 3, 19, 1, 2, 1, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 5, 3, 3, 6, 1, 0, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 10, 3, 3, 5, 3, 1, 2014, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 5, 4, 10, 1, 3, 1, 2014, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 6, 0, 18, 7, 1, 7, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 10, 2, 4, 5, 9, 4, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 3, 0, 9, 5, 3, 2, 2015, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 6, 1, 34, 1, 4, 0, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 3, 5, 4, 0, 7, 0, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 0, 0, 0, 0, 0, 0, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 5, 3, 4, 2, 8, 2, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 6, 4, 26, 5, 5, 1, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 3, 5, 10, 5, 1, 2, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 6, 5, 28, 0, 5, 0, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 1, 0, 5, 3, 5, 2, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 4, 0, 2, 5, 0, 1, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 8, 1, 10, 8, 5, 7, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 5, 1, 5, 4, 1, 4, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 9, 3, 3, 2, 3, 1, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 7, 2, 10, 7, 4, 4, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 0, 0, 0, 0, 0, 0, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 0, 1, 17, 2, 9, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 10, 2, 1, 1, 5, 0, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 4, 5, 13, 3, 6, 0, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 9, 4, 1, 4, 4, 3, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 2, 3, 1, 8, 6, 8, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0015', 7, 0, 5, 7, 10, 0, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 2, 24, 0, 3, 0, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 2, 10, 3, 3, 3, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 1, 2, 1, 0, 2014, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 38, 1, 2, 1, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 2, 7, 2, 1, 1, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 8, 1, 1, 1, 2015, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 37, 3, 1, 1, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 0, 0, 0, 0, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 8, 1, 2, 1, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 6, 2, 1, 0, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 35, 3, 2, 2, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 2, 7, 2, 1, 0, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 10, 3, 3, 3, 2017, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 17, 3, 0, 1, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 7, 0, 2, 0, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 4, 2, 1, 0, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 9, 2, 0, 2, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 23, 2, 0, 2, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 2, 3, 3, 0, 2, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 7, 2, 0, 1, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 22, 2, 3, 1, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 6, 0, 0, 0, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 37, 0, 3, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 2, 8, 0, 0, 0, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 6, 1, 1, 0, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 1, 18, 2, 0, 1, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 2, 2, 1, 1, 0, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 0, 0, 0, 0, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0016', 0, 0, 2, 0, 2, 0, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 24, 7, 12, 0, 0, 0, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 22, 13, 10, 0, 1, 0, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 27, 9, 5, 0, 5, 0, 2017, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 20, 12, 13, 0, 4, 0, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 18, 15, 10, 2, 0, 1, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 25, 15, 2, 0, 9, 0, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 14, 7, 6, 2, 1, 1, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 10, 3, 20, 2, 5, 0, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 0, 0, 0, 0, 0, 0, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 23, 12, 3, 2, 6, 1, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 30, 9, 22, 1, 10, 0, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 21, 15, 8, 1, 6, 1, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 27, 12, 10, 0, 7, 0, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 19, 6, 32, 4, 10, 4, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 14, 11, 8, 2, 4, 0, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 16, 13, 3, 0, 6, 0, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 25, 4, 16, 0, 3, 0, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 29, 5, 5, 5, 8, 2, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0017', 23, 3, 4, 4, 8, 1, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 24, 9, 13, 0, 1, 0, 2008, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 13, 3, 4, 2, 8, 0, 2008, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 15, 13, 10, 0, 1, 0, 2008, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 0, 0, 0, 0, 0, 0, 2008, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 24, 8, 35, 3, 2, 2, 2009, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 9, 4, 4, 3, 6, 1, 2009, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 15, 15, 4, 1, 0, 0, 2009, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 25, 11, 24, 5, 4, 5, 2010, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 20, 6, 10, 2, 9, 2, 2010, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 6, 14, 5, 4, 7, 3, 2010, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 26, 4, 36, 2, 8, 2, 2011, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 17, 14, 6, 2, 8, 0, 2011, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 24, 15, 2, 4, 1, 1, 2011, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 30, 9, 17, 4, 5, 3, 2012, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 12, 6, 5, 0, 5, 0, 2012, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 10, 5, 1, 1, 1, 0, 2012, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 30, 5, 3, 2, 2, 0, 2012, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 19, 13, 26, 1, 8, 0, 2013, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 15, 5, 6, 5, 8, 2, 2013, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 7, 15, 33, 3, 3, 3, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 12, 4, 38, 5, 5, 0, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 17, 4, 1, 0, 7, 0, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 12, 7, 29, 4, 4, 3, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 27, 14, 4, 4, 2, 2, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 26, 7, 8, 4, 0, 2, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 30, 3, 3, 3, 9, 0, 2016, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 16, 3, 20, 4, 2, 0, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 23, 15, 5, 2, 10, 1, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 11, 9, 37, 1, 8, 1, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 14, 6, 7, 1, 3, 0, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 0, 0, 0, 0, 0, 0, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 25, 10, 6, 2, 3, 1, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 8, 13, 36, 3, 0, 2, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 11, 4, 2, 2, 9, 2, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 11, 7, 15, 0, 3, 0, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 14, 9, 10, 3, 2, 3, 2020, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 12, 5, 2, 0, 10, 0, 2020, 'Europeo/Copa Amèrica');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 18, 13, 11, 3, 9, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 8, 12, 5, 3, 6, 2, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 5, 9, 1, 3, 3, 2, 2021, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 15, 14, 15, 5, 9, 3, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('D0018', 9, 11, 3, 0, 1, 0, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 10, 1, 20, 7, 4, 5, 2014, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 10, 1, 1, 1, 10, 1, 2014, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 5, 2, 6, 1, 7, 0, 2014, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 2, 1, 5, 7, 4, 2, 2014, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 9, 2, 37, 1, 5, 0, 2015, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 9, 4, 5, 5, 7, 0, 2015, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 10, 0, 32, 1, 4, 1, 2016, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 0, 5, 8, 2, 2, 2, 2016, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 0, 4, 10, 0, 5, 0, 2016, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 5, 2, 35, 8, 10, 4, 2017, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 0, 0, 0, 0, 0, 0, 2017, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 0, 0, 0, 0, 0, 0, 2017, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 7, 4, 12, 0, 3, 0, 2018, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 10, 5, 9, 5, 2, 2, 2018, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 0, 0, 0, 0, 0, 0, 2018, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 4, 0, 5, 5, 2, 2, 2018, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 6, 1, 11, 2, 0, 1, 2019, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 6, 5, 7, 1, 7, 0, 2019, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 4, 4, 7, 4, 10, 1, 2019, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 3, 2, 35, 1, 6, 0, 2020, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 6, 0, 8, 6, 7, 4, 2020, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 2, 5, 26, 3, 4, 3, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 8, 4, 7, 8, 1, 4, 2021, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 1, 2, 36, 4, 4, 1, 2022, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 1, 0, 4, 5, 3, 3, 2022, 'Coppa');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 4, 3, 9, 1, 8, 0, 2022, 'Coppa Europea');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('L0019', 5, 2, 5, 6, 9, 4, 2022, 'Mondiale');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('S0028', 2, 1, 6, 0, 3, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('C0029', 4, 2, 20, 0, 5, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0030', 5, 3, 20, 2, 2, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('S0031', 6, 5, 20, 0, 3, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0032', 2, 1, 16, 0, 1, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('G0033', 8, 3, 20, 3, 0, 1, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('F0034', 2, 2, 18, 0, 3, 0, 2021, 'Campionato');
INSERT INTO `DBScout`.`Statistiche_Torneo` (`Atleta`, `Gol`, `Assists`, `Presenze`, `Espulsioni`, `Ammonizioni`, `Doppie_Ammonizioni`, `EdizioneA`, `CompetizioneNome`) VALUES ('W0035', 5, 4, 17, 4, 5, 2, 2021, 'Campionato');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Contratti`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('CR001', '2021-07-09', 12000000, '2023-02-02', 0, 'Nike', 'R0001');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC108', '2015-07-20', 4000000, '2019-04-02', 1, 'Nike', 'D0008');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC208', '2019-04-03', 8000000, '2022-02-01', 0, 'Adidas', 'D0008');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC008', '2011-07-18', 1000000, '2015-07-20', 1, 'Givova', 'D0008');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('CC007', '2011-06-20', 1500000, '2014-06-02', 1, 'Nike', 'C0007');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('CC107', '2014-07-20', 4000000, '2015-01-02', 1, 'Nike', 'C0007');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('CC207', '2015-01-03', 5000000, '2022-06-19', 0, 'Adidas', 'C0007');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC106', '2019-06-20', 10000000, '2024-07-21', 0, 'Adidas', 'D0006');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC006', '2008-01-21', 500000, '2019-06-19', 1, 'Puma', 'D0006');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC005', '2017-02-04', 100000, '2019-02-04', 1, 'Nike', 'D0005');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC105', '2019-06-04', 5000000, '2024-06-07', 0, 'Adidas', 'D0005');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('NC004', '2010-06-02', 3000000, '2013-06-05', 1, 'Nike', 'N0004');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('NC104', '2014-07-03', 6000000, '2022-07-05', 0, 'Adidas', 'N0004');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('LC003', '2013-01-02', 5000000, '2015-06-01', 1, 'Puma', 'L0003');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('LC103', '2015-02-05', 10000000, '2018-01-21', 1, 'Nike', 'L0003');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('LC203', '2018-01-22', 15000000, '2025-05-10', 0, 'Adidas', 'L0003');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('BC009', '2006-01-22', 500000, '2010-02-04', 1, NULL, 'B0009');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('BC109', '2010-06-14', 3000000, '2016-06-13', 1, 'Nike', 'B0009');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('BC209', '2016-06-14', 6000000, '2018-08-03', 1, 'Adidas', 'B0009');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('BC309', '2018-08-4', 10000000, '2019-07-14', 1, 'Adidas', 'B0009');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('BC409', '2019-07-15', 5000000, '2023-04-02', 0, 'Adidas', 'B0009');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('FC210', '2008-04-26', 17290134, '2014-03-28', 1, NULL, 'F0010');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('FC510', '2017-10-08', 1200000, '2019-03-12', 1, 'New Balance', 'F0010');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('FC710', '2014-03-29', 7090574, '2017-10-07', 1, 'Puma', 'F0010');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('FC410', '2019-03-13', 6416161, '2022-06-13', 0, 'Adidas', 'F0010');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('PC811', '2022-01-04', 7737247, '2026-01-04', 0, 'Puma', 'P0011');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('PC311', '2019-11-22', 971799, '2022-01-04', 1, 'New Balance', 'P0011');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('FC212', '2017-02-01', 3342606, '2019-09-05', 1, 'Adidas', 'F0012');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('FC712', '2005-01-20', 1709071, '2017-02-01', 1, 'Puma', 'F0012');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('BC113', '2000-09-25', 1137620, '2016-05-19', 1, 'Macron', 'B0013');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('BC913', '2022-01-04', 208540, '2024-01-04', 0, 'Adidas', 'B0013');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('BC813', '2016-05-20', 224409, '2022-01-04', 1, 'New Balance', 'B0013');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('GC914', '2011-03-20', 229356, '2022-03-14', 0, 'Givova', 'G0014');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('GC114', '2010-01-01', 785086, '2011-03-19', 1, 'Adidas', 'G0014');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC015', '2013-02-02', 383310, '2021-07-06', 1, 'Puma', 'D0015');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC115', '2021-11-19', 201497, '2022-11-19', 0, 'Puma', 'D0015');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('GC316', '2014-02-01', 1357477, '2018-06-15', 1, 'Macron', 'G0016');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('GC416', '2018-02-02', 130000, '2023-01-01', 0, 'Macron', 'G0016');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('LC819', '2014-11-17', 285312, '2022-11-07', 0, 'Adidas', 'L0019');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC818', '2021-03-02', 1000000, '2023-04-05', 0, 'Puma', 'D0018');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC218', '2015-01-12', 3285000, '2021-03-02', 1, 'Ellesse', 'D0018');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('DC918', '2008-01-03', 84000, '2015-01-12', 1, NULL, 'D0018');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('FC517', '2021-07-16', 1126035, '2025-04-01', 0, 'Givova', 'F0017');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('FC817', '2017-07-29', 2317037, '2021-07-10', 1, 'Ellesse', 'F0017');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('CR101', '2003-06-05', 3000000, '2009-07-02', 1, 'Nike', 'R0001');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('CR201', '2009-07-03', 20000000, '2018-07-01', 1, 'Adidas', 'R0001');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('CR301', '2018-07-02', 30000000, '2021-07-09', 1, 'Adidas', 'R0001');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('WC035', '2020-02-03', 100000, '2022-06-06', 0, 'Adidas', 'W0035');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('GC033', '2020-02-02', 99000, '2024-05-05', 0, 'Nike', 'G0033');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('FC034', '2020-04-01', 100000, '2024-01-02', 0, NULL, 'F0034');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('GC032', '2020-06-10', 9000, '2023-05-05', 0, 'Puma', 'G0032');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('SC031', '2020-07-20', 45000, '2022-03-03', 0, 'Diadora', 'S0031');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('GC030', '2020-02-01', 20000, '2022-04-05', 0, 'Nike', 'G0030');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('CC029', '2020-06-05', 80000, '2026-05-05', 0, NULL, 'C0029');
INSERT INTO `DBScout`.`Contratti` (`IDContratti`, `Data_inizio`, `Ingaggio`, `Scadenza`, `Scaduto`, `Sponsor`, `Atleta`) VALUES ('SC028', '2020-01-02', 20000, '2025-03-17', 0, 'Adidas', 'S0028');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Trasferimenti`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TR001', NULL, '2021-07-010', 'Manchester United', 'Juventus', 25000000, 'R0001', 'CR001');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TB009', '2018-08-3', '2010-02-03', 'Juventus', 'Bari', 4000000, 'B0009', 'BC109');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TB109', NULL, '2019-07-14', 'Juventus', 'Milan', 10000000, 'B0009', 'BC409');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TB209', '2019-07-14', '2018-08-3', 'Milan', 'Juventus', 30000000, 'B0009', 'BC309');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TL003', NULL, '2015-02-05', 'Bayern Monaco', 'Borussia Dortmund', 40000000, 'L0003', 'LC103');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TN004', NULL, '2014-07-02', 'Bayern Monaco', 'Schalke 04', 20000000, 'N0004', 'NC004');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TD005', NULL, '2019-06-03', 'Bayern Monaco', 'Fc Monty', 500000, 'D0005', 'DC105');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TD006', NULL, '2019-06-20', 'Juventus', 'Ajax', 75000000, 'D0006', 'DC106');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TC007', '2015-01-02', '2014-07-19', 'Chelsea', 'Fiorentina', 30000000, 'C0007', 'CC107');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TC107', NULL, '2015-01-02', 'Juventus', 'Chelsea', 20000000, 'C0007', 'CC207');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TD009', NULL, '2015-07-20', 'Juventus', 'Palermo', 40000000, 'D0008', 'DC108');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TF510', '2014-03-28', '2008-04-26', 'Eintracht Francoforte', 'Stoke City', 20931343, 'F0010', 'FC210  ');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TF910', NULL, '2017-10-08', 'Volpes', 'Leicester', 23185829, 'F0010', 'FC510 ');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TF210', '2017-10-07', '2014-03-29', 'Leicester', 'Eintracht Francoforte', 24357015, 'F0010', 'FC710');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TP311', NULL, '2022-01-04', 'Lille', 'Villareal', 41863099, 'P0011', 'PC811');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TP211', '2022-01-04', '2019-11-22', 'Villareal', 'Porto', 37248251, 'P0011', 'PC311');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TF612', '2019-09-05', '2017-02-01', 'Milan', 'Manchester United', 4017880, 'F0012', 'FC212');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TF212', '2017-02-01', '2005-01-20', 'Manchester United', 'Porto', 3929050, 'F0012', 'FC712');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TB613', '2016-05-19', '2000-09-25', 'Auxerre', 'Roma', 1215761, 'B0013', 'BC113');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TB713', NULL, '2022-01-04', 'Boca Junior', 'Paris Saint-German', 935072, 'B0013', 'BC913');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TB813', '2022-01-04', '2016-05-20', 'Paris Saint-German', 'Auxerre', 303482, 'B0013', 'BC813');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TG814', NULL, '2011-03-20', 'Toronto', 'Boca Junior', 271009, 'G0014', 'GC914');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TG414', '2011-03-19', '2010-01-01', 'Lille', 'Boca Junior', 1117048, 'G0014', 'GC114');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TD815', '2021-07-06', '2013-02-10', 'Real Madrid', 'Roma', 458708, 'D0015', 'DC015 ');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TD515', NULL, '2021-11-19', 'Toronto', 'Roma', 215365, 'D0015', 'DC115');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TG516', '2018-06-15', '2014-02-01', 'Valladolid', 'Juventus', 2242741, 'G0016', 'GC316');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TG566', NULL, '2018-02-02', 'Napoli', 'Valladolid', 2200000, 'G0016', 'GC416');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TF717', '2021-07-10', '2017-07-29', 'Foggia', 'Roma', 2491693, 'F0017', 'FC817');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TF117', NULL, '2021-07-16', 'Roma', 'Deportivo', 1802098, 'F0017', 'FC517');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TD618', NULL, '2021-03-03', 'Barcellona', 'Atletico Madrid', 1717178, 'D0018', 'DC818 ');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TD718', '2021-03-02', '2015-01-11', 'Atletico Madrid', 'Flamengo', 4030468, 'D0018', 'DC218');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TD018', '2015-01-12', '2008-01-03', 'Flamengo', 'Atletico Madrid', 1394477, 'D0018', 'DC918 ');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TL619', '2022-11-07', '2014-11-17', 'Fonte Nuova', 'Boca Junior', 286970, 'L0019', 'LC819');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TR101', '2009-07-02', '2003-06-05', 'Manchester United', 'Sporting Lisbona', 3000000, 'R0001', 'CR101');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TR201', '2018-07-01', '2009-07-03', 'Real Madrid', 'Manchester United', 50000000, 'R0001', 'CR201');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TR301', '2021-07-09', '2018-07-02', 'Juventus', 'Real Madrid', 90000000, 'R0001', 'CR301');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TW035', NULL, '2020-02-04', 'Fiorentina', 'DcScount', 100000, 'W0035', 'WC035');
INSERT INTO `DBScout`.`Trasferimenti` (`ID_trasferimento`, `Data_fine`, `Data_inizio`, `Acquirente`, `Venditore`, `Somma_trasferimento`, `Atleta`, `Contratto`) VALUES ('TF034', NULL, '2020-04-01', 'Chelsea', 'Funesca', 300000, 'F0034', 'FC034');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Caratteristiche`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('R0001', 'Dx', 88, 90, 1.88, 98, 90);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('M0002', 'Sx', 90, 80, 1.70, 99, 87);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('L0003', 'Dx', 77, 90, 1.93, 95, 88);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('N0004', 'Sx', 32, 96, 1.98, 61, 65);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('D0005', 'Sx', 90, 85, 1.80, 80, 90);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('D0006', 'Sx', 70, 95, 1.95, 75, 90);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('C0007', 'Dx', 87, 78, 1.75, 90, 84);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('D0008', 'Sx', 80, 80, 1.78, 92, 80);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('B0009', 'Dx', 70, 92, 1.92, 85, 90);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('F0010', 'Sx', 77, 91, 1.74, 63, 94);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('P0011', 'Dx', 86, 78, 1.98, 91, 63);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('F0012', 'Sx', 84, 81, 1.72, 77, 62);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('B0013', 'Sx', 97, 85, 1.99, 68, 77);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('G0014', 'Dx', 63, 74, 1.87, 89, 64);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('D0015', 'Sx', 81, 85, 1.95, 79, 78);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('G0016', 'Sx', 95, 81, 1.95, 71, 93);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('F0017', 'Sx', 75, 88, 1.92, 65, 78);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('D0018', 'Sx', 66, 94, 1.86, 73, 71);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('L0019', 'Sx', 66, 78, 1.82, 80, 69);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('B0020', 'Sx', 82, 89, 1.85, 64, 66);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('W0021', 'Dx', 92, 75, 1.65, 69, 67);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('D0022', 'Sx', 96, 70, 1.90, 71, 90);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('M0023', 'Sx', 76, 51, 1.90, 76, 77);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('M0024', 'Dx', 67, 66, 1.75, 84, 87);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('T0025', 'Sx', 92, 43, 1.74, 97, 65);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('W0026', 'Sx', 63, 44, 1.84, 66, 85);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('R0027', 'Sx', 76, 63, 1.82, 87, 96);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('S0028', 'Sx', 75, 82, 1.70, 76, 81);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('C0029', 'Dx', 84, 85, 1.83, 62, 66);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('G0030', 'Dx', 66, 43, 1.67, 84, 71);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('S0031', 'Dx', 94, 61, 1.67, 64, 73);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('G0032', 'Sx', 80, 74, 1.76, 77, 62);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('G0033', 'Sx', 66, 75, 1.85, 73, 83);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('F0034', 'Sx', 69, 69, 1.73, 94, 62);
INSERT INTO `DBScout`.`Caratteristiche` (`Atleta`, `Piede`, `Velocità`, `Peso`, `Altezza`, `Tiro`, `Resistenza`) VALUES ('W0035', 'Sx', 82, 81, 1.66, 63, 84);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Palmarès`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('D0008', 6, 2, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('L0003', 16, 6, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('N0004', 19, 5, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('D0005', 6, 4, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('D0006', 3, 4, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('C0007', 8, 5, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('R0001', 30, 10, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('M0002', 30, 16, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('B0009', 14, 13, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('F0010', 13, 2, 2019);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('P0011', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('F0012', 2, 2, 2007);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('B0013', 5, 0, 2020);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('G0014', 1, 1, 2010);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('D0015', 8, 4, 2018);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('G0016', 2, 0, 2015);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('F0017', 2, 0, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('D0018', 4, 1, 2008);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('L0019', 10, 2, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('W0035', 1, 1, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('F0034', 1, 0, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('G0033', 1, 0, 2021);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('G0032', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('S0031', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('G0030', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('C0029', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('S0028', 0, 1, 2020);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('R0027', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('W0026', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('T0025', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('M0024', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('M0023', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('D0022', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('W0021', 0, 0, NULL);
INSERT INTO `DBScout`.`Palmarès` (`Atleta`, `Numero_trofei_squadra`, `Numero_trofei_personali`, `Anno_ultimo_trofeo`) VALUES ('B0020', 0, 0, NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Ruolo`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Ruolo` (`Posizione`) VALUES ('Portiere');
INSERT INTO `DBScout`.`Ruolo` (`Posizione`) VALUES ('Difensore');
INSERT INTO `DBScout`.`Ruolo` (`Posizione`) VALUES ('Centrocampista');
INSERT INTO `DBScout`.`Ruolo` (`Posizione`) VALUES ('Attaccante');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DBScout`.`Ricopre`
-- -----------------------------------------------------
START TRANSACTION;
USE `DBScout`;
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'R0001');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'M0002');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'D0008');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'L0003');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Portiere', 'N0004');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Difensore', 'D0005');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Difensore', 'D0006');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Centrocampista', 'C0007');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Difensore', 'B0009');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Centrocampista', 'F0010');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Portiere', 'P0011');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Difensore', 'F0012');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Portiere', 'B0013');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Centrocampista', 'G0014');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Difensore', 'D0015');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Portiere', 'G0016');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'F0017');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'D0018');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Difensore', 'L0019');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'B0020');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Centrocampista', 'W0021');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'D0022');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Centrocampista', 'M0023');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Portiere', 'M0024');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Difensore', 'T0025');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Portiere', 'W0026');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Portiere', 'R0027');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Centrocampista', 'S0028');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'C0029');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Portiere', 'G0030');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Attaccante', 'S0031');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Difensore', 'G0032');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Portiere', 'G0033');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Centrocampista', 'F0034');
INSERT INTO `DBScout`.`Ricopre` (`Posizione`, `Atleta`) VALUES ('Difensore', 'W0035');

COMMIT;

