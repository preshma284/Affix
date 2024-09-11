page 7207559 "Select. Subcont. Unit List"
{
    Editable = false;
    CaptionML = ENU = 'Select. Subcont. Unit List', ESP = 'Lista unid. Subcon. Seleccion';
    SourceTable = 7207386;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Piecework Code"; rec."Piecework Code")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Budget Measure"; rec."Budget Measure")
                {

                }
                field("Measured Qty Subc. Piecework"; rec."Measured Qty Subc. Piecework")
                {

                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

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

                CaptionML = ESP = '&Unidades de obra';
                action("action1")
                {
                    CaptionML = ENU = 'Bill of Item', ESP = 'Descompuesto';
                    RunObject = Page 7207526;
                    RunPageView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.");
                    RunPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code");
                    Image = BinContent;
                }

            }

        }
        area(Processing)
        {


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        IF CloseAction = ACTION::LookupOK THEN
            LookupOkOnPush;
    END;



    var
        AmountCostEmphasize: Boolean;
        codeMeasure: Code[20];
        recLinMedProd: Record 7207400;
        RecUnidadObraProd: Record 7207386;
        intNolinea: Integer;

    LOCAL procedure FunShowAmountCostOnFormat();
    begin
        if rec."Account Type" <> rec."Account Type"::Unit then begin
            AmountCostEmphasize := TRUE;
        end;
    end;

    procedure RecieveData(parcodeMeasure: Code[20]);
    begin
        codeMeasure := parcodeMeasure;
    end;

    LOCAL procedure LookupOkOnPush();
    begin
        if codeMeasure <> '' then begin
            intNolinea := 0;
            recLinMedProd.SETRANGE("Document No.", codeMeasure);
            if recLinMedProd.FINDFIRST then
                intNolinea := recLinMedProd."Line No." + 10000
            ELSE
                intNolinea := 10000;
            CurrPage.SETSELECTIONFILTER(RecUnidadObraProd);
            if RecUnidadObraProd.FINDSET then
                repeat
                    if RecUnidadObraProd."Account Type" = RecUnidadObraProd."Account Type"::Unit then begin
                        RecUnidadObraProd.CALCFIELDS("Measured Qty Subc. Piecework");
                        recLinMedProd.SETRANGE("Document No.", codeMeasure);
                        recLinMedProd.SETRANGE("Piecework No.", RecUnidadObraProd."Piecework Code");
                        if recLinMedProd.FINDFIRST then begin
                            recLinMedProd.VALIDATE("Measure Source", RecUnidadObraProd."Measured Qty Subc. Piecework");
                            recLinMedProd.MODIFY;
                        end ELSE begin
                            recLinMedProd."Document No." := codeMeasure;
                            recLinMedProd."Line No." := intNolinea;
                            //JMMA recLinMedProd.INSERT(TRUE);
                            recLinMedProd.INSERT;
                            recLinMedProd.VALIDATE("Job No.", RecUnidadObraProd."Job No.");
                            recLinMedProd.VALIDATE("Piecework No.", RecUnidadObraProd."Piecework Code");
                            recLinMedProd.VALIDATE("Measure Source", RecUnidadObraProd."Measured Qty Subc. Piecework");
                            recLinMedProd.MODIFY;
                            intNolinea := intNolinea + 10000;
                        end;
                    end;
                until RecUnidadObraProd.NEXT = 0;
        end;
    end;

    // begin//end
}







