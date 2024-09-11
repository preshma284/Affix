page 7207400 "Withholding Movements"
{
    CaptionML = ENU = 'Withholding Movements', ESP = 'Movs. Retenciones';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207329;
    SourceTableView = SORTING("Entry No.");
    DataCaptionFields = "No.";
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Type"; rec."Type")
                {

                }
                field("No."; rec."No.")
                {

                }
                field("Account Name"; rec."Account Name")
                {

                }
                field("Withholding Code"; rec."Withholding Code")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Document Date"; rec."Document Date")
                {

                }
                field("Document Type"; rec."Document Type")
                {

                }
                field("Document No."; rec."Document No.")
                {

                }
                field("External Document No."; rec."External Document No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                }
                field("Withholding Type"; rec."Withholding Type")
                {

                }
                field("Currency Code"; rec."Currency Code")
                {

                }
                field("Withholding Base"; rec."Withholding Base")
                {

                }
                field("Withholding Base (LCY)"; rec."Withholding Base (LCY)")
                {

                    Visible = false;
                }
                field("Withholding %"; rec."Withholding %")
                {

                }
                field("Amount"; rec."Amount")
                {

                }
                field("Amount (LCY)"; rec."Amount (LCY)")
                {

                    Visible = false;
                }
                field("Due Date"; rec."Due Date")
                {

                }
                field("QB_PaymentBankNo"; rec."QB Payment bank No.")
                {

                    Editable = false;
                }
                field("QB_PaymentBankName"; FunctionQB.GetBankName(rec."QB Payment bank No."))
                {

                    CaptionML = ENU = 'Own Bank Name', ESP = 'Nombre del banco propio';
                    Enabled = false;
                }
                field("Open"; rec."Open")
                {

                }
                field("User ID"; rec."User ID")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                }
                field("Withholding treating"; rec."Withholding treating")
                {

                }
                field("Release Date"; rec."Release Date")
                {

                }
                field("Released-to Document No."; rec."Released-to Document No.")
                {

                }
                field("Applies-to ID"; rec."Applies-to ID")
                {

                }
                field("Released-to Movement No."; rec."Released-to Movement No.")
                {

                }
                field("Entry No."; rec."Entry No.")
                {

                }
                field("QB_Unpaid"; rec."QB_Unpaid")
                {

                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("<Action53>")
            {

                CaptionML = ENU = 'Ent&ry', ESP = '&Movimiento';
                action("<Action3>")
                {

                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }

            }
            group("group4")
            {
                CaptionML = ENU = '&Application', ESP = 'Procesar';
                action("<Action36>")
                {

                    CaptionML = ENU = 'Release Withholding', ESP = 'Liberar retenci�n';
                    Enabled = bLiberar;
                    Image = MakeAgreement;

                    trigger OnAction()
                    VAR
                        Text000: TextConst ESP = 'Confirme que desea liberar %1 retenciones.';
                        Text001: TextConst ENU = 'Releasing Whithholding/s... \1#######', ESP = 'Liberando retenci�n 1#######';
                        Window: Dialog;
                        total: Integer;
                        read: Integer;
                        liq: Integer;
                        inv: Integer;
                        r: Boolean;
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(WithholdingMovements);
                        cduWithholdingtreating.FunReleaseWitholding(WithholdingMovements);
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Defer Withholding', ESP = 'Fraccionar retenci�n';
                    Enabled = bLiberar;
                    Image = Splitlines;

                    trigger OnAction()
                    BEGIN
                        CLEAR(cduWithholdingtreating);
                        cduWithholdingtreating.FunDeferWithholding(Rec);
                    END;


                }

            }
            group("group7")
            {
                CaptionML = ESP = 'Navegar';
                // ActionContainerType =ActionItems ;
                action("action4")
                {
                    CaptionML = ENU = '&Navigate', ESP = 'Nav. Original';
                    Image = Navigate;

                    trigger OnAction()
                    VAR
                        NavigatePage: Page 344;
                    BEGIN
                        NavigatePage.SetDoc(rec."Posting Date", rec."Document No.");
                        NavigatePage.RUN;
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = '&Navigate', ESP = 'Nav. Liberado';
                    Enabled = NOT bLiberar;
                    Image = Navigate;

                    trigger OnAction()
                    VAR
                        NavigatePage: Page 344;
                        i: Integer;
                        txt: Text;
                    BEGIN
                        NavigatePage.SetDoc(rec."Release Date", rec."Released-to Doc. No");
                        NavigatePage.RUN;
                    END;


                }

            }
            group("group10")
            {
                CaptionML = ESP = 'Liquidar';
                // ActionContainerType =NewDocumentItems ;
                action("action6")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Mark Application', ESP = 'Marcar liquidaci�n';
                    Enabled = bLiberar;
                    Image = SelectLineToApply;

                    trigger OnAction()
                    BEGIN
                        CLEAR(cduWithholdingtreating);
                        cduWithholdingtreating.FunMarkApplication(Rec);
                        CurrPage.UPDATE;
                    END;


                }
                action("action7")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'Post. Marked Application', ESP = 'Registrar Liquidaci�n';
                    Enabled = bLiquidar;
                    Image = Post;

                    trigger OnAction()
                    BEGIN
                        CLEAR(cduWithholdingtreating);
                        Rec.TESTFIELD("Applies-to ID");
                        cduWithholdingtreating.FunMarkPostApplication(Rec);
                    END;


                }
                action("UnpaidWithholding")
                {

                    CaptionML = ESP = 'Impagar retenci�n';
                    Enabled = bImpagar;
                    Image = UnApply;


                    trigger OnAction()
                    VAR
                        WithholdingMovements: Record 7207329;
                        cWithholdingTreating: Codeunit 7207306;
                    BEGIN
                        //Q15417 LCG 06/10/21-INI
                        WithholdingMovements.RESET();
                        CurrPage.SETSELECTIONFILTER(WithholdingMovements);
                        IF WithholdingMovements.FINDSET() THEN
                            REPEAT
                                cWithholdingTreating.FunUnpaidWithholding(Rec);
                            UNTIL WithholdingMovements.NEXT() = 0;
                        //Q15417 LCG 06/10/21-FIN
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref("<Action36>_Promoted"; "<Action36>")
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(UnpaidWithholding_Promoted; UnpaidWithholding)
                {
                }
            }
            group(Category_Category4)
            {
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
            }
            group(Category_Category5)
            {
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    BEGIN
        //JAV 07/03/19: - Se ponen no activos los botones de acci�n cuando es una linea de IRPF
        bLiberar := (rec."Withholding Type" = rec."Withholding Type"::"G.E") AND (rec.Open);
        bLiquidar := (rec."Withholding Type" = rec."Withholding Type"::"G.E") AND (rec."Released-to Movement No." = 0);
        //JAV --
        //Q15417 LCG 06/10/21 - QRE - INI
        bImpagar := (rec."Withholding Type" = rec."Withholding Type"::"G.E") AND (rec.Open) AND (NOT rec.QB_Unpaid);
        //Q15417 LCG 06/10/21 - QRE - FIN
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        //CODEUNIT.RUN(CODEUNIT::"Mov. retenci�n-Editar",Rec);
        //EXIT(FALSE);
    END;



    var
        WithholdingMovements: Record 7207329;
        cduWithholdingtreating: Codeunit 7207306;
        FunctionQB: Codeunit 7207272;
        Window: Dialog;
        read: Integer;
        Text001: TextConst ENU = 'Releasing Whithholding/s... \#1#######', ESP = 'Liberando retenci�n/es... \#1#######';
        bLiberar: Boolean;
        bLiquidar: Boolean;
        bImpagar: Boolean;/*

    begin
    {
      JAV 18/10/19: - Esta pantalla es para cualquier tipo de movimiento de retenci�n
      LCG 06/10/21: - QRE Q15417Se crea campo QB_Unpaid y bot�n UnpaidWithholding
      JDC 01/06/22: - QB 1.10.49 Q17128 Added fields 50000 "Customer Name", 50001 "Vendor Name"
    }
    end.*/


}







