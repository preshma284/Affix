page 7207340 "Vendor Certificates List"
{
    CaptionML = ENU = 'Vendor Certificates List', ESP = 'Lista de certificados del proveedor';
    SourceTable = 7207419;
    SourceTableView = SORTING("Vendor No.", "Certificate Code")
                    ORDER(Ascending);
    PageType = List;

    layout
    {
        area(content)
        {
            group("group6")
            {

                CaptionML = ESP = 'Proveedor';
                field("Vendor No."; rec."Vendor No.")
                {

                }
                field("Vendor.Name"; Vendor.Name)
                {

                }

            }
            repeater("Group")
            {

                field("Certificate Line No."; rec."Certificate Line No.")
                {

                    Visible = False;
                    StyleExpr = stLine;
                }
                field("Certificate Code"; rec."Certificate Code")
                {

                    StyleExpr = stLine;

                    ; trigger OnValidate()
                    BEGIN
                        GetType;
                    END;


                }
                field("VendorCertificatesTypes.Description"; VendorCertificatesTypes.Description)
                {

                    CaptionML = ESP = 'Descripci�n certificado';
                    Editable = false;
                    StyleExpr = stLine;
                }
                field("VendorCertificatesTypes.Type of Certificate"; VendorCertificatesTypes."Type of Certificate")
                {

                    CaptionML = ENU = 'Type Certificate', ESP = 'Tipo certificado';
                    Editable = false;
                    StyleExpr = stLine;
                }
                field("Active From"; rec."Active From")
                {

                    StyleExpr = stLine;
                }
                field("Active To"; rec."Active To")
                {

                    StyleExpr = stLine;
                }
                field("Required"; rec."Required")
                {

                    StyleExpr = stLine;
                }
                field("Lines No."; rec."Lines No.")
                {

                    StyleExpr = stLine;
                }
                field("Valid"; Valid)
                {

                    CaptionML = ENU = 'Valid', ESP = 'En vigor';
                    StyleExpr = stLine;
                }
                field("DateInit"; DateInit)
                {

                    CaptionML = ESP = 'Fecha inicio Validez';
                    Editable = false;
                    StyleExpr = stLine;
                }
                field("DateEnd"; DateEnd)
                {

                    CaptionML = ESP = 'Fecha fin Validez';
                    Editable = false;
                    StyleExpr = stLine;
                }
                field("Job No."; rec."Job No.")
                {

                    StyleExpr = stLine;
                }
                field("Activity Code"; rec."Activity Code")
                {

                    StyleExpr = stLine;
                }
                field("Activity Description"; rec."Activity Description")
                {

                    StyleExpr = stLine;
                }
                field("Entity Certification"; rec."Entity Certification")
                {

                    StyleExpr = stLine;
                }
                field("Certificate No."; rec."Certificate No.")
                {

                    StyleExpr = stLine;
                }
                field("Level of Implementation"; rec."Level of Implementation")
                {

                    StyleExpr = stLine;
                }
                field("Reference Standard"; rec."Reference Standard")
                {

                    StyleExpr = stLine;
                }
                field("Other Reference Standards"; rec."Other Reference Standards")
                {

                    StyleExpr = stLine;
                }

            }

        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ESP = 'Evaluaciones';
                // ActionContainerType =ActionItems ;

            }
            action("action1")
            {
                CaptionML = ENU = '&Certifications', ESP = 'Historial';
                Image = CheckLedger;

                trigger OnAction()
                VAR
                    VendorCertificatesHistory: Record 7207426;
                    VendorCertificatesHistList: Page 7207564;
                BEGIN
                    VendorCertificatesHistory.RESET;
                    VendorCertificatesHistory.SETRANGE("Vendor No.", rec."Vendor No.");
                    VendorCertificatesHistory.SETRANGE("Certificate Line No.", rec."Certificate Line No.");
                    CLEAR(VendorCertificatesHistList);
                    VendorCertificatesHistList.SETTABLEVIEW(VendorCertificatesHistory);
                    VendorCertificatesHistList.RUNMODAL;
                    CurrPage.UPDATE;
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Load Template', ESP = 'Cargar Plantilla';
                Image = Template;


                trigger OnAction()
                VAR
                    VendorCertificatesTemplates: Record 7207428;
                    // LoadVendCertTemplate: Report 7207373;
                BEGIN
                    // CLEAR(LoadVendCertTemplate);
                    // LoadVendCertTemplate.SetVendor(rec."Vendor No.");
                    // LoadVendCertTemplate.RUNMODAL;
                    CurrPage.UPDATE;
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
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        IF NOT Vendor.GET(rec."Vendor No.") THEN
            Vendor.INIT;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        GetType;
        funOnAfterGetRecord;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        funOnAfterGetRecord;
    END;



    var
        Vendor: Record 23;
        VendorCertificatesTypes: Record 7207427;
        DateInit: Date;
        DateEnd: Date;
        Valid: Boolean;
        Template: Code[10];
        stLine: Text;

    LOCAL procedure GetType();
    begin
        if not VendorCertificatesTypes.GET(rec."Certificate Code") then
            VendorCertificatesTypes.INIT;
        Valid := rec.IsValid(TODAY, DateInit, DateEnd);
    end;

    LOCAL procedure funOnAfterGetRecord();
    begin
        if (not rec.Required) then
            stLine := 'Standar'
        ELSE if (Valid) then
            stLine := 'Favorable'
        ELSE
            stLine := 'Unfavorable';
    end;

    // begin//end
}







