CREATE OR REPLACE FUNCTION nationkey_before() RETURNS TRIGGER AS $nationkey_before$
  BEGIN
    ALTER TABLE Customer DROP CONSTRAINT fk1;
    ALTER TABLE Supplier DROP CONSTRAINT fk1;
    RETURN NULL;
  END;
$nationkey_before$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION nationkey_after() RETURNS TRIGGER AS $nationkey_after$
  BEGIN
    -- update key in Customer and Supplier
    UPDATE Customer
    SET c_nationkey = NEW.n_nationkey
    WHERE c_nationkey = OLD.n_nationkey;
    UPDATE Supplier
    SET s_nationkey = NEW.n_nationkey
    WHERE s_nationkey = OLD.n_nationke;
    -- enable fk1 in Customer and Supplier
    ALTER TABLE Customer
    ADD CONSTRAINT fk1 FOREIGN KEY (c_nationkey) REFERENCES Nation (n_nationkey);
    ALTER TABLE Supplier
    ADD CONSTRAINT fk1 FOREIGN KEY (s_nationkey) REFERENCES Nation (n_nationkey);
    RETURN NULL;
  END;
$nationkey_after$ LANGUAGE plpgsql;

CREATE TRIGGER updateNationkey_before
BEFORE UPDATE ON Nation 
    FOR EACH STATEMENT EXECUTE PROCEDURE nationkey_before();

CREATE TRIGGER updateNationkey_after
AFTER UPDATE ON Nation
    FOR EACH STATEMENT EXECUTE PROCEDURE nationkey_after();


-- check.  24
SELECT c_custkey, c_nationkey
FROM customer
WHERE c_nationkey = 99;

UPDATE nation
SET n_nationkey = 99
WHERE n_name = 'UNITED STATES';    

UPDATE nation
SET n_nationkey = 99
WHERE n_nationkey = 99; 

SELECT *
FROM nation
WHERE n_name = 'UNITED STATES';

-- Çå³ý
drop trigger updateNationkey on nation;
drop trigger updateNationkey_before on nation;
drop trigger updateNationkey_after on nation;
drop function nationkey();
drop function nationkey_before();
drop function nationkey_after();

--- À¦°óÔÚÒ»ÆðÊÔÊÔ
CREATE OR REPLACE FUNCTION nationkey() RETURNS TRIGGER AS $nationkey$
  BEGIN
    ALTER TABLE Customer DROP CONSTRAINT fk1;
    ALTER TABLE Supplier DROP CONSTRAINT fk1;

    -- update key in Customer and Supplier
    UPDATE Customer
    SET c_nationkey = NEW.n_nationkey
    WHERE c_nationkey = OLD.n_nationkey;

    UPDATE Supplier
    SET s_nationkey = NEW.n_nationkey
    WHERE s_nationkey = OLD.n_nationke;

    UPDATE Nation
    SET n_nationkey = NEW.n_nationkey
    WHERE n_nationkey = OLD.n_nationke;

    -- enable fk1 in Customer and Supplier
    ALTER TABLE Customer
    ADD CONSTRAINT fk1 FOREIGN KEY (c_nationkey) REFERENCES Nation (n_nationkey);

    ALTER TABLE Supplier
    ADD CONSTRAINT fk1 FOREIGN KEY (s_nationkey) REFERENCES Nation (n_nationkey);
    RETURN NULL;

  END;
$nationkey$ LANGUAGE plpgsql;

CREATE TRIGGER updateNationkey
BEFORE UPDATE ON Nation 
    FOR EACH STATEMENT EXECUTE PROCEDURE nationkey();



