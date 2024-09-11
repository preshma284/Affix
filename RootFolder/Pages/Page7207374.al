page 7207374 "Measure Lines Bill of Item"
{
    CaptionML = ENU = 'Measure Lines Bill of Item', ESP = 'Descompuesto Lineas de Medici�n';
    SourceTable = 7207395;
    PageType = Worksheet;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Description"; rec."Description")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Budget Units"; rec."Budget Units")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Budget Length"; rec."Budget Length")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Budget Width"; rec."Budget Width")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Budget Height"; rec."Budget Height")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Budget Total"; rec."Budget Total")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Realized Units"; rec."Realized Units")
                {

                    Visible = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Realized Total"; rec."Realized Total")
                {

                    Visible = false;
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Measured % Progress"; rec."Measured % Progress")
                {


                    ; trigger OnValidate()
                    BEGIN
                        UpdateData(FALSE);
                        //-Q17698
                        IF (rec."Measured % Progress" > 100) AND Rec.FIELDACTIVE(rec."Measured % Progress") THEN ERROR('No se puede dar m�s de 100% de medicion por l�neas');
                        //+Q17698
                    END;


                }
                field("Measured Units"; rec."Measured Units")
                {


                    ; trigger OnValidate()
                    BEGIN
                        UpdateData(FALSE);
                        //-Q17698
                        Rec.CALCFIELDS(rec."Realized Units");
                        IF rec."Realized Units" < rec."Measured Units" THEN ERROR('No se puede dar m�s de 100% de medicion por l�neas');
                        //+Q17698
                    END;


                }
                field("Period Units"; rec."Period Units")
                {


                    ; trigger OnValidate()
                    BEGIN
                        UpdateData(FALSE);
                        //-Q17698
                        Rec.CALCFIELDS(rec."Realized Units");
                        IF rec."Realized Units" < rec."Measured Units" THEN ERROR('No se puede dar m�s de 100% de medicion por l�neas');
                        //+Q17698
                    END;


                }
                field("Measured Total"; rec."Measured Total")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Period Total"; rec."Period Total")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }

            }
            group("group20")
            {

                group("group21")
                {

                    CaptionML = ENU = 'Previous Measured Quantity', ESP = 'Totales';
                    field("TotalMeadureBudget"; TotalMeadureBudget)
                    {

                        CaptionML = ENU = 'Previous Measured Quantity', ESP = 'Cantidad Total Presupuestada';
                        Editable = FALSE;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("TotalMeasureAnt"; TotalMeasureAnt)
                    {

                        CaptionML = ENU = 'Previous Measured Quantity', ESP = 'Cantidad medida anterior';
                        Editable = FALSE;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("TotalMeasureOrigin"; TotalMeasureOrigin)
                    {

                        CaptionML = ENU = 'Total Origin Quantity', ESP = 'Cantidad total origen';
                        Editable = FALSE;
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field("TotalMeasurePeriod"; TotalMeasurePeriod)
                    {

                        CaptionML = ENU = 'Total Quantity Term', ESP = 'Cantidad total per�odo';
                        Editable = FALSE;
                        Style = Strong;
                        StyleExpr = TRUE

  ;
                    }

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Actions', ESP = 'A&cciones';
                action("action1")
                {
                    CaptionML = ENU = 'Match Budget', ESP = 'Igualar a presupuesto';
                    Image = Copy;

                    trigger OnAction()
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(MeasureLinesBillofItem);

                        IF CONFIRM(Text001, TRUE, MeasureLinesBillofItem.COUNT) THEN BEGIN
                            IF MeasureLinesBillofItem.FINDSET(TRUE) THEN
                                REPEAT
                                    MeasureLinesBillofItem.VALIDATE("Measured Units", MeasureLinesBillofItem."Budget Units");
                                    MeasureLinesBillofItem.MODIFY;
                                UNTIL MeasureLinesBillofItem.NEXT = 0;
                            CurrPage.UPDATE(FALSE);
                        END;
                    END;


                }
                action("action2")
                {
                    CaptionML = ESP = 'Quitar marca de edici�n';
                    Image = CancelLine;


                    trigger OnAction()
                    BEGIN
                        IF (rec."Document Type" = rec."Document Type"::Measuring) THEN BEGIN
                            IF MeasurementLines.GET(rec."Document No.", rec."Line No.") THEN BEGIN
                                IF CONFIRM(Text002, FALSE) THEN BEGIN
                                    MeasureLinesBillofItem.RESET;
                                    MeasureLinesBillofItem.SETRANGE("Document Type", rec."Document Type");
                                    MeasureLinesBillofItem.SETRANGE("Document No.", rec."Document No.");
                                    MeasureLinesBillofItem.SETRANGE("Line No.", rec."Line No.");
                                    IF MeasureLinesBillofItem.FINDSET(FALSE) THEN
                                        REPEAT
                                            MeasureLinesBillofItem.VALIDATE("Measured % Progress", MeasurementLines."Med. % Measure");
                                            MeasureLinesBillofItem.MODIFY;
                                        UNTIL MeasureLinesBillofItem.NEXT = 0;

                                    MeasurementLines."From Measure" := FALSE;
                                    MeasurementLines.MODIFY;
                                    CurrPage.CLOSE;
                                END;
                            END;
                        END;

                        IF (rec."Document Type" = rec."Document Type"::"Valued Relationship") THEN BEGIN
                            IF ProdMeasureLines.GET(rec."Document No.", rec."Line No.") THEN BEGIN
                                IF CONFIRM(Text002, FALSE) THEN BEGIN
                                    MeasureLinesBillofItem.RESET;
                                    MeasureLinesBillofItem.SETRANGE("Document Type", rec."Document Type");
                                    MeasureLinesBillofItem.SETRANGE("Document No.", rec."Document No.");
                                    MeasureLinesBillofItem.SETRANGE("Line No.", rec."Line No.");
                                    IF MeasureLinesBillofItem.FINDSET(FALSE) THEN
                                        REPEAT
                                            MeasureLinesBillofItem.VALIDATE("Measured % Progress", ProdMeasureLines."% Progress To Source");
                                            MeasureLinesBillofItem.MODIFY;
                                        UNTIL MeasureLinesBillofItem.NEXT = 0;

                                    ProdMeasureLines."From Measure" := FALSE;
                                    ProdMeasureLines.MODIFY;
                                    CurrPage.CLOSE;
                                END;
                            END;
                        END;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        bCancelFromMeasure := FALSE;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        CASE rec."Document Type" OF
           rec. "Document Type"::Measuring:
                BEGIN
                    MeasurementLines.GET(rec."Document No.", rec."Line No.");
                    rec."Piecework Code" := MeasurementLines."Piecework No.";
                    rec."Job No." := MeasurementLines."Job No.";
                END;
            rec."Document Type"::"Valued Relationship":
                BEGIN
                    ProdMeasureLines.GET(rec."Document No.", rec."Line No.");
                    rec."Piecework Code" := ProdMeasureLines."Piecework No.";
                    rec."Job No." := ProdMeasureLines."Job No.";
                END;
        END;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        UpdateData(TRUE);
    END;



    var
        TotalMeadureBudget: Decimal;
        TotalMeasureOrigin: Decimal;
        TotalMeasurePeriod: Decimal;
        TotalMeasureAnt: Decimal;
        MeasurementLines: Record 7207337;
        ProdMeasureLines: Record 7207400;
        MeasureLinesBillofItem: Record 7207395;
        Text001: TextConst ENU = 'Do you want to match Budgets?', ESP = '�Desea igualar en las %1 l�neas seleccionadas la medici�n al 100% del presupuesto?';
        Text002: TextConst ESP = 'Esta acci�n dejar� editable la l�nea de medici�n, las cantidades se ajustar�n a lo indicado en la l�nea para evitar discrepancias.';
        bCancelFromMeasure: Boolean;

    procedure UpdateData(pTotal: Boolean);
    begin
        TotalMeadureBudget := 0;
        TotalMeasureOrigin := 0;
        TotalMeasurePeriod := 0;

        MeasureLinesBillofItem.RESET;
        MeasureLinesBillofItem.SETRANGE("Document Type", rec."Document Type");
        MeasureLinesBillofItem.SETRANGE("Document No.", rec."Document No.");
        MeasureLinesBillofItem.SETRANGE("Line No.", rec."Line No.");
        if MeasureLinesBillofItem.FINDSET(FALSE) then
            repeat
                if (pTotal) or (MeasureLinesBillofItem."Bill of Item No Line" <> rec."Bill of Item No Line") then begin
                    TotalMeadureBudget += MeasureLinesBillofItem."Budget Total";
                    TotalMeasureOrigin += MeasureLinesBillofItem."Measured Total";
                    TotalMeasurePeriod += MeasureLinesBillofItem."Period Total";
                end ELSE begin
                    TotalMeadureBudget += rec."Budget Total";
                    TotalMeasureOrigin += rec."Measured Total";
                    TotalMeasurePeriod += rec."Period Total";
                end;
            until MeasureLinesBillofItem.NEXT = 0;

        TotalMeasureAnt := TotalMeasureOrigin - TotalMeasurePeriod;
    end;

    procedure CancelFromMeasure(): Boolean;
    begin
        exit(bCancelFromMeasure);
    end;

    // begin
    /*{
      AML 07/06/23: - Q17698 Correcciones para la actualizacion de l�neas de medicion en RV.
    }*///end
}







