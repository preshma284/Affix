Codeunit 7207314 "Rental Functions"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      RentalElements : Record 7207344;
      Text001 : TextConst ENU='Rental variants cannot be purchased',ESP='Las variantes de alquiler no se pueden comprar';

    PROCEDURE UsageDays(parContractCode : Code[20];parElementCode : Code[20];parDateFrom : Date;parDateTo : Date) Days : Decimal;
    VAR
      LOResource : Record 156;
      LOAllocationTermDays : Record 7207295;
      UsedWeekday : Decimal;
      AuxDate : Date;
      AuxStartDate : Date;
      NumDaysMonth : Integer;
    BEGIN
      //EXIT(parrechasta-parrecdesde);
      RentalElements.GET(parElementCode);
      CASE RentalElements."Billing Rate Type" OF
        RentalElements."Billing Rate Type"::"Calendar Day": BEGIN
          IF parDateFrom - parDateTo + 1 < 0 THEN
            EXIT(0)
          ELSE
            EXIT(parDateFrom-parDateTo + 1);
        END;
        RentalElements."Billing Rate Type"::Weekday: BEGIN
          UsedWeekday := 0;
          LOResource.GET(RentalElements."Invoicing Resource");
          LOResource.TESTFIELD("Type Calendar");
          LOAllocationTermDays.SETRANGE(Calendar,LOResource."Type Calendar");
          LOAllocationTermDays.SETRANGE(Day,parDateTo,parDateFrom);
          IF LOAllocationTermDays.FINDSET(FALSE) THEN
            REPEAT
              IF (NOT LOAllocationTermDays.Holiday) AND (NOT LOAllocationTermDays."Long Weekend") THEN
                UsedWeekday := UsedWeekday + 1;
            UNTIL LOAllocationTermDays.NEXT = 0;
          IF UsedWeekday < 0 THEN
            UsedWeekday := 0;
          EXIT(UsedWeekday);
        END;
        RentalElements."Billing Rate Type"::Month: BEGIN
          AuxDate := CALCDATE('PM',parDateTo);
          AuxStartDate := parDateTo;
          UsedWeekday := 0;
          REPEAT
            IF parDateFrom > AuxDate THEN BEGIN
              NumDaysMonth := DATE2DMY(AuxDate,1);
              UsedWeekday := UsedWeekday + (AuxDate - AuxStartDate + 1)/ NumDaysMonth;
              AuxStartDate := AuxDate + 1;
              AuxDate := CALCDATE('PM',AuxStartDate);
            END ELSE BEGIN
              NumDaysMonth := DATE2DMY(AuxDate,1);
              UsedWeekday := UsedWeekday + (parDateFrom - AuxStartDate + 1)/ NumDaysMonth;
              AuxStartDate := AuxDate + 1;
              AuxDate := CALCDATE('PM',AuxStartDate);
            END;
          UNTIL AuxDate > parDateFrom;
          IF UsedWeekday < 0 THEN
            UsedWeekday := 0;
          EXIT(UsedWeekday);
        END;
      END;
    END;

    /* /*BEGIN
END.*/
}







