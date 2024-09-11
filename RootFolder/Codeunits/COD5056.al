Codeunit 50831 "CustCont-Update 1"
{


    trigger OnRun()
    BEGIN
    END;

    VAR
        RMSetup: Record 5079;

    //[External]
    PROCEDURE OnInsert(VAR Cust: Record 18);
    BEGIN
        RMSetup.GET;
        IF RMSetup."Bus. Rel. Code for Customers" = '' THEN
            EXIT;

        InsertNewContact(Cust, TRUE);
    END;

    //[External]
    PROCEDURE OnModify(VAR Cust: Record 18);
    VAR
        ContBusRel: Record 5054;
        Cont: Record 5050;
        OldCont: Record 5050;
        IdentityManagement: Codeunit 9801;
        IdentityManagement1: Codeunit 51289;
        ContNo: Code[20];
        NoSeries: Code[20];
    BEGIN
        WITH ContBusRel DO BEGIN
            SETCURRENTKEY("Link to Table", "No.");
            SETRANGE("Link to Table", "Link to Table"::Customer);
            SETRANGE("No.", Cust."No.");
            IF NOT FINDFIRST THEN
                EXIT;
            Cont.GET("Contact No.");
            OldCont := Cont;
        END;

        ContNo := Cont."No.";
        NoSeries := Cont."No. Series";
        Cont.VALIDATE("E-Mail", Cust."E-Mail");
        Cont.TRANSFERFIELDS(Cust);
        OnAfterTransferFieldsFromCustToCont(Cont, Cust);
        Cont."No." := ContNo;
        Cont."No. Series" := NoSeries;
        IF NOT IdentityManagement1.IsInvAppId THEN
            Cont.Type := OldCont.Type;
        Cont.VALIDATE(Name);
        Cont.DoModify(OldCont);
        Cont.MODIFY(TRUE);

        Cust.GET(Cust."No.");
    END;

    //[External]
    PROCEDURE OnDelete(VAR Cust: Record 18);
    VAR
        ContBusRel: Record 5054;
    BEGIN
        WITH ContBusRel DO BEGIN
            SETCURRENTKEY("Link to Table", "No.");
            SETRANGE("Link to Table", "Link to Table"::Customer);
            SETRANGE("No.", Cust."No.");
            DELETEALL(TRUE);
        END;
    END;

    //[External]
    PROCEDURE InsertNewContact(VAR Cust: Record 18; LocalCall: Boolean);
    VAR
        ContBusRel: Record 5054;
        Cont: Record 5050;
        NoSeriesMgt: Codeunit 396;
    BEGIN
        IF NOT LocalCall THEN BEGIN
            RMSetup.GET;
            RMSetup.TESTFIELD("Bus. Rel. Code for Customers");
        END;

        IF ContBusRel.UpdateEmptyNoForContact(Cust."No.", Cust."Primary Contact No.", ContBusRel."Link to Table"::Customer) THEN
            EXIT;

        WITH Cont DO BEGIN
            INIT;
            TRANSFERFIELDS(Cust);
            OnAfterTransferFieldsFromCustToCont(Cont, Cust);
            VALIDATE(Name);
            VALIDATE("E-Mail");
            "No." := '';
            "No. Series" := '';
            RMSetup.TESTFIELD("Contact Nos.");
            NoSeriesMgt.InitSeries(RMSetup."Contact Nos.", '', 0D, "No.", "No. Series");
            Type := Type::Company;
            TypeChange;
            SetSkipDefault;
            INSERT(TRUE);
        END;

        WITH ContBusRel DO BEGIN
            INIT;
            "Contact No." := Cont."No.";
            "Business Relation Code" := RMSetup."Bus. Rel. Code for Customers";
            "Link to Table" := "Link to Table"::Customer;
            "No." := Cust."No.";
            INSERT(TRUE);
        END;
    END;

    //[External]
    PROCEDURE InsertNewContactPerson(VAR Cust: Record 18; LocalCall: Boolean);
    VAR
        ContComp: Record 5050;
        ContBusRel: Record 5054;
        Cont: Record 5050;
    BEGIN
        IF NOT LocalCall THEN BEGIN
            RMSetup.GET;
            RMSetup.TESTFIELD("Bus. Rel. Code for Customers");
        END;

        ContBusRel.SETCURRENTKEY("Link to Table", "No.");
        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("No.", Cust."No.");
        IF ContBusRel.FINDFIRST THEN
            IF ContComp.GET(ContBusRel."Contact No.") THEN
                WITH Cont DO BEGIN
                    INIT;
                    "No." := '';
                    VALIDATE(Type, Type::Person);
                    INSERT(TRUE);
                    "Company No." := ContComp."No.";
                    VALIDATE(Name, Cust.Contact);
                    InheritCompanyToPersonData(ContComp);
                    MODIFY(TRUE);
                    Cust."Primary Contact No." := "No.";
                END
    END;

    
    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterTransferFieldsFromCustToCont(VAR Contact: Record 5050; Customer: Record 18);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







