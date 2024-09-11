page 7207341 "Vendor Conditions List"
{
    CaptionML = ENU = 'Conditions Vendor List', ESP = 'Lista de condiciones del proveedor';
    SourceTable = 7207420;
    SourceTableView = SORTING("Vendor No.", "Order");
    PageType = List;

    layout
    {
        area(content)
        {
            group("group4")
            {

                CaptionML = ESP = 'Proveedor';
                field("Vendor No."; rec."Vendor No.")
                {

                    Editable = false;
                }
                field("Vendor.Name"; Vendor.Name)
                {

                    CaptionML = ESP = 'Nombre';
                    Editable = false;
                }

            }
            repeater("table")
            {

                field("Line No."; rec."Line No.")
                {

                    Visible = false;
                }
                field("Job No."; rec."Job No.")
                {


                    ; trigger OnValidate()
                    BEGIN
                        SetDescription;
                    END;


                }
                field("Activity Code"; rec."Activity Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        SetDescription;
                    END;


                }
                field("Description"; Description)
                {

                    CaptionML = ESP = 'Descripci�n';
                    Editable = false;
                }
                field("Use Generals"; rec."Use Generals")
                {


                    ; trigger OnValidate()
                    BEGIN
                        SetEditable;
                    END;


                }
                field("Date Rec.INIT"; rec."Date INIT")
                {

                }
                field("Date End"; rec."Date End")
                {

                }
                field("Import General Conditions"; rec."Import General Conditions")
                {

                    Visible = false;
                }
                field("Import Other Conditions"; rec."Import Other Conditions")
                {

                    Visible = false;
                }
                field("Import General Conditions + Import Other Conditions"; rec."Import General Conditions" + rec."Import Other Conditions")
                {

                    CaptionML = ESP = 'Total otras condiciones';
                    Editable = false;
                }
                field("Validity Quotes"; rec."Validity Quotes")
                {

                    Editable = bGenerals;
                }
                field("Withholding Code"; rec."Withholding Code")
                {

                    Editable = bGenerals;
                }
                field("Withholding return term"; rec."Withholding return term")
                {

                    Editable = false;
                }
                field("Warranty"; rec."Warranty")
                {

                    Editable = bGenerals;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {

                    Editable = bGenerals;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                    Editable = bGenerals;
                }

            }
            group("group24")
            {

                part("part1"; 7207342)
                {
                    SubPageLink = "Vendor No." = FIELD("Vendor No."), "Line No." = FIELD("Line No.");
                    UpdatePropagation = Both;
                }
                part("part2"; 7207342)
                {

                    CaptionML = ENU = 'Vendor General Conditions', ESP = 'Condiciones Generales del Proveedor';
                    SubPageLink = "Vendor No." = FIELD("Vendor No."), "Line No." = CONST(0);
                    UpdatePropagation = Both

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ENU = '" Other Conditions"', ESP = 'Condiciones Proveredor';
                RunObject = Page 7207342;
                RunPageLink = "Vendor No." = FIELD("Vendor No."), "Line No." = CONST(0);
                Image = LotInfo;
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
    trigger OnOpenPage()
    BEGIN
        IF Rec.FINDFIRST THEN;
        bUseGenerals := (rec."Activity Code" <> '');

        IF NOT Vendor.GET(rec."Vendor No.") THEN
            Vendor.INIT;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetEditable;
        Rec.VALIDATE("Use Generals"); //Actualiza las condiciones del proveedor
        Rec.CALCFIELDS("Withholding return term");
        SetDescription;
    END;



    var
        ConditionsVendor: Record 7207420;
        Vendor: Record 23;
        ActivityQB: Record 7207280;
        Job: Record 167;
        bUseGenerals: Boolean;
        bGenerals: Boolean;
        Description: Text;

    LOCAL procedure SetEditable();
    begin
        bGenerals := (not rec."Use Generals");
    end;

    LOCAL procedure SetDescription();
    begin
        Description := '';
        if Job.GET(rec."Job No.") then
            Description := Job.Description;

        if ActivityQB.GET(rec."Activity Code") then begin
            if (Description <> '') then
                Description += ' -:- ';
            Description += ActivityQB.Description;
        end;
    end;

    // begin
    /*{
      JAV 26/09/19: - Esta p�gina pasa de ser una lista que solo puede tener un solo registro a una ficha, sin permitir altas ni bajas de los datos, solo modificar.
      JAV 12/11/19: - Volvemos a ponerla como lista pues ahora si que puede ser una lista con varios registros por fechas
    }*///end
}







