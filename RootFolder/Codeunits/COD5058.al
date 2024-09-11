Codeunit 50833 "BankCont-Update 1"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      RMSetup : Record 5079;

    
    //[External]
    PROCEDURE OnModify(VAR BankAcc : Record 270);
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
        SETRANGE("Link to Table","Link to Table"::"Bank Account");
        SETRANGE("No.",BankAcc."No.");
        IF NOT FINDFIRST THEN
          EXIT;
        Cont.GET("Contact No.");
        OldCont := Cont;
      END;

      ContNo := Cont."No.";
      NoSeries := Cont."No. Series";
      SalespersonCode := Cont."Salesperson Code";
      Cont.VALIDATE("E-Mail",BankAcc."E-Mail");
      Cont.TRANSFERFIELDS(BankAcc);
      OnAfterTransferFieldsFromBankAccToCont(Cont,BankAcc);
      Cont."No." := ContNo ;
      Cont."No. Series" := NoSeries;
      Cont."Salesperson Code" := SalespersonCode;
      Cont.VALIDATE(Name);
      Cont.DoModify(OldCont);
      Cont.MODIFY(TRUE);

      BankAcc.GET(BankAcc."No.");
    END;

    //[External]
    PROCEDURE InsertNewContact(VAR BankAcc : Record 270;LocalCall : Boolean);
    VAR
      Cont : Record 5050;
      ContBusRel : Record 5054;
      NoSeriesMgt : Codeunit 396;
    BEGIN
      IF NOT LocalCall THEN BEGIN
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Bank Accs.");
      END;

      WITH Cont DO BEGIN
        INIT;
        TRANSFERFIELDS(BankAcc);
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
        "Business Relation Code" := RMSetup."Bus. Rel. Code for Bank Accs.";
        "Link to Table" := "Link to Table"::"Bank Account";
        "No." := BankAcc."No.";
        INSERT(TRUE);
      END;
    END;

   

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterTransferFieldsFromBankAccToCont(VAR Contact : Record 5050;BankAccount : Record 270);
    BEGIN
    END;

    /* /*BEGIN
END.*/
}







