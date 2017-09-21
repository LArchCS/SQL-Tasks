CREATE FUNCTION function5() RETURNS TRIGGER AS $function5$
  DECLARE
    quantity integer;
    status character(1);
  BEGIN
    SELECT COUNT (DISTINCT l_linestatus)
    INTO quantity
    FROM lineitem
    WHERE l_orderkey = NEW.l_orderkey;
    IF (quantity > 1) THEN
      UPDATE orders
      SET o_orderstatus = 'P'
      WHERE o_orderkey = NEW.l_orderkey;
    ELSIF (quantity = 1) THEN
      SELECT DISTINCT l_linestatus
      INTO status
      FROM lineitem
      WHERE l_orderkey = NEW.l_orderkey;
      UPDATE orders
      SET o_orderstatus = status
      WHERE o_orderkey = NEW.l_orderkey;
    END IF;
    RETURN NEW;
  END;
$function5$ LANGUAGE plpgsql;

CREATE TRIGGER trigger5
AFTER INSERT OR UPDATE ON lineitem
    FOR EACH ROW EXECUTE PROCEDURE function5();