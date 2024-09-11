Codeunit 7207324 "Post Prod. Measure"
{
  
  
    TableNo=7207399;
    Permissions=TableData 7207401=rimd,
                TableData 7207402=rimd;
    trigger OnRun()
VAR
            UpdateAnalysisView : Codeunit 410;
            HistProdMeasureHeader : Record 7207401;
          BEGIN

            CLEARALL;
            ProdMeasureHeader.COPY(Rec);

            //Comprobamos los campos obligatorios
            WITH ProdMeasureHeader DO BEGIN
              TESTFIELD("Posting Date");   //JAV 14/06/21: - QB 1.08.48 Se cambia la fecha de medici�n por la de registro
              TESTFIELD("Job No.");
              TESTFIELD("Measurement No.");
              TESTFIELD("Customer No.");
            END;

            MastCustomer.GET(Rec."Customer No.");
            MastCustomer.TESTFIELD(Blocked, 0);

            MasterJob.GET(Rec."Job No.");
            MasterJob.TESTFIELD(Blocked,MasterJob.Blocked::" ");


            Window.OPEN(
              '#1#################################\\' +
              Text005 +
              Text007 +
              Text7000000);

            Window.UPDATE(1,STRSUBSTNO('%1',rec."No."));

            //Comprobamos que el n� de serie de registro este relleno
            rec.TESTFIELD("Posting No. Series");

            //Bloqueamos las tablas a usar
            IF rec.RECORDLEVELLOCKING THEN BEGIN
              ProdMeasureLines.LOCKTABLE;
              GLEntry.LOCKTABLE;
              IF GLEntry.FINDLAST THEN;
            END;

            //Tomamos el c�d. de origen.
            SourceCodeSetup.GET;
            SourceCodeSetup.TESTFIELD(SourceCodeSetup."Prod. Measuring");
            SrcCode := SourceCodeSetup."Prod. Measuring";

            //Creo el documento que ir� al hist�rico de medici�n
            PostProdMeasureHeader.INIT;
            PostProdMeasureHeader.TRANSFERFIELDS(ProdMeasureHeader);
            PostProdMeasureHeader."Pre-Assigned No. Series" :=  ProdMeasureHeader."Posting No. Series";
            PostProdMeasureHeader."No." := NoSeriesMgt.GetNextNo(ProdMeasureHeader."Posting No. Series",ProdMeasureHeader."Posting Date",TRUE);
            Window.UPDATE(1,STRSUBSTNO(Text010,rec."No.",PostProdMeasureHeader."No."));
            PostProdMeasureHeader."Source Code" := SrcCode;
            PostProdMeasureHeader."User ID" := USERID;
            PostProdMeasureHeader."Dimension Set ID" := ProdMeasureHeader."Dimension Set ID";
            PostProdMeasureHeader.INSERT;

            //Ya no es necesario, son campos calculados
            // Guardar datos a origen
            // ProdMeasureHeader.CALCFIELDS("DOC PEM Import Previous", "DOC PEM Import Previous", "DOC PEM Import Term",
            //                             "DOC PEM Import to Source", "TOT PEM Import Previous", "TOT PEM Import to Source");
            // PostProdMeasureHeader."DOC PEM Import Previous"  := ProdMeasureHeader."DOC PEM Import Previous";
            // PostProdMeasureHeader."DOC PEM Import Previous"      := ProdMeasureHeader."DOC PEM Import Previous";
            // PostProdMeasureHeader."DOC PEM Import Term" := ProdMeasureHeader."DOC PEM Import Term";
            // PostProdMeasureHeader."DOC PEM Import to Source"  := ProdMeasureHeader."DOC PEM Import to Source";
            // PostProdMeasureHeader."TOT PEM Import Previous"      := ProdMeasureHeader."TOT PEM Import Previous";
            // PostProdMeasureHeader."TOT PEM Import to Source" := ProdMeasureHeader."TOT PEM Import to Source";
            PostProdMeasureHeader.MODIFY;

            //Copiar comentarios
            CopyCommentLines(rec."No.",PostProdMeasureHeader."No.");

            // Controlo que la suma de mediciones para una misma UO no exceda del prespuestado
            ProdMeasureLines.RESET;
            ProdMeasureLines2.RESET;
            ProdMeasureLines.SETRANGE("Document No.",rec."No.");
            ProdMeasureLines2.SETRANGE("Document No.",rec."No.");
            ProdMeasureLines2.SETRANGE("Piecework No.",ProdMeasureLines."Piecework No.");
            IF ProdMeasureLines2.FINDSET THEN BEGIN
              REPEAT
                MeasureLines := MeasureLines + ProdMeasureLines."Measure Source";
              UNTIL ProdMeasureLines2.NEXT = 0;
              DataPieceworkForProduction.GET(ProdMeasureLines."Job No.",ProdMeasureLines."Piecework No.");
              DataPieceworkForProduction.CALCFIELDS("Budget Measure");
              IF MeasureLines > DataPieceworkForProduction."Budget Measure" THEN
                ERROR(text036,ProdMeasureLines."Piecework No.");
            END;

            //JAV 28/07/21: - QB 1.09.14 Antes de procesar las l�neas debo cargar las que est�n en otras mediciones, as� no tengo problemas para la cantidad a origen
            ProdMeasureHeader.AddLines;

            // Lineas
            DataPieceworkForProduction.RESET;
            ProdMeasureLines.RESET;
            ProdMeasureLines.SETRANGE("Document No.",rec."No.");
            LineCount := 0;
            IF ProdMeasureLines.FINDSET(FALSE) THEN BEGIN
              REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2,LineCount);
                // Controles a realizar con las lineas del documento que registramos, testfield de los campos obligatorios
                // ProdMeasureLines.TESTFIELD(ProdMeasureLines."Medici�n per�odo");
                DataPieceworkForProduction.GET(ProdMeasureLines."Job No.",ProdMeasureLines."Piecework No.");
                IF DataPieceworkForProduction.Blocked = TRUE THEN
                  ERROR(text037,ProdMeasureLines."Piecework No.");

                PostProdMeasureLines.INIT;
                PostProdMeasureLines.TRANSFERFIELDS(ProdMeasureLines);
                PostProdMeasureLines."Document No." :=  PostProdMeasureHeader."No.";
                PostProdMeasureLines.INSERT;

                //Traspasar las l�neas de medici�n
                CreatePostBillofItemMeasurement(ProdMeasureLines,PostProdMeasureHeader."No.");
              UNTIL ProdMeasureLines.NEXT = 0;
            END ELSE BEGIN
              ERROR(Text001);
            END;

            rec.DELETE;
            ProdMeasureLines.DELETEALL;

            recLinComDoc.SETRANGE("No.",rec."No.");
            recLinComDoc.DELETEALL;

            //JAV 31/07/19: - Marcar la relaci�n que se cancela
            IF (HistProdMeasureHeader.GET(rec."Cancel No.")) THEN BEGIN
              HistProdMeasureHeader."Cancel By" := PostProdMeasureHeader."No.";
              HistProdMeasureHeader.Description := COPYSTR(HistProdMeasureHeader.Description + ' Cancelada', 1, MAXSTRLEN(HistProdMeasureHeader.Description));
              HistProdMeasureHeader."Measurement No." := COPYSTR(HistProdMeasureHeader."Measurement No." + ' Cancelada', 1, MAXSTRLEN(HistProdMeasureHeader."Measurement No."));
              HistProdMeasureHeader."Measurement Text" := COPYSTR(HistProdMeasureHeader."Measurement Text" + ' Cancelada', 1, MAXSTRLEN(HistProdMeasureHeader."Measurement Text"));
              HistProdMeasureHeader.MODIFY;
            END;

            COMMIT;
            Window.CLOSE;

            UpdateAnalysisView.UpdateAll(0,TRUE);
            Rec := ProdMeasureHeader;
          END;
    VAR
      ProdMeasureHeader : Record 7207399;
      MastCustomer : Record 18;
      MasterJob : Record 167;
      Window : Dialog;
      Text005 : TextConst ENU='Posting lines              #2######\',ESP='Registrando l�neas           #2######\';
      Text007 : TextConst ENU='Posting to vendors         #4######\',ESP='Registrando cliente          #4######\';
      Text7000000 : TextConst ENU='Creating documents         #6######',ESP='Creando documentos           #6######';
      ProdMeasureLines : Record 7207400;
      ProdMeasureLines2 : Record 7207400;
      GLEntry : Record 17;
      SourceCodeSetup : Record 242;
      SrcCode : Code[10];
      PostProdMeasureHeader : Record 7207401;
      MeasureLines : Decimal;
      DataPieceworkForProduction : Record 7207386;
      text036 : TextConst ENU='Measurement amount has exceeded budgeted amount for piecework %1',ESP='El importe de medici�n se ha excedido de lo presupuestado para la unidad de obra %1';
      recLinComDoc : Record 7207270;
      recLinComDoc2 : Record 7207270;
      LineCount : Integer;
      text037 : TextConst ENU='Piecework %1 is blocked',ESP='La unidad de obra %1 est� bloqueada';
      PostProdMeasureLines : Record 7207402;
      NoSeriesMgt : Codeunit 396;
      Text010 : TextConst ENU='%1 %2 -> Invoice %3',ESP='%1 -> Documento %2';
      Text001 : TextConst ENU='There is nothing to post.',ESP='No hay nada que registrar.';

    LOCAL PROCEDURE CopyCommentLines(FromNumber : Code[20];ToNumber : Code[20]);
    BEGIN
      recLinComDoc.SETRANGE("No.",FromNumber);
      IF recLinComDoc.FINDSET(TRUE) THEN
        REPEAT
         recLinComDoc."Document Type" := recLinComDoc."Document Type"::"Measure Hist.";
         recLinComDoc2 := recLinComDoc;
         recLinComDoc2."No." := ToNumber;
         recLinComDoc2.INSERT;
        UNTIL recLinComDoc.NEXT = 0;
    END;

    PROCEDURE CreatePostBillofItemMeasurement(parrecLineMeasure : Record 7207400;parcodNumDoc : Code[20]);
    VAR
      PostMeasLinesBillofItem : Record 7207396;
      MeasureLinesBillofItem : Record 7207395;
    BEGIN
      //Traspasar las l�neas de medici�n
      MeasureLinesBillofItem.SETRANGE("Document Type",MeasureLinesBillofItem."Document Type"::"Valued Relationship");
      MeasureLinesBillofItem.SETRANGE("Document No.",parrecLineMeasure."Document No.");
      MeasureLinesBillofItem.SETRANGE("Line No.",parrecLineMeasure."Line No.");
      IF MeasureLinesBillofItem.FINDSET THEN
        REPEAT
          MeasureLinesBillofItem.CALCFIELDS("Realized Units","Realized Total");
          PostMeasLinesBillofItem.INIT;
          PostMeasLinesBillofItem.TRANSFERFIELDS(MeasureLinesBillofItem);
          PostMeasLinesBillofItem."Document No." := parcodNumDoc;
          PostMeasLinesBillofItem."Realized Units" := MeasureLinesBillofItem."Realized Units";
          PostMeasLinesBillofItem."Realized Total" := MeasureLinesBillofItem."Realized Total";
          PostMeasLinesBillofItem.INSERT;
        UNTIL MeasureLinesBillofItem.NEXT = 0;
    END;

    /*BEGIN
/*{
      JAV 31/07/19: - Se guarda la medici�n a origen y marcar la relaci�n que se cancela
      JAV 21/09/20: - Eliminar por completo una relaci�n valorada
      JAV 14/06/21: - QB 1.08.48 Se eliminan variables que no se usan y se cambia "Measure Date" por "Posting Date"
      JAV 28/07/21: - QB 1.09.14 Antes de procesar las l�neas debo cargar las que est�n en otras mediciones, as� no tengo problemas para la cantidad a origen
    }
END.*/
}







