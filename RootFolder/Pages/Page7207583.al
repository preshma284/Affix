page 7207583 "Job Piecework List"
{
    Editable = false;
    CaptionML = ENU = 'Job Piecework List', ESP = 'Lista U.O. Proyecto';
    SourceTable = 7207386;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Description 2"; rec."Description 2")
                {

                }
                field("Amount Production Budget"; rec."Amount Production Budget")
                {

                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                }
                field("Budget Measure"; rec."Budget Measure")
                {

                }

            }
            part("BillofItemData"; 7207585)
            {

                CaptionML = ENU = 'BillofItemData', ESP = 'DatoDescompuesto';
                SubPageView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.");
                SubPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code");
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Piecework', ESP = '&Unidades de Obra';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = '&Card', ESP = '&Ficha';

                    trigger OnAction()
                    BEGIN
                        PAGE.RUNMODAL(PAGE::"Job Piecework Card", Rec);
                    END;


                }
                action("action2")
                {
                    CaptionML = ENU = 'Extended Text', ESP = '&Textos adicionales';
                    RunObject = Page 391;
                    RunPageView = SORTING("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                    RunPageLink = "Table Name" = CONST(16), "No." = FIELD("Unique Code");
                }
                action("action3")
                {
                    CaptionML = ENU = 'Comments', ESP = 'Comentario';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Piecework"), "No." = FIELD("Unique Code");
                }
                separator("separator4")
                {

                }
                action("action5")
                {
                    CaptionML = ENU = 'Confirm', ESP = 'Confirmar';
                    Image = Confirm;
                    trigger OnAction()
                    VAR
                        Text000: TextConst;
                        Text001: TextConst ENU = 'Do you want to Rec.COPY the selected decomposed to the work unit% 1 of project% 2?', ESP = '�Desea copiar el descompuesto seleccionado a la unidad de obra %1 del proyecto %2?';
                    BEGIN
                        IF CONFIRM(Text001, TRUE, DataPieceworkForProduction."Piecework Code", DataPieceworkForProduction."Job No.") THEN BEGIN
                            CLEAR(Currency);
                            Currency.InitRoundingPrecision;

                            // Adem�s de cada una unidad de obra hay que crear una l�nea de coste que viene determinado por su descompuesto
                            Job.GET(DataPieceworkForProduction."Job No.");
                            IF DataCostByPiecework.FINDSET THEN BEGIN
                                REPEAT
                                    DataCostByPiecework2.INIT;
                                    DataCostByPiecework2.VALIDATE("Job No.", DataPieceworkForProduction."Job No.");
                                    DataCostByPiecework2.VALIDATE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                                    DataCostByPiecework2.VALIDATE("Cost Type", DataCostByPiecework."Cost Type");
                                    DataCostByPiecework2.VALIDATE("No.", DataCostByPiecework."No.");
                                    DataCostByPiecework2.VALIDATE("Analytical Concept Direct Cost", DataCostByPiecework."Analytical Concept Direct Cost");
                                    DataCostByPiecework2.VALIDATE("Analytical Concept Ind. Cost", DataCostByPiecework."Analytical Concept Ind. Cost");
                                    DataCostByPiecework2.VALIDATE("Performance By Piecework", DataCostByPiecework."Performance By Piecework");
                                    IF Job."Budget Status" = Job."Budget Status"::Blocked THEN BEGIN
                                        DataCostByPiecework2.VALIDATE("Direct Unitary Cost (JC)", 0);
                                        DataCostByPiecework2.VALIDATE("Indirect Unit Cost", 0);
                                        DataCostByPiecework2.VALIDATE("Budget Cost", 0);
                                    END ELSE BEGIN
                                        DataCostByPiecework2.VALIDATE("Direct Unitary Cost (JC)", DataCostByPiecework."Direct Unitary Cost (JC)");
                                        DataCostByPiecework2.VALIDATE("Indirect Unit Cost", DataCostByPiecework."Indirect Unit Cost");
                                        DataCostByPiecework2.VALIDATE("Budget Cost", ROUND(DataCostByPiecework."Performance By Piecework" *
                                                                      (DataCostByPiecework."Direct Unitary Cost (JC)" +
                                                                      DataCostByPiecework."Indirect Unit Cost"),
                                                                      Currency."Amount Rounding Precision"));
                                    END;
                                    DataCostByPiecework2."Code Cost Database" := DataCostByPiecework."Code Cost Database";
                                    DataCostByPiecework2."Unique Code" := DataPieceworkForProduction."Unique Code";
                                    DataCostByPiecework2."Cod. Budget" := CurrentBudget;
                                    IF NOT DataCostByPiecework2.INSERT THEN BEGIN
                                        MESSAGE(Text000, DataCostByPiecework2."Piecework Code", DataCostByPiecework2."Cost Type", DataCostByPiecework2."No.");
                                        CurrPage.CLOSE;
                                    END;
                                UNTIL DataCostByPiecework.NEXT = 0;
                            END;
                        END;
                    END;
                }

            }

        }
        area(Creation)
        {


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action5_Promoted; action5)
                {
                }
            }
        }
    }

    trigger OnInit()
    BEGIN
        CurrPage.LOOKUPMODE := TRUE;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        CurrPage.BillofItemData.PAGE.ReceivesDataPieceworkProduction(DataPieceworkForProduction, CurrentBudget);
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        Currency: Record 4;
        Job: Record 167;
        DataCostByPiecework: Record 7207387;
        DataCostByPiecework2: Record 7207387;
        CurrentBudget: Code[20];
        Accept: Boolean;

    procedure GetPiecework(var PDataPieceworkForProduction: Record 7207386; PCurrentBudget: Code[20]);
    begin
        DataPieceworkForProduction := PDataPieceworkForProduction;
        CurrentBudget := PCurrentBudget;
    end;

    procedure DefinitionFilter(PType: Option "Piecework","Cost Unit");
    begin
        Rec.FILTERGROUP(2);
        Rec.SETRANGE(Type, PType);
        Rec.FILTERGROUP(0);
    end;

    LOCAL procedure LookupOKOnPush();
    begin
        Accept := TRUE;
        CurrPage.BillofItemData.PAGE.ReceivesFilter(DataCostByPiecework);
    end;

    // begin
    /*{
      Inhabilito la acci�n de Confirmar y la sustituyo por una acci�n en la Page 7207585 - "Subform descomp. UO proyecto".

      Inserto c�digo en el OnAfterRecord para pasar los datos necesarios.
    }*///end
}







