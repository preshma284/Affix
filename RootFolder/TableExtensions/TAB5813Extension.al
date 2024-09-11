tableextension 50201 "MyExtension50201" extends "Inventory Posting Setup"
{
  
  
    CaptionML=ENU='Inventory Posting Setup',ESP='Config. registro inventario';
  
  fields
{
    field(7207270;"Analytic Concept";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='Analytic Concept',ESP='Concepto anal¡tico';
                                                   Description='QB2411';

trigger OnLookup();
    VAR
//                                                               FunctionQB@100000000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("Analytic Concept", FALSE);
                                                            END;


    }
    field(7207271;"App. Account Concept Analytic";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='App. Account Concept Analytic',ESP='Concepto anal¡tico contrapartida';
                                                   Description='QB2411';

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("App. Account Concept Analytic", FALSE);
                                                            END;


    }
    field(7207272;"Location Account Consumption";Text[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Location Account Consumption',ESP='Cuenta consumo almac‚n';
                                                   Description='QB2411';


    }
    field(7207273;"App.Account Locat Acc. Consum.";Text[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='App.Account Locat Acc. Consum.',ESP='Cuenta contrap. consumo almac.';
                                                   Description='QB2411';


    }
}
  keys
{
   // key(key1;"Location Code","Invt. Posting Group Code")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       GLAccountCategory@1001 :
      GLAccountCategory: Record 570;
//       GLAccountCategoryMgt@1002 :
      GLAccountCategoryMgt: Codeunit 570;
//       YouCannotDeleteErr@1004 :
      YouCannotDeleteErr: 
// "%1 = Location Code; %2 = Posting Group"
TextConst ENU='You cannot delete %1 %2.',ESP='No puede eliminar %1 %2.';
//       PostingSetupMgt@1003 :
      PostingSetupMgt: Codeunit 48;

    


/*
trigger OnDelete();    begin
               CheckSetupUsage;
             end;

*/




/*
LOCAL procedure CheckSetupUsage ()
    var
//       ValueEntry@1000 :
      ValueEntry: Record 5802;
    begin
      ValueEntry.SETRANGE("Location Code","Location Code");
      ValueEntry.SETRANGE("Inventory Posting Group","Invt. Posting Group Code");
      if not ValueEntry.ISEMPTY then
        ERROR(YouCannotDeleteErr,"Location Code","Invt. Posting Group Code");
    end;
*/


    
    
/*
procedure GetCapacityVarianceAccount () : Code[20];
    begin
      if "Capacity Variance Account" = '' then
        PostingSetupMgt.SendInvtPostingSetupNotification(Rec,FIELDCAPTION("Capacity Variance Account"));
      TESTFIELD("Capacity Variance Account");
      exit("Capacity Variance Account");
    end;
*/


    
    
/*
procedure GetCapOverheadVarianceAccount () : Code[20];
    begin
      if "Cap. Overhead Variance Account" = '' then
        PostingSetupMgt.SendInvtPostingSetupNotification(Rec,FIELDCAPTION("Cap. Overhead Variance Account"));
      TESTFIELD("Cap. Overhead Variance Account");
      exit("Cap. Overhead Variance Account");
    end;
*/


    
    
/*
procedure GetInventoryAccount () : Code[20];
    begin
      if "Inventory Account" = '' then
        PostingSetupMgt.SendInvtPostingSetupNotification(Rec,FIELDCAPTION("Inventory Account"));
      TESTFIELD("Inventory Account");
      exit("Inventory Account");
    end;
*/


    
    
/*
procedure GetInventoryAccountInterim () : Code[20];
    begin
      if "Inventory Account (Interim)" = '' then
        PostingSetupMgt.SendInvtPostingSetupNotification(Rec,FIELDCAPTION("Inventory Account (Interim)"));
      TESTFIELD("Inventory Account (Interim)");
      exit("Inventory Account (Interim)");
    end;
*/


    
    
/*
procedure GetMaterialVarianceAccount () : Code[20];
    begin
      if "Material Variance Account" = '' then
        PostingSetupMgt.SendInvtPostingSetupNotification(Rec,FIELDCAPTION("Material Variance Account"));
      TESTFIELD("Material Variance Account");
      exit("Material Variance Account");
    end;
*/


    
    
/*
procedure GetMfgOverheadVarianceAccount () : Code[20];
    begin
      if "Mfg. Overhead Variance Account" = '' then
        PostingSetupMgt.SendInvtPostingSetupNotification(Rec,FIELDCAPTION("Mfg. Overhead Variance Account"));
      TESTFIELD("Mfg. Overhead Variance Account");
      exit("Mfg. Overhead Variance Account");
    end;
*/


    
    
/*
procedure GetSubcontractedVarianceAccount () : Code[20];
    begin
      if "Subcontracted Variance Account" = '' then
        PostingSetupMgt.SendInvtPostingSetupNotification(Rec,FIELDCAPTION("Subcontracted Variance Account"));
      TESTFIELD("Subcontracted Variance Account");
      exit("Subcontracted Variance Account");
    end;
*/


    
    
/*
procedure GetWIPAccount () : Code[20];
    begin
      if "WIP Account" = '' then
        PostingSetupMgt.SendInvtPostingSetupNotification(Rec,FIELDCAPTION("WIP Account"));
      TESTFIELD("WIP Account");
      exit("WIP Account");
    end;
*/


    
    
/*
procedure SuggestSetupAccounts ()
    var
//       RecRef@1000 :
      RecRef: RecordRef;
    begin
      RecRef.GETTABLE(Rec);
      if "Inventory Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Inventory Account"));
      if "Inventory Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Inventory Account (Interim)"));
      if "WIP Account" = '' then
        SuggestAccount(RecRef,FIELDNO("WIP Account"));
      if "Material Variance Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Material Variance Account"));
      if "Capacity Variance Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Capacity Variance Account"));
      if "Mfg. Overhead Variance Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Mfg. Overhead Variance Account"));
      if "Cap. Overhead Variance Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Cap. Overhead Variance Account"));
      if "Subcontracted Variance Account" = '' then
        SuggestAccount(RecRef,FIELDNO("Subcontracted Variance Account"));
      RecRef.MODIFY;
    end;
*/


//     LOCAL procedure SuggestAccount (var RecRef@1000 : RecordRef;AccountFieldNo@1001 :
    
/*
LOCAL procedure SuggestAccount (var RecRef: RecordRef;AccountFieldNo: Integer)
    var
//       TempAccountUseBuffer@1002 :
      TempAccountUseBuffer: Record 63 TEMPORARY;
//       RecFieldRef@1003 :
      RecFieldRef: FieldRef;
//       InvtPostingSetupRecRef@1005 :
      InvtPostingSetupRecRef: RecordRef;
//       InvtPostingSetupFieldRef@1004 :
      InvtPostingSetupFieldRef: FieldRef;
    begin
      InvtPostingSetupRecRef.OPEN(DATABASE::"Inventory Posting Setup");

      InvtPostingSetupRecRef.RESET;
      InvtPostingSetupFieldRef := InvtPostingSetupRecRef.FIELD(FIELDNO("Invt. Posting Group Code"));
      InvtPostingSetupFieldRef.SETFILTER('<>%1',"Invt. Posting Group Code");
      InvtPostingSetupFieldRef := InvtPostingSetupRecRef.FIELD(FIELDNO("Location Code"));
      InvtPostingSetupFieldRef.SETRANGE("Location Code");
      TempAccountUseBuffer.UpdateBuffer(InvtPostingSetupRecRef,AccountFieldNo);

      InvtPostingSetupRecRef.CLOSE;

      TempAccountUseBuffer.RESET;
      TempAccountUseBuffer.SETCURRENTKEY("No. of Use");
      if TempAccountUseBuffer.FINDLAST then begin
        RecFieldRef := RecRef.FIELD(AccountFieldNo);
        RecFieldRef.VALUE(TempAccountUseBuffer."Account No.");
      end;
    end;

    /*begin
    end.
  */
}




