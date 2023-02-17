CREATE PROCEDURE [dbo].[generate_codes]
AS
BEGIN
  -- Koddaki karakterler
  DECLARE @characters VARCHAR(20) = 'ACDEFGHKLMNPRTXYZ234579'
  -- Geçici tablo için ad
  DECLARE @tempTable NVARCHAR(128) = '#tempCodes'
  -- Kaç adet kod üretileceği
  DECLARE @numberOfCodes INT = 1000
  -- Kod uzunluðu
  DECLARE @codeLength INT = 8
  
  IF OBJECT_ID(N'tempdb..' + @tempTable) IS NOT NULL
    DROP TABLE #tempCodes
  
  CREATE TABLE #tempCodes (Code NVARCHAR(20))
  
  WHILE @numberOfCodes > 0
  BEGIN
    DECLARE @code NVARCHAR(20) = ''
    
    -- Kod üretme işlemi
    WHILE LEN(@code) < @codeLength
      SET @code = @code + SUBSTRING(@characters, CAST(RAND() * LEN(@characters) + 1 AS INT), 1)
    
    -- Kodun geçici tabloda var olup olmadığını kontrol etme işlemi
    IF NOT EXISTS (SELECT * FROM #tempCodes WHERE Code = @code)
    BEGIN
      INSERT INTO #tempCodes VALUES (@code)
      SET @numberOfCodes = @numberOfCodes - 1
    END
  END
  
  SELECT Code FROM #tempCodes
END

