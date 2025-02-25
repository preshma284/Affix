report 7207340 "Create Ship. Output Regular."
{


    CaptionML = ENU = 'Create Ship. Output Regular.', ESP = 'Crear alb. salida regular.';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Header Regularization Stock"; "Header Regularization Stock")
        {

            ;
            DataItem("Line Regularization Stock"; "Line Regularization Stock")
            {

                DataItemTableView = SORTING("Document No.", "Job No.")
                                 WHERE("Job No." = FILTER(<> ''), "Adjusted" = FILTER(<> 0));
                DataItemLink = "Document No." = FIELD("No.");
                trigger OnPreDataItem();
                BEGIN
                    Window.OPEN(Text006 + Text007 + Text008);

                    Total := "Line Regularization Stock".COUNT;

                    NoLine := 10000;

                    PresentJob := '';
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Read := Read + 1;
                    Window.UPDATE(1, ROUND(Read / Total * 10000, 1));
                    Window.UPDATE(2, Text003);
                    Window.UPDATE(3, Read);
                    Window.UPDATE(4, Total);

                    IF Job.GET("Job No.") THEN
                        IF (Job."Management By Production Unit") AND ("Piecework No." = '') THEN
                            ERROR(Text001, "Job No.", "Line No.");

                    LineRegularizationStock := "Line Regularization Stock";
                    LineRegularizationStock.DELETE;

                    IF PresentJob <> "Line Regularization Stock"."Job No." THEN BEGIN
                        PresentJob := "Line Regularization Stock"."Job No.";
                        FunCreateHeader;
                    END;
                    FunCreateLine;
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                HeaderRegularizationStock := "Header Regularization Stock";
                HeaderRegularizationStock.DELETE;
            END;

            trigger OnPostDataItem();
            BEGIN
                Window.CLOSE;

                COMMIT;

                CLEAR(OutputShipmentRegBatch);
                OutputShipmentHeader.MARKEDONLY(TRUE);
                OutputShipmentRegBatch.SETTABLEVIEW(OutputShipmentHeader);
                OutputShipmentRegBatch.USErequestpage(FALSE);
                OutputShipmentRegBatch.RUNMODAL;
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
        //       HeaderRegularizationStock@7001100 :
        HeaderRegularizationStock: Record 7207408;
        //       Window@7001101 :
        Window: Dialog;
        //       OutputShipmentRegBatch@7001102 :
        OutputShipmentRegBatch: Report 7207286;
        //       OutputShipmentHeader@7001103 :
        OutputShipmentHeader: Record 7207308;
        //       Text006@7001104 :
        Text006: TextConst ENU = 'Generating shipment\', ESP = 'Generando albaranes\';
        //       Text007@7001105 :
        Text007: TextConst ENU = '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        //       Text008@7001106 :
        Text008: TextConst ENU = '#2##########  #3###### #4#########';
        //       Total@7001107 :
        Total: Integer;
        //       NoLine@7001108 :
        NoLine: Integer;
        //       PresentJob@7001109 :
        PresentJob: Code[20];
        //       Read@7001110 :
        Read: Integer;
        //       Text003@7001111 :
        Text003: TextConst ENU = 'No. Shipment', ESP = 'Albar n N§';
        //       Job@7001112 :
        Job: Record 167;
        //       Text001@7001113 :
        Text001: TextConst ESP = 'El proyecto %1 de la l¡na %2 debe tener unidad de obra';
        //       LineRegularizationStock@7001114 :
        LineRegularizationStock: Record 7207409;
        //       NoShipment@7001115 :
        NoShipment: Code[20];
        //       QBCommentLine@7001116 :
        QBCommentLine: Record 7207270;
        //       QBCommentLineShipment@7001117 :
        QBCommentLineShipment: Record 7207270;
        //       OutputShipmentLines@7001118 :
        OutputShipmentLines: Record 7207309;
        //       Text002@1100286000 :
        Text002: TextConst ENU = 'The analytical concept cannot be the one configured for the warehouse.', ESP = 'El concepto anal¡tico no puede ser el configurado para el almac‚n.';
        //       InventoryPostingSetup@1100286001 :
        InventoryPostingSetup: Record 5813;
        //       FunctionQB@1100286002 :
        FunctionQB: Codeunit 7207272;
        //       Text004@1100286003 :
        Text004: TextConst ENU = 'You must fill Analitic Concep.', ESP = 'Es obligatorio informar el Concepto Anal¡tico.';
        //       Text005@1100286004 :
        Text005: TextConst ENU = '¨Ha comprobado que los Conceptos Anal¡ticos informados son los correctos?', ESP = '¨Ha comprobado que los Conceptos Anal¡ticos informados son los correctos?';

    procedure FunCreateHeader()
    begin
        //QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock. -
        if not CONFIRM(Text005, FALSE) then
            ERROR('Proceso cancelado.');
        //QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock. +

        NoShipment := '';
        OutputShipmentHeader.INIT;
        OutputShipmentHeader."No." := '';
        OutputShipmentHeader.INSERT(TRUE);
        NoShipment := OutputShipmentHeader."No.";
        OutputShipmentHeader.VALIDATE("Job No.", "Line Regularization Stock"."Job No.");
        OutputShipmentHeader.VALIDATE("Posting Date", "Header Regularization Stock"."Posting Date");
        OutputShipmentHeader.VALIDATE("Posting Description", "Header Regularization Stock"."Posting Description");
        OutputShipmentHeader.VALIDATE("Request Date", "Header Regularization Stock"."Regularization Date");
        OutputShipmentHeader."Stock Regulation" := TRUE;
        OutputShipmentHeader.MODIFY;
        OutputShipmentHeader.MARK(TRUE);
        QBCommentLine.SETRANGE("No.", "Line Regularization Stock"."Document No.");
        if QBCommentLine.FINDSET then begin
            repeat
                QBCommentLineShipment.INIT;
                QBCommentLineShipment."Document Type" := QBCommentLineShipment."Document Type"::Receipt;
                QBCommentLineShipment."No." := NoShipment;
                QBCommentLineShipment."Line No." := QBCommentLine."Line No.";
                QBCommentLineShipment.Date := QBCommentLine.Date;
                QBCommentLineShipment.Code := QBCommentLine.Code;
                QBCommentLineShipment.Comment := QBCommentLine.Comment;
                QBCommentLineShipment.INSERT;
            until QBCommentLine.NEXT = 0;
        end;
    end;

    procedure FunCreateLine()
    var
        //       JobVL@1100286000 :
        JobVL: Record 167;
        //       ItemVL@1100286001 :
        ItemVL: Record 27;
    begin
        //QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock. -
        JobVL.GET("Line Regularization Stock"."Job No.");
        ItemVL.GET("Line Regularization Stock"."Item No.");

        InventoryPostingSetup.GET(JobVL."Job Location", ItemVL."Inventory Posting Group");
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 then begin
            "Line Regularization Stock".TESTFIELD("Shortcut Dimension 1 Code");
            //if "Line Regularization Stock"."Shortcut Dimension 1 Code" = InventoryPostingSetup."Analytic Concept" then
            //  ERROR(Text002);
        end;
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 then begin
            "Line Regularization Stock".TESTFIELD("Shortcut Dimension 2 Code");
            //if "Line Regularization Stock"."Shortcut Dimension 2 Code" = InventoryPostingSetup."Analytic Concept" then
            //  ERROR(Text002);
        end;
        //QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock. +


        OutputShipmentLines.RESET;
        OutputShipmentLines.INIT;
        OutputShipmentLines.VALIDATE("Document No.", NoShipment);
        OutputShipmentLines.VALIDATE("Line No.", NoLine);
        OutputShipmentLines.INSERT(TRUE);

        OutputShipmentLines.VALIDATE("No.", "Line Regularization Stock"."Item No.");
        OutputShipmentLines.VALIDATE("Produccion Unit", "Line Regularization Stock"."Piecework No.");
        OutputShipmentLines.VALIDATE(Quantity, -"Line Regularization Stock".Adjusted);
        OutputShipmentLines.VALIDATE("Unit Cost", "Line Regularization Stock"."Unit Cost");

        //QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock. -
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 then
            OutputShipmentLines.VALIDATE("Shortcut Dimension 1 Code", "Line Regularization Stock"."Shortcut Dimension 1 Code");
        if FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 then
            OutputShipmentLines.VALIDATE("Shortcut Dimension 2 Code", "Line Regularization Stock"."Shortcut Dimension 2 Code");
        //QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock. +
        OutputShipmentLines.MODIFY;
        NoLine += 10000;
    end;

    /*begin
    //{
//      //QBU17147 CSM 11/05/22 Í Mostrar columna de Concepto Anal¡tico en la regularizaci¢n de stock.
//    }
    end.
  */

}



