report 7207336 "Set Period Trans. Nos. Element"
{
  
  
    CaptionML=ENU='Set Period Trans. Nos. Element',ESP='Asignar nros. asiento periodo Plantilla';
    ProcessingOnly=true;
    
  dataset
{

DataItem("Table2000000026";"2000000026")
{

               DataItemTableView=SORTING("Number")
                                 WHERE("Number"=FILTER(1..10));
               ;
DataItem("Element Posting Entries";"Element Posting Entries")
{

               DataItemTableView=SORTING("Posting Date");
               

               RequestFilterFields="Posting Date";
trigger OnPreDataItem();
    BEGIN 
                               AccountingPeriod.SETFILTER("Starting Date",'> %1',FromDate);
                               AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
                               IF NOT AccountingPeriod.FINDFIRST THEN
                                 CurAccountingPeriodLastDate := ToDate
                               ELSE
                                 CurAccountingPeriodLastDate := CLOSINGDATE(CALCDATE(Text1100000,AccountingPeriod."Starting Date"));
                               IF CurAccountingPeriodLastDate >= ToDate THEN BEGIN 
                                 "Element Posting Entries".SETRANGE("Posting Date",FromDate,ToDate);
                                 EndReached := TRUE
                               END ELSE
                                 "Element Posting Entries".SETRANGE("Posting Date",FromDate,CurAccountingPeriodLastDate);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  ElementPostingEntries := "Element Posting Entries";
                                  ElementPostingEntries."Period Trans. No." := CurrAccountingPeriodTransNo;
                                  ElementPostingEntries.MODIFY;
                                  CurrAccountingPeriodTransNo := CurrAccountingPeriodTransNo + 1;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                IF NOT EndReached THEN BEGIN 
                                  FromDate := NORMALDATE(CALCDATE(Text1100001,CurAccountingPeriodLastDate));
                                  CurrAccountingPeriodTransNo := 2;
                                END;
                              END;


}
trigger OnPreDataItem();
    BEGIN 
                               AccountingPeriod.RESET;
                               AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
                               AccountingPeriod.FINDSET;
                               IF AccountingPeriod."Starting Date" > FromDate THEN
                                 FromDate := AccountingPeriod."Starting Date";
                               AccountingPeriod.FINDLAST;
                               IF AccountingPeriod."Starting Date" < FromDate THEN
                                 FromDate := AccountingPeriod."Starting Date";

                               "Element Posting Entries".SETCURRENTKEY("Posting Date");
                               "Element Posting Entries".SETRANGE("Posting Date",FromDate,ToDate);
                               IF NOT "Element Posting Entries".FIND('-') THEN
                                 CurrReport.BREAK;
                               ElementPostingEntries2.RESET;
                               ElementPostingEntries2.SETCURRENTKEY("Posting Date");
                               ElementPostingEntries2.FIND('-');
                               IF "Element Posting Entries"."Transaction No." = ElementPostingEntries2."Transaction No." THEN
                                 CurrAccountingPeriodTransNo := 1
                               ELSE BEGIN 
                                 AccountingPeriod.SETRANGE("Starting Date",FromDate);
                                 IF AccountingPeriod.FIND('-') THEN BEGIN 
                                   CurrAccountingPeriodTransNo := 2;
                                 END ELSE BEGIN 
                                   "Element Posting Entries".SETCURRENTKEY("Posting Date");
                                   "Element Posting Entries".SETFILTER("Posting Date",'< %1',FromDate);
                                   "Element Posting Entries".FIND('+');
                                    CurrAccountingPeriodTransNo := "Element Posting Entries"."Period Trans. No." + 1;
                                 END;
                               END;

                               EndReached := FALSE;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF EndReached THEN
                                    CurrReport.BREAK;
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  
    var
//       FromDate@7001100 :
      FromDate: Date;
//       ToDate@7001101 :
      ToDate: Date;
//       AccountingPeriod@7001102 :
      AccountingPeriod: Record 50;
//       ElementPostingEntries2@7001103 :
      ElementPostingEntries2: Record 7207352;
//       CurrAccountingPeriodTransNo@7001104 :
      CurrAccountingPeriodTransNo: Integer;
//       EndReached@7001105 :
      EndReached: Boolean;
//       CurAccountingPeriodLastDate@7001106 :
      CurAccountingPeriodLastDate: Date;
//       Text1100000@7001108 :
      Text1100000: TextConst ENU='-1D',ESP='-1D';
//       Text1100001@7001107 :
      Text1100001: TextConst ENU='1D',ESP='1D';
//       ElementPostingEntries@7001109 :
      ElementPostingEntries: Record 7207352;

    

trigger OnPreReport();    begin
                  FromDate := "Element Posting Entries".GETRANGEMIN("Posting Date");
                  ToDate := CLOSINGDATE("Element Posting Entries".GETRANGEMAX("Posting Date"));
                end;



/*begin
    end.
  */
  
}



