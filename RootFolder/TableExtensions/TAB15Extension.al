tableextension 50105 "MyExtension50105" extends "G/L Account"
{
  
  DataCaptionFields="No.","Name";
    CaptionML=ENU='G/L Account',ESP='Cuenta';
    LookupPageID="G/L Account List";
    DrillDownPageID="Chart of Accounts";
  
  fields
{
    field(88182;"KPI for HFM-FCCS";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   Description='AMAPALA - HFM/FCCS';


    }
    field(88183;"IC Partner Code Filter";Code[20])
    {
        FieldClass=FlowFilter;
                                                   
                                                   TableRelation="IC Partner"."Code";
                                                   Description='AMAPALA INTEGRACION';


    }
    field(7174331;"QuoSII Payment Cash";Boolean)
    {
        CaptionML=ENU='SII Payment Cash',ESP='Cobro Met lico SII';
                                                   Description='QuoSII' ;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Search Name")
  //  {
       /* ;
 */
   // }
   // key(key3;"Reconciliation Account")
  //  {
       /* ;
 */
   // }
   // key(key4;"Gen. Bus. Posting Group")
  //  {
       /* ;
 */
   // }
   // key(key5;"Gen. Prod. Posting Group")
  //  {
       /* ;
 */
   // }
   // key(No6;"Consol. Debit Acc.","Consol. Translation Method")
   // {
       /* ;
 */
   // }
   // key(No7;"Consol. Credit Acc.","Consol. Translation Method")
   // {
       /* ;
 */
   // }
   // key(key8;"Name")
  //  {
       /* ;
 */
   // }
   // key(key9;"Account Type")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","Name","Income/Balance","Blocked","Direct Posting")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='You cannot change %1 because there are one or more ledger entries associated with this account.',ESP='No se puede cambiar la cuenta %1 porque tiene movimientos asociados.';
//       Text001@1001 :
      Text001: TextConst ENU='You cannot change %1 because this account is part of one or more budgets.',ESP='No se puede cambiar la cuenta %1 porque est  incluida en presupuestos.';
//       GLSetup@1002 :
      GLSetup: Record 98;
//       CostAccSetup@1006 :
      CostAccSetup: Record 1108;
//       DimMgt@1003 :
      DimMgt: Codeunit 408;
//       CostAccMgt@1007 :
      CostAccMgt: Codeunit 1100;
//       GLSetupRead@1004 :
      GLSetupRead: Boolean;
//       Text002@1005 :
      Text002: TextConst ENU='There is another %1: %2; which refers to the same %3, but with a different %4: %5.',ESP='Existe otro %1: %2 que hace referencia al mismo %3, pero con un valor diferente para %4: %5.';
//       Text1100000@1100000 :
      Text1100000: TextConst ENU='A heading account with related accounts cannot be deleted.',ESP='No se puede eliminar una cuenta de mayor que tiene cuentas auxiliares asociadas.';
//       Text1100001@1100001 :
      Text1100001: TextConst ENU='The length of the new value is not acceptable, as it implies a change in %1.',ESP='La nueva longitud no es correcta ya que implica un cambio en %1.';
//       Text1100002@1100002 :
      Text1100002: TextConst ENU='The account has entries and/or %1. Changing the value of this field may cause ',ESP='La cuenta tiene movs. y/o %1. Cambiar el valor del campo puede causar ';
//       Text1100003@1100003 :
      Text1100003: TextConst ENU='inconsistencies report 347.',ESP='inconsistencias informe 347.';
//       NoAccountCategoryMatchErr@1008 :
      NoAccountCategoryMatchErr: 
// "%1=account category value, %2=the user input."
TextConst ENU='There is no subcategory description for %1 that matches ''%2''.',ESP='No hay ninguna descripci¢n de subcategor¡a para %1 que coincide con ''%2''.';

    
    


/*
trigger OnInsert();    begin
               DimMgt.UpdateDefaultDim(DATABASE::"G/L Account","No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");

               SetLastModifiedDateTime;

               if CostAccSetup.GET then
                 CostAccMgt.UpdateCostTypeFromGLAcc(Rec,xRec,0);

               if Indentation < 0 then
                 Indentation := 0;
             end;


*/

/*
trigger OnModify();    begin
               SetLastModifiedDateTime;

               if CostAccSetup.GET then begin
                 if CurrFieldNo <> 0 then
                   CostAccMgt.UpdateCostTypeFromGLAcc(Rec,xRec,1)
                 else
                   CostAccMgt.UpdateCostTypeFromGLAcc(Rec,xRec,0);
               end;

               if Indentation < 0 then
                 Indentation := 0;
             end;


*/

/*
trigger OnDelete();    var
//                GLBudgetEntry@1000 :
               GLBudgetEntry: Record 96;
//                CommentLine@1001 :
               CommentLine: Record 97;
//                ExtTextHeader@1002 :
               ExtTextHeader: Record 279;
//                AnalysisViewEntry@1003 :
               AnalysisViewEntry: Record 365;
//                AnalysisViewBudgetEntry@1004 :
               AnalysisViewBudgetEntry: Record 366;
//                MyAccount@1006 :
               MyAccount: Record 9153;
//                MoveEntries@1005 :
               MoveEntries: Codeunit 361;
//                GLAcc@1100000 :
               GLAcc: Record 15;
             begin
               if ("Account Type" = "Account Type"::Heading) then begin
                 GLAcc := Rec;
                 if GLAcc.NEXT <> 0 then
                   if COPYSTR(GLAcc."No.",1,STRLEN("No.")) = "No." then
                     ERROR(Text1100000);
               end;

               MoveEntries.MoveGLEntries(Rec);

               GLBudgetEntry.SETCURRENTKEY("Budget Name","G/L Account No.");
               GLBudgetEntry.SETRANGE("G/L Account No.","No.");
               GLBudgetEntry.DELETEALL(TRUE);

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"G/L Account");
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::"G/L Account");
               ExtTextHeader.SETRANGE("No.","No.");
               ExtTextHeader.DELETEALL(TRUE);

               AnalysisViewEntry.SETRANGE("Account No.","No.");
               AnalysisViewEntry.DELETEALL;

               AnalysisViewBudgetEntry.SETRANGE("G/L Account No.","No.");
               AnalysisViewBudgetEntry.DELETEALL;

               MyAccount.SETRANGE("Account No.","No.");
               MyAccount.DELETEALL;

               DimMgt.DeleteDefaultDim(DATABASE::"G/L Account","No.");
             end;


*/

/*
trigger OnRename();    var
//                SalesLine@1000 :
               SalesLine: Record 37;
//                PurchaseLine@1001 :
               PurchaseLine: Record 39;
             begin
               SalesLine.RenameNo(SalesLine.Type::"G/L Account",xRec."No.","No.");
               PurchaseLine.RenameNo(PurchaseLine.Type::"G/L Account",xRec."No.","No.");
               DimMgt.RenameDefaultDim(DATABASE::"G/L Account",xRec."No.","No.");

               SetLastModifiedDateTime;

               if CostAccSetup.READPERMISSION then
                 CostAccMgt.UpdateCostTypeFromGLAcc(Rec,xRec,3);
             end;

*/



// procedure SetupNewGLAcc (OldGLAcc@1000 : Record 15;BelowOldGLAcc@1001 :

/*
procedure SetupNewGLAcc (OldGLAcc: Record 15;BelowOldGLAcc: Boolean)
    var
//       OldGLAcc2@1002 :
      OldGLAcc2: Record 15;
    begin
      if not BelowOldGLAcc then begin
        OldGLAcc2 := OldGLAcc;
        OldGLAcc.COPY(Rec);
        OldGLAcc := OldGLAcc2;
        if not OldGLAcc.FIND('<') then
          OldGLAcc.INIT;
      end;
      "Income/Balance" := OldGLAcc."Income/Balance";
    end;
*/


    
    
/*
procedure CheckGLAcc ()
    begin
      TESTFIELD("Account Type","Account Type"::Posting);
      TESTFIELD(Blocked,FALSE);

      OnAfterCheckGLAcc(Rec);
    end;
*/


    
//     procedure ValidateAccountSubCategory (NewValue@1000 :
    
/*
procedure ValidateAccountSubCategory (NewValue: Text[80])
    var
//       GLAccountCategory@1001 :
      GLAccountCategory: Record 570;
    begin
      if NewValue = "Account Subcategory Descript." then
        exit;
      if NewValue = '' then
        VALIDATE("Account Subcategory Entry No.",0)
      else begin
        GLAccountCategory.SETRANGE("Account Category","Account Category");
        GLAccountCategory.SETRANGE(Description,NewValue);
        if not GLAccountCategory.FINDFIRST then begin
          GLAccountCategory.SETFILTER(Description,'''@*' + NewValue + '*''');
          if not GLAccountCategory.FINDFIRST then
            ERROR(NoAccountCategoryMatchErr,"Account Category",NewValue);
        end;
        VALIDATE("Account Subcategory Entry No.",GLAccountCategory."Entry No.");
      end;
    end;
*/


    
    
/*
procedure LookupAccountSubCategory ()
    var
//       GLAccountCategory@1001 :
      GLAccountCategory: Record 570;
//       GLAccountCategories@1000 :
      GLAccountCategories: Page 790;
    begin
      if "Account Subcategory Entry No." <> 0 then
        if GLAccountCategory.GET("Account Subcategory Entry No.") then
          GLAccountCategories.SETRECORD(GLAccountCategory);
      GLAccountCategory.SETRANGE("Income/Balance","Income/Balance");
      if "Account Category" <> 0 then
        GLAccountCategory.SETRANGE("Account Category","Account Category");
      GLAccountCategories.SETTABLEVIEW(GLAccountCategory);
      GLAccountCategories.LOOKUPMODE(TRUE);
      if GLAccountCategories.RUNMODAL = ACTION::LookupOK then begin
        GLAccountCategories.GETRECORD(GLAccountCategory);
        VALIDATE("Account Category",GLAccountCategory."Account Category");
        "Account Subcategory Entry No." := GLAccountCategory."Entry No.";
      end;
      CALCFIELDS("Account Subcategory Descript.");
    end;
*/


    
    
/*
procedure GetCurrencyCode () : Code[10];
    begin
      if not GLSetupRead then begin
        GLSetup.GET;
        GLSetupRead := TRUE;
      end;
      exit(GLSetup."Additional Reporting Currency");
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::"G/L Account","No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    end;
*/


    
//     procedure TranslationMethodConflict (var GLAcc@1000 :
    
/*
procedure TranslationMethodConflict (var GLAcc: Record 15) : Boolean;
    begin
      GLAcc.RESET;
      GLAcc.SETFILTER("No.",'<>%1',"No.");
      GLAcc.SETFILTER("Consol. Translation Method",'<>%1',"Consol. Translation Method");
      if "Consol. Debit Acc." <> '' then begin
        if not GLAcc.SETCURRENTKEY("Consol. Debit Acc.","Consol. Translation Method") then
          GLAcc.SETCURRENTKEY("No.");
        GLAcc.SETRANGE("Consol. Debit Acc.","Consol. Debit Acc.");
        if GLAcc.FIND('-') then
          exit(TRUE);
        GLAcc.SETRANGE("Consol. Debit Acc.");
      end;
      if "Consol. Credit Acc." <> '' then begin
        if not GLAcc.SETCURRENTKEY("Consol. Credit Acc.","Consol. Translation Method") then
          GLAcc.SETCURRENTKEY("No.");
        GLAcc.SETRANGE("Consol. Credit Acc.","Consol. Credit Acc.");
        if GLAcc.FIND('-') then
          exit(TRUE);
        GLAcc.SETRANGE("Consol. Credit Acc.");
      end;
      exit(FALSE);
    end;
*/


//     procedure InvoiceDiscountAllowed (GLAccNo@1100000 :
    
/*
procedure InvoiceDiscountAllowed (GLAccNo: Code[20]) : Boolean;
    var
//       GLAccount@1100001 :
      GLAccount: Record 15;
    begin
      if GLAccount.GET(GLAccNo) then
        exit(GLAccount."Ignore Discounts");
    end;
*/


    
/*
LOCAL procedure SetLastModifiedDateTime ()
    begin
      "Last Modified Date Time" := CURRENTDATETIME;
      "Last Date Modified" := TODAY;
    end;
*/


    
    
/*
procedure IsTotaling () : Boolean;
    begin
      exit("Account Type" = "Account Type"::Heading);
    end;
*/


    
//     LOCAL procedure OnAfterCheckGLAcc (var GLAccount@1000 :
    
/*
LOCAL procedure OnAfterCheckGLAcc (var GLAccount: Record 15)
    begin
    end;

    /*begin
    //{
//      Se a¤aden estos campos propios de Ortiz: 88182 "KPI for HFM-FCCS" y 88183 "IC Partner Code Filter"
//    }
    end.
  */
}




