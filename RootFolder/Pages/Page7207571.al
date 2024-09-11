page 7207571 "Card Records"
{
    CaptionML = ENU = 'Card Records', ESP = 'Ficha Expedientes';
    SourceTable = 7207393;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("No."; rec."No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Job Description"; rec."Job Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Customer Name"; rec."Customer Name")
                {

                }
                field("Sale Type"; rec."Sale Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Record Type"; rec."Record Type")
                {

                }
                field("Description"; rec."Description")
                {

                }
                field("Record Status"; rec."Record Status")
                {

                }
                field("Search Description"; rec."Search Description")
                {

                }
                field("Blocked"; rec."Blocked")
                {

                }
                field("Last Modified Date"; rec."Last Modified Date")
                {

                }
                field("Finished"; rec."Finished")
                {

                }

            }
            group("Dates")
            {

                CaptionML = ENU = 'Dates', ESP = 'Fechas';
                field("Entry Record Date"; rec."Entry Record Date")
                {

                }
                field("Shipment To Central Date"; rec."Shipment To Central Date")
                {

                }
                field("Initial Procedure Date"; rec."Initial Procedure Date")
                {

                }
                field("Launch Date"; rec."Launch Date")
                {

                }
                field("Technical Approval Date"; rec."Technical Approval Date")
                {

                }
                field("Definitive Approval Date"; rec."Definitive Approval Date")
                {

                }
                field("Finish Record Date"; rec."Finish Record Date")
                {

                }

            }
            group("Amounts")
            {

                CaptionML = ENU = 'Amounts', ESP = 'Importes';
                field("Estimated Amount"; rec."Estimated Amount")
                {

                }
                field("Piecework No."; rec."Piecework No.")
                {

                }
                field("CostAmount"; rec.CostAmount(0))
                {

                    CaptionML = ENU = 'Cost Amount', ESP = 'Importe coste Ppto.';
                }
                field("SaleAmount"; rec.SaleAmount(0))
                {

                    CaptionML = ENU = 'Sale Amount', ESP = 'Importe producci�n Ppto.';
                }
                field("AmountProductionProcedure"; rec.ProcedureAmount(0))
                {

                    CaptionML = ENU = 'Amount Production Procedure', ESP = 'Importe producci�n tramite';
                }
                field("AmountProductionAccepted"; rec.AcceptedAmount(0))
                {

                    CaptionML = ENU = 'Amount Production Accepted', ESP = 'Importe producci�n aceptada';
                }

            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Records', ESP = '&Expedientes';
                action("action1")
                {
                    CaptionML = ENU = 'Comments', ESP = '&Comentarios';
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST("Vendor Evaluation"), "No." = FIELD("No.");
                }
                separator("separator2")
                {

                }
                action("Job Units")
                {

                    CaptionML = ENU = '&Job Units', ESP = '&Unidades de obra';
                    Image = SuggestSalesPrice;

                    trigger OnAction()
                    VAR
                        ListUnitProduction: Page 7207533;
                    BEGIN
                        CLEAR(ListUnitProduction);
                        DataJobUnitForProduction.RESET;
                        DataJobUnitForProduction.SETCURRENTKEY("Job No.", "No. Record");
                        DataJobUnitForProduction.FILTERGROUP(2);
                        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
                        DataJobUnitForProduction.SETRANGE("No. Record", rec."No.");
                        DataJobUnitForProduction.SETRANGE("Account Type", DataJobUnitForProduction."Account Type"::Unit);
                        DataJobUnitForProduction.FILTERGROUP(0);
                        ListUnitProduction.SETTABLEVIEW(DataJobUnitForProduction);
                        ListUnitProduction.EDITABLE(FALSE);
                        ListUnitProduction.RUNMODAL;
                    END;


                }

            }
            group("Actions")
            {

                CaptionML = ENU = '&Actions', ESP = '&Acciones';
                action("Associate Job Units")
                {

                    CaptionML = ENU = '&Associate Job Units', ESP = '&Asociar Unidades de Obra';
                    Image = CopyFromTask;

                    trigger OnAction()
                    BEGIN
                        CLEAR(AssociateJUToRecord);
                        DataJobUnitForProduction.RESET;
                        DataJobUnitForProduction.SETCURRENTKEY("Job No.", "No. Record");
                        DataJobUnitForProduction.FILTERGROUP(2);
                        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
                        DataJobUnitForProduction.SETFILTER("No. Record", '%1', '');
                        DataJobUnitForProduction.SETRANGE("Production Unit", TRUE);
                        DataJobUnitForProduction.FILTERGROUP(0);
                        AssociateJUToRecord.SETTABLEVIEW(DataJobUnitForProduction);
                        AssociateJUToRecord.EDITABLE(FALSE);
                        AssociateJUToRecord.LOOKUPMODE(TRUE);
                        AssociateJUToRecord.ReceiveData(Rec, OptionAction::Associate);
                        IF AssociateJUToRecord.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            AssociateJUToRecord.ReturnNumber(NumberParam);
                            IF NumberParam <> 0 THEN
                                MESSAGE(Text0001, NumberParam);
                        END;
                    END;


                }
                separator("separator5")
                {

                }
                action("Remove Units from Record")
                {

                    CaptionML = ENU = '&Remove Units from Record', ESP = '&Quitar Unidades del exp.';
                    Image = DeleteExpiredComponents;

                    trigger OnAction()
                    BEGIN
                        CLEAR(AssociateJUToRecord);
                        DataJobUnitForProduction.RESET;
                        DataJobUnitForProduction.SETCURRENTKEY("Job No.", "No. Record");
                        DataJobUnitForProduction.FILTERGROUP(2);
                        DataJobUnitForProduction.SETRANGE("Job No.", rec."Job No.");
                        DataJobUnitForProduction.SETFILTER("No. Record", '%1', rec."No.");
                        DataJobUnitForProduction.FILTERGROUP(0);
                        AssociateJUToRecord.SETTABLEVIEW(DataJobUnitForProduction);
                        AssociateJUToRecord.EDITABLE(FALSE);
                        AssociateJUToRecord.LOOKUPMODE(TRUE);
                        AssociateJUToRecord.ReceiveData(Rec, OptionAction::Remove);
                        IF AssociateJUToRecord.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            AssociateJUToRecord.ReturnNumber(NumberParam);
                            IF NumberParam <> 0 THEN
                                MESSAGE(Text0001, NumberParam);
                        END;
                    END;


                }
                separator("separator7")
                {

                }
                action("Finish Record")
                {

                    CaptionML = ENU = '&Finish Record', ESP = '&Finalizar Expediente';
                    RunObject = Codeunit 7207330;
                    Image = ChangeStatus;
                }

            }

        }
        area(Processing)
        {

            action("Print")
            {

                CaptionML = ENU = 'Print', ESP = 'Imprimir';
                Image = Print;
            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Print_Promoted; Print)
                {
                }
                actionref("Job Units_Promoted"; "Job Units")
                {
                }
                actionref("Associate Job Units_Promoted"; "Associate Job Units")
                {
                }
                actionref("Remove Units from Record_Promoted"; "Remove Units from Record")
                {
                }
                actionref("Finish Record_Promoted"; "Finish Record")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.SETRANGE("No.");
    END;



    var
        DataJobUnitForProduction: Record 7207386;
        AssociateJUToRecord: Page 7207573;
        OptionAction: Option "Associate","Remove";
        NumberParam: Integer;
        Text0001: TextConst ENU = 'It has been associated %1 job units', ESP = 'Se han asociado %1 unidades de obra';

    /*begin
    end.
  
*/
}







