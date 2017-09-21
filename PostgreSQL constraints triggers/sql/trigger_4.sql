ALTER TABLE orders
DROP CONSTRAINT fk1;

ALTER TABLE orders
ADD CONSTRAINT fk1 FOREIGN KEY (o_custkey) REFERENCES customer (c_custkey) ON DELETE CASCADE;


ALTER TABLE Lineitem
DROP CONSTRAINT fk2;

ALTER TABLE Lineitem
ADD CONSTRAINT fk2 FOREIGN KEY (l_orderkey) REFERENCES Orders (o_orderkey) ON DELETE CASCADE;


-- check.
SELECT l_orderkey, l_linenumber
FROM lineitem
WHERE l_orderkey IN
(SELECT o_orderkey FROM orders WHERE o_custkey = 203);

DELETE FROM customer WHERE c_custkey = 203;
