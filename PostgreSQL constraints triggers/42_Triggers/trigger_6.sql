ALTER TABLE nation
DROP CONSTRAINT fk1;

ALTER TABLE nation
ADD CONSTRAINT fk1 FOREIGN KEY (n_regionkey) REFERENCES Region (r_regionkey) ON DELETE CASCADE;


ALTER TABLE supplier
DROP CONSTRAINT fk1;

ALTER TABLE supplier
ADD CONSTRAINT fk1 FOREIGN KEY (s_nationkey) REFERENCES Nation (n_nationkey) ON DELETE CASCADE;


ALTER TABLE partsupp
DROP CONSTRAINT fk1;

ALTER TABLE partsupp
ADD CONSTRAINT fk1 FOREIGN KEY (ps_suppkey) REFERENCES Supplier (s_suppkey) ON DELETE CASCADE;


ALTER TABLE customer
DROP CONSTRAINT fk1;

ALTER TABLE Customer
ADD CONSTRAINT fk1 FOREIGN KEY (c_nationkey) REFERENCES Nation (n_nationkey) ON DELETE SET NULL;


ALTER TABLE lineitem
DROP CONSTRAINT fk1;

ALTER TABLE Lineitem
ADD CONSTRAINT fk1 FOREIGN KEY (l_partkey,l_suppkey) REFERENCES Partsupp (ps_partkey, ps_suppkey) ON DELETE SET NULL;