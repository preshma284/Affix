page 7207549 "Conditions Vendor Quote"
{
    CaptionML = ENU = 'Conditions Vendor Quote', ESP = 'Condiciones Proveedor Oferta';
    SourceTable = 7207414;
    DelayedInsert = true;
    PopulateAllFields = true;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("group18")
            {

                CaptionML = ESP = 'Importes';
                field("Initial Estimated Total Amount"; rec."Initial Estimated Total Amount")
                {

                    Visible = false;
                    Style = Strong;
                    StyleExpr = bSelected;
                }
                field("Total Estimated Amount"; rec."Total Estimated Amount")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Total Target Amount"; rec."Total Target Amount")
                {

                    Style = Favorable;
                }

            }
            group("group22")
            {

                CaptionML = ENU = 'General', ESP = 'Proveedores';
                repeater("Group")
                {

                    field("Vendor No."; rec."Vendor No.")
                    {

                        StyleExpr = LineStyle;

                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;  //JAV 02/06/22: - QB 1.10.47 Para que se lance el control de contratos marco se refresca la p�gina al poner el proveedor
                        END;


                    }
                    field("Contact No."; rec."Contact No.")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Version No."; rec."Version No.")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Version Date"; rec."Version Date")
                    {

                    }
                    field("NameVendorContact"; rec."NameVendorContact")
                    {

                        CaptionML = ENU = 'Name', ESP = 'Nombre';
                        StyleExpr = LineStyle;
                    }
                    field("CountyVendorContact"; rec."CountyVendorContact")
                    {

                        CaptionML = ENU = 'Name', ESP = 'Provincia';
                        StyleExpr = LineStyle;
                    }
                    field("Selected Vendor"; rec."Selected Vendor")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Total Vendor Amount"; rec."Total Vendor Amount")
                    {

                        CaptionML = ENU = 'Total Vendor Amount', ESP = 'Importe L�neas';
                        StyleExpr = LineStyle;
                    }
                    field("Other Conditions"; rec."Other Conditions")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Other Conditions Amount"; rec."Other Conditions Amount")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("TotalAmount"; TotalAmount)
                    {

                        CaptionML = ESP = 'Total Proveedor';
                        StyleExpr = TotalStyle;
                    }
                    field("Lines whitout prices"; rec."Lines whitout prices")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Payment Phases"; rec."Payment Phases")
                    {

                        Visible = verPaymentPhases;
                        StyleExpr = LineStyle;

                        ; trigger OnValidate()
                        BEGIN
                            SetEditable;
                        END;


                    }
                    field("Payment Terms Code"; rec."Payment Terms Code")
                    {

                        Enabled = actPayment;
                        StyleExpr = LineStyle;
                    }
                    field("Payment Method Code"; rec."Payment Method Code")
                    {

                        Enabled = actPayment;
                        StyleExpr = LineStyle;
                    }
                    field("Withholding Code"; rec."Withholding Code")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Warranty"; rec."Warranty")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Quote Validity"; rec."Quote Validity")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Start Date"; rec."Start Date")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("End Date"; rec."End Date")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Quonte Date"; rec."Quonte Date")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Evaluation Activity"; rec."Evaluation Activity")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Clasification Activity"; rec."Clasification Activity")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Evaluation Global"; rec."Evaluation Global")
                    {

                        StyleExpr = LineStyle;
                    }
                    field("Clasification Global"; rec."Clasification Global")
                    {

                        StyleExpr = LineStyle;
                    }

                }

            }
            part("QuoteLinesbyVendor"; 7207550)
            {
                SubPageLink = "Quote Code" = FIELD("Quote Code"), "Vendor No." = FIELD("Vendor No."), "Contact No." = FIELD("Contact No."), "Version No." = FIELD("Version No.");
                UpdatePropagation = Both;
            }

        }
        area(FactBoxes)
        {
            part("DropArea"; 7174655)
            {

                Visible = seeDragDrop;
            }
            part("FilesSP"; 7174656)
            {

                Visible = seeDragDrop;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Vendor', ESP = '&Proveedor';
                action("action1")
                {
                    CaptionML = ENU = 'Create Contact', ESP = 'Crear contacto';
                    Image = AddContacts;

                    trigger OnAction()
                    VAR
                        CreatingContacts: Codeunit 7207335;
                    BEGIN
                        CLEAR(CreatingContacts);
                        CreatingContacts.CreateContact(rec."Quote Code");
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Create contact as a Vendor', ESP = 'Crear contacto como proveedor';
                    Image = New;

                    trigger OnAction()
                    BEGIN
                        AsociateVendor(TRUE);
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Relate contacts with Vendor', ESP = 'Relaccionar contactos con proveedor';
                    Image = VendorContact;

                    trigger OnAction()
                    BEGIN
                        AsociateVendor(FALSE);
                    END;


                }
                action("action4")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Vendor Card', ESP = 'Proveedor/Contacto';
                    Image = Vendor;

                    trigger OnAction()
                    VAR
                        Vendor: Record 23;
                        VendorCard: Page 26;
                        Contact: Record 5050;
                        ContactCard: Page 5050;
                    BEGIN
                        IF rec."Vendor No." = '' THEN
                            rec."Vendor No." := rec.RelationshipBusinessCreated;
                        IF rec."Vendor No." <> '' THEN BEGIN
                            Vendor.RESET;
                            Vendor.SETRANGE("No.", Rec."Vendor No.");
                            CLEAR(VendorCard);
                            VendorCard.SETTABLEVIEW(Vendor);
                            VendorCard.RUNMODAL;
                            //JAV 26/03/19: - Ir la ficha del proveedor o a la del contacto
                            //END;
                        END ELSE BEGIN
                            Contact.RESET;
                            Contact.SETRANGE("No.", Rec."Contact No.");
                            CLEAR(ContactCard);
                            ContactCard.SETTABLEVIEW(Contact);
                            ContactCard.RUNMODAL;
                        END;
                        //JAV 26/03/19
                    END;


                }
                separator("separator5")
                {

                }
                action("action6")
                {
                    CaptionML = ENU = 'Select Vendor', ESP = 'Seleccionar proveedor';
                    Image = SuggestVendorBills;

                    trigger OnAction()
                    BEGIN
                        IF NOT Rec.MODIFY(TRUE) THEN
                            ERROR('Esta l�nea no puede generar un contrato');

                        //JAV 05/06/22: - QB 1.10.47 Se verifica que sea posible generar estas l�neas
                        DataPricesVendor1.RESET;
                        DataPricesVendor1.SETRANGE("Quote Code", Rec."Quote Code");
                        DataPricesVendor1.SETRANGE("Vendor No.", Rec."Vendor No.");
                        DataPricesVendor1.SETRANGE("Contact No.", Rec."Contact No.");
                        DataPricesVendor1.SETRANGE("Version No.", Rec."Version No.");
                        IF (NOT DataPricesVendor1.FINDSET(FALSE)) THEN
                            ERROR('No tiene l�neas para generar')
                        ELSE
                            REPEAT
                                IF (DataPricesVendor1.Quantity = 0) OR (DataPricesVendor1."Vendor Price" = 0) THEN
                                    ERROR('El %1 %2 tiene cantidad o precio a cero, no puede generar un contrato', DataPricesVendor1.Type, DataPricesVendor1."No.");
                            UNTIL DataPricesVendor1.NEXT = 0;

                        rec.SelectVendor(Rec);
                        CurrPage.UPDATE();
                    END;


                }
                action("action7")
                {
                    CaptionML = ENU = 'Deselect Vendor', ESP = 'Quitar proveedor seleccionado';
                    Image = CancelFALedgerEntries;

                    trigger OnAction()
                    BEGIN
                        //JAV 12/03/19: - Se a�ade un bot�n para deseleccionar al proveedor
                        rec.UnselectVendor(rec."Quote Code");
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("action8")
                {
                    CaptionML = ENU = 'Other Conditions', ESP = 'Otras condiciones';
                    Image = LotInfo;

                    trigger OnAction()
                    VAR
                        OtherVendorConditions: Record 7207416;
                        pgOtherVendorConditions: Page 7207551;
                    BEGIN
                        OtherVendorConditions.RESET;
                        OtherVendorConditions.SETRANGE("Quote Code", rec."Quote Code");
                        OtherVendorConditions.SETRANGE("Vendor No.", rec."Vendor No.");
                        OtherVendorConditions.SETRANGE("Contact No.", rec."Contact No.");
                        OtherVendorConditions.SETRANGE("Version No.", rec."Version No.");

                        CLEAR(pgOtherVendorConditions);
                        pgOtherVendorConditions.SETTABLEVIEW(OtherVendorConditions);
                        pgOtherVendorConditions.RUNMODAL;

                        CurrPage.UPDATE;
                    END;


                }
                action("CreateVersion")
                {

                    CaptionML = ENU = 'Quality of the Vendor', ESP = 'Crear Versi�n';
                    Image = NewOrder;

                    trigger OnAction()
                    BEGIN
                        Rec.MODIFY;
                        Rec."Version No." := 0;
                        Rec.INSERT(TRUE);
                    END;


                }
                action("action10")
                {
                    CaptionML = ENU = 'Quality of the Vendor', ESP = 'Calidad del proveedor';
                    RunObject = Page 7207339;
                    RunPageLink = "Vendor No."= FIELD("Vendor No.");
                    Image = Signature;
                }

            }

        }
        area(Processing)
        {

            action("action11")
            {
                CaptionML = ENU = '&Issue request for Quote', ESP = 'Petici�n ofertas en conjunto';
                Image = Report;

                trigger OnAction()
                VAR
                    VendorConditionsData: Record 7207414;
                BEGIN
                    Print(TRUE, FALSE);
                END;


            }
            action("action12")
            {
                CaptionML = ENU = '&Issue request for Quote by Vendor', ESP = 'Petici�n ofertas por proveedor';
                Image = Report2;

                trigger OnAction()
                VAR
                    VendorConditionsData: Record 7207414;
                    VendorConditionsData2: Record 7207414;
                BEGIN
                    Print(FALSE, FALSE);
                END;


            }
            action("[ImportarExcel ]")
            {
                Image = ImportExcel;


                trigger OnAction()
                VAR
                    // ImportExcelComparative: Report 7207271;
                    VendorCondition: Record 7207414;
                BEGIN
                    // CLEAR(ImportExcelComparative);
                    VendorCondition.RESET;
                    VendorCondition.SETRANGE("Quote Code", rec."Quote Code");
                    VendorCondition.SETRANGE("Vendor No.", rec."Vendor No.");
                    // ImportExcelComparative.SETTABLEVIEW(VendorCondition);
                    // ImportExcelComparative.RUNMODAL;

                    //ImportExcelComparative.RUN;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
                actionref(CreateVersion_Promoted; CreateVersion)
                {
                }
                actionref(action10_Promoted; action10)
                {
                }
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action8_Promoted; action8)
                {
                }
            }
            group(Category_Report)
            {
                actionref(action11_Promoted; action11)
                {
                }
                actionref(action12_Promoted; action12)
                {
                }
                actionref("[ImportarExcel ]_Promoted"; "[ImportarExcel ]")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        verPaymentPhases := FunctionQB.AccessToPaymentPhases;

        //Q7357
        seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
        IF seeDragDrop THEN
            CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Vendor Conditions Data");
    END;

    trigger OnAfterGetRecord()
    BEGIN
        bSelected := rec."Selected Vendor";
        Rec.CALCFIELDS("Initial Estimated Total Amount", "Total Estimated Amount", "Total Target Amount", "Total Vendor Amount", "Other Conditions Amount");

        SetTotalStyle;
        SetEditable;

        //Q13150 -
        SetLineStyle;
        //Q13150 +
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //+Q8636
        IF seeDragDrop THEN BEGIN
            CurrPage.DropArea.PAGE.SetFilter(Rec);
            CurrPage.FilesSP.PAGE.SetFilter(Rec);
        END;
    END;



    var
        Vendor: Record 23;
        DataPricesVendor1: Record 7207415;
        DataPricesVendor2: Record 7207415;
        PurchasesPayablesSetup: Record 312;
        FunctionQB: Codeunit 7207272;
        bSelected: Boolean;
        TotalAmount: Decimal;
        TotalStyle: Text;
        verPaymentPhases: Boolean;
        actPayment: Boolean;
        VendorTemp: Record 23 TEMPORARY;
        Text001: TextConst ESP = 'El contacto ya est� relacionado con el proveedor %1, se actualiza';
        LineStyle: Text;
        i: Integer;
        seeDragDrop: Boolean;

    LOCAL procedure AsociateVendor(pCreate: Boolean): Boolean;
    var
        ContactBusinessRelation: Record 5054;
        Contact: Record 5050;
    begin
        if (rec."Vendor No." = '') and (rec."Contact No." <> '') then begin
            if Contact.GET(rec."Contact No.") then begin
                ContactBusinessRelation.RESET;
                ContactBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
                ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Vendor);
                ContactBusinessRelation.SETRANGE("Contact No.", rec."Contact No.");
                if (ContactBusinessRelation.FINDFIRST) then begin
                    MESSAGE(Text001, ContactBusinessRelation."No.");
                    SetVendorToContact(ContactBusinessRelation."No.");
                end ELSE begin
                    if (pCreate) then
                        Contact.CreateVendor
                    ELSE
                        Contact.CreateVendorLink;
                    if Vendor.GET(rec.RelationshipBusinessCreated) then
                        SetVendorToContact(Vendor."No.");
                end;
            end;
        end;
    end;

    LOCAL procedure SetVendorToContact(pVendorNo: Code[20]);
    var
        VendorConditionsData1: Record 7207414;
        VendorConditionsData2: Record 7207414;
    begin
        //JAV 29/04/21: - QB 1.08.41 Asociar el contacto con todas las versiones, no solo con la actual. Y lo hago para todos los comparativos, no solo para el actual
        //Cabeceras de precios del vendedor
        VendorConditionsData1.RESET;
        VendorConditionsData1.SETRANGE("Vendor No.", '');
        VendorConditionsData1.SETRANGE("Contact No.", rec."Contact No.");
        if (VendorConditionsData1.FINDSET) then
            repeat
                //Borro el registro de cabecera, a�ado el vendedor y lo vuelvo a crear, ya que es parte de la clave, as� es mas r�pido que renombrar
                VendorConditionsData1.DELETE(FALSE);

                VendorConditionsData2 := VendorConditionsData1;
                VendorConditionsData2."Vendor No." := pVendorNo;
                VendorConditionsData2.INSERT(TRUE);
            until (VendorConditionsData1.NEXT = 0);

        //L�neas de precios del vendedor
        DataPricesVendor1.RESET;
        DataPricesVendor1.SETRANGE("Quote Code", VendorConditionsData1."Quote Code");
        DataPricesVendor1.SETRANGE("Vendor No.", '');
        DataPricesVendor1.SETRANGE("Contact No.", VendorConditionsData1."Contact No.");
        if (DataPricesVendor1.FINDSET(TRUE)) then
            repeat
                //Borro las l�neas, a�ado el vendedor y lo vuelvo a crear, ya que es parte de la clave, as� es mas r�pido que renombrar
                DataPricesVendor1.DELETE;

                DataPricesVendor2 := DataPricesVendor1;
                DataPricesVendor2."Vendor No." := pVendorNo;
                if not DataPricesVendor2.INSERT then
                    DataPricesVendor2.MODIFY;
            until DataPricesVendor1.NEXT = 0;

        //Vuelvo a leer el registro actual
        Rec.GET(rec."Quote Code", pVendorNo, rec."Contact No.", rec."Version No.");
    end;

    LOCAL procedure SetEditable();
    begin
        actPayment := (rec."Payment Phases" = '');
    end;

    LOCAL procedure SetTotalStyle();
    begin
        //JAV 22/11/19: - Se calcula totalAmount con la suma de l�neas + otras condiciones si ha dado alg�n precio el proveedor
        Rec.CALCFIELDS("Lines whitout prices");

        if (rec."Total Vendor Amount" = 0) then
            TotalAmount := 0
        ELSE
            TotalAmount := rec."Total Vendor Amount" + rec."Other Conditions Amount";

        if (TotalAmount = 0) or (rec."Lines whitout prices") then
            TotalStyle := 'Subordinate'
        ELSE if (TotalAmount < rec."Total Target Amount") then
            TotalStyle := 'Favorable'
        ELSE if (TotalAmount < rec."Total Estimated Amount") then
            TotalStyle := 'StrongAccent'
        ELSE
            TotalStyle := 'UnFavorable';
    end;

    LOCAL procedure SetLineStyle();
    begin
        //Q13150 -
        CLEAR(LineStyle);
        Rec.CALCFIELDS("MAX Version");
        CASE TRUE OF
            rec."Selected Vendor":
                begin
                    LineStyle := 'Strong';
                    exit;
                end;
            rec."Version No." <> rec."MAX Version":
                LineStyle := 'Subordinate';
            rec."Version No." = rec."MAX Version":
                LineStyle := 'Standard';
        end;
        //Q13150 +
    end;

    LOCAL procedure Print(pUnified: Boolean; pExcel: Boolean);
    var
        VendorConditionsData: Record 7207414;
        VendorConditionsData2: Record 7207414;
        // QuoteRequestReport: Report 7207357;
    begin

        VendorConditionsData.RESET;
        VendorConditionsData.SETRANGE("Quote Code", rec."Quote Code");
        if VendorConditionsData.FINDSET(TRUE) then
            repeat
                VendorConditionsData.CALCFIELDS("MAX Version");
                if (VendorConditionsData."Version No." = VendorConditionsData."MAX Version") then
                    VendorConditionsData.MARK(TRUE);
            until VendorConditionsData.NEXT = 0;

        VendorConditionsData.MARKEDONLY(TRUE);

        //Si se imprimr unificado enviamos todos los registros al report, si no hay que imprimir uno a uno
        if (pUnified) then begin
            COMMIT;   //Por el runmodal
            // REPORT.RUNMODAL(REPORT::"Quote Request Report", TRUE, TRUE, VendorConditionsData);
        end ELSE begin
            if VendorConditionsData.FINDSET(TRUE) then
                repeat
                    VendorConditionsData2.RESET;
                    VendorConditionsData2.SETRANGE("Quote Code", VendorConditionsData."Quote Code");
                    VendorConditionsData2.SETRANGE("Vendor No.", VendorConditionsData."Vendor No.");
                    VendorConditionsData2.SETRANGE("Contact No.", VendorConditionsData."Contact No.");
                    VendorConditionsData2.SETRANGE("Version No.", VendorConditionsData."Version No.");

                    COMMIT;   //Por el runmodal
                    // CLEAR(QuoteRequestReport);
                    // QuoteRequestReport.SETTABLEVIEW(VendorConditionsData2);
                    // if (pExcel) then
                        // QuoteRequestReport.SAVEASEXCEL('c:\temp\a.xmlx')
                    // ELSE
                        // QuoteRequestReport.RUNMODAL;
                until VendorConditionsData.NEXT = 0;
        end;
    end;

    // begin
    /*{
      JAV 26/12/18: - Se a�ade un panel para los datos de proveedores para que as� se pueda ajustar la altura del panel
      PEL 13/02/19: - QPE6436 A�adido campo provincia
      JAV 09/07/19: - Se eliminan las variables vendorname y vendorcounty que no se utilizan, y sus columnas en la pantalla
                    - Se elimina la columna de vendedor relacionado, y se a�ade la de provincia del proveedor/contacto
      JAV 22/11/19: - Se hace no visible rec."Initial Estimated Total Amount" y se a�aden rec."Other Conditions Amount" y totalAmount con la suma de l�neas + otras condiciones
      Q13150 JDC 31/03/21 - Added field 24 "Version", 25 "MAX Version"
                            Added function "SetLineStyle".
                            Modified fields property "StyleExpr"
                            Modified PagePart "QuoteLinesbyVendor" property "SubPageLink"
      JAV 02/06/22: - QB 1.10.47 Para que se lance el control de contratos marco se refresca la p�gina al poner el proveedor
    }*///end
}







