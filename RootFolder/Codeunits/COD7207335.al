Codeunit 7207335 "Creating Contacts"
{
  
  
    trigger OnRun()
BEGIN
          END;

    PROCEDURE CreateContact(QuoteCode : Code[20]) : Code[20];
    VAR
      ComparativeQuoteHeader : Record 7207412;
      ActivityFilter : Code[250];
      ContactCreationWizard : Page 7207604;
    BEGIN
      //JAV 25/07/19: - Cuando creas un contacto, retorna el contacto creado
      IF ComparativeQuoteHeader.GET(QuoteCode) THEN
        ContactCreationWizard.PassActivity(ComparativeQuoteHeader."Activity Filter");

      ContactCreationWizard.RUNMODAL;
      EXIT(ContactCreationWizard.GetContact);
    END;

    PROCEDURE InsertContact(ContactPass : Record 5050);
    VAR
      Contact : Record 5050;
      ContactActivitiesQB : Record 7207430;
      locrecUsuario : Record 91;
      ActivityQB : Record 7207280;
      Text50000 : TextConst ENU='Contact %1 was created',ESP='Se ha creado el contacto %1';
    BEGIN
      Contact.INIT;
      Contact."No." := '';
      Contact."No. Series" := ContactPass."No. Series";
      Contact.INSERT(TRUE);
      Contact.VALIDATE(Name,ContactPass.Name);
      Contact.VALIDATE("Name 2",ContactPass."Name 2");
      Contact.Address := ContactPass.Address;
      Contact."Address 2" := ContactPass."Address 2";
      Contact."Post Code" := ContactPass."Post Code";
      Contact.City := ContactPass.City;
      Contact."Phone No." := ContactPass."Phone No.";
      Contact.County := ContactPass.County;
      Contact."Country/Region Code" := ContactPass."Country/Region Code";
      Contact."VAT Registration No." := ContactPass."VAT Registration No.";
      Contact."Activity Filter" := ContactPass."Activity Filter";
      Contact.MODIFY(TRUE);
      MESSAGE(Text50000,Contact."No.");

      IF Contact."Activity Filter" <> '' THEN BEGIN
        ActivityQB.SETFILTER("Activity Code",Contact."Activity Filter");
        IF ActivityQB.FINDSET THEN
          REPEAT
            CLEAR(ContactActivitiesQB);
            ContactActivitiesQB."Contact No." := Contact."No.";
            ContactActivitiesQB."Activity Code" := ActivityQB."Activity Code";
            ContactActivitiesQB.INSERT;
          UNTIL ActivityQB.NEXT = 0;
      END;
    END;

    PROCEDURE InsertActivitiesOnly(ContactPass : Record 5050);
    VAR
      ActivityQB : Record 7207280;
      ContactActivitiesQB : Record 7207430;
    BEGIN
      IF ContactPass."Activity Filter" <> '' THEN BEGIN
        ActivityQB.SETFILTER("Activity Code",ContactPass."Activity Filter");
        IF ActivityQB.FINDSET THEN
          REPEAT
            CLEAR(ContactActivitiesQB);
            ContactActivitiesQB."Contact No." := ContactPass."No.";
            ContactActivitiesQB."Activity Code" := ActivityQB."Activity Code";
            ContactActivitiesQB.INSERT;
          UNTIL ActivityQB.NEXT = 0;
      END;
    END;

    /*BEGIN
/*{
      //JAV 25/07/19: - Cuando creas un contacto, retorna el contacto creado
    }
END.*/
}







