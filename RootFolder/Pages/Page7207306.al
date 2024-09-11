page 7207306 "Post. Measurement"
{
    Editable = false;
    InsertAllowed = false;
    SourceTable = 7207338;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("No."; rec."No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Name"; rec."Name")
                {

                }
                field("Address"; rec."Address")
                {

                }
                field("Text Measure"; rec."Text Measure")
                {

                }
                field("Measurement Date"; rec."Measurement Date")
                {

                    ToolTipML = ESP = 'Hasta que fecha se ha efectuado la medici�n (la medici�n es desde el inicio de la obra hasta esta fecha)';
                }
                field("Send Date"; rec."Send Date")
                {

                    ToolTipML = ESP = 'En que fecha se ha entregado al cliente';
                }
                field("Posting Date"; rec."Posting Date")
                {

                    ToolTipML = ESP = 'En que fecha se cargar� en el proyecto';
                }
                field("Cancel No."; rec."Cancel No.")
                {

                }
                field("Cancel By"; rec."Cancel By")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }
                field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207497)
            {

                CaptionML = ESP = 'Totales de la medici�n';
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
            }
            systempart(Links; Links)
            {

                Visible = TRUE;
            }
            systempart(Notes; Notes)
            {

                Visible = TRUE;
            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = '&Document', ESP = 'General';
                action("action1")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Measure Hist."), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action2")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDimensions;
                    END;


                }

            }
            group("group5")
            {
                CaptionML = ESP = 'Medici�n';
                // ActionContainerType =ActionItems ;
                action("action3")
                {
                    CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                    Image = Navigate;

                    trigger OnAction()
                    BEGIN
                        rec.Navigate;
                    END;


                }
                action("Cancel Measurement")
                {

                    CaptionML = ENU = 'Cancel Measurement', ESP = 'Cancelar medici�n';
                    Image = Cancel;

                    trigger OnAction()
                    VAR
                        QBMeasurements: Codeunit 7207274;
                    BEGIN
                        //JAV 22/03/19: - Nueva acci�n para cancelar una medici�n registrada
                        QBMeasurements.HistMeasurementsCancel(Rec);
                    END;


                }
                action("action5")
                {
                    Ellipsis = true;
                    CaptionML = ENU = '&Print', ESP = '&Imprimir';
                    Image = Print;

                    trigger OnAction()
                    VAR
                        QBReportSelections: Record 7206901;
                    BEGIN
                        HistMeasurements.RESET;
                        HistMeasurements.SETRANGE("No.", rec."No.");
                        HistMeasurements.SETRANGE("Job No.", rec."Job No.");

                        //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                        //CLEAR(RepMedi);
                        //RepMedi.SETTABLEVIEW(HistMeasurements);
                        //RepMedi.RUNMODAL;
                        QBReportSelections.Print(QBReportSelections.Usage::J5, HistMeasurements);
                    END;


                }

            }
            group("group9")
            {
                CaptionML = ESP = 'QB Admin';
                // ActionContainerType =ActionItems ;
                action("action6")
                {
                    CaptionML = ESP = 'Eliminar';
                    Visible = seeAdmin;
                    Image = Delete;


                    trigger OnAction()
                    VAR
                        HistMeasureLines: Record 7207339;
                    BEGIN
                        //JAV 13/10/20: - QB 1.06.20 Nueva acci�n para borrar completamente la certificaci�n, solo para administradores de QB
                        Rec.DELETE(TRUE);
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref("Cancel Measurement_Promoted"; "Cancel Measurement")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        rec.FilterResponsability(Rec);
        FunctionQB.SetUserJobHistMeasurementsFilter(Rec);

        //JAV 13/10/20: - QB 1.06.20 Si es administrador de QB, podr� ver ciertos botones
        seeAdmin := FunctionQB.IsQBAdmin;
    END;



    var
        FunctionQB: Codeunit 7207272;
        HistMeasurements: Record 7207338;
        // RepMedi: Report 7207423;
        seeAdmin: Boolean;

    //[Business]
    LOCAL procedure PagePostMeasurementCancel(HistMeasurements: Record 7207338);
    begin
    end;

    // begin
    /*{
      JAV 22/03/19: - Nueva acci�n para cancelar una medici�n registrada
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
      JAV 13/10/20: - QB 1.06.20 Nueva acci�n para borrar completamente la certificaci�n, solo para administradores de QB
    }*///end
}







