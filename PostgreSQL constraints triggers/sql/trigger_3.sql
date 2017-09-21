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


-- check.
INSERT INTO orders VALUES
(99098, 112, 'O', 99.00, NOW(), '5-LOW', 'Clerk#99', 0, 'IWillPass');

INSERT INTO orders VALUES
(99099, 112, 'F', 99.00, NOW(), '5-LOW', 'Clerk#99', 0, 'IWillPass');

INSERT INTO orders VALUES
(99100, 112, 'O', 99.00, NOW(), '5-LOW', 'Clerk#99', 0, 'IWillPass');

-- clear
drop trigger trigger3 on orders;
drop function function3();

SELECT COUNT (o_orderstatus)
FROM orders
WHERE o_custkey = 112 AND o_orderstatus = 'O';
