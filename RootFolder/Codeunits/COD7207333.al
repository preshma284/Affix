Codeunit 7207333 "Comparative Quote Functions"
{
  
  
    trigger OnRun()
BEGIN
          END;

    PROCEDURE AddContactsToActivity(VAR ComparativeQuoteHeaderPass : Record 7207412);
    VAR
      Contact : Record 5050;
      ContactActivitiesQB : Record 7207430;
      AreaActivity : Text;
      Finalize : Boolean;
      ContactList : Page 5052;
    BEGIN
      //JAV 07/11/22: - QB 1.12.15 Evitar errores de desbordamiento en actividades, se cambia la variable local AreaActivity de code[250] a Text
      CLEAR(Contact);
      CLEAR(ContactList);
      Contact.SETRANGE(Type,Contact.Type::Company);
      ContactList.SETTABLEVIEW(Contact);
      ContactList.LOOKUPMODE(TRUE);
      IF ContactList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        ContactList.SelectContact(Contact);
        IF Contact.FINDSET THEN
          REPEAT
            AreaActivity := COPYSTR(ComparativeQuoteHeaderPass."Activity Filter", 1, MAXSTRLEN(AreaActivity));
            Finalize := FALSE;
            REPEAT
              IF STRPOS(AreaActivity,'|') <> 0 THEN BEGIN
                CLEAR(ContactActivitiesQB);
                ContactActivitiesQB."Contact No." := Contact."No.";
                ContactActivitiesQB."Activity Code" := COPYSTR(AreaActivity,1,STRPOS(AreaActivity,'|')-1);
                IF ContactActivitiesQB.INSERT THEN;
                AreaActivity := COPYSTR(AreaActivity,STRPOS(AreaActivity,'|')+1);
                IF AreaActivity = '' THEN
                  Finalize := TRUE;
              END ELSE BEGIN
                ContactActivitiesQB."Contact No." := Contact."No.";
                ContactActivitiesQB."Activity Code" := AreaActivity;
                IF ContactActivitiesQB.INSERT THEN;
                Finalize := TRUE;
              END;
            UNTIL Finalize;

            ContactActivitiesQB.SETRANGE("Contact No.",Contact."No.");
            IF ContactActivitiesQB.FINDSET(FALSE) THEN BEGIN
              AreaActivity := '';
              Finalize := FALSE;
              REPEAT
                IF ContactActivitiesQB.NEXT = 0 THEN BEGIN
                  Finalize := TRUE;
                  AreaActivity := AreaActivity + ContactActivitiesQB."Activity Code";
                END ELSE BEGIN
                  AreaActivity := AreaActivity + ContactActivitiesQB."Activity Code" + '|';
                END;
              UNTIL Finalize;
              Contact."Activity Filter" := AreaActivity;
              Contact.MODIFY;
            END;
          UNTIL Contact.NEXT = 0;
      END;
    END;

    PROCEDURE MoveFromQuoteToJob(ComparativeQuoteHeader : Record 7207412);
    VAR
      Quote : Record 167;
      ComparativeQuoteLines : Record 7207413;
      DataPricesVendor : Record 7207415;
      Text0003 : TextConst ENU='The Job is not generated',ESP='El proyecto no est  generado';
      Text0004 : TextConst ENU='Comparative has been transferred to Job %1',ESP='Se ha traspasado el comparativo al proyecto %1';
    BEGIN
      Quote.GET(ComparativeQuoteHeader."Job No.");
      IF Quote."Generated Job" = '' THEN
        ERROR(Text0003);

      //Cambiamos la cabecera  TO-DO: Revisar el tema de las dimensiones
      ComparativeQuoteHeader."Job No." := Quote."Generated Job";
      ComparativeQuoteHeader.MODIFY;

      //Cambiamos las l¡neas
      ComparativeQuoteLines.SETRANGE("Quote No.", ComparativeQuoteHeader."No.");
      IF ComparativeQuoteLines.FINDSET(TRUE) THEN
        REPEAT
          ComparativeQuoteLines."Job No." := Quote."Generated Job";
          ComparativeQuoteLines.MODIFY;
        UNTIL ComparativeQuoteLines.NEXT = 0;

      //Cambiamos las condiciones
      DataPricesVendor.SETRANGE("Quote Code", ComparativeQuoteHeader."No.");
      IF DataPricesVendor.FINDSET(TRUE) THEN
        REPEAT
          DataPricesVendor."Job No." := Quote."Generated Job";
          DataPricesVendor.MODIFY;
        UNTIL DataPricesVendor.NEXT = 0;

      MESSAGE(Text0004,Quote."Generated Job");
    END;

    /*BEGIN
/*{
      JAV 07/11/22: - QB 1.12.15 Evitar errores de desbordamiento en actividades
    }
END.*/
}







