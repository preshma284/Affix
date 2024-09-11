page 7207516 "Prod. Measure"
{
    CaptionML = ENU = 'Prod. Measure', ESP = 'Relaci�n valorada';
    SourceTable = 7207399;
    SourceTableView = SORTING("No.");
    PageType = Document;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("No."; rec."No.")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Customer No."; rec."Customer No.")
                {


                    ; trigger OnLookup(var Text: Text): Boolean
                    BEGIN
                        //Q8047 >>
                        Records.RESET;
                        Records.SETRANGE("Job No.", Rec."Job No.");
                        IF Records.FINDSET THEN
                            REPEAT
                                Filtros += Records."Customer No." + '|';
                            UNTIL Records.NEXT = 0;

                        Filtros := COPYSTR(Filtros, 1, STRLEN(Filtros) - 1);
                        CLEAR(CustomerList);
                        Customer.RESET;
                        CustomerList.LOOKUPMODE(TRUE);
                        Customer.SETFILTER("No.", Filtros);
                        CustomerList.SETTABLEVIEW(Customer);
                        IF CustomerList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            CustomerList.GETRECORD(Customer);
                            rec."Customer No." := Customer."No.";
                        END;
                        IF xRec."Customer No." <> Rec."Customer No." THEN BEGIN
                            ProdMeasureLines.RESET;
                            ProdMeasureLines.SETRANGE("Document No.", Rec."No.");
                            IF ProdMeasureLines.FINDSET THEN
                                IF ProdMeasureLines.COUNT > 0 THEN
                                    IF CONFIRM(ConfirmCustChange) THEN
                                        REPEAT
                                            ProdMeasureLines.DELETE(TRUE);
                                        UNTIL ProdMeasureLines.NEXT = 0
                                    ELSE
                                        ERROR(ErrCancel);
                        END;
                        //Q8047 <<
                    END;


                }
                field("Measurement No."; rec."Measurement No.")
                {

                }
                field("Measurement Text"; rec."Measurement Text")
                {

                }
                field("Posting No. Series"; rec."Posting No. Series")
                {

                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Measure Date"; rec."Measure Date")
                {

                }
                field("Cancel No."; rec."Cancel No.")
                {

                }
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207629)
            {
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
            }
            systempart(Notes; Notes)
            {

                Visible = TRUE;
            }
            systempart(Links; Links)
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
                CaptionML = ENU = '&Measurement', ESP = '&Medici�n';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 89;
                    RunPageLink = "No." = FIELD("Job No.");
                    Image = EditLines;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Measure"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDocDim;
                        CurrPage.SAVERECORD;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group7")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                action("action4")
                {
                    CaptionML = ENU = 'Suggest Piecework for Prod.', ESP = 'Propo&ner unidades de obra de producci�n';
                    Image = SuggestSalesPrice;

                    trigger OnAction()
                    BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                        DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);

                        //Si es Multi-cliente, filtramos los expediente del cliente
                        //JAV 19/11/20: - QB 1.07.06 Pero solo si no hay separaci�n coste-venta, TO-DO mejorar para que busque a trav�s de las U.O. de venta las de coste asociadas
                        Job.GET(rec."Job No.");
                        IF (Job."Multi-Client Job" = Job."Multi-Client Job"::ByCustomers) AND (NOT Job."Separation Job Unit/Cert. Unit") THEN BEGIN
                            Filtros := '';

                            Records2.RESET;
                            Records2.SETRANGE("Customer No.", rec."Customer No.");
                            Records2.SETRANGE("Job No.", rec."Job No.");
                            IF Records2.FINDSET(FALSE) THEN
                                REPEAT
                                    Filtros += Records2."No." + '|';
                                UNTIL Records2.NEXT = 0;

                            Filtros := DELCHR(Filtros, '>', '|');
                            IF (Filtros <> '') THEN
                                DataPieceworkForProduction.SETFILTER("No. Record", Filtros);
                        END;

                        //Sacar la lista
                        CLEAR(pageSelectProdUnitList);
                        pageSelectProdUnitList.LOOKUPMODE(TRUE);
                        pageSelectProdUnitList.SETTABLEVIEW(DataPieceworkForProduction);
                        pageSelectProdUnitList.RecieveData(rec."No.");
                        pageSelectProdUnitList.RUNMODAL;
                    END;


                }
                action("action5")
                {
                    CaptionML = ENU = 'Suggest Measures Subcont.', ESP = 'Proponer &mediciones subcontrataci�n';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    BEGIN
                        DataPieceworkForProduction.RESET;
                        DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
                        DataPieceworkForProduction.SETFILTER("No. Subcontracting Resource", '<>%1', '');

                        CLEAR(pageSelectSubcontUnitList);
                        pageSelectSubcontUnitList.LOOKUPMODE(TRUE);
                        pageSelectSubcontUnitList.SETTABLEVIEW(DataPieceworkForProduction);
                        pageSelectSubcontUnitList.RecieveData(rec."No.");
                        pageSelectSubcontUnitList.RUNMODAL;
                    END;


                }
                action("action6")
                {
                    CaptionML = ENU = 'Print', ESP = 'Imprimir';
                    Image = Print;

                    trigger OnAction()
                    VAR
                        QBReportSelections: Record 7206901;
                        ProdMeasureHeader: Record 7207399;
                    BEGIN
                        ProdMeasureHeader.RESET;
                        ProdMeasureHeader.SETRANGE("No.", rec."No.");
                        //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                        //REPORT.RUNMODAL(REPORT::"Production Measurement", TRUE, TRUE, ProdMeasureHeader)
                        QBReportSelections.Print(QBReportSelections.Usage::J2, ProdMeasureHeader);
                    END;


                }
                action("action7")
                {
                    CaptionML = ESP = 'Importar Excel';
                    Image = ImportExcel;

                    trigger OnAction()
                    VAR
                        // ImportExcel: Report 7207426;
                    BEGIN
                        //JAV 18/10/19: - Nueva acci�n para importar desde Excel los datos
                        // CLEAR(ImportExcel);
                        // ImportExcel.SetFilters(Rec);
                        // ImportExcel.RUN;

                        //JAV 28/07/21: - QB 1.09.14 A�adir las l�neas valoradas anteriomente que falten tras traer la Excel
                        COMMIT;
                        rec.AddLines;
                    END;


                }

            }
            group("group12")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action8")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    RunObject = Codeunit 7207323;
                    Image = Post;
                }
                action("action9")
                {
                    CaptionML = ESP = 'Igualar C/V';
                    Image = EnableAllBreakpoints;


                    trigger OnAction()
                    BEGIN
                        rec.MatchCostSale;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action4_Promoted; action4)
                {
                }
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
        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.FunFilterResponsibility(Rec);
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Responsibility Center" := FunctionQB.GetUserJobResponsibilityCenter;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(TRUE);
    END;



    var
        Job: Record 167;
        jobsSetup: Record 312;
        DataPieceworkForProduction: Record 7207386;
        pageSelectProdUnitList: Page 7207527;
        pageSelectSubcontUnitList: Page 7207559;
        Text001: TextConst ENU = 'You only can suggest subcontracting for type Source Measurements', ESP = 'Unicamente se pueden proponer mediciones de subcontrataci�n para medidciones de tipo a origen';
        Records2: Record 7207393;
        Records: Record 7207393;
        Filtros: Text;
        Customer: Record 18;
        CustomerList: Page 22;
        ProdMeasureLines: Record 7207400;
        ConfirmCustChange: TextConst ENU = 'if you change the customer, the measure lines will be cleaned. Do you wish to continue?', ESP = 'Si cambia el cliente se limpiaran las l�neas de medici�n.�Desea continuar?';
        ErrCancel: TextConst ENU = 'Cancelled by the user', ESP = 'Cancelado por el usuario';
        FunctionQB: Codeunit 7207272;/*

    begin
    {
      JAV 26/03/19: - Se cambia el par�metro UpdatePropagation de la page de l�neas para que se actualice
      JAV 02/04/19: - Se elimina la llamada a las l�neas para establecer editable coluimnas a origen o periodo, ya no tiene sentido y lo hac�a mal de todas formas.
                    - Se cambia el texto de la contante Text001
      JAV 31/07/19: - Se a�ade el campo "Cancel No."
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
      PGM 16/10/19: - Q8047 Se controla que solo se puedan elegir los clientes que est�n en los expedientes del proyecto.
      JAV 18/10/19: - Nueva acci�n para importar desde Excel los datos
      JAV 28/07/21: - QB 1.09.14 A�adir las l�neas valoradas anteriomente que falten tras traer la Excel

      CPA 29/08/22 Q17919. Optimizaci�n. Se eliminan:
                  - Trigger OnFindRecord y OnAfterGetCurrrecord: Se elimina el c�digo
                  - Funci�n GetRecord: se elimina porque ya no se usa
    }
    end.*/


}







