page 7207313 "Output Shipment Heading"
{
    CaptionML = ENU = 'Warehouse Shipment Heading', ESP = 'Cabecera albaran almac�n';
    SourceTable = 7207308;
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'Generla', ESP = 'General';
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Request Date"; rec."Request Date")
                {

                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Posting Description"; rec."Posting Description")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Stock Regulation"; rec."Stock Regulation")
                {

                    Editable = False;
                }

            }
            part("LinDoc"; 7207315)
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group("group27")
            {

                CaptionML = ENU = 'Posting', ESP = 'Registro';
                field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                {


                    ; trigger OnValidate()
                    BEGIN
                        ShortcutDimension1CodeOnAfterV;
                    END;


                }

            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207496)
            {
                SubPageLink = "No." = FIELD("No.");
            }
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
                CaptionML = ENU = 'Shipment', ESP = 'Albar�n';
                action("action1")
                {
                    ShortCutKey = 'F7';
                    CaptionML = ENU = 'Statistics', ESP = 'Estad�sticas';
                    Promoted = true;
                    Visible = false;
                    Image = Statistics;
                    PromotedCategory = Process;

                    trigger OnAction()
                    BEGIN
                        // Tomamos la configuraci�n del area funcional del documento.
                        PAGE.RUNMODAL(PAGE::"Posted Output Shipment List", Rec);
                    END;


                }
                action("action2")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 89;
                    RunPageLink = "No." = FIELD("Job No.");
                    Image = EditLines;
                }
                action("action3")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "No." = FIELD("No."), "Document Type" = CONST("Receipt");
                    Image = ViewComments;
                }
                action("action4")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDocDim;
                    END;


                }

            }
            group("group7")
            {
                CaptionML = ENU = 'Line', ESP = 'Acciones';
                action("action5")
                {
                    CaptionML = ENU = 'Print', ESP = 'Imprimir';
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Print;
                    PromotedCategory = Report;

                    trigger OnAction()
                    BEGIN
                        OutputShipmentHeader.RESET;
                        OutputShipmentHeader.SETRANGE("No.", rec."No.");
                        // REPORT.RUNMODAL(REPORT::"Output Shipment", TRUE, FALSE, OutputShipmentHeader);
                    END;


                }

            }

        }
        area(Creation)
        {
            ////CaptionML=ENU='Documents New',ESP='Nuevos documentos';
            action("action6")
            {
                CaptionML = ENU = 'New (Job Filter)', ESP = 'Nuevo (Filtro PRoy.)';
                RunObject = Page 7207313;
                RunPageLink = "Job No." = FIELD("Job No.");
                Promoted = true;
                Image = NewDocument;
                PromotedCategory = New;
            }

        }
        area(Processing)
        {

            group("group12")
            {
                CaptionML = ENU = 'Posting', ESP = 'Registro';
                action("action7")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'Post', ESP = 'Registrar';
                    RunObject = Codeunit 7207277;
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Post;
                    PromotedCategory = Process;

                    trigger OnAction()
                    VAR
                        OutputShipmentLines: Record 7207309;
                    BEGIN

                        OutputShipmentLines.SETRANGE("Document No.", rec."No.");
                        OutputShipmentLines.SETRANGE(Devolucion, TRUE);
                        OutputShipmentLines.SETRANGE("Precio Devolucion", 0);
                        IF OutputShipmentLines.FINDSET THEN
                            IF NOT CONFIRM('Hay devoluciones con precios a 0. Desea Seguir?', FALSE) THEN ERROR('No se sigue con el registro');
                    END;


                }
                action("action8")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Post Batch', ESP = 'Registrar por lotes';
                    Image = PostBatch;

                    trigger OnAction()
                    VAR
                        OutputShipmentLines: Record 7207309;
                    BEGIN

                        // REPORT.RUNMODAL(REPORT::"Output Shipment Batrch Records", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                group("group15")
                {

                    CaptionML = ESP = 'Disponibilidad';
                    action("action9")
                    {
                        CaptionML = ESP = 'Disponibilidad prestados';


                        trigger OnAction()
                        BEGIN
                            PAGE.RUN(PAGE::"QB Items by Location", Rec);
                        END;


                    }

                }

            }

        }
    }

    trigger OnOpenPage()
    BEGIN
        rec.FilterResponsability(Rec);
        FunctionQB.SetUserJobOutputShipmentHeaderFilter(Rec);
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        IF Rec.FIND(Which) THEN
            EXIT(TRUE)
        ELSE BEGIN
            Rec.SETRANGE("No.");
            EXIT(Rec.FIND(Which));
        END;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        FunctionQB.GetJobFilter(HasGotSalesUserSetup, UserRespCenter);
        rec."Responsability Center" := UserRespCenter;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(rec.ConfirmDeletion);
    END;



    var
        FunctionQB: Codeunit 7207272;
        CodeFilterLevel: Code[250];
        HasGotSalesUserSetup: Boolean;
        UserRespCenter: Code[20];
        OutputShipmentHeader: Record 7207308;

    LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
    end;

    // begin
    /*{
      JAV 09/07/19: - Se cambia la propiedad de propagaci�n de las l�neas para que sea en ambos sentidos
    }*///end
}







