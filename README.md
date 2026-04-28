# Progetto_BDSI

# ✈️ Progetto BDSI – Database Compagnia Aerea

## 📌 Descrizione
Questo progetto consiste nella progettazione e implementazione di una base di dati per la gestione di una **compagnia aerea**.

Il sistema permette di gestire:
- Aeroporti e Gate  
- Voli (partenze e arrivi)  
- Prenotazioni e pagamenti  
- Passeggeri e Check-In  
- Dipendenti (equipaggio e servizio clienti)  
- Servizi offerti durante i voli  

Il progetto copre tutte le fasi di sviluppo di un database: **analisi dei requisiti, progettazione concettuale, logica e implementazione in MySQL**.

---

## 🧱 Struttura del Progetto

Il progetto è suddiviso in tre fasi principali:

### 1. Progettazione Concettuale
- Analisi dei requisiti
- Costruzione schema E-R
- Documentazione di:
  - Entità
  - Relazioni
  - Vincoli

### 2. Progettazione Logica
- Ristrutturazione schema E-R
- Traduzione in schema relazionale
- Definizione dei vincoli di integrità referenziale

### 3. Implementazione MySQL
- Creazione tabelle
- Popolamento dati
- Query
- Procedure
- Trigger
- Viste

---

## 🗄️ Schema Database

### Tabelle principali
- `Aeroporto`
- `Gate`
- `Volo`
- `Dipendente`
- `Prenotante`
- `Prenotazione`
- `Passeggero`
- `Servizi`

### Tabelle di relazione
- `Equipaggio`
- `ServizioClienti`
- `Richiesta`
- `Usa`
- `Offre`

---

## ⚙️ Funzionalità Implementate

### 🔍 Query
- Mostrare voli in ritardo  
- Visualizzare i passeggeri con volo e aeroporto  
- Guadagno totale per metodo di pagamento  
- Passeggeri con più servizi utilizzati  
- Voli con più di tre servizi  
- Elenco prenotazioni per prenotante  

---

### 🧠 Procedure
- `AnnullaPrenotazione`  
- `AggiungiVolo`  
- `AssegnaServizioClienti`  

---

### ⚡ Trigger
- Controllo data check-in  
- Verifica ore equipaggio (max 150/mese)  
- Verifica servizi disponibili per passeggero  

---

### 👁️ Viste
- `VistaVoliGateAeroporto`  
- `VistaServiziPasseggeri`  

---

## 🔒 Vincoli Principali
- Identificatori univoci per tutte le entità  
- Un gate non può avere più voli contemporaneamente  
- Check-in obbligatorio per poter volare  
- Limite massimo ore equipaggio: **150 ore/mese**  
- Integrità referenziale tra le tabelle  

---

## 🛠️ Tecnologie Utilizzate
- MySQL  
- SQL (DDL, DML)  
- Stored Procedures  
- Trigger  
