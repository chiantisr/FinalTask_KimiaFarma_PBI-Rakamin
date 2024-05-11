-- Membuat Tabel Analisis
CREATE TABLE kimia_farma.tabel_analisa AS (
    WITH mandatory_table AS (
        SELECT
            ft.transaction_id,
            ft.date,
            ft.branch_id,
            kc.branch_name,
            kc.kota,
            kc.provinsi,
            kc.rating AS rating_cabang,
            ft.customer_name,
            ft.product_id,
            pr.product_name,
            pr.price AS actual_price,
            ft.discount_percentage,
            -- Menghitung persentase laba
            CASE
                WHEN pr.price <= 50000 THEN 0.10
                WHEN pr.price <= 100000 THEN 0.15
                WHEN pr.price <= 300000 THEN 0.20
                WHEN pr.price <= 500000 THEN 0.25
                ELSE 0.30
            END AS persentase_gross_laba,
            -- Menghitung harga setelah diskon
            (pr.price - (pr.price * ft.discount_percentage)) AS nett_sales,
            -- Menghitung keuntungan yang diperoleh
            (pr.price * (1 - ft.discount_percentage)) * 
            CASE
                WHEN pr.price <= 50000 THEN 0.10
                WHEN pr.price <= 100000 THEN 0.15
                WHEN pr.price <= 300000 THEN 0.20
                WHEN pr.price <= 500000 THEN 0.25
                ELSE 0.30
            END AS nett_profit,
            ft.rating AS rating_transaksi
        FROM
            kimia_farma.final_transaction ft
        JOIN
            kimia_farma.kantor_cabang kc ON ft.branch_id = kc.branch_id
        JOIN
            kimia_farma.product pr ON ft.product_id = pr.product_id
    )
    SELECT *
    FROM mandatory_table
);

SELECT * 
FROM kimia_farma.tabel_analisa;
