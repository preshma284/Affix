page 7207579 "Select Vendor to Compare"
{
    CaptionML = ENU = 'Select Vendor to Compare', ESP = 'Selecciona Proveedor para comparativo';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207429;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            field("QuoteNo"; QuoteNo)
            {

                CaptionML = ESP = 'Oferta';
                Editable = FALSE;
            }
            field("ActivityFilter"; ActivityFilter)
            {

                CaptionML = ESP = 'Filtro de Actividades';
                TableRelation = "Activity QB"."Activity Code";
                Style = StrongAccent;
                StyleExpr = TRUE;

                ; trigger OnValidate()
                BEGIN
                    AddVendorsToList;
                    CurrPage.UPDATE(FALSE);
                END;


            }
            field("Job.No."; Job."No.")
            {

                CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
                Editable = FALSE;
            }
            field("JobUbicacion"; JobUbicacion)
            {

                CaptionML = ENU = 'Job No.', ESP = 'Ubicaci�n del proyecto';
                Editable = FALSE;
            }
            repeater("Group")
            {

                field("Selected"; rec."Selected")
                {

                }
                field("Vendor No."; rec."Vendor No.")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Contact No."; rec."Contact No.")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Ambito actividad"; rec."Ambito actividad")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Vendor Name"; rec."Vendor Name")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Vendor City"; rec."Vendor City")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("County"; rec."County")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Operation Counties"; rec."Operation Counties")
                {

                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {

                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Operation Countries"; rec."Operation Countries")
                {

                    Editable = FALSE;
                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Comparative Blocked"; rec."Comparative Blocked")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Comment"; rec."Comment")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Evaluation Global"; rec."Evaluation Global")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Clasification Global"; rec."Clasification Global")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Evaluation Activity"; rec."Evaluation Activity")
                {

                    Style = Strong;
                    StyleExpr = stNegrita;
                }
                field("Clasification Activity"; rec."Clasification Activity")
                {

                    Style = Strong;
                    StyleExpr = stNegrita

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
                CaptionML = ENU = 'Select Yes / No', ESP = 'Seleccionar Si/No';
                Image = Confirm;

                trigger OnAction()
                VAR
                    Rec2: Record 7207429;
                BEGIN
                    CurrPage.SETSELECTIONFILTER(Rec2);
                    IF Rec2.FINDSET THEN
                        REPEAT
                            Rec2.Selected := NOT Rec2.Selected;
                            Rec2.MODIFY;
                        UNTIL Rec2.NEXT = 0;
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Generate', ESP = 'Generar';
                Visible = false;
                Image = CreateMovement;

                trigger OnAction()
                BEGIN
                    Generate;
                    CurrPage.CLOSE;
                END;


            }
            action("action3")
            {
                CaptionML = ENU = 'Create Contact', ESP = 'Crear Contacto';
                Image = AddContacts;

                trigger OnAction()
                VAR
                    codContact: Code[20];
                BEGIN
                    //JAV 25/07/19: - Cuando creas un contacto, a�adirlo a la pantalla
                    codContact := rec.CreateContact(QuoteNo);
                    IF (codContact <> '') THEN BEGIN
                        Contact.GET(codContact);
                        Rec.INIT;
                        rec."Quote No." := QuoteNo;
                        rec."Vendor No." := '';
                        rec."Contact No." := codContact;
                        rec."Activity Code" := Contact."Activity Filter";
                        rec."Vendor Name" := Contact.Name;
                        rec."Vendor City" := Contact.City;
                        rec."Ambito actividad" := Contact."Area Activity";
                        rec.Selected := TRUE;   //Se marca para a�adirlo por defecto
                        IF Rec.INSERT THEN;
                    END;
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
                    //JAV 21/05/19: - Ir la ficha del proveedor o a la del contacto
                    IF rec."Vendor No." <> '' THEN BEGIN
                        Vendor.RESET;
                        Vendor.SETRANGE("No.", Rec."Vendor No.");
                        CLEAR(VendorCard);
                        VendorCard.SETTABLEVIEW(Vendor);
                        VendorCard.RUNMODAL;
                    END ELSE BEGIN
                        Contact.RESET;
                        Contact.SETRANGE("No.", Rec."Contact No.");
                        CLEAR(ContactCard);
                        ContactCard.SETTABLEVIEW(Contact);
                        ContactCard.RUNMODAL;
                    END;
                    //JAV fin
                END;


            }
            action("OnlyCountryVendor")
            {

                CaptionML = ENU = 'Only Local Vendors', ESP = 'Ver Prov. del Pa�s';
                Enabled = actVendor1;
                Image = FilterLines;

                trigger OnAction()
                VAR
                    ComparativeQuoteHeader: Record 7207412;
                    Job: Record 167;
                BEGIN
                    OnlyCountryVendor_;
                END;


            }
            action("OnlyWorkingCountryVendor")
            {

                CaptionML = ENU = 'General Vendors', ESP = 'Ver Prov. trabajan en el Pa�s';
                Enabled = actVendor2;
                Image = FilterLines;

                trigger OnAction()
                VAR
                    ComparativeQuoteHeader: Record 7207412;
                    Job: Record 167;
                BEGIN
                    OnlyWorkingCountryVendor_;
                END;


            }
            action("OnlyLocalVendor")
            {

                CaptionML = ENU = 'Only Local Vendors', ESP = 'Ver Prov. de la Provincia';
                Enabled = actVendor3;
                Image = FilterLines;

                trigger OnAction()
                VAR
                    ComparativeQuoteHeader: Record 7207412;
                    Job: Record 167;
                BEGIN
                    OnlyLocalVendor_;
                END;


            }
            action("OnlyWorkingLocalVendor")
            {

                CaptionML = ENU = 'General Vendors', ESP = 'Ver Prov. trabajan en la Provincia';
                Enabled = actVendor4;
                Image = FilterLines;

                trigger OnAction()
                VAR
                    ComparativeQuoteHeader: Record 7207412;
                    Job: Record 167;
                BEGIN
                    OnlyWorkingLocalVendor_;
                END;


            }
            action("AnyVendor")
            {

                CaptionML = ENU = 'Any Vendor', ESP = 'Ver Cualquier proveedor';
                Enabled = actVendor5;
                Image = FilterLines;


                trigger OnAction()
                BEGIN
                    AnyVendor_;
                END;


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
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(OnlyCountryVendor_Promoted; OnlyCountryVendor)
                {
                }
                actionref(OnlyWorkingCountryVendor_Promoted; OnlyWorkingCountryVendor)
                {
                }
                actionref(OnlyLocalVendor_Promoted; OnlyLocalVendor)
                {
                }
                actionref(OnlyWorkingLocalVendor_Promoted; OnlyWorkingLocalVendor)
                {
                }
                actionref(AnyVendor_Promoted; AnyVendor)
                {
                }
            }
        }
    }
    trigger OnInit()
    BEGIN
        CurrPage.LOOKUPMODE := FALSE;
    END;

    trigger OnOpenPage()
    BEGIN
        IF (Rec.GETFILTER("Quote No.") = '') OR (Rec.GETRANGEMIN("Quote No.") <> Rec.GETRANGEMAX("Quote No.")) THEN
            ERROR(Text002);
        QuoteNo := Rec.GETFILTER("Quote No.");
        ComparativeQuoteHeader.GET(QuoteNo);
        Job.GET(ComparativeQuoteHeader."Job No.");
        ActivityFilter := ComparativeQuoteHeader."Activity Filter";
        CountyFilter := UPPERCASE(Job."Job Province");
        CountryFilter := UPPERCASE(Job."Job Country/Region Code");
        IF (CountryFilter = '') THEN BEGIN
            CompanyInformation.GET();
            CountryFilter := CompanyInformation."Country/Region Code";
        END;
        JobUbicacion := Job."Job City" + ' (' + CountyFilter + ') ' + CountryFilter;

        //JAV: - Se pasa el c�digo para a�adir proveedores a una funci�n
        AddVendorsToList;
        //JAV 12/11/19: - Se a�aden los preseleccionados a la lista
        AddPreselectedVendors;

        //Ver todos los proveedores posibles por defecto
        AnyVendor_;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        //JAV 10/08/19: - Se ponen en negrita los que ya est�n en el comparativo
        VendorConditionsData.RESET;
        VendorConditionsData.SETRANGE("Quote Code", rec."Quote No.");
        IF (rec."Vendor No." <> '') THEN
            VendorConditionsData.SETRANGE("Vendor No.", rec."Vendor No.")
        ELSE IF (rec."Contact No." <> '') THEN
            VendorConditionsData.SETRANGE("Contact No.", rec."Contact No.");
        //Si no est� vacio, es que el proveedor est� en el comparativo
        stNegrita := (NOT VendorConditionsData.ISEMPTY);
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        IF (CloseAction = ACTION::LookupOK) THEN
            Generate();
    END;



    var
        Vendor: Record 23;
        ComparativeQuoteHeader: Record 7207412;
        ConditionsVendor: Record 7207420;
        ContactActivitiesQB: Record 7207430;
        Contact: Record 5050;
        ContactBusinessRelation: Record 5054;
        VendorConditionsData: Record 7207414;
        CompanyInformation: Record 79;
        ActivityQB: Record 7207280;
        QuoteNo: Code[20];
        ActivityFilter: Text;
        Text002: TextConst ENU = 'This process must be executed for a single comparison. \ Check the filters', ESP = 'Este proceso debe ser ejecutado para una sola comparaci�n.\Revise los filtros';
        CountyFilter: Text;
        CountryFilter: Text;
        stNegrita: Boolean;
        Job: Record 167;
        JobUbicacion: Text;
        actVendor1: Boolean;
        actVendor2: Boolean;
        actVendor3: Boolean;
        actVendor4: Boolean;
        actVendor5: Boolean;

    procedure AddVendorsToList();
    var
        VendorQualityData: Record 7207418;
        VendorConditionsData: Record 7207414;
    begin
        Rec.DELETEALL;

        //A�adir vendedores
        VendorQualityData.RESET;
        if (ActivityFilter <> '') then
            VendorQualityData.SETFILTER("Activity Code", ActivityFilter);
        if VendorQualityData.FINDSET(FALSE) then
            repeat
                AddOneVendor(VendorQualityData."Vendor No.");
            until VendorQualityData.NEXT = 0;

        //A�adir contactos
        ContactActivitiesQB.RESET;
        if ComparativeQuoteHeader."Activity Filter" <> '' then
            ContactActivitiesQB.SETFILTER("Activity Code", ComparativeQuoteHeader."Activity Filter");
        if ContactActivitiesQB.FINDSET(FALSE) then
            repeat
                if Contact.GET(ContactActivitiesQB."Contact No.") then begin
                    ContactBusinessRelation.SETRANGE("Contact No.", Contact."No.");
                    ContactBusinessRelation.SETRANGE("Link to Table", ContactBusinessRelation."Link to Table"::Vendor);
                    ContactBusinessRelation.SETFILTER("No.", '<>%1', '');
                    if not ContactBusinessRelation.FINDSET then begin
                        if Contact.Type = Contact.Type::Company then begin
                            //JAV 07/11/22: QB 1.12.15 Buscar las actividades de otra manera para evitar errores de desbordamiento
                            ActivityQB.RESET;
                            ActivityQB.SETFILTER("Activity Code", ActivityFilter);
                            if (not ActivityQB.FINDFIRST) then
                                ActivityQB.INIT;

                            Rec.INIT;
                            rec."Quote No." := QuoteNo;
                            rec."Activity Code" := ActivityQB."Activity Code";    //JAV 07/11/22: QB 1.12.15 Buscar las actividades de otra manera para evitar errores de desbordamiento, pongo solo la primera del filtro
                            rec."Vendor No." := '';
                            rec."Contact No." := ContactActivitiesQB."Contact No.";
                            rec."Vendor Name" := Contact.Name;
                            rec."Vendor City" := Contact.City;
                            rec."Ambito actividad" := Contact."Area Activity";
                            if Rec.INSERT then;
                        end;
                    end;
                end;
            until ContactActivitiesQB.NEXT = 0;
    end;

    LOCAL procedure AddPreselectedVendors();
    var
        ComparativeQuoteLines: Record 7207413;
        Vendor: Record 23;
    begin
        //QCPM_GAP06 >>
        //JAV 12/11/19: - Solo si tiene un preseleccionado se a�ade a la lista de proveedores del comparativo, pues si no crea registros en blanco
        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", rec."Quote No.");
        ComparativeQuoteLines.SETFILTER("Activity Code", ComparativeQuoteHeader."Activity Filter");
        ComparativeQuoteLines.SETFILTER("Preselected Vendor", '<>%1', '');
        if ComparativeQuoteLines.FINDSET(FALSE) then begin
            repeat
                if Vendor.GET(ComparativeQuoteLines."Preselected Vendor") then begin
                    Rec.INIT;
                    Rec."Quote No." := ComparativeQuoteLines."Quote No.";
                    Rec."Activity Code" := ComparativeQuoteLines."Activity Code";
                    Rec."Vendor No." := ComparativeQuoteLines."Preselected Vendor";
                    Rec."Contact No." := Vendor."Primary Contact No.";
                    Rec."Vendor Name" := Vendor.Name;
                    Rec.Selected := TRUE;
                    if Rec.INSERT then;
                end;
            until ComparativeQuoteLines.NEXT = 0;
        end;
        //QCPM_GAP06 <<
    end;

    LOCAL procedure AddOneVendor(pVendor: Code[20]);
    var
        VendorQualityData: Record 7207418;
    begin
        if Vendor.GET(pVendor) then begin
            //JAV 07/11/22: QB 1.12.15 Buscar las actividades de otra manera para evitar errores de desbordamiento
            //if not VendorQualityData.GET(rec.pVendor,rec. ActivityFilter) then
            //  VendorQualityData.INIT;
            VendorQualityData.RESET;
            VendorQualityData.SETRANGE("Vendor No.", pVendor);
            VendorQualityData.SETFILTER("Activity Code", ActivityFilter);
            if (not VendorQualityData.FINDFIRST) then
                VendorQualityData.INIT;


            Rec.INIT;
            rec."Quote No." := QuoteNo;
            //"Activity Code" := ActivityFilter;
            rec."Activity Code" := VendorQualityData."Activity Code";
            rec."Vendor No." := Vendor."No.";
            rec."Contact No." := Vendor."Primary Contact No.";
            rec."Vendor Name" := Vendor.Name;
            rec."Vendor City" := Vendor.City;

            //JAV 21/05/19: - Se a�aden bloqueo y comentarios
            rec."Comparative Blocked" := VendorQualityData."Comparative Blocked";
            rec.Comment := VendorQualityData.Comment;

            //Multidivisas, paises en que opera GEN001-05
            rec.County := Vendor.County;
            rec."Country/Region Code" := Vendor."Country/Region Code";

            if (VendorQualityData."Operation Counties" <> '') then
                rec."Operation Counties" := SetVendorFilter(Vendor.County, VendorQualityData."Operation Counties")
            ELSE
                rec."Operation Counties" := SetVendorFilter(Vendor.County, Vendor."QB Operation Counties");

            if (VendorQualityData."Operation Countries" <> '') then
                rec."Operation Countries" := SetVendorFilter(Vendor."Country/Region Code", VendorQualityData."Operation Countries")
            ELSE
                rec."Operation Countries" := SetVendorFilter(Vendor."Country/Region Code", Vendor."QB Operation Countries");

            rec."Operation Counties" := UPPERCASE(rec."Operation Counties");
            rec."Operation Countries" := UPPERCASE(rec."Operation Countries");
            //GEN001-05

            //JAV 14/08/20: - Se a�aden las evaluaciones de calidad
            VendorQualityData.CALCFIELDS("Total Average Punctuation");
            Rec.VALIDATE("Evaluation Activity", VendorQualityData."Punctuation end");
            Rec.VALIDATE("Evaluation Global", VendorQualityData."Total Average Punctuation");

            if Rec.INSERT then;
        end;
    end;

    LOCAL procedure SetVendorFilter(pLocal: Text; pFiltro: Text): Text;
    begin
        if (STRPOS(UPPERCASE(pFiltro), UPPERCASE(pLocal)) > 0) then
            exit(pFiltro);
        if (pFiltro = '') then
            exit(pLocal);
        exit(pLocal + '|' + pFiltro);
    end;

    LOCAL procedure OnlyCountryVendor_();
    begin
        //GEN001-05
        Rec.SETRANGE(County);
        Rec.SETRANGE("Operation Counties");
        Rec.SETRANGE("Country/Region Code", CountryFilter);
        Rec.SETRANGE("Operation Countries");
        actVendor1 := FALSE;
        actVendor2 := TRUE;
        actVendor3 := TRUE;
        actVendor4 := TRUE;
        actVendor5 := TRUE;
    end;

    LOCAL procedure OnlyWorkingCountryVendor_();
    begin
        //GEN001-05
        Rec.SETRANGE(County);
        Rec.SETRANGE("Operation Counties");
        Rec.SETRANGE("Country/Region Code");
        Rec.SETFILTER("Operation Countries", '@*' + CountryFilter + '*');
        actVendor1 := TRUE;
        actVendor2 := FALSE;
        actVendor3 := TRUE;
        actVendor4 := TRUE;
        actVendor5 := TRUE;
    end;

    LOCAL procedure OnlyLocalVendor_();
    begin
        //GEN001-05
        Rec.SETRANGE(County, CountyFilter);
        Rec.SETRANGE("Operation Counties");
        Rec.SETRANGE("Country/Region Code");
        Rec.SETRANGE("Operation Countries");
        actVendor1 := TRUE;
        actVendor2 := TRUE;
        actVendor3 := FALSE;
        actVendor4 := TRUE;
        actVendor5 := TRUE;
    end;

    LOCAL procedure OnlyWorkingLocalVendor_();
    begin
        //GEN001-05
        Rec.SETRANGE(County);
        Rec.SETFILTER("Operation Counties", '@*' + CountyFilter + '*');
        Rec.SETRANGE("Country/Region Code");
        Rec.SETRANGE("Operation Countries");
        actVendor1 := TRUE;
        actVendor2 := TRUE;
        actVendor3 := TRUE;
        actVendor4 := FALSE;
        actVendor5 := TRUE;
    end;

    LOCAL procedure AnyVendor_();
    begin
        //GEN001-05
        Rec.SETRANGE(County);
        Rec.SETRANGE("Operation Counties");
        Rec.SETRANGE("Country/Region Code");
        Rec.SETRANGE("Operation Countries");
        actVendor1 := TRUE;
        actVendor2 := TRUE;
        actVendor3 := TRUE;
        actVendor4 := TRUE;
        actVendor5 := FALSE;
    end;

    LOCAL procedure Generate();
    var
        txt001: TextConst ESP = 'El proveedor %1 est� boqueado para comparativos, no se incluir� este proveedor.';
        recRecurso: Record 156;
        recProducto: Record 27;
        SelectedVendorsQuote: Record 7207429;
        eliminar: Boolean;
    begin
        //QCPM_GAP06 - A�adir vendedor asociado a la U.O.
        AddPreselectedVendors;

        //JAV 26/12/18 - Desmarcar de la lista los proveedores que ya est�n en el comparativo
        //JAV 21/05/19 - Controlar si esta bloqueado para comparativos
        SelectedVendorsQuote.RESET;
        SelectedVendorsQuote.SETRANGE("Quote No.", rec."Quote No.");
        SelectedVendorsQuote.SETRANGE("Activity Code", rec."Activity Code");
        SelectedVendorsQuote.SETRANGE(Selected, TRUE);
        if SelectedVendorsQuote.FINDSET then
            repeat
                VendorConditionsData.RESET;
                VendorConditionsData.SETRANGE("Quote Code", SelectedVendorsQuote."Quote No.");
                //VendorConditionsData.SETFILTER("Activity Code", SelectedVendorsQuote."Activity Code");
                if (SelectedVendorsQuote."Vendor No." <> '') then
                    VendorConditionsData.SETRANGE("Vendor No.", SelectedVendorsQuote."Vendor No.");
                if (SelectedVendorsQuote."Contact No." <> '') then
                    VendorConditionsData.SETRANGE("Contact No.", SelectedVendorsQuote."Contact No.");
                //Si no est� vacio, es que el proveedor est� en el comparativo y no hay que generarlo
                eliminar := (not VendorConditionsData.ISEMPTY);

                //Si est� bloqueado, no se generar� tampoco
                if (SelectedVendorsQuote."Comparative Blocked") then begin
                    MESSAGE(txt001, SelectedVendorsQuote."Vendor No.");
                    eliminar := TRUE;
                end;

                //Si no hay que generarlo, lo desmarco
                if (eliminar) then begin
                    Rec.GET(SelectedVendorsQuote."Quote No.", SelectedVendorsQuote."Vendor No.", SelectedVendorsQuote."Contact No.", SelectedVendorsQuote."Activity Code");
                    Rec.Selected := FALSE;
                    Rec.MODIFY;
                end;
            until SelectedVendorsQuote.NEXT = 0;
        //JAV 26/12/18 - fin

        rec.GenerateComparative(QuoteNo, ActivityFilter);
        //CurrPage.CLOSE;
    end;

    // begin
    /*{
      JAV 26/12/18: - Se a�ade el icono al bot�n de crear contacto, y se promociona a procesos
                    - Desmarcar de la lista los proveedores que ya est�n en el comparativo
      PGR 08/05/19: - QCPM_GAP06 Traer proveedor por defecto del descompuesto
      JAV 21/05/19: - Ir la ficha del proveedor o a la del contacto
                    - Mostrar campo de motivo del bloqueo en los comparativos
                    - Se a�ade bloqueo y comentarios en la pantalla y su carga
                    - Se unifica la carga de los datos con una sola funci�n, en lugar de usar dos iguales
      JAV 25/07/19: - Cuando creas un contacto, a�adirlo a la pantalla
      JAV 10/08/19: - Se ponen en negrita los que ya est�n en el comparativo
      JAV 12/11/19: - Se a�aden los preseleccionados a la lista
      JAV 07/11/22: - QB 1.12.15 Buscar las actividades de otra manera para evitar errores de desbordamiento
    }*///end
}







