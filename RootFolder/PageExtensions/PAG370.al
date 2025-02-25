pageextension 50177 MyExtension370 extends 370//270
{
layout
{
addafter("Transfer")
{
group("QB_QuoBuilding")
{
        
                CaptionML=ENU='QuoBuilding',ESP='QuoBuilding';
group("Control1100286065")
{
        
                CaptionML=ESP='Confirming/Factoring';
                Visible=seeConfirming;
    field("Confirming Line";rec."Confirming Line")
    {
        
                Visible=seeConfirming ;
}
    field("Electronic Report";rec."Electronic Report")
    {
        
}
    field("Factoring Line";rec."Factoring Line")
    {
        
                Visible=seeFactoring ;
}
}
group("Control1100286064")
{
        
                CaptionML=ESP='Conciliaci¢n autom tica';
    field("Margin days for conciliation";rec."Margin days for conciliation")
    {
        
}
}
group("Control1100286054")
{
        
                CaptionML=ESP='Confirming';
    field("QB_ConfirmingContractNo";rec."Confirming Contract No.")
    {
        
}
    field("Dig.Control Bankinter";rec."Dig.Control Bankinter")
    {
        
}
}
group("Control1100286041")
{
        
                CaptionML=ESP='Imp. Cheque/Pagar‚ 1';
    field("Check Report ID";rec."Check Report ID")
    {
        
}
    field("Check Report Name";rec."Check Report Name")
    {
        
}
    field("QB_UltimoNroCheque";rec."Last Check No.")
    {
        
                CaptionML=ENU='rec."Last Check No."',ESP='éltimo N§ Cheque/Pagar‚';
                ToolTipML=ENU='Specifies the check number of the last check issued from the bank account.',ESP='Especifica el n£mero del £ltimo cheque emitido de la cuenta bancaria.';
                ApplicationArea=Basic,Suite;
                Visible=verRelacionesPagos ;
}
    field("QB_Maximo NoCheque";rec."Maximo  No. Cheque")
    {
        
                CaptionML=ENU='Ult. n§ pagar‚',ESP='M ximo N§ Cheque/Pagar‚';
                Visible=verRelacionesPagos ;
}
}
group("Control1100286053")
{
        
                CaptionML=ESP='Imp. Cheque/Pagar‚ 2';
    field("Rep2 Check Report ID";rec."Rep2 Check Report ID")
    {
        
}
    field("Rep2 Check Report Name";rec."Rep2 Check Report Name")
    {
        
}
    field("Rep2 Last Check No.";rec."Rep2 Last Check No.")
    {
        
}
    field("Rep2 Maximo  No. Cheque";rec."Rep2 Maximo  No. Cheque")
    {
        
}
}
group("Control1100286042")
{
        
                CaptionML=ESP='Imp. Cheque/Pagar‚ 3';
    field("Rep3 Check Report ID";rec."Rep3 Check Report ID")
    {
        
}
    field("Rep3 Check Report Name";rec."Rep3 Check Report Name")
    {
        
}
    field("Rep3 Last Check No.";rec."Rep3 Last Check No.")
    {
        
}
    field("Rep3 Maximo  No. Cheque";rec."Rep3 Maximo  No. Cheque")
    {
        
}
}
group("Control1100286040")
{
        
                CaptionML=ESP='Imp. Cheque/Pagar‚ 4';
    field("Rep4 Check Report ID";rec."Rep4 Check Report ID")
    {
        
}
    field("Rep4 Check Report Name";rec."Rep4 Check Report Name")
    {
        
}
    field("Rep4 Last Check No.";rec."Rep4 Last Check No.")
    {
        
}
    field("Rep4 Maximo  No. Cheque";rec."Rep4 Maximo  No. Cheque")
    {
        
}
}
group("Control1100286043")
{
        
                CaptionML=ESP='Varios';
    field("Imp Lineas Documentos";rec."Imp Lineas Documentos")
    {
        
}
    field("Imp Use";rec."Imp Use")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             SetNoFieldVisible;
                             CurrPage.UPDATE;
                           END;


}
    field("Pagare sin Barras";rec."Pagare sin Barras")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             SetNoFieldVisible;
                             CurrPage.UPDATE;
                           END;


}
}
group("QB_PAGARE")
{
        
                CaptionML=ENU='QuoBuilding',ESP='Pagar‚s Sin C.Barras';
                Visible=vPagBarras;
    field("QB_SerieBanco";rec."Serie banco")
    {
        
                Visible=verRelacionesPagos;
                Enabled=actBarras ;
}
    field("QB_NoControlCheque";rec."No. control cheque")
    {
        
                Visible=verRelacionesPagos;
                Enabled=actBarras ;
}
    field("QB_NoChequeAdicional";rec."No. cheque adicional")
    {
        
                Visible=false;
                Enabled=actBarras ;
}
    field("QB_NoControlChequeAdicional";rec."No. control cheque adicional")
    {
        
                Visible=false;
                Enabled=actBarras ;
}
    field("QB_N67Obligatoria";rec."N67 Obligatoria")
    {
        
                Visible=verRelacionesPagos;
                Enabled=actBarras ;
}
    field("QB_DigitosBancoN67";rec."Digitos banco N 67")
    {
        
                Visible=verRelacionesPagos;
                Enabled=actBarras ;
}
    field("QB_FechaUltFicheroN67";rec."Fecha ult. fichero N67")
    {
        
                Visible=verRelacionesPagos;
                Enabled=actBarras ;
}
}
}
group("QB_Matricial")
{
        
                CaptionML=ENU='QuoBuilding',ESP='Impresi¢n en Matricial';
                Visible=vMatricial;
    field("Imp Impresora";rec."Imp Impresora")
    {
        
}
    field("Imp Lineas";rec."Imp Lineas")
    {
        
}
    field("Imp Importe Lin";rec."Imp Importe Lin")
    {
        
}
    field("Imp Importe Col";rec."Imp Importe Col")
    {
        
}
    field("Imp Importe Lon";rec."Imp Importe Lon")
    {
        
}
    field("Imp Letras1 Lin";rec."Imp Letras1 Lin")
    {
        
}
    field("Imp Letras1 Col";rec."Imp Letras1 Col")
    {
        
}
    field("Imp Letras1 Lon";rec."Imp Letras1 Lon")
    {
        
}
    field("Imp Letras2 Lin";rec."Imp Letras2 Lin")
    {
        
}
    field("Imp Letras2 Col";rec."Imp Letras2 Col")
    {
        
}
    field("Imp Letras2 Lon";rec."Imp Letras2 Lon")
    {
        
}
    field("Imp Destinatario Lin";rec."Imp Destinatario Lin")
    {
        
}
    field("Imp Destinatario Col";rec."Imp Destinatario Col")
    {
        
}
    field("Imp Destinatario Lon";rec."Imp Destinatario Lon")
    {
        
}
    field("Imp Firma Lin";rec."Imp Firma Lin")
    {
        
}
    field("Imp Firma Lugar Col";rec."Imp Firma Lugar Col")
    {
        
}
    field("Imp Firma Lugar Lon";rec."Imp Firma Lugar Lon")
    {
        
}
    field("Imp Firma Dia Col";rec."Imp Firma Dia Col")
    {
        
}
    field("Imp Firma Mes Col";rec."Imp Firma Mes Col")
    {
        
}
    field("Imp Firma A¤o Col";rec."Imp Firma AÂ¤o Col")
    {
        
}
    field("Imp Vto Lin";rec."Imp Vto Lin")
    {
        
}
    field("Imp Vto Dia Col";rec."Imp Vto Dia Col")
    {
        
}
    field("Imp Vto Mes Col";rec."Imp Vto Mes Col")
    {
        
}
    field("Imp Vto AÂ¤o Col";rec."Imp Vto AÂ¤o Col")
    {
        
}
}
    part("QM_Data_Synchronization_Log";7174395)
    {
        
                SubPageView=SORTING("Table","RecordID","With Company");SubPageLink="Table"=CONST(18), "Code 1"=field("No.");
                Visible=verMasterData;
}
}

}

actions
{
addafter("Posted Pa&yable Bills")
{
    action("QB_CreditPolicies")
    {
        CaptionML=ENU='Credit policies',ESP='Polizas de cr‚dito';
                      RunObject=Page 7207306;
                      RunPageView=SORTING("No.");
RunPageLink="No."=field("No.");
                      Promoted=true;
                      Image=ViewPage;
}
}


modify("Cash Receipt Journals")
{
CaptionML=ENU='Cash Receipt Journals',ESP='Diarios de recibos de efectivo';


}

}

//trigger
trigger OnOpenPage()    VAR
                 "Contact" : Record 5050;
                 QMMasterDataManagement : Codeunit 7174368;
               BEGIN
                 ContactActionVisible := "Contact".READPERMISSION;
                 SetNoFieldVisible;

                 //JAV 24/6/19: - Se hace visible el panel de Pagos de Efectos seg£n si en configuraci¢n est  activo
                 verRelacionesPagos := FunctionQB.AccessToPaymentRelations;

                 //Confirming y factoring
                 seeConfirming := FunctionQB.QB_UseConfirmingLines;
                 seeFactoring  := FunctionQB.QB_UseFactoringLines;

                 //JAV 01/03/21: - QB 1.08.19 Se pasan funciones de QBSetup a Functions QB
                 //JAV 14/02/22: - QM 1.00.00 Se pasana las funciones de MasterData a su propia CU
                 verMasterData := QMMasterDataManagement.SetMasterDataVisible(DATABASE::"Bank Account");
               END;
trigger OnAfterGetCurrRecord()    BEGIN
                           rec.GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
                           ShowBankLinkingActions := rec.StatementProvidersExist;
                           actBarras := rec."Pagare sin Barras";

                           //JAV 14/02/22: - QM 1.00.00 Se pasan los valores adecuados a la subp gina
                           CurrPage.QM_Data_Synchronization_Log.PAGE.SetData(Rec.RECORDID);
                         END;


//trigger

var
      Text001 : TextConst ENU='There may be a statement using the %1.\\Do you want to change Balance Last Statement?',ESP='Es posible que haya un extracto que usa %1.\\¨Desea cambiar el saldo de £ltimo extracto?';
      Text002 : TextConst ENU='Canceled.',ESP='Cancelado.';
      ContactActionVisible : Boolean ;
      Linked : Boolean;
      OnlineBankAccountLinkingErr : TextConst ENU='You must link the bank account to an online bank account.\\Choose the Link to Online Bank Account action.',ESP='Debe vincular el banco a un banco en l¡nea.\\Elija la acci¢n Vincular a banco en l¡nea.';
      ShowBankLinkingActions : Boolean;
      NoFieldVisible : Boolean;
      OnlineFeedStatementStatus: Option "not Linked","Linked","Linked and Auto. Bank Statement Enabled";
      "---------------------------------------- QB" : Integer;
      verRelacionesPagos : Boolean ;
      FunctionQB : Codeunit 7207272;
      actBarras : Boolean;
      vMatricial : Boolean;
      vPagBarras : Boolean;
      verMasterData : Boolean;
      seeConfirming : Boolean;
      seeFactoring : Boolean;

    
    

//procedure
LOCAL procedure SetNoFieldVisible();
    var
      DocumentNoVisibility : Codeunit 1400;
    begin
      NoFieldVisible := DocumentNoVisibility.BankAccountNoIsVisible;
      vMatricial := rec."Imp Use";
      vPagBarras := rec."Pagare sin Barras";
    end;

//procedure
}

