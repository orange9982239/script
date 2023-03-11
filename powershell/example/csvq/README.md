# csvq
> 可以用SQL對CSV檔案進行CRUD的優質工具，包含查詢便建立檔案或接收API資料寫入CSV
## 準備
- [ ] 下載包 
    * https://github.com/mithrandie/csvq/releases/tag/v1.17.11
- [ ] 解壓縮包到隨意路徑
    * EX`"C:\csvq-v1.17.11-windows-amd64"`
- [ ] env path
   * 加入windows env path
        > 認真地加入env path，永絕後患~
   * 臨時env path
        > 暫時加入本次powershell session，雖然方便，但關了powershell以後又要重執行一次
        ```ps
        $env:Path += ";C:\csvq-v1.17.11-windows-amd64"
        ```


## 範例
> * PS預設啟動路徑是`C:/Users/<<account>>`
> * `/`代表當前路徑，可用`..`向前
> * 斜線用`/`或`\\`，不支援windows的`\`
1. 基本語法

    ```ps
    # 基本語法
    csvq 'select * from `test.csv`'

    # 讀取絕對路徑
    csvq 'select * from `/Desktop/csvq/example/test.csv`'
    ```

2. 查詢
    ```ps
    # 查詢後過濾
    csvq '
        SELECT
            *
        FROM
            `/Desktop/csvq/example/test2.csv`
        WHERE
            `Index` >= 198
    '
    ```

3. 建立表
    > 注意檔案必須`不存在`
    ```ps
    # 查詢後建立表
    csvq '
        CREATE TABLE 
            `/Desktop/csvq/example/test3.csv` 
        SELECT
            Index
        FROM
            `/Desktop/csvq/example/test2.csv`
        WHERE
            `Height` > "71.39"
    '
    ```

4. 寫入表
    > 注意檔案必須`存在`
    ```ps
    # 寫入表
    csvq '
        INSERT INTO 
            `/Desktop/csvq/example/test3.csv` 
        SELECT
            Index
        FROM
            `/Desktop/csvq/example/test2.csv`
        WHERE
            `Index` > 180
    '
    ```

## ref
* https://mithrandie.github.io/csvq
* https://github.com/mithrandie/csvq