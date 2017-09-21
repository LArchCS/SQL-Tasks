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

-- check.
SELECT o_orderkey, o_orderstatus
FROM orders
WHERE o_orderkey = 7;

INSERT INTO LINEITEM
VALUES (7, 1, 2, 8, 1, 99.00, 0.00, 0.05, 'N', 'F', NOW(), NOW(), NOW(), 'NONE', 'MAIL', 'No Comment');

SELECT o_orderkey, o_orderstatus
FROM orders
WHERE o_orderkey = 3;

INSERT INTO LINEITEM
VALUES (3, 1, 2, 24, 1, 99.00, 0.00, 0.05, 'N', 'F', NOW(), NOW(), NOW(), 'NONE', 'MAIL', 'No Comment');

SELECT l_orderkey, l_linestatus, l_linenumber
FROM lineitem
WHERE l_orderkey = 3;

-- clear
drop trigger trigger5 on lineitem;
drop function function5();


SELECT COUNT (DISTINCT l_linestatus)
FROM lineitem
WHERE l_orderkey = 3;
