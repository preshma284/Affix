report 7207285 "Copy Doc. To Certification"
{


    CaptionML = ENU = 'Copy Doc. To Certification', ESP = 'Copiar doc. a certificaci¢n';
    ProcessingOnly = true;

    dataset
    {

    }
    requestpage
    {

        layout
        {
        }
    }
    labels
    {
    }

    var
        //       MeasurementHeader@7001115 :
        MeasurementHeader: Record 7207336;
        //       FromMeasurmentHeader@7001114 :
        FromMeasurmentHeader: Record 7207336;
        //       FromHistMeasurements@7001113 :
        FromHistMeasurements: Record 7207338;
        //       FromPostCertifications@7001112 :
        FromPostCertifications: Record 7207341;
        //       FromReturnReceiptHeader@7001111 :
        FromReturnReceiptHeader: Record 6660;
        //       CopyDocMgt@7001110 :
        CopyDocMgt: Codeunit 7207281;
        //       DocType@7001109 :
        DocType: Option "Measuring","Certification","Post Measuring","Post Certification";
        //       DocNo@7001108 :
        DocNo: Code[20];
        //       IncludeHeader@7001107 :
        IncludeHeader: Boolean;
        //       RecalculateLines@7001106 :
        RecalculateLines: Boolean;
        //       MeasurementLines@7001105 :
        MeasurementLines: Record 7207337;
        //       MeasurementLines2@7001104 :
        MeasurementLines2: Record 7207337;
        //       HistMeasureLines@7001103 :
        HistMeasureLines: Record 7207339;
        //       HistCertificationLines@7001102 :
        HistCertificationLines: Record 7207342;
        //       LineNo@7001101 :
        LineNo: Integer;
        //       MeasurementHeader2@7001100 :
        MeasurementHeader2: Record 7207336;
        //       text001@7001116 :
        text001: TextConst ENU = 'Enter a Document No.', ESP = 'Introduzca un n§ documento';



    trigger OnPreReport();
    begin
        if DocNo = '' then
            ERROR(text001)
        else
            if FromMeasurmentHeader."No." = '' then begin
                FromMeasurmentHeader.INIT;
                CASE DocType OF
                    DocType::Measuring:
                        begin
                            MeasurementHeader2 := MeasurementHeader;
                            MeasurementHeader.GET(DocNo);
                            FromMeasurmentHeader.TRANSFERFIELDS(MeasurementHeader);
                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", MeasurementHeader2."No.");
                            if MeasurementLines.FINDLAST then
                                LineNo := MeasurementLines."Line No." + 10000
                            else
                                LineNo := 10000;
                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", MeasurementHeader."No.");
                            if MeasurementLines.FINDSET(TRUE, TRUE) then
                                repeat
                                    MeasurementLines2.TRANSFERFIELDS(MeasurementLines);
                                    MeasurementLines2."Document type" := MeasurementHeader2."Document Type";
                                    MeasurementLines2."Document No." := MeasurementHeader2."No.";
                                    MeasurementLines2."Line No." := LineNo;
                                    MeasurementLines2.VALIDATE("Piecework No.");
                                    MeasurementLines2."Med. Source Measure" := MeasurementLines."Med. Source Measure";
                                    MeasurementLines2."Med. Term Measure" := MeasurementLines."Med. Term Measure";
                                    MeasurementLines2."Contract Price" := MeasurementLines."Contract Price";
                                    MeasurementLines2."Med. Term PEC Amount" := MeasurementLines."Med. Term PEC Amount";
                                    MeasurementLines2.INSERT;
                                    LineNo := LineNo + 10000;
                                until MeasurementLines.NEXT = 0;
                        end;
                    DocType::Certification:
                        begin
                            MeasurementHeader2 := MeasurementHeader;
                            MeasurementHeader.GET(DocNo);
                            FromMeasurmentHeader.TRANSFERFIELDS(MeasurementHeader);
                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", MeasurementHeader2."No.");
                            if MeasurementLines.FINDLAST then
                                LineNo := MeasurementLines."Line No." + 10000
                            else
                                LineNo := 10000;
                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", MeasurementHeader."No.");
                            if MeasurementLines.FINDSET(TRUE, TRUE) then
                                repeat
                                    MeasurementLines2.TRANSFERFIELDS(MeasurementLines);
                                    MeasurementLines2."Document type" := MeasurementLines2."Document type"::Measuring;
                                    MeasurementLines2."Document No." := MeasurementHeader2."No.";
                                    MeasurementLines2."Line No." := LineNo;
                                    MeasurementLines2.VALIDATE("Piecework No.");
                                    MeasurementLines2."Med. Source Measure" := MeasurementLines."Med. Source Measure";
                                    MeasurementLines2."Med. Term Measure" := MeasurementLines."Med. Term Measure";
                                    MeasurementLines2."Contract Price" := MeasurementLines."Contract Price";
                                    MeasurementLines2."Med. Term PEC Amount" := MeasurementLines."Med. Term PEC Amount";
                                    MeasurementLines2.INSERT;
                                    LineNo := LineNo + 10000;
                                until MeasurementLines.NEXT = 0;
                        end;
                    DocType::"Post Measuring":
                        begin
                            FromHistMeasurements.GET(DocNo);
                            FromMeasurmentHeader.TRANSFERFIELDS(FromHistMeasurements);

                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", MeasurementHeader."No.");
                            if MeasurementLines.FINDLAST then
                                LineNo := MeasurementLines."Line No." + 10000
                            else
                                LineNo := 10000;
                            MeasurementLines.RESET;
                            HistMeasureLines.SETRANGE("Document No.", DocNo);
                            if HistMeasureLines.FINDSET(TRUE, TRUE) then
                                repeat
                                    MeasurementLines2.TRANSFERFIELDS(HistMeasureLines);
                                    MeasurementLines2."Document type" := MeasurementHeader."Document Type";
                                    MeasurementLines2."Document No." := MeasurementHeader."No.";
                                    MeasurementLines2."Line No." := LineNo;
                                    MeasurementLines2.VALIDATE("Piecework No.");
                                    MeasurementLines2."Med. Term Measure" := HistMeasureLines."Med. Term Measure";
                                    MeasurementLines2."Contract Price" := HistMeasureLines."Contract Price";
                                    MeasurementLines2."Med. Term PEC Amount" := HistMeasureLines."Med. Term PEC Amount";
                                    MeasurementLines2.INSERT;
                                    LineNo := LineNo + 10000;
                                until HistMeasureLines.NEXT = 0;
                        end;
                    DocType::"Post Certification":
                        begin
                            FromPostCertifications.GET(DocNo);
                            FromMeasurmentHeader.TRANSFERFIELDS(FromPostCertifications);

                            MeasurementLines.RESET;
                            MeasurementLines.SETRANGE("Document No.", MeasurementHeader."No.");
                            if MeasurementLines.FINDLAST then
                                LineNo := MeasurementLines."Line No." + 10000
                            else
                                LineNo := 10000;
                            MeasurementLines.RESET;
                            HistCertificationLines.SETRANGE("Document No.", DocNo);
                            if HistCertificationLines.FINDSET(TRUE, TRUE) then
                                repeat
                                    MeasurementLines2.TRANSFERFIELDS(HistCertificationLines);
                                    MeasurementLines2."Document type" := MeasurementHeader."Document Type";
                                    MeasurementLines2."Document No." := MeasurementHeader."No.";
                                    MeasurementLines2."Line No." := LineNo;
                                    MeasurementLines2.VALIDATE("Piecework No.");
                                    MeasurementLines2."Contract Price" := HistCertificationLines."Contract Price";
                                    MeasurementLines2."Med. Term PEC Amount" := HistCertificationLines."Term Contract Amount";
                                    MeasurementLines2.INSERT;
                                    LineNo := LineNo + 10000;
                                until HistCertificationLines.NEXT = 0;
                        end;
                end;
            end;
    end;



    // procedure SetDoc (var NewMeasurementHeader@1000 :
    procedure SetDoc(var NewMeasurementHeader: Record 7207336)
    begin
        MeasurementHeader := NewMeasurementHeader;
    end;

    LOCAL procedure ValidateDocNo()
    begin
        if DocNo = '' then
            FromMeasurmentHeader.INIT
        else
            if FromMeasurmentHeader."No." = '' then begin
                FromMeasurmentHeader.INIT;
                CASE DocType OF
                    DocType::Measuring:
                        begin
                            MeasurementHeader.GET(DocNo);
                            FromMeasurmentHeader.TRANSFERFIELDS(MeasurementHeader);
                        end;
                    DocType::Certification:
                        begin
                            MeasurementHeader.GET(DocNo);
                            FromMeasurmentHeader.TRANSFERFIELDS(MeasurementHeader);
                        end;
                    DocType::"Post Measuring":
                        begin
                            FromHistMeasurements.GET(DocNo);
                            FromMeasurmentHeader.TRANSFERFIELDS(FromHistMeasurements);
                        end;
                    DocType::"Post Certification":
                        begin
                            FromPostCertifications.GET(DocNo);
                            FromMeasurmentHeader.TRANSFERFIELDS(FromPostCertifications);
                        end;
                end;
            end;
        FromMeasurmentHeader."No." := '';
    end;

    LOCAL procedure LookupDocNo()
    begin
        CASE DocType OF
            DocType::Measuring:
                begin
                    FromMeasurmentHeader.FILTERGROUP := 0;
                    FromMeasurmentHeader.SETRANGE("Document Type", FromMeasurmentHeader."Document Type"::Measuring);
                    if MeasurementHeader."Document Type" = MeasurementHeader."Document Type"::Measuring then
                        FromMeasurmentHeader.SETFILTER("No.", '<>%1', MeasurementHeader."No.");
                    FromMeasurmentHeader.FILTERGROUP := 2;
                    FromMeasurmentHeader."Document Type" := FromMeasurmentHeader."Document Type"::Measuring;
                    FromMeasurmentHeader."No." := DocNo;
                    if (DocNo = '') and (MeasurementHeader."Customer No." <> '') then
                        if FromMeasurmentHeader.SETCURRENTKEY("Document Type", "Customer No.") then begin
                            FromMeasurmentHeader."Customer No." := MeasurementHeader."Customer No.";
                            if FromMeasurmentHeader.FIND('=><') then;
                        end;
                    if PAGE.RUNMODAL(0, FromMeasurmentHeader) = ACTION::LookupOK then
                        DocNo := FromMeasurmentHeader."No.";
                end;
            DocType::Certification:
                begin
                    FromMeasurmentHeader.FILTERGROUP := 0;
                    FromMeasurmentHeader.SETRANGE("Document Type", FromMeasurmentHeader."Document Type"::Certification);
                    if MeasurementHeader."Document Type" = MeasurementHeader."Document Type"::Certification then
                        FromMeasurmentHeader.SETFILTER("No.", '<>%1', MeasurementHeader."No.");
                    FromMeasurmentHeader.FILTERGROUP := 2;
                    FromMeasurmentHeader."Document Type" := FromMeasurmentHeader."Document Type"::Certification;
                    FromMeasurmentHeader."No." := DocNo;
                    if (DocNo = '') and (MeasurementHeader."Customer No." <> '') then
                        if FromMeasurmentHeader.SETCURRENTKEY("Document Type", "Customer No.") then begin
                            FromMeasurmentHeader."Customer No." := MeasurementHeader."Customer No.";
                            if FromMeasurmentHeader.FIND('=><') then;
                        end;
                    if PAGE.RUNMODAL(0, FromMeasurmentHeader) = ACTION::LookupOK then
                        DocNo := FromMeasurmentHeader."No.";
                end;
            DocType::"Post Measuring":
                begin
                    FromHistMeasurements."No." := DocNo;
                    if (DocNo = '') and (MeasurementHeader."Customer No." <> '') then
                        if FromHistMeasurements.SETCURRENTKEY("No.") then begin
                            FromHistMeasurements."Customer No." := MeasurementHeader."Customer No.";
                            if FromHistMeasurements.FIND('=><') then;
                        end;
                    if PAGE.RUNMODAL(0, FromHistMeasurements) = ACTION::LookupOK then
                        DocNo := FromHistMeasurements."No.";
                end;
            DocType::"Post Certification":
                begin
                    FromPostCertifications."No." := DocNo;
                    if (DocNo = '') and (MeasurementHeader."Customer No." <> '') then
                        if FromPostCertifications.SETCURRENTKEY("No.") then begin
                            FromPostCertifications."Customer No." := MeasurementHeader."Customer No.";
                            if FromPostCertifications.FIND('=><') then;
                        end;
                    if PAGE.RUNMODAL(0, FromPostCertifications) = ACTION::LookupOK then
                        DocNo := FromPostCertifications."No.";
                end;
        end;
        ValidateDocNo;
    end;

    LOCAL procedure ValidateIncludeHeader()
    begin
    end;

    /*begin
    end.
  */

}



