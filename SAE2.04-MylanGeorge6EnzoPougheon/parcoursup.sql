DROP TABLE IF EXISTS import ;

CREATE temp TABLE import (
n1 int, n2 text, n3 text, n4 text, n5 text, n6 text, n7 text, n8 text, n9 text, n10 text, n11 text,
n12 text, n13 text, n14 text, n15 text, n16 text, n17 text, n18 int, n19 int, n20 int, n21 int,
n22 text, n23 int, n24 int, n25 int, n26 int, n27 int, n28 int,
n29 int, n30 int, n31 int, n32 int, n33 int, n34 int, n35 int,
n36 int, n37 text, n38 text, n39 int, n40 int, n41 int, n42 int,
n43 int, n44 int, n45 int, n46 int, n47 int, n48 int, n49 int,
n50 int, n51 int, n52 int, n53 int, n54 text, n55 int, n56 int,
n57 int, n58 int, n59 int, n60 int, n61 int, n62 int, n63 int,
n64 int, n65 int, n66 int, n67 int, n68 int, n69 int, n70 text,
n71 text, n72 int, n73 int, n74 float, n75 float, n76 float, n77 float,
n78 float, n79 float, n80 float, n81 float, n82 float, n83 float, n84 float,
n85 float, n86 float, n87 float, n88 float, n89 float, n90 float, n91 float,
n92 float, n93 float, n94 float, n95 float, n96 float, n97 float, n98 float,
n99 float, n100 float, n101 float, n102 text, n103 int, n104 text, n105 text,
n106 text, n107 text, n108 text, n109 text, n110 text, n111 text, n112 text, n113 int, n114 int,
n115 int, n116 int, n117 text, n118 text);

\copy import FROM 'fr-esr-parcoursup.csv' DELIMITER ';' CSV HEADER;

-- SELECT COUNT(*) FROM import;

-- SELECT COUNT(DISTINCT n3) FROM import;

-- SELECT COUNT(*) FROM import WHERE n4 LIKE '%Université de Lille%';

-- SELECT COUNT(*) FROM import WHERE n3 = '0597215X';

-- SELECT n110 FROM import WHERE n3='0597215X' AND n10='BUT - Informatique';

DROP TABLE IF EXISTS filière, candidats ,admis , propose, formation, etablissement, departement ;

create table departement(code_dept,nom_dept,region,academie) AS SELECT DISTINCT n5,n6,n7,n8 FROM import;
ALTER TABLE departement ADD PRIMARY KEY(code_dept);

create table etablissement(uai,nom,statu,commune,code_dept) AS SELECT DISTINCT n3,n4,n2,n9,n5 FROM import;
ALTER TABLE etablissement ADD PRIMARY KEY(uai);
ALTER TABLE etablissement ADD FOREIGN KEY(code_dept) REFERENCES departement(code_dept);



create table formation(cod_aff_form,session,gps,lien,concours,capacité) AS SELECT DISTINCT n110,n1,n17,n112,n111,n18 FROM import;

ALTER TABLE formation ADD PRIMARY KEY(cod_aff_form);


create table propose(uai,cod_aff_form) AS SELECT DISTINCT n3,n110 FROM import;
ALTER TABLE propose ADD PRIMARY KEY (uai,cod_aff_form);
ALTER TABLE propose ADD FOREIGN KEY (uai) REFERENCES etablissement(uai);
ALTER TABLE propose ADD FOREIGN KEY (cod_aff_form) REFERENCES formation(cod_aff_form);

create table admis(cod_aff_form,admis_total,pct_prop_ouverture,pct_prop_avant_fin,pct_brs_nb) AS SELECT DISTINCT n110,n47,n74,n76,n81 FROM import;
ALTER TABLE admis ADD FOREIGN KEY (cod_aff_form) REFERENCES formation(cod_aff_form);

create table candidats(cod_aff_form,cand_total,cand_pp,cand_pc,classes_pp,prop_total) AS SELECT DISTINCT n110,n19,n21,n30,n35,n46 FROM import;
ALTER TABLE candidats ADD FOREIGN KEY (cod_aff_form) REFERENCES formation(cod_aff_form);

create table filière(cod_aff_form,nom_filière,filière_agregee,selectivite) AS SELECT DISTINCT n110,n10,n12,n11 FROM import;
ALTER TABLE filière ADD PRIMARY KEY (nom_filière,cod_aff_form);
ALTER TABLE filière ADD FOREIGN KEY (cod_aff_form) REFERENCES formation(cod_aff_form);


--Q1

SELECT
    n56 AS admis_nb_stocke,
    n57 + n58 + n59 AS admis_nb_recalcule
FROM import;



--Q2
SELECT COUNT(*) AS nb_erreurs
FROM import
WHERE n56 IS NOT NULL
  AND n56 <> n57 + n58 + n59;


--Q3

SELECT
    n74 AS pct_ouverture_stocke,
    (n51 * 100.0 / n47) AS pct_ouverture_recalcule
FROM import
WHERE n47 IS NOT NULL AND n47 != 0;


--Q4

SELECT COUNT(*) AS nb_erreurs
FROM import
WHERE n74 IS NOT NULL
  AND n47 IS NOT NULL AND n47 != 0
  AND n74 <> (n51 * 100.0 / n47);

SELECT COUNT(*) AS nb_erreurs
FROM import
WHERE n74 IS NOT NULL
  AND n47 IS NOT NULL AND n47 <> 0
  AND ROUND(n74) <> ROUND(n51::NUMERIC / n47 * 100);


SELECT
    n74 AS pct_ouverture_stocke,
    (n51 * 100.0 / n47) AS pct_ouverture_recalcule,
    n74 - (n51 * 100.0 / n47) AS difference
FROM import
WHERE n74 IS NOT NULL
  AND n47 IS NOT NULL AND n47 != 0
  AND n74 <> (n51 * 100.0 / n47);



--Q5

  SELECT
    n76 AS pct_avant_fin_stocke,
    (n53 * 100.0 / n47) AS pct_avant_fin_recalcule
FROM import
WHERE n47 IS NOT NULL AND n47 != 0;




--Q6

SELECT
    a.pct_prop_avant_fin AS pct_avant_fin_stocke,
    (i.n53 * 100.0 / i.n47) AS pct_avant_fin_recalcule
FROM admis a
JOIN import i ON i.n110 = a.cod_aff_form
WHERE i.n47 IS NOT NULL AND i.n47 != 0;

--Q7

SELECT
    n81 AS pct_brs_nb_stocke,
    (n55 * 100.0 / n56) AS pct_brs_nb_recalcule
FROM import
WHERE n56 IS NOT NULL AND n56 != 0;

--Q8

SELECT
    a.pct_brs_nb AS pct_brs_nb_stocke,
    (i.n55 * 100.0 / i.n56) AS pct_brs_nb_recalcule
FROM admis a
JOIN import i ON i.n110 = a.cod_aff_form
WHERE i.n56 IS NOT NULL AND i.n56 != 0;