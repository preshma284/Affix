report 7207290 "Job Consumption by Order"
{


    ;
    dataset
    {

        DataItem("Sales Header"; "Sales Header")
        {

            DataItemTableView = SORTING("Document Type", "No.");


            RequestFilterFields = "No.";
            DataItem("Sales Line"; "Sales Line")
            {

                DataItemTableView = SORTING("Job No.")
                                 ORDER(Ascending)
                                 WHERE("Type" = CONST("Item"), "Job No." = FILTER(<> ''), "Job Contract Entry No." = CONST(0));


                RequestFilterFields = "Document No.";
                DataItemLink = "Document Type" = FIELD("Document Type"),
                            "Document No." = FIELD("No.");
                trigger OnAfterGetRecord();
                BEGIN
                    IF "Sales Header"."Document Type" = "Sales Header"."Document Type"::Invoice THEN BEGIN
                        IF "Sales Line"."Shipment No." <> '' THEN
                            CurrReport.SKIP;
                    END;

                    IF "Sales Header"."Document Type" = "Sales Header"."Document Type"::"Credit Memo" THEN BEGIN
                        IF "Sales Line"."Return Receipt No." <> '' THEN
                            CurrReport.SKIP;
                    END;

                    IF "Sales Line"."Job No." <> PresentJob THEN BEGIN
                        PresentJob := "Sales Line"."Job No.";
                        CreateHeader;
                    END;
                    CreateLine;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                Window.OPEN(Text000 +
                             Text001);
            END;

            trigger OnPostDataItem();
            BEGIN
                Window.CLOSE;
                OutputShipmentHeader.MARKEDONLY(TRUE);
                IF OutputShipmentHeader.FINDSET THEN BEGIN
                    REPEAT
                        OutputShipmentLines.RESET;
                        OutputShipmentLines.SETRANGE("Document No.", OutputShipmentHeader."No.");
                        IF OutputShipmentLines.FINDFIRST THEN
                            PostPurchaseRcptOutput.RUN(OutputShipmentHeader);
                    UNTIL OutputShipmentHeader.NEXT = 0;
                END;
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
        //       Window@7001100 :
        Window: Dialog;
        //       Text000@7001101 :
        Text000: TextConst ENU = 'Generating Consumption Orders \', ESP = 'Generando albaranes de consumo \';
        //       Text001@7001102 :
        Text001: TextConst ENU = 'Shipment No. #1###################', ESP = 'Albar n N§ #1###################';
        //       OutputShipmentHeader@7001103 :
        OutputShipmentHeader: Record 7207308;
        //       OutputShipmentLines@7001104 :
        OutputShipmentLines: Record 7207309;
        //       PostPurchaseRcptOutput@7001105 :
        PostPurchaseRcptOutput: Codeunit 7207276;
        //       PresentJob@7001106 :
        PresentJob: Code[20];
        //       FunctionQB@7001107 :
        FunctionQB: Codeunit 7207272;
        //       ReservationEntry@7001108 :
        ReservationEntry: Record 337;
        //       ReservationEntryDelete@7001109 :
        ReservationEntryDelete: Record 337;

    procedure CreateHeader()
    begin
        OutputShipmentHeader.INIT;
        OutputShipmentHeader."No." := '';
        OutputShipmentHeader.INSERT(TRUE);

        OutputShipmentHeader."Request Date" := "Sales Header"."Posting Date";
        OutputShipmentHeader."Posting Date" := "Sales Header"."Posting Date";
        OutputShipmentHeader.VALIDATE("Job No.", "Sales Line"."Job No.");

        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::Order then begin
            if "Sales Header"."Shipping No." <> '' then begin
                OutputShipmentHeader."Documnet Type" := OutputShipmentHeader."Documnet Type"::Shipment;
                OutputShipmentHeader.VALIDATE("Sales Document No.", "Sales Header"."Shipping No.");
            end else begin
                OutputShipmentHeader."Documnet Type" := OutputShipmentHeader."Documnet Type"::Invoice;
                OutputShipmentHeader.VALIDATE("Sales Document No.", "Sales Header"."Posting No.");
            end;
        end;

        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::Invoice then begin
            OutputShipmentHeader."Documnet Type" := OutputShipmentHeader."Documnet Type"::Invoice;
            OutputShipmentHeader.VALIDATE("Sales Document No.", "Sales Header"."Posting No.");
        end;

        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::"Return Order" then begin
            if "Sales Header"."Return Receipt No." <> '' then begin
                OutputShipmentHeader."Documnet Type" := OutputShipmentHeader."Documnet Type"::"Receipt.Return";
                OutputShipmentHeader.VALIDATE("Sales Document No.", "Sales Header"."Return Receipt No.");
            end else begin
                OutputShipmentHeader."Documnet Type" := OutputShipmentHeader."Documnet Type"::"Credir Memo";
                OutputShipmentHeader.VALIDATE("Sales Document No.", "Sales Header"."Posting No.");
            end;
        end;

        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::"Credit Memo" then begin
            OutputShipmentHeader."Documnet Type" := OutputShipmentHeader."Documnet Type"::"Credir Memo";
            OutputShipmentHeader.VALIDATE("Sales Document No.", "Sales Header"."Posting No.");
        end;

        if OutputShipmentHeader."Sales Document No." = '' then begin
            OutputShipmentHeader."Sales Document No." := "Sales Header"."Last Shipping No.";
            OutputShipmentHeader."Documnet Type" := OutputShipmentHeader."Documnet Type"::Shipment;
        end;

        OutputShipmentHeader.VALIDATE("Sales Shipment Origin", TRUE);
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) = 1 then begin
            if OutputShipmentHeader."Shortcut Dimension 1 Code" = '' then begin
                OutputShipmentHeader.VALIDATE("Shortcut Dimension 1 Code", "Sales Line"."Shortcut Dimension 1 Code");
            end;
        end else begin
            if OutputShipmentHeader."Shortcut Dimension 2 Code" = '' then begin
                OutputShipmentHeader.VALIDATE("Shortcut Dimension 2 Code", "Sales Line"."Shortcut Dimension 2 Code");
            end;
        end;

        OutputShipmentHeader.MODIFY(TRUE);
        OutputShipmentHeader.MARK(TRUE);
    end;

    procedure CreateLine()
    begin
        Window.UPDATE(1, OutputShipmentHeader."No.");

        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::Order then begin
            if "Sales Line"."Qty. to Ship" = 0 then
                exit;
        end;

        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::"Return Order" then begin
            if "Sales Line"."Return Qty. to Receive" = 0 then
                exit;
        end;

        if (("Sales Header"."Document Type" = "Sales Header"."Document Type"::Invoice) or
           ("Sales Header"."Document Type" = "Sales Header"."Document Type"::"Credit Memo")) then begin
            if "Sales Line".Quantity = 0 then
                exit;
        end;

        if "Sales Line".Type = "Sales Line".Type::Item then begin
            ReservationEntry.RESET;
            ReservationEntry.SETRANGE("Source ID", "Sales Line"."Document No.");
            ReservationEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
            // filtro para el caso de pedidos
            if "Sales Header"."Document Type" = "Sales Header"."Document Type"::Order then
                ReservationEntry.SETRANGE("Source Subtype", 1);

            // filtro para el caso de Invoices
            if "Sales Header"."Document Type" = "Sales Header"."Document Type"::Invoice then
                ReservationEntry.SETRANGE("Source Subtype", 2);

            //filtro para el caso de "Credir Memo"s
            if "Sales Header"."Document Type" = "Sales Header"."Document Type"::"Credit Memo" then
                ReservationEntry.SETRANGE("Source Subtype", 3);

            ReservationEntry.SETRANGE("Source Ref. No.", "Sales Line"."Line No.");
            ReservationEntry.SETRANGE("Item No.", "Sales Line"."No.");
            if not ReservationEntry.FIND('-') then begin
                OutputShipmentLines.INIT;
                OutputShipmentLines."Document No." := OutputShipmentHeader."No.";
                OutputShipmentLines."Line No." := OutputShipmentLines."Line No." + 10000;
                OutputShipmentLines."Document Source" := OutputShipmentLines."Document Source"::Sale;
                OutputShipmentLines.INSERT(TRUE);

                OutputShipmentLines.VALIDATE("Job No.", OutputShipmentHeader."Job No.");
                OutputShipmentLines.VALIDATE("No.", "Sales Line"."No.");

                if "Sales Header"."Document Type" = "Sales Header"."Document Type"::Order then begin
                    OutputShipmentLines.VALIDATE(Quantity, "Sales Line"."Qty. to Ship")
                end;

                if "Sales Header"."Document Type" = "Sales Header"."Document Type"::"Return Order" then begin
                    OutputShipmentLines.VALIDATE(Quantity, "Sales Line"."Return Qty. to Receive")
                end;
                if ("Sales Header"."Document Type" = "Sales Header"."Document Type"::Invoice) then
                    OutputShipmentLines.VALIDATE(Quantity, "Sales Line".Quantity);
                if ("Sales Header"."Document Type" = "Sales Header"."Document Type"::"Credit Memo") then
                    OutputShipmentLines.VALIDATE(Quantity, -"Sales Line".Quantity);
                OutputShipmentLines.VALIDATE("Sales Price", "Sales Line"."Unit Price");
                //El almac‚n de salida es el almac‚n del proyecto si el de la linea de venta est  en blanco y lo coge al valida proyecto
                if "Sales Line"."Location Code" <> '' then
                    OutputShipmentLines.VALIDATE("Outbound Warehouse", "Sales Line"."Location Code");
                OutputShipmentLines.VALIDATE("Unit of Measure Code", "Sales Line"."Unit of Measure Code");
                OutputShipmentLines."Unit of Mensure Quantity" := "Sales Line"."Qty. per Unit of Measure";
                OutputShipmentLines.VALIDATE("Unit Cost", "Sales Line"."Unit Cost (LCY)");
                OutputShipmentLines.VALIDATE(Billable, TRUE);
                OutputShipmentLines.MODIFY(TRUE);
            end else begin
                repeat
                    if ReservationEntry."Qty. to Handle (Base)" <> 0 then begin
                        OutputShipmentLines.INIT;
                        OutputShipmentLines."Document No." := OutputShipmentHeader."No.";
                        OutputShipmentLines."Line No." := OutputShipmentLines."Line No." + 10000;
                        OutputShipmentLines."Document Source" := OutputShipmentLines."Document Source"::Sale;
                        OutputShipmentLines.INSERT(TRUE);

                        OutputShipmentLines.VALIDATE("Job No.", OutputShipmentHeader."Job No.");
                        OutputShipmentLines.VALIDATE("No.", "Sales Line"."No.");
                        OutputShipmentLines.VALIDATE("Shortcut Dimension 1 Code", "Sales Line"."Shortcut Dimension 1 Code");
                        OutputShipmentLines.VALIDATE("Shortcut Dimension 2 Code", "Sales Line"."Shortcut Dimension 2 Code");
                        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::Order then
                            OutputShipmentLines.VALIDATE(Quantity, -ReservationEntry."Qty. to Handle (Base)");

                        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::"Return Order" then
                            OutputShipmentLines.VALIDATE(Quantity, -ReservationEntry."Qty. to Handle (Base)");

                        // Invoices
                        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::Invoice then
                            OutputShipmentLines.VALIDATE(Quantity, -ReservationEntry."Qty. to Handle (Base)");

                        //"Credir Memo"s
                        if "Sales Header"."Document Type" = "Sales Header"."Document Type"::"Credit Memo" then
                            OutputShipmentLines.VALIDATE(Quantity, -ReservationEntry."Qty. to Handle (Base)");

                        OutputShipmentLines.VALIDATE("Sales Price", "Sales Line"."Unit Price");
                        //El almac‚n de salida es el almac‚n del proyecto si el de la linea de venta est  en blanco y lo coge al valida proyecto
                        if "Sales Line"."Location Code" <> '' then
                            OutputShipmentLines.VALIDATE("Outbound Warehouse", "Sales Line"."Location Code");
                        OutputShipmentLines.VALIDATE(Billable, TRUE);
                        OutputShipmentLines."No. Serie for Tracking" := ReservationEntry."Serial No.";
                        OutputShipmentLines."No. Lot for Tracking" := ReservationEntry."Lot No.";
                        OutputShipmentLines."Source Document Type" := "Sales Line"."Document Type";
                        OutputShipmentLines."No. Source Document" := "Sales Line"."Document No.";
                        OutputShipmentLines."No. Source Document Line" := "Sales Line"."Line No.";
                        OutputShipmentLines.VALIDATE("Unit Cost", "Sales Line"."Unit Cost (LCY)");

                        OutputShipmentLines.MODIFY(TRUE);
                        ReservationEntryDelete := ReservationEntry;
                        ReservationEntryDelete.DELETE;
                    end else begin
                        ReservationEntry."Qty. to Handle (Base)" := -1;
                        ReservationEntry."Qty. to Invoice (Base)" := -1;
                        ReservationEntry.MODIFY;
                    end;
                until ReservationEntry.NEXT = 0;
            end;
        end;
    end;

    /*begin
    end.
  */

}



// RequestFilterFields="Document No.";
