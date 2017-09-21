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