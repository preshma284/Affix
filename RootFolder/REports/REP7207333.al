report 7207333 "Generate Usage Doc."
{


    CaptionML = ENU = 'Generate Usage Doc.', ESP = 'Genera Documento de utilizaci¢n';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Element Contract Header"; "Element Contract Header")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.", "Customer/Vendor No.", "Job No.", "Contract Type";
            DataItem("Rental Elements Entries"; "Rental Elements Entries")
            {

                DataItemTableView = SORTING("Contract No.", "Entry Type")
                                 WHERE("Entry Type" = CONST("Delivery"));
                DataItemLink = "Contract No." = FIELD("No.");
                trigger OnPreDataItem();
                BEGIN
                    LastFieldNo := FIELDNO("Entry No.");
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    SETFILTER("Date Filter", '..%1', "Applied Last Date");
                    CALCFIELDS("Return Quantity");
                    IF "Rental Elements Entries".Quantity < "Rental Elements Entries"."Return Quantity" THEN
                        CurrReport.SKIP;

                    //se mira si hay devoluciones
                    CalculateUsageMov("Rental Elements Entries", UsageHeader);

                    //se mira si hay saldo

                    CalculateUsageBalance("Rental Elements Entries", UsageHeader)
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                Window.OPEN(Text003);
                ElementContractLines.SETCURRENTKEY("Document No.", "No.", "Job No.", "Location Code", "Variant Code", "Piecework Code");
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Window.UPDATE(1, "Element Contract Header"."No.");
                IF NOT CreateHeader THEN
                    Usage_Header("Element Contract Header");
            END;

            trigger OnPostDataItem();
            BEGIN
                IF Action_Type <> Action_Type::"Solo generar doc utilizaci¢n" THEN BEGIN
                    IF NOT CreateHeader THEN BEGIN
                        UsageHeader.RESET;
                        UsageHeader.SETRANGE("No.", From, To_);
                        IF UsageHeader.FINDSET THEN
                            REPEAT
                                UsageLine.RESET;
                                UsageLine.SETRANGE("Document No.", UsageHeader."No.");
                                IF UsageLine.FINDFIRST THEN BEGIN
                                    IF Action_Type = Action_Type::"Generar y registrar doc utilizacion y proponer parte" THEN BEGIN
                                        CLEAR(CURegisterUsagesn);
                                        CURegisterUsagesn.Omit_Question(TRUE, 2);
                                        CURegisterUsagesn.RUN(UsageHeader);
                                        IF FromSheet = '' THEN
                                            FromSheet := UsageHeader."Preassigned Sheet Draft No.";
                                        ToSheet := UsageHeader."Preassigned Sheet Draft No.";
                                        MESSAGE(text001, FromSheet, ToSheet);
                                    END;
                                    IF Action_Type = Action_Type::"Generar y Reg doc de utilizaci¢n y albaranes de compra" THEN BEGIN
                                        CLEAR(CURegisterUsagesn);
                                        CURegisterUsagesn.Omit_Question(TRUE, 2);
                                        CURegisterUsagesn.RUN(UsageHeader);
                                    END;
                                END;
                            UNTIL UsageHeader.NEXT = 0;
                    END;
                END;
            END;


        }
    }
    requestpage
    {
        CaptionML = ENU = 'Generate Usage Doc.', ESP = 'Genera Documento de utilizaci¢n';
        layout
        {
            area(content)
            {
                group("group531")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("Posting_Date"; "Posting_Date")
                    {

                        CaptionML = ENU = 'Posting Date', ESP = 'Fecha de registro';
                    }
                    field("Usage_Date"; "Usage_Date")
                    {

                        CaptionML = ENU = 'Application Date', ESP = 'Fecha de liquidaci¢n';
                    }
                    field("StartDate"; "StartDate")
                    {

                        CaptionML = ENU = 'Start Application Date', ESP = 'Fecha Inicio Liquidaci¢n';
                    }
                    group("group535")
                    {

                        CaptionML = ENU = 'Action type', ESP = 'Tipo acci¢n';
                        field("Action_Type"; "Action_Type")
                        {

                            // OptionCaptionML=ENU='Generate Usage Doc. only,Generate and register Usage Doc.and propose sheet,Generate and register Usage Doc.and receipts',ESP='S¢lo generar doc. utilizaci¢n,Generar y registrar doc. utilizaci¢n y proponer parte,Generar y registrar doc. utilizaci¢n y albaranes de compra';
                        }

                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       LastFieldNo@7001120 :
        LastFieldNo: Integer;
        //       FooterPrinted@7001119 :
        FooterPrinted: Boolean;
        //       UsageHeader@7001118 :
        UsageHeader: Record 7207362;
        //       Usage_Date@7001117 :
        Usage_Date: Date;
        //       CreateHeader@7001116 :
        CreateHeader: Boolean;
        //       RecepcionPeriod@7001115 :
        RecepcionPeriod: Boolean;
        //       CURentalFunctions@7001114 :
        CURentalFunctions: Codeunit 7207314;
        //       UsageLine@7001113 :
        UsageLine: Record 7207363;
        //       Line_@7001112 :
        Line_: Integer;
        //       UsageLine2@7001111 :
        UsageLine2: Record 7207363;
        //       RentQuantity@7001110 :
        RentQuantity: Decimal;
        //       From@7001109 :
        From: Code[20];
        //       To_@7001108 :
        To_: Code[20];
        //       Posting_Date@7001107 :
        Posting_Date: Date;
        //       Action_Type@7001106 :
        Action_Type: Option "Solo generar doc utilizaci¢n","Generar y registrar doc utilizacion y proponer parte","Generar y Reg doc de utilizaci¢n y albaranes de compra";
        //       CURegisterUsagesn@7001105 :
        CURegisterUsagesn: Codeunit 7207309;
        //       StartDate@7001104 :
        StartDate: Date;
        //       FromSheet@7001103 :
        FromSheet: Code[20];
        //       ToSheet@7001102 :
        ToSheet: Code[20];
        //       Window@7001101 :
        Window: Dialog;
        //       ElementContractLines@7001100 :
        ElementContractLines: Record 7207354;
        //       loc7021500@7001126 :
        loc7021500: TextConst ENU = 'You must indicate the application date', ESP = 'Debe indicar fecha de liquidaci¢n';
        //       loctex7021500@7001125 :
        loctex7021500: TextConst ENU = 'Document %1 to %2 has been created', ESP = 'Se han creado los documentos %1 a %2';
        //       loc7021501@7001124 :
        loc7021501: TextConst ENU = 'Yo must indicate posting date', ESP = 'Debe indicar fecha de registro';
        //       text001@7001123 :
        text001: TextConst ENU = 'Drafts for part of %1 to%2 have been created', ESP = 'Se han creado los borradores de parte de %1 a %2';
        //       Text003@7001122 :
        Text003: TextConst ENU = 'Generating contract usage document: #1##################', ESP = 'Generando documento de utilizaci¢n del contrato: #1##################';
        //       Text50000@7001121 :
        Text50000: TextConst ENU = 'Yo cannot generate Usage Doc. in contract %1 because Posting Date is earlier than the Rental Date', ESP = 'No se puede generar doc. utilizaci¢n en contrato %1 porque la fecha de registro es anterior a la fecha de alquiler';



    trigger OnPreReport();
    begin
        if Usage_Date = 0D then
            ERROR(loc7021500);
        if Posting_Date = 0D then
            ERROR(loc7021501);
    end;

    trigger OnPostReport();
    begin
        if Action_Type = Action_Type::"Solo generar doc utilizaci¢n" then begin
            if From <> '' then
                MESSAGE(loctex7021500, From, To_);
        end;
    end;



    // procedure ReceivesUsageHeader (PAUsageHeader@1100251000 :
    procedure ReceivesUsageHeader(PAUsageHeader: Record 7207362)
    begin
        CreateHeader := TRUE;
        UsageHeader := PAUsageHeader;
        Usage_Date := PAUsageHeader."Usage Date";
        Posting_Date := PAUsageHeader."Posting Date";
    end;

    //     procedure Usage_Header (PaElementContractHeader@1100251000 :
    procedure Usage_Header(PaElementContractHeader: Record 7207353)
    begin
        UsageHeader.INIT;
        UsageHeader."No." := '';
        UsageHeader.INSERT(TRUE);
        UsageHeader."Contract Type" := PaElementContractHeader."Contract Type";
        UsageHeader.VALIDATE("Customer/Vendor No.", PaElementContractHeader."Customer/Vendor No.");
        UsageHeader.VALIDATE("Job No.", PaElementContractHeader."Job No.");
        UsageHeader.VALIDATE("Contract Code", PaElementContractHeader."No.");
        UsageHeader."Usage Date" := Usage_Date;
        UsageHeader."Posting Date" := Posting_Date;
        UsageHeader.VALIDATE("Shortcut Dimension 1 Code", PaElementContractHeader."Shortcut Dimension 1 Code");
        UsageHeader.VALIDATE("Shortcut Dimension 2 Code", PaElementContractHeader."Shortcut Dimension 2 Code");
        UsageHeader.MODIFY;
        if From = '' then
            From := UsageHeader."No.";
        To_ := UsageHeader."No.";
    end;

    //     procedure InitUsageMov (var PaUsageLine@7001103 : Record 7207363;PaUsageHeader@7001102 : Record 7207362;PaRentalElementsEntries@7001101 :
    procedure InitUsageMov(var PaUsageLine: Record 7207363; PaUsageHeader: Record 7207362; PaRentalElementsEntries: Record 7207345)
    var
        //       LOUsageLine@1100251003 :
        LOUsageLine: Record 7207363;
        //       LOElementContractLines@1100000 :
        LOElementContractLines: Record 7207354;
    begin
        PaUsageLine.INIT;
        PaUsageLine."Document No." := PaUsageHeader."No.";
        PaUsageLine."Contract Code" := PaUsageHeader."Contract Code";
        UsageLine2.SETRANGE(UsageLine2."Document No.", PaUsageLine."Document No.");
        if UsageLine2.FINDLAST then
            Line_ := UsageLine2."Line No." + 10000
        else
            Line_ := 10000;

        PaUsageLine."Line No." := Line_;
        PaUsageLine.VALIDATE("No.", PaRentalElementsEntries."Element No.");
        PaUsageLine.VALIDATE("Variant Code", PaRentalElementsEntries."Variant Code");
        LOElementContractLines.SETRANGE(LOElementContractLines."Document No.", PaRentalElementsEntries."Contract No.");
        LOElementContractLines.SETRANGE("No.", PaRentalElementsEntries."Element No.");
        LOElementContractLines.SETRANGE("Job No.", PaRentalElementsEntries."Job No.");
        LOElementContractLines.SETRANGE("Piecework Code", PaRentalElementsEntries."Piecework Code");
        LOElementContractLines.SETRANGE("Variant Code", PaRentalElementsEntries."Variant Code");
        LOElementContractLines.SETRANGE("Location Code", PaRentalElementsEntries."Location code");
        if LOElementContractLines.FINDFIRST then begin
            PaUsageLine.VALIDATE("Unit Price", LOElementContractLines."Rent Price");
            PaUsageLine.Description := LOElementContractLines.Description;
        end else
            PaUsageLine.VALIDATE("Unit Price", PaRentalElementsEntries."Unit Price");
        PaUsageLine.VALIDATE("Shortcut Dimension 1 Code", PaRentalElementsEntries."Global Dimension 1 Code");
        PaUsageLine.VALIDATE("Shortcut Dimension 2 Code", PaRentalElementsEntries."Global Dimension 2 Code");
        PaUsageLine."Application Date" := PaUsageHeader."Usage Date";
        PaUsageLine."Delivery Mov. No." := PaRentalElementsEntries."Entry No.";
        PaUsageLine."Delivery Document" := PaRentalElementsEntries."Document No.";
        PaUsageLine."Application Date" := PaUsageHeader."Usage Date";
        PaUsageLine."Customer/Vendor No." := PaUsageHeader."Customer/Vendor No.";
        PaUsageLine."Contract Type" := PaUsageHeader."Contract Type";
        PaUsageLine."Job No." := PaRentalElementsEntries."Job No.";
        PaUsageLine."Piecework Code" := PaRentalElementsEntries."Piecework Code";
    end;

    //     procedure RentedQuantity (PaRentalElementsEntries@1100251000 : Record 7207345;parDate@1100251001 :
    procedure RentedQuantity(PaRentalElementsEntries: Record 7207345; parDate: Date) RentCta: Decimal;
    begin
        PaRentalElementsEntries.SETFILTER("Date Filter", '..%1', parDate);
        PaRentalElementsEntries.CALCFIELDS("Return Quantity");
        RentCta := PaRentalElementsEntries.Quantity - PaRentalElementsEntries."Return Quantity";
        exit(RentCta);
    end;

    //     procedure CalculateUsageMov (var PaRentalElementsEntries@1100251000 : Record 7207345;PaUsageHeader@1100251001 :
    procedure CalculateUsageMov(var PaRentalElementsEntries: Record 7207345; PaUsageHeader: Record 7207362)
    var
        //       LORentalElementsEntries@1100251005 :
        LORentalElementsEntries: Record 7207345;
    begin
        //Leo las devoluciones de la entrega que estoy tratando
        LORentalElementsEntries.SETCURRENTKEY("Applied Entry No.", "Rent effective Date");
        LORentalElementsEntries.SETRANGE(LORentalElementsEntries."Applied Entry No.", PaRentalElementsEntries."Entry No.");
        LORentalElementsEntries.SETFILTER(LORentalElementsEntries."Rent effective Date", '>=%1&<=%2',
              PaRentalElementsEntries."Applied Last Date", PaUsageHeader."Usage Date");

        if LORentalElementsEntries.FINDSET then
            repeat
                CalculateModev(PaRentalElementsEntries, LORentalElementsEntries);
            until LORentalElementsEntries.NEXT = 0;
    end;

    //     procedure CalculateModev (var ParDeliveryMov@1100251000 : Record 7207345;ParReturnMov@1100251001 :
    procedure CalculateModev(var ParDeliveryMov: Record 7207345; ParReturnMov: Record 7207345)
    var
        //       Days@1100251002 :
        Days: Decimal;
        //       LORentalElementsEntries@1100251003 :
        LORentalElementsEntries: Record 7207345;
        //       LOStartDate@1100000 :
        LOStartDate: Date;
    begin
        //Inicializo la l¡nea
        InitUsageMov(UsageLine, UsageHeader, ParDeliveryMov);

        //calculo los d¡as de utilizaci¢n
        //El dia de la entrega tambien cuenta en el primer mes.
        if (ParDeliveryMov."Rent effective Date" = ParDeliveryMov."Applied Last Date") and
           (ParDeliveryMov."Applied First Pending Entry") then begin
            Days := CURentalFunctions.UsageDays(ParDeliveryMov."Contract No.", ParDeliveryMov."Element No.",
            ParDeliveryMov."Applied Last Date", ParReturnMov."Rent effective Date");
            LOStartDate := ParDeliveryMov."Applied Last Date";
        end else begin
            if (DATE2DMY(ParDeliveryMov."Rent effective Date", 2) = DATE2DMY(UsageHeader."Usage Date", 2)) and
               (DATE2DMY(ParDeliveryMov."Rent effective Date", 3) = DATE2DMY(UsageHeader."Usage Date", 3)) then begin
                Days := CURentalFunctions.UsageDays(ParDeliveryMov."Contract No.", ParDeliveryMov."Element No.",
                ParDeliveryMov."Applied Last Date" + 1, ParReturnMov."Rent effective Date");
                LOStartDate := ParDeliveryMov."Applied Last Date" + 1;
            end else begin
                Days := CURentalFunctions.UsageDays(ParDeliveryMov."Contract No.", ParDeliveryMov."Element No.",
                ParDeliveryMov."Applied Last Date" + 1, ParReturnMov."Rent effective Date");
                LOStartDate := ParDeliveryMov."Applied Last Date" + 1;
            end;
        end;

        UsageLine.VALIDATE(UsageLine."Usage Days", Days);
        UsageLine."Initial Date Calculation" := LOStartDate;

        //calculo la cantidad
        RentQuantity := RentedQuantity(ParDeliveryMov, ParReturnMov."Rent effective Date");
        UsageLine.VALIDATE(UsageLine.Quantity, RentQuantity - ParReturnMov.Quantity);

        UsageLine."Return Mov. No." := ParReturnMov."Entry No.";
        UsageLine."Return Document" := ParReturnMov."Document No.";
        UsageLine."Return Date" := ParReturnMov."Rent effective Date";
        UsageLine."Line Type" := UsageLine."Line Type"::Refund;


        UsageLine."Quantity to invoice" := UsageLine.Quantity * UsageLine."Usage Days";
        UsageLine."Pending Quantity" := UsageLine."Quantity to invoice";
        UsageLine.Amount := UsageLine.Quantity * UsageLine."Unit Price" * UsageLine."Usage Days";
        if (UsageLine.Quantity <> 0) and (UsageLine."Usage Days" <> 0) then
            UsageLine.INSERT;

        ParDeliveryMov."Applied Last Date" := ParReturnMov."Rent effective Date";
    end;

    //     procedure CalculateUsageBalance (PaRentalElementsEntries@1100251000 : Record 7207345;PaUsageHeader@1100251001 :
    procedure CalculateUsageBalance(PaRentalElementsEntries: Record 7207345; PaUsageHeader: Record 7207362)
    var
        //       LO_Days@1100251002 :
        LO_Days: Decimal;
        //       LO_StartDate@1100000 :
        LO_StartDate: Date;
    begin
        //calculo la cantidad
        RentQuantity := RentedQuantity(PaRentalElementsEntries, UsageHeader."Usage Date");

        //Inicializo la l¡nea
        InitUsageMov(UsageLine, UsageHeader, PaRentalElementsEntries);

        //calculo los d¡as de utilizaci¢n
        if (PaRentalElementsEntries."Rent effective Date" = PaRentalElementsEntries."Applied Last Date") and
          (PaRentalElementsEntries."Applied First Pending Entry") then begin
            LO_Days := CURentalFunctions.UsageDays(PaRentalElementsEntries."Contract No.", PaRentalElementsEntries."Element No.",
                       PaRentalElementsEntries."Applied Last Date", UsageHeader."Usage Date");
            LO_StartDate := PaRentalElementsEntries."Applied Last Date";
        end else begin
            if (DATE2DMY(PaRentalElementsEntries."Rent effective Date", 2) = DATE2DMY(PaUsageHeader."Usage Date", 2)) and
               (DATE2DMY(PaRentalElementsEntries."Rent effective Date", 3) = DATE2DMY(PaUsageHeader."Usage Date", 3)) then begin
                LO_Days := CURentalFunctions.UsageDays(PaRentalElementsEntries."Contract No.", PaRentalElementsEntries."Element No.",
                           PaRentalElementsEntries."Applied Last Date" + 1, UsageHeader."Usage Date");
                LO_StartDate := PaRentalElementsEntries."Applied Last Date" + 1;
            end else begin
                LO_Days := CURentalFunctions.UsageDays(PaRentalElementsEntries."Contract No.", PaRentalElementsEntries."Element No.",
                           PaRentalElementsEntries."Applied Last Date" + 1, UsageHeader."Usage Date");
                LO_StartDate := PaRentalElementsEntries."Applied Last Date" + 1;
            end;
        end;

        UsageLine."Initial Date Calculation" := LO_StartDate;
        UsageLine.VALIDATE(UsageLine."Usage Days", LO_Days);
        UsageLine."Line Type" := UsageLine."Line Type"::"Balance on Job";
        UsageLine.VALIDATE(UsageLine.Quantity, RentQuantity);
        UsageLine."Quantity to invoice" := UsageLine.Quantity * UsageLine."Usage Days";
        UsageLine."Pending Quantity" := UsageLine."Quantity to invoice";
        UsageLine.Amount := UsageLine.Quantity * UsageLine."Unit Price" * UsageLine."Usage Days";

        if (UsageLine.Quantity <> 0) and (UsageLine."Usage Days" <> 0) then
            UsageLine.INSERT;
    end;

    /*begin
    end.
  */

}



