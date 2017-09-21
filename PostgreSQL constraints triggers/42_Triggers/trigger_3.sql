CREATE FUNCTION function3() RETURNS TRIGGER AS $function3$
  DECLARE
    quantity integer;
  BEGIN
    SELECT COUNT (o_orderstatus)
    INTO quantity
    FROM orders
    WHERE o_custkey = NEW.o_custkey AND o_orderstatus = 'O';
    IF (quantity > 14) THEN
        RAISE EXCEPTION 'the customer reaches maximum orders';
    END IF;
    RETURN NEW;
  END;
$function3$ LANGUAGE plpgsql;

CREATE TRIGGER trigger3
AFTER INSERT OR UPDATE ON orders
    FOR EACH ROW EXECUTE PROCEDURE function3();