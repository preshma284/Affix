page 7207669 "QB Debit Relations Closed"
{
  ApplicationArea=All;

    CaptionML = ESP = 'Relaciones de Cobros Registradas';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = 7206919;
    SourceTableView = SORTING("Relacion No.")
                    WHERE("Closed" = CONST(true));
    PageType = List;
    CardPageID = "QB Debit Relations Header";

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Relacion No."; rec."Relacion No.")
                {

                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Job Desription"; rec."Job Desription")
                {

                }
                field("Customer No."; rec."Customer No.")
                {

                }
                field("Customer Name"; rec."Customer Name")
                {

                }
                field("Closed"; rec."Closed")
                {

                    Visible = false;
                }
                field("Date"; rec."Date")
                {

                }
                field("Amount"; rec."Amount")
                {

                    Visible = false;
                }
                field("Amount Invoiced"; rec."Amount Invoiced")
                {

                }
                field("Amount Received"; rec."Amount Received")
                {

                }
                field("Amount Invoiced - Amount Received"; rec."Amount Invoiced" - rec."Amount Received")
                {

                    CaptionML = ESP = 'Importe Pendiente';
                }

            }

        }
    }
    trigger OnInit()
    BEGIN
        QBRelationshipSetup.GET();
        IF NOT QBRelationshipSetup."RC Use Debit Relations" THEN
            ERROR(Text00);
    END;



    var
        QBRelationshipSetup: Record 7207335;
        Text00: TextConst ENU = 'This option is not active', ESP = 'Esta opci�n no est� activa';

    /*begin
    end.
  
*/
}








