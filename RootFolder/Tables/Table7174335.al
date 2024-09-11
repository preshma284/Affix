table 7174335 "SII Document Shipment"
{




    fields
    {
        field(1; "Ship No."; Code[20])
        {
            CaptionML = ENU = 'Ship No.', ESP = 'N� Env�o';


        }
        field(2; "Shipment DateTime"; DateTime)
        {
            CaptionML = ENU = 'Shipment Date Time', ESP = 'Fecha/Hora Env�o';


        }
        field(3; "Shipment Status"; Option)
        {
            OptionMembers = "Pendiente","Enviado","No Enviado";
            CaptionML = ENU = 'Shipment Status', ESP = 'Estado del Env�o';

            Description = 'QuoSII1.4.03: Deshabilitado';
            Editable = true;


        }
        field(4; "Shipment Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("CommunicationType"),
                                                                                                   "SII Entity" = FIELD("SII Entity"));


            CaptionML = ENU = 'Shipment Type', ESP = 'Tipo de Env�o';

            trigger OnValidate();
            BEGIN
                IF "Shipment Type" <> '' THEN
                    VALIDATE("Shipment Type Name", SIITypeListValue.GetDocumentName(1, "Shipment Type"));
            END;


        }
        field(5; "AEAT Status"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("ShipStatus"),
                                                                                                   "SII Entity" = FIELD("SII Entity"));


            CaptionML = ENU = 'AEAT Status', ESP = 'Estado AEAT';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 Text0001@1000000000 :
                Text0001: TextConst ENU = 'No se puede eliminar el env�o %1 porque tiene l�neas con estado %2.', ESP = 'No se puede modificar el env�o %1 porque tiene l�neas con estado %2.';
            BEGIN
                IF (xRec."AEAT Status" IN ['CORRECTO', 'PARCIALMENTECORRECTO', 'ANULADA']) AND (xRec."Tipo Entorno" = xRec."Tipo Entorno"::REAL) THEN
                    ERROR(Text0001, "Ship No.", 'CORRECTO, PARCIALMENTECORRECTO o ANULADA');
            END;


        }
        field(6; "Document Type"; Option)
        {
            OptionMembers = " ","FE","FR","OS","CM","BI","OI","CE","PR";
            CaptionML = ENU = 'Document Type', ESP = 'Tipo Documento';
            OptionCaptionML = ENU = '" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Metalico,Fact. Bienes Inv.,Fact. Op. Intracomunitaria,Cobro Factura,Pago Factura"', ESP = '" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Met�lico,Factura Bienes Inversi�n,Factura Op. Intracomunitaria,Cobro Factura Emitida,Pago Factura Recibida"';



        }
        field(7; "Shipment Type Name"; Text[250])
        {

            CaptionML = ENU = 'Shipment Type', ESP = 'Tipo de Env�o';


        }
        field(8; "Tipo Entorno"; Option)
        {
            OptionMembers = "REAL","PRUEBAS";

            CaptionML = ENU = 'Environmet Type', ESP = 'Tipo Entorno';

            Description = 'QuoSII1.4';

            trigger OnValidate();
            VAR
                //                                                                 SIIDocumentShipmentLine@1000000000 :
                SIIDocumentShipmentLine: Record 7174336;
                //                                                                 Text0001@1000000001 :
                Text0001: TextConst ENU = 'No se puede eliminar el env�o %1 porque tiene l�neas con estado %2.', ESP = 'No se puede modificar el env�o %1 porque tiene l�neas con estado %2.';
            BEGIN
                IF (xRec."AEAT Status" IN ['CORRECTO', 'PARCIALMENTECORRECTO', 'ANULADA']) AND (xRec."Tipo Entorno" = xRec."Tipo Entorno"::REAL) THEN
                    ERROR(Text0001, "Ship No.", 'CORRECTO, PARCIALMENTECORRECTO o ANULADA');
                VALIDATE("AEAT Status", '');
                MODIFY;
                SIIDocumentShipmentLine.RESET;
                SIIDocumentShipmentLine.SETRANGE("Ship No.", "Ship No.");
                IF SIIDocumentShipmentLine.FINDFIRST THEN
                    REPEAT
                        SIIDocumentShipmentLine.VALIDATE("AEAT Status", '');
                        SIIDocumentShipmentLine.MODIFY;
                    UNTIL SIIDocumentShipmentLine.NEXT = 0;
            END;


        }
        field(9; "SII Entity"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SIIEntity"),
                                                                                                   "SII Entity" = CONST(''));


            CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII';
            Description = 'QuoSII_1.4.2.042';

            trigger OnValidate();
            VAR
                //                                                                 QuoSII@80000 :
                QuoSII: Integer;
                //                                                                 SIIDocumentShipmentLine@80001 :
                SIIDocumentShipmentLine: Record 7174336;
            BEGIN
                //QuoSII_1.4.02.042.begin 
                IF ("SII Entity" <> xRec."SII Entity") THEN BEGIN
                    SIIDocumentShipmentLine.RESET;
                    SIIDocumentShipmentLine.SETRANGE("Document Type", "Document Type");
                    SIIDocumentShipmentLine.SETRANGE("Ship No.", Rec."Ship No.");
                    IF SIIDocumentShipmentLine.FINDFIRST THEN
                        ERROR('No se puede cambiar el campo %1 cuando existen l�neas.', Rec.FIELDCAPTION("SII Entity"));
                END;
                //QuoSII_1.4.02.042.end
            END;


        }
    }
    keys
    {
        key(key1; "Ship No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       CompanyInformation@80000 :
        CompanyInformation: Record 79;
        //       NoSeriesMgt@80001 :
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        //       OldSeriesCode@80002 :
        OldSeriesCode: Code[10];
        //       NewSeriesCode@80003 :
        NewSeriesCode: Code[10];
        //       SIITypeListValue@80004 :
        SIITypeListValue: Record 7174331;
        //       SIIDocumentShipmentLine@80005 :
        SIIDocumentShipmentLine: Record 7174336;



    trigger OnInsert();
    var
        //                GeneralLedgerSetup@80000 :
        GeneralLedgerSetup: Record 98;
    begin
        if "Ship No." = '' then begin
            "Shipment DateTime" := CREATEDATETIME(WORKDATE, TIME);
            "Shipment Status" := "Shipment Status"::Pendiente;
            CompanyInformation.GET;
            NoSeriesMgt.InitSeries(CompanyInformation."QuoSII Nos. Serie SII", '', DT2DATE("Shipment DateTime"), "Ship No.", NewSeriesCode);
            //QuoSII_1.4.02.042.begin
            GeneralLedgerSetup.GET;
            GeneralLedgerSetup.TESTFIELD("QuoSII Default SII Entity");
            VALIDATE("SII Entity", GeneralLedgerSetup."QuoSII Default SII Entity");
            //QuoSII_1.4.02.042.end
        end;
    end;

    trigger OnModify();
    var
        //                Text0001@1000000000 :
        Text0001: TextConst ENU = 'No se puede modificar el env�o %1 porque tiene l�neas con estado %2.', ESP = 'No se puede modificar el env�o %1 porque tiene l�neas con estado %2.';
    begin
        //QuoSII_1.4.02.042.18.begin
        if xRec."AEAT Status" = 'CORRECTO' then begin  //QuoSII_1.4.0.012
            if (xRec."Shipment Type" <> "Shipment Type") and not ((xRec."Shipment Type" = 'A0') and ("Shipment Type" = 'A1')) then
                ERROR(Text0001, "Ship No.", 'CORRECTO');
        end else begin
            if xRec."AEAT Status" = 'PARCIALMENTECORRECTO' then begin  //QuoSII_1.4.0.012
                if not ((xRec."Shipment Type" = 'A1') and ("Shipment Type" = 'A0')) then
                    ERROR(Text0001, "Ship No.", 'PARCIALMENTECORRECTO');
            end else begin
                if (xRec."AEAT Status" IN ['CORRECTO', 'PARCIALMENTECORRECTO', 'ANULADA']) then  //QuoSII_1.4.0.012
                    ERROR(Text0001, "Ship No.", 'CORRECTO, PARCIALMENTECORRECTO o ANULADA');
            end;
            //QuoSII_1.4.02.042.18.begin
        end;
    end;

    trigger OnDelete();
    var
        //                Text0001@80001 :
        Text0001: TextConst ENU = 'No se puede eliminar el env�o %1 porque tiene l�neas con estado %2.', ESP = 'No se puede eliminar el env�o %1 porque tiene l�neas con estado %2.';
        //                Text0002@80000 :
        Text0002: TextConst ENU = 'No se puede eliminar el env�o %1 porque tiene estado %2.', ESP = 'No se puede eliminar el env�o %1 porque tiene estado %2.';
        //                SIIDocuments@80002 :
        SIIDocuments: Record 7174333;
        //                SIIDocumentShipmentLineAux@80003 :
        SIIDocumentShipmentLineAux: Record 7174336;
    begin
        if "AEAT Status" IN ['CORRECTO', 'PARCIALMENTECORRECTO'] then
            ERROR(Text0002, "Ship No.", "AEAT Status")
        else begin
            SIIDocumentShipmentLine.RESET;
            SIIDocumentShipmentLine.SETRANGE("Ship No.", "Ship No.");
            SIIDocumentShipmentLine.SETFILTER("AEAT Status", '%1|%2|%3', 'CORRECTO', 'PARCIALMENTECORRECTO', 'ANULADA'); //QuoSII1.4
            if SIIDocumentShipmentLine.FINDFIRST then
                ERROR(Text0001, "Ship No.", SIIDocumentShipmentLine."AEAT Status")
            else begin

                //QuoSII1.4.03
                if "Shipment Type" = 'A0' then begin

                    SIIDocumentShipmentLine.RESET;
                    SIIDocumentShipmentLine.SETRANGE("Ship No.", "Ship No.");
                    if SIIDocumentShipmentLine.FINDSET then begin
                        repeat

                            SIIDocuments.RESET;
                            SIIDocuments.SETRANGE("Entry No.", SIIDocumentShipmentLine."Entry No.");
                            if SIIDocuments.FINDFIRST then begin
                                SIIDocuments.VALIDATE(Status, SIIDocuments.Status::" ");
                                SIIDocuments.VALIDATE("Is Emited", FALSE);  //JAV 01/06/21: - En el Delete se marcan los documentos como que ya no est�n en un env�o
                                SIIDocuments.MODIFY(TRUE);
                            end;

                        until SIIDocumentShipmentLine.NEXT = 0;
                    end;
                end else if ("Shipment Type" = 'A1') or ("Shipment Type" = 'B0') then begin

                    SIIDocumentShipmentLine.RESET;
                    SIIDocumentShipmentLine.SETRANGE("Ship No.", "Ship No.");
                    if SIIDocumentShipmentLine.FINDSET then begin
                        repeat

                            SIIDocuments.RESET;
                            SIIDocuments.SETRANGE("Document No.", SIIDocumentShipmentLine."Document No.");
                            SIIDocuments.SETRANGE("Entry No.", SIIDocumentShipmentLine."Entry No.");
                            SIIDocuments.SETRANGE("Register Type", SIIDocumentShipmentLine."Register Type");
                            if SIIDocuments.FINDFIRST then begin

                                SIIDocuments.VALIDATE(Status, SIIDocuments.Status::" ");
                                SIIDocuments.VALIDATE("Is Emited", FALSE);  //JAV 01/06/21: - En el Delete se marcan los documentos como que ya no est�n en un env�o
                                SIIDocuments.MODIFY(TRUE);

                                SIIDocumentShipmentLineAux.RESET;
                                SIIDocumentShipmentLineAux.SETFILTER("Ship No.", '<>%1', "Ship No.");
                                SIIDocumentShipmentLineAux.SETRANGE("Document No.", SIIDocumentShipmentLine."Document No.");
                                SIIDocumentShipmentLineAux.SETFILTER(Status, '<>%1', SIIDocumentShipmentLineAux.Status::" ");
                                if SIIDocumentShipmentLineAux.FINDFIRST then begin

                                    SIIDocuments.VALIDATE(Status, SIIDocumentShipmentLineAux.Status);
                                    SIIDocuments.VALIDATE("Is Emited", FALSE);  //JAV 01/06/21: - En el Delete se marcan los documentos como que ya no est�n en un env�o
                                    SIIDocuments.MODIFY(TRUE);
                                end;
                            end;

                        until SIIDocumentShipmentLine.NEXT = 0;
                    end;
                end else
                    //QuoSII1.4.03

                    SIIDocumentShipmentLine.RESET;
                SIIDocumentShipmentLine.SETRANGE("Ship No.", "Ship No.");
                SIIDocumentShipmentLine.DELETEALL;

            end;
        end;
    end;



    /*begin
        {
          QuoSII1.4.03 09/03/2018 PEL
          QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci�n de enviar a la ATCN
          QuoSII_1.4.02.042.18 MCM 27/02/19 - Se modifica la propiedad Editable del campo AEAT Status.
          JAV 01/06/21: - En el Delete se marcan los documentos como que ya no est�n en un env�o
          JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as� no entra en confusi�n con campos denominados Type
        }
        end.
      */
}







