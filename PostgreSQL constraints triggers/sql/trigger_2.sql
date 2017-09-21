CREATE FUNCTION function2() RETURNS TRIGGER AS $function2$
  BEGIN
    UPDATE partsupp
    SET ps_supplycost = ps_supplycost + NEW.p_retailprice - OLD.p_retailprice
    WHERE ps_partkey = NEW.p_partkey;
    RETURN NEW;
  END;
$function2$ LANGUAGE plpgsql;

CREATE TRIGGER trigger2
BEFORE UPDATE ON part
    FOR EACH ROW EXECUTE PROCEDURE function2();


-- check.
SELECT ps_partkey, ps_supplycost FROM partsupp WHERE ps_partkey = 1;

UPDATE part
SET p_retailprice = p_retailprice * 1.1
WHERE p_partkey = 1;

-- clear
drop trigger trigger2 on part;
drop function function2();
