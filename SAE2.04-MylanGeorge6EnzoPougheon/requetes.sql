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