Codeunit 7207296 "Cost Piecework Job-Ident"
{
  
  
    trigger OnRun()
BEGIN
          END;
    VAR
      Text000 : TextConst ENU='This function checks the consistency of and completes the Chart of Accounts:\\',ESP='Se comprueba para el presupuesto que:\';
      Text001 : TextConst ENU='- Checks that a corresponding balance account exists for every posting account.\',ESP='"  - Cada unidad auxiliar tiene su correspondiente mayor.\"';
      Text002 : TextConst ENU='- Checks that all accounts comply with the Chart of Account account length requisites.\',ESP='"  - Cada unidad tiene un c�digo adecuado.\"';
      Text003 : TextConst ENU='- Assigns values to the following fields: Income/Balance, Account Type, Indentation, Totaling and Debit/Credit.\',ESP='"  - Se calculan  valores para: Tipo cuenta,  Indentar y  Sumatorio .\"';
      Text004 : TextConst ENU='- Assigns values to the following fields: Income/Balance, Account Type, Indentation, Totaling and Debit/Credit.\',ESP='"  - Se verifican las que no est�n marcadas de coste ni de venta .\"';
      Text005 : TextConst ENU='Do you wish to check the Chart of Accounts?',ESP='\�Confirma que desea comprobar el presupuesto?';
      Text010 : TextConst ENU='Checking the Chart of Accounts #1########## @@@@@@@@@@@@@',ESP='Comprobando el presupuesto #1########## @@@@@@@@@@@@@';
      Text011 : TextConst ENU='The Chart of Accounts is correct.',ESP='El presupuesto es correcto.';
      Text012 : TextConst ESP='El presupuesto es correcto. Se han marcado como de coste %1 unidades que no ten�an marcado coste ni venta.';
      Text020 : TextConst ENU='The length of a heading account cannot be greater than 8, account %1',ESP='La longitud del c�digo no puede ser mayor que %1 para la U.O. %2';
      Text021 : TextConst ENU='The length of account %1 cannot be different than the next one�s',ESP='La longitud de la unidad de obra %1 no puede ser diferente de la siguiente';
      Text022 : TextConst ESP='Advertencia: La U.O. %1 que es de mayor no tiene partidas';
      Text023 : TextConst ESP='El cap�tulo %1 tiene descompuestos, cambielo a partida o elimne estos';
      NotSeeMessages : Boolean;

    PROCEDURE Process(pJobNo : Code[20];pBudget : Code[20];pTipo: Option "Preciario","Proyecto");
    VAR
      Datos : ARRAY [20] OF Integer;
      Valor : ARRAY [2] OF Text;
      Piecework : Record 7207277;
      DataPieceworkForProduction : Record 7207386;
      DataCostByPiecework : Record 7207387;
      BillofItemData : Record 7207384;
    BEGIN
      IF (NotSeeMessages = FALSE) THEN BEGIN
        IF NOT CONFIRM(Text000 + Text001 + Text002 + Text003 + Text004 + Text005,TRUE) THEN
          EXIT;
      END;

      CASE pTipo OF
        pTipo::Preciario :
          BEGIN
            Datos[ 1] := DATABASE::Piecework;
            Datos[ 2] := Piecework.FIELDNO(Piecework."Cost Database Default");
            Datos[ 3] := Piecework.FIELDNO("No.");
            Datos[ 4] := Piecework.FIELDNO("Account Type");
            Datos[ 5] := Piecework.FIELDNO(Identation);
            Datos[ 6] := Piecework.FIELDNO(Description);
            Datos[ 7] := Piecework.FIELDNO("Unique Code");
            Datos[ 8] := Piecework.FIELDNO(Title);
            Datos[ 9] := Piecework.FIELDNO(Totaling);
            Datos[10] := DATABASE::"Bill of Item Data";
            Datos[11] := BillofItemData.FIELDNO("Cod. Cost database");
            Datos[12] := BillofItemData.FIELDNO("Cod. Piecework");
            Datos[13] := 0;
            Datos[14] := Piecework.FIELDNO("Unit Type");
            Datos[15] := 0;
            Datos[16] := 0;
            Valor[ 1] := FORMAT(Piecework."Account Type"::Heading);
            Valor[ 2] := FORMAT(Piecework."Account Type"::Unit);
          END;
        pTipo::Proyecto :
          BEGIN
            Datos[ 1] := DATABASE::"Data Piecework For Production";
            Datos[ 2] := DataPieceworkForProduction.FIELDNO("Job No.");
            Datos[ 3] := DataPieceworkForProduction.FIELDNO("Piecework Code");
            Datos[ 4] := DataPieceworkForProduction.FIELDNO("Account Type");
            Datos[ 5] := DataPieceworkForProduction.FIELDNO(Indentation);
            Datos[ 6] := DataPieceworkForProduction.FIELDNO(Description);
            Datos[ 7] := DataPieceworkForProduction.FIELDNO("Unique Code");
            Datos[ 8] := DataPieceworkForProduction.FIELDNO(Title);
            Datos[ 9] := DataPieceworkForProduction.FIELDNO(Totaling);
            Datos[10] := DATABASE::"Data Cost By Piecework";
            Datos[11] := DataCostByPiecework.FIELDNO("Job No.");
            Datos[12] := DataCostByPiecework.FIELDNO("Piecework Code");
            Datos[13] := DataCostByPiecework.FIELDNO("Cod. Budget");
            Datos[14] := DataPieceworkForProduction.FIELDNO(Type);
            Datos[15] := DataPieceworkForProduction.FIELDNO("Production Unit");
            Datos[16] := DataPieceworkForProduction.FIELDNO("Customer Certification Unit");
            Valor[ 1] := FORMAT(DataPieceworkForProduction."Account Type"::Heading);
            Valor[ 2] := FORMAT(DataPieceworkForProduction."Account Type"::Unit);
          END;
      END;

      Ident(pJobNo, pBudget, Datos, Valor);

      NotSeeMessages := FALSE;
    END;

    LOCAL PROCEDURE Ident(pJobNo : Code[20];pBudget : Code[20];pDatos : ARRAY [20] OF Integer;pValor : ARRAY [2] OF Text);
    VAR
      TxtAux : Text;
      RecRef : RecordRef;
      FieldRef2 : FieldRef;
      FieldRef3 : FieldRef;
      FieldRef15 : FieldRef;
      FieldRef16 : FieldRef;
      Window : Dialog;
      LineCounter : Integer;
      NoOfRecords : Integer;
      Inicio : Code[20];
      nUdAsociadas : Integer;
    BEGIN
      RecRef.OPEN(pDatos[1]);
      FieldRef2 := RecRef.FIELD(pDatos[2]);  // Job No.
      FieldRef3 := RecRef.FIELD(pDatos[3]);  // Piecework Code
      IF (pDatos[1] = DATABASE::"Data Piecework For Production") THEN BEGIN
        FieldRef15 := RecRef.FIELD(pDatos[15]); // Unidad producci�n
        FieldRef16 := RecRef.FIELD(pDatos[16]); // Unidad certificacion
      END;

      Window.OPEN(Text010);
      Window.UPDATE(1, pJobNo);


      Inicio := '';
      LineCounter := 0;
      nUdAsociadas := 0;

      RecRef.RESET;
      FieldRef2.SETRANGE(pJobNo);
      NoOfRecords := RecRef.COUNT;
      IF (RecRef.FINDSET(TRUE)) THEN
        REPEAT
          LineCounter += 1;
          Window.UPDATE(2,ROUND(LineCounter / NoOfRecords * 10000,1));

          //JAV 01/08/20: - En las unidades de obra marco las que no tengan coste ni venta como de coste para que aparezcan al menos en la pantalla de presupuestos de coste
          IF (pDatos[1] = DATABASE::"Data Piecework For Production") THEN BEGIN
            IF (FORMAT(FieldRef15.VALUE) = FORMAT(FALSE)) AND (FORMAT(FieldRef16.VALUE) = FORMAT(FALSE)) THEN BEGIN
              FieldRef15.VALIDATE(TRUE);   //Marco que es unidad de producci�n
              RecRef.MODIFY;
              nUdAsociadas += 1;
            END;
          END;

          TxtAux := FORMAT(FieldRef3.VALUE);
          IF (Inicio = '') OR (COPYSTR(TxtAux,1,STRLEN(Inicio)) <> Inicio) THEN BEGIN
            Inicio := TxtAux;
            IdentOne(pJobNo, pBudget, Inicio, pDatos, pValor);
          END;
        UNTIL RecRef.NEXT = 0;

      Window.CLOSE;
      IF (NotSeeMessages = FALSE) THEN BEGIN
        IF (nUdAsociadas = 0) THEN
          MESSAGE(Text011)
        ELSE
          MESSAGE(Text012,nUdAsociadas);
      END;
    END;

    LOCAL PROCEDURE IdentOne(pJobNo : Code[20];pBudget : Code[20];pInicio : Code[20];pDatos : ARRAY [20] OF Integer;pValor : ARRAY [2] OF Text);
    VAR
      RecRef : RecordRef;
      FieldRef2 : FieldRef;
      FieldRef3 : FieldRef;
      FieldRef4 : FieldRef;
      FieldRef5 : FieldRef;
      FieldRef6 : FieldRef;
      FieldRef7 : FieldRef;
      FieldRef8 : FieldRef;
      FieldRef9 : FieldRef;
      FieldRef14 : FieldRef;
      RecRef3 : RecordRef;
      rr3Field2 : FieldRef;
      rr3Field3 : FieldRef;
      rr3Field4 : FieldRef;
      rr3Field14 : FieldRef;
      RecRef10 : RecordRef;
      FieldRef11 : FieldRef;
      FieldRef12 : FieldRef;
      FieldRef13 : FieldRef;
      LastPŒecework : Code[20];
      TxtAux : Text;
      Tabla : ARRAY [20] OF Integer;
      i : Integer;
      j : Integer;
      MaxLen : Integer;
    BEGIN
      RecRef.OPEN(pDatos[1]);
      FieldRef2 := RecRef.FIELD(pDatos[2]);   // Job No.
      FieldRef3 := RecRef.FIELD(pDatos[3]);   // Piecework Code
      FieldRef4 := RecRef.FIELD(pDatos[4]);   // Account type
      FieldRef5 := RecRef.FIELD(pDatos[5]);   // Identation
      FieldRef6 := RecRef.FIELD(pDatos[6]);   // Desription
      FieldRef7 := RecRef.FIELD(pDatos[7]);   // Unique Code
      FieldRef8 := RecRef.FIELD(pDatos[8]);   // Title
      FieldRef9 := RecRef.FIELD(pDatos[9]);   // Totaling
      FieldRef14:= RecRef.FIELD(pDatos[14]);  // Type

      RecRef3.OPEN(pDatos[1]);
      rr3Field2 := RecRef3.FIELD(pDatos[2]);   // Job No.
      rr3Field3 := RecRef3.FIELD(pDatos[3]);   // Piecework Code
      rr3Field4 := RecRef3.FIELD(pDatos[4]);   // Account type
      rr3Field14:= RecRef3.FIELD(pDatos[14]);  // Type

      RecRef10.OPEN(pDatos[10]);
      FieldRef11 := RecRef10.FIELD(pDatos[11]); // "Job No."
      FieldRef12 := RecRef10.FIELD(pDatos[12]); // "Piecework Code"
      IF (pDatos[13] <> 0) THEN
        FieldRef13 := RecRef10.FIELD(pDatos[13]); // "Cod. Budget"


      MaxLen := 14;  // Long. M�xima de una U.O. de mayor

      //Primera pasada, hay que ver los niveles reales que tiene y preparar la tabla de niveles
      CLEAR(Tabla);
      RecRef.RESET;
      FieldRef2.SETRANGE(pJobNo);
      FieldRef3.SETFILTER(pInicio + '*');
      IF (RecRef.FINDSET(FALSE)) THEN
        REPEAT
          TxtAux := FORMAT(FieldRef3.VALUE);
          Tabla[STRLEN(TxtAux)] := -1;
        UNTIL RecRef.NEXT = 0;

      //Numeramos los niveles correlativamente
      j:=0;
      FOR i := 1 TO ARRAYLEN(Tabla) DO
        IF (Tabla[i] = -1) THEN BEGIN
          Tabla[i] := j;
          j += 1;
        END;

      //segunda pasada, una vez definidos los niveles los asignamos y verificamos datos
      IF (RecRef.FINDSET(TRUE)) THEN
        REPEAT
          IF (FORMAT(FieldRef4) = pValor[1]) THEN BEGIN  //Si es de mayor
            LastPŒecework := FORMAT(FieldRef3);

            //The length of a heading account cannot be greater than maxlen
            IF (STRLEN(FORMAT(FieldRef3)) > MaxLen) THEN
              ERROR(Text020, MaxLen, FORMAT(FieldRef3));

            //Aviso si una unidad de tipo mayor no tiene partidas
            RecRef3.RESET;
            rr3Field2.SETRANGE(pJobNo);
            rr3Field3.SETFILTER(FORMAT(FieldRef3) + '*');
            IF (NotSeeMessages = FALSE) THEN BEGIN
              IF (RecRef3.COUNT = 1) THEN
                MESSAGE(Text022, FORMAT(FieldRef3));
            END;

            //Error si tiene descompuestos
            RecRef10.RESET;
            FieldRef11.SETRANGE(pJobNo);
            FieldRef12.SETRANGE(FORMAT(FieldRef3));
            IF (pDatos[13] <> 0) AND (pBudget <> '') THEN
              FieldRef13.SETRANGE('');
            IF (NOT RecRef10.ISEMPTY) THEN
              ERROR(Text023, FORMAT(FieldRef3));

          END ELSE BEGIN //Si es unidad
            //Verifico que la siguiente partidas de una unidad tenga la misma longitud, siempre que sean del mismo tipo
            RecRef3.RESET;
            rr3Field2.SETRANGE(pJobNo);
            rr3Field3.SETFILTER('>%1', FORMAT(FieldRef3));
            rr3Field3.SETRANGE(FORMAT(FieldRef14));          //Tienen que ser del mismo tipo
            IF (RecRef3.FINDFIRST) THEN
              IF (FORMAT(rr3Field4)  = pValor[2]) AND                             //Si es de tipo unidad
                 (STRLEN(FORMAT(FieldRef3)) <> STRLEN(FORMAT(rr3Field3))) THEN    //Y su longitud es diferente
                ERROR(Text021, FORMAT(FieldRef3));
          END;

          //Ajustar datos y asignar nivel
          TxtAux := FORMAT(FieldRef3.VALUE);
          FieldRef5.VALUE := Tabla[STRLEN(TxtAux)];   // Identation
          FieldRef6.TESTFIELD;                        // Description
          FieldRef7.VALIDATE;                         // Unique Code;
          FieldRef8.VALUE := LastPŒecework;           // Title
          FieldRef9.VALIDATE('');                     // Totaling

          RecRef.MODIFY;

        UNTIL RecRef.NEXT = 0;
    END;

    PROCEDURE FunOrganise(pCodeCostDatabase : Code[10]);
    VAR
      VPiecework : Record 7207277;
      VPieceworkSon : Record 7207277;
      ChangeFather : Boolean;
    BEGIN
      //Tras cargar un precio, lo organiza en niveles
      VPiecework.SETRANGE("Cost Database Default", pCodeCostDatabase);
      IF VPiecework.FINDSET THEN
        REPEAT
         ChangeFather := FALSE;
         VPieceworkSon.SETRANGE("Cost Database Default",pCodeCostDatabase);
         VPieceworkSon.SETFILTER("No.",'%1',VPiecework."No."+'*');
         IF VPieceworkSon.FINDSET THEN BEGIN
           REPEAT
             IF VPieceworkSon."No." <> VPiecework."No." THEN BEGIN
               VPieceworkSon.Identation := VPiecework.Identation + 1;
               VPieceworkSon.MODIFY;
               ChangeFather := TRUE;
             END;
           UNTIL VPieceworkSon.NEXT = 0;
           IF ChangeFather THEN BEGIN
             VPiecework."Account Type" := VPiecework."Account Type"::Heading;
             VPiecework.VALIDATE(Totaling);
             VPiecework.MODIFY;
           END;
         END ELSE BEGIN
           VPiecework."Account Type" := VPiecework."Account Type"::Unit;
           VPiecework.VALIDATE(Totaling);
           VPiecework.MODIFY;
         END;
        UNTIL VPiecework.NEXT = 0;
    END;

    PROCEDURE NotMessages();
    BEGIN
      NotSeeMessages := TRUE;
    END;

    /*BEGIN
/*{
      JAV 05/10/19: - Se cambia por completo el algoritmo de c�lculo de las identaciones y los ajustes de los campos
                    - Se unifica para preciarios y proyectos
      JAV 08/07/20: - Al verificar mira si ha cambiado el tipo de unidad para no mezclar cosas diferentes.
    }
END.*/
}







