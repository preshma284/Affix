report 7207448 "QB Invoice Service Orders"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Invoice Service Orders', ESP = 'Fact. Pedidos Servicio';
    ProcessingOnly = true;

    dataset
    {

        DataItem("QBPostedServiceOrderHeader"; "QB Posted Service Order Header")
        {

            DataItemTableView = SORTING("Job No.", "Grouping Criteria")
                                 WHERE("Invoice Generated" = FILTER(false));


            RequestFilterFields = "Grouping Criteria";
            DataItem("QBPostedServiceOrderLines"; "QB Posted Service Order Lines")
            {

                DataItemTableView = SORTING("Document No.", "Line No.")
                                 WHERE("Piecework No." = FILTER(<> ''));
                DataItemLink = "Document No." = FIELD("No.");
                trigger OnAfterGetRecord();
                VAR
                    //                                   BringCertifications@1100286000 :
                    BringCertifications: Codeunit 7207284;
                BEGIN

                    InsertSalesInvLine;
                END;

                trigger OnPostDataItem();
                VAR
                    //                                 SalesShipmentLine@1000 :
                    SalesShipmentLine: Record 111;
                    //                                 SalesLineInvoice@1002 :
                    SalesLineInvoice: Record 37;
                    //                                 SalesGetShpt@1001 :
                    SalesGetShpt: Codeunit 64;
                BEGIN
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                IF JobNo <> '' THEN
                    QBPostedServiceOrderHeader.SETRANGE("Job No.", JobNo);

                IF PostingDateReq = 0D THEN
                    ERROR(Text000);
                IF DocDateReq = 0D THEN
                    ERROR(Text001);

                Window.OPEN(
                  Text002 +
                  Text003 +
                  Text004 +
                  Text005);

                ActualJobCode := '';
                ActualGroupingCriteriaCode := '';
            END;

            trigger OnAfterGetRecord();
            VAR
                //                                   DueDate@1000 :
                DueDate: Date;
                //                                   PmtDiscDate@1001 :
                PmtDiscDate: Date;
                //                                   PmtDiscPct@1002 :
                PmtDiscPct: Decimal;
            BEGIN
                IF QBPostedServiceOrderHeader."Invoice Generated" THEN
                    CurrReport.SKIP;

                Window.UPDATE(1, QBPostedServiceOrderHeader."Grouping Criteria");
                Window.UPDATE(3, "No.");

                //Factura por cada proyecto y criterio de agrupaci¢n.
                IF (ActualJobCode <> QBPostedServiceOrderHeader."Job No.") OR (ActualGroupingCriteriaCode <> QBPostedServiceOrderHeader."Grouping Criteria") THEN BEGIN
                    InsertSalesInvHeader;
                    ActualGroupingCriteriaCode := QBPostedServiceOrderHeader."Grouping Criteria";
                    ActualJobCode := QBPostedServiceOrderHeader."Job No.";
                END;
                QBPostedServiceOrderHeader."Pre-Assigned Invoice No." := SalesHeader."No.";
                QBPostedServiceOrderHeader."Invoice Generated" := TRUE;
                QBPostedServiceOrderHeader.MODIFY;
            END;

            trigger OnPostDataItem();
            BEGIN
                MESSAGE(Text010, NoOfSalesInv);
            END;


        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group("group944")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("JobNo"; "JobNo")
                    {

                        CaptionML = ENU = 'Job No.', ESP = 'N§ proyecto';
                        TableRelation = Job."No.";
                    }
                    field("PostingDate"; "PostingDateReq")
                    {

                        CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';
                        ToolTipML = ENU = 'Specifies the posting date for the invoice(s) that the batch job creates. This field must be filled in.', ESP = 'Especifica la fecha de la factura o facturas que va a crear el proceso. Este campo debe rellenarse.';
                        ApplicationArea = Advanced;
                    }
                    field("DocDateReq"; "DocDateReq")
                    {

                        CaptionML = ENU = 'Document Date', ESP = 'Fecha emisi¢n documento';
                        ToolTipML = ENU = 'Specifies the document date for the invoice(s) that the batch job creates. This field must be filled in.', ESP = 'Especifica la fecha de emisi¢n de la factura o facturas que va a crear el proceso. Este campo debe cumplimentarse.';
                        ApplicationArea = Advanced;
                    }

                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            IF PostingDateReq = 0D THEN
                PostingDateReq := WORKDATE;
            IF DocDateReq = 0D THEN
                DocDateReq := WORKDATE;
            SalesSetup.GET;
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
        END;


    }
    labels
    {
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = 'Enter the posting date.', ESP = 'Introduzca la fecha de registro.';
        //       Text001@1001 :
        Text001: TextConst ENU = 'Enter the document date.', ESP = 'Introduzca la fecha de documento.';
        //       Text002@1002 :
        Text002: TextConst ENU = 'Combining Orders...\\', ESP = 'Agrupando Pedidos...\\';
        //       Text003@1003 :
        Text003: TextConst ENU = 'Grouping No.    #1##########\', ESP = 'Agrupaci¢n No.      #1##########\';
        //       Text004@1004 :
        Text004: TextConst ENU = 'Order No.       #2##########\', ESP = 'N§ pedido       #2##########\';
        //       Text005@1005 :
        Text005: TextConst ENU = 'Service Order No.    #3##########', ESP = 'N§ pedido servicio     #3##########';
        //       Text007@1006 :
        Text007: TextConst ENU = 'not all the invoices were posted. A total of %1 invoices were not posted.', ESP = 'No se registraron todas las facturas. %1 facturas est n pendientes de registrar.';
        //       Text008@1007 :
        Text008: TextConst ENU = 'There is nothing to combine.', ESP = 'No hay albaranes para agrupar.';
        //       Text010@1008 :
        Text010: TextConst ENU = 'The orders are now combined and the number of invoices created is %1.', ESP = 'Se han agrupado los pedidos de servicio y el n£mero de facturas creadas es %1.';
        //       SalesOrderHeader@1100286000 :
        SalesOrderHeader: Record 36;
        //       SalesHeader@1010 :
        SalesHeader: Record 36;
        //       SalesLine@1011 :
        SalesLine: Record 37;
        //       SalesShptLine@1012 :
        SalesShptLine: Record 111;
        //       SalesSetup@1013 :
        SalesSetup: Record 311;
        //       Cust@1018 :
        Cust: Record 18;
        //       Language@1009 :
        Language: Record 8;
        //       PmtTerms@1017 :
        PmtTerms: Record 3;
        //       SalesCalcDisc@1019 :
        SalesCalcDisc: Codeunit 60;
        //       SalesPost@1020 :
        SalesPost: Codeunit 80;
        //       Window@1021 :
        Window: Dialog;
        //       PostingDateReq@1022 :
        PostingDateReq: Date;
        //       DocDateReq@1023 :
        DocDateReq: Date;
        //       CalcInvDisc@1024 :
        CalcInvDisc: Boolean;
        //       PostInv@1025 :
        PostInv: Boolean;
        //       OnlyStdPmtTerms@1015 :
        OnlyStdPmtTerms: Boolean;
        //       HasAmount@1102601000 :
        HasAmount: Boolean;
        //       HideDialog@1034 :
        HideDialog: Boolean;
        //       NoOfSalesInvErrors@1027 :
        NoOfSalesInvErrors: Integer;
        //       NoOfSalesInv@1028 :
        NoOfSalesInv: Integer;
        //       NoOfskippedShiment@1030 :
        NoOfskippedShiment: Integer;
        //       CopyTextLines@1035 :
        CopyTextLines: Boolean;
        //       NotAllInvoicesCreatedMsg@1014 :
        NotAllInvoicesCreatedMsg: TextConst ENU = 'not all the invoices were created. A total of %1 invoices were not created.', ESP = 'No se crearon todas las facturas. %1 facturas est n pendientes de crearse.';
        //       NewInvoiceForConditions@50001 :
        NewInvoiceForConditions: Boolean;
        //       recDate@50002 :
        recDate: Record 2000000007;
        //       blnLastMonthDay@50003 :
        blnLastMonthDay: Boolean;
        //       InvoiceDay@50005 :
        InvoiceDay: Boolean;
        //       lastOrderHeader@50006 :
        lastOrderHeader: Record 36;
        //       JobNo@1100286001 :
        JobNo: Code[20];
        //       MeasurementHeader@1100286002 :
        MeasurementHeader: Record 7206966;
        //       NoGrouping@1100286003 :
        NoGrouping: Boolean;
        //       FirstLine@1100286004 :
        FirstLine: Boolean;
        //       Jobs@1100286006 :
        Jobs: Record 167;
        //       JobPostingGroup@1100286007 :
        JobPostingGroup: Record 208;
        //       ActualGroupingCriteriaCode@1100286008 :
        ActualGroupingCriteriaCode: Code[20];
        //       ActualJobCode@1100286009 :
        ActualJobCode: Code[20];
        //       Text011@1100286010 :
        Text011: TextConst ENU = 'Sales Ord. No. %1-Date %2:', ESP = 'N§ Ped. Serv. %1-Fecha %2:';
        //       ActualServiceOrderCode@1100286011 :
        ActualServiceOrderCode: Code[20];
        //       SalesHeaderExt@1100286012 :
        SalesHeaderExt: Record 7207071;

    LOCAL procedure InsertSalesInvHeader()
    begin
        SalesHeader.INIT;
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := '';
        // Q16212 02/02/2022 (EPV) La validaci¢n de "Document Date" debe ser anterior a la validaci¢n de "Posting Date" porque se requiere para el c lculo del periodo del SII
        SalesHeader.VALIDATE("Document Date", DocDateReq);
        //--> Q16212
        SalesHeader.VALIDATE("Posting Date", PostingDateReq);
        SalesHeader.INSERT(TRUE);
        SalesHeader.VALIDATE("Sell-to Customer No.", QBPostedServiceOrderHeader."Customer No.");
        // Q16212 02/02/2022 (EPV) Esta validaci¢n de "Document Date" ya se hace m s arriba en el c¢digo.
        //SalesHeader.VALIDATE("Document Date",DocDateReq);
        //--> Q16212
        SalesHeader.VALIDATE("QB Job No.", QBPostedServiceOrderHeader."Job No.");
        SalesHeader.VALIDATE("Shortcut Dimension 1 Code", QBPostedServiceOrderHeader."Shortcut Dimension 1 Code");
        SalesHeader.VALIDATE("Shortcut Dimension 2 Code", QBPostedServiceOrderHeader."Shortcut Dimension 2 Code");
        SalesHeader.MODIFY;
        COMMIT;
        HasAmount := FALSE;
        NoOfSalesInv += 1;

        SalesHeaderExt.Read(SalesHeader.RECORDID);
        SalesHeaderExt."Expenses/Investment" := QBPostedServiceOrderHeader."Expenses/Investment";
        SalesHeaderExt."Grouping Criteria" := QBPostedServiceOrderHeader."Grouping Criteria";
        SalesHeaderExt."Contract No." := QBPostedServiceOrderHeader."Contract No.";
        //{
        //      SalesHeaderExt."Failiure Benefit Centre" :=
        //      SalesHeaderExt."Failiure Budget Pos."
        //      SalesHeaderExt."Failiure Order"
        //      SalesHeaderExt."Failiure Pep."
        //      SalesHeaderExt."Failiure Order No."
        //      }
        SalesHeaderExt."Price review percentage" := QBPostedServiceOrderHeader."Price review percentage";
        //SalesHeaderExt."IPC/Rev aplicado" :=
        SalesHeaderExt."Price review" := QBPostedServiceOrderHeader."Price review";
        SalesHeaderExt."Price review code" := QBPostedServiceOrderHeader."Price review code";
        SalesHeaderExt.Save();
    end;

    LOCAL procedure InsertSalesInvLine()
    var
        //       LineNo@1100286000 :
        LineNo: Integer;
    begin
        Jobs.GET(QBPostedServiceOrderHeader."Job No.");
        JobPostingGroup.GET(Jobs."Job Posting Group");
        JobPostingGroup.TESTFIELD("QB Invoice Acc. Service Order");

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        if (SalesLine.FINDLAST) then
            LineNo := SalesLine."Line No."
        else
            LineNo := 0;

        if (ActualServiceOrderCode <> QBPostedServiceOrderHeader."No.") then begin //Si cambia el pedido de servicio, a¤adimos cabecera
            ActualServiceOrderCode := QBPostedServiceOrderHeader."No.";

            LineNo += 10000;
            SalesLine.INIT;
            SalesLine."Document Type" := SalesHeader."Document Type";
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine."Line No." := LineNo;
            SalesLine.Description := STRSUBSTNO(Text011, QBPostedServiceOrderHeader."No.", FORMAT(QBPostedServiceOrderHeader."Posting Date"));
            SalesLine.INSERT(TRUE);
        end;

        LineNo += 10000;
        SalesLine.INIT;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := LineNo;
        SalesLine.INSERT(TRUE);
        SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
        SalesLine.VALIDATE("No.", JobPostingGroup."QB Invoice Acc. Service Order");
        SalesLine.VALIDATE(Quantity, QBPostedServiceOrderLines.Quantity);
        if (QBPostedServiceOrderLines."Sale Price With Price review" <> 0) then
            SalesLine.VALIDATE("Unit Price", QBPostedServiceOrderLines."Sale Price With Price review")
        else
            SalesLine.VALIDATE("Unit Price", QBPostedServiceOrderLines."Sale Price");
        SalesLine.VALIDATE(Description, QBPostedServiceOrderLines.Description);
        SalesLine.VALIDATE("Shortcut Dimension 1 Code", QBPostedServiceOrderLines."Shortcut Dimension 1 Code");
        SalesLine.VALIDATE("Shortcut Dimension 2 Code", QBPostedServiceOrderLines."Shortcut Dimension 2 Code");
        SalesLine.MODIFY;
    end;

    //     procedure InitializeRequest (NewPostingDate@1002 : Date;NewDocDate@1003 : Date;NewCalcInvDisc@1000 : Boolean;NewPostInv@1001 : Boolean;NewOnlyStdPmtTerms@1004 : Boolean;NewCopyTextLines@1005 :
    procedure InitializeRequest(NewPostingDate: Date; NewDocDate: Date; NewCalcInvDisc: Boolean; NewPostInv: Boolean; NewOnlyStdPmtTerms: Boolean; NewCopyTextLines: Boolean)
    begin
        PostingDateReq := NewPostingDate;
        DocDateReq := NewDocDate;
        CalcInvDisc := NewCalcInvDisc;
        PostInv := NewPostInv;
        OnlyStdPmtTerms := NewOnlyStdPmtTerms;
        CopyTextLines := NewCopyTextLines;
    end;

    //     procedure SetHideDialog (NewHideDialog@1000 :
    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    //     procedure SetJobNo (JobNoAux@1000 :
    procedure SetJobNo(JobNoAux: Code[20])
    begin
        JobNo := JobNoAux;
    end;

    /*begin
    //{
//      Q16212 02/02/2022 (EPV) - Error al registrar pedidos de servicio con el QuoSII activado
//    }
    end.
  */

}




