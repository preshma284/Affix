page 7207577 "Comparative Quote Detail"
{
    CaptionML = ENU = 'Comparative Quote Detail', ESP = 'Detalle comparativo oferta';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207414;
    PageType = ListPlus;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("codeContact/Vendor"; "codeContact/Vendor")
                {

                    CaptionML = ESP = 'C�digo Proveedor/Contacto';
                }
                field("PhoneContact/Vendor"; "PhoneContact/Vendor")
                {

                    CaptionML = ESP = 'N� tel�fono';
                }
                field("FaxContact/Vendor"; "FaxContact/Vendor")
                {

                    CaptionML = ESP = 'N� fax';
                }
                field("NameContact/Vendor"; "NameContact/Vendor")
                {

                    CaptionML = ESP = 'Nombre Proveedor/Contacto';
                }
                field("MobileContact/Vendor"; "MobileContact/Vendor")
                {

                    CaptionML = ESP = 'N� tel�fono movil';
                }

            }
            part("part1"; 7207578)
            {
                SubPageLink = "Quote Code" = FIELD("Quote Code"), "Vendor No." = FIELD("Vendor No.");
            }
            part("part2"; 7207551)
            {
                SubPageLink = "Quote Code" = FIELD("Quote Code"), "Vendor No." = FIELD("Vendor No."), "Contact No." = FIELD("Contact No.");
            }
            group("Otras condiciones")
            {

                field("Start Date"; rec."Start Date")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("End Date"; rec."End Date")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Quonte Date"; rec."Quonte Date")
                {

                }
                field("Quote Validity"; rec."Quote Validity")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Payment Terms Code"; rec."Payment Terms Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Payment Method Code"; rec."Payment Method Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Withholding Code"; rec."Withholding Code")
                {

                }
                field("Return Withholding"; rec."Return Withholding")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part3"; 7207627)
            {
                ;
            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Anterior")
            {

                CaptionML = ENU = 'Previus Record', ESP = 'Anterior proveedor';
                Image = PreviousRecord;

                trigger OnAction()
                BEGIN
                    PreviusRecord;
                END;


            }
            action("Siguiente")
            {

                CaptionML = ENU = 'Next Record', ESP = 'Siguiente proveedor';
                Image = NextRecord;


                trigger OnAction()
                BEGIN
                    NextRecord;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Anterior_Promoted; Anterior)
                {
                }
                actionref(Siguiente_Promoted; Siguiente)
                {
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        rec.CALCFIELDS("Total Estimated Amount", "Total Target Amount", "Other Conditions Amount", "Initial Estimated Total Amount");

        IF rec."Vendor No." <> '' THEN BEGIN
            IF NOT Vendor.GET(rec."Vendor No.") THEN
                CLEAR(Vendor);
            "codeContact/Vendor" := rec."Vendor No.";
            "NameContact/Vendor" := Vendor.Name;
            "PhoneContact/Vendor" := Vendor."Phone No.";
            "FaxContact/Vendor" := Vendor."Fax No.";
            "MobileContact/Vendor" := Vendor."Telex No.";
        END ELSE BEGIN
            IF NOT Contact.GET(rec."Contact No.") THEN
                CLEAR(Contact);
            "codeContact/Vendor" := rec."Contact No.";
            "NameContact/Vendor" := Contact.Name;
            "PhoneContact/Vendor" := Contact."Phone No.";
            "FaxContact/Vendor" := Contact."Fax No.";
            "MobileContact/Vendor" := Contact."Telex No.";
        END;
        IF Job.GET(rec."Job No.") THEN;
        SumJobUnit := SumJobUnits;
        //SumSeveral := "Other Conditions Amount";
        PreviusUploadValuesConditions;
    END;



    var
        Vendor: Record 23;
        ActivityQB: Record 7207280;
        Job: Record 167;
        DataPricesVendor: Record 7207415;
        VendorCond: Record 7207417;
        PurchasesPayablesSetup: Record 312;
        Contact: Record 5050;
        Code: ARRAY[12] OF Code[20];
        "codeContact/Vendor": Code[20];
        Name: ARRAY[12] OF Text[60];
        "NameContact/Vendor": Text[60];
        "PhoneContact/Vendor": Text[30];
        "FaxContact/Vendor": Text[30];
        "MobileContact/Vendor": Text[30];
        Value: ARRAY[12] OF Decimal;
        SumJobUnit: Decimal;
        SumSeveral: Decimal;
        // WSHShell: Automation  "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{72C24DD5-D70A-438B-8A42-98424B88AFB8}:'Windows Script Host Object Model'.WshShell";



    procedure EstimatedAmountDifference(): Decimal;
    begin
        if rec."Total Estimated Amount" <> 0 then
            exit(((SumJobUnit - rec."Total Estimated Amount") / rec."Total Estimated Amount") * 100)
        ELSE
            exit(0);
    end;

    procedure TargetAmountDifference(): Decimal;
    begin
        if rec."Total Target Amount" <> 0 then
            exit(((SumJobUnit - rec."Total Target Amount") / rec."Total Target Amount") * 100)
        ELSE
            exit(0);
    end;

    procedure SumJobUnits(): Decimal;
    var
        SumJobUnitL: Decimal;
    begin
        DataPricesVendor.SETFILTER("Quote Code", rec."Quote Code");
        DataPricesVendor.SETFILTER("Vendor No.", rec."Vendor No.");
        DataPricesVendor.SETFILTER("Contact No.", rec."Contact No.");
        SumJobUnitL := 0;
        if DataPricesVendor.FINDSET then
            repeat
                SumJobUnitL += DataPricesVendor.Quantity * DataPricesVendor."Vendor Price";
            until DataPricesVendor.NEXT = 0;
        exit(SumJobUnitL);
    end;

    procedure InitialEstimatedAmountDifference(): Decimal;
    begin
        if rec."Initial Estimated Total Amount" <> 0 then
            exit(((SumJobUnit - rec."Initial Estimated Total Amount") / rec."Initial Estimated Total Amount") * 100)
        ELSE
            exit(0);
    end;

    LOCAL procedure PreviusUploadValuesConditions();
    begin
        xRec := Rec;
    end;

    LOCAL procedure Control32OnDeactivate();
    begin
        // Al volver de la edici�n del subformulario, recalcula la suma de unidades obra
        SumJobUnit := SumJobUnits;
    end;

    procedure NextRecord();
    begin
        // if ISSERVICETIER then begin
            // if ISCLEAR(WSHShell) then
            //     CREATE(WSHShell, FALSE, ISSERVICETIER);
            // WSHShell.SendKeys('^{PGDN}');
            // CLEAR(WSHShell);
        // end
    end;

    procedure PreviusRecord();
    begin
        // if ISSERVICETIER then begin
            // if ISCLEAR(WSHShell) then
            //     CREATE(WSHShell, FALSE, ISSERVICETIER);
            // WSHShell.SendKeys('^{PGUP}');
            // CLEAR(WSHShell);
        // end;
    end;

    // begin
    /*{
      JAV 21/11/19: - Se eliminan los campos "Other Vendor Conditions Code 1" y "Other Vendor Conditions Code 2" pues ya no se usan
                    - Se eliminan el uso de la actividad en las condicones
    }*///end
}







