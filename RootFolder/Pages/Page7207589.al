page 7207589 "Get Certification Units"
{
    Editable = false;
    CaptionML = ENU = 'Get Certification Units', ESP = 'Traer unidades certificaci�n';
    SourceTable = 7207386;
    SourceTableView = SORTING("Job No.", "Customer Certification Unit", "Piecework Code")
                    ORDER(Ascending)
                    WHERE("Type" = CONST("Piecework"));
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                IndentationControls = Indentation;
                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = Strong;
                    StyleExpr = Mayor;
                }
                field("Indentation"; rec."Indentation")
                {

                    Visible = false;
                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    Style = Strong;
                    StyleExpr = Mayor;
                }
                field("Description"; rec."Description")
                {

                    Style = Strong;
                    StyleExpr = Mayor;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = False;
                    Style = Strong;
                    StyleExpr = Mayor;
                }
                // group("group11")
                // {

                    // CaptionML = ESP = 'Datos Venta';

                // }
                field("Sale Quantity (base)"; rec."Sale Quantity (base)")
                {

                    BlankZero = true;
                    Visible = verVenta;
                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                    BlankZero = true;
                    Visible = verVenta;
                }
                field("Sale Amount"; rec."Sale Amount")
                {

                    BlankZero = true;
                    Visible = verVenta;
                }
                // group("group15")
                // {

                //     CaptionML = ESP = 'Datos Coste';
                    field("Measure Budg. Piecework Sol"; rec."Measure Budg. Piecework Sol")
                    {

                        BlankZero = true;
                        Visible = verCoste;
                        Editable = false;
                    }
                    field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                    {

                        BlankZero = true;
                        Visible = verCoste;
                    }
                    field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                    {

                        BlankZero = true;
                        Visible = verCoste;
                        Style = Strong;
                        StyleExpr = mayor

  ;
                    }

                // }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Units', ESP = '&Unidades';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = '&Ficha';
                    Image = Card;


                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Job Piecework Card", Rec);
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
            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        Mayor := (rec."Account Type" = rec."Account Type"::Heading);
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        IF (CloseAction = ACTION::LookupOK) THEN
            LookupOKOnPush;
    END;



    var
        RelCertificationProduct: Record 7207397;
        DataPieceworkForProduction: Record 7207386;
        Text002: TextConst ENU = 'Delete data unit of work for certification?', ESP = '�Eliminiar datos unidad de obra para certificaci�n?';
        SeeType: Option "Certification","Production";
        verCoste: Boolean;
        verVenta: Boolean;
        Mayor: Boolean;
        Job: Code[20];
        Piecework: Code[20];

    procedure SetType(pType: Option; pJob: Code[20]; pPiecework: Code[20]);
    begin
        SeeType := pType;
        Job := pJob;
        Piecework := pPiecework;

        verCoste := (SeeType = SeeType::Production);
        verVenta := (SeeType = SeeType::Certification);

        Rec.RESET;
        Rec.SETRANGE("Job No.", Job);
        CASE pType OF
            SeeType::Certification:
                Rec.SETRANGE("Customer Certification Unit", TRUE);
            SeeType::Production:
                Rec.SETRANGE("Production Unit", TRUE);
        end;
    end;

    LOCAL procedure LookupOKOnPush();
    begin
        CurrPage.SETSELECTIONFILTER(DataPieceworkForProduction);
        if DataPieceworkForProduction.FINDSET then
            repeat
                if DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit then begin
                    RelCertificationProduct.INIT;
                    RelCertificationProduct."Job No." := Job;
                    CASE SeeType OF
                        SeeType::Certification:
                            begin
                                RelCertificationProduct."Production Unit Code" := Piecework;
                                RelCertificationProduct."Certification Unit Code" := DataPieceworkForProduction."Piecework Code";
                            end;
                        SeeType::Production:
                            begin
                                RelCertificationProduct."Production Unit Code" := DataPieceworkForProduction."Piecework Code";
                                RelCertificationProduct."Certification Unit Code" := Piecework;
                            end;
                    end;
                    RelCertificationProduct.VALIDATE("Percentage Of Assignment", RelCertificationProduct.CheckPercentage);
                    if not RelCertificationProduct.INSERT then;
                end;
            until DataPieceworkForProduction.NEXT = 0;
    end;

    // begin//end
}







