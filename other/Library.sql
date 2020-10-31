--  MS SQL, используется БД  Library , schema analyst
-- books - Произведения
-- editions - Издания
-- issues - Экземпляры
-- operations_log - Лог операций

-- #1 Найти произведения, которые издавались более 5 раз.
--
-- Решение.

USE Library;

SELECT name
FROM analyst.books AS b
    LEFT JOIN analyst.editions AS e
        ON e.id_book = b.id
GROUP BY name
HAVING count(e.year) > 5;

-- #2 Проверить, есть ли экземпляры, не привязанные к ни к одному изданию.
--
-- В решении используется оператор EXCEPT.
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
--
-- В решении используются временные таблицы и оконная функция ROW_NUMBER. Вложенный запрос или СТЕ выглядят здесь
-- логичным (и часто используемым средством решения такого типа задач), но по условию задачи они не использованы.


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
FROM #temp4 AS t4
    LEFT JOIN #temp5 AS t5 ON t4.id_issue = t5.id_issue
    LEFT JOIN analyst.issues AS i ON i.id = t5.id_issue
    LEFT JOIN analyst.editions AS e ON e.id = i.id_edition
    LEFT JOIN analyst.books AS b ON b.id = e.id_book
WHERE t4.rank <= 3;

-- #4 Найти список самых неблагонадежных пользователей библиотеки – рейтинг 10 самых-
-- самых плохих пользователей по двум или более критериям. Критерии неблагонадежности, с точки зрения бизнеса, предложите самостоятельно.
--
-- Решение. Предлагаются 2 критерия: 1) Чтение книги больше разрешенного, в данном слуае - это 14 дней. 2) Взятие очередной книги раньше
-- сдачи предыдущей. Пока читателю вычисляется количество строк соответствующих первому ИЛИ второму критерию. Если какая-то строка
-- подпадает под оба условия, в штрафной показатель она зачитывается дважды. Далее читатели ранжируются по сумме таких строк
-- по убыванию и берутся топ-10 читателей. В решении используются временная таблица и оконная функция LAG. Вложенный запрос или СТЕ выглядят здесь
-- -- логичным (и часто используемым средством решения такого типа задач), но по условию задачи они не использованы.

DROP TABLE IF EXISTS #temp7;
CREATE TABLE #temp7(
    id_user INT
    , id_issue INT
    , days_taken_earlier_than_return_prev INT
    , days_holding INT
);
INSERT INTO #temp7(
    id_user
    , id_issue
    , days_taken_earlier_than_return_prev
    , days_holding
)
select
    ol.id_user
    , ol.id_issue
    , DATEDIFF(dd, LAG(ol.date_return) over (PARTITION BY ol.id_user ORDER BY ol.date_return), ol.date_take)
    , DATEDIFF(dd, ol.date_take, ol.date_return)
FROM analyst.operations_log AS ol;

DECLARE @term_of_reading INT;
SET @term_of_reading = 10;

SELECT TOP(10)
    t7.id_user
    , COUNT(t7.id_issue) AS penalty_score
FROM #temp7 as t7
WHERE t7.days_taken_earlier_than_return_prev < 0
    OR t7.days_holding >  @term_of_reading
GROUP BY t7.id_user
ORDER BY penalty_score DESC
;

-----