report 7207278 "Copy Measurement Doc."
{


    CaptionML = ENU = 'Copy Measurement Doc', ESP = 'Copiar documento de medici¢n';
    ProcessingOnly = true;

    dataset
    {

    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group("group388")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("DocType"; "DocType")
                    {

                        CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
                        //OptionCaptionML=ENU='Document Type',ESP='Tipo documento';

                        ; trigger OnValidate()
                        BEGIN
                            DocNo := '';
                            ValidateDocNo;
                        END;


                    }
                    field("DocNo"; "DocNo")
                    {

                        CaptionML = ENU = 'Document No.', ESP = 'N§ documento';

                        ; trigger OnValidate()
                        BEGIN
                            ValidateDocNo;
                        END;

                        trigger OnLookup(var Text: Text): Boolean
                        BEGIN
                            LookupDocNo;
                        END;


                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       recMeasurementHeader@7001106 :
        recMeasurementHeader: Record 7207336;
        //       MeasurementLines@7001103 :
        MeasurementLines: Record 7207337;
        //       MeasurementLines2@7001102 :
        MeasurementLines2: Record 7207337;
        //       NoLine@7001101 :
        NoLine: Integer;
        //       recMeasurementHeader2@7001100 :
        recMeasurementHeader2: Record 7207336;
        //       FromrecHistMedic@7001111 :
        FromrecHistMedic: Record 7207338;
        //       recLinPostMeasurement@7001109 :
        recLinPostMeasurement: Record 7207339;
        //       recLinPostCertification@7001108 :
        recLinPostCertification: Record 7207342;
        //       recPieceworkMeasurementCert@7001110 :
        recPieceworkMeasurementCert: Record 7207386;
        //       FromValuedRelationship@7001113 :
        FromValuedRelationship: Record 7207401;
        //       recLinValuedRelationship@7001112 :
        recLinValuedRelationship: Record 7207402;
        //       decSourceMeasure@7001115 :
        decSourceMeasure: Decimal;
        //       cduMeasureLinesManagement@7001116 :
        cduMeasureLinesManagement: Codeunit 7207292;
        //       text001@7001117 :
        text001: TextConst ENU = 'Enter a Document No.', ESP = 'Introduzca un n§ documento';
        //       FromrecPostCert@7001118 :
        FromrecPostCert: Record 7207341;
        //       "-------------------------------------- Opciones"@1100286000 :
        "-------------------------------------- Opciones": Integer;
        //       DocType@1100286001 :
        DocType: Option "Valued Relationship","Measuring","Post. Measurement","Certification","Post Certification";
        //       DocNo@1100286002 :
        DocNo: Code[20];
        //       FromrecMeasurementHeader@1100286003 :
        FromrecMeasurementHeader: Record 7207336;
        //       PostMeasLinesBillofItem@1100286004 :
        PostMeasLinesBillofItem: Record 7207396;
        //       MeasureLinesBillofItem@1100286005 :
        MeasureLinesBillofItem: Record 7207395;



    trigger OnPreReport();
    begin
        if DocNo = '' then
            ERROR(text001)
        else
            if FromrecMeasurementHeader."No." = '' then begin
                FromrecMeasurementHeader.INIT;
                CASE DocType OF
                    DocType::Measuring:
                        begin
                            recMeasurementHeader2 := recMeasurementHeader;
                            recMeasurementHeader.GET(DocNo);
                            FromrecMeasurementHeader.TRANSFERFIELDS(recMeasurementHeader);
                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", recMeasurementHeader2."No.");
                            if MeasurementLines.FINDLAST then
                                NoLine := MeasurementLines."Line No." + 10000
                            else
                                NoLine := 10000;
                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", recMeasurementHeader."No.");
                            if MeasurementLines.FINDSET then
                                repeat
                                    MeasurementLines2.TRANSFERFIELDS(MeasurementLines);
                                    MeasurementLines2."Document type" := recMeasurementHeader2."Document Type";
                                    MeasurementLines2."Document No." := recMeasurementHeader2."No.";
                                    MeasurementLines2."Line No." := NoLine;
                                    MeasurementLines2.VALIDATE("Piecework No.");
                                    MeasurementLines2."Med. Source Measure" := 0;
                                    MeasurementLines2."Med. Term Measure" := 0;
                                    MeasurementLines2."Contract Price" := MeasurementLines."Contract Price";
                                    MeasurementLines2."Med. Term PEC Amount" := 0;
                                    MeasurementLines2.INSERT;
                                    NoLine := NoLine + 10000;
                                until MeasurementLines.NEXT = 0;
                        end;
                    DocType::Certification:
                        begin
                            recMeasurementHeader2 := recMeasurementHeader;
                            recMeasurementHeader.GET(DocNo);
                            FromrecMeasurementHeader.TRANSFERFIELDS(recMeasurementHeader);
                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", recMeasurementHeader2."No.");
                            if MeasurementLines.FINDLAST then
                                NoLine := MeasurementLines."Line No." + 10000
                            else
                                NoLine := 10000;
                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", recMeasurementHeader."No.");
                            if MeasurementLines.FINDSET then
                                repeat
                                    MeasurementLines2.TRANSFERFIELDS(MeasurementLines);
                                    MeasurementLines2."Document type" := MeasurementLines2."Document type"::Measuring;
                                    MeasurementLines2."Document No." := recMeasurementHeader2."No.";
                                    MeasurementLines2."Line No." := NoLine;
                                    MeasurementLines2.VALIDATE("Piecework No.");
                                    MeasurementLines2."Med. Source Measure" := 0;
                                    MeasurementLines2."Med. Term Measure" := 0;
                                    MeasurementLines2."Contract Price" := MeasurementLines."Contract Price";
                                    MeasurementLines2."Med. Term PEC Amount" := 0;
                                    MeasurementLines2.INSERT;
                                    NoLine := NoLine + 10000;
                                until MeasurementLines.NEXT = 0;
                        end;

                    DocType::"Post. Measurement":
                        begin
                            FromrecHistMedic.GET(DocNo);
                            FromrecMeasurementHeader.TRANSFERFIELDS(FromrecHistMedic);

                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", recMeasurementHeader."No.");
                            if MeasurementLines.FINDLAST then
                                NoLine := MeasurementLines."Line No." + 10000
                            else
                                NoLine := 10000;
                            MeasurementLines.RESET;

                            recLinPostMeasurement.SETRANGE("Document No.", DocNo);
                            if recLinPostMeasurement.FINDSET then
                                repeat
                                    MeasurementLines2.TRANSFERFIELDS(recLinPostMeasurement);
                                    MeasurementLines2."Document type" := recMeasurementHeader."Document Type";
                                    MeasurementLines2."Document No." := recMeasurementHeader."No.";
                                    MeasurementLines2."Line No." := NoLine;
                                    MeasurementLines2.VALIDATE("Piecework No.");
                                    MeasurementLines2."Med. Source Measure" := 0;
                                    MeasurementLines2."Med. Term Measure" := 0;
                                    MeasurementLines2."Contract Price" := recLinPostMeasurement."Contract Price";
                                    MeasurementLines2."Med. Term PEC Amount" := 0;
                                    MeasurementLines2.INSERT;
                                    NoLine := NoLine + 10000;
                                until recLinPostMeasurement.NEXT = 0;
                        end;
                    DocType::"Post Certification":
                        begin
                            FromrecPostCert.GET(DocNo);
                            FromrecMeasurementHeader.TRANSFERFIELDS(FromrecPostCert);

                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", recMeasurementHeader."No.");
                            if MeasurementLines.FINDLAST then
                                NoLine := MeasurementLines."Line No." + 10000
                            else
                                NoLine := 10000;
                            MeasurementLines.RESET;

                            recLinPostCertification.SETRANGE("Document No.", DocNo);
                            if recLinPostCertification.FINDSET then
                                repeat
                                    MeasurementLines2.TRANSFERFIELDS(recLinPostCertification);
                                    MeasurementLines2."Document type" := recMeasurementHeader."Document Type";
                                    MeasurementLines2."Document No." := recMeasurementHeader."No.";
                                    MeasurementLines2."Line No." := NoLine;
                                    MeasurementLines2.VALIDATE("Job No.");
                                    MeasurementLines2."Med. Source Measure" := 0;
                                    MeasurementLines2."Contract Price" := recLinPostCertification."Contract Price";
                                    MeasurementLines2."Med. Term PEC Amount" := 0;
                                    MeasurementLines2.INSERT;
                                    NoLine := NoLine + 10000;
                                until recLinPostCertification.NEXT = 0;
                        end;
                    DocType::"Valued Relationship":
                        begin
                            FromValuedRelationship.GET(DocNo);
                            FromrecMeasurementHeader."No." := FromValuedRelationship."No.";
                            FromrecMeasurementHeader.Description := FromValuedRelationship.Description;
                            FromrecMeasurementHeader."Description 2" := FromValuedRelationship."Description 2";
                            FromrecMeasurementHeader."Posting Date" := FromValuedRelationship."Posting Date";
                            FromrecMeasurementHeader."Shortcut Dimension 1 Code" := FromValuedRelationship."Shortcut Dimension 1 Code";
                            FromrecMeasurementHeader."Shortcut Dimension 2 Code" := FromValuedRelationship."Shortcut Dimension 2 Code";
                            FromrecMeasurementHeader."Currency Code" := FromValuedRelationship."Currency Code";
                            FromrecMeasurementHeader."Currency Factor" := FromValuedRelationship."Currency Factor";
                            FromrecMeasurementHeader."Reason Code" := FromValuedRelationship."Reason Code";
                            FromrecMeasurementHeader."Posting Date" := FromValuedRelationship."Posting Date";
                            FromrecMeasurementHeader."Measurement Date" := FromValuedRelationship."Measure Date";
                            FromrecMeasurementHeader."No. Measure" := FromValuedRelationship."Measurement No.";
                            FromrecMeasurementHeader."Last Measure" := FromValuedRelationship."Last Measurement";
                            FromrecMeasurementHeader."Text Measure" := FromValuedRelationship."Measurement Text";
                            FromrecMeasurementHeader."Job No." := FromValuedRelationship."Job No.";
                            FromrecMeasurementHeader."Customer No." := FromValuedRelationship."Customer No.";
                            FromrecMeasurementHeader.Name := FromValuedRelationship.Name;
                            FromrecMeasurementHeader.Address := FromValuedRelationship.Address;
                            FromrecMeasurementHeader."Address 2" := FromValuedRelationship."Address 2";
                            FromrecMeasurementHeader.City := FromValuedRelationship.City;
                            FromrecMeasurementHeader.Contact := FromValuedRelationship.Contact;
                            FromrecMeasurementHeader.County := FromValuedRelationship.County;
                            FromrecMeasurementHeader."Post Code" := FromValuedRelationship."Post Code";
                            FromrecMeasurementHeader."Country Code" := FromValuedRelationship."Country/Region Code";
                            FromrecMeasurementHeader."Responsibility Center" := FromValuedRelationship."Responsibility Center";

                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", recMeasurementHeader."No.");
                            if MeasurementLines.FINDLAST then
                                NoLine := MeasurementLines."Line No." + 10000
                            else
                                NoLine := 10000;
                            MeasurementLines.RESET;
                            recLinValuedRelationship.SETRANGE("Document No.", DocNo);

                            if recLinValuedRelationship.FINDSET then
                                repeat
                                    recPieceworkMeasurementCert.RESET;
                                    if recPieceworkMeasurementCert.GET(recLinValuedRelationship."Job No.", recLinValuedRelationship."Piecework No.") then begin
                                        if recPieceworkMeasurementCert."Account Type" = recPieceworkMeasurementCert."Account Type"::Unit then begin
                                            MeasurementLines2."Document type" := recMeasurementHeader."Document Type";
                                            MeasurementLines2."Document No." := recMeasurementHeader."No.";
                                            MeasurementLines2."Line No." := NoLine;
                                            MeasurementLines2."Job No." := recLinValuedRelationship."Job No.";
                                            MeasurementLines2."Piecework No." := recLinValuedRelationship."Piecework No.";
                                            MeasurementLines2.Description := recLinValuedRelationship.Description;
                                            MeasurementLines2."Description 2" := recLinValuedRelationship."Description 2";
                                            MeasurementLines2."Med. Term PEC Amount" := recLinValuedRelationship."PROD Amount Term";   //JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado
                                            MeasurementLines2."Shortcut Dimension 1 Code" := recLinValuedRelationship."Shortcut Dimension 1 Code";
                                            MeasurementLines2."Shortcut Dimension 2 Code" := recLinValuedRelationship."Shortcut Dimension 2 Code";
                                            MeasurementLines2."Med. Measured Quantity" := recLinValuedRelationship."Measure Term";
                                            MeasurementLines2."Contract Price" := recLinValuedRelationship."PROD Price";
                                            MeasurementLines2.VALIDATE("Piecework No.");
                                            recPieceworkMeasurementCert.CALCFIELDS(recPieceworkMeasurementCert."Quantity in Measurements");
                                            decSourceMeasure := recPieceworkMeasurementCert."Quantity in Measurements" + recLinValuedRelationship."Measure Term";
                                            if decSourceMeasure > recPieceworkMeasurementCert."Sale Quantity (base)" then
                                                //jmma corregir para permitir exceso de medici¢n certificaci¢n
                                                if not recPieceworkMeasurementCert."Allow Over Measure" then //jmma
                                                    decSourceMeasure := recPieceworkMeasurementCert."Sale Quantity (base)";
                                            MeasurementLines2.VALIDATE("Med. Source Measure", decSourceMeasure);
                                            MeasurementLines2.INSERT;
                                            //-Q17698 No podemos traer las mediciones del presupuesto si estamos copiando.
                                            //cduMeasureLinesManagement.GetLineDescMeasureOrder(MeasurementLines2."Job No.",
                                            //                                                  MeasurementLines2."Piecework No.",
                                            //                                                  MeasurementLines2."Document type",
                                            //                                                  MeasurementLines2."Document No.",
                                            //                                                  MeasurementLines2."Line No.",'');
                                            GetMeasuresOfDocument;
                                            //+Q17698
                                            NoLine := NoLine + 10000;
                                        end;
                                    end;
                                until recLinValuedRelationship.NEXT = 0;
                        end;

                end;
            end;
    end;



    // procedure SetDoc (var NewrecMeasurementHeader@1000 :
    procedure SetDoc(var NewrecMeasurementHeader: Record 7207336)
    begin
        recMeasurementHeader := NewrecMeasurementHeader;
    end;

    LOCAL procedure ValidateDocNo()
    begin
        if DocNo = '' then
            FromrecMeasurementHeader.INIT
        else
            if FromrecMeasurementHeader."No." = '' then begin
                FromrecMeasurementHeader.INIT;
                CASE DocType OF
                    DocType::Measuring:
                        begin
                            recMeasurementHeader.GET(DocNo);
                            FromrecMeasurementHeader.TRANSFERFIELDS(recMeasurementHeader);
                        end;
                    DocType::Certification:
                        begin
                            recMeasurementHeader.GET(DocNo);
                            FromrecMeasurementHeader.TRANSFERFIELDS(recMeasurementHeader);
                        end;
                    DocType::"Post. Measurement":
                        begin
                            FromrecHistMedic.GET(DocNo);
                            FromrecMeasurementHeader.TRANSFERFIELDS(FromrecHistMedic);
                        end;
                    DocType::"Post Certification":
                        begin
                            FromrecPostCert.GET(DocNo);
                            FromrecMeasurementHeader.TRANSFERFIELDS(FromrecPostCert);
                        end;
                    DocType::"Valued Relationship":
                        begin
                            FromValuedRelationship.GET(DocNo);
                            FromrecMeasurementHeader."No." := FromValuedRelationship."No.";
                            FromrecMeasurementHeader.Description := FromValuedRelationship.Description;
                            FromrecMeasurementHeader."Description 2" := FromValuedRelationship."Description 2";
                            FromrecMeasurementHeader."Posting Date" := FromValuedRelationship."Posting Date";
                            FromrecMeasurementHeader."Shortcut Dimension 1 Code" := FromValuedRelationship."Shortcut Dimension 1 Code";
                            FromrecMeasurementHeader."Shortcut Dimension 2 Code" := FromValuedRelationship."Shortcut Dimension 2 Code";
                            FromrecMeasurementHeader."Currency Code" := FromValuedRelationship."Currency Code";
                            FromrecMeasurementHeader."Currency Factor" := FromValuedRelationship."Currency Factor";
                            FromrecMeasurementHeader."Reason Code" := FromValuedRelationship."Reason Code";
                            FromrecMeasurementHeader."Measurement Date" := FromValuedRelationship."Measure Date";
                            FromrecMeasurementHeader."No. Measure" := FromValuedRelationship."Measurement No.";
                            FromrecMeasurementHeader."Last Measure" := FromValuedRelationship."Last Measurement";
                            FromrecMeasurementHeader."Text Measure" := FromValuedRelationship."Measurement Text";
                            FromrecMeasurementHeader."Job No." := FromValuedRelationship."Job No.";
                            FromrecMeasurementHeader."Customer No." := FromValuedRelationship."Customer No.";
                            FromrecMeasurementHeader.Name := FromValuedRelationship.Name;
                            FromrecMeasurementHeader.Address := FromValuedRelationship.Address;
                            FromrecMeasurementHeader."Address 2" := FromValuedRelationship."Address 2";
                            FromrecMeasurementHeader.City := FromValuedRelationship.City;
                            FromrecMeasurementHeader.Contact := FromValuedRelationship.Contact;
                            FromrecMeasurementHeader.County := FromValuedRelationship.County;
                            FromrecMeasurementHeader."Post Code" := FromValuedRelationship."Post Code";
                            FromrecMeasurementHeader."Country Code" := FromValuedRelationship."Country/Region Code";
                            FromrecMeasurementHeader."Responsibility Center" := FromValuedRelationship."Responsibility Center";
                        end;
                end;
            end;
        FromrecMeasurementHeader."No." := '';
    end;

    LOCAL procedure LookupDocNo()
    begin
        CASE DocType OF
            DocType::Measuring:
                begin
                    FromrecMeasurementHeader.SETRANGE("Job No.", recMeasurementHeader."Job No.");
                    FromrecMeasurementHeader.SETRANGE("Expedient No.", recMeasurementHeader."Expedient No."); //Q8047
                    FromrecMeasurementHeader.FILTERGROUP := 0;
                    FromrecMeasurementHeader.SETRANGE("Document Type", FromrecMeasurementHeader."Document Type"::Measuring);
                    if recMeasurementHeader."Document Type" = recMeasurementHeader."Document Type"::Measuring then
                        FromrecMeasurementHeader.SETFILTER("No.", '<>%1', recMeasurementHeader."No.");
                    FromrecMeasurementHeader.FILTERGROUP := 2;
                    FromrecMeasurementHeader."Document Type" := FromrecMeasurementHeader."Document Type"::Measuring;
                    FromrecMeasurementHeader."No." := DocNo;
                    if (DocNo = '') and (recMeasurementHeader."Customer No." <> '') then
                        if FromrecMeasurementHeader.SETCURRENTKEY("Document Type", "Customer No.") then begin
                            FromrecMeasurementHeader."Customer No." := recMeasurementHeader."Customer No.";
                            if FromrecMeasurementHeader.FIND('=><') then;
                        end;
                    if PAGE.RUNMODAL(0, FromrecMeasurementHeader) = ACTION::LookupOK then
                        DocNo := FromrecMeasurementHeader."No.";
                end;
            DocType::Certification:
                begin
                    FromrecMeasurementHeader.SETRANGE("Job No.", recMeasurementHeader."Job No.");
                    FromrecMeasurementHeader.FILTERGROUP := 0;
                    FromrecMeasurementHeader.SETRANGE("Document Type", FromrecMeasurementHeader."Document Type"::Certification);
                    if recMeasurementHeader."Document Type" = recMeasurementHeader."Document Type"::Certification then
                        FromrecMeasurementHeader.SETFILTER("No.", '<>%1', recMeasurementHeader."No.");
                    FromrecMeasurementHeader.FILTERGROUP := 2;
                    FromrecMeasurementHeader."Document Type" := FromrecMeasurementHeader."Document Type"::Certification;
                    FromrecMeasurementHeader."No." := DocNo;
                    if (DocNo = '') and (recMeasurementHeader."Customer No." <> '') then
                        if FromrecMeasurementHeader.SETCURRENTKEY("Document Type", "Customer No.") then begin
                            FromrecMeasurementHeader."Customer No." := recMeasurementHeader."Customer No.";
                            if FromrecMeasurementHeader.FIND('=><') then;
                        end;
                    if PAGE.RUNMODAL(0, FromrecMeasurementHeader) = ACTION::LookupOK then
                        DocNo := FromrecMeasurementHeader."No.";
                end;
            DocType::"Post. Measurement":
                begin
                    FromrecHistMedic.SETRANGE("Job No.", recMeasurementHeader."Job No.");
                    FromrecHistMedic."No." := DocNo;
                    if (DocNo = '') and (recMeasurementHeader."Customer No." <> '') then
                        if FromrecHistMedic.SETCURRENTKEY("No.") then begin
                            FromrecHistMedic."Customer No." := recMeasurementHeader."Customer No.";
                            if FromrecHistMedic.FIND('=><') then;
                        end;
                    if PAGE.RUNMODAL(0, FromrecHistMedic) = ACTION::LookupOK then
                        DocNo := FromrecHistMedic."No.";
                end;
            DocType::"Post Certification":
                begin
                    FromrecPostCert.SETRANGE("Job No.", recMeasurementHeader."Job No.");
                    FromrecPostCert."No." := DocNo;
                    if (DocNo = '') and (recMeasurementHeader."Customer No." <> '') then
                        if FromrecPostCert.SETCURRENTKEY("No.") then begin
                            FromrecPostCert."Customer No." := recMeasurementHeader."Customer No.";
                            if FromrecPostCert.FIND('=><') then;
                        end;
                    if PAGE.RUNMODAL(0, FromrecPostCert) = ACTION::LookupOK then
                        DocNo := FromrecPostCert."No.";
                end;
            DocType::"Valued Relationship":
                begin
                    FromValuedRelationship.SETRANGE("Job No.", recMeasurementHeader."Job No.");
                    FromValuedRelationship."No." := DocNo;
                    if (DocNo = '') and (recMeasurementHeader."Customer No." <> '') then
                        if FromValuedRelationship.SETCURRENTKEY("No.") then begin
                            FromValuedRelationship."Customer No." := recMeasurementHeader."Customer No.";
                            if FromValuedRelationship.FIND('=><') then;
                        end;
                    if PAGE.RUNMODAL(0, FromValuedRelationship) = ACTION::LookupOK then
                        DocNo := FromValuedRelationship."No.";
                end;
        end;

        ValidateDocNo;
    end;

    LOCAL procedure GetMeasuresOfDocument()
    var
        //       MeasureLinesBillofItem@1100286000 :
        MeasureLinesBillofItem: Record 7207395;
    begin
        //recLinValuedRelationship.
        PostMeasLinesBillofItem.RESET;
        PostMeasLinesBillofItem.SETRANGE("Document No.", recLinValuedRelationship."Document No.");
        PostMeasLinesBillofItem.SETRANGE("Line No.", recLinValuedRelationship."Line No.");
        if PostMeasLinesBillofItem.FINDSET then
            repeat
                MeasureLinesBillofItem.TRANSFERFIELDS(PostMeasLinesBillofItem);
                MeasureLinesBillofItem."Document Type" := MeasureLinesBillofItem."Document Type"::Measuring;
                MeasureLinesBillofItem."Document No." := recMeasurementHeader."No.";
                MeasureLinesBillofItem.INSERT;
            until PostMeasLinesBillofItem.NEXT = 0;
    end;

    /*begin
    //{
//      JAV 15/10/19: - Se eliminan los campos 14 "Measure Date" y 32 "Certification Date" de las l¡neas de medici¢n que no se usan
//                    - Se elimina el campo "Text Measure" de la cabecera que no se usa
//      PGM 16/10/19: - KALAM Q8047 A¤adido filtro para que solo se puedan elegir mediciones que sean del mismo expediente
//      JAV 24/06/22: - QB 1.10.53 Cambiar los campos PEC por COST que es mas apropiado
//      AML 16/06/12: - Q17698 Modificar como lleva las l¡neas de medicion en la copia.
//    }
    end.
  */

}



