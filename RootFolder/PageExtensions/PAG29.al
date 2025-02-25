pageextension 50169 MyExtension29 extends 29//25
{
layout
{
addafter("Vendor No.")
{
    field("QB_VendorName";rec."QB Vendor Name")
    {
        
                CaptionML=ESP='Nombre';
}
    field("QB_VendorPostingGroup";rec."Vendor Posting Group")
    {
        
}
} addafter("Document Date")
{
    field("QB_JobNo";rec."QB Job No.")
    {
        
}
    field("QB_BudgetItem";rec."QB Budget Item")
    {
        
}
    field("Applies-to Doc. No.";rec."Applies-to Doc. No.")
    {
        
}
} addafter("Due Date")
{
    field("QB Original Due Date";rec."QB Original Due Date")
    {
        
}
} addafter("Dimension Set ID")
{
    field("QB Payable Bank No.";rec."QB Payable Bank No.")
    {
        
}
    field("QB_BankName";FunctionQB.GetBankName(rec."QB Payable Bank No."))
    {
        
                CaptionML=ESP='Nombre del banco';
                Enabled=false ;
}
    field("QuoSII Exported";rec."QuoSII Exported")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Invoice Type";rec."QuoSII Purch. Invoice Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Corr. Inv. Type";rec."QuoSII Purch. Corr. Inv. Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Cr.Memo Type";rec."QuoSII Purch. Cr.Memo Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Special Reg.";rec."QuoSII Purch. Special Reg.")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Special Reg. 1";rec."QuoSII Purch. Special Reg. 1")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. Special Reg. 2";rec."QuoSII Purch. Special Reg. 2")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Purch. UE Inv Type";rec."QuoSII Purch. UE Inv Type")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII UE Country";rec."QuoSII UE Country")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Bienes Description";rec."QuoSII Bienes Description")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Operator Address";rec."QuoSII Operator Address")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII AEAT Status";rec."QuoSII AEAT Status")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Ship No.";rec."QuoSII Ship No.")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Third Party";rec."QuoSII Third Party")
    {
        
                Visible=vQuoSII ;
}
    field("QuoSII Entity";rec."QuoSII Entity")
    {
        
                Visible=vQuoSII ;
}
} addafter("Control1905767507")
{
}

}

actions
{
addfirst("F&unctions")
{
    action("Exports")
    {
        
                      CaptionML=ENU='First half-year Export',ESP='Exportar primer semestre';
                      ToolTipML=ENU='Exports First half-year movements in excel format',ESP='Exporta movimientos de cliente del primer semestre en formato excel para env¡o SII';
                      Visible=vQuoSII;
                      Image=Excel;
                      Scope=Repeater;
                      
                                trigger OnAction()    VAR
                                 SIIManagement : Codeunit 7174331;
                                 TipoExportacion: Option "Customer","Vendor";
                               BEGIN
                                 //QuoSII.B9.Begin
                                 SIIManagement.CSVExportEntries(TipoExportacion::Vendor);
                                 //QuoSII.B9.End
                               END;


}
    action("Imports")
    {
        
                      CaptionML=ENU='First half-year Import',ESP='Importar primer semestre';
                      ToolTipML=ENU='Imports First half-year movements in excel format',ESP='Importa movimientos de cliente del primer semestre en formato excel para env¡o SII';
                      Visible=vQuoSII;
                      Image=Excel;
                      Scope=Repeater;
                      
                                trigger OnAction()    VAR
                                 SIIManagement : Codeunit 7174331;
                                 TipoExportacion: Option "Customer","Vendor";
                               BEGIN
                                 //QuoSII.B9.Begin
                                 SIIManagement.CSVImportEntries(TipoExportacion::Vendor);
                                 //QuoSII.B9.End
                               END;


}
    separator("Action1100286002")
    {
        
}
}

}

//trigger
trigger OnOpenPage()    BEGIN
                 SetConrolVisibility;

                 IF Rec.GETFILTERS <> '' THEN
                   IF Rec.FINDFIRST THEN;

                 vQuoSII := FunctionQB.AccessToQuoSII;
               END;
trigger OnAfterGetRecord()    BEGIN
                       StyleTxt := rec.SetStyle;
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           IncomingDocument : Record 130;
                         BEGIN
                           HasIncomingDocument := IncomingDocument.PostedDocExists(rec."Document No.",rec."Posting Date");
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;


//trigger

var
      Navigate : Page 344;
      DimensionSetIDFilter : Page 481;
      CreatePayment : Page 1190;
      StyleTxt : Text;
      HasIncomingDocument : Boolean;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;
      "--------------------- QB" : Integer;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;

    
    

//procedure
Local procedure SetConrolVisibility();
   var
     GLSetup : Record 98;
   begin
     GLSetup.GET;
     AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
     DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
   end;
//Local procedure GetBatchRecord(var GenJournalBatch : Record 232);
//    var
//      GenJournalTemplate : Record 80;
//      JournalTemplateName : Code[10];
//      JournalBatchName : Code[10];
//    begin
//      GenJournalTemplate.RESET;
//      GenJournalTemplate.SETRANGE(Type,GenJournalTemplate.Type::Payments);
//      GenJournalTemplate.SETRANGE(Recurring,FALSE);
//      if ( GenJournalTemplate.FINDFIRST  )then
//        JournalTemplateName := GenJournalTemplate.Name;
//
//      JournalBatchName := CreatePayment.GetBatchNumber;
//
//      GenJournalTemplate.GET(JournalTemplateName);
//      GenJournalBatch.GET(JournalTemplateName,JournalBatchName);
//    end;

//procedure
}

