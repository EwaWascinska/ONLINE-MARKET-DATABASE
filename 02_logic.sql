-- =====================================================================
-- 02_logic.sql
--
-- This script creates triggers for automated business logic and the
-- stored procedure for managing deliveries.
-- =====================================================================


-- Trigger to handle new order item insertions
CREATE OR REPLACE TRIGGER update_on_insert_in_zamowienie
BEFORE INSERT ON pozycja_zamowienia
FOR EACH ROW
DECLARE
    v_suma_stan        NUMBER; -- Sum of stock for the product
    v_left_to_sub      NUMBER; -- Quantity remaining to be subtracted from warehouses
    v_cena_produktu    NUMBER(5); -- Product price from the 'produkt' table
    v_kod_rabatowy     VARCHAR2(20); -- Discount code from the 'zamowienie' table
    v_nr_promocji      NUMBER(5);
    v_rabat_procentowy NUMBER(2);
    v_data_zakonczenia DATE;
    v_ilosc            NUMBER(4); -- Shortcut for :NEW.ilosc
    v_line_cost        NUMBER(10,2); -- Value of the order item
    v_count_promocja   NUMBER; -- Check if the product is on promotion
BEGIN
    v_ilosc := :NEW.ilosc;

    -- Calculate total stock for the product across all warehouses
    SELECT NVL(SUM(liczba), 0)
    INTO v_suma_stan
    FROM stan_magazynowy
    WHERE nr_produktu = :NEW.nr_produktu;

    -- If not enough stock, raise an error
    IF v_suma_stan < v_ilosc THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock for product (' || :NEW.nr_produktu || ') across all warehouses.');
    END IF;

    -- Sequentially subtract stock from warehouses, starting with the lowest warehouse ID
    v_left_to_sub := v_ilosc;
    FOR rec IN (
        SELECT nr_magazynu, liczba
        FROM stan_magazynowy
        WHERE nr_produktu = :NEW.nr_produktu AND liczba > 0
        ORDER BY nr_magazynu
    ) LOOP
        EXIT WHEN v_left_to_sub = 0;

        IF rec.liczba >= v_left_to_sub THEN
            UPDATE stan_magazynowy
            SET liczba = liczba - v_left_to_sub
            WHERE nr_magazynu = rec.nr_magazynu AND nr_produktu = :NEW.nr_produktu;
            v_left_to_sub := 0;
        ELSE
            v_left_to_sub := v_left_to_sub - rec.liczba;
            UPDATE stan_magazynowy
            SET liczba = 0
            WHERE nr_magazynu = rec.nr_magazynu AND nr_produktu = :NEW.nr_produktu;
        END IF;
    END LOOP;

    -- Set the regular price in the order item from the product table
    SELECT cena INTO v_cena_produktu FROM produkt WHERE nr_produktu = :NEW.nr_produktu;
    :NEW.cena_regularna := v_cena_produktu;

    -- Calculate the final line cost, applying discounts if applicable
    SELECT z.kod_rabatowy INTO v_kod_rabatowy FROM zamowienie z WHERE z.nr_zamowienia = :NEW.nr_zamowienia;

    IF v_kod_rabatowy IS NULL THEN
        v_line_cost := v_ilosc * v_cena_produktu;
    ELSE
        BEGIN
            SELECT p.nr_promocji, p.rabat_procentowy, p.data_zakonczenia
            INTO v_nr_promocji, v_rabat_procentowy, v_data_zakonczenia
            FROM promocja p
            WHERE p.kod_rabatowy = v_kod_rabatowy;

            -- Check if promotion is active and applies to this product
            IF v_data_zakonczenia > SYSDATE THEN
                SELECT COUNT(*) INTO v_count_promocja
                FROM pozycja_promocji pp
                WHERE pp.nr_promocji = v_nr_promocji AND pp.nr_produktu = :NEW.nr_produktu;

                IF v_count_promocja > 0 THEN
                    v_line_cost := v_ilosc * v_cena_produktu * (1 - v_rabat_procentowy / 100);
                ELSE
                    v_line_cost := v_ilosc * v_cena_produktu;
                END IF;
            ELSE
                v_line_cost := v_ilosc * v_cena_produktu; -- Promotion expired
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_line_cost := v_ilosc * v_cena_produktu; -- Promotion code is invalid
        END;
    END IF;

    -- Update the total order value
    UPDATE zamowienie
    SET wartosc_zamowienia = wartosc_zamowienia + v_line_cost
    WHERE nr_zamowienia = :NEW.nr_zamowienia;
END;
/


-- Trigger to handle order item deletions
CREATE OR REPLACE TRIGGER restore_stan_on_delete_in_zamowienie
AFTER DELETE ON pozycja_zamowienia
FOR EACH ROW
DECLARE
    v_kod_rabatowy     VARCHAR2(20);
    v_nr_promocji      NUMBER(5);
    v_rabat_procentowy NUMBER(2);
    v_data_zakonczenia DATE;
    v_count_promocja   NUMBER;
    v_cena_produktu    NUMBER(5);
    v_line_cost        NUMBER(10,2); -- Cost of the deleted item
BEGIN
    -- Recalculate the cost of the deleted item to subtract it from the total order value
    SELECT p.cena INTO v_cena_produktu FROM produkt p WHERE p.nr_produktu = :OLD.nr_produktu;
    SELECT z.kod_rabatowy INTO v_kod_rabatowy FROM zamowienie z WHERE z.nr_zamowienia = :OLD.nr_zamowienia;

    IF v_kod_rabatowy IS NULL THEN
        v_line_cost := :OLD.ilosc * v_cena_produktu;
    ELSE
        BEGIN
            SELECT pr.nr_promocji, pr.rabat_procentowy, pr.data_zakonczenia
            INTO v_nr_promocji, v_rabat_procentowy, v_data_zakonczenia
            FROM promocja pr
            WHERE pr.kod_rabatowy = v_kod_rabatowy;
            
            IF v_data_zakonczenia > SYSDATE THEN
                SELECT COUNT(*) INTO v_count_promocja
                FROM pozycja_promocji pp
                WHERE pp.nr_promocji = v_nr_promocji AND pp.nr_produktu = :OLD.nr_produktu;

                IF v_count_promocja > 0 THEN
                    v_line_cost := :OLD.ilosc * v_cena_produktu * (1 - v_rabat_procentowy / 100);
                ELSE
                    v_line_cost := :OLD.ilosc * v_cena_produktu;
                END IF;
            ELSE
                v_line_cost := :OLD.ilosc * v_cena_produktu;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_line_cost := :OLD.ilosc * v_cena_produktu;
        END;
    END IF;

    -- Update the total order value
    UPDATE zamowienie
    SET wartosc_zamowienia = wartosc_zamowienia - v_line_cost
    WHERE nr_zamowienia = :OLD.nr_zamowienia;

    -- Return the products to the first warehouse (for simplicity)
    UPDATE stan_magazynowy
    SET liczba = liczba + :OLD.ilosc
    WHERE nr_magazynu = 1 AND nr_produktu = :OLD.nr_produktu;
END;
/


-- Trigger to handle updates to order items
CREATE OR REPLACE TRIGGER update_on_update_in_zamowienie
BEFORE UPDATE ON pozycja_zamowienia
FOR EACH ROW
DECLARE
    v_ilosc_old        NUMBER(4);
    v_ilosc_new        NUMBER(4);
    v_cena_produktu    NUMBER(5);
    v_kod_rabatowy     VARCHAR2(20);
    v_nr_promocji      NUMBER(5);
    v_rabat_procentowy NUMBER(2);
    v_data_zakonczenia DATE;
    v_count_promocja   NUMBER;
    v_line_cost_old    NUMBER(10,2);
    v_line_cost_new    NUMBER(10,2);
    v_suma_stan        NUMBER;
    v_roznica_ilosci   NUMBER;
    v_left_to_sub      NUMBER;
BEGIN
    v_ilosc_old := :OLD.ilosc;
    v_ilosc_new := :NEW.ilosc;
    v_roznica_ilosci := v_ilosc_new - v_ilosc_old;

    SELECT cena INTO v_cena_produktu FROM produkt WHERE nr_produktu = :NEW.nr_produktu;
    
    BEGIN
        SELECT z.kod_rabatowy INTO v_kod_rabatowy FROM zamowienie z WHERE z.nr_zamowienia = :NEW.nr_zamowienia;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_kod_rabatowy := NULL;
    END;

    -- Re-usable logic block to calculate line cost
    DECLARE
        p_ilosc NUMBER := 0;
        p_line_cost NUMBER;
    BEGIN
        -- Calculate old cost
        p_ilosc := v_ilosc_old;
        IF v_kod_rabatowy IS NOT NULL THEN
            BEGIN
                SELECT pr.nr_promocji, pr.rabat_procentowy, pr.data_zakonczenia INTO v_nr_promocji, v_rabat_procentowy, v_data_zakonczenia FROM promocja pr WHERE pr.kod_rabatowy = v_kod_rabatowy;
                IF v_data_zakonczenia > SYSDATE THEN
                    SELECT COUNT(*) INTO v_count_promocja FROM pozycja_promocji pp WHERE pp.nr_promocji = v_nr_promocji AND pp.nr_produktu = :OLD.nr_produktu;
                    IF v_count_promocja > 0 THEN p_line_cost := p_ilosc * v_cena_produktu * (1 - v_rabat_procentowy/100); ELSE p_line_cost := p_ilosc * v_cena_produktu; END IF;
                ELSE p_line_cost := p_ilosc * v_cena_produktu; END IF;
            EXCEPTION WHEN NO_DATA_FOUND THEN p_line_cost := p_ilosc * v_cena_produktu; END;
        ELSE p_line_cost := p_ilosc * v_cena_produktu; END IF;
        v_line_cost_old := p_line_cost;

        -- Calculate new cost
        p_ilosc := v_ilosc_new;
        IF v_kod_rabatowy IS NOT NULL THEN
            BEGIN
                SELECT pr.nr_promocji, pr.rabat_procentowy, pr.data_zakonczenia INTO v_nr_promocji, v_rabat_procentowy, v_data_zakonczenia FROM promocja pr WHERE pr.kod_rabatowy = v_kod_rabatowy;
                IF v_data_zakonczenia > SYSDATE THEN
                    SELECT COUNT(*) INTO v_count_promocja FROM pozycja_promocji pp WHERE pp.nr_promocji = v_nr_promocji AND pp.nr_produktu = :NEW.nr_produktu;
                    IF v_count_promocja > 0 THEN p_line_cost := p_ilosc * v_cena_produktu * (1 - v_rabat_procentowy/100); ELSE p_line_cost := p_ilosc * v_cena_produktu; END IF;
                ELSE p_line_cost := p_ilosc * v_cena_produktu; END IF;
            EXCEPTION WHEN NO_DATA_FOUND THEN p_line_cost := p_ilosc * v_cena_produktu; END;
        ELSE p_line_cost := p_ilosc * v_cena_produktu; END IF;
        v_line_cost_new := p_line_cost;
    END;

    IF v_roznica_ilosci > 0 THEN -- If quantity increased, subtract from stock
        SELECT NVL(SUM(liczba), 0) INTO v_suma_stan FROM stan_magazynowy WHERE nr_produktu = :NEW.nr_produktu;
        IF v_suma_stan < v_roznica_ilosci THEN
            RAISE_APPLICATION_ERROR(-20011, 'Not enough stock for product (' || :NEW.nr_produktu || ') to increase quantity.');
        END IF;

        v_left_to_sub := v_roznica_ilosci;
        FOR rec IN (SELECT nr_magazynu, liczba FROM stan_magazynowy WHERE nr_produktu = :NEW.nr_produktu AND liczba > 0 ORDER BY nr_magazynu) LOOP
            EXIT WHEN v_left_to_sub = 0;
            IF rec.liczba >= v_left_to_sub THEN
                UPDATE stan_magazynowy SET liczba = liczba - v_left_to_sub WHERE nr_magazynu = rec.nr_magazynu AND nr_produktu = :NEW.nr_produktu;
                v_left_to_sub := 0;
            ELSE
                v_left_to_sub := v_left_to_sub - rec.liczba;
                UPDATE stan_magazynowy SET liczba = 0 WHERE nr_magazynu = rec.nr_magazynu AND nr_produktu = :NEW.nr_produktu;
            END IF;
        END LOOP;
    ELSIF v_roznica_ilosci < 0 THEN -- If quantity decreased, return stock to warehouse 1
        UPDATE stan_magazynowy
        SET liczba = liczba + (-v_roznica_ilosci)
        WHERE nr_magazynu = 1 AND nr_produktu = :NEW.nr_produktu;
    END IF;

    -- Update the total order value with the difference
    UPDATE zamowienie
    SET wartosc_zamowienia = wartosc_zamowienia + (v_line_cost_new - v_line_cost_old)
    WHERE nr_zamowienia = :NEW.nr_zamowienia;
END;
/


-- Procedure to handle incoming product deliveries
CREATE OR REPLACE PROCEDURE przyjmij_dostawe(
    p_nr_produktu IN stan_magazynowy.nr_produktu%TYPE,
    p_nr_magazynu IN stan_magazynowy.nr_magazynu%TYPE,
    p_ilosc IN NUMBER
)
IS
    v_updated_rows NUMBER := 0;
BEGIN
    -- Try to update the stock for an existing product-warehouse combination
    UPDATE stan_magazynowy
    SET liczba = liczba + p_ilosc
    WHERE nr_produktu = p_nr_produktu AND nr_magazynu = p_nr_magazynu;
    v_updated_rows := SQL%ROWCOUNT;

    -- If no row was updated, it means this is a new product for this warehouse
    IF v_updated_rows = 0 THEN
        INSERT INTO stan_magazynowy (nr_magazynu, nr_produktu, liczba)
        VALUES (p_nr_magazynu, p_nr_produktu, p_ilosc);
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Error during delivery processing: ' || SQLERRM);
END;
/
