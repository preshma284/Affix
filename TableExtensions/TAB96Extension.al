tableextension 50127 "QBU G/L Budget EntryExt" extends "G/L Budget Entry"
{
  
  /*
Permissions=TableData 366 rd;
*/
    CaptionML=ENU='G/L Budget Entry',ESP='Mov. presupuesto';
    LookupPageID="G/L Budget Entries";
    DrillDownPageID="G/L Budget Entries";
  
  fields
{
    field(7207270;"QBU Type";Option)
    {
        OptionMembers="Expenses","Revenues";CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='Expenses,Revenues',ESP='Gastos,Ingresos';
                                                   
                                                   Description='QB2413' ;


    }
}
  keys
{
   // key(key1;"Entry No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Budget Name","G/L Account No.","Date")
  //  {
       /* SumIndexFields="Amount";
 */
   // }
   // key(key3;"Budget Name","G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code","Budget Dimension 1 Code","Budget Dimension 2 Code","Budget Dimension 3 Code","Budget Dimension 4 Code","Date")
  //  {
       /* SumIndexFields="Amount";
 */
   // }
   // key(key4;"Budget Name","G/L Account No.","Description","Date")
  //  {
       /* ;
 */
   // }
   // key(key5;"Budget Name","Old G/L Account No.","Date")
  //  {
       /* SumIndexFields="Amount";
 */
   // }
   // key(key6;"Budget Name","Old G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code","Budget Dimension 1 Code","Budget Dimension 2 Code","Budget Dimension 3 Code","Budget Dimension 4 Code","Date")
  //  {
       /* SumIndexFields="Amount";
 */
   // }
   // key(key7;"G/L Account No.","Date","Budget Name","Dimension Set ID")
  //  {
       /* SumIndexFields="Amount";
 */
   // }
   // key(key8;"Last Date Modified","Budget Name")
  //  {
       /* ;
 */
   // }
    //key(Extkey9;"Budget Name","Global Dimension 1 Code","Global Dimension 2 Code","Type","Date")
   // {
        /*  SumIndexFields="Amount";
 */
   // }
    //key(Extkey10;"Budget Name","Budget Dimension 1 Code","Budget Dimension 2 Code","Type","Date")
   // {
        /*  SumIndexFields="Amount";
 */
   // }
    key(Extkey11;"Budget Name","Budget Dimension 1 Code","Budget Dimension 2 Code","Global Dimension 2 Code","Date")
    {
        SumIndexFields="Amount";
    }
}
  fieldgroups
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='The dimension value %1 has not been set up for dimension %2.',ESP='El valor dimensi¢n %1 no ha sido config. para la dimensi¢n %2.';
//       Text001@1001 :
      Text001: TextConst ENU='1,5,,Budget Dimension 1 Code',ESP='1,5,,C¢digo Dimensi¢n Presupuesto 1';
//       Text002@1002 :
      Text002: TextConst ENU='1,5,,Budget Dimension 2 Code',ESP='1,5,,C¢digo Dimensi¢n Presupuesto 2';
//       Text003@1003 :
      Text003: TextConst ENU='1,5,,Budget Dimension 3 Code',ESP='1,5,,C¢digo Dimensi¢n Presupuesto 3';
//       Text004@1004 :
      Text004: TextConst ENU='1,5,,Budget Dimension 4 Code',ESP='1,5,,C¢digo Dimensi¢n Presupuesto 4';
//       GLBudgetName@1005 :
      GLBudgetName: Record 95;
//       GLSetup@1006 :
      GLSetup: Record 98;
//       DimVal@1009 :
      DimVal: Record 349;
//       DimMgt@1008 :
      DimMgt: Codeunit 408;
//       GLSetupRetrieved@1007 :
      GLSetupRetrieved: Boolean;
//       AnalysisViewBudgetEntryExistsErr@1010 :
      AnalysisViewBudgetEntryExistsErr: TextConst ENU='You cannot change the amount on this G/L budget entry because one or more related analysis view budget entries exist.\\You must make the change on the related entry in the G/L Budget window.',ESP='No puede cambiar el importe de este movimiento de presupuesto de Contabilidad porque existen uno o m s movimientos de presupuesto de vista de an lisis relacionados.\\Debe definirse el cambio en el movimiento relacionado en la ventana Ppto. contable.';

    


/*
trigger OnInsert();    var
//                TempDimSetEntry@1000 :
               TempDimSetEntry: Record 480 TEMPORARY;
             begin
               CheckIfBlocked;
               TESTFIELD(Date);
               TESTFIELD("G/L Account No.");
               TESTFIELD("Budget Name");
               LOCKTABLE;
               "User ID" := USERID;
               "Last Date Modified" := TODAY;
               if "Entry No." = 0 then
                 "Entry No." := GetNextEntryNo;

               GetGLSetup;
               DimMgt.GetDimensionSet(TempDimSetEntry,"Dimension Set ID");
               UpdateDimSet(TempDimSetEntry,GLSetup."Global Dimension 1 Code","Global Dimension 1 Code");
               UpdateDimSet(TempDimSetEntry,GLSetup."Global Dimension 2 Code","Global Dimension 2 Code");
               UpdateDimSet(TempDimSetEntry,GLBudgetName."Budget Dimension 1 Code","Budget Dimension 1 Code");
               UpdateDimSet(TempDimSetEntry,GLBudgetName."Budget Dimension 2 Code","Budget Dimension 2 Code");
               UpdateDimSet(TempDimSetEntry,GLBudgetName."Budget Dimension 3 Code","Budget Dimension 3 Code");
               UpdateDimSet(TempDimSetEntry,GLBudgetName."Budget Dimension 4 Code","Budget Dimension 4 Code");
               OnInsertOnAfterUpdateDimSets(TempDimSetEntry,Rec);
               VALIDATE("Dimension Set ID",DimMgt.GetDimensionSetID(TempDimSetEntry));
             end;


*/

/*
trigger OnModify();    begin
               CheckIfBlocked;
               "User ID" := USERID;
               "Last Date Modified" := TODAY;
             end;


*/

/*
trigger OnDelete();    begin
               CheckIfBlocked;
               DeleteAnalysisViewBudgetEntries;
             end;

*/




/*
LOCAL procedure CheckIfBlocked ()
    begin
      if "Budget Name" = GLBudgetName.Name then
        exit;
      if GLBudgetName.Name <> "Budget Name" then
        GLBudgetName.GET("Budget Name");
      GLBudgetName.TESTFIELD(Blocked,FALSE);
    end;
*/


//     LOCAL procedure ValidateDimValue (DimCode@1000 : Code[20];var DimValueCode@1001 :
    
/*
LOCAL procedure ValidateDimValue (DimCode: Code[20];var DimValueCode: Code[20])
    var
//       DimValue@1002 :
      DimValue: Record 349;
    begin
      if DimValueCode = '' then
        exit;

      DimValue."Dimension Code" := DimCode;
      DimValue.Code := DimValueCode;
      DimValue.FIND('=><');
      if DimValueCode <> COPYSTR(DimValue.Code,1,STRLEN(DimValueCode)) then
        ERROR(Text000,DimValueCode,DimCode);
      DimValueCode := DimValue.Code;
    end;
*/


    
/*
LOCAL procedure GetGLSetup ()
    begin
      if not GLSetupRetrieved then begin
        GLSetup.GET;
        GLSetupRetrieved := TRUE;
      end;
    end;
*/


//     LOCAL procedure OnLookupDimCode (DimOption@1000 : 'Global Dimension 1,Global Dimension 2,Budget Dimension 1,Budget Dimension 2,Budget Dimension 3,Budget Dimension 4';DefaultValue@1001 :
    
/*
LOCAL procedure OnLookupDimCode (DimOption: Option "Global Dimension 1","Global Dimension 2","Budget Dimension 1","Budget Dimension 2","Budget Dimension 3","Budget Dimension 4";DefaultValue: Code[20]) : Code[20];
    var
//       DimValue@1002 :
      DimValue: Record 349;
//       DimValueList@1003 :
      DimValueList: Page 560;
    begin
      if DimOption IN [DimOption::"Global Dimension 1",DimOption::"Global Dimension 2"] then
        GetGLSetup
      else
        if GLBudgetName.Name <> "Budget Name" then
          GLBudgetName.GET("Budget Name");
      CASE DimOption OF
        DimOption::"Global Dimension 1":
          DimValue."Dimension Code" := GLSetup."Global Dimension 1 Code";
        DimOption::"Global Dimension 2":
          DimValue."Dimension Code" := GLSetup."Global Dimension 2 Code";
        DimOption::"Budget Dimension 1":
          DimValue."Dimension Code" := GLBudgetName."Budget Dimension 1 Code";
        DimOption::"Budget Dimension 2":
          DimValue."Dimension Code" := GLBudgetName."Budget Dimension 2 Code";
        DimOption::"Budget Dimension 3":
          DimValue."Dimension Code" := GLBudgetName."Budget Dimension 3 Code";
        DimOption::"Budget Dimension 4":
          DimValue."Dimension Code" := GLBudgetName."Budget Dimension 4 Code";
      end;
      DimValue.SETRANGE("Dimension Code",DimValue."Dimension Code");
      if DimValue.GET(DimValue."Dimension Code",DefaultValue) then;
      DimValueList.SETTABLEVIEW(DimValue);
      DimValueList.SETRECORD(DimValue);
      DimValueList.LOOKUPMODE := TRUE;
      if DimValueList.RUNMODAL = ACTION::LookupOK then begin
        DimValueList.GETRECORD(DimValue);
        exit(DimValue.Code);
      end;
      exit(DefaultValue);
    end;
*/


    
/*
LOCAL procedure GetNextEntryNo () : Integer;
    var
//       GLBudgetEntry@1000 :
      GLBudgetEntry: Record 96;
    begin
      GLBudgetEntry.SETCURRENTKEY("Entry No.");
      if GLBudgetEntry.FINDLAST then
        exit(GLBudgetEntry."Entry No." + 1);

      exit(1);
    end;
*/


    
//     procedure GetCaptionClass (BudgetDimType@1000 :
    
/*
procedure GetCaptionClass (BudgetDimType: Integer) : Text[250];
    begin
      if GETFILTER("Budget Name") <> '' then begin
        GLBudgetName.SETFILTER(Name,GETFILTER("Budget Name"));
        if not GLBudgetName.FINDFIRST then
          CLEAR(GLBudgetName);
      end;
      CASE BudgetDimType OF
        1:
          begin
            if GLBudgetName."Budget Dimension 1 Code" <> '' then
              exit('1,5,' + GLBudgetName."Budget Dimension 1 Code");

            exit(Text001);
          end;
        2:
          begin
            if GLBudgetName."Budget Dimension 2 Code" <> '' then
              exit('1,5,' + GLBudgetName."Budget Dimension 2 Code");

            exit(Text002);
          end;
        3:
          begin
            if GLBudgetName."Budget Dimension 3 Code" <> '' then
              exit('1,5,' + GLBudgetName."Budget Dimension 3 Code");

            exit(Text003);
          end;
        4:
          begin
            if GLBudgetName."Budget Dimension 4 Code" <> '' then
              exit('1,5,' + GLBudgetName."Budget Dimension 4 Code");

            exit(Text004);
          end;
      end;
    end;
*/


    
    
/*
procedure ShowDimensions ()
    var
//       DimSetEntry@1000 :
      DimSetEntry: Record 480;
//       OldDimSetID@1001 :
      OldDimSetID: Integer;
    begin
      OldDimSetID := "Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Budget Name","G/L Account No.","Entry No."));

      if OldDimSetID = "Dimension Set ID" then
        exit;

      GetGLSetup;
      GLBudgetName.GET("Budget Name");

      "Global Dimension 1 Code" := '';
      "Global Dimension 2 Code" := '';
      "Budget Dimension 1 Code" := '';
      "Budget Dimension 2 Code" := '';
      "Budget Dimension 3 Code" := '';
      "Budget Dimension 4 Code" := '';

      if DimSetEntry.GET("Dimension Set ID",GLSetup."Global Dimension 1 Code") then
        "Global Dimension 1 Code" := DimSetEntry."Dimension Value Code";
      if DimSetEntry.GET("Dimension Set ID",GLSetup."Global Dimension 2 Code") then
        "Global Dimension 2 Code" := DimSetEntry."Dimension Value Code";
      if DimSetEntry.GET("Dimension Set ID",GLBudgetName."Budget Dimension 1 Code") then
        "Budget Dimension 1 Code" := DimSetEntry."Dimension Value Code";
      if DimSetEntry.GET("Dimension Set ID",GLBudgetName."Budget Dimension 2 Code") then
        "Budget Dimension 2 Code" := DimSetEntry."Dimension Value Code";
      if DimSetEntry.GET("Dimension Set ID",GLBudgetName."Budget Dimension 3 Code") then
        "Budget Dimension 3 Code" := DimSetEntry."Dimension Value Code";
      if DimSetEntry.GET("Dimension Set ID",GLBudgetName."Budget Dimension 4 Code") then
        "Budget Dimension 4 Code" := DimSetEntry."Dimension Value Code";

      OnAfterShowDimensions(Rec);
    end;
*/


    
//     procedure UpdateDimSet (var TempDimSetEntry@1003 : TEMPORARY Record 480;DimCode@1000 : Code[20];DimValueCode@1001 :
    
/*
procedure UpdateDimSet (var TempDimSetEntry: Record 480 TEMPORARY;DimCode: Code[20];DimValueCode: Code[20])
    begin
      if DimCode = '' then
        exit;
      if TempDimSetEntry.GET("Dimension Set ID",DimCode) then
        TempDimSetEntry.DELETE;
      if DimValueCode = '' then
        DimVal.INIT
      else
        DimVal.GET(DimCode,DimValueCode);
      TempDimSetEntry.INIT;
      TempDimSetEntry."Dimension Set ID" := "Dimension Set ID";
      TempDimSetEntry."Dimension Code" := DimCode;
      TempDimSetEntry."Dimension Value Code" := DimValueCode;
      TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
      TempDimSetEntry.INSERT;
    end;
*/


//     LOCAL procedure UpdateDimensionSetId (DimCode@1002 : Code[20];DimValueCode@1001 :
    
/*
LOCAL procedure UpdateDimensionSetId (DimCode: Code[20];DimValueCode: Code[20])
    var
//       TempDimSetEntry@1000 :
      TempDimSetEntry: Record 480 TEMPORARY;
    begin
      DimMgt.GetDimensionSet(TempDimSetEntry,"Dimension Set ID");
      UpdateDimSet(TempDimSetEntry,DimCode,DimValueCode);
      OnAfterUpdateDimensionSetId(TempDimSetEntry,Rec,xRec);
      "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;
*/


    
/*
LOCAL procedure DeleteAnalysisViewBudgetEntries ()
    var
//       AnalysisViewBudgetEntry@1000 :
      AnalysisViewBudgetEntry: Record 366;
    begin
      AnalysisViewBudgetEntry.SETRANGE("Budget Name","Budget Name");
      AnalysisViewBudgetEntry.SETRANGE("Entry No.","Entry No.");
      AnalysisViewBudgetEntry.DELETEALL;
    end;
*/


//     LOCAL procedure VerifyNoRelatedAnalysisViewBudgetEntries (GLBudgetEntry@1001 :
    
/*
LOCAL procedure VerifyNoRelatedAnalysisViewBudgetEntries (GLBudgetEntry: Record 96)
    var
//       AnalysisViewBudgetEntry@1000 :
      AnalysisViewBudgetEntry: Record 366;
    begin
      AnalysisViewBudgetEntry.SETRANGE("Budget Name",GLBudgetEntry."Budget Name");
      AnalysisViewBudgetEntry.SETRANGE("G/L Account No.",GLBudgetEntry."G/L Account No.");
      AnalysisViewBudgetEntry.SETRANGE("Posting Date",GLBudgetEntry.Date);
      AnalysisViewBudgetEntry.SETRANGE("Business Unit Code",GLBudgetEntry."Business Unit Code");
      if not AnalysisViewBudgetEntry.ISEMPTY then
        ERROR(AnalysisViewBudgetEntryExistsErr);
    end;
*/


    
//     LOCAL procedure OnAfterShowDimensions (var GLBudgetEntry@1000 :
    
/*
LOCAL procedure OnAfterShowDimensions (var GLBudgetEntry: Record 96)
    begin
    end;
*/


    
//     LOCAL procedure OnAfterUpdateDimensionSetId (var TempDimensionSetEntry@1000 : TEMPORARY Record 480;var GLBudgetEntry@1001 : Record 96;xGLBudgetEntry@1002 :
    
/*
LOCAL procedure OnAfterUpdateDimensionSetId (var TempDimensionSetEntry: Record 480 TEMPORARY;var GLBudgetEntry: Record 96;xGLBudgetEntry: Record 96)
    begin
    end;
*/


    
//     LOCAL procedure OnInsertOnAfterUpdateDimSets (var TempDimensionSetEntry@1000 : TEMPORARY Record 480;var GLBudgetEntry@1001 :
    
/*
LOCAL procedure OnInsertOnAfterUpdateDimSets (var TempDimensionSetEntry: Record 480 TEMPORARY;var GLBudgetEntry: Record 96)
    begin
    end;

    /*begin
    //{
//      CPA 29/03/22: Q16867 - Mejora de rendimiento
//          - Nueva clave: Budget Name,Global Dimension 1 Code,Global Dimension 2 Code,Type,Date
//          - Nueva Clave: Budget Name,Budget Dimension 1 Code,Budget Dimension 2 Code,Type,Date
//          - Nueva clave: Budget Name,Budget Dimension 1 Code,Budget Dimension 2 Code,Global Dimension 2 Code,Date
//    }
    end.
  */
}





