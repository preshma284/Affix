page 7207578 "Comparat. Quote Detail Subfom"
{
    CaptionML = ENU = 'Lines', ESP = 'L�neas';
    MultipleNewLines = true;
    InsertAllowed = false;
    SourceTable = 7207415;
    DelayedInsert = true;
    PopulateAllFields = true;
    PageType = ListPart;
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Type"; rec."Type")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("No."; rec."No.")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Quantity"; rec."Quantity")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Descrip"; "Descrip")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Vendor No."; rec."Vendor No.")
                {

                    Visible = FALSE;
                }
                field("Contact No."; rec."Contact No.")
                {

                    Visible = FALSE;
                    Editable = FALSE;
                }
                field("Estimated Price"; rec."Estimated Price")
                {

                }
                field("EstimatedAmount"; "EstimatedAmount")
                {

                    CaptionML = ENU = 'Estimated Amount', ESP = 'Importe previsto';
                    Editable = FALSE;
                }
                field("Vendor Price"; rec."Vendor Price")
                {

                    Editable = EditVendorPrice;

                    ; trigger OnValidate()
                    BEGIN
                        Rec.CALCFIELDS(rec."Estimated Price");
                        DataPricesVendor.RESET;
                        DataPricesVendor.SETRANGE("Quote Code", rec."Quote Code");
                        DataPricesVendor.SETRANGE("Vendor No.", rec."Vendor No.");
                        DataPricesVendor.SETRANGE(Type, rec.Type);
                        DataPricesVendor.SETRANGE("No.", rec."No.");
                        DataPricesVendor.SETFILTER("Line No.", '<>%1', rec."Line No.");
                        IF DataPricesVendor.FINDSET THEN BEGIN
                            REPEAT
                                DataPricesVendor.VALIDATE("Vendor Price", rec."Vendor Price");
                                IF ComparativeQuoteLines.GET(DataPricesVendor."Quote Code", DataPricesVendor."Line No.") THEN BEGIN
                                    ComparativeQuoteLines.VALIDATE("Estimated Price", rec."Estimated Price");
                                    ComparativeQuoteLines.MODIFY;
                                END;
                                DataPricesVendor.MODIFY;
                            UNTIL DataPricesVendor.NEXT = 0;
                        END;
                        CurrPage.UPDATE;
                    END;


                }
                field("Purchase Amount"; rec."Purchase Amount")
                {

                }
                field("TargetAmount"; "TargetAmount")
                {

                    CaptionML = ENU = 'Target Amount', ESP = 'Importe objetivo';
                    Editable = FALSE

  ;
                }

            }

        }
    }
    trigger OnInit()
    BEGIN
        EditVendorPrice := TRUE;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        IF rec.Type = rec.Type::Item THEN BEGIN
            Item.GET(rec."No.");
            Descrip := Item.Description;
        END;

        IF rec.Type = rec.Type::Resource THEN BEGIN
            Resource.GET(rec."No.");
            Descrip := Resource.Name;
        END;

        ComparativeQuoteLines.RESET;
        ComparativeQuoteLines.SETRANGE("Quote No.", rec."Quote Code");
        ComparativeQuoteLines.SETRANGE("Line No.", rec."Line No.");
        ComparativeQuoteLines.SETRANGE(Type, rec.Type);
        ComparativeQuoteLines.SETRANGE("No.", rec."No.");
        IF ComparativeQuoteLines.FINDFIRST THEN BEGIN
            EstimatedAmount := ComparativeQuoteLines."Estimated Amount";
            TargetAmount := ComparativeQuoteLines."Target Amount";
        END;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec.Type := xRec.Type;
        xRec := Rec;
        //Solo deja modificar el primer precio encontrado del mismo producto o recurso
        DataPricesVendor.RESET;
        DataPricesVendor.SETRANGE("Quote Code", rec."Quote Code");
        DataPricesVendor.SETRANGE("Vendor No.", rec."Vendor No.");
        DataPricesVendor.SETRANGE(Type, rec.Type);
        DataPricesVendor.SETRANGE("No.", rec."No.");
        DataPricesVendor.SETRANGE("Line No.");
        IF DataPricesVendor.FINDFIRST THEN BEGIN
            IF DataPricesVendor."Line No." = rec."Line No." THEN
                EditVendorPrice := TRUE
            ELSE
                EditVendorPrice := FALSE
        END ELSE
            EditVendorPrice := TRUE
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        xRec := Rec;
        //Solo deja modificar el primer precio encontrado del mismo producto o recurso
        DataPricesVendor.RESET;
        DataPricesVendor.SETRANGE("Quote Code", rec."Quote Code");
        DataPricesVendor.SETRANGE("Vendor No.", rec."Vendor No.");
        DataPricesVendor.SETRANGE(Type, rec.Type);
        DataPricesVendor.SETRANGE("No.", rec."No.");
        DataPricesVendor.SETRANGE("Line No.");
        IF DataPricesVendor.FINDFIRST THEN BEGIN
            IF DataPricesVendor."Line No." = rec."Line No." THEN
                EditVendorPrice := TRUE
            ELSE
                EditVendorPrice := FALSE
        END ELSE
            EditVendorPrice := TRUE
    END;



    var
        Item: Record 27;
        Resource: Record 156;
        ComparativeQuoteLines: Record 7207413;
        DataPricesVendor: Record 7207415;
        Descrip: Text;
        EstimatedAmount: Decimal;
        TargetAmount: Decimal;
        EditVendorPrice: Boolean;/*

    begin
    {
      JAV 17/12/2018 Se elimina el tama�o de la variable global rec."Descrip" de tipo texto para evitar un error de desbordamiento
    }
    end.*/


}







