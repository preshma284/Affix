Codeunit 50007 "Resource-Find Price 1"
{


    TableNo = 201;
    trigger OnRun()
    BEGIN
        ResPrice.COPY(Rec);
        WITH ResPrice DO
            IF FindResPrice THEN
                ResPrice := ResPrice2
            ELSE BEGIN
                INIT;
                Code := Res."No.";
                "Currency Code" := '';
                "Unit Price" := Res."Unit Price";
            END;
        Rec := ResPrice;
    END;

    VAR
        ResPrice: Record 201;
        ResPrice2: Record 201;
        Res: Record 156;

    LOCAL PROCEDURE FindResPrice(): Boolean;
    VAR
        QBCodeunitPublisher: Codeunit 7207352;
        AnswerPar: Boolean;
    BEGIN
        QBCodeunitPublisher.OnFindResPriceNewResourceFindPrice(ResPrice, ResPrice2, AnswerPar);
        EXIT(AnswerPar); //QB

        WITH ResPrice DO BEGIN
            IF ResPrice2.GET(Type::Resource, Code, "Work Type Code", "Currency Code") THEN
                EXIT(TRUE);

            IF ResPrice2.GET(Type::Resource, Code, "Work Type Code", '') THEN
                EXIT(TRUE);

            Res.GET(Code);
            IF ResPrice2.GET(Type::"Group(Resource)", Res."Resource Group No.", "Work Type Code", "Currency Code") THEN
                EXIT(TRUE);

            IF ResPrice2.GET(Type::"Group(Resource)", Res."Resource Group No.", "Work Type Code", '') THEN
                EXIT(TRUE);

            IF ResPrice2.GET(Type::All, '', "Work Type Code", "Currency Code") THEN
                EXIT(TRUE);

            IF ResPrice2.GET(Type::All, '', "Work Type Code", '') THEN
                EXIT(TRUE);
        END;

        OnAfterFindResPrice(ResPrice, Res);
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterFindResPrice(VAR ResourcePrice: Record 201; Resource: Record 156);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







