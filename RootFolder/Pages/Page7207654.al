page 7207654 "Guarantees Card"
{
    CaptionML = ENU = 'Guarantees', ESP = 'Ficha de garant�a';
    SourceTable = 7207441;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("No."; rec."No.")
                {

                }
                field("Quote No."; rec."Quote No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Customer"; rec."Customer")
                {

                }
                field("Description"; rec."Description")
                {

                }

            }
            group("group23")
            {

                CaptionML = ESP = 'Registro';
                field("Type"; rec."Type")
                {

                }
                field("Date of Expiration"; rec."Date of Expiration")
                {

                }
                field("Date of last expenses calc"; rec."Date of last expenses calc")
                {

                }
                field("Guarantee No."; rec."Guarantee No.")
                {

                }
                field("Guarantee No. Esp."; rec."Guarantee No. Esp.")
                {

                }

            }
            group("group29")
            {

                CaptionML = ESP = 'Importes';
                group("group30")
                {

                    CaptionML = ESP = 'Provisional';
                    field("Provisional Status"; rec."Provisional Status")
                    {

                    }
                    field("Provisional Date ofApplication"; rec."Provisional Date ofApplication")
                    {

                    }
                    field("Provisional Date of Issue"; rec."Provisional Date of Issue")
                    {

                    }
                    field("Provisional Date of request"; rec."Provisional Date of request")
                    {

                    }
                    field("Provisional Date of return"; rec."Provisional Date of return")
                    {

                    }
                    field("Provisional Amount"; rec."Provisional Amount")
                    {

                        Editable = edProvisional1;

                        ; trigger OnValidate()
                        BEGIN
                            SetEditable;
                        END;


                    }
                    field("Provisional Expenses Forecast"; rec."Provisional Expenses Forecast")
                    {

                        Editable = edProvisional1;
                    }
                    field("Provisional Emisions costs"; rec."Provisional Emisions costs")
                    {

                        Editable = edProvisional1;
                    }
                    field("Provisional Months payment"; rec."Provisional Months payment")
                    {

                        Editable = edProvisional2;
                    }
                    field("Provisional Amount per period"; rec."Provisional Amount per period")
                    {

                        Editable = edProvisional2;
                    }
                    field("Provisional final cost"; rec."Provisional final cost")
                    {

                        Editable = edProvisional2;
                    }
                    field("Provisional Total Cost"; rec."Provisional Total Cost")
                    {

                    }

                }
                group("group43")
                {

                    CaptionML = ESP = 'Definitiva';
                    field("Definitive Status"; rec."Definitive Status")
                    {

                    }
                    field("Definitive Date of Application"; rec."Definitive Date of Application")
                    {

                    }
                    field("Definitive Date of Issue"; rec."Definitive Date of Issue")
                    {

                    }
                    field("Definitive Date of request"; rec."Definitive Date of request")
                    {

                    }
                    field("Definitive Date of return"; rec."Definitive Date of return")
                    {

                    }
                    field("Definitive Amount"; rec."Definitive Amount")
                    {

                        Editable = edDefinitiva1;

                        ; trigger OnValidate()
                        BEGIN
                            SetEditable;
                        END;


                    }
                    field("Definitive Expenses Forecast"; rec."Definitive Expenses Forecast")
                    {

                        Editable = edDefinitiva1;
                    }
                    field("Definitive Emisions costs"; rec."Definitive Emisions costs")
                    {

                        Editable = edDefinitiva1;
                    }
                    field("Definitive Months payment"; rec."Definitive Months payment")
                    {

                        Editable = edDefinitiva2;
                    }
                    field("Definitive Amount per period"; rec."Definitive Amount per period")
                    {

                        Editable = edDefinitiva2;
                    }
                    field("Definitive final cost"; rec."Definitive final cost")
                    {

                        Editable = edDefinitiva2;
                    }
                    field("Definitive Total Cost"; rec."Definitive Total Cost")
                    {

                    }
                    field("Definitive Seized amount"; rec."Definitive Seized amount")
                    {

                        Editable = edDefinitiva2;
                    }

                }

            }
            part("part1"; 7207655)
            {

                SubPageView = SORTING("No.", "Line No.");
                SubPageLink = "No." = FIELD("No.");
            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {

                CaptionML = ESP = 'Dimensiones';
                action("action1")
                {
                    ShortCutKey = 'Shift+Ctrl+E';
                    CaptionML = ENU = 'See Quotes', ESP = 'Ver Estudio';
                    RunObject = Page 7207361;
                    RunPageLink = "No." = FIELD("Quote No.");
                    Enabled = edEstudio;
                    Image = Quote;
                }
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+P';
                    CaptionML = ENU = 'Dimensions', ESP = 'Ver Proyecto';
                    RunObject = Page 7207478;
                    RunPageLink = "No." = FIELD("Job No.");
                    Enabled = edProyecto;
                    Image = Job;
                }
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+F';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones Estudio';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(167), "No." = FIELD("Quote No.");
                    Enabled = edEstudio;
                    Image = Dimensions;
                }
                action("action4")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones Proyecto';
                    RunObject = Page 540;
                    RunPageLink = "Table ID" = CONST(167), "No." = FIELD("Job No.");
                    Enabled = edProyecto;
                    Image = Dimensions;
                }

            }
            group("group7")
            {

                CaptionML = ESP = 'Provisional';
                action("action5")
                {
                    CaptionML = ESP = 'Crear Provisional';
                    Visible = verAdmin;
                    Enabled = actProvisional;
                    Image = PostedPayableVoucher;

                    trigger OnAction()
                    BEGIN
                        Guarantees.CreateLine(Rec, 0, 0, FALSE);
                    END;


                }
                action("action6")
                {
                    CaptionML = ESP = 'Solicitar devoluci�n';
                    Visible = verAdmin;
                    Enabled = actProvisional;
                    Image = CloseDocument;

                    trigger OnAction()
                    BEGIN
                        Guarantees.SolicitarDevolucion(Rec, 0);
                    END;


                }
                action("action7")
                {
                    CaptionML = ESP = 'Cerrar Provisional';
                    Visible = verAdmin;
                    Enabled = actProvisional;
                    Image = DeleteQtyToHandle;

                    trigger OnAction()
                    BEGIN
                        Guarantees.CreateLine(Rec, 0, 1, FALSE);
                    END;


                }
                action("action8")
                {
                    CaptionML = ESP = 'Pasar a Definitiva';
                    Visible = verAdmin;
                    Enabled = actProvisional;
                    Image = ChangeTo;

                    trigger OnAction()
                    BEGIN
                        Guarantees.ToDefinitive(Rec);
                    END;


                }

            }
            group("group12")
            {

                CaptionML = ESP = 'Definitiva';
                action("action9")
                {
                    CaptionML = ESP = 'Crear Definitiva';
                    Visible = verAdmin;
                    Enabled = actDefinitiva;
                    Image = PostedPayableVoucher;

                    trigger OnAction()
                    BEGIN
                        Guarantees.CreateLine(Rec, 1, 0, FALSE);
                    END;


                }
                action("action10")
                {
                    CaptionML = ESP = 'Solicitar devoluci�n';
                    Visible = verAdmin;
                    Enabled = actDefinitiva;
                    Image = CloseDocument;

                    trigger OnAction()
                    BEGIN
                        Guarantees.SolicitarDevolucion(Rec, 1);
                    END;


                }
                action("action11")
                {
                    CaptionML = ESP = 'Cerrar Definitiva';
                    Visible = verAdmin;
                    Enabled = actDefinitiva;
                    Image = DeleteQtyToHandle;


                    trigger OnAction()
                    BEGIN
                        Guarantees.CreateLine(Rec, 1, 1, FALSE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ESP = 'Proceso';

                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ESP = 'Informe';
            }
            group(Category_Category4)
            {
                CaptionML = ESP = 'Provisional';

                actionref(action5_Promoted; action5)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
            }
            group(Category_Category5)
            {
                CaptionML = ESP = 'Definitiva';

                actionref(action9_Promoted; action9)
                {
                }
                actionref(action10_Promoted; action10)
                {
                }
                actionref(action11_Promoted; action11)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        UserSetup.GET(USERID);
        verAdmin := UserSetup."Guarantees Administrator";
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetEditable;
    END;



    var
        UserSetup: Record 91;
        Guarantees: Codeunit 7207355;
        verAdmin: Boolean;
        actProvisional: Boolean;
        actDefinitiva: Boolean;
        edProvisional1: Boolean;
        edProvisional2: Boolean;
        edDefinitiva1: Boolean;
        edDefinitiva2: Boolean;
        edEstudio: Boolean;
        edProyecto: Boolean;

    LOCAL procedure SetEditable();
    begin
        actProvisional := (rec."Provisional Amount" <> 0) and (rec."Definitive Status" < rec."Definitive Status"::Deposited);
        actDefinitiva := (rec."Definitive Amount" <> 0) and (rec."Provisional Status" IN [rec."Provisional Status"::" ", rec."Provisional Status"::Definitive]);
        edProvisional1 := (rec."Provisional Status" < rec."Provisional Status"::Deposited);
        edProvisional2 := (rec."Provisional Status" < rec."Provisional Status"::Canceled);
        edDefinitiva1 := (rec."Definitive Status" < rec."Definitive Status"::Deposited);
        edDefinitiva2 := (rec."Definitive Status" < rec."Definitive Status"::Canceled);
        edEstudio := (rec."Quote No." <> '');
        edProyecto := (rec."Job No." <> '');
    end;

    // begin//end
}







