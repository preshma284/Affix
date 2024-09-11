Codeunit 7207301 "QB Bank Acc. Fuctions"
{
  
  
    trigger OnRun()
BEGIN
          END;

    PROCEDURE CalcularIBAN(pPais : Code[3];pCta : Code[20]) : Code[30];
    VAR
      IBANaux : Code[60];
      DC : Code[2];
      Error001 : TextConst ESP='No ha indicado Pais';
      Resto : Integer;
      Numero : Integer;
      i : Integer;
    BEGIN
      //Calcular el IBAN de una cuenta
      IF pCta = '' THEN
        EXIT('');

      IF pPais = '' THEN
        pPais := 'ES';

      IBANaux := pCta + auxLetrasIBAN(COPYSTR(pPais,1,1)) + auxLetrasIBAN(COPYSTR(pPais,2,1))  + '00';

      Resto := 0;
      FOR i := 1 TO STRLEN(IBANaux) DO BEGIN
        EVALUATE(Numero, COPYSTR(IBANaux, i, 1));
        Resto := (Resto * 10 + Numero) MOD 97;
      END;

      DC := FORMAT(98 - Resto);
      IF STRLEN(DC) = 1 THEN
        DC := '0' + DC;

      EXIT(pPais + DC + pCta);
    END;

    LOCAL PROCEDURE auxLetrasIBAN(parCodeLetra : Text[1]) : Code[2];
    BEGIN
      CASE parCodeLetra OF
        'A': EXIT('10');
        'B': EXIT('11');
        'C': EXIT('12');
        'D': EXIT('13');
        'E': EXIT('14');
        'F': EXIT('15');
        'G': EXIT('16');
        'H': EXIT('17');
        'I': EXIT('18');
        'J': EXIT('19');
        'K': EXIT('20');
        'L': EXIT('21');
        'M': EXIT('22');
        'N': EXIT('23');
        'O': EXIT('24');
        'P': EXIT('25');
        'Q': EXIT('26');
        'R': EXIT('27');
        'S': EXIT('28');
        'T': EXIT('29');
        'U': EXIT('30');
        'V': EXIT('31');
        'W': EXIT('32');
        'X': EXIT('33');
        'Y': EXIT('34');
        'Z': EXIT('35');
      END;
      EXIT('00');
    END;

    PROCEDURE VerificarCCC(p_banco : Text[4];P_oficina : Text[4];p_Digcontrol : Text[2];p_cuenta : Text[10]) : Boolean;
    VAR
      Locdc1 : Integer;
      Locdc2 : Integer;
      LocAPesos : ARRAY [10] OF Integer;
      Locdigito : Integer;
      LocResto : Integer;
      VarArraybancoyoficina : ARRAY [8] OF Integer;
      VarArrayCuenta : ARRAY [10] OF Integer;
      digitocorrectocontrol : Text[2];
      i : Integer;
      introduzca : TextConst ESP='''introduzca la cuenta';
      Error001 : TextConst ESP='El c�digo de control debe ser %1';
    BEGIN
      //Calcular si el CCC de una cuenta es correcto
      IF (p_banco = '') OR (P_oficina = '') OR (p_cuenta = '') THEN
        EXIT(FALSE);

      FOR i := 1 TO 8 DO
        EVALUATE(VarArraybancoyoficina[i],COPYSTR(p_banco+P_oficina,i,1));

      FOR i := 1 TO 10 DO
        EVALUATE(VarArrayCuenta[i],COPYSTR(p_cuenta,i,1));

      LocAPesos[1]  :=  1;
      LocAPesos[2]  :=  2;
      LocAPesos[3]  :=  4;
      LocAPesos[4]  :=  8;
      LocAPesos[5]  :=  5;
      LocAPesos[6]  := 10;
      LocAPesos[7]  :=  9;
      LocAPesos[8]  :=  7;
      LocAPesos[9]  :=  3;
      LocAPesos[10] :=  6;

      // D�gito control Entidad-Oficina
      Locdc1 := 0;
      FOR i:= 8 DOWNTO 1 DO
        Locdc1 += LocAPesos[i+2] * VarArraybancoyoficina[i];

      Locdc1 := 11 - (Locdc1 MOD 11);
      IF (Locdc1 =10) THEN Locdc1 := 1;
      IF (Locdc1 =11) THEN Locdc1 := 0;

      // D�gito control Cuenta
      Locdc2 := 0;
      FOR i:= 10 DOWNTO 1 DO
       Locdc2 += LocAPesos[i] * VarArrayCuenta[i];

      Locdc2 := 11 - (Locdc2 MOD 11);
      IF (Locdc2=10) THEN Locdc2 := 1;
      IF (Locdc2=11) THEN Locdc2 := 0;

      digitocorrectocontrol := FORMAT(Locdc1)+FORMAT(Locdc2);   // los 2 n�meros del D.C.

      IF p_Digcontrol <> digitocorrectocontrol THEN BEGIN
        MESSAGE(Error001,digitocorrectocontrol);
        EXIT(FALSE);
      END ELSE
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE "---------------------- EVENTOS"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Table, 270, OnAfterValidateEvent, "CCC Bank No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCBankNo_TBankAccount(VAR Rec : Record 270;VAR xRec : Record 270;CurrFieldNo : Integer);
    BEGIN
      Validate_BankAccount(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 270, OnAfterValidateEvent, "CCC Bank Branch No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCBankBranchNo_TBankAccount(VAR Rec : Record 270;VAR xRec : Record 270;CurrFieldNo : Integer);
    BEGIN
      Validate_BankAccount(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 270, OnAfterValidateEvent, "CCC Control Digits", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCControlDigits_TBankAccount(VAR Rec : Record 270;VAR xRec : Record 270;CurrFieldNo : Integer);
    BEGIN
      Validate_BankAccount(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 270, OnAfterValidateEvent, "CCC Bank Account No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCBankAccountNo_TBankAccount(VAR Rec : Record 270;VAR xRec : Record 270;CurrFieldNo : Integer);
    BEGIN
      Validate_BankAccount(Rec);
    END;

    [EventSubscriber(ObjectType::Table, 270, OnAfterValidateEvent, "CCC No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCNo_TBankAccount(VAR Rec : Record 270;VAR xRec : Record 270;CurrFieldNo : Integer);
    BEGIN
      Validate_BankAccount(Rec);
    END;

    LOCAL PROCEDURE Validate_BankAccount(VAR Rec : Record 270);
    BEGIN
      //JAV 03/07/19: Verificar el CCC y montar el IBAN si es correcto
      IF VerificarCCC(Rec."CCC Bank No.", Rec."CCC Bank Branch No.", Rec."CCC Control Digits", Rec."CCC Bank Account No.") THEN
        Rec.IBAN := CalcularIBAN(Rec."Country/Region Code", Rec."CCC No.");
    END;

    // [EventSubscriber(ObjectType::Table, 287, OnAfterValidateEvent, "CCC Bank No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCBankNo_TCustomerBankAccount(VAR Rec : Record 287;VAR xRec : Record 287;CurrFieldNo : Integer);
    BEGIN
      Validate_CustomerBankAccount(Rec);
    END;

    // [EventSubscriber(ObjectType::Table, 287, OnAfterValidateEvent, "CCC Bank Branch No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCBankBranchNo_TCustomerBankAccount(VAR Rec : Record 287;VAR xRec : Record 287;CurrFieldNo : Integer);
    BEGIN
      Validate_CustomerBankAccount(Rec);
    END;

    // [EventSubscriber(ObjectType::Table, 287, OnAfterValidateEvent, "CCC Control Digits", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCControlDigits_TCustomerBankAccount(VAR Rec : Record 287;VAR xRec : Record 287;CurrFieldNo : Integer);
    BEGIN
      Validate_CustomerBankAccount(Rec);
    END;

    // [EventSubscriber(ObjectType::Table, 287, OnAfterValidateEvent, "CCC Bank Account No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCBankAccountNo_TCustomerBankAccount(VAR Rec : Record 287;VAR xRec : Record 287;CurrFieldNo : Integer);
    BEGIN
      Validate_CustomerBankAccount(Rec);
    END;

    // [EventSubscriber(ObjectType::Table, 287, OnAfterValidateEvent, "CCC No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCNo_TCustomerBankAccount(VAR Rec : Record 287;VAR xRec : Record 287;CurrFieldNo : Integer);
    BEGIN
      Validate_CustomerBankAccount(Rec);
    END;

    LOCAL PROCEDURE Validate_CustomerBankAccount(VAR Rec : Record 287);
    BEGIN
      //JAV 03/07/19: Verificar el CCC y montar el IBAN si es correcto
      // IF VerificarCCC(Rec."CCC Bank No.", Rec."CCC Bank Branch No.", Rec."CCC Control Digits", Rec."CCC Bank Account No.") THEN
      //   Rec.IBAN := CalcularIBAN(Rec."Country/Region Code", Rec."CCC No.");
    END;

    // [EventSubscriber(ObjectType::Table, 288, OnAfterValidateEvent, "CCC Bank No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCBankNo_TVendorBankAccount(VAR Rec : Record 288;VAR xRec : Record 288;CurrFieldNo : Integer);
    BEGIN
      Validate_VendorBankAccount(Rec);
    END;

    // [EventSubscriber(ObjectType::Table, 288, OnAfterValidateEvent, "CCC Bank Branch No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCBankBranchNo_TVendorBankAccount(VAR Rec : Record 288;VAR xRec : Record 288;CurrFieldNo : Integer);
    BEGIN
      Validate_VendorBankAccount(Rec);
    END;

    // [EventSubscriber(ObjectType::Table, 288, OnAfterValidateEvent, "CCC Control Digits", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCControlDigits_TVendorBankAccount(VAR Rec : Record 288;VAR xRec : Record 288;CurrFieldNo : Integer);
    BEGIN
      Validate_VendorBankAccount(Rec);
    END;

    // [EventSubscriber(ObjectType::Table, 288, OnAfterValidateEvent, "CCC Bank Account No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCBankAccountNo_TVendorBankAccount(VAR Rec : Record 288;VAR xRec : Record 288;CurrFieldNo : Integer);
    BEGIN
      Validate_VendorBankAccount(Rec);
    END;

    // [EventSubscriber(ObjectType::Table, 288, OnAfterValidateEvent, "CCC No.", true, true)]
    LOCAL PROCEDURE OnAfterValidateEvent_CCCNo_TVendorBankAccount(VAR Rec : Record 288;VAR xRec : Record 288;CurrFieldNo : Integer);
    BEGIN
      Validate_VendorBankAccount(Rec);
    END;

    LOCAL PROCEDURE Validate_VendorBankAccount(VAR Rec : Record 288);
    BEGIN
      //JAV 03/07/19: Verificar el CCC y montar el IBAN si es correcto
      // IF VerificarCCC(Rec."CCC Bank No.", Rec."CCC Bank Branch No.", Rec."CCC Control Digits", Rec."CCC Bank Account No.") THEN
      //   Rec.IBAN := CalcularIBAN(Rec."Country/Region Code", Rec."CCC No.");
    END;

    /*BEGIN
/*{
      JAV 02/07/19 Para manjo de cuentas de los bancos
    }
END.*/
}







