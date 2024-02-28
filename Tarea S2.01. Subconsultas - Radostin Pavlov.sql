# NIVEL 1

-- Ejercicio 1: Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT 
    country, transaction.*
FROM
    transaction
        JOIN
    company ON company.id = transaction.company_id
WHERE
    country = 'Germany';


-- Ejercicio 2: Listado de las empresas que han realizado transacciones por una suma superior a la media de todas las transacciones.
-- (Para mayor claridad he incluido en la tabla la suma de ventas por compañia y el promedio de todas las compañias)
SELECT 
    company_name AS Compañía,
    SUM(amount) AS 'Suma por compañia',
    (SELECT 
            Round(AVG(amount),2)
        FROM
            transaction) AS 'Promedio global'
FROM
    transaction
        JOIN
    company ON company.id = transaction.company_id
GROUP BY company_name
HAVING SUM(amount) > (SELECT 
        Round(AVG(amount),2)
    FROM
        transaction)
ORDER BY `Suma por compañia` DESC;


-- Ejercicio 3: El departamento de contabilidad perdió la información de las transacciones 
-- realizadas por una empresa, pero no recuerdan su nombre, sólo recuerdan que su nombre 
-- empezaba por la letra c. ¿Cómo puedes ayudarles? Coméntelo acompañándolo de la información de las transacciones.

SELECT 
    company_name AS Compañía, transaction.*
FROM
    company
        LEFT JOIN
    transaction ON company.id = transaction.company_id
WHERE
    company_name LIKE 'C%';


-- Ejercicio 4: Van a eliminar del sistema a las empresas que no tienen transacciones registradas, entrega el listado de estas empresas.

SELECT id, company_name as Compañía
FROM company
WHERE NOT EXISTS (
    SELECT *
    FROM transaction
    WHERE company.id = transaction.company_id
);


# NIVEL 2 
-- Ejercicio 1: En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía Non Institute. 
-- Para ello, te piden la lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.

SELECT 
    company_name as Compañía, country as País, transaction.*
FROM
    company
        JOIN
    transaction ON transaction.company_id = company.id
WHERE
    country = (SELECT 
            country AS País
        FROM
            company
        WHERE
            company_name = 'Non Institute');



-- Ejercicio 2: El departamento de contabilidad necesita que encuentres a la empresa 
-- que ha realizado la transacción de mayor suma en la base de datos.

SELECT 
    company_name as 'Compañía mayor gasto', amount as Gasto
FROM
    company
        JOIN
    transaction ON company.id = transaction.company_id
WHERE
    amount = (SELECT 
            MAX(amount)
        FROM
            transaction);


# NIVEL 3
-- Ejercicio 1: Listado de los países cuya media de transacciones sea superior a la media general.
SELECT 
    country,
    ROUND(AVG(amount), 2) AS Promedio,
    (SELECT 
            ROUND(AVG(amount), 2)
        FROM
            transaction) AS 'Promedio global'
FROM
    transaction
        JOIN
    company ON company.id = transaction.company_id
GROUP BY country
HAVING AVG(amount) > (SELECT 
        ROUND(AVG(amount), 2)
    FROM
        transaction)
ORDER BY Promedio DESC;



-- Ejercicio 2: Listado de las empresas donde 
-- especifiques si tienen más de 4 transacciones o menos.
SELECT 
    company_name AS Compañía,
    COUNT(transaction.id) AS Transacciones,
    CASE
        WHEN COUNT(transaction.id) > 4 THEN '>4'
        WHEN COUNT(transaction.id) < 4 THEN '<4'
        ELSE '=4'
    END AS 'Más o menos de 4 transacciones'
FROM
    company
        JOIN
    transaction ON company.id = transaction.company_id
GROUP BY Compañía
ORDER BY Transacciones DESC;

