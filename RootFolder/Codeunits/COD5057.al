Codeunit 50832 "VendCont-Update 1"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      RMSetup : Record 5079;

    //[External]
    PROCEDURE OnInsert(VAR Vend : Record 23);
    BEGIN
      RMSetup.GET;
      IF RMSetup."Bus. Rel. Code for Vendors" = '' THEN
        EXIT;

      InsertNewContact(Vend,TRUE);
    END;

    //[External]
    PROCEDURE OnModify(VAR Vend : Record 23);
    VAR
      Cont : Record 5050;
      OldCont : Record 5050;
      ContBusRel : Record 5054;
      ContNo : Code[20];
      NoSeries : Code[20];
      SalespersonCode : Code[20];
    BEGIN
      WITH ContBusRel DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::Vendor);
        SETRANGE("No.",Vend."No.");
        IF NOT FINDFIRST THEN
          EXIT;
        Cont.GET("Contact No.");
        OldCont := Cont;
      END;

      ContNo := Cont."No.";
      NoSeries := Cont."No. Series";
      SalespersonCode := Cont."Salesperson Code";
      Cont.VALIDATE("E-Mail",Vend."E-Mail");
      Cont.TRANSFERFIELDS(Vend);
      OnAfterTransferFieldsFromVendToCont(Cont,Vend);
      Cont."No." := ContNo ;
      Cont."No. Series" := NoSeries;
      Cont."Salesperson Code" := SalespersonCode;
      Cont.VALIDATE(Name);
      Cont.DoModify(OldCont);
      Cont.MODIFY(TRUE);

      Vend.GET(Vend."No.");
    END;

    //[External]
    PROCEDURE OnDelete(VAR Vend : Record 23);
    VAR
      ContBusRel : Record 5054;
    BEGIN
      WITH ContBusRel DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::Vendor);
        SETRANGE("No.",Vend."No.");
        DELETEALL(TRUE);
      END;
    END;

    //[External]
    PROCEDURE InsertNewContact(VAR Vend : Record 23;LocalCall : Boolean);
    VAR
      Cont : Record 5050;
      ContBusRel : Record 5054;
      NoSeriesMgt : Codeunit 396;
    BEGIN
      IF NOT LocalCall THEN BEGIN
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");
      END;

      IF ContBusRel.UpdateEmptyNoForContact(Vend."No.",Vend."Primary Contact No.",ContBusRel."Link to Table"::Vendor) THEN
        EXIT;

      WITH Cont DO BEGIN
        INIT;
        TRANSFERFIELDS(Vend);
        VALIDATE(Name);
        VALIDATE("E-Mail");
        "No." := '';
        "No. Series" := '';
        RMSetup.TESTFIELD("Contact Nos.");
        NoSeriesMgt.InitSeries(RMSetup."Contact Nos.",'',0D,"No.","No. Series");
        Type := Type::Company;
        TypeChange;
        SetSkipDefault;
        INSERT(TRUE);
      END;

      WITH ContBusRel DO BEGIN
        INIT;
        "Contact No." := Cont."No.";
        "Business Relation Code" := RMSetup."Bus. Rel. Code for Vendors";
        "Link to Table" := "Link to Table"::Vendor;
        "No." := Vend."No.";
        INSERT(TRUE);
      END;
    END;

    //[External]
    PROCEDURE InsertNewContactPerson(VAR Vend : Record 23;LocalCall : Boolean);
    VAR
      Cont : Record 5050;
      ContComp : Record 5050;
      ContBusRel : Record 5054;
    BEGIN
      IF NOT LocalCall THEN BEGIN
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");
      END;

      ContBusRel.SETCURRENTKEY("Link to Table","No.");
      ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
      ContBusRel.SETRANGE("No.",Vend."No.");
      IF ContBusRel.FINDFIRST THEN
        IF ContComp.GET(ContBusRel."Contact No.") THEN
          WITH Cont DO BEGIN
            INIT;
            "No." := '';
            INSERT(TRUE);
            "Company No." := ContComp."No.";
            Type := Type::Person;
            VALIDATE(Name,Vend.Contact);
            InheritCompanyToPersonData(ContComp);
            MODIFY(TRUE);
            Vend."Primary Contact No." := "No.";
          END
    END;

    

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterTransferFieldsFromVendToCont(VAR Contact : Record 5050;Vendor : Record 23);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







