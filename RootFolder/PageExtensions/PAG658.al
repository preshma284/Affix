pageextension 50240 MyExtension658 extends 658//454
{
layout
{
addafter("Approval Type")
{
//     field("Document Type";rec."Document Type")
//     {
        
//                 ToolTipML=ENU='Specifies the type of document that an approval entry has been created for. Approval entries can be created for six different types of sales or purchase documents:',ESP='Especifica el tipo de documento para el que se ha creado un movimiento de aprobaci¢n. Se pueden crear movimientos de aprobaci¢n para seis tipos diferentes de documentos de compra o venta:';
//                 ApplicationArea=Suite;
//                 Visible=FALSE ;
// }
    field("QB Document Type";rec."QB Document Type")
    {
        
                ToolTipML=ENU='Specifies the type of document that an approval entry has been created for. Approval entries can be created for six different types of sales or purchase documents:',ESP='Especifica el tipo de documento para el que se ha creado un movimiento de aprobaci¢n. Se pueden crear movimientos de aprobaci¢n para seis tipos diferentes de documentos de compra o venta:';
                ApplicationArea=Suite;
                Visible=FALSE ;
}
} addafter("Salespers./Purch. Code")
{
    field("QB Position";rec."QB Position")
    {
        
}
} addafter("Approver ID")
{
    field("DelegateID";"DelegateID")
    {
        
                CaptionML=ESP='Id. Delegado';
}
} addafter("Currency Code")
{
    field("Amount";rec."Amount")
    {
        
                ToolTipML=ENU='Specifies the total amount (excl. VAT) on the document awaiting approval.',ESP='Especifica el importe total (sin IVA) del documento en espera de aprobaci¢n.';
                ApplicationArea=Suite;
}
} addafter("Amount (LCY)")
{
    field("QB_Type";rec."Type")
    {
        
}
    field("QB_WithholdingPayment>";rec."Withholding")
    {
        
}
    field("QB_CustVendNo";"CustVendNo")
    {
        
                CaptionML=ENU='Cust/Vend Name',ESP='Cliente/Proveedor';
}
    field("QB_CustVendName";"CustVendName")
    {
        
                CaptionML=ENU='Cust/Vend Name',ESP='Nombre Cliente/Proveedor';
}
    field("QB_JobNo";rec."Job No.")
    {
        
                Visible=false ;
}
} addfirst("factboxes")
{    part("QB_ApprovalsFactBox";7207383)
    {
        
                SubPageView=SORTING("Entry No.");SubPageLink="Entry No."=field("Entry No.");
}
    part("CommentsFactBox";9104)
    {
        
                ApplicationArea=Suite;
                Visible=ShowCommentFactbox;
}
}


modify("Approval Type")
{
Visible=false ;


}


modify("Details")
{
Visible=false ;


}


modify("Salespers./Purch. Code")
{
Visible=false ;


}

}

actions
{



//modify("Comments")
//{
//
//
//}
//
}

//trigger
trigger OnOpenPage()    BEGIN
                 //rec.MarkAllWhereUserisApproverOrSender;

                 //QB Ordenar por secuencia de aprobaci¢n, no por el momento de creaci¢n, salen desordenados cuando van muy seguidos
                 Rec.SETCURRENTKEY("Entry No.");
                 //Limpiar el FactBox de datos del documento
                 //CurrPage.QB_ApprovalsFactBox.PAGE.ClearData;
               END;
trigger OnAfterGetRecord()    BEGIN
                       Overdue := Overdue::" ";
                       IF FormatField(Rec) THEN
                         Overdue := Overdue::Yes;

                       RecordIDText := FORMAT(rec."Record ID to Approve",0,1);

                       //QB
                       QB_OnAfterGetRecord;
                     END;
trigger OnAfterGetCurrRecord()    VAR
                           RecRef : RecordRef;
                         BEGIN
                           ShowChangeFactBox := CurrPage.Change.PAGE.SetFilterFromApprovalEntry(Rec);
                           DelegateEnable := rec.CanCurrentUserEdit;
                           ShowRecCommentsEnabled := RecRef.GET(rec."Record ID to Approve");

                           //QB
                           QB_OnAfterGetRecord;
                         END;


//trigger

var
      Overdue: Option "Yes"," ";
      RecordIDText : Text;
      ShowChangeFactBox : Boolean;
      DelegateEnable : Boolean;
      ShowRecCommentsEnabled : Boolean;
      "--------------------------------------- QB" : Integer;
      ShowCommentFactbox : Boolean;
      NewComment : Boolean;
      DelegateID : Text;
      CustVendNo : Text;
      CustVendName : Text;
      Job : Record 167;
      DataPieceworkForProduction : Record 7207386;
      JobDescription : Text[50];
      BudgetItemDescription : Text;

    

//procedure
procedure Setfilters(TableId : Integer;DocumentType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";DocumentNo : Code[20]);
   begin
     if ( TableId <> 0  )then begin
       Rec.FILTERGROUP(2);
       Rec.SETCURRENTKEY("Table ID","Document Type","Document No.","Date-Time Sent for Approval");
       Rec.SETRANGE("Table ID",TableId);
       Rec.SETRANGE("Document Type",DocumentType);
       if ( DocumentNo <> ''  )then
         Rec.SETRANGE("Document No.",DocumentNo);
       Rec.FILTERGROUP(0);
     end;
   end;
Local procedure FormatField(ApprovalEntry : Record 454) : Boolean;
   begin
     if ( rec.Status IN [rec."Status"::Created,rec."Status"::Open]  )then begin
       if ( ApprovalEntry."Due Date" < TODAY  )then
         exit(TRUE);

       exit(FALSE);
     end;
   end;
//
//    //[External]
//procedure CalledFrom();
//    begin
//      Overdue := Overdue::" ";
//    end;
procedure QB_SetDocument(DocType : Option);
    begin
      Rec.FILTERGROUP(2);
      Rec.SETRANGE("QB Document Type",DocType);
      Rec.FILTERGROUP(0);
    end;
LOCAL procedure QB_OnAfterGetRecord();
    var
      UserSetup : Record 91;
      ApprovalsMgmt : Codeunit 1535;
      tmpApprovalEntry : Record 454;
      QBApprovalManagement : Codeunit 7207354;
    begin
      ShowCommentFactbox := NewComment or CurrPage.CommentsFactBox.PAGE.SetFilterFromApprovalEntry(Rec);

      DelegateID := '';
      if ( (rec.Status IN[rec."Status"::Open,rec."Status"::Created])  )then begin
        //JAV 14/06/22: - QB 1.10.49 En la funci¢n est ndar est  mal la verificaci¢n, la hago aqu¡ para sar un error correcto
        if ( not UserSetup.GET(Rec."Approver ID")  )then begin
          MESSAGE('El usuario %1 no existe en la configuraci¢n de usuarios, debe crearlo', Rec."Approver ID");
          exit;
        end;

        tmpApprovalEntry := Rec;
        tmpApprovalEntry."Entry No." := -tmpApprovalEntry."Entry No.";
        tmpApprovalEntry.Status := rec."Status"::Open;
        tmpApprovalEntry.INSERT;

        ApprovalsMgmt.DelegateSelectedApprovalRequest(tmpApprovalEntry,FALSE);
        tmpApprovalEntry.GET(tmpApprovalEntry."Entry No.");
        if ( (tmpApprovalEntry."Approver ID" <> rec."Approver ID")  )then
          DelegateID := tmpApprovalEntry."Approver ID";
        tmpApprovalEntry.DELETE;
      end;


      //CPA 16/03/22: - QB 1.10.27 (Q16730 Roig) Agregar una columna con el n£mero y nombre del proveedor en las pantallas de aprobaciones.
      QBApprovalManagement.GetCustVendFromRecRef(Rec."Record ID to Approve", CustVendNo, CustVendName);

      //+18218
      JobDescription := '';
      if ( Job.GET(Rec."Job No.")  )then
        JobDescription := Job.Description;

      BudgetItemDescription := '';
      if ( DataPieceworkForProduction.GET(Rec."Job No.", Rec."QB_Piecework No.")  )then
        BudgetItemDescription := DataPieceworkForProduction.Description;
      //-18218
    end;

//procedure
}

