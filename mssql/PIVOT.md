# MSSQL PIVOT
1. 範例
    ```sql
    --建立假資料
    CREATE TABLE Grades(
        [Student] VARCHAR(50),
        [Subject] VARCHAR(50),
        [Marks] INT
    )
    GO
    INSERT INTO
        Grades
    VALUES
        ('Jacob', 'Mathematics', 100),
        ('Jacob', 'Science', 95),
        ('Jacob', 'Geography', 90),
        ('Amilee', 'Mathematics', 90),
        ('Amilee', 'Science', 90),
        ('Amilee', 'Geography', 100)
    GO
    ```
2. templet
    ```sql
    -- 欄代表用source的某欄位取DISTINCT
    -- SELECT
    --     <<列>>,
    --     欄值1別名 = <<欄值1>>,
    --     欄值2別名 = <<欄值2>>,
    --     欄值n別名 = <<欄值n>>,
    -- FROM
    --     (
    --         <<原始表>>
    --     ) AS TMP_TABLE PIVOT (
    --         <<值的計算方法、COUNT、SUM、MAX...>>
    --         FOR <<欄>> IN([<<欄值1>>], [<<欄值2>>], [<<欄值n>>])
    --     ) AS PIVOT_TABLE
    ```
3. 計算科目分數總合
    ```sql
    SELECT
        Student,                                                    -- row
        Mathematics_count = [Mathematics],                          -- col1
        Science_count = [Science],                                  -- col2
        Geography_count = [Geography]                               -- col3
    FROM
        (
            select
                *
            from
                Grades                                              -- source
        ) AS TMP_TABLE PIVOT (
            SUM(Marks)                                              -- value
            FOR Subject IN([Mathematics], [Science], [Geography])   -- col,col1-3
        ) AS PIVOT_TABLE
    ```
* ref
    https://coolmandiary.blogspot.com/2021/08/t-sql22pivot-select.html