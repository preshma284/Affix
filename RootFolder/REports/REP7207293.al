report 7207293 "Generate Reestimation Code"
{
  
  
    CaptionML=ENU='Generate Reestimation Code',ESP='Generar c¢digo reestimaci¢n';
    ProcessingOnly=true;
    
  dataset
{

}
  requestpage
  {

    layout
{
area(content)
{
group("group421")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("DateStart";"DateStart")
    {
        
                  CaptionML=ENU='Starting Date',ESP='Fecha inicial';
                  NotBlank=true;
    }
    field("DateEnd";"DateEnd")
    {
        
                  CaptionML=ENU='End Date',ESP='Fecha final';
                  NotBlank=true;
    }
    field("LongPeriod";"LongPeriod")
    {
        
                  CaptionML=ENU='Period Lenght',ESP='Longitud periodo';
    }

}

}
}
  }
  labels
{
}
  
    var
//       DateStart@7001100 :
      DateStart: Date;
//       DateEnd@7001101 :
      DateEnd: Date;
//       Text001@7001103 :
      Text001: TextConst ENU='%1 must be specified.',ESP='Se debe indicar Fecha inicial.';
//       Text002@7001102 :
      Text002: TextConst ENU='end date must be specified.',ESP='Se debe indicar Fecha final.';
//       LongPeriod@7001104 :
      LongPeriod: DateFormula;
//       DateReestimation@7001105 :
      DateReestimation: Date;
//       DateEndPeriod@7001106 :
      DateEndPeriod: Date;
//       DimensionValue@7001107 :
      DimensionValue: Record 349;
//       FunctionQB@7001108 :
      FunctionQB: Codeunit 7207272;
//       Day@7001109 :
      Day: Integer;
//       Month@7001110 :
      Month: Integer;
//       Year@7001111 :
      Year: Integer;
//       VYear@7001112 :
      VYear: Text[2];
//       VMonth@7001113 :
      VMonth: Text[2];
//       VDay@7001114 :
      VDay: Text[2];
//       VTextDate@7001115 :
      VTextDate: Text[30];
//       Text003@7001119 :
      Text003: TextConst ENU='Reestimation end period %1',ESP='Reestimaci¢n fin periodo %1';
//       Text004@7001118 :
      Text004: TextConst ENU='Reestimation Week %1 year %2',ESP='Reestimaci¢n Semana %1 a¤o %2';
//       Text005@7001117 :
      Text005: TextConst ENU='Reestimation %1',ESP='Reestimaci¢n %1';
//       Text006@7001116 :
      Text006: TextConst ENU='Year reestimation %1',ESP='Reestimaci¢n a¤o %1';

    

trigger OnPreReport();    begin
                  if DateStart = 0D then
                    ERROR(Text001);
                  if DateEnd = 0D then
                    ERROR(Text002);

                  WHILE CALCDATE(LongPeriod,DateStart) <= CALCDATE(LongPeriod,DateEnd) DO begin
                    DateReestimation := DateStart;
                    DateStart := CALCDATE(LongPeriod,DateReestimation);
                    DateEndPeriod := DateStart -1;
                    DimensionValue.INIT;
                    DimensionValue."Dimension Code" := FunctionQB.ReturnDimReest;

                    Day := DATE2DMY(DateEndPeriod,1);
                    Month := DATE2DMY(DateEndPeriod,2);
                    Year := DATE2DMY(DateEndPeriod,3);
                    VYear := COPYSTR(FORMAT(Year),3,2);
                    VMonth := COPYSTR(FORMAT(Month),1,2);
                    VDay := COPYSTR(FORMAT(Day),1,2);
                    if STRLEN(VMonth)=1 then
                      VMonth:='0'+VMonth;
                    if STRLEN(VDay)=1 then
                      VDay:='0'+VDay;
                    VTextDate := VYear + VMonth + VDay;
                    DimensionValue.Code := 'R' + FORMAT(VTextDate);
                    CASE UPPERCASE(COPYSTR(FORMAT(LongPeriod),STRLEN(FORMAT(LongPeriod)),1)) OF
                      'S':
                        begin
                          DimensionValue.Name := STRSUBSTNO(Text004,DATE2DWY(DateEndPeriod,2),DATE2DWY(DateEndPeriod,3));
                        end;
                      'M':
                        begin
                          DimensionValue.Name := STRSUBSTNO(Text005,FORMAT(DateEndPeriod,0,'<Month Text> <Year4>'));
                        end;
                      'A':
                        begin
                          DimensionValue.Name := STRSUBSTNO(Text006,FORMAT(DateEndPeriod,0,'<Year4>'));
                        end;
                      else
                        DimensionValue.Name := STRSUBSTNO(Text003,DateEndPeriod);
                    end;
                    DimensionValue."Reestimation Date" := DateEndPeriod;
                    DimensionValue.INSERT;
                  end;
                end;



/*begin
    end.
  */
  
}



