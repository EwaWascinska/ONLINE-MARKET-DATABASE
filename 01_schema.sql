-- =====================================================================
-- 01_schema.sql
--
-- This script creates all database tables, sequences, and constraints.
-- =====================================================================


-- Sequences for Primary Keys
CREATE SEQUENCE seq_dzial_produktowy START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE;
CREATE SEQUENCE seq_klient START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE;
CREATE SEQUENCE seq_magazyn START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE;
CREATE SEQUENCE seq_pracownik START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE;
CREATE SEQUENCE seq_produkt START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE;
CREATE SEQUENCE seq_promocja START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE;
CREATE SEQUENCE seq_zamowienie START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE;


-- Table Creation
CREATE TABLE dzial_produktowy (
    nr_dzialu NUMBER(2) NOT NULL,
    nazwa VARCHAR2(30) NOT NULL
);
ALTER TABLE dzial_produktowy ADD CONSTRAINT dzial_produktowy_pk PRIMARY KEY (nr_dzialu);

CREATE TABLE klient (
    nr_klienta NUMBER(6) NOT NULL,
    imie VARCHAR2(20) NOT NULL,
    nazwisko VARCHAR2(40) NOT NULL,
    adres VARCHAR2(50) NOT NULL,
    kod_pocztowy VARCHAR2(6) NOT NULL,
    miasto VARCHAR2(20) DEFAULT 'Brak danych'
);
ALTER TABLE klient ADD CONSTRAINT klient_pk PRIMARY KEY (nr_klienta);

CREATE TABLE magazyn (
    nr_magazynu NUMBER(2) NOT NULL,
    kod_pocztowy VARCHAR2(6) NOT NULL,
    miasto VARCHAR2(20),
    adres VARCHAR2(50) NOT NULL,
    miesieczny_koszt_utrzymania NUMBER(5) NOT NULL
);
ALTER TABLE magazyn ADD CONSTRAINT magazyn_pk PRIMARY KEY (nr_magazynu);

CREATE TABLE pracownik (
    id_pracownika NUMBER(5) NOT NULL,
    stanowisko VARCHAR2(30) NOT NULL,
    imie VARCHAR2(20) NOT NULL,
    nazwisko VARCHAR2(40) NOT NULL,
    data_urodzenia DATE NOT NULL,
    nr_magazynu NUMBER(2),
    miesieczne_wynagrodzenie NUMBER(4) NOT NULL
);
ALTER TABLE pracownik ADD CONSTRAINT pracownik_pk PRIMARY KEY (id_pracownika);

CREATE TABLE produkt (
    nr_produktu NUMBER(5) NOT NULL,
    nazwa VARCHAR2(50) NOT NULL,
    cena NUMBER(5) NOT NULL,
    nr_dzialu NUMBER(2) NOT NULL
);
ALTER TABLE produkt ADD CONSTRAINT produkt_pk PRIMARY KEY (nr_produktu);

CREATE TABLE promocja (
    nr_promocji NUMBER(5) NOT NULL,
    kod_rabatowy VARCHAR2(20) NOT NULL,
    nazwa VARCHAR2(50) NOT NULL,
    data_rozpoczecia DATE DEFAULT sysdate NOT NULL,
    data_zakonczenia DATE NOT NULL,
    rabat_procentowy NUMBER(2) NOT NULL
);
ALTER TABLE promocja ADD CONSTRAINT promocja_pk PRIMARY KEY (nr_promocji);
ALTER TABLE promocja ADD CONSTRAINT promocja_kod_rabatowy_unique UNIQUE (kod_rabatowy);

CREATE TABLE zamowienie (
    nr_zamowienia NUMBER(7) NOT NULL,
    nr_klienta NUMBER(6) NOT NULL,
    data_zlozenia DATE DEFAULT sysdate NOT NULL,
    data_realizacji DATE NOT NULL,
    wartosc_zamowienia NUMBER(6) NOT NULL,
    kod_rabatowy VARCHAR2(20)
);
ALTER TABLE zamowienie ADD CONSTRAINT zamowienie_pk PRIMARY KEY (nr_zamowienia);

-- Junction Tables
CREATE TABLE pozycja_promocji (
    nr_promocji NUMBER(5) NOT NULL,
    nr_produktu NUMBER(5) NOT NULL
);
ALTER TABLE pozycja_promocji ADD CONSTRAINT pozycja_promocji_pk PRIMARY KEY (nr_promocji, nr_produktu);

CREATE TABLE pozycja_zamowienia (
    nr_produktu NUMBER(5) NOT NULL,
    nr_zamowienia NUMBER(7) NOT NULL,
    ilosc NUMBER(4) DEFAULT 0 NOT NULL,
    cena_regularna NUMBER(5) NOT NULL
);
ALTER TABLE pozycja_zamowienia ADD CONSTRAINT pozycja_zamowienia_pk PRIMARY KEY (nr_produktu, nr_zamowienia);

CREATE TABLE stan_magazynowy (
    nr_magazynu NUMBER(2) NOT NULL,
    nr_produktu NUMBER(5) NOT NULL,
    liczba NUMBER(6) DEFAULT 0 NOT NULL
);
ALTER TABLE stan_magazynowy ADD CONSTRAINT stan_magazynowy_pk PRIMARY KEY (nr_magazynu, nr_produktu);


-- Foreign Key Constraints
ALTER TABLE produkt ADD CONSTRAINT dzial_produktowy_fk FOREIGN KEY (nr_dzialu) REFERENCES dzial_produktowy (nr_dzialu) ON DELETE CASCADE NOT DEFERRABLE;
ALTER TABLE zamowienie ADD CONSTRAINT klient_fk FOREIGN KEY (nr_klienta) REFERENCES klient (nr_klienta) ON DELETE CASCADE NOT DEFERRABLE;
ALTER TABLE pracownik ADD CONSTRAINT magazyn_fk FOREIGN KEY (nr_magazynu) REFERENCES magazyn (nr_magazynu) NOT DEFERRABLE;
ALTER TABLE stan_magazynowy ADD CONSTRAINT magazyn_fkv1 FOREIGN KEY (nr_magazynu) REFERENCES magazyn (nr_magazynu) NOT DEFERRABLE;
ALTER TABLE stan_magazynowy ADD CONSTRAINT produkt_fk FOREIGN KEY (nr_produktu) REFERENCES produkt (nr_produktu) NOT DEFERRABLE;
ALTER TABLE pozycja_zamowienia ADD CONSTRAINT produkt_fkv1 FOREIGN KEY (nr_produktu) REFERENCES produkt (nr_produktu) ON DELETE CASCADE NOT DEFERRABLE;
ALTER TABLE pozycja_promocji ADD CONSTRAINT produkt_fkv2 FOREIGN KEY (nr_produktu) REFERENCES produkt (nr_produktu) NOT DEFERRABLE;
ALTER TABLE pozycja_promocji ADD CONSTRAINT promocja_fk FOREIGN KEY (nr_promocji) REFERENCES promocja (nr_promocji) NOT DEFERRABLE;
ALTER TABLE pozycja_zamowienia ADD CONSTRAINT zamowienie_fk FOREIGN KEY (nr_zamowienia) REFERENCES zamowienie (nr_zamowienia) ON DELETE CASCADE NOT DEFERRABLE;


-- Set Default Values from Sequences
ALTER TABLE dzial_produktowy MODIFY nr_dzialu DEFAULT seq_dzial_produktowy.NEXTVAL;
ALTER TABLE klient MODIFY nr_klienta DEFAULT seq_klient.NEXTVAL;
ALTER TABLE magazyn MODIFY nr_magazynu DEFAULT seq_magazyn.NEXTVAL;
ALTER TABLE pracownik MODIFY id_pracownika DEFAULT seq_pracownik.NEXTVAL;
ALTER TABLE produkt MODIFY nr_produktu DEFAULT seq_produkt.NEXTVAL;
ALTER TABLE promocja MODIFY nr_promocji DEFAULT seq_promocja.NEXTVAL;
ALTER TABLE zamowienie MODIFY nr_zamowienia DEFAULT seq_zamowienie.NEXTVAL;


-- Check Constraints
ALTER TABLE promocja ADD CONSTRAINT promocja_date_range_ck CHECK (data_zakonczenia > data_rozpoczecia);
ALTER TABLE zamowienie ADD CONSTRAINT zamowienie_date_ck CHECK (data_realizacji > data_zlozenia);
