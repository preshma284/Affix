pageextension 50181 MyExtension379 extends 379//273
{
layout
{


}

actions
{
addfirst("Creation")
{
    action("QB_ImportN43")
    {
        
                      CaptionML=ESP='Importar N43';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=ImportChartOfAccounts;
                      PromotedCategory=Category4;
                      
                              //   trigger OnAction()    VAR
                              //    recBankAccount : Record 270;
                              //    ImportN43 : Report 50050;
                              //  BEGIN
                              //    //JAV 15/09/20: - QB 1.06.14 Se a¤ade la acci¢n para importar el fichero Norma 43 directamente
                              //    recBankAccount.RESET;
                              //    recBankAccount.SETRANGE("No.",rec."Bank Account No.");
                              //    IF recBankAccount.FINDFIRST THEN BEGIN
                              //      CLEAR(ImportN43);
                              //      ImportN43.SETTABLEVIEW(recBankAccount);
                              //      ImportN43.SetConciliation(Rec);
                              //      ImportN43.RUNMODAL;
                              //    END ELSE BEGIN
                              //        ERROR(txtQB000, rec."Bank Account No.")
                              //    END;
                              //    //JAV fin
                              //  END;


}
}

}

//trigger

//trigger

var
      SuggestBankAccStatement : Report 1496;
      TransferToGLJnl : Report 1497;
      ReportPrint : Codeunit 228;
      txtQB000 : TextConst ESP='No se ha encontrado el banco del filtro %1';

    

//procedure

//procedure
}

