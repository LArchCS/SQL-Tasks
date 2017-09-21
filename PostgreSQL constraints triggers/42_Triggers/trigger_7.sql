CREATE FUNCTION function7() RETURNS TRIGGER AS $function7$
  DECLARE
    oldRegion integer;
    newRegion integer;
  BEGIN
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
      UPDATE partsupp
      SET ps_supplycost = ps_supplycost * 0.8
      WHERE ps_suppkey = NEW.s_suppkey;
    ELSIF (oldRegion = 1 AND newRegion = 3) THEN
      UPDATE partsupp
      SET ps_supplycost = ps_supplycost * 1.05
      WHERE ps_suppkey = NEW.s_suppkey;
    ELSIF (oldRegion = 2 AND newRegion = 1) THEN
      UPDATE partsupp
      SET ps_supplycost = ps_supplycost * 1.2
      WHERE ps_suppkey = NEW.s_suppkey;
    ELSIF (oldRegion = 2 AND newRegion = 3) THEN
      UPDATE partsupp
      SET ps_supplycost = ps_supplycost * 1.1
      WHERE ps_suppkey = NEW.s_suppkey;
    ELSIF (oldRegion = 3 AND newRegion = 1) THEN
      UPDATE partsupp
      SET ps_supplycost = ps_supplycost * 0.95
      WHERE ps_suppkey = NEW.s_suppkey;
    ELSIF (oldRegion = 3 AND newRegion = 2) THEN
      UPDATE partsupp
      SET ps_supplycost = ps_supplycost * 0.9
      WHERE ps_suppkey = NEW.s_suppkey;
    END IF;
    RETURN NEW;
  END;
$function7$ LANGUAGE plpgsql;

CREATE TRIGGER trigger7
AFTER UPDATE ON supplier
    FOR EACH ROW EXECUTE PROCEDURE function7();