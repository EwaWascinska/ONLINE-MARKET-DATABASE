-- =====================================================================
-- 04_data.sql
--
-- This script populates the database with initial sample data.
-- =====================================================================

INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Jan', 'Kowalski', 'Miodowa 5', '00-955', 'Warszawa');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy)
VALUES ('Adam', 'Nowak', 'Lipowa 10', '00-001');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Maria', 'Wiśniewska', 'Słoneczna 23', '80-125', 'Gdańsk');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy)
VALUES ('Piotr', 'Zieliński', 'Leśna 8', '81-601');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Ewa', 'Szymańska', 'Parkowa 11', '32-065', 'Kraków');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy)
VALUES ('Paweł', 'Wójcik', 'Wrzosowa 7', '15-118');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Agnieszka', 'Lewandowska', 'Wesoła 56', '01-234', 'Warszawa');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Tomasz', 'Dąbrowski', 'Rejtana 4', '35-326', 'Rzeszów');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy)
VALUES ('Anna', 'Jankowska', 'Chmielna 12', '00-111');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Karolina', 'Woźniak', 'Lipowa 45', '45-201', 'Opole');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Krzysztof', 'Mazur', 'Krótka 2', '40-100', 'Katowice');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy)
VALUES ('Joanna', 'Pawlak', 'Szeroka 14', '20-330');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Maciej', 'Kaczmarek', 'Kwiatowa 9', '60-123', 'Poznań');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy)
VALUES ('Alicja', 'Kowal', 'Miła 1', '70-456');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Urszula', 'Dudek', 'Cedrowa 12', '34-340', 'Jabłonka');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy, miasto)
VALUES ('Artur', 'Olejniczak', 'Topolowa 99', '44-400', 'Gliwice');
INSERT INTO klient (imie, nazwisko, adres, kod_pocztowy)
VALUES ('Monika', 'Pawłowska', 'Wierzbowa 2', '18-555');
INSERT INTO dzial_produktowy (nazwa) VALUES ('Narzędzia ręczne');
INSERT INTO dzial_produktowy (nazwa) VALUES ('Elektronarzędzia');
INSERT INTO dzial_produktowy (nazwa) VALUES ('Ogród i narzędzia ogrodowe');
INSERT INTO dzial_produktowy (nazwa) VALUES ('Materiały budowlane');
INSERT INTO dzial_produktowy (nazwa) VALUES ('Wykończenie i dekoracja');
INSERT INTO magazyn (nr_magazynu, kod_pocztowy, miasto, adres, miesieczny_koszt_utrzymania)
VALUES (1, '00-001', 'Warszawa', 'Ul. Składowa 1', 2000);
INSERT INTO magazyn (nr_magazynu, kod_pocztowy, miasto, adres, miesieczny_koszt_utrzymania)
VALUES (2, '31-001', 'Kraków', 'Ul. Magazynowa 2', 1500);
INSERT INTO pracownik (id_pracownika, stanowisko, imie, nazwisko, data_urodzenia, nr_magazynu,
miesieczne_wynagrodzenie)
VALUES (1, 'Magazynier', 'Jan', 'Malinowski', DATE '1980-05-15', 1, 2000);
INSERT INTO pracownik (id_pracownika, stanowisko, imie, nazwisko, data_urodzenia, nr_magazynu,
miesieczne_wynagrodzenie)
VALUES (2, 'Magazynier', 'Anna', 'Rogowska', DATE '1982-10-07', 1, 2000);
INSERT INTO pracownik (id_pracownika, stanowisko, imie, nazwisko, data_urodzenia, nr_magazynu,
miesieczne_wynagrodzenie)
VALUES (3, 'Kierownik', 'Janusz', 'Jabłonowski', DATE '1970-02-09', 1, 3000);
INSERT INTO pracownik (id_pracownika, stanowisko, imie, nazwisko, data_urodzenia, nr_magazynu,
miesieczne_wynagrodzenie)
VALUES (4, 'Magazynier', 'Piotr', 'Jasiński', DATE '1990-11-23', 2, 2100);
INSERT INTO pracownik (id_pracownika, stanowisko, imie, nazwisko, data_urodzenia, nr_magazynu,
miesieczne_wynagrodzenie)
VALUES (5, 'Kierownik', 'Maria', 'Zawadzka', DATE '1979-08-25', 2, 3100);
INSERT INTO promocja (kod_rabatowy, nazwa, data_rozpoczecia, data_zakonczenia, rabat_procentowy)
VALUES ('PROMO5OFF', 'Rabat 5%', TO_DATE('2023-01-01','YYYY-MM-DD'), TO_DATE('2023-12-31','YYYY-MM-
DD'), 5);
INSERT INTO promocja (kod_rabatowy, nazwa, data_rozpoczecia, data_zakonczenia, rabat_procentowy)
VALUES ('PROMO15OFF', 'Rabat 15%', TO_DATE('2023-03-01','YYYY-MM-DD'), TO_DATE('2024-03-01','YYYY-
MM-DD'), 15);
INSERT INTO promocja (kod_rabatowy, nazwa, data_rozpoczecia, data_zakonczenia, rabat_procentowy)
VALUES ('PROMO25OFF', 'Mega wyprzedaż 25%', SYSDATE, SYSDATE + 30, 25);
INSERT INTO promocja (kod_rabatowy, nazwa, data_rozpoczecia, data_zakonczenia, rabat_procentowy)
VALUES ('SUMMER2024', 'Letnia promocja 10%', TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-
31','YYYY-MM-DD'), 10);
INSERT INTO promocja (kod_rabatowy, nazwa, data_rozpoczecia, data_zakonczenia, rabat_procentowy)
VALUES ('WINTER2025', 'Zimowa promocja 20%', TO_DATE('2024-12-01','YYYY-MM-DD'), TO_DATE('2025-02-
28','YYYY-MM-DD'), 20);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Młotek standard', 25, 2);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 100);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 200);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Klucz płaski 10mm', 15, 1);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 200);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 150);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Obcęgi', 18, 1);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 150);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 120);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Wkrętak krzyżakowy', 10, 1);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 230);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 120);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Wkrętak płaski', 9, 1);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 70);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 320);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Szczypce uniwersalne', 22, 1);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 160);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 50);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Piła do metalu', 30, 1);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 70);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 150);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Miara 5m', 12, 1);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 180);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 40);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Wiertarka udarowa', 150, 2);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 10);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 5);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Szlifierka kątowa', 130, 2);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 7);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 14);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Wkrętarka akumulatorowa', 120, 2);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 12);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 11);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Piła ukośna', 280, 2);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 4);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 6);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Strug elektryczny', 210, 2);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 8);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 14);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Frezarka górnowrzecionowa', 250, 2);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 10);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 3);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Mieszarka zapraw', 180, 2);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 15);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 10);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Opalarka', 90, 2);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 6);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 7);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Kosiarka spalinowa', 800, 3);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 5);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 2);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Podkaszarka', 150, 3);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 20);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 15);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Nożyce do żywopłotu', 120, 3);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 11);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 9);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Łopata ogrodowa', 40, 3);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 25);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 10);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Sekator uniwersalny', 35, 3);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 5);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 6);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Taczka ogrodowa', 130, 3);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 2);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 8);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Opryskiwacz ręczny', 60, 3);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 14);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 10);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Wąż ogrodowy 30m', 75, 3);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 6);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 14);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Cegła ceramiczna', 2, 4);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 100);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 200);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Pustak betonowy', 3, 4);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 120);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 100);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Styropian elewacyjny', 40, 4);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 150);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 80);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Papa termozgrzewalna', 35, 4);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 100);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 50);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Cement 25kg', 14, 4);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 50);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 400);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Gips szpachlowy', 18, 4);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 250);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 150);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Farba gruntująca', 50, 4);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 120);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 100);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Siatka zbrojeniowa', 120, 4);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 50);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 70);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Panel podłogowy', 45, 5);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 300);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 250);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Listwa przypodłogowa', 8, 5);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 350);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 200);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Płytka ceramiczna 30x30', 60, 5);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 150);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 120);
INSERT INTO produkt (nazwa, cena, nr_dzialu) VALUES ('Fuga elastyczna', 25, 5);
INSERT INTO stan_magazynowy VALUES (1, seq_produkt.CURRVAL, 200);
INSERT INTO stan_magazynowy VALUES (2, seq_produkt.CURRVAL, 50);
ts, I've kept all 40+ inserts from your file)
