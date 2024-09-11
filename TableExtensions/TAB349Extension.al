tableextension 50174 "QBU Dimension ValueExt" extends "Dimension Value"
{
  
  
    CaptionML=ENU='Dimension Value',ESP='Valor dimensi¢n';
    LookupPageID="Dimension Value List";
  
  fields
{
    field(7174350;"QBU DP Prorrata Non deductible";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No deducible para Prorrata';


    }
    field(7207270;"QBU Type";Option)
    {
        OptionMembers="Expenses","Income","Result";CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='Expenses,Income,Result',ESP='Gastos,Ingresos,Resultados';
                                                   
                                                   Description='QB 1.00 - QB2411   - USO EN CA';


    }
    field(7207271;"QBU Jobs desviation";Code[20])
    {
        TableRelation=Job WHERE ("Status"=CONST("Open"),
                                                                            "Blocked"=CONST(" "),
                                                                            "Job Type"=CONST("Deviations"));
                                                   CaptionML=ENU='Jobs desviation',ESP='Proyecto desviaci¢n';
                                                   Description='QB 1.00 - QB271     - USO EN DEPARTAMENTOS';


    }
    field(7207272;"QBU Jobs Not Assigned";Code[20])
    {
        TableRelation=Job WHERE ("Status"=CONST("Open"),
                                                                            "Blocked"=CONST(" "));
                                                   CaptionML=ENU='Jobs Not Assignes',ESP='Proyecto no asignadas';
                                                   Description='QB 1.00 - QB271     - USO EN DEPARTAMENTOS';


    }
    field(7207273;"QBU Account Budget E Reestimations";Text[20])
    {
        TableRelation="G/L Account" WHERE ("Income/Balance"=FILTER("Income Statement"));
                                                   CaptionML=ENU='Account Budget E Reestimations',ESP='Cuenta ppto y reestimaciones';
                                                   Description='QB 1.00 - QB2415   - USO EN CA';


    }
    field(7207274;"QBU Income by Transfer Job";Code[20])
    {
        TableRelation=Job WHERE ("Status"=CONST("Open"),
                                                                            "Blocked"=CONST(" "));
                                                   CaptionML=ENU='Income by Transfer Job',ESP='Proyecto ingresos por cesi¢n';
                                                   Description='QB 1.00 - QB2713   - USO EN DEPARTAMENTOS';


    }
    field(7207275;"QBU Transfer Analytical Concept";Code[20])
    {
        

                                                   CaptionML=ENU='Concepto analitico cesiones',ESP='Concepto anal¡tico cesiones';
                                                   Description='QB 1.00 - QB2713   - USO EN DEPARTAMENTOS';

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("Transfer Analytical Concept",FALSE);
                                                            END;


    }
    field(7207276;"QBU Transfer Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Cuenta cesiones',ESP='Cuenta cesiones';
                                                   Description='QB 1.00 - QB2713   - USO EN DEPARTAMENTOS';


    }
    field(7207277;"QBU Job Structure Warehouse";Code[20])
    {
        TableRelation=Job WHERE ("Status"=CONST("Open"),
                                                                            "Blocked"=CONST(" "),
                                                                            "Job Type"=CONST("Structure"));
                                                   CaptionML=ENU='Job Structure Warehouse',ESP='Proyecto Estruc. Almac‚n';
                                                   Description='QB 1.00 - QB2517   - USO EN DEPARTAMENTOS';


    }
    field(7207278;"QBU % Planned";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Milestone Costs Planning"."Percentage" WHERE ("Job No."=FIELD("Job Filter"),
                                                                                                                "Concept Code"=FIELD("Code")));
                                                   CaptionML=ENU='% Planned',ESP='% Planificado';
                                                   Description='QB 1.00 - QB2412   - USO EN Page 7207468';


    }
    field(7207279;"QBU Job Filter";Code[20])
    {
        FieldClass=FlowFilter;
                                                   
                                                   TableRelation="Job";
                                                   CaptionML=ENU='Job Filter',ESP='Filtro proyecto';
                                                   Description='QB 1.00 - QB2412   - USO EN CA';


    }
    field(7207280;"QBU Reestimation Date";Date)
    {
        CaptionML=ENU='Reestimation Date',ESP='Fecha reestimaci¢n';
                                                   Description='QB 1.00 - QB2418   - USO EN REESTIMACIONES';


    }
    field(7207281;"QBU Cash MGT Rule Code";Code[10])
    {
        CaptionML=ENU='Cash MGT Rule Code',ESP='Cod. regla tesorer¡a';
                                                   Description='QB 1.00                 - USO EN CA';


    }
    field(7207282;"QBU VAT Prod. Posting Group";Code[20])
    {
        TableRelation="VAT Product Posting Group";
                                                   CaptionML=ENU='VAT Prod. Posting Group',ESP='Grupo registro IVA prod.';
                                                   Description='QB 1.00                 - USO EN CA                              QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


    }
    field(7207283;"QBU Department";Code[20])
    {
        TableRelation="QB Department" WHERE ("Type"=CONST("Standard"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Organization Department',ESP='Departamento Organizativo';
                                                   Description='QB 1.10.54 JAV 25/06/22: - [TT] Indica que departamento de la estructura organizativa de la empresa est  asociado a este valor de dimensi¢n' ;


    }
}
  keys
{
   // key(key1;"Dimension Code","Code")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Code","Global Dimension No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"Code","Name")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='%1\You cannot delete it.',ESP='%1\No puede borrarla.';
//       Text002@1002 :
      Text002: TextConst ENU='(CONFLICT)',ESP='(CONFLICTO)';
//       Text003@1003 :
      Text003: TextConst ENU='%1 can not be (CONFLICT). This name is used internally by the system.',ESP='%1 no puede ser (CONFLICTO). Este nombre se usa interna. por el sist.';
//       Text004@1004 :
      Text004: TextConst ENU='%1\You cannot change the type.',ESP='%1\No puede cambiar el tipo.';
//       Text005@1005 :
      Text005: TextConst ENU='This dimension value has been used in posted or budget entries.',ESP='Esta dim. valor se ha usado en movs. registrados o presupuestad.';
//       DimSetEntry@1001 :
      DimSetEntry: Record 480;
//       DimValueComb@1014 :
      DimValueComb: Record 351;
//       DefaultDim@1015 :
      DefaultDim: Record 352;
//       SelectedDim@1016 :
      SelectedDim: Record 369;
//       AnalysisSelectedDim@1021 :
      AnalysisSelectedDim: Record 7159;
//       CostAccSetup@1008 :
      CostAccSetup: Record 1108;
//       CostAccMgt@1007 :
      CostAccMgt: Codeunit 1100;
//       Text006@1006 :
      Text006: TextConst ENU='You cannot change the value of %1.',ESP='No puede cambiar el valor de %1.';

    
    


/*
trigger OnInsert();    begin
               TESTFIELD("Dimension Code");
               TESTFIELD(Code);
               "Global Dimension No." := GetGlobalDimensionNo;

               if CostAccSetup.GET then begin
                 CostAccMgt.UpdateCostCenterFromDim(Rec,Rec,0);
                 CostAccMgt.UpdateCostObjectFromDim(Rec,Rec,0);
               end;

               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnModify();    begin
               if "Dimension Code" <> xRec."Dimension Code" then
                 "Global Dimension No." := GetGlobalDimensionNo;
               if CostAccSetup.GET then begin
                 CostAccMgt.UpdateCostCenterFromDim(Rec,xRec,1);
                 CostAccMgt.UpdateCostObjectFromDim(Rec,xRec,1);
               end;

               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnDelete();    begin
               if CheckIfDimValueUsed then
                 ERROR(Text000,GetCheckDimErr);

               DimValueComb.SETRANGE("Dimension 1 Code","Dimension Code");
               DimValueComb.SETRANGE("Dimension 1 Value Code",Code);
               DimValueComb.DELETEALL(TRUE);

               DimValueComb.RESET;
               DimValueComb.SETRANGE("Dimension 2 Code","Dimension Code");
               DimValueComb.SETRANGE("Dimension 2 Value Code",Code);
               DimValueComb.DELETEALL(TRUE);

               DefaultDim.SETRANGE("Dimension Code","Dimension Code");
               DefaultDim.SETRANGE("Dimension Value Code",Code);
               DefaultDim.DELETEALL(TRUE);

               SelectedDim.SETRANGE("Dimension Code","Dimension Code");
               SelectedDim.SETRANGE("New Dimension Value Code",Code);
               SelectedDim.DELETEALL(TRUE);

               AnalysisSelectedDim.SETRANGE("Dimension Code","Dimension Code");
               AnalysisSelectedDim.SETRANGE("New Dimension Value Code",Code);
               AnalysisSelectedDim.DELETEALL(TRUE);
             end;


*/

/*
trigger OnRename();    begin
               RenameBudgEntryDim;
               RenameAnalysisViewEntryDim;
               RenameItemBudgEntryDim;
               RenameItemAnalysisViewEntryDim;

               if CostAccSetup.GET then begin
                 CostAccMgt.UpdateCostCenterFromDim(Rec,xRec,3);
                 CostAccMgt.UpdateCostObjectFromDim(Rec,xRec,3);
               end;

               SetLastModifiedDateTime;
             end;

*/




/*
procedure CheckIfDimValueUsed () : Boolean;
    begin
      DimSetEntry.SETCURRENTKEY("Dimension Value ID");
      DimSetEntry.SETRANGE("Dimension Value ID","Dimension Value ID");
      exit(not DimSetEntry.ISEMPTY);
    end;
*/


    
/*
LOCAL procedure GetCheckDimErr () : Text[250];
    begin
      exit(Text005);
    end;
*/


    
/*
LOCAL procedure RenameBudgEntryDim ()
    var
//       GLBudget@1002 :
      GLBudget: Record 95;
//       GLBudgetEntry@1003 :
      GLBudgetEntry: Record 96;
//       GLBudgetEntry2@1001 :
      GLBudgetEntry2: Record 96;
//       BudgDimNo@1000 :
      BudgDimNo: Integer;
    begin
      GLBudget.LOCKTABLE;
      if GLBudget.FIND('-') then
        repeat
        until GLBudget.NEXT = 0;
      FOR BudgDimNo := 1 TO 4 DO begin
        CASE TRUE OF
          BudgDimNo = 1:
            GLBudget.SETRANGE("Budget Dimension 1 Code","Dimension Code");
          BudgDimNo = 2:
            GLBudget.SETRANGE("Budget Dimension 2 Code","Dimension Code");
          BudgDimNo = 3:
            GLBudget.SETRANGE("Budget Dimension 3 Code","Dimension Code");
          BudgDimNo = 4:
            GLBudget.SETRANGE("Budget Dimension 4 Code","Dimension Code");
        end;
        if GLBudget.FIND('-') then begin
          GLBudgetEntry.SETCURRENTKEY("Budget Name","G/L Account No.","Business Unit Code","Global Dimension 1 Code");
          repeat
            GLBudgetEntry.SETRANGE("Budget Name",GLBudget.Name);
            CASE TRUE OF
              BudgDimNo = 1:
                GLBudgetEntry.SETRANGE("Budget Dimension 1 Code",xRec.Code);
              BudgDimNo = 2:
                GLBudgetEntry.SETRANGE("Budget Dimension 2 Code",xRec.Code);
              BudgDimNo = 3:
                GLBudgetEntry.SETRANGE("Budget Dimension 3 Code",xRec.Code);
              BudgDimNo = 4:
                GLBudgetEntry.SETRANGE("Budget Dimension 4 Code",xRec.Code);
            end;
            if GLBudgetEntry.FIND('-') then
              repeat
                GLBudgetEntry2 := GLBudgetEntry;
                CASE TRUE OF
                  BudgDimNo = 1:
                    GLBudgetEntry2."Budget Dimension 1 Code" := Code;
                  BudgDimNo = 2:
                    GLBudgetEntry2."Budget Dimension 2 Code" := Code;
                  BudgDimNo = 3:
                    GLBudgetEntry2."Budget Dimension 3 Code" := Code;
                  BudgDimNo = 4:
                    GLBudgetEntry2."Budget Dimension 4 Code" := Code;
                end;
                GLBudgetEntry2.MODIFY;
              until GLBudgetEntry.NEXT = 0;
            GLBudgetEntry.RESET;
          until GLBudget.NEXT = 0;
        end;
        GLBudget.RESET;
      end;
    end;
*/


    
/*
LOCAL procedure RenameAnalysisViewEntryDim ()
    var
//       AnalysisView@1001 :
      AnalysisView: Record 363;
//       AnalysisViewEntry@1002 :
      AnalysisViewEntry: Record 365;
//       AnalysisViewEntry2@1003 :
      AnalysisViewEntry2: Record 365;
//       AnalysisViewBudgEntry@1004 :
      AnalysisViewBudgEntry: Record 366;
//       AnalysisViewBudgEntry2@1005 :
      AnalysisViewBudgEntry2: Record 366;
//       DimensionNo@1000 :
      DimensionNo: Integer;
    begin
      AnalysisView.LOCKTABLE;
      if AnalysisView.FIND('-') then
        repeat
        until AnalysisView.NEXT = 0;

      FOR DimensionNo := 1 TO 4 DO begin
        CASE TRUE OF
          DimensionNo = 1:
            AnalysisView.SETRANGE("Dimension 1 Code","Dimension Code");
          DimensionNo = 2:
            AnalysisView.SETRANGE("Dimension 2 Code","Dimension Code");
          DimensionNo = 3:
            AnalysisView.SETRANGE("Dimension 3 Code","Dimension Code");
          DimensionNo = 4:
            AnalysisView.SETRANGE("Dimension 4 Code","Dimension Code");
        end;
        if AnalysisView.FIND('-') then
          repeat
            AnalysisViewEntry.SETRANGE("Analysis View Code",AnalysisView.Code);
            AnalysisViewBudgEntry.SETRANGE("Analysis View Code",AnalysisView.Code);
            CASE TRUE OF
              DimensionNo = 1:
                begin
                  AnalysisViewEntry.SETRANGE("Dimension 1 Value Code",xRec.Code);
                  AnalysisViewBudgEntry.SETRANGE("Dimension 1 Value Code",xRec.Code);
                end;
              DimensionNo = 2:
                begin
                  AnalysisViewEntry.SETRANGE("Dimension 2 Value Code",xRec.Code);
                  AnalysisViewBudgEntry.SETRANGE("Dimension 2 Value Code",xRec.Code);
                end;
              DimensionNo = 3:
                begin
                  AnalysisViewEntry.SETRANGE("Dimension 3 Value Code",xRec.Code);
                  AnalysisViewBudgEntry.SETRANGE("Dimension 3 Value Code",xRec.Code);
                end;
              DimensionNo = 4:
                begin
                  AnalysisViewEntry.SETRANGE("Dimension 4 Value Code",xRec.Code);
                  AnalysisViewBudgEntry.SETRANGE("Dimension 4 Value Code",xRec.Code);
                end;
            end;
            if AnalysisViewEntry.FIND('-') then
              repeat
                AnalysisViewEntry2 := AnalysisViewEntry;
                CASE TRUE OF
                  DimensionNo = 1:
                    AnalysisViewEntry2."Dimension 1 Value Code" := Code;
                  DimensionNo = 2:
                    AnalysisViewEntry2."Dimension 2 Value Code" := Code;
                  DimensionNo = 3:
                    AnalysisViewEntry2."Dimension 3 Value Code" := Code;
                  DimensionNo = 4:
                    AnalysisViewEntry2."Dimension 4 Value Code" := Code;
                end;
                AnalysisViewEntry.DELETE;
                AnalysisViewEntry2.INSERT;
              until AnalysisViewEntry.NEXT = 0;
            AnalysisViewEntry.RESET;
            if AnalysisViewBudgEntry.FIND('-') then
              repeat
                AnalysisViewBudgEntry2 := AnalysisViewBudgEntry;
                CASE TRUE OF
                  DimensionNo = 1:
                    AnalysisViewBudgEntry2."Dimension 1 Value Code" := Code;
                  DimensionNo = 2:
                    AnalysisViewBudgEntry2."Dimension 2 Value Code" := Code;
                  DimensionNo = 3:
                    AnalysisViewBudgEntry2."Dimension 3 Value Code" := Code;
                  DimensionNo = 4:
                    AnalysisViewBudgEntry2."Dimension 4 Value Code" := Code;
                end;
                AnalysisViewBudgEntry.DELETE;
                AnalysisViewBudgEntry2.INSERT;
              until AnalysisViewBudgEntry.NEXT = 0;
            AnalysisViewBudgEntry.RESET;
          until AnalysisView.NEXT = 0;
        AnalysisView.RESET;
      end;
    end;
*/


    
/*
LOCAL procedure RenameItemBudgEntryDim ()
    var
//       ItemBudget@1003 :
      ItemBudget: Record 7132;
//       ItemBudgetEntry@1002 :
      ItemBudgetEntry: Record 7134;
//       ItemBudgetEntry2@1001 :
      ItemBudgetEntry2: Record 7134;
//       BudgDimNo@1000 :
      BudgDimNo: Integer;
    begin
      ItemBudget.LOCKTABLE;
      if ItemBudget.FIND('-') then
        repeat
        until ItemBudget.NEXT = 0;

      FOR BudgDimNo := 1 TO 3 DO begin
        CASE TRUE OF
          BudgDimNo = 1:
            ItemBudget.SETRANGE("Budget Dimension 1 Code","Dimension Code");
          BudgDimNo = 2:
            ItemBudget.SETRANGE("Budget Dimension 2 Code","Dimension Code");
          BudgDimNo = 3:
            ItemBudget.SETRANGE("Budget Dimension 3 Code","Dimension Code");
        end;
        if ItemBudget.FIND('-') then begin
          ItemBudgetEntry.SETCURRENTKEY(
            "Analysis Area","Budget Name","Item No.","Source Type","Source No.",Date,"Location Code","Global Dimension 1 Code");
          repeat
            ItemBudgetEntry.SETRANGE("Analysis Area",ItemBudget."Analysis Area");
            ItemBudgetEntry.SETRANGE("Budget Name",ItemBudget.Name);
            CASE TRUE OF
              BudgDimNo = 1:
                ItemBudgetEntry.SETRANGE("Budget Dimension 1 Code",xRec.Code);
              BudgDimNo = 2:
                ItemBudgetEntry.SETRANGE("Budget Dimension 2 Code",xRec.Code);
              BudgDimNo = 3:
                ItemBudgetEntry.SETRANGE("Budget Dimension 3 Code",xRec.Code);
            end;
            if ItemBudgetEntry.FIND('-') then
              repeat
                ItemBudgetEntry2 := ItemBudgetEntry;
                CASE TRUE OF
                  BudgDimNo = 1:
                    ItemBudgetEntry2."Budget Dimension 1 Code" := Code;
                  BudgDimNo = 2:
                    ItemBudgetEntry2."Budget Dimension 2 Code" := Code;
                  BudgDimNo = 3:
                    ItemBudgetEntry2."Budget Dimension 3 Code" := Code;
                end;
                ItemBudgetEntry2.MODIFY;
              until ItemBudgetEntry.NEXT = 0;
            ItemBudgetEntry.RESET;
          until ItemBudget.NEXT = 0;
        end;
        ItemBudget.RESET;
      end;
    end;
*/


    
/*
LOCAL procedure RenameItemAnalysisViewEntryDim ()
    var
//       ItemAnalysisView@1005 :
      ItemAnalysisView: Record 7152;
//       ItemAnalysisViewEntry@1004 :
      ItemAnalysisViewEntry: Record 7154;
//       ItemAnalysisViewEntry2@1003 :
      ItemAnalysisViewEntry2: Record 7154;
//       ItemAnalysisViewBudgEntry@1002 :
      ItemAnalysisViewBudgEntry: Record 7156;
//       ItemAnalysisViewBudgEntry2@1001 :
      ItemAnalysisViewBudgEntry2: Record 7156;
//       DimensionNo@1000 :
      DimensionNo: Integer;
    begin
      ItemAnalysisView.LOCKTABLE;
      if ItemAnalysisView.FIND('-') then
        repeat
        until ItemAnalysisView.NEXT = 0;

      FOR DimensionNo := 1 TO 3 DO begin
        CASE TRUE OF
          DimensionNo = 1:
            ItemAnalysisView.SETRANGE("Dimension 1 Code","Dimension Code");
          DimensionNo = 2:
            ItemAnalysisView.SETRANGE("Dimension 2 Code","Dimension Code");
          DimensionNo = 3:
            ItemAnalysisView.SETRANGE("Dimension 3 Code","Dimension Code");
        end;
        if ItemAnalysisView.FIND('-') then
          repeat
            ItemAnalysisViewEntry.SETRANGE("Analysis Area",ItemAnalysisView."Analysis Area");
            ItemAnalysisViewEntry.SETRANGE("Analysis View Code",ItemAnalysisView.Code);
            ItemAnalysisViewBudgEntry.SETRANGE("Analysis Area",ItemAnalysisView."Analysis Area");
            ItemAnalysisViewBudgEntry.SETRANGE("Analysis View Code",ItemAnalysisView.Code);
            CASE TRUE OF
              DimensionNo = 1:
                begin
                  ItemAnalysisViewEntry.SETRANGE("Dimension 1 Value Code",xRec.Code);
                  ItemAnalysisViewBudgEntry.SETRANGE("Dimension 1 Value Code",xRec.Code);
                end;
              DimensionNo = 2:
                begin
                  ItemAnalysisViewEntry.SETRANGE("Dimension 2 Value Code",xRec.Code);
                  ItemAnalysisViewBudgEntry.SETRANGE("Dimension 2 Value Code",xRec.Code);
                end;
              DimensionNo = 3:
                begin
                  ItemAnalysisViewEntry.SETRANGE("Dimension 3 Value Code",xRec.Code);
                  ItemAnalysisViewBudgEntry.SETRANGE("Dimension 3 Value Code",xRec.Code);
                end;
            end;
            if ItemAnalysisViewEntry.FIND('-') then
              repeat
                ItemAnalysisViewEntry2 := ItemAnalysisViewEntry;
                CASE TRUE OF
                  DimensionNo = 1:
                    ItemAnalysisViewEntry2."Dimension 1 Value Code" := Code;
                  DimensionNo = 2:
                    ItemAnalysisViewEntry2."Dimension 2 Value Code" := Code;
                  DimensionNo = 3:
                    ItemAnalysisViewEntry2."Dimension 3 Value Code" := Code;
                end;
                ItemAnalysisViewEntry.DELETE;
                ItemAnalysisViewEntry2.INSERT;
              until ItemAnalysisViewEntry.NEXT = 0;
            ItemAnalysisViewEntry.RESET;
            if ItemAnalysisViewBudgEntry.FIND('-') then
              repeat
                ItemAnalysisViewBudgEntry2 := ItemAnalysisViewBudgEntry;
                CASE TRUE OF
                  DimensionNo = 1:
                    ItemAnalysisViewBudgEntry2."Dimension 1 Value Code" := Code;
                  DimensionNo = 2:
                    ItemAnalysisViewBudgEntry2."Dimension 2 Value Code" := Code;
                  DimensionNo = 3:
                    ItemAnalysisViewBudgEntry2."Dimension 3 Value Code" := Code;
                end;
                ItemAnalysisViewBudgEntry.DELETE;
                ItemAnalysisViewBudgEntry2.INSERT;
              until ItemAnalysisViewBudgEntry.NEXT = 0;
            ItemAnalysisViewBudgEntry.RESET;
          until ItemAnalysisView.NEXT = 0;
        ItemAnalysisView.RESET;
      end;
    end;
*/


    
//     procedure LookUpDimFilter (Dim@1000 : Code[20];var Text@1001 :
    
/*
procedure LookUpDimFilter (Dim: Code[20];var Text: Text) : Boolean;
    var
//       DimVal@1002 :
      DimVal: Record 349;
//       DimValList@1003 :
      DimValList: Page 560;
    begin
      if Dim = '' then
        exit(FALSE);
      DimValList.LOOKUPMODE(TRUE);
      DimVal.SETRANGE("Dimension Code",Dim);
      DimValList.SETTABLEVIEW(DimVal);
      if DimValList.RUNMODAL = ACTION::LookupOK then begin
        Text := DimValList.GetSelectionFilter;
        exit(TRUE);
      end;
      exit(FALSE)
    end;
*/


    
//     procedure LookupDimValue (DimCode@1000 : Code[20];var DimValueCode@1001 :
    
/*
procedure LookupDimValue (DimCode: Code[20];var DimValueCode: Code[20])
    var
//       DimValue@1003 :
      DimValue: Record 349;
//       DimValuesList@1002 :
      DimValuesList: Page 537;
    begin
      DimValue.SETRANGE("Dimension Code",DimCode);
      DimValuesList.LOOKUPMODE := TRUE;
      DimValuesList.SETTABLEVIEW(DimValue);
      if DimValue.GET(DimCode,DimValueCode) then
        DimValuesList.SETRECORD(DimValue);
      if DimValuesList.RUNMODAL = ACTION::LookupOK then begin
        DimValuesList.GETRECORD(DimValue);
        DimValueCode := DimValue.Code;
      end;
    end;
*/


    
/*
LOCAL procedure GetGlobalDimensionNo () : Integer;
    var
//       GeneralLedgerSetup@1000 :
      GeneralLedgerSetup: Record 98;
    begin
      GeneralLedgerSetup.GET;
      CASE "Dimension Code" OF
        GeneralLedgerSetup."Global Dimension 1 Code":
          exit(1);
        GeneralLedgerSetup."Global Dimension 2 Code":
          exit(2);
        GeneralLedgerSetup."Shortcut Dimension 3 Code":
          exit(3);
        GeneralLedgerSetup."Shortcut Dimension 4 Code":
          exit(4);
        GeneralLedgerSetup."Shortcut Dimension 5 Code":
          exit(5);
        GeneralLedgerSetup."Shortcut Dimension 6 Code":
          exit(6);
        GeneralLedgerSetup."Shortcut Dimension 7 Code":
          exit(7);
        GeneralLedgerSetup."Shortcut Dimension 8 Code":
          exit(8);
        else
          exit(0);
      end;
    end;
*/


    
/*
LOCAL procedure SetLastModifiedDateTime ()
    begin
      "Last Modified Date Time" := CURRENTDATETIME;
    end;
*/


    
/*
LOCAL procedure UpdateMapToICDimensionCode ()
    var
//       Dimension@1000 :
      Dimension: Record 348;
    begin
      Dimension.GET("Dimension Code");
      VALIDATE("Map-to IC Dimension Code",Dimension."Map-to IC Dimension Code");
    end;

    /*begin
    //{
//      JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
//                                    7174350 "DP Prorrata Non deductible", indica que la actividad relacionada con esta dimensi¢n no es deducible en la prorrata
//    }
    end.
  */
}





