page 7207452 "Rental Elements Entries List"
{
    CaptionML = ENU = 'Rental Elements Entries List', ESP = 'Lista de movimientos de elemento';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207345;
    DataCaptionFields = "Element No.";
    PageType = List;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Posting Date"; rec."Posting Date")
                {

                }
                field("Rent effective Date"; rec."Rent effective Date")
                {

                }
                field("Piecework Code"; rec."Piecework Code")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Applied Last Date"; rec."Applied Last Date")
                {

                }
                field("Variant Code"; rec."Variant Code")
                {

                }
                field("Entry Type"; rec."Entry Type")
                {

                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Document No."; rec."Document No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Contract No."; rec."Contract No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Element No."; rec."Element No.")
                {

                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Quantity"; rec."Quantity")
                {

                }
                field("Unit Price"; rec."Unit Price")
                {

                }
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Unit of measure"; rec."Unit of measure")
                {

                }
                field("Location code"; rec."Location code")
                {

                }
                field("Return Quantity"; rec."Return Quantity")
                {

                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {

                    Visible = False;
                }
                field("Pending"; rec."Pending")
                {

                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {

                }
                field("Source Code"; rec."Source Code")
                {

                    Visible = False;
                }
                field("Journal Batch Name"; rec."Journal Batch Name")
                {

                    Visible = False;
                }
                field("Applied Entry No."; rec."Applied Entry No.")
                {

                }
                field("Reason Code"; rec."Reason Code")
                {

                    Visible = False;
                }
                field("Return Last Date"; rec."Return Last Date")
                {

                }
                field("Transaction No."; rec."Transaction No.")
                {

                    Visible = False;
                }
                field("Entry No."; rec."Entry No.")
                {

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
                CaptionML = ENU = '&Entries', ESP = '&Movimiento';
                action("action1")
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

        }
        area(Creation)
        {

            action("action2")
            {
                CaptionML = ENU = '&Navigate', ESP = '&Navegar';
                Image = Navigate;


                trigger OnAction()
                VAR
                    Navigate: Page 344;
                BEGIN
                    Navigate.SetDoc(rec."Posting Date", rec."Document No.");
                    Navigate.RUN;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    BEGIN
        //Missing in QUO Db
        // CODEUNIT.RUN(CODEUNIT::60018, Rec);
        EXIT(FALSE);
        
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        IF CloseAction = ACTION::LookupOK THEN
            LookupOKOnPush;
    END;



    var
        Return: Code[20];
    LOCAL procedure LookupOKOnPush();
    begin
        if Return <> '' then
            InsertReturn(Return);
    end;

    procedure InsertReturn(PReturn: Code[20]);
    var
        RentalElementsEntries: Record 7207345;
        HeaderDeliveryReturnElement: Record 7207356;
        LineDeliveryReturnElement: Record 7207357;
        Line: Integer;
    begin
        CurrPage.SETSELECTIONFILTER(RentalElementsEntries);
        if RentalElementsEntries.FINDSET then begin
            HeaderDeliveryReturnElement.GET(Return);
            LineDeliveryReturnElement.SETRANGE(LineDeliveryReturnElement."Document No.", Return);
            if LineDeliveryReturnElement.FINDLAST then
                Line := LineDeliveryReturnElement."Line No." + 10000
            ELSE
                Line := 10000;
            repeat
                RentalElementsEntries.CALCFIELDS(RentalElementsEntries."Return Quantity");
                if RentalElementsEntries."Return Quantity" < RentalElementsEntries.Quantity then begin
                    LineDeliveryReturnElement."Document No." := Return;
                    LineDeliveryReturnElement."Line No." := Line;
                    LineDeliveryReturnElement."Contract Code" := HeaderDeliveryReturnElement."Contract Code";
                    LineDeliveryReturnElement.INSERT(TRUE);
                    LineDeliveryReturnElement.VALIDATE("No.", RentalElementsEntries."Element No.");
                    LineDeliveryReturnElement.VALIDATE("Applicated Entry No.", RentalElementsEntries."Entry No.");
                    LineDeliveryReturnElement.VALIDATE(LineDeliveryReturnElement."Unit of measure", LineDeliveryReturnElement."Unit of measure");
                    LineDeliveryReturnElement.VALIDATE("Unit Price", RentalElementsEntries."Unit Price");
                    LineDeliveryReturnElement.VALIDATE(Quantity, RentalElementsEntries.Quantity - RentalElementsEntries."Return Quantity");
                    LineDeliveryReturnElement."Job No." := RentalElementsEntries."Job No.";
                    LineDeliveryReturnElement."Piecework Code" := LineDeliveryReturnElement."Piecework Code";
                    LineDeliveryReturnElement.MODIFY;
                    Line := Line + 10000;
                end;
            until RentalElementsEntries.NEXT = 0;
        end;
    end;

    procedure ReceivesReturn(PReturn: Code[20]);
    begin
        Return := PReturn;
    end;

    LOCAL procedure LookupOKPush();
    begin
        if Return <> '' then
            InsertReturn(Return);
    end;

    // begin//end
}







