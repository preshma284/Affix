Codeunit 7206904 "CUST - Subscribers - Codeunits"
{


    trigger OnRun()
    BEGIN
    END;

    LOCAL PROCEDURE "------------------------------------------------------------------------------- KALAM"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 37, OnAfterValidateEvent, "No.", true, true)]
    PROCEDURE T37_OnAfterValidateEvent_No_TSalesLine(VAR Rec: Record 37; VAR xRec: Record 37; CurrFieldNo: Integer);
    BEGIN
        //GAP027
        IF Rec.ISTEMPORARY THEN
            EXIT;

        IF Rec."Document Type" = Rec."Document Type"::"Credit Memo" THEN BEGIN
            //MESSAGE(Rec.Description);
            IF Rec."Unit Price" < 0 THEN BEGIN
                Rec.VALIDATE("Unit Price", -Rec."Unit Price");
                Rec.MODIFY;
            END;
        END;
    END;


    /*BEGIN
    /*{
                        - KALAM GAP027 Added function KALAM_OnAfterValidateNo_TSalesLine
        }
    END.*/
}









