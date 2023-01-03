# 修復圖片建立日期

## 功能
> 從exif取得拍攝日期，修復圖片建立日期。


## HowToUse
 - [ ] 設定 Powershell 
    > 以管理員權限執行powershell，給予授權，並選A。
    ``` powershell
    Set-ExecutionPolicy RemoteSigned
    ```
 - [ ] 自行補齊pip包
 - [ ] 設定要修改的副檔名種類       [L46]
 - [ ] 欲修改圖片資料夾             [L44]

## 原理
1. 從圖片中exif取得拍攝日期存入變數。
2. 用powershell寫入圖檔建立時間、修改日期、存取日期。