tableextension 50123 "MyExtension50123" extends "Acc. Schedule Line"
{
  
  
    CaptionML=ENU='Acc. Schedule Line',ESP='L¡n. esquema cuentas';
  
  fields
{
    field(7207270;"Analytic Concept";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='Analytic Concept',ESP='Concepto anal¡tico'; ;

trigger OnLookup();
    VAR
//                                                               AccScheduleLine@7001100 :
                                                              AccScheduleLine: Record 85;
//                                                               FunctionQB@100000000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("Analytic Concept", FALSE);
                                                            END;


    }
}
  keys
{
   // key(key1;"Schedule Name","Line No.")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       ForceUnderLineMsg@1022 :
      ForceUnderLineMsg: 
// "%1= Field underline "
TextConst ENU='%1 will be set to false.',ESP='%1 se establecer  en False.';
//       Text000@1000 :
      Text000: TextConst ENU='Default Schedule',ESP='Previsi¢n gen‚r.';
//       Text001@1001 :
      Text001: TextConst ENU='The parenthesis at position %1 is misplaced.',ESP='El par‚ntesis en la posici¢n %1 es incorrecto.';
//       Text002@1002 :
      Text002: TextConst ENU='You cannot have two consecutive operators. The error occurred at position %1.',ESP='No se puede tener dos operaciones consecutivas. Revise la posici¢n %1.';
//       Text003@1003 :
      Text003: TextConst ENU='There is an operand missing after position %1.',ESP='Falta un operando despu‚s de la posici¢n %1.';
//       Text004@1004 :
      Text004: TextConst ENU='There are more left parentheses than right parentheses.',ESP='Hay m s par‚ntesis de apertura que de cierre.';
//       Text005@1005 :
      Text005: TextConst ENU='There are more right parentheses than left parentheses.',ESP='Hay m s par‚ntesis de cierre que de apertura.';
//       Text006@1006 :
      Text006: TextConst ENU='1,6,,Dimension 1 Filter',ESP='1,6,,Filtro dimensi¢n 1';
//       Text007@1007 :
      Text007: TextConst ENU='1,6,,Dimension 2 Filter',ESP='1,6,,Filtro dimensi¢n 2';
//       Text008@1008 :
      Text008: TextConst ENU='1,6,,Dimension 3 Filter',ESP='1,6,,Filtro dimensi¢n 3';
//       Text009@1009 :
      Text009: TextConst ENU='1,6,,Dimension 4 Filter',ESP='1,6,,Filtro dimensi¢n 4';
//       Text010@1010 :
      Text010: TextConst ENU=',, Totaling',ESP=',, Totales';
//       Text011@1011 :
      Text011: TextConst ENU='1,5,,Dimension 1 Totaling',ESP='1,5,,Total dimensi¢n 1';
//       Text012@1012 :
      Text012: TextConst ENU='1,5,,Dimension 2 Totaling',ESP='1,5,,Total dimensi¢n 2';
//       Text013@1013 :
      Text013: TextConst ENU='1,5,,Dimension 3 Totaling',ESP='1,5,,Total dimensi¢n 3';
//       Text014@1014 :
      Text014: TextConst ENU='1,5,,Dimension 4 Totaling',ESP='1,5,,Total dimensi¢n 4';
//       AccSchedName@1015 :
      AccSchedName: Record 84;
//       GLAcc@1016 :
      GLAcc: Record 15;
//       CFAccount@1841 :
      CFAccount: Record 841;
//       AnalysisView@1017 :
      AnalysisView: Record 363;
//       GLSetup@1018 :
      GLSetup: Record 98;
//       CostType@1021 :
      CostType: Record 1103;
//       HasGLSetup@1019 :
      HasGLSetup: Boolean;
//       Text015@1020 :
      Text015: TextConst ENU='The %1 refers to %2 %3, which does not exist. The field %4 on table %5 has now been deleted.',ESP='El %1 se refiere a %2 %3, que no existe. El campo %4 en la tabla %5 ha sido borrado.';

    
    


/*
trigger OnInsert();    begin
               if xRec."Line No." = 0 then
                 if not AccSchedName.GET("Schedule Name") then begin
                   AccSchedName.INIT;
                   AccSchedName.Name := "Schedule Name";
                   if AccSchedName.Name = '' then
                     AccSchedName.Description := Text000;
                   AccSchedName.INSERT;
                 end;
             end;

*/



// procedure LookUpDimFilter (DimNo@1000 : Integer;var Text@1001 :

/*
procedure LookUpDimFilter (DimNo: Integer;var Text: Text) : Boolean;
    var
//       DimVal@1002 :
      DimVal: Record 349;
//       DimValList@1003 :
      DimValList: Page 560;
    begin
      GetAccSchedSetup;
      CASE DimNo OF
        1:
          DimVal.SETRANGE("Dimension Code",AnalysisView."Dimension 1 Code");
        2:
          DimVal.SETRANGE("Dimension Code",AnalysisView."Dimension 2 Code");
        3:
          DimVal.SETRANGE("Dimension Code",AnalysisView."Dimension 3 Code");
        4:
          DimVal.SETRANGE("Dimension Code",AnalysisView."Dimension 4 Code");
      end;

      DimValList.LOOKUPMODE(TRUE);
      DimValList.SETTABLEVIEW(DimVal);
      if DimValList.RUNMODAL = ACTION::LookupOK then begin
        DimValList.GETRECORD(DimVal);
        Text := DimValList.GetSelectionFilter;
        exit(TRUE);
      end;
      exit(FALSE)
    end;
*/


    
//     procedure CheckFormula (Formula@1000 :
    
/*
procedure CheckFormula (Formula: Code[250])
    var
//       i@1001 :
      i: Integer;
//       ParenthesesLevel@1002 :
      ParenthesesLevel: Integer;
//       HasOperator@1003 :
      HasOperator: Boolean;
    begin
      ParenthesesLevel := 0;
      FOR i := 1 TO STRLEN(Formula) DO begin
        if Formula[i] = '(' then
          ParenthesesLevel := ParenthesesLevel + 1
        else
          if Formula[i] = ')' then
            ParenthesesLevel := ParenthesesLevel - 1;
        if ParenthesesLevel < 0 then
          ERROR(Text001,i);
        if Formula[i] IN ['+','-','*','/','^'] then begin
          if HasOperator then
            ERROR(Text002,i);

          HasOperator := TRUE;

          if i = STRLEN(Formula) then
            ERROR(Text003,i);

          if Formula[i + 1] = ')' then
            ERROR(Text003,i);
        end else
          HasOperator := FALSE;
      end;
      if ParenthesesLevel > 0 then
        ERROR(Text004);

      if ParenthesesLevel < 0 then
        ERROR(Text005);
    end;
*/


    
//     procedure GetCaptionClass (AnalysisViewDimType@1000 :
    
/*
procedure GetCaptionClass (AnalysisViewDimType: Integer) : Text[250];
    begin
      GetAccSchedSetup;
      CASE AnalysisViewDimType OF
        1:
          begin
            if AnalysisView."Dimension 1 Code" <> '' then
              exit('1,6,' + AnalysisView."Dimension 1 Code");

            exit(Text006);
          end;
        2:
          begin
            if AnalysisView."Dimension 2 Code" <> '' then
              exit('1,6,' + AnalysisView."Dimension 2 Code");

            exit(Text007);
          end;
        3:
          begin
            if AnalysisView."Dimension 3 Code" <> '' then
              exit('1,6,' + AnalysisView."Dimension 3 Code");

            exit(Text008);
          end;
        4:
          begin
            if AnalysisView."Dimension 4 Code" <> '' then
              exit('1,6,' + AnalysisView."Dimension 4 Code");

            exit(Text009);
          end;
        5:
          begin
            if AnalysisView."Dimension 1 Code" <> '' then
              exit('1,5,' + AnalysisView."Dimension 1 Code" + Text010);

            exit(Text011);
          end;
        6:
          begin
            if AnalysisView."Dimension 2 Code" <> '' then
              exit('1,5,' + AnalysisView."Dimension 2 Code" + Text010);

            exit(Text012);
          end;
        7:
          begin
            if AnalysisView."Dimension 3 Code" <> '' then
              exit('1,5,' + AnalysisView."Dimension 3 Code" + Text010);

            exit(Text013);
          end;
        8:
          begin
            if AnalysisView."Dimension 4 Code" <> '' then
              exit('1,5,' + AnalysisView."Dimension 4 Code" + Text010);

            exit(Text014);
          end;
      end;
    end;
*/


    
/*
LOCAL procedure GetAccSchedSetup ()
    begin
      if "Schedule Name" <> AccSchedName.Name then
        AccSchedName.GET("Schedule Name");
      if AccSchedName."Analysis View Name" <> '' then
        if AccSchedName."Analysis View Name" <> AnalysisView.Code then
          if not AnalysisView.GET(AccSchedName."Analysis View Name") then begin
            MESSAGE(
              Text015,
              AccSchedName.TABLECAPTION,AnalysisView.TABLECAPTION,AccSchedName."Analysis View Name",
              AccSchedName.FIELDCAPTION("Analysis View Name"),AccSchedName.TABLECAPTION);
            AccSchedName."Analysis View Name" := '';
            AccSchedName.MODIFY;
          end;

      if AccSchedName."Analysis View Name" = '' then begin
        if not HasGLSetup then begin
          GLSetup.GET;
          HasGLSetup := TRUE;
        end;
        CLEAR(AnalysisView);
        AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
        AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
      end;
    end;
*/


    
/*
LOCAL procedure LookupTotaling ()
    var
//       AccSchedName@1100000 :
      AccSchedName: Record 84;
//       GLAccList@1000 :
      GLAccList: Page 18;
//       CostTypeList@1001 :
      CostTypeList: Page 1124;
//       CFAccList@1002 :
      CFAccList: Page 855;
//       IsHandled@1003 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeLookupTotaling(Rec,IsHandled);
      if IsHandled then
        exit;

      CASE "Totaling Type" OF
        "Totaling Type"::"Posting Accounts",
        "Totaling Type"::"Total Accounts":
          if AccSchedName.GET("Schedule Name") then begin
            GLAccList.LOOKUPMODE(TRUE);
            if GLAccList.RUNMODAL = ACTION::LookupOK then
              VALIDATE(Totaling,GLAccList.GetSelectionFilter);
          end;
        "Totaling Type"::"Cost Type",
        "Totaling Type"::"Cost Type Total":
          begin
            CostTypeList.LOOKUPMODE(TRUE);
            if CostTypeList.RUNMODAL = ACTION::LookupOK then
              VALIDATE(Totaling,CostTypeList.GetSelectionFilter);
          end;
        "Totaling Type"::"Cash Flow Entry Accounts",
        "Totaling Type"::"Cash Flow Total Accounts":
          begin
            CFAccList.LOOKUPMODE(TRUE);
            if CFAccList.RUNMODAL = ACTION::LookupOK then
              VALIDATE(Totaling,CFAccList.GetSelectionFilter);
          end;
      end;

      OnAfterLookupTotaling(Rec);
    end;
*/


    
//     procedure LookupGLBudgetFilter (var Text@1000 :
    
/*
procedure LookupGLBudgetFilter (var Text: Text) : Boolean;
    var
//       GLBudgetNames@1001 :
      GLBudgetNames: Page 121;
    begin
      GLBudgetNames.LOOKUPMODE(TRUE);
      if GLBudgetNames.RUNMODAL = ACTION::LookupOK then begin
        Text := GLBudgetNames.GetSelectionFilter;
        exit(TRUE);
      end;
      exit(FALSE)
    end;
*/


    
//     procedure LookupCostBudgetFilter (var Text@1000 :
    
/*
procedure LookupCostBudgetFilter (var Text: Text) : Boolean;
    var
//       CostBudgetNames@1001 :
      CostBudgetNames: Page 1116;
    begin
      CostBudgetNames.LOOKUPMODE(TRUE);
      if CostBudgetNames.RUNMODAL = ACTION::LookupOK then begin
        Text := CostBudgetNames.GetSelectionFilter;
        exit(TRUE);
      end;
      exit(FALSE)
    end;
*/


    
    
/*
procedure Indent ()
    begin
      if Indentation < 10 then
        Indentation += 1;
    end;
*/


    
    
/*
procedure Outdent ()
    begin
      if Indentation > 0 then
        Indentation -= 1;
    end;
*/


    
//     LOCAL procedure OnAfterLookupTotaling (var AccScheduleLine@1000 :
    
/*
LOCAL procedure OnAfterLookupTotaling (var AccScheduleLine: Record 85)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeLookupTotaling (var AccScheduleLine@1000 : Record 85;var IsHandled@1001 :
    
/*
LOCAL procedure OnBeforeLookupTotaling (var AccScheduleLine: Record 85;var IsHandled: Boolean)
    begin
    end;

    /*begin
    end.
  */
}




