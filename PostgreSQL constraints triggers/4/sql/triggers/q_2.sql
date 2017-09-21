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