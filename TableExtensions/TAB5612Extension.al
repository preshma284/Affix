tableextension 50197 "QBU FA Depreciation BookExt" extends "FA Depreciation Book"
{
  
  /*
Permissions=TableData 5601 r,
                TableData 5625 r;
*/
    CaptionML=ENU='FA Depreciation Book',ESP='A/F Libro amortizaci¢n';
  
  fields
{
    field(7207270;"QBU OLD_Asset Allocation Job";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Asset Allocation Job',ESP='_Proyecto imputaci¢n Activos';
                                                   Description='### ELIMINAR ### ya no se usan';


    }
    field(7207271;"QBU OLD_Piecework Code";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("OLD_Asset Allocation Job"));
                                                   CaptionML=ENU='Cod. unidad de obra',ESP='_C¢d. unidad de obra';
                                                   Description='### ELIMINAR ### ya no se usan' ;


    }
}
  keys
{
   // key(key1;"FA No.","Depreciation Book Code")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Depreciation Book Code","FA No.")
  //  {
       /* ;
 */
   // }
   // key(key3;"Depreciation Book Code","Component of Main Asset","Main Asset/Component")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='You cannot rename a %1.',ESP='No se puede cambiar el nombre a %1.';
//       Text001@1001 :
      Text001: TextConst ENU='must not be 100',ESP='no debe ser 100';
//       Text002@1002 :
      Text002: TextConst ENU='%1 is later than %2.',ESP='%1 es posterior a %2.';
//       Text003@1003 :
      Text003: TextConst ENU='must not be %1',ESP='No puede ser %1.';
//       Text004@1004 :
      Text004: TextConst ENU='untitled',ESP='SinT¡tulo';
//       FA@1005 :
      FA: Record 5600;
//       DeprBook@1006 :
      DeprBook: Record 5611;
//       FAMoveEntries@1007 :
      FAMoveEntries: Codeunit 5623;
//       FADateCalc@1008 :
      FADateCalc: Codeunit 5617;
//       DepreciationCalc@1009 :
      DepreciationCalc: Codeunit 5616;
//       OnlyOneDefaultDeprBookErr@1010 :
      OnlyOneDefaultDeprBookErr: TextConst ENU='Only one fixed asset depreciation book can be marked as the default book',ESP='Se puede marcar como predeterminado un solo libro de amortizaci¢n de activos fijos';

    


/*
trigger OnInsert();    begin
               "Acquisition Date" := 0D;
               "G/L Acquisition Date" := 0D;
               "Last Acquisition Cost Date" := 0D;
               "Last Salvage Value Date" := 0D;
               "Last Depreciation Date" := 0D;
               "Last Write-Down Date" := 0D;
               "Last Appreciation Date" := 0D;
               "Last Custom 1 Date" := 0D;
               "Last Custom 2 Date" := 0D;
               "Disposal Date" := 0D;
               "Last Maintenance Date" := 0D;
               LOCKTABLE;
               FA.LOCKTABLE;
               DeprBook.LOCKTABLE;
               FA.GET("FA No.");
               DeprBook.GET("Depreciation Book Code");
               Description := FA.Description;
               "Main Asset/Component" := FA."Main Asset/Component";
               "Component of Main Asset" := FA."Component of Main Asset";
               if ("No. of Depreciation Years" <> 0) or ("No. of Depreciation Months" <> 0) then
                 DeprBook.TESTFIELD("Fiscal Year 365 Days",FALSE);
               CheckApplyDeprBookDefaults;
             end;


*/

/*
trigger OnModify();    begin
               "Last Date Modified" := TODAY;
               LOCKTABLE;
               DeprBook.LOCKTABLE;
               DeprBook.GET("Depreciation Book Code");
               if ("No. of Depreciation Years" <> 0) or ("No. of Depreciation Months" <> 0) then
                 DeprBook.TESTFIELD("Fiscal Year 365 Days",FALSE);
               CheckApplyDeprBookDefaults;
             end;


*/

/*
trigger OnDelete();    begin
               FAMoveEntries.MoveFAEntries(Rec);
             end;


*/

/*
trigger OnRename();    begin
               ERROR(Text000,TABLECAPTION);
             end;

*/



// LOCAL procedure AdjustLinearMethod (var Amount1@1000 : Decimal;var Amount2@1001 :

/*
LOCAL procedure AdjustLinearMethod (var Amount1: Decimal;var Amount2: Decimal)
    begin
      Amount1 := 0;
      Amount2 := 0;
      if "No. of Depreciation Years" = 0 then begin
        "No. of Depreciation Months" := 0;
        "Depreciation Ending Date" := 0D;
      end;
    end;
*/


    
/*
LOCAL procedure ModifyDeprFields ()
    begin
      if ("Last Depreciation Date" > 0D) or
         ("Last Write-Down Date" > 0D) or
         ("Last Appreciation Date" > 0D) or
         ("Last Custom 1 Date" > 0D) or
         ("Last Custom 2 Date" > 0D) or
         ("Disposal Date" > 0D)
      then begin
        DeprBook.GET("Depreciation Book Code");
        DeprBook.TESTFIELD("Allow Changes in Depr. Fields",TRUE);
      end;
    end;
*/


    
    
/*
procedure CalcDeprPeriod ()
    var
//       DeprBook2@1000 :
      DeprBook2: Record 5611;
    begin
      if "Depreciation Starting Date" = 0D then begin
        "Depreciation Ending Date" := 0D;
        "No. of Depreciation Years" := 0;
        "No. of Depreciation Months" := 0;
      end;
      if ("Depreciation Starting Date" = 0D) or ("Depreciation Ending Date" = 0D) then begin
        "No. of Depreciation Years" := 0;
        "No. of Depreciation Months" := 0;
      end else begin
        if "Depreciation Starting Date" > "Depreciation Ending Date" then
          ERROR(
            Text002,
            FIELDCAPTION("Depreciation Starting Date"),FIELDCAPTION("Depreciation Ending Date"));
        DeprBook2.GET("Depreciation Book Code");
        if DeprBook2."Fiscal Year 365 Days" then begin
          "No. of Depreciation Months" := 0;
          "No. of Depreciation Years" := 0;
        end;
        if not DeprBook2."Fiscal Year 365 Days" then begin
          "No. of Depreciation Months" :=
            DepreciationCalc.DeprDays("Depreciation Starting Date","Depreciation Ending Date",FALSE) / 30;
          "No. of Depreciation Months" := ROUND("No. of Depreciation Months",0.00000001);
          "No. of Depreciation Years" := ROUND("No. of Depreciation Months" / 12,0.00000001);
        end;
        "Straight-Line %" := 0;
        "Fixed Depr. Amount" := 0;
      end;
    end;
*/


    
/*
LOCAL procedure CalcEndingDate () : Date;
    var
//       EndingDate@1000 :
      EndingDate: Date;
    begin
      if "No. of Depreciation Years" = 0 then
        exit(0D);
      EndingDate := FADateCalc.CalculateDate(
          "Depreciation Starting Date",ROUND("No. of Depreciation Years" * 360,1),FALSE);
      EndingDate := DepreciationCalc.Yesterday(EndingDate,FALSE);
      if EndingDate < "Depreciation Starting Date" then
        EndingDate := "Depreciation Starting Date";
      exit(EndingDate);
    end;
*/


    
    
/*
procedure GetExchangeRate () : Decimal;
    var
//       DeprBook@1000 :
      DeprBook: Record 5611;
    begin
      DeprBook.GET("Depreciation Book Code");
      if not DeprBook."Use FA Exch. Rate in Duplic." then
        exit(0);
      if "FA Exchange Rate" > 0 then
        exit("FA Exchange Rate");
      exit(DeprBook."Default Exchange Rate");
    end;
*/


    
/*
LOCAL procedure LinearMethod () : Boolean;
    begin
      exit(
        "Depreciation Method" IN
        ["Depreciation Method"::"Straight-Line",
         "Depreciation Method"::"DB1/SL",
         "Depreciation Method"::"DB2/SL"]);
    end;
*/


    
/*
LOCAL procedure DecliningMethod () : Boolean;
    begin
      exit(
        "Depreciation Method" IN
        ["Depreciation Method"::"Declining-Balance 1",
         "Depreciation Method"::"Declining-Balance 2",
         "Depreciation Method"::"DB1/SL",
         "Depreciation Method"::"DB2/SL"]);
    end;
*/


    
/*
LOCAL procedure UserDefinedMethod () : Boolean;
    begin
      exit("Depreciation Method" = "Depreciation Method"::"User-Defined");
    end;
*/


    
/*
LOCAL procedure TestHalfYearConventionMethod ()
    begin
      if "Depreciation Method" IN
         ["Depreciation Method"::"Declining-Balance 2",
          "Depreciation Method"::"DB2/SL",
          "Depreciation Method"::"User-Defined"]
      then
        TESTFIELD("Use Half-Year Convention",FALSE);
    end;
*/


    
/*
LOCAL procedure DeprMethodError ()
    begin
      FIELDERROR("Depreciation Method",STRSUBSTNO(Text003,"Depreciation Method"));
    end;
*/


    
/*
LOCAL procedure CheckApplyDeprBookDefaults ()
    begin
      if (DeprBook."Default Ending Book Value" <> 0) and ("Ending Book Value" = 0) then
        "Ending Book Value" := DeprBook."Default Ending Book Value";
      if (DeprBook."Default Final Rounding Amount" <> 0) and ("Final Rounding Amount" = 0) then
        "Final Rounding Amount" := DeprBook."Default Final Rounding Amount"
    end;
*/


    
    
/*
procedure Caption () : Text[120];
    var
//       FA@1000 :
      FA: Record 5600;
//       DeprBook@1001 :
      DeprBook: Record 5611;
    begin
      if "FA No." = '' then
        exit(Text004);
      FA.GET("FA No.");
      DeprBook.GET("Depreciation Book Code");
      exit(
        STRSUBSTNO(
          '%1 %2 %3 %4',"FA No.",FA.Description,"Depreciation Book Code",DeprBook.Description));
    end;
*/


    
    
/*
procedure DrillDownOnBookValue ()
    var
//       FALedgEntry@1000 :
      FALedgEntry: Record 5601;
    begin
      if "Disposal Date" > 0D then
        ShowBookValueAfterDisposal
      else begin
        SetBookValueFiltersOnFALedgerEntry(FALedgEntry);
        PAGE.RUN(0,FALedgEntry);
      end;
    end;
*/


    
    
/*
procedure ShowBookValueAfterDisposal ()
    var
//       TempFALedgEntry@1000 :
      TempFALedgEntry: Record 5601 TEMPORARY;
//       FALedgEntry@1001 :
      FALedgEntry: Record 5601;
    begin
      if "Disposal Date" > 0D then begin
        CLEAR(TempFALedgEntry);
        TempFALedgEntry.DELETEALL;
        TempFALedgEntry.SETCURRENTKEY("FA No.","Depreciation Book Code","FA Posting Date");
        DepreciationCalc.SetFAFilter(FALedgEntry,"FA No.","Depreciation Book Code",FALSE);
        SetBookValueAfterDisposalFiltersOnFALedgerEntry(FALedgEntry);
        PAGE.RUN(0,FALedgEntry);
      end else begin
        SetBookValueFiltersOnFALedgerEntry(FALedgEntry);
        PAGE.RUN(0,FALedgEntry);
      end;
    end;
*/


    
    
/*
procedure CalcBookValue ()
    begin
      if "Disposal Date" > 0D then
        "Book Value" := 0
      else
        CALCFIELDS("Book Value");
    end;
*/


    
//     procedure SetBookValueFiltersOnFALedgerEntry (var FALedgEntry@1000 :
    
/*
procedure SetBookValueFiltersOnFALedgerEntry (var FALedgEntry: Record 5601)
    begin
      FALedgEntry.SETCURRENTKEY("FA No.","Depreciation Book Code","Part of Book Value","FA Posting Date");
      FALedgEntry.SETRANGE("FA No.","FA No.");
      FALedgEntry.SETRANGE("Depreciation Book Code","Depreciation Book Code");
      FALedgEntry.SETRANGE("Part of Book Value",TRUE);
    end;
*/


    
//     procedure LineIsReadyForAcquisition (FANo@1000 :
    
/*
procedure LineIsReadyForAcquisition (FANo: Code[20]) : Boolean;
    var
//       FADepreciationBook@1001 :
      FADepreciationBook: Record 5612;
//       FASetup@1002 :
      FASetup: Record 5603;
    begin
      FASetup.GET;
      exit(FADepreciationBook.GET(FANo,FASetup."Default Depr. Book") and FADepreciationBook.RecIsReadyForAcquisition);
    end;
*/


    
    
/*
procedure RecIsReadyForAcquisition () : Boolean;
    var
//       FASetup@1000 :
      FASetup: Record 5603;
    begin
      FASetup.GET;
      if ("Depreciation Book Code" = FASetup."Default Depr. Book") and
         ("FA Posting Group" <> '') and
         ("Depreciation Starting Date" > 0D)
      then begin
        if "Depreciation Method" IN
           ["Depreciation Method"::"Straight-Line","Depreciation Method"::"DB1/SL","Depreciation Method"::"DB2/SL"]
        then
          exit("No. of Depreciation Years" > 0);
        exit(TRUE);
      end;

      exit(FALSE);
    end;
*/


    
    
/*
procedure UpdateBookValue ()
    begin
      if "Disposal Date" > 0D then
        "Book Value" := 0;
    end;
*/


//     LOCAL procedure SetBookValueAfterDisposalFiltersOnFALedgerEntry (var FALedgEntry@1000 :
    
/*
LOCAL procedure SetBookValueAfterDisposalFiltersOnFALedgerEntry (var FALedgEntry: Record 5601)
    begin
      SetBookValueFiltersOnFALedgerEntry(FALedgEntry);
      FALedgEntry.SETRANGE("Part of Book Value");
      FALedgEntry.SETRANGE("FA Posting Category",FALedgEntry."FA Posting Category"::Disposal);
      FALedgEntry.SETRANGE("FA Posting Type",FALedgEntry."FA Posting Type"::"Book Value on Disposal");
      if GETFILTER("FA Posting Date Filter") <> '' then
        FALedgEntry.SETFILTER("FA Posting Date",GETFILTER("FA Posting Date Filter"));
    end;

    /*begin
    end.
  */
}





