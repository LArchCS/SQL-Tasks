
CREATE FUNCTION function7() RETURNS TRIGGER AS $function7$
  DECLARE
    oldRegion integer;
    newRegion integer;
    rate decimal;
  BEGIN
    rate = 1.0;
    -- update region key
    SELECT n_regionkey
    INTO oldRegion
    FROM nation
    WHERE n_nationkey = OLD.s_nationkey;
    SELECT n_regionkey
    INTO newRegion
    FROM nation
    WHERE n_nationkey = NEW.s_nationkey;
    -- case by case
    -- America: 1 _ Asia: 2 _ Europe: 3
    IF (oldRegion = 1 AND newRegion = 2) THEN
      rate = 0.8;
    ELSIF (oldRegion = 1 AND newRegion = 3) THEN
      rate = 1.05;
    ELSIF (oldRegion = 2 AND newRegion = 1) THEN
      rate = 1.2;
    ELSIF (oldRegion = 2 AND newRegion = 3) THEN
      rate = 1.1;
    ELSIF (oldRegion = 3 AND newRegion = 1) THEN
      rate = 0.95;
    ELSIF (oldRegion = 3 AND newRegion = 2) THEN
      rate = 0.9;
    END IF;
    IF (oldRegion <> newRegion) THEN
      UPDATE partsupp
      SET ps_supplycost = ps_supplycost * rate
      WHERE ps_suppkey = NEW.s_suppkey;
    END IF;
    RETURN NEW;
  END;
$function7$ LANGUAGE plpgsql;

CREATE TRIGGER trigger7
AFTER UPDATE ON supplier
    FOR EACH ROW EXECUTE PROCEDURE function7();


-- check
SELECT SUM(ps_supplycost) FROM partsupp WHERE ps_suppkey = 1;

UPDATE supplier SET s_nationkey = 6 WHERE s_suppkey = 1;

UPDATE supplier SET s_nationkey = 1 WHERE s_suppkey = 1;

SELECT n_regionkey
FROM nation
WHERE n_nationkey = NEW.s_nationkey;

-- clear
drop trigger trigger7 on supplier;
drop function function7();
