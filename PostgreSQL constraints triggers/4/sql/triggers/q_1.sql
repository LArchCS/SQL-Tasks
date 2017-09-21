ALTER TABLE Customer DROP CONSTRAINT fk1;
ALTER TABLE Customer ADD CONSTRAINT fk1 FOREIGN KEY (c_nationkey) REFERENCES Nation (n_nationkey) ON UPDATE CASCADE;

ALTER TABLE Supplier DROP CONSTRAINT fk1;
ALTER TABLE Supplier ADD CONSTRAINT fk1 FOREIGN KEY (s_nationkey) REFERENCES Nation (n_nationkey) ON UPDATE CASCADE;
