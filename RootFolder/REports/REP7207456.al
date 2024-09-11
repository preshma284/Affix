report 7207456 "QB Review Purch.Receipts/Fin."
{
  ApplicationArea=All;



    CaptionML = ENU = 'Review Purchase Receipts/Financials', ESP = 'Revisi¢n Albaranes de Compra/Financiero';

    dataset
    {

        DataItem("tmpPurchRcptHeader"; "Purch. Rcpt. Header")
        {

            DataItemTableView = SORTING("No.");


            UseTemporary = true;
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(Filters; Filters)
            {
                //SourceExpr=Filters;
            }
            Column(FRI; FORMAT(tmpPurchRcptHeader."Receive in FRIS"))
            {
                //SourceExpr=FORMAT(tmpPurchRcptHeader."Receive in FRIS");
            }
            Column(ALB_Type; TRUE)
            {
                //SourceExpr=TRUE;
            }
            Column(DocumentNo; tmpPurchRcptHeader."No.")
            {
                //SourceExpr=tmpPurchRcptHeader."No.";
            }
            Column(PostingDate; tmpPurchRcptHeader."Posting Date")
            {
                //SourceExpr=tmpPurchRcptHeader."Posting Date";
            }
            Column(JobNo; tmpPurchRcptHeader."Job No.")
            {
                //SourceExpr=tmpPurchRcptHeader."Job No.";
            }
            Column(VendorNo; tmpPurchRcptHeader."Buy-from Vendor No.")
            {
                //SourceExpr=tmpPurchRcptHeader."Buy-from Vendor No.";

            }
            Column(VendorName; Vendor.Name)
            {
                //SourceExpr=Vendor.Name;
            }
            Column(Total; tmpPurchRcptHeader."QB Total Amount")
            {
                //SourceExpr=tmpPurchRcptHeader."QB Total Amount";
            }
            Column(Invoiced; tmpPurchRcptHeader."QB Invoiced Amount")
            {
                //SourceExpr=tmpPurchRcptHeader."QB Invoiced Amount";
            }
            Column(G4; tmpPurchRcptHeader."QB Accounted Amount")
            {
                //SourceExpr=tmpPurchRcptHeader."QB Accounted Amount";

            }
            Column(GO; Go)
            {
                //SourceExpr=Go;

            }
            Column(Diference; Diference)
            {
                //SourceExpr=Diference;
            }
            DataItem("tmpGLEntry"; "G/L Entry")
            {

                DataItemTableView = SORTING("Document No.", "Posting Date");


                UseTemporary = true;
                Column(GLE_Type; TRUE)
                {
                    //SourceExpr=TRUE;
                }
                Column(GLE_AccountNo; tmpGLEntry."G/L Account No.")
                {
                    //SourceExpr=tmpGLEntry."G/L Account No.";
                }
                Column(GLE_PostingDate; tmpGLEntry."Posting Date")
                {
                    //SourceExpr=tmpGLEntry."Posting Date";
                }
                Column(GLE_DocumentType; tmpGLEntry."Document Type")
                {
                    //SourceExpr=tmpGLEntry."Document Type";
                }
                Column(GLE_DocumentNo; tmpGLEntry."Document No.")
                {
                    //SourceExpr=tmpGLEntry."Document No.";
                }
                Column(GLE_Description; tmpGLEntry.Description)
                {
                    //SourceExpr=tmpGLEntry.Description;
                }
                Column(GLE_Amount; tmpGLEntry.Amount)
                {
                    //SourceExpr=tmpGLEntry.Amount ;
                }
                trigger OnPreDataItem();
                BEGIN
                    tmpGLEntry.RESET;
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                IF NOT Vendor.GET("Buy-from Vendor No.") THEN
                    Vendor.INIT;

                Diference := tmpPurchRcptHeader."QB Total Amount" - tmpPurchRcptHeader."QB Invoiced Amount" + tmpPurchRcptHeader."QB Accounted Amount";

                Go := 0;
                GLEntry.RESET;
                GLEntry.SETCURRENTKEY("Document No.");
                GLEntry.SETRANGE("Document No.", tmpPurchRcptHeader."No.");
                IF (GLEntry.FINDSET(FALSE)) THEN
                    REPEAT
                        IF STRPOS(Accounts, GLEntry."G/L Account No.") = 0 THEN
                            Go += GLEntry.Amount;
                    UNTIL GLEntry.NEXT = 0;
            END;


        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("group972")
                {

                    field("Accounts"; "Accounts")
                    {

                        CaptionML = ESP = 'Ctas. Alb. Ptes.';
                    }
                    field("opcDfecha"; "opcDfecha")
                    {

                        CaptionML = ESP = 'Desde fecha';
                    }
                    field("opcHfecha"; "opcHfecha")
                    {

                        CaptionML = ESP = 'Hasta fecha';
                    }
                    field("SeeAll"; "SeeAll")
                    {

                        CaptionML = ESP = 'Ver Todos';
                    }

                }

            }
        }
    }
    labels
    {
        NameReport = 'Invoiced Pending Shipments/ Cuadre Albaranes-Contabilidad/';
        PageNo = 'Page No./ Pag./';
        Doc = 'Document N§/ N§ Doc./';
        FReg = 'Posting Date/ Fecha Registro/';
    }

    var
        //       tmpPurchRcptHeader2@1100286015 :
        tmpPurchRcptHeader2: Record 120 TEMPORARY;
        //       PurchRcptHeader@1100286009 :
        PurchRcptHeader: Record 120;
        //       PurchRcptLine@1100286000 :
        PurchRcptLine: Record 121;
        //       GLEntry@1100286011 :
        GLEntry: Record 17;
        //       Job@7001103 :
        Job: Record 167;
        //       Vendor@7001102 :
        Vendor: Record 23;
        //       Filters@7001100 :
        Filters: Text;
        //       Total@7001106 :
        Total: Decimal;
        //       Invoiced@7001107 :
        Invoiced: Decimal;
        //       G4@1100286001 :
        G4: Decimal;
        //       Go@1100286003 :
        Go: Decimal;
        //       Diference@1000000001 :
        Diference: Decimal;
        //       txtAux@1100286008 :
        txtAux: Text;
        //       DateFilterTxt@1100286016 :
        DateFilterTxt: Text;
        //       DateFilter@1100286002 :
        DateFilter: Text;
        //       Window@1100286004 :
        Window: Dialog;
        //       n1@1100286006 :
        n1: Integer;
        //       n2@1100286007 :
        n2: Integer;
        //       "------------------------- Opciones"@1100286010 :
        "------------------------- Opciones": Integer;
        //       Accounts@1100286005 :
        Accounts: Text;
        //       opcDfecha@1100286012 :
        opcDfecha: Date;
        //       opcHfecha@1100286013 :
        opcHfecha: Date;
        //       SeeAll@1100286014 :
        SeeAll: Boolean;



    trigger OnInitReport();
    begin
        Accounts := '4109001|4009001';
    end;

    trigger OnPreReport();
    begin
        if (STRLEN(Accounts) = 0) then
            ERROR('Debe indicar cuentas contables de fras ptes.');

        DateFilter := '';
        if (opcDfecha <> 0D) then
            DateFilter += FORMAT(opcDfecha, 0, '<Day,2><Month,2><Year>');
        if (opcDfecha <> 0D) or (opcHfecha <> 0D) then
            DateFilter += '..';
        if (opcHfecha <> 0D) then
            DateFilter += FORMAT(opcHfecha, 0, '<Day,2><Month,2><Year>');

        DateFilterTxt := '';
        if (opcDfecha <> 0D) then
            DateFilterTxt += ' Desde ' + FORMAT(opcDfecha);
        if (opcHfecha <> 0D) then
            DateFilterTxt += ' Hasta ' + FORMAT(opcHfecha);
        if (DateFilter = '') then
            DateFilterTxt := 'Todas';

        Filters := 'Filtros = Cuentas: ' + Accounts + '    Fechas: ' + DateFilterTxt;

        Window.OPEN('Preparando #1#############################################');

        //Preparar el temporal de movimientos contables
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("G/L Account No.", "Posting Date");
        GLEntry.SETFILTER("G/L Account No.", Accounts);
        if (DateFilter <> '') then
            GLEntry.SETFILTER("Posting Date", DateFilter);
        n1 := 0;
        n2 := GLEntry.COUNT;
        if (GLEntry.FINDSET(FALSE)) then
            repeat
                n1 += 1;
                Window.UPDATE(1, STRSUBSTNO('Fin %1 / %2', n1, n2));
                tmpGLEntry := GLEntry;
                tmpGLEntry.INSERT(FALSE);
            until GLEntry.NEXT = 0;

        //Preparar el temporal de albaranes
        PurchRcptHeader.RESET;
        if (DateFilter <> '') then
            PurchRcptHeader.SETFILTER("Posting Date", DateFilter);

        n1 := 0;
        n2 := PurchRcptHeader.COUNT;
        if (PurchRcptHeader.FINDSET(FALSE)) then
            repeat
                n1 += 1;
                Window.UPDATE(1, STRSUBSTNO('Alb %1 / %2', n1, n2));

                PurchRcptHeader."QB Total Amount" := 0;
                PurchRcptHeader."QB Invoiced Amount" := 0;
                PurchRcptHeader."QB Accounted Amount" := 0;
                Diference := 0;

                if (not PurchRcptHeader.Cancelled) then begin
                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Document No.", PurchRcptHeader."No.");
                    PurchRcptLine.SETRANGE(Cancelled, FALSE);
                    if (PurchRcptLine.FINDSET(FALSE)) then
                        repeat
                            PurchRcptHeader."QB Total Amount" += ROUND(PurchRcptLine.Quantity * PurchRcptLine."Unit Cost", 0.01);
                            PurchRcptHeader."QB Invoiced Amount" += ROUND(PurchRcptLine."Quantity Invoiced" * PurchRcptLine."Unit Cost", 0.01);
                        until PurchRcptLine.NEXT = 0;
                end;

                GLEntry.RESET;
                GLEntry.SETCURRENTKEY("Document No.");
                GLEntry.SETRANGE("Document No.", PurchRcptHeader."No.");
                if (GLEntry.FINDSET(FALSE)) then
                    repeat
                        if STRPOS(Accounts, GLEntry."G/L Account No.") <> 0 then begin
                            PurchRcptHeader."QB Accounted Amount" += GLEntry.Amount;
                            if tmpGLEntry.GET(GLEntry."Entry No.") then
                                tmpGLEntry.DELETE(FALSE);
                        end;
                    until GLEntry.NEXT = 0;

                PurchRcptHeader.MODIFY;

                if (GLEntry.COUNT <> 0) then  //Solo si se ha contabilizado puede haber diferencias
                    Diference := PurchRcptHeader."QB Total Amount" - PurchRcptHeader."QB Invoiced Amount" + PurchRcptHeader."QB Accounted Amount";

                if (SeeAll) or (Diference <> 0) then begin
                    tmpPurchRcptHeader := PurchRcptHeader;
                    tmpPurchRcptHeader.INSERT(FALSE);
                    tmpPurchRcptHeader2 := PurchRcptHeader;
                    tmpPurchRcptHeader2.INSERT(FALSE);
                end;
            until PurchRcptHeader.NEXT = 0;

        //Sistema ant¡guo, se cancela el albar n con otro negativo
        // {---
        // tmpPurchRcptHeader.RESET;
        // tmpPurchRcptHeader.SETFILTER("QB Total Amount",'<>0');
        // if (tmpPurchRcptHeader.FINDSET) then
        //   repeat
        //     tmpPurchRcptHeader2.RESET;
        //     tmpPurchRcptHeader2.SETRANGE("Buy-from Vendor No.", tmpPurchRcptHeader."Buy-from Vendor No.");
        //     tmpPurchRcptHeader2.SETRANGE("QB Total Amount", - tmpPurchRcptHeader."QB Total Amount");
        //     if (not tmpPurchRcptHeader2.ISEMPTY) then begin
        //       GLEntry.RESET;
        //       GLEntry.SETCURRENTKEY("Document No.");
        //       GLEntry.SETRANGE("Document No.", tmpPurchRcptHeader."No.");
        //       if (GLEntry.FINDSET(FALSE)) then
        //         repeat
        //           if STRPOS(Accounts, GLEntry."G/L Account No.") <> 0 then
        //             if tmpGLEntry.GET(GLEntry."Entry No.") then
        //               tmpGLEntry.DELETE(FALSE);
        //         until GLEntry.NEXT = 0;

        //       GLEntry.RESET;
        //       GLEntry.SETCURRENTKEY("Document No.");
        //       GLEntry.SETRANGE("Document No.", tmpPurchRcptHeader2."No.");
        //       if (GLEntry.FINDSET(FALSE)) then
        //         repeat
        //           if STRPOS(Accounts, GLEntry."G/L Account No.") <> 0 then
        //             if tmpGLEntry.GET(GLEntry."Entry No.") then
        //               tmpGLEntry.DELETE(FALSE);
        //         until GLEntry.NEXT = 0;

        //       tmpPurchRcptHeader.DELETE;
        //       tmpPurchRcptHeader.GET(tmpPurchRcptHeader2."No.");
        //       tmpPurchRcptHeader.DELETE;

        //     end;
        //   until (tmpPurchRcptHeader.NEXT = 0);
        // ---}

        //Si est  en la contabilidad, puede que sea un albar nexistente pero con fecha anterior o posterior
        tmpGLEntry.RESET;
        n1 := 0;
        n2 := tmpGLEntry.COUNT;

        if (tmpGLEntry.FINDSET(FALSE)) then
            repeat
                n1 += 1;
                Window.UPDATE(1, STRSUBSTNO('Ajustando %1 / %2', n1, n2));

                if PurchRcptHeader.GET(tmpGLEntry."Document No.") then
                    if (PurchRcptHeader."Posting Date" < opcDfecha) or (PurchRcptHeader."Posting Date" > opcHfecha) then
                        tmpGLEntry.DELETE;
            until tmpGLEntry.NEXT = 0;


        Window.CLOSE;
    end;



    /*begin
        end.
      */

}




