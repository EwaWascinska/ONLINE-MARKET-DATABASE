-- =====================================================================
-- 03_views.sql
--
-- This script creates all views for business intelligence and reporting.
-- =====================================================================


-- View to monitor warehouse contents
CREATE OR REPLACE VIEW magazyn_zawartosc AS
SELECT
    m.miasto || ', ' || m.adres AS "lokalizacja_magazynu",
    p.nazwa AS produkt,
    s.liczba AS "liczba_w_magazynie"
FROM stan_magazynowy s
JOIN magazyn m ON s.nr_magazynu = m.nr_magazynu
JOIN produkt p ON s.nr_produktu = p.nr_produktu;


-- View for detailed order tracking
CREATE OR REPLACE VIEW szczegoly_zamowienia AS
SELECT
    z.nr_zamowienia,
    z.data_zlozenia,
    z.data_realizacji,
    CASE
        WHEN z.data_realizacji <= SYSDATE THEN 'ZREALIZOWANE'
        ELSE 'W TRAKCIE'
    END AS status_zamowienia,
    k.imie || ' ' || k.nazwisko AS klient,
    z.wartosc_zamowienia,
    (SELECT SUM(pz.ilosc) FROM pozycja_zamowienia pz WHERE pz.nr_zamowienia = z.nr_zamowienia) AS liczba_pozycji,
    z.kod_rabatowy
FROM zamowienie z
JOIN klient k ON z.nr_klienta = k.nr_klienta;


-- View for sales statistics by product department
CREATE OR REPLACE VIEW dzialy_statystyka_sprzedazy AS
SELECT
    d.nazwa AS dzial,
    SUM(z.ilosc) AS "liczba_sprzedazy",
    SUM(z.ilosc * p.cena) AS "wartosc_sprzedazy"
FROM pozycja_zamowienia z
JOIN produkt p ON z.nr_produktu = p.nr_produktu
JOIN dzial_produktowy d ON p.nr_dzialu = d.nr_dzialu
GROUP BY d.nazwa;


-- View for customer purchasing statistics
CREATE OR REPLACE VIEW statystyka_zakupow_klientow AS
SELECT
    (k.imie || ' ' || k.nazwisko) AS "klient",
    k.miasto,
    COUNT(z.nr_zamowienia) AS "liczba_zamowien",
    SUM(NVL(z.wartosc_zamowienia, 0)) AS "wartosc_zamowien"
FROM klient k
LEFT JOIN zamowienie z ON k.nr_klienta = z.nr_klienta
GROUP BY (k.imie || ' ' || k.nazwisko), k.miasto;


-- View for quarterly sales summary
CREATE OR REPLACE VIEW sprzedaz_kwartalna AS
SELECT
    TO_CHAR(z.data_zlozenia, 'YYYY') AS "rok",
    CASE
        WHEN TO_NUMBER(TO_CHAR(z.data_zlozenia, 'MM')) IN (1, 2, 3) THEN 'Q1'
        WHEN TO_NUMBER(TO_CHAR(z.data_zlozenia, 'MM')) IN (4, 5, 6) THEN 'Q2'
        WHEN TO_NUMBER(TO_CHAR(z.data_zlozenia, 'MM')) IN (7, 8, 9) THEN 'Q3'
        WHEN TO_NUMBER(TO_CHAR(z.data_zlozenia, 'MM')) IN (10, 11, 12) THEN 'Q4'
    END AS "kwartal",
    SUM(NVL(z.wartosc_zamowienia, 0)) AS "wartosc_zamowien",
    COUNT(DISTINCT z.nr_zamowienia) AS "liczba_zamowien"
FROM zamowienie z
GROUP BY
    TO_CHAR(z.data_zlozenia, 'YYYY'),
    CASE
        WHEN TO_NUMBER(TO_CHAR(z.data_zlozenia, 'MM')) IN (1, 2, 3) THEN 'Q1'
        WHEN TO_NUMBER(TO_CHAR(z.data_zlozenia, 'MM')) IN (4, 5, 6) THEN 'Q2'
        WHEN TO_NUMBER(TO_CHAR(z.data_zlozenia, 'MM')) IN (7, 8, 9) THEN 'Q3'
        WHEN TO_NUMBER(TO_CHAR(z.data_zlozenia, 'MM')) IN (10, 11, 12) THEN 'Q4'
    END;


-- View for quarterly revenue and profit calculation
CREATE OR REPLACE VIEW przychody_kwartalne AS
SELECT
    sk."rok",
    sk."kwartal",
    sk."wartosc_zamowien",
    sk."liczba_zamowien",
    SUM(DISTINCT m.miesieczny_koszt_utrzymania * 3) AS "koszty_utrzymania_magazynow",
    SUM(DISTINCT p.miesieczne_wynagrodzenie * 3) AS "koszty_pracownikow",
    sk."wartosc_zamowien" - SUM(DISTINCT m.miesieczny_koszt_utrzymania * 3) - SUM(DISTINCT p.miesieczne_wynagrodzenie * 3) AS "zysk"
FROM sprzedaz_kwartalna sk
CROSS JOIN magazyn m
LEFT JOIN pracownik p ON p.nr_magazynu = m.nr_magazynu
GROUP BY
    sk."rok", sk."kwartal", sk."wartosc_zamowien", sk."liczba_zamowien"
ORDER BY
    sk."rok" DESC,
    sk."kwartal" ASC;
