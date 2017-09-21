-- Primary Keys.

ALTER TABLE Customer
ADD PRIMARY KEY (c_custkey);

ALTER TABLE Lineitem
ADD PRIMARY KEY (l_orderkey, l_linenumber);

ALTER TABLE Nation
ADD PRIMARY KEY (n_nationkey);

ALTER TABLE Orders
ADD PRIMARY KEY (o_orderkey);

ALTER TABLE Part
ADD PRIMARY KEY (p_partkey);

ALTER TABLE Partsupp
ADD PRIMARY KEY (ps_partkey, ps_suppkey);

ALTER TABLE Region
ADD PRIMARY KEY (r_regionkey);

ALTER TABLE Supplier
ADD PRIMARY KEY (s_suppkey);


-- Foreign Keys.

ALTER TABLE Customer
ADD CONSTRAINT fk1 FOREIGN KEY (c_nationkey) REFERENCES Nation (n_nationkey);

ALTER TABLE Lineitem
ADD CONSTRAINT fk1 FOREIGN KEY (l_partkey,l_suppkey) REFERENCES Partsupp (ps_partkey, ps_suppkey),
ADD CONSTRAINT fk2 FOREIGN KEY (l_orderkey) REFERENCES Orders (o_orderkey);

ALTER TABLE Nation
ADD CONSTRAINT fk1 FOREIGN KEY (n_regionkey) REFERENCES Region (r_regionkey);

ALTER TABLE Orders
ADD CONSTRAINT fk1 FOREIGN KEY (o_custkey) REFERENCES Customer (c_custkey);

ALTER TABLE Partsupp
ADD CONSTRAINT fk1 FOREIGN KEY (ps_suppkey) REFERENCES Supplier (s_suppkey),
ADD CONSTRAINT fk2 FOREIGN KEY (ps_partkey) REFERENCES Part (p_partkey);

ALTER TABLE Supplier
ADD CONSTRAINT fk1 FOREIGN KEY (s_nationkey) REFERENCES Nation (n_nationkey);

