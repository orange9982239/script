from PIL import Image, ExifTags
from datetime import datetime
import subprocess
import sys
import os
import pathlib

def getImageTakeDate(imgPath):
    img = Image.open(imgPath)
    img_exif = img.getexif()

    if img_exif is None:
        # print('Sorry, image has no exif data.')
        return None
    else:
        for key, val in img_exif.items():
            if key in ExifTags.TAGS:
                if (ExifTags.TAGS[key] == 'DateTime'):
                    return datetime.strptime(val, '%Y:%m:%d %H:%M:%S')
                # print(f'{ExifTags.TAGS[key]}:{val}')

def changeFileCreationTime(imgPath, takeDate):
    subprocess.Popen(
        [
            'powershell.exe', 
            f'''
                $Date = New-Object DateTime({takeDate.year}, {takeDate.month}, {takeDate.day}, {takeDate.hour}, {takeDate.minute}, {takeDate.second});
                $FileName = "{imgPath}"
                $file = Get-Item $FileName
                $file.CreationTime   = $Date; #建立日期
                $file.LastWriteTime  = $Date; #修改日期
                $file.LastAccessTime = $Date; #存取日期
            '''
        ]
    , stdout=sys.stdout)

def main(imgPath):
    takeDate = getImageTakeDate(imgPath)
    if takeDate != None:                # 無法取得拍攝日期者，不做修改
        changeFileCreationTime(imgPath,takeDate)

if __name__ == '__main__':
    # 指定圖片資料夾
    folderPath = "C://Users//Admin//Desktop//photoFolder"
    # 取得檔案 list 並保留.jpg .heic 檔案
    imgNameList = list(filter(lambda x: pathlib.PurePosixPath(x).suffix.lower() in ['.jpg','.heic'], os.listdir(folderPath)))

    # 迴圈傳入imgPath
    for imgName in imgNameList :
        main(f'{folderPath}//{imgName}')

    print('好囉~')