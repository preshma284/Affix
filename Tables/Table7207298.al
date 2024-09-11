table 7207298 "QBU Hours to perform"
{
  
  
    CaptionML=ENU='Hours to perform',ESP='Horas a realizar';
    LookupPageID="Hours to perform List";
    DrillDownPageID="Hours to perform List";
  
  fields
{
    field(1;"Calendar";Code[10])
    {
        TableRelation="Type Calendar";
                                                   CaptionML=ENU='Calendar',ESP='Calendario';


    }
    field(2;"Period";Code[10])
    {
        TableRelation="Allocation Term";
                                                   

                                                   CaptionML=ENU='Period',ESP='Periodo';

trigger OnValidate();
    BEGIN 
                                                                IF AllocationTerm.GET(Period) THEN BEGIN 
                                                                  Date := AllocationTerm."Initial Date";
                                                                  AllocationTermDaysPrevius.RESET;
                                                                  AllocationTermDaysPrevius.SETRANGE(Calendar,Calendar);
                                                                  AllocationTermDaysPrevius.SETFILTER(Day,'..%1',Date-1);
                                                                  IF AllocationTermDaysPrevius.FINDLAST THEN BEGIN 
                                                                    Workingday := AllocationTermDaysPrevius.Workday;
                                                                    Hours := AllocationTermDaysPrevius."Hours to work";
                                                                  END ELSE BEGIN 
                                                                    Workingday := 0;
                                                                    Hours := 8;
                                                                  END;
                                                                  REPEAT
                                                                    AllocationTermDays.INIT;
                                                                    AllocationTermDays.VALIDATE(Calendar,Calendar);
                                                                    AllocationTermDays.VALIDATE("Allocation Term",Period);
                                                                    AllocationTermDays.VALIDATE(Day,Date);
                                                                    AllocationTermDays.VALIDATE(Workday,Workingday);
                                                                    AllocationTermDays.VALIDATE(Holiday,(DATE2DWY(Date,1) > 5));
                                                                    AllocationTermDays.VALIDATE("Long Weekend",FALSE);
                                                                    AllocationTermDays.VALIDATE("Hours to work",Hours);
                                                                    IF NOT AllocationTermDays.INSERT(TRUE) THEN
                                                                      AllocationTermDays.MODIFY(TRUE);
                                                                    Date := Date + 1;
                                                                  UNTIL Date > AllocationTerm."Final Date";
                                                                END;
                                                              END;


    }
    field(3;"Hours Total";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Allocation Term - Days"."Hours to work" WHERE ("Calendar"=FIELD("Calendar"),
                                                                                                                   "Allocation Term"=FIELD("Period"),
                                                                                                                   "Holiday"=CONST(false),
                                                                                                                   "Long Weekend"=CONST(false)));
                                                   CaptionML=ENU='Hours Total',ESP='Total horas';
                                                   Description='Sum of the day table by allocation non holiday days or long weekend';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Calendar","Period")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       AllocationTermDays@7001100 :
      AllocationTermDays: Record 7207295;
//       AllocationTerm@7001101 :
      AllocationTerm: Record 7207297;
//       AllocationTermDaysPrevius@7001102 :
      AllocationTermDaysPrevius: Record 7207295;
//       Date@7001103 :
      Date: Date;
//       Workingday@7001104 :
      Workingday: Integer;
//       Hours@7001105 :
      Hours: Decimal;

    /*begin
    end.
  */
}







