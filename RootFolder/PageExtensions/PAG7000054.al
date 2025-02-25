pageextension 50269 MyExtension7000054 extends 7000054//7000021
{
layout
{
addafter("Remaining Amount (LCY)")
{
    field("Confirming";rec."Confirming")
    {
        
                Visible=seeConfirming;
                Editable=false ;
}
    field("Confirming Line";rec."Confirming Line")
    {
        
                Visible=seeConfirming ;
}
}

}

actions
{
addafter("Page Posted Payment Orders Maturity Process")
{
    action("QB_GenerarPagoElectronico")
    {
        
                      CaptionML=ESP='Generar Pago Electr¢nico';
                      Promoted=true;
                      Visible=seeGenerate;
                      PromotedIsBig=true;
                      Image=ElectronicDoc;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    VAR
                                 GenerateElectronicsPayments : Codeunit 7206908;
                                 QBReportSelections : Record 7206901;
                                 ExportAgainQst : TextConst ENU='The selected payment order has already been exported. Do you want to export again?',ESP='Sea prudente para no duplicar las ¢rdenes de pago electr¢nicas.\¨Realmente desea exportar el fichero?';
                                 PostedPaymentOrder : Record 7000021;
                                 BankAccount : Record 270;
                                 UserSetup : Record 91;
                                 ExportError : TextConst ESP='false tiene autorizaci¢n para generar el pago electr¢nico';
                               BEGIN
                                 //JAV 26/10/20: - QB 1.07.00 Verificar si se puede ejecutar por el usuario
                                 //JAV 03/10/19: - Se utiliza el nuevo selector de informes para la generaci¢n del pago electr¢nico
                                 //JAV 14/09/21: - QB 1.09.17 Nuevo proceso para generar los formatos sin necesidad de usar reports
                                 UserSetup.GET(USERID);
                                 IF NOT UserSetup."Allow Gen. Posted Elec.Payment" THEN
                                   ERROR(ExportError);

                                 IF NOT Rec.FIND THEN
                                   EXIT;

                                 IF (NOT CONFIRM(ExportAgainQst)) THEN
                                   EXIT;

                                 PostedPaymentOrder.RESET;
                                 PostedPaymentOrder := Rec;
                                 PostedPaymentOrder.SETRECFILTER;

                                 BankAccount.GET(rec."Bank Account No.");
                                 GenerateElectronicsPayments.Launch(Rec."No.", BankAccount."Electronic Report");


                                 // IF (BankAccount."Electronic Report" <> 0) THEN
                                 //  QBReportSelections.PrintOneReport(BankAccount."Electronic Report", PostedPaymentOrder)
                                 // ELSE
                                 //  QBReportSelections.Print(QBReportSelections.Usage::G1, PostedPaymentOrder);
                               END;


}
}

}

//trigger
trigger OnOpenPage()    BEGIN
                 //rec."Confirming"
                 seeConfirming := (QBCartera.IsFactoringActive);

                 //JAV 14/09/21: - QB 1.09.17 Nuevo bot¢n para volver a generar un pago electr¢nico
                 UserSetup.GET(USERID);

                 PostedCarteraDoc.RESET;
                 PostedCarteraDoc.SETCURRENTKEY(Type,"Bill Gr./Pmt. Order No.");
                 PostedCarteraDoc.SETRANGE(Type, PostedCarteraDoc.Type::Payable);
                 PostedCarteraDoc.SETRANGE("Bill Gr./Pmt. Order No.", Rec."No.");
                 PostedCarteraDoc.SETFILTER(PostedCarteraDoc.Status, '<>%1', PostedCarteraDoc.Status::Open);
                 seeGenerate := (UserSetup."Allow Gen. Posted Elec.Payment") AND (PostedCarteraDoc.ISEMPTY);
               END;


//trigger

var
      PostedPmtOrd : Record 7000021;
      Navigate : Page 344;
      "------------------------------ QB" : Integer;
      UserSetup : Record 91;
      PostedCarteraDoc : Record 7000003;
      QBCartera : Codeunit 7206905;
      seeConfirming : Boolean;
      seeGenerate : Boolean;

    

//procedure

//procedure
}

