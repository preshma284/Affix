report 7207287 "Gen. Due Milestone Invoice"
{
  
  
    ProcessingOnly=true;
    
  dataset
{

DataItem("InvMilest";"Invoice Milestone")
{

               DataItemTableView=SORTING("Customer Code","Currency Code");
               PrintOnlyIfDetail=true;
               

               RequestFilterFields="Completion Date";
trigger OnPreDataItem();
    BEGIN 
                               IF GETFILTER("Completion Date") = '' THEN BEGIN 
                                 IF NOT booGenerateSaleHeader THEN
                                   SETRANGE("Completion Date",0D,WORKDATE)
                                 ELSE
                                   SETRANGE("Completion Date",0D,varDate);
                               END;

                               InvMilest.SETFILTER("Draft Invoice No.",'=%1','');
                               InvMilest.SETFILTER("Posted Invoice No.",'=%1','');

                               OldCust:='';
                               OldCurrency:='';

                               IF booGenerateSaleHeader THEN BEGIN 
                                 IF SaleCust <> FilterCust THEN
                                   ERROR(Text002);
                                 IF Currency <> FilterCurrency THEN
                                    ERROR(Text003);
                               END;

                               Window.OPEN(Text001 +
                                            Text004 +
                                            Text005 +
                                            Text006 );

                               totals:=InvMilest.COUNT;
                             END;

trigger OnAfterGetRecord();
    BEGIN 

                                  read := read + 1;
                                  IF totals<>0 THEN
                                    Window.UPDATE(1,ROUND(read/totals*10000,1));
                                  IF "Completion Date" = 0D THEN
                                    CurrReport.SKIP;
                                  IF (InvMilest."Customer Code"<>OldCust) OR
                                     (InvMilest."Currency Code"<>OldCurrency) THEN
                                        CreateInvHeader;

                                  CreateInvLines;
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  
    var
//       FilterMilest@7001104 :
      FilterMilest: Text[250];
//       FilterCust@7001103 :
      FilterCust: Text[250];
//       FilterCurrency@7001102 :
      FilterCurrency: Text[250];
//       FilterJob@7001101 :
      FilterJob: Text[250];
//       FilterCompDate@7001100 :
      FilterCompDate: Text[250];
//       booGenerateSaleHeader@7001105 :
      booGenerateSaleHeader: Boolean;
//       varDate@7001106 :
      varDate: Date;
//       SaleCust@7001110 :
      SaleCust: Code[20];
//       Currency@7001109 :
      Currency: Code[27];
//       OldCust@7001108 :
      OldCust: Code[20];
//       OldCurrency@7001107 :
      OldCurrency: Code[20];
//       Window@7001111 :
      Window: Dialog;
//       totals@7001112 :
      totals: Integer;
//       read@7001113 :
      read: Integer;
//       NoJob@7001115 :
      NoJob: Code[20];
//       NoDoc@7001114 :
      NoDoc: Code[20];
//       InvoiceCust@7001116 :
      InvoiceCust: Code[20];
//       recSalesHeader@7001117 :
      recSalesHeader: Record 36;
//       NoHeader@7001118 :
      NoHeader: Integer;
//       Job@7001119 :
      Job: Record 167;
//       JobPostingGroup@7001120 :
      JobPostingGroup: Record 208;
//       recAccount@7001121 :
      recAccount: Record 15;
//       SalesLine@7001122 :
      SalesLine: Record 37;
//       NoLine@7001123 :
      NoLine: Integer;
//       recCommentMilest@7001124 :
      recCommentMilest: Record 7207332;
//       recInvMilest@7001125 :
      recInvMilest: Record 7207331;
//       Text001@7001131 :
      Text001: TextConst ENU='Creating Due Milestone Invoices',ESP='Generando facturas Hitos vencidos';
//       Text002@7001130 :
      Text002: TextConst ENU='You cannot select another Customer if you execute action from Invoice',ESP='No se puede seleccionar otro Cliente si ejecuta la acci¢n desde la Factura';
//       Text003@7001129 :
      Text003: TextConst ENU='You cannot select another Currency if you execute action from Invoce',ESP='No se puede seleccionar otra Divisa si ejecuta la acci¢n desde la Factura';
//       Text004@7001128 :
      Text004: TextConst ENU='    @1@@@@@@@@@@@@@@@ \',ESP='    @1@@@@@@@@@@@@@@@ \';
//       Text005@7001127 :
      Text005: TextConst ENU='Invoice Header                              #2###### \',ESP='Cabecera Factura                              #2###### \';
//       Text006@7001126 :
      Text006: TextConst ENU='Invoice Lines                                 #3###### \',ESP='L¡nea Factura                                 #3###### \';
//       textConst1@7001132 :
      textConst1: TextConst ENU='Milestone Invoicing No: ',ESP='Facturaci¢n del hito N§: ';

    

trigger OnPreReport();    begin
                  FilterMilest := InvMilest.GETFILTERS;
                  FilterJob := InvMilest.GETFILTER("Job No.");
                  FilterCust := InvMilest.GETFILTER("Customer Code");
                  FilterCurrency := InvMilest.GETFILTER("Currency Code");
                  FilterCompDate := InvMilest.GETFILTER("Completion Date");
                end;



// procedure SetSalesHeader (locSalesHeader@1000000000 : Record 36;BooSalesHeader@1000000001 :
procedure SetSalesHeader (locSalesHeader: Record 36;BooSalesHeader: Boolean)
    begin
      NoJob := locSalesHeader."QB Job No.";
      NoDoc := locSalesHeader."No.";
      Currency := locSalesHeader."Currency Code";
      SaleCust := locSalesHeader."Sell-to Customer No.";
      InvoiceCust := locSalesHeader."Bill-to Customer No.";
      varDate := locSalesHeader."Document Date";
      booGenerateSaleHeader := BooSalesHeader;
    end;

    procedure CreateInvHeader ()
    begin
      NoHeader := NoHeader + 1;
      if not booGenerateSaleHeader then begin
        //if CurrReport.TOTALSCAUSEDBY=InvMilest.FIELDNO(InvMilest."Currency Code") then begin
          Window.UPDATE(2,NoHeader);
          recSalesHeader.INIT;
          recSalesHeader."Document Type":=recSalesHeader."Document Type"::Invoice;
          recSalesHeader."No.":='';
          recSalesHeader.INSERT(TRUE);
          recSalesHeader.VALIDATE("Sell-to Customer No.",InvMilest."Customer Code");
          recSalesHeader.VALIDATE("Bill-to Customer No.",InvMilest."Customer Code");
          recSalesHeader.VALIDATE("QB Job No.",InvMilest."Job No.");
          recSalesHeader."Posting Date":=WORKDATE;
          recSalesHeader."Document Date":=WORKDATE;
          recSalesHeader.VALIDATE("Currency Code",InvMilest."Currency Code");
          if InvMilest."Payment Method Code"<>'' then
            recSalesHeader.VALIDATE("Payment Method Code",InvMilest."Payment Method Code");
          if InvMilest."Payment Terms Code"<>'' then
            recSalesHeader.VALIDATE("Payment Terms Code",InvMilest."Payment Terms Code");
          recSalesHeader.MODIFY;
        //end;
      end;
      OldCust:=InvMilest."Customer Code";
      OldCurrency:=InvMilest."Currency Code";
    end;

    procedure CreateInvLines ()
    begin
      //se generan las l¡neas de venta
      //si existen registros hay que insertar una linea de factura por cada una de hitos facturaci¢n vencidos

      NoSalesLine;
      Window.UPDATE(3,NoLine);
      InvMilest.TESTFIELD(InvMilest."Job No.");
      Job.GET(InvMilest."Job No.");
      Job.TESTFIELD(Job."Job Posting Group");
      JobPostingGroup.GET(Job."Job Posting Group");
      SalesLine."Document Type":=SalesLine."Document Type"::Invoice;
      if booGenerateSaleHeader then
        SalesLine."Document No.":=NoDoc;
      if not booGenerateSaleHeader then
        SalesLine."Document No.":=recSalesHeader."No.";
      SalesLine."Line No.":=NoLine;
      SalesLine.INSERT(TRUE);

      //JAV 14/04/21: - QB 1.08.39 Usar otros tipos, no solo cuenta
      CASE JobPostingGroup."QB Invoice Certi. Type" OF
        JobPostingGroup."QB Invoice Certi. Type"::Standar:  //Si no se ha definido otra cosa, usar esta cuenta que es la estandar de Busines Central
          begin
            SalesLine.Type := SalesLine.Type::"G/L Account";
            SalesLine.VALIDATE("No.",JobPostingGroup."Recognized Sales Account");
          end;
        JobPostingGroup."QB Invoice Certi. Type"::Account:  //Si usamos cuenta
          begin
            SalesLine.Type := SalesLine.Type::"G/L Account";
            SalesLine.VALIDATE("No.",JobPostingGroup."QB Invoice Certi. No.");
          end;
        JobPostingGroup."QB Invoice Certi. Type"::Resource: //Si usamos recurso
          begin
            SalesLine.Type := SalesLine.Type::Resource;
            SalesLine.VALIDATE("No.",JobPostingGroup."QB Invoice Certi. No.");
          end;
        JobPostingGroup."QB Invoice Certi. Type"::Item: //Si usamos producto
          begin
            SalesLine.Type := SalesLine.Type::Item;
            SalesLine.VALIDATE("No.",JobPostingGroup."QB Invoice Certi. No.");
          end;
      end;
      //Usar el grupo de IVA asociado al proyecto si est  definido, si no usar  el asociado al registro usado
      if (Job."VAT Prod. PostingGroup" <> '') then
        ////SalesLine.VALIDATE("VAT Bus. Posting Group", Job."VAT Prod. PostingGroup");
        SalesLine.VALIDATE("VAT Prod. Posting Group", Job."VAT Prod. PostingGroup");   //JAV 02/12/21: - QB 1.10.06 Estaba mal la variable que se utilizaba

      SalesLine.VALIDATE(SalesLine."Sell-to Customer No.",SaleCust);
      SalesLine.VALIDATE(SalesLine."Bill-to Customer No.",InvoiceCust);
      SalesLine.VALIDATE(SalesLine."Job No.",InvMilest."Job No.");
      SalesLine."Shipment Date":=InvMilest."Completion Date";
      SalesLine.Description:= textConst1 + InvMilest."Milestone No.";
      SalesLine.VALIDATE("Currency Code",InvMilest."Currency Code");
      SalesLine.VALIDATE(SalesLine."Location Code",Job."Job Location");
      SalesLine.VALIDATE("Unit Price",InvMilest.Amount);
      SalesLine.VALIDATE(Quantity,1);
      SalesLine.VALIDATE(Amount,InvMilest.Amount);
      SalesLine.VALIDATE(SalesLine."QB Milestone No.",InvMilest."Milestone No.");
      SalesLine.MODIFY(TRUE);
      updtNoInvoiceDraft;

      recCommentMilest.RESET;
      recCommentMilest.SETRANGE("Milestone No.",InvMilest."Milestone No.");
      ////recCommentMilest.SETRANGE("Milestone No.",InvMilest."Job No.");
      recCommentMilest.SETRANGE("Job No.",InvMilest."Job No.");  //JAV 02/12/21: - QB 1.10.06 Estaba mal la variable que se utilizaba
      if recCommentMilest.FINDFIRST then
        repeat
          SalesLine.INIT;
          NoSalesLine;
          SalesLine."Document Type":=SalesLine."Document Type"::Invoice;
          SalesLine."Document No.":=recSalesHeader."No.";
          SalesLine.Type:=SalesLine.Type::" ";
          SalesLine."Line No.":=NoLine;
          SalesLine."No.":='';
          SalesLine.Description:=recCommentMilest.Comment;
          SalesLine.INSERT(TRUE);
        until recCommentMilest.NEXT=0;


      recInvMilest.RESET;
      recInvMilest.SETRANGE("Milestone No.",SalesLine."QB Milestone No.");
      ////recInvMilest.SETRANGE("Milestone No.",SalesLine."Job No."); //tb se filtra por el proy
      recInvMilest.SETRANGE("Job No.",SalesLine."Job No.");   //JAV 02/12/21: - QB 1.10.06 Estaba mal la variable que se utilizaba
      if recInvMilest.FINDFIRST then begin
        if booGenerateSaleHeader then
          recInvMilest."Draft Invoice No.":=NoDoc;
        if not booGenerateSaleHeader then
          recInvMilest."Draft Invoice No.":=recSalesHeader."No.";
        recInvMilest.MODIFY;
      end;
    end;

    procedure NoSalesLine ()
    var
//       locSalesLine@1000000000 :
      locSalesLine: Record 37;
    begin
      locSalesLine.RESET;
      if booGenerateSaleHeader=TRUE then
        locSalesLine.SETRANGE("Document No.",NoDoc);
      if not booGenerateSaleHeader then
        locSalesLine.SETRANGE("Document No.",recSalesHeader."No.");
      locSalesLine.SETRANGE("Document Type",locSalesLine."Document Type"::Invoice);
      if locSalesLine.FINDLAST then
        NoLine:=locSalesLine."Line No."+10000
      else
        NoLine:=10000;
    end;

    procedure updtNoInvoiceDraft ()
    begin
      if recInvMilest.GET(SalesLine."Job No.",SalesLine."QB Milestone No.") then begin
        recInvMilest."Draft Invoice No." := SalesLine."Document No.";
        recInvMilest.MODIFY;
      end;
    end;

    /*begin
    //{
//      JAV 02/12/21: - QB 1.10.06 Estaba mal la variable que se utilizaba
//    }
    end.
  */
  
}



