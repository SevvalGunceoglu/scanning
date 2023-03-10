
create PROCEDURE [dbo].[check_code]
  @code NVARCHAR(20),
  @IsValid BIT OUT
AS
BEGIN
  DECLARE @checkDigit INT = 0
  DECLARE @i INT = 1
  
  -- Check-digit hesaplama işlemi
  WHILE @i <= LEN(@code)
  BEGIN
    DECLARE @char NVARCHAR(1) = SUBSTRING(@code, @i, 1)
    SET @checkDigit = @checkDigit + (ASCII(@char) * POWER(2, @i))
    SET @i = @i + 1
  END
  
  -- Check-digit doğrulama işlemi
  IF @checkDigit % 10 = 0
    SET @IsValid = 1
  ELSE
    SET @IsValid = 0
END