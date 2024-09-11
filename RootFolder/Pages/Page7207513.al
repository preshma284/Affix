page 7207513 "Bill of Items Piec by Job Card"
{
    CaptionML = ENU = 'Bill of Item Cost Data', ESP = 'Datos de descompuesto de Coste';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    PopulateAllFields = true;
    PageType = Document;

    layout
    {
        area(content)
        {
            group("group4")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Piecework Code"; rec."Piecework Code")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                }
                field("Price Subcontracting Cost"; rec."Price Subcontracting Cost")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Initial Produc. Price"; rec."Initial Produc. Price")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Contract Price"; rec."Contract Price")
                {

                    Editable = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }

            }
            part("PG_BillOfItems"; 7207515)
            {

                SubPageView = SORTING("Job No.", "Piecework Code", "Cod. Budget", "Cost Type", "No.");
                SubPageLink = "Job No." = FIELD("Job No."), "Piecework Code" = FIELD("Piecework Code"), "Cod. Budget" = FIELD("Budget Filter");
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Job Unit', ESP = 'Unidad de obra';

            }
        }
    }
    trigger OnModifyRecord(): Boolean
    BEGIN
        Modi := TRUE;
    END;



    var
        BillofItemData: Record 7207384;
        JobsUnits: Record 7207277;
        // CalculateJobUnitCost: Report 7207273;
        Cost: Decimal;
        Text001: TextConst ENU = 'No bill of item is defined for highers', ESP = 'No se definen descompuestos para mayores de unidad de obra';
        Modi: Boolean;

    /*begin
    end.
  
*/
}







