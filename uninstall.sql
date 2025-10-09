-- =====================================================================
-- uninstall.sql
--
-- This script drops all objects created for the project.
-- Run this script to clean the database.
-- =====================================================================

-- Drop Views
DROP VIEW magazyn_zawartosc;
DROP VIEW szczegoly_zamowienia;
DROP VIEW dzialy_statystyka_sprzedazy;
DROP VIEW statystyka_zakupow_klientow;
DROP VIEW sprzedaz_kwartalna;
DROP VIEW przychody_kwartalne;

-- Drop Procedure
DROP PROCEDURE przyjmij_dostawe;

-- Drop Tables (CASCADE CONSTRAINTS drops dependent objects and constraints)
DROP TABLE dzial_produktowy CASCADE CONSTRAINTS;
DROP TABLE klient CASCADE CONSTRAINTS;
DROP TABLE magazyn CASCADE CONSTRAINTS;
DROP TABLE pozycja_promocji CASCADE CONSTRAINTS;
DROP TABLE pozycja_zamowienia CASCADE CONSTRAINTS;
DROP TABLE pracownik CASCADE CONSTRAINTS;
DROP TABLE produkt CASCADE CONSTRAINTS;
DROP TABLE promocja CASCADE CONSTRAINTS;
DROP TABLE stan_magazynowy CASCADE CONSTRAINTS;
DROP TABLE zamowienie CASCADE CONSTRAINTS;

-- Drop Sequences
DROP SEQUENCE seq_dzial_produktowy;
DROP SEQUENCE seq_klient;
DROP SEQUENCE seq_magazyn;
DROP SEQUENCE seq_pracownik;
DROP SEQUENCE seq_produkt;
DROP SEQUENCE seq_promocja;
DROP SEQUENCE seq_zamowienie;
