--  MS SQL, используется БД  Library , schema analyst
-- books - Произведения
-- editions - Издания
-- issues - Экземпляры
-- operations_log - Лог операций

-- #1 Найти произведения, которые издавались более 5 раз.

USE Library;

SELECT name
FROM analyst.books AS b
    LEFT JOIN analyst.editions AS e
        ON e.id_book = b.id
GROUP BY name
HAVING count(e.year) > 5;

-- #2 Проверить, есть ли экземпляры, не привязанные к ни к одному изданию.
-- Стоит отметить, что
-- Проверка этого условия должна реализовываться d БД с помощью внешних ключей и выполнением требования ссылочной целостности.
-- Если БД находится в 3 нормальной форме, как указано в условии задачи
-- и идшник издания в таблице экземпляров не соотносится ни с одним идшником в таблице изданий
-- (внешний ключ фактически пустой), то это указывает на ошибку проектирования БД.
-- Проверка реализована без вложенного запроса или обобщенного табличного выражения Common Table Expression (CTE)

SELECT i.id_edition
FROM analyst.issues AS i
EXCEPT
SELECT e.id
FROM analyst.editions AS e;


-- #3 Для каждого пользователя найти последние три взятые им произведения. Для
-- каждого такого произведения указать сколько всего раз ее брали (за все время).

DROP TABLE IF EXISTS #temp4;
CREATE TABLE #temp4(
    id_user INT
    , id_issue INT
    , rank INT
);
INSERT INTO #temp4(
    id_user
    , id_issue
    , rank
)
SELECT
    ol.id_user
     , ol.id_issue
     , ROW_NUMBER() over (PARTITION BY ol.id_user ORDER BY ol.date_take DESC) as Rank
FROM analyst.operations_log AS ol;

DROP TABLE IF EXISTS #temp5;
CREATE TABLE #temp5(
    id_issue INT
    , times_taken INT
);
INSERT INTO #temp5(
    id_issue
    , times_taken
)
SELECT
    ol.id_issue
    , COUNT(ol.id) as times_taken
FROM analyst.operations_log AS ol
GROUP BY ol.id_issue
;

SELECT t4.id_user, b.name, t5.times_taken
FROM #temp4 as t4
    LEFT JOIN #temp5 t5 ON t4.id_issue = t5.id_issue
    LEFT JOIN analyst.issues i ON i.id = t5.id_issue
    LEFT JOIN analyst.editions e ON e.id = i.id_edition
    LEFT JOIN analyst.books b ON b.id = e.id_book
WHERE t4.rank <= 3;

