page 7207339 "Vendor Quality Data List"
{
    CaptionML = ENU = 'Vendor Quality Data List', ESP = 'Lista datos calidad proveedor';
    SourceTable = 7207418;
    PageType = List;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group12")
            {

                CaptionML = ESP = 'Proveedor';
                Visible = seeVendorGroup;
                field("Vendor No."; rec."Vendor No.")
                {

                    Editable = FALSE;
                }
                field("Vendor.Name"; Vendor.Name)
                {

                    Editable = FALSE;
                }
                field("No. of Evaluations Total"; rec."No. of Evaluations Total")
                {

                }
                field("No. of Conditions"; rec."No. of Conditions")
                {

                }
                field("No. of Certificates"; rec."No. of Certificates")
                {

                }

            }
            repeater("Group")
            {

                field("VendorNoLine"; rec."Vendor No.")
                {

                    Visible = seeVendor;
                }
                field("VendorNameLine"; Vendor.Name)
                {

                    Visible = seeVendor;
                    Editable = FALSE;
                }
                field("Activity Code"; rec."Activity Code")
                {

                }
                field("Activity Description"; rec."Activity Description")
                {

                }
                field("Main Activity"; rec."Main Activity")
                {

                }
                field("Comparative Blocked"; rec."Comparative Blocked")
                {

                }
                field("Operation Counties"; rec."Operation Counties")
                {


                    ; trigger OnAssistEdit()
                    VAR
                        QBPageSubscriber: Codeunit 7207349;
                    BEGIN
                        //QUONEXT PER 05.06.19: - Elecnor, assist edit del campo de provincias en las que opera
                        QBPageSubscriber.GetOperationCounties(rec."Operation Counties");
                        Rec.VALIDATE(rec."Operation Counties");
                    END;


                }
                field("Operation Countries"; rec."Operation Countries")
                {


                    ; trigger OnAssistEdit()
                    VAR
                        QBPageSubscriber: Codeunit 7207349;
                    BEGIN
                        //QUONEXT PER 05.06.19: - Elecnor, assist edit del campo de paises en los que opera
                        QBPageSubscriber.GetOperationCountries(rec."Operation Countries");
                        Rec.VALIDATE(rec."Operation Countries");
                    END;


                }
                field("Comment"; rec."Comment")
                {

                }
                field("Punctuation end"; rec."Punctuation end")
                {

                }
                field("Clasification end"; rec."Clasification end")
                {

                }
                field("No. of Evaluations"; rec."No. of Evaluations")
                {

                }
                field("Evaluations Average Rating"; rec."Evaluations Average Rating")
                {

                }
                field("Average Clasification"; rec."Average Clasification")
                {

                }
                field("Last Evaluation Date"; rec."Last Evaluation Date")
                {

                }
                field("Last Evaluation Observations"; rec."Last Evaluation Observations")
                {

                }
                field("Date Last Reviews"; rec."Date Last Reviews")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Review Score"; rec."Review Score")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Comments Latest Reviews"; rec."Comments Latest Reviews")
                {


                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207487)
            {
                SubPageLink = "Vendor No." = FIELD("Vendor No."), "Activity Code" = FIELD("Activity Code");
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
                action("action1")
                {
                    CaptionML = ESP = 'Evaluaciones';
                    RunObject = Page 7207568;
                    RunPageLink = "Vendor No." = FIELD("Vendor No.");
                    Image = CalculateLines;

                    trigger OnAction()
                    VAR
                        VendorEvaluationList: Page 7207568;
                        VendorEvaluationHeader: Record 7207424;
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = '&Evaluations', ESP = '&Eval. por Actividad';
                    RunObject = Page 7207569;
                    RunPageView = SORTING("Evaluation No.", "Activity Code");
                    RunPageLink = "Vendor No." = FIELD("Vendor No."), "Activity Code" = FIELD("Activity Code");
                    Image = Calculate;
                }

            }
            group("group5")
            {
                CaptionML = ENU = 'Quality Card', ESP = 'Condiciones';
                action("action3")
                {
                    CaptionML = ENU = '&Conditions', ESP = 'Condiciones';
                    Image = BinContent;

                    trigger OnAction()
                    BEGIN
                        //Ver las condiciones del proveedor
                        ConditionsVendor.RESET;
                        ConditionsVendor.SETRANGE("Vendor No.", rec."Vendor No.");

                        CLEAR(ConditionsVendorCard);
                        ConditionsVendorCard.SETTABLEVIEW(ConditionsVendor);
                        ConditionsVendorCard.RUNMODAL;
                        Rec.CALCFIELDS("No. of Conditions");
                    END;


                }

            }
            group("group7")
            {
                CaptionML = ENU = '&Vendor', ESP = 'Certificados';
                action("action4")
                {
                    CaptionML = ENU = '&Certifications', ESP = 'Certificados';
                    RunObject = Page 7207340;
                    RunPageLink = "Vendor No." = FIELD("Vendor No.");
                    Image = CheckLedger;
                }

            }
            group("group9")
            {
                CaptionML = ENU = 'Quality Card', ESP = 'Ficha de calidad';
                action("action5")
                {
                    CaptionML = ENU = 'Quality Card', ESP = 'Ficha de calidad';
                    Image = QualificationOverview;


                    trigger OnAction()
                    VAR
                        VendorQltyData: Record 7207418;
                        // VendorSubcontCard: Report 7207361;
                    BEGIN
                        VendorQltyData.RESET;
                        VendorQltyData.SETRANGE("Vendor No.", rec."Vendor No.");
                        VendorQltyData.SETRANGE("Activity Code", rec."Activity Code");
                        IF VendorQltyData.FINDFIRST THEN BEGIN
                            // VendorSubcontCard.SETTABLEVIEW(VendorQltyData);
                            // VendorSubcontCard.RUNMODAL;
                            CLEAR(VendorQltyData);
                        END;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = 'New', ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Evaluations', ESP = 'Evaluaciones';

                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Consitions', ESP = 'Condiciones';

                actionref(action3_Promoted; action3)
                {
                }
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Certificates', ESP = 'Certificados';

                actionref(action4_Promoted; action4)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        seeVendor := CurrPage.LOOKUPMODE;
        seeVendorGroup := (NOT CurrPage.LOOKUPMODE);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        IF NOT Vendor.GET(rec."Vendor No.") THEN
            Vendor.INIT;
    END;



    var
        Vendor: Record 23;
        ConditionsVendorCard: Page 7207341;
        ConditionsVendor: Record 7207420;
        seeVendorGroup: Boolean;
        seeVendor: Boolean;/*

    

begin
    {
      PGM 19/07/19: - GAP003 Kalam A�adido el campo rec."Main Activity"
      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c�lculo de las puntuaciones de las mismas
      JAV 06/11/19: - Se elimina la acci�n "Ficha de calidad Evaluaci�n" pues estaba duplicada y no imprime nada razonable
    }
    end.*/


}







