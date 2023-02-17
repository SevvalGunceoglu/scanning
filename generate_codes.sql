CREATE PROCEDURE [dbo].[generate_codes]
AS
BEGIN
  -- Koddaki karakterler
  DECLARE @characters VARCHAR(20) = 'ACDEFGHKLMNPRTXYZ234579'
  -- Ge�ici tablo i�in ad
  DECLARE @tempTable NVARCHAR(128) = '#tempCodes'
  -- Ka� adet kod �retilece�i
  DECLARE @numberOfCodes INT = 1000
  -- Kod uzunlu�u
  DECLARE @codeLength INT = 8
  
  IF OBJECT_ID(N'tempdb..' + @tempTable) IS NOT NULL
    DROP TABLE #tempCodes
  
  CREATE TABLE #tempCodes (Code NVARCHAR(20))
  
  WHILE @numberOfCodes > 0
  BEGIN
    DECLARE @code NVARCHAR(20) = ''
    
    -- Kod �retme i�lemi
    WHILE LEN(@code) < @codeLength
      SET @code = @code + SUBSTRING(@characters, CAST(RAND() * LEN(@characters) + 1 AS INT), 1)
    
    -- Kodun ge�ici tabloda var olup olmad���n� kontrol etme i�lemi
    IF NOT EXISTS (SELECT * FROM #tempCodes WHERE Code = @code)
    BEGIN
      INSERT INTO #tempCodes VALUES (@code)
      SET @numberOfCodes = @numberOfCodes - 1
    END
  END
  
  SELECT Code FROM #tempCodes
END

