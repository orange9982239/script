--顯示 sp_configure 系統存儲過程高級選項
EXEC sp_configure 'show advanced options', 1;

--開啟xp_cmdshell
EXEC sp_configure 'xp_cmdshell',1
--SMB掛載於X:
-- EXEC XP_CMDSHELL 'net use X: \\{ip}\{folder} /USER:{account} {password}'
EXEC XP_CMDSHELL 'net use X: \\192.168.1.1\home /USER:account password'
EXEC XP_CMDSHELL 'Dir X:'

--關閉xp_cmdshell
EXEC sp_configure 'xp_cmdshell', 0;
--刪除SMB掛載
EXEC xp_cmdshell 'net use X: /delete'