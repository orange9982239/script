-- 1. 使用id分組，並編號
-- 2. 透過WHERE過濾Sort，達到留第n名
SELECT
    parent,
    child
FROM
    (
        SELECT
            parent_id,
            parent,
            child_id,
            child,
            childSort = ROW_NUMBER() Over (         -- 產編號
                PARTITION By parent_id              -- 使用parent_id分組
                ORDER BY child_id                   -- 組內用child_id排序
            ) 
        FROM
            parent_child
    ) AS parent_child_with_rownumber
WHERE
    parent_child_with_rownumber.childSort = 2       -- 僅保留組內排名第2