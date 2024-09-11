page 7207585 "Subf. Job Piecew. Bill of Item"
{
    CaptionML = ENU = 'Subf. Job Piecework Bill of Item', ESP = 'Subform descomp. UO proyecto';
    SourceTable = 7207387;
    PageType = ListPart;
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Cost Type"; rec."Cost Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Cod. Budget"; rec."Cod. Budget")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Analytical Concept Direct Cost"; rec."Analytical Concept Direct Cost")
                {

                }
                field("Performance By Piecework"; rec."Performance By Piecework")
                {

                }
                field("Budget Quantity"; rec."Budget Quantity")
                {

                }
                field("Direct Unitary Cost (JC)"; rec."Direct Unitary Cost (JC)")
                {

                }
                field("Budget Cost"; rec."Budget Cost")
                {

                }
                field("Piecework Code"; rec."Piecework Code")
                {

                }
                field("Cod. Measure Unit"; rec."Cod. Measure Unit")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            group("group2")
            {
                CaptionML = ENU = 'Functions', ESP = 'A&cciones';
                action("action1")
                {
                    CaptionML = ENU = 'Bill of Item Rec.COPY', ESP = 'Copiar descompuestos';
                    trigger OnAction()
                    VAR
                        DataCostByPieceworkLocal: Record 7207387;
                        DataCostByPieceworkL2: Record 7207387;
                        Job: Record 167;
                        Currency: Record 4;
                        Text000: TextConst ENU='Piecework %1 for %2 and %3 already exists',ESP='Ya existe la unidad de obra %1 para %2 y %3';
                        Text001: TextConst ENU='Do you want to Rec.COPY the selected bill of item to the piecework %1 of job %2?',ESP='�Desea copiar el descompuesto seleccionado a la unidad de obra %1 del proyecto %2?';
                    BEGIN
                        CurrPage.SETSELECTIONFILTER(DataCostByPiecework);

                        IF CONFIRM(Text001, TRUE, DataPieceworkForProduction."Piecework Code", DataPieceworkForProduction."Job No.") THEN BEGIN
                            CLEAR(Currency);
                            Currency.InitRoundingPrecision;

                            // Adem�s de cada una unidad de obra hay que crear una l�nea de coste que viene determinado por su descompuesto
                            Job.GET(DataPieceworkForProduction."Job No.");
                            IF DataCostByPiecework.FINDSET THEN BEGIN
                                REPEAT
                                    DataCostByPieceworkL2.INIT;
                                    DataCostByPieceworkL2.VALIDATE("Job No.", DataPieceworkForProduction."Job No.");
                                    DataCostByPieceworkL2.VALIDATE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                                    DataCostByPieceworkL2.VALIDATE("Cost Type", DataCostByPiecework."Cost Type");
                                    DataCostByPieceworkL2.VALIDATE("No.", DataCostByPiecework."No.");
                                    DataCostByPieceworkL2.VALIDATE("Analytical Concept Direct Cost", DataCostByPiecework."Analytical Concept Direct Cost");
                                    DataCostByPieceworkL2.VALIDATE("Analytical Concept Ind. Cost", DataCostByPiecework."Analytical Concept Ind. Cost");
                                    DataCostByPieceworkL2.VALIDATE("Performance By Piecework", DataCostByPiecework."Performance By Piecework");
                                    IF Job."Budget Status" = Job."Budget Status"::Blocked THEN BEGIN
                                        DataCostByPieceworkL2.VALIDATE("Direct Unitary Cost (JC)", 0);
                                        DataCostByPieceworkL2.VALIDATE("Indirect Unit Cost", 0);
                                        DataCostByPieceworkL2.VALIDATE("Budget Cost", 0);
                                    END ELSE BEGIN
                                        DataCostByPieceworkL2.VALIDATE("Direct Unitary Cost (JC)", DataCostByPiecework."Direct Unitary Cost (JC)");
                                        DataCostByPieceworkL2.VALIDATE("Indirect Unit Cost", DataCostByPiecework."Indirect Unit Cost");
                                        DataCostByPieceworkL2.VALIDATE("Budget Cost", ROUND(DataCostByPiecework."Performance By Piecework" *
                                                                      (DataCostByPiecework."Direct Unitary Cost (JC)" +
                                                                      DataCostByPiecework."Indirect Unit Cost"),
                                                                      Currency."Amount Rounding Precision"));
                                    END;
                                    DataCostByPieceworkL2."Piecework Code" := DataCostByPiecework."Piecework Code";
                                    DataCostByPieceworkL2."Unique Code" := DataPieceworkForProduction."Unique Code";
                                    DataCostByPieceworkL2."Cod. Budget" := CurrentBudget;
                                    IF NOT DataCostByPieceworkL2.INSERT THEN BEGIN
                                        MESSAGE(Text000, DataCostByPieceworkL2."Piecework Code", DataCostByPieceworkL2."Cost Type", DataCostByPieceworkL2."No.");
                                        CurrPage.CLOSE;
                                    END;
                                UNTIL DataCostByPiecework.NEXT = 0;
                            END;
                        END;
                    END;
                }

            }

        }
    }

    var
        DataCostByPiecework: Record 7207387;
        DataPieceworkForProduction: Record 7207386;
        CurrentBudget: Code[20];

    procedure ReceivesDataPieceworkProduction(DataPieceworkForProductionF: Record 7207386; CurentBudgetF: Code[20]);
    begin
        DataPieceworkForProduction := DataPieceworkForProductionF;
        CurrentBudget := CurentBudgetF;
    end;

    procedure ReceivesFilter(var PDataCostByPiecework: Record 7207387);
    begin
        CurrPage.SETSELECTIONFILTER(PDataCostByPiecework);
        if PDataCostByPiecework.FINDSET then
            repeat
                PDataCostByPiecework.MARK := TRUE;
            until PDataCostByPiecework.NEXT = 0;
    end;

    // begin
    /*{
      A�ado la acci�n de copiar descompuestos.
    }*///end
}







