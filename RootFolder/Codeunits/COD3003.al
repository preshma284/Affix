Codeunit 50792 "DotNet_DateTime 1"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      DotNetDateTime : DotNet DateTime;

    
    //[External]
    PROCEDURE TryParse(DateTimeText : Text;DotNet_CultureInfo : Codeunit 3002;DotNet_DateTimeStyles : Codeunit 3004) : Boolean;
    VAR
      DotNetCultureInfo : DotNet CultureInfo;
      DotNetDateTimeStyles : DotNet DateTimeStyles;
    BEGIN
      DateTimeFromInt(0);
      DotNet_CultureInfo.GetCultureInfo(DotNetCultureInfo);
      DotNet_DateTimeStyles.GetDateTimeStyles(DotNetDateTimeStyles);
      EXIT(DotNetDateTime.TryParse(DateTimeText,DotNetCultureInfo,DotNetDateTimeStyles,DotNetDateTime))
    END;

    //[External]
    PROCEDURE TryParseExact(DateTimeText : Text;Format : Text;DotNet_CultureInfo : Codeunit 3002;DotNet_DateTimeStyles : Codeunit 3004) : Boolean;
    VAR
      DotNetCultureInfo : DotNet CultureInfo;
      DotNetDateTimeStyles : DotNet DateTimeStyles;
    BEGIN
      DateTimeFromInt(0);
      DotNet_CultureInfo.GetCultureInfo(DotNetCultureInfo);
      DotNet_DateTimeStyles.GetDateTimeStyles(DotNetDateTimeStyles);
      EXIT(DotNetDateTime.TryParseExact(DateTimeText,Format,DotNetCultureInfo,DotNetDateTimeStyles,DotNetDateTime))
    END;

    //[External]
    PROCEDURE DateTimeFromInt(IntegerDateTime : Integer);
    BEGIN
      DotNetDateTime := DotNetDateTime.DateTime(IntegerDateTime)
    END;

    //[External]
    PROCEDURE DateTimeFromYMD(Year : Integer;Month : Integer;Day : Integer);
    BEGIN
      DotNetDateTime := DotNetDateTime.DateTime(Year,Month,Day)
    END;

    
    //[External]
    PROCEDURE ToString(DotNet_DateTimeFormatInfo : Codeunit 3022) : Text;
    VAR
      DotNetDateTimeFormatInfo : DotNet DateTimeFormatInfo;
    BEGIN
      DotNet_DateTimeFormatInfo.GetDateTimeFormatInfo(DotNetDateTimeFormatInfo);
      EXIT(DotNetDateTime.ToString('d',DotNetDateTimeFormatInfo))
    END;

    

    /* /*BEGIN
END.*/
}







