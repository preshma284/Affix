report 7207324 "Generate Purchase Order"
{
  
  
    CaptionML=ENU='Generate Purchase Order',ESP='Generar pedidos compra necesid';
    ProcessingOnly=true;
    
  dataset
{

DataItem("PurchJnlLine";"Purchase Journal Line")
{

               DataItemTableView=SORTING("Job No.","Line No.")
                                 ORDER(Ascending);
               

               RequestFilterFields="Job No.","No.","Location Code","Vendor No.";
trigger OnPreDataItem();
    BEGIN 
                               Window.OPEN(Text001 +
                                            Text002 +
                                            Text003 +
                                            Text004 );

                               Total := PurchJnlLine.COUNT;  //JAV 05/08/19: - Se cambia COUNTAPROX pues est  obsoleto
                               HeaderNo := 0;
                               LineNo := 0;
                               ProjectInProgress := '';
                               VendorInProgress := '';
                               FromComparative := '';
                               ToComparative := '';
                               LineCount := 0;

                               PurchJnlLine.SETRANGE(Generate, TRUE);  //JAV 04/05/20: - Solo l¡neas marcadas para generar
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF PurchJnlLine."Vendor No." = '' THEN
                                    CurrReport.SKIP;

                                  IF SubtractAvailable THEN BEGIN 
                                    Tem_InvoicePostBuffer.SETRANGE(Type,PurchJnlLine.Type);
                                    Tem_InvoicePostBuffer.SETRANGE("G/L Account",PurchJnlLine."No.");
                                    IF NOT Tem_InvoicePostBuffer.FINDFIRST THEN BEGIN 
                                      PurchJnlLine.CALCFIELDS("Stock Contracts Items (Base)","Stock Contracts Resource (B)");
                                      Tem_InvoicePostBuffer.Type := PurchJnlLine.Type;
                                      Tem_InvoicePostBuffer."G/L Account" := PurchJnlLine."No.";
                                      Tem_InvoicePostBuffer.INSERT;
                                      IF PurchJnlLine.Type = PurchJnlLine.Type::Item THEN
                                        Tem_InvoicePostBuffer.Quantity := PurchJnlLine."Stock Location (Base)" + PurchJnlLine.
                                                                     "Stock Contracts Items (Base)"
                                      ELSE
                                        Tem_InvoicePostBuffer.Quantity := PurchJnlLine."Stock Contracts Items (Base)";
                                      Tem_InvoicePostBuffer.MODIFY;
                                    END;

                                    IF Tem_InvoicePostBuffer.Quantity > 0 THEN BEGIN 
                                      IF PurchJnlLine.Type = PurchJnlLine.Type::Item THEN BEGIN 
                                        Necessary := PurchJnlLine.Quantity - Tem_InvoicePostBuffer.Quantity;
                                        Tem_InvoicePostBuffer.Quantity := Tem_InvoicePostBuffer.Quantity - PurchJnlLine.Quantity;
                                        Tem_InvoicePostBuffer.MODIFY;
                                      END ELSE BEGIN 
                                        Necessary := PurchJnlLine.Quantity - Tem_InvoicePostBuffer.Quantity;
                                        Tem_InvoicePostBuffer.Quantity := Tem_InvoicePostBuffer.Quantity - PurchJnlLine.Quantity;
                                        Tem_InvoicePostBuffer.MODIFY;
                                      END
                                    END ELSE
                                     Necessary := PurchJnlLine.Quantity
                                  END ELSE
                                    Necessary := PurchJnlLine.Quantity;
                                  IF Necessary <= 0 THEN
                                    CurrReport.SKIP;
                                  IF VendorInProgress <> PurchJnlLine."Vendor No." THEN BEGIN 
                                    CreateHeader;
                                    LineCount := 0;
                                    VendorInProgress := PurchJnlLine."Vendor No.";
                                  END;
                                  IF ByJob THEN
                                    IF ProjectInProgress <> PurchJnlLine."Job No." THEN BEGIN 
                                      CreateHeader;
                                      LineCount := 0;
                                      ProjectInProgress := PurchJnlLine."Job No.";
                                    END;
                                  LineNo:=LineNo+1;
                                  Window.UPDATE(3,LineNo);
                                  PurchaseLine.INIT;
                                  PurchaseLine.VALIDATE(PurchaseLine."Document Type",PurchaseHeader."Document Type");
                                  PurchaseLine.VALIDATE("Document No.",PurchaseHeader."No.");
                                  LineCount := LineCount + 10000;
                                  PurchaseLine.VALIDATE(PurchaseLine."Line No.",LineCount);
                                  PurchaseLine.INSERT(TRUE);
                                  IF PurchJnlLine.Type=PurchJnlLine.Type::Resource THEN BEGIN 
                                    PurchaseLine.Type := PurchaseLine.Type::Resource;
                                    PurchaseLine.VALIDATE(PurchaseLine."No.",PurchJnlLine."No.");
                                  END;
                                  IF PurchJnlLine.Type=PurchJnlLine.Type::Item THEN BEGIN 
                                    PurchaseLine.Type := PurchaseLine.Type::Item;
                                    PurchaseLine.VALIDATE(PurchaseLine."No.",PurchJnlLine."No.");
                                  END;
                                  PurchaseLine.VALIDATE(PurchaseLine."Unit of Measure Code",PurchJnlLine."Unit of Measure Code");
                                  IF PurchJnlLine."Job No." <> '' THEN BEGIN 
                                    PurchaseLine.VALIDATE("Job No.",PurchJnlLine."Job No.");
                                    PurchaseLine."Location Code" := '';
                                  END ELSE BEGIN 
                                    PurchaseLine."Job No." := '';
                                    PurchaseLine.VALIDATE("Location Code",PurchJnlLine."Location Code");
                                  END;
                                  PurchaseLine.VALIDATE(PurchaseLine.Quantity,Necessary);
                                  PurchaseLine.VALIDATE("Direct Unit Cost",PurchJnlLine."Estimated Price");
                                  IF ByJob THEN BEGIN 
                                    IF PurchJnlLine."Job Unit" = '' THEN BEGIN 
                                      IF (Job2.GET(PurchaseLine."Job No.")) AND (Job2."Warehouse Cost Unit"<>'') THEN
                                        PurchaseLine.VALIDATE(PurchaseLine."Piecework No.",Job2."Warehouse Cost Unit");
                                    END ELSE
                                      PurchaseLine.VALIDATE(PurchaseLine."Piecework No.",PurchJnlLine."Job Unit");
                                  END;
                                  PurchaseLine.VALIDATE("Shortcut Dimension 1 Code",PurchJnlLine."Shortcut Dimension 1 Code");
                                  PurchaseLine.VALIDATE("Shortcut Dimension 2 Code",PurchJnlLine."Shortcut Dimension 2 Code");
                                  PurchaseLine.VALIDATE(PurchaseLine.Quantity,Necessary);
                                  PurchaseLine.VALIDATE("Direct Unit Cost",PurchJnlLine."Estimated Price");
                                  PurchaseLine.VALIDATE("Planned Receipt Date",PurchJnlLine."Date Needed");
                                  PurchaseLine.MODIFY(TRUE);

                                  PurchJnlLine.DELETE;
                                  PurchaseJournalLine2 := PurchJnlLine;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                Read := Read + 1;
                                IF Total <> 0 THEN
                                  Window.UPDATE(1,ROUND(Read / Total * 10000,1));
                              END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group496")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("ByJob";"ByJob")
    {
        
                  CaptionML=ESP='Por proyecto';
    }
    field("SubtractAvailable";"SubtractAvailable")
    {
        
                  CaptionML=ESP='Tener en cuenta existencias disponibles';
                  MultiLine=true 

    ;
    }

}

}
}
  }
  labels
{
}
  
    var
//       PurchaseHeader@7001116 :
      PurchaseHeader: Record 38;
//       PurchaseLine@7001123 :
      PurchaseLine: Record 39;
//       Tem_InvoicePostBuffer@7001121 :
      Tem_InvoicePostBuffer: Record 49;
//       PurchaseJournalLine2@7001124 :
      PurchaseJournalLine2: Record 7207281;
//       Job2@7001125 :
      Job2: Record 167;
//       ProjectInProgress@7001109 :
      ProjectInProgress: Code[20];
//       VendorInProgress@7001118 :
      VendorInProgress: Code[20];
//       FromComparative@7001108 :
      FromComparative: Code[20];
//       ToComparative@7001107 :
      ToComparative: Code[20];
//       CodeInitialComparative@7001117 :
      CodeInitialComparative: Code[20];
//       HeaderNo@7001106 :
      HeaderNo: Integer;
//       LineNo@7001105 :
      LineNo: Integer;
//       Total@7001104 :
      Total: Integer;
//       Read@7001103 :
      Read: Integer;
//       LineCount@7001119 :
      LineCount: Integer;
//       Necessary@7001122 :
      Necessary: Decimal;
//       ByJob@7001102 :
      ByJob: Boolean;
//       First@7001101 :
      First: Boolean;
//       SubtractAvailable@7001120 :
      SubtractAvailable: Boolean;
//       Window@7001100 :
      Window: Dialog;
//       Text001@7001115 :
      Text001: TextConst ENU='Generating Order',ESP='Generando pedidos';
//       Text002@7001114 :
      Text002: TextConst ENU=' @1@@@@@@@@@@\',ESP=' @1@@@@@@@@@@\';
//       Text003@7001113 :
      Text003: TextConst ENU='Order Header        #2#####\',ESP='Cabecera pedido        #2#####\';
//       Text004@7001112 :
      Text004: TextConst ENU='Order lines       #3#####\',ESP='L¡neas de pedido       #3#####\';
//       Text005@7001111 :
      Text005: TextConst ENU='Order %1 has been generated',ESP='Se han generado el pedido %1';
//       Text006@7001110 :
      Text006: TextConst ENU='%1 Order were generated. From Order %2 to Order %3',ESP='Se han generado %1 pedido. Desde el pedido %2 hasta el pedido %3';

    

trigger OnPostReport();    begin
                   Window.CLOSE;
                   if HeaderNo = 1 then
                     MESSAGE(Text005,PurchaseHeader."No.")
                   else
                     MESSAGE(Text006,HeaderNo,CodeInitialComparative,PurchaseHeader."No.");
                 end;



procedure CreateHeader ()
    var
//       PurchaseHeader2@7001100 :
      PurchaseHeader2: Record 38;
    begin
      PurchaseHeader2.RESET;
      PurchaseHeader2.SETRANGE("Document Type",PurchaseHeader2."Document Type"::Order);
      PurchaseHeader2.SETRANGE(PurchaseHeader2."No.",FromComparative,ToComparative);
      PurchaseHeader2.SETRANGE("Buy-from Vendor No.",PurchJnlLine."Vendor No.");
      if ByJob then
        PurchaseHeader2.SETRANGE("QB Job No.",PurchJnlLine."Job No.");
      if not PurchaseHeader2.FINDFIRST then begin
        HeaderNo += 1;
        Window.UPDATE(2,HeaderNo);
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.VALIDATE("No.");
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader.VALIDATE("Buy-from Vendor No.",PurchJnlLine."Vendor No.");
        //PurchaseHeader."_QB Type of Order" := PurchaseHeader."_QB Type of Order"::Mixed;  //JAV 21/01/22: - QB 1.10.12 Este campo ya no se utiliza
        if not ByJob then begin
          PurchaseHeader."QB Order To" := PurchaseHeader."QB Order To"::Location;
          PurchaseHeader."QB Job No." := '';
          PurchaseHeader.VALIDATE("Location Code",PurchJnlLine."Location Code");
        end else begin
          if PurchJnlLine."Job No." <> '' then begin
            PurchaseHeader."QB Order To" := PurchaseHeader."QB Order To"::Job;
            PurchaseHeader.VALIDATE("QB Job No.",PurchJnlLine."Job No.");
            PurchaseHeader."Location Code" := '';
          end else begin
            PurchaseHeader."QB Order To" := PurchaseHeader."QB Order To"::Location;
            PurchaseHeader."QB Job No." := '';
            PurchaseHeader.VALIDATE("Location Code",PurchJnlLine."Location Code");
          end;
        end;
        PurchaseHeader.VALIDATE("Order Date",WORKDATE);
        PurchaseHeader.MODIFY(TRUE);
        if not First then begin
          First := TRUE;
          CodeInitialComparative := PurchaseHeader."No.";
        end;
      end else
        PurchaseHeader := PurchaseHeader2;
      if FromComparative = '' then
        FromComparative := PurchaseHeader."No.";
      ToComparative := PurchaseHeader."No.";
    end;

    /*begin
    //{
//      JAV 05/08/19: - Se cambia COUNTAPROX pues est  obsoleto
//      JAV 21/01/22: - QB 1.10.11 Se eliminan campos relacionados con el contrato que no son utilizados en el programa para nada
//    }
    end.
  */
  
}



