tableextension 50173 "QBU DimensionExt" extends "Dimension"
{
  
  DataCaptionFields="Code","Name";
    CaptionML=ENU='Dimension',ESP='Dimensi¢n';
    LookupPageID="Dimension List";
    DrillDownPageID="Dimension List";
  
  fields
{
    field(7207270;"QBU Not for Job";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='No usar en Proyecto';
                                                   Description='QB 1.06.15 - JAV 25/09/20: - [TT] Indica que esta dimensi¢n no se puede usar en los proyectos directa o indirectamente' ;


    }
}
  keys
{
   // key(key1;"Code")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"Code","Name","Blocked")
   // {
       // 
   // }
   // fieldgroup(Brick;"Code","Name")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='%1\This dimension is also used in posted or budget entries.\You cannot delete it.',ESP='%1\Esta dimensi¢n se usa tambi‚n al registrar ¢ presup. movs.\No puede borrarla.';
//       Text001@1001 :
      Text001: TextConst ENU='%1\You cannot delete it.',ESP='%1\No puede borrarla.';
//       Text002@1002 :
      Text002: TextConst ENU='You cannot delete this dimension value, because it has been used in one or more documents or budget entries.',ESP='No puede eliminar este valor de dimensi¢n, porque se ha usado en uno o varios documentos o mov. de presupuestos.';
//       Text006@1006 :
      Text006: TextConst ENU='Period',ESP='Periodo';
//       Text007@1007 :
      Text007: TextConst ENU='%1 can not be %2, %3, %4, %5 or Period. These names are used internally by the system.',ESP='%1 no puede ser %2, %3, %4, %5 ni periodo. Son nombres internos del sistema.';
//       Text008@1008 :
      Text008: TextConst ENU='Code',ESP='C¢digo';
//       Text009@1009 :
      Text009: TextConst ENU='Filter',ESP='Filtro';
//       Text010@1010 :
      Text010: TextConst ENU='This dimension is used in the following setup: ',ESP='Esta dimensi¢n se usa en la siguiente config.: ';
//       Text011@1011 :
      Text011: TextConst ENU='General Ledger Setup, ',ESP='Config. contabilidad, ';
//       Text012@1012 :
      Text012: TextConst ENU='G/L Budget Names, ',ESP='Nombres ppto., ';
//       Text013@1013 :
      Text013: TextConst ENU='Analysis View Card, ',ESP='Ficha Vista de an lisis, ';
//       DefaultDim@1003 :
      DefaultDim: Record 352;
//       DimVal@1014 :
      DimVal: Record 349;
//       DimComb@1015 :
      DimComb: Record 350;
//       SelectedDim@1016 :
      SelectedDim: Record 369;
//       AnalysisSelectedDim@1024 :
      AnalysisSelectedDim: Record 7159;
//       DimTrans@1022 :
      DimTrans: Record 388;
//       UsedAsGlobalDim@1017 :
      UsedAsGlobalDim: Boolean;
//       UsedAsShortcutDim@1018 :
      UsedAsShortcutDim: Boolean;
//       UsedAsBudgetDim@1019 :
      UsedAsBudgetDim: Boolean;
//       UsedAsAnalysisViewDim@1020 :
      UsedAsAnalysisViewDim: Boolean;
//       UsedAsItemBudgetDim@1028 :
      UsedAsItemBudgetDim: Boolean;
//       UsedAsItemAnalysisViewDim@1027 :
      UsedAsItemAnalysisViewDim: Boolean;
//       CheckDimErr@1021 :
      CheckDimErr: Text;
//       Text014@1026 :
      Text014: TextConst ENU='Item Budget Names, ',ESP='Nombres ppto. pdto., ';
//       Text015@1025 :
      Text015: TextConst ENU='Item Analysis View Card, ',ESP='Ficha vista de an lisis de art¡culo, ';

    


/*
trigger OnInsert();    begin
               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnModify();    begin
               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnDelete();    var
//                GLSetup@1000 :
               GLSetup: Record 98;
             begin
               DimVal.SETRANGE("Dimension Code",xRec.Code);
               if CheckIfDimUsed(xRec.Code,0,'','',0) then begin
                 if DimVal.FINDSET then
                   repeat
                     if DimVal.CheckIfDimValueUsed then
                       ERROR(Text000,GetCheckDimErr);
                   until DimVal.NEXT = 0;
                 ERROR(Text001,GetCheckDimErr);
               end;
               if DimVal.FINDSET then
                 repeat
                   if DimVal.CheckIfDimValueUsed then
                     ERROR(Text002);
                 until DimVal.NEXT = 0;

               DefaultDim.SETRANGE("Dimension Code",Code);
               DefaultDim.DELETEALL(TRUE);

               DimVal.SETRANGE("Dimension Code",Code);
               DimVal.DELETEALL(TRUE);

               DimComb.SETRANGE("Dimension 1 Code",Code);
               DimComb.DELETEALL;

               DimComb.RESET;
               DimComb.SETRANGE("Dimension 2 Code",Code);
               DimComb.DELETEALL;

               SelectedDim.SETRANGE("Dimension Code",Code);
               SelectedDim.DELETEALL;

               AnalysisSelectedDim.SETRANGE("Dimension Code",Code);
               AnalysisSelectedDim.DELETEALL;

               DimTrans.SETRANGE(Code,Code);
               DimTrans.DELETEALL;

               GLSetup.GET;
               CASE Code OF
                 GLSetup."Shortcut Dimension 3 Code":
                   begin
                     GLSetup."Shortcut Dimension 3 Code" := '';
                     GLSetup.MODIFY;
                   end;
                 GLSetup."Shortcut Dimension 4 Code":
                   begin
                     GLSetup."Shortcut Dimension 4 Code" := '';
                     GLSetup.MODIFY;
                   end;
                 GLSetup."Shortcut Dimension 5 Code":
                   begin
                     GLSetup."Shortcut Dimension 5 Code" := '';
                     GLSetup.MODIFY;
                   end;
                 GLSetup."Shortcut Dimension 6 Code":
                   begin
                     GLSetup."Shortcut Dimension 6 Code" := '';
                     GLSetup.MODIFY;
                   end;
                 GLSetup."Shortcut Dimension 7 Code":
                   begin
                     GLSetup."Shortcut Dimension 7 Code" := '';
                     GLSetup.MODIFY;
                   end;
                 GLSetup."Shortcut Dimension 8 Code":
                   begin
                     GLSetup."Shortcut Dimension 8 Code" := '';
                     GLSetup.MODIFY;
                   end;
               end;
             end;


*/

/*
trigger OnRename();    begin
               SetLastModifiedDateTime;
             end;

*/



// LOCAL procedure UpdateText (Code@1000 : Code[20];AddText@1001 : Text[30];var Text@1002 :

/*
LOCAL procedure UpdateText (Code: Code[20];AddText: Text[30];var Text: Text[80])
    begin
      if Text = '' then begin
        Text := LOWERCASE(Code);
        Text[1] := Code[1];
        if AddText <> '' then
          Text := STRSUBSTNO('%1 %2',Text,AddText);
      end;
    end;
*/


    
//     procedure CheckIfDimUsed (DimChecked@1000 : Code[20];DimTypeChecked@1001 : ' ,Global1,Global2,Shortcut3,Shortcut4,Shortcut5,Shortcut6,Shortcut7,Shortcut8,Budget1,Budget2,Budget3,Budget4,Analysis1,Analysis2,Analysis3,Analysis4,ItemBudget1,ItemBudget2,ItemBudget3,ItemAnalysis1,ItemAnalysis2,ItemAnalysis3';BudgetNameChecked@1002 : Code[10];AnalysisViewChecked@1003 : Code[10];AnalysisAreaChecked@1016 :
    
/*
procedure CheckIfDimUsed (DimChecked: Code[20];DimTypeChecked: Option " ","Global1","Global2","Shortcut3","Shortcut4","Shortcut5","Shortcut6","Shortcut7","Shortcut8","Budget1","Budget2","Budget3","Budget4","Analysis1","Analysis2","Analysis3","Analysis4","ItemBudget1","ItemBudget2","ItemBudget3","ItemAnalysis1","ItemAnalysis2","ItemAnalysis3";BudgetNameChecked: Code[10];AnalysisViewChecked: Code[10];AnalysisAreaChecked: Integer) : Boolean;
    var
//       GLSetup@1004 :
      GLSetup: Record 98;
//       GLBudgetName@1005 :
      GLBudgetName: Record 95;
//       AnalysisView@1006 :
      AnalysisView: Record 363;
//       ItemBudgetName@1015 :
      ItemBudgetName: Record 7132;
//       ItemAnalysisView@1014 :
      ItemAnalysisView: Record 7152;
//       CustomDimErr@1018 :
      CustomDimErr: Text;
//       CheckAllDim@1007 :
      CheckAllDim: Boolean;
//       CheckGlobalDim@1008 :
      CheckGlobalDim: Boolean;
//       CheckShortcutDim@1009 :
      CheckShortcutDim: Boolean;
//       CheckBudgetDim@1010 :
      CheckBudgetDim: Boolean;
//       CheckAnalysisViewDim@1011 :
      CheckAnalysisViewDim: Boolean;
//       CheckItemBudgetDim@1013 :
      CheckItemBudgetDim: Boolean;
//       CheckItemAnalysisViewDim@1012 :
      CheckItemAnalysisViewDim: Boolean;
//       UsedAsCustomDim@1017 :
      UsedAsCustomDim: Boolean;
    begin
      if DimChecked = '' then
        exit;

      OnBeforeCheckIfDimUsed(DimChecked,DimTypeChecked,UsedAsCustomDim,CustomDimErr);

      CheckAllDim := DimTypeChecked IN [DimTypeChecked::" "];
      CheckGlobalDim := DimTypeChecked IN [DimTypeChecked::Global1,DimTypeChecked::Global2];
      CheckShortcutDim := DimTypeChecked IN [DimTypeChecked::Shortcut3,DimTypeChecked::Shortcut4,DimTypeChecked::Shortcut5,
                                             DimTypeChecked::Shortcut6,DimTypeChecked::Shortcut7,DimTypeChecked::Shortcut8];
      CheckBudgetDim := DimTypeChecked IN [DimTypeChecked::Budget1,DimTypeChecked::Budget2,DimTypeChecked::Budget3,
                                           DimTypeChecked::Budget4];
      CheckAnalysisViewDim := DimTypeChecked IN [DimTypeChecked::Analysis1,DimTypeChecked::Analysis2,DimTypeChecked::Analysis3,
                                                 DimTypeChecked::Analysis4];
      CheckItemBudgetDim :=
        DimTypeChecked IN [DimTypeChecked::ItemBudget1,DimTypeChecked::ItemBudget2,DimTypeChecked::ItemBudget3];
      CheckItemAnalysisViewDim :=
        DimTypeChecked IN [DimTypeChecked::ItemAnalysis1,DimTypeChecked::ItemAnalysis2,DimTypeChecked::ItemAnalysis3];

      UsedAsGlobalDim := FALSE;
      UsedAsShortcutDim := FALSE;
      UsedAsBudgetDim := FALSE;
      UsedAsAnalysisViewDim := FALSE;
      UsedAsItemBudgetDim := FALSE;
      UsedAsItemAnalysisViewDim := FALSE;

      if CheckAllDim or CheckGlobalDim or CheckShortcutDim or CheckBudgetDim or CheckItemBudgetDim then begin
        GLSetup.GET;
        if (DimTypeChecked <> DimTypeChecked::Global1) and
           (DimChecked = GLSetup."Global Dimension 1 Code")
        then
          UsedAsGlobalDim := TRUE;
        if (DimTypeChecked <> DimTypeChecked::Global2) and
           (DimChecked = GLSetup."Global Dimension 2 Code")
        then
          UsedAsGlobalDim := TRUE;
      end;

      if CheckGlobalDim or CheckShortcutDim then begin
        if (DimTypeChecked <> DimTypeChecked::Shortcut3) and
           (DimChecked = GLSetup."Shortcut Dimension 3 Code")
        then
          UsedAsShortcutDim := TRUE;
        if (DimTypeChecked <> DimTypeChecked::Shortcut4) and
           (DimChecked = GLSetup."Shortcut Dimension 4 Code")
        then
          UsedAsShortcutDim := TRUE;
        if (DimTypeChecked <> DimTypeChecked::Shortcut5) and
           (DimChecked = GLSetup."Shortcut Dimension 5 Code")
        then
          UsedAsShortcutDim := TRUE;
        if (DimTypeChecked <> DimTypeChecked::Shortcut6) and
           (DimChecked = GLSetup."Shortcut Dimension 6 Code")
        then
          UsedAsShortcutDim := TRUE;
        if (DimTypeChecked <> DimTypeChecked::Shortcut7) and
           (DimChecked = GLSetup."Shortcut Dimension 7 Code")
        then
          UsedAsShortcutDim := TRUE;
        if (DimTypeChecked <> DimTypeChecked::Shortcut8) and
           (DimChecked = GLSetup."Shortcut Dimension 8 Code")
        then
          UsedAsShortcutDim := TRUE;
      end;

      if CheckAllDim or CheckGlobalDim or CheckBudgetDim then begin
        if BudgetNameChecked <> '' then
          GLBudgetName.SETRANGE(Name,BudgetNameChecked);
        if GLBudgetName.FINDSET then
          repeat
            if (DimTypeChecked <> DimTypeChecked::Budget1) and
               (DimChecked = GLBudgetName."Budget Dimension 1 Code")
            then
              UsedAsBudgetDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::Budget2) and
               (DimChecked = GLBudgetName."Budget Dimension 2 Code")
            then
              UsedAsBudgetDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::Budget3) and
               (DimChecked = GLBudgetName."Budget Dimension 3 Code")
            then
              UsedAsBudgetDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::Budget4) and
               (DimChecked = GLBudgetName."Budget Dimension 4 Code")
            then
              UsedAsBudgetDim := TRUE;
          until GLBudgetName.NEXT = 0;
      end;

      if CheckAllDim or CheckGlobalDim or CheckItemBudgetDim then begin
        if BudgetNameChecked <> '' then begin
          ItemBudgetName.SETRANGE("Analysis Area",AnalysisAreaChecked);
          ItemBudgetName.SETRANGE(Name,BudgetNameChecked);
        end;
        if ItemBudgetName.FINDSET then
          repeat
            if (DimTypeChecked <> DimTypeChecked::ItemBudget1) and
               (DimChecked = ItemBudgetName."Budget Dimension 1 Code")
            then
              UsedAsItemBudgetDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::ItemBudget2) and
               (DimChecked = ItemBudgetName."Budget Dimension 2 Code")
            then
              UsedAsItemBudgetDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::ItemBudget3) and
               (DimChecked = ItemBudgetName."Budget Dimension 3 Code")
            then
              UsedAsItemBudgetDim := TRUE;
          until ItemBudgetName.NEXT = 0;
      end;

      if CheckAllDim or CheckAnalysisViewDim then begin
        if AnalysisViewChecked <> '' then
          AnalysisView.SETRANGE(Code,AnalysisViewChecked);
        if AnalysisView.FINDSET then
          repeat
            if (DimTypeChecked <> DimTypeChecked::Analysis1) and
               (DimChecked = AnalysisView."Dimension 1 Code")
            then
              UsedAsAnalysisViewDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::Analysis2) and
               (DimChecked = AnalysisView."Dimension 2 Code")
            then
              UsedAsAnalysisViewDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::Analysis3) and
               (DimChecked = AnalysisView."Dimension 3 Code")
            then
              UsedAsAnalysisViewDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::Analysis4) and
               (DimChecked = AnalysisView."Dimension 4 Code")
            then
              UsedAsAnalysisViewDim := TRUE;
          until AnalysisView.NEXT = 0;
      end;

      if CheckAllDim or CheckItemAnalysisViewDim then begin
        if AnalysisViewChecked <> '' then begin
          ItemAnalysisView.SETRANGE("Analysis Area",AnalysisAreaChecked);
          ItemAnalysisView.SETRANGE(Code,AnalysisViewChecked);
        end;
        if ItemAnalysisView.FINDSET then
          repeat
            if (DimTypeChecked <> DimTypeChecked::ItemAnalysis1) and
               (DimChecked = ItemAnalysisView."Dimension 1 Code")
            then
              UsedAsItemAnalysisViewDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::ItemAnalysis2) and
               (DimChecked = ItemAnalysisView."Dimension 2 Code")
            then
              UsedAsItemAnalysisViewDim := TRUE;
            if (DimTypeChecked <> DimTypeChecked::ItemAnalysis3) and
               (DimChecked = ItemAnalysisView."Dimension 3 Code")
            then
              UsedAsItemAnalysisViewDim := TRUE;
          until ItemAnalysisView.NEXT = 0;
      end;

      if UsedAsGlobalDim or
         UsedAsShortcutDim or
         UsedAsBudgetDim or
         UsedAsAnalysisViewDim or
         UsedAsItemBudgetDim or
         UsedAsItemAnalysisViewDim or
         UsedAsCustomDim
      then begin
        MakeCheckDimErr(CustomDimErr);
        exit(TRUE);
      end;
      exit(FALSE);
    end;
*/


//     LOCAL procedure MakeCheckDimErr (CustomDimErr@1000 :
    
/*
LOCAL procedure MakeCheckDimErr (CustomDimErr: Text)
    begin
      CheckDimErr := Text010;
      if UsedAsGlobalDim or UsedAsShortcutDim then
        CheckDimErr := CheckDimErr + Text011;
      if UsedAsBudgetDim then
        CheckDimErr := CheckDimErr + Text012;
      if UsedAsAnalysisViewDim then
        CheckDimErr := CheckDimErr + Text013;
      if UsedAsItemBudgetDim then
        CheckDimErr := CheckDimErr + Text014;
      if UsedAsItemAnalysisViewDim then
        CheckDimErr := CheckDimErr + Text015;
      if CustomDimErr <> '' then
        CheckDimErr := CheckDimErr + CustomDimErr;
      CheckDimErr := COPYSTR(CheckDimErr,1,STRLEN(CheckDimErr) - 2) + '.';
    end;
*/


    
    
/*
procedure GetCheckDimErr () : Text[250];
    begin
      exit(CheckDimErr);
    end;
*/


    
//     procedure GetMLName (LanguageID@1001 :
    
/*
procedure GetMLName (LanguageID: Integer) : Text[30];
    begin
      GetDimTrans(LanguageID);
      exit(DimTrans.Name);
    end;
*/


    
//     procedure GetMLCodeCaption (LanguageID@1000 :
    
/*
procedure GetMLCodeCaption (LanguageID: Integer) : Text[30];
    begin
      GetDimTrans(LanguageID);
      exit(DimTrans."Code Caption");
    end;
*/


    
//     procedure GetMLFilterCaption (LanguageID@1000 :
    
/*
procedure GetMLFilterCaption (LanguageID: Integer) : Text[30];
    begin
      GetDimTrans(LanguageID);
      exit(DimTrans."Filter Caption");
    end;
*/


    
//     procedure SetMLName (NewMLName@1000 : Text[30];LanguageID@1001 :
    
/*
procedure SetMLName (NewMLName: Text[30];LanguageID: Integer)
    begin
      if IsApplicationLanguage(LanguageID) then begin
        if Name <> NewMLName then begin
          Name := NewMLName;
          MODIFY;
        end;
      end else begin
        InsertDimTrans(LanguageID);
        if DimTrans.Name <> NewMLName then begin
          DimTrans.Name := NewMLName;
          DimTrans.MODIFY;
        end;
      end;
    end;
*/


    
//     procedure SetMLCodeCaption (NewMLCodeCaption@1000 : Text[30];LanguageID@1001 :
    
/*
procedure SetMLCodeCaption (NewMLCodeCaption: Text[30];LanguageID: Integer)
    begin
      if IsApplicationLanguage(LanguageID) then begin
        if "Code Caption" <> NewMLCodeCaption then begin
          "Code Caption" := NewMLCodeCaption;
          MODIFY;
        end;
      end else begin
        InsertDimTrans(LanguageID);
        if DimTrans."Code Caption" <> NewMLCodeCaption then begin
          DimTrans."Code Caption" := NewMLCodeCaption;
          DimTrans.MODIFY;
        end;
      end;
    end;
*/


    
//     procedure SetMLFilterCaption (NewMLFilterCaption@1000 : Text[30];LanguageID@1001 :
    
/*
procedure SetMLFilterCaption (NewMLFilterCaption: Text[30];LanguageID: Integer)
    begin
      if IsApplicationLanguage(LanguageID) then begin
        if "Filter Caption" <> NewMLFilterCaption then begin
          "Filter Caption" := NewMLFilterCaption;
          MODIFY;
        end;
      end else begin
        InsertDimTrans(LanguageID);
        if DimTrans."Filter Caption" <> NewMLFilterCaption then begin
          DimTrans."Filter Caption" := NewMLFilterCaption;
          DimTrans.MODIFY;
        end;
      end;
    end;
*/


    
//     procedure SetMLDescription (NewMLDescription@1000 : Text[50];LanguageID@1001 :
    
/*
procedure SetMLDescription (NewMLDescription: Text[50];LanguageID: Integer)
    begin
      if IsApplicationLanguage(LanguageID) then begin
        if Description <> NewMLDescription then begin
          Description := NewMLDescription;
          MODIFY;
        end;
      end else
        InsertDimTrans(LanguageID);
    end;
*/


//     LOCAL procedure GetDimTrans (LanguageID@1001 :
    
/*
LOCAL procedure GetDimTrans (LanguageID: Integer)
    begin
      if (DimTrans.Code <> Code) or (DimTrans."Language ID" <> LanguageID) then
        if not DimTrans.GET(Code,LanguageID) then begin
          DimTrans.INIT;
          DimTrans.Code := Code;
          DimTrans."Language ID" := LanguageID;
          DimTrans.Name := Name;
          DimTrans."Code Caption" := "Code Caption";
          DimTrans."Filter Caption" := "Filter Caption";
        end;
    end;
*/


//     LOCAL procedure InsertDimTrans (LanguageID@1000 :
    
/*
LOCAL procedure InsertDimTrans (LanguageID: Integer)
    begin
      if not DimTrans.GET(Code,LanguageID) then begin
        DimTrans.INIT;
        DimTrans.Code := Code;
        DimTrans."Language ID" := LanguageID;
        DimTrans.INSERT;
      end;
    end;
*/


//     LOCAL procedure IsApplicationLanguage (LanguageID@1000 :
    
/*
LOCAL procedure IsApplicationLanguage (LanguageID: Integer) : Boolean;
    var
//       LanguageManagement@1003 :
      LanguageManagement: Codeunit 43;
    begin
      exit(LanguageID = LanguageManagement.ApplicationLanguage);
    end;
*/


    
/*
LOCAL procedure SetLastModifiedDateTime ()
    begin
      "Last Modified Date Time" := CURRENTDATETIME;
    end;
*/


    
//     LOCAL procedure OnBeforeCheckIfDimUsed (DimChecked@1001 : Code[20];DimTypeChecked@1000 : ' ,Global1,Global2,Shortcut3,Shortcut4,Shortcut5,Shortcut6,Shortcut7,Shortcut8,Budget1,Budget2,Budget3,Budget4,Analysis1,Analysis2,Analysis3,Analysis4,ItemBudget1,ItemBudget2,ItemBudget3,ItemAnalysis1,ItemAnalysis2,ItemAnalysis3';var UsedAsCustomDim@1002 : Boolean;var CustomDimErr@1003 :
    
/*
LOCAL procedure OnBeforeCheckIfDimUsed (DimChecked: Code[20];DimTypeChecked: Option " ","Global1","Global2","Shortcut3","Shortcut4","Shortcut5","Shortcut6","Shortcut7","Shortcut8","Budget1","Budget2","Budget3","Budget4","Analysis1","Analysis2","Analysis3","Analysis4","ItemBudget1","ItemBudget2","ItemBudget3","ItemAnalysis1","ItemAnalysis2","ItemAnalysis3";var UsedAsCustomDim: Boolean;var CustomDimErr: Text)
    begin
    end;

    /*begin
    end.
  */
}





