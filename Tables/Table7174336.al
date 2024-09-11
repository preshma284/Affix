table 7174336 "QBU SII Document Shipment Line"
{
  
  
    
  fields
{
    field(1;"Ship No.";Code[20])
    {
        CaptionML=ENU='Ship No.',ESP='N§ Env¡o';
                                                   Description='Key 1';


    }
    field(2;"Document No.";Code[60])
    {
        CaptionML=ENU='Document No.',ESP='N§ Documento';
                                                   Description='Key 2';


    }
    field(3;"Status";Option)
    {
        OptionMembers=" ","Pendiente","Enviada","No enviada","Anulada","Modificada";CaptionML=ENU='Status',ESP='Estado';
                                                   OptionCaptionML=ENU='" ,Pendiente,Enviada,No Enviada,Anulada,Modificada"',ESP='" ,Pendiente,Enviada,No Enviada,Anulada,Modificada"';
                                                   


    }
    field(4;"AEAT Status";Code[20])
    {
        FieldClass=Normal;
                                                   TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("ShipStatus"),
                                                                                                   "SII Entity"=FIELD("SII Entity"));
                                                   CaptionML=ENU='AEAT Status',ESP='Estado AEAT';
                                                   Editable=false;


    }
    field(5;"Document Type";Option)
    {
        OptionMembers=" ","FE","FR","OS","CM","BI","OI","CE","PR";CaptionML=ENU='Document Type',ESP='Tipo Documento';
                                                   OptionCaptionML=ENU='" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Metalico,Fact. Bienes Inv.,Fact. Op. Intracomunitaria,Cobro Factura,Pago Factura"',ESP='" ,Factura Emitida,Factura Recibida,Op. Seguros,Cobros Met lico,Factura Bienes Inversi¢n,Factura Op. Intracomunitaria,Cobro Factura Emitida,Pago Factura Recibida"';
                                                   


    }
    field(7;"Entry No.";Integer)
    {
        Description='Key 5';


    }
    field(19;"VAT Registration No.";Code[20])
    {
        CaptionML=ENU='VAT Registration No.',ESP='CIF/NIF';
                                                   Description='Key 3';


    }
    field(20;"Base Imponible";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("SII Document Line"."VAT Base" WHERE ("Document No."=FIELD("Document No."),
                                                                                                         "Document Type"=FIELD("Document Type"),
                                                                                                         "VAT Registration No."=FIELD("VAT Registration No."),
                                                                                                         "Entry No."=FIELD("Entry No."),
                                                                                                         "Register Type"=FIELD("Register Type")));
                                                   CaptionML=ENU='Tax Base',ESP='Base Imponible';
                                                   Description='QuoSII 1.06.12 Se a¤ade el campo "Register Type" al CalcFormula';


    }
    field(21;"Importe IVA";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("SII Document Line"."VAT Amount" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                           "Document No."=FIELD("Document No."),
                                                                                                           "No Taxable VAT"=FILTER(false),
                                                                                                           "Exent"=FILTER(false),
                                                                                                           "VAT Registration No."=FIELD("VAT Registration No."),
                                                                                                           "Entry No."=FIELD("Entry No."),
                                                                                                           "Register Type"=FIELD("Register Type")));
                                                   CaptionML=ENU='VAT Amount',ESP='Importe IVA';
                                                   Description='QuoSII 1.06.12 Se a¤ade el campo "Register Type" al CalcFormula';


    }
    field(22;"Posting Date";Date)
    {
        CaptionML=ENU='Posting Date',ESP='Fecha de Registro';
                                                   Description='Key 4   QuoSII_02_07';


    }
    field(23;"SII Entity";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SIIEntity"),
                                                                                                   "SII Entity"=CONST(''));
                                                   

                                                   CaptionML=ENU='SII Entity',ESP='Entidad SII';
                                                   Description='QuoSII_1.4.2.042';

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
                                                                  SIIDocumentShipmentLine.SETRANGE("Document Type","Document Type");
                                                                  SIIDocumentShipmentLine.SETRANGE("Document No.",Rec."Ship No.");
                                                                  IF SIIDocumentShipmentLine.COUNT > 0 THEN
                                                                    ERROR('No se puede cambiar el campo %1 cuando existen l¡neas.',Rec.FIELDCAPTION("SII Entity"));
                                                                END;
                                                                //QuoSII_1.4.02.042.end
                                                              END;


    }
    field(24;"Payment No.";Integer)
    {
        CaptionML=ENU='VAT Amount',ESP='N§ Pago';
                                                   Description='QuoSII 1.5k JAV 11/05/21 Indica el N§ de pago de una tipo 14';
                                                   Editable=false;


    }
    field(64;"Register Type";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo de Registro';
                                                   Description='Key 6   QuoSII 1.05n' ;


    }
}
  keys
{
    key(key1;"Ship No.","Document No.","VAT Registration No.","Posting Date","Entry No.","Register Type")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       SIIDocumentShipment@80002 :
      SIIDocumentShipment: Record 7174335;
//       SIIDocuments@80001 :
      SIIDocuments: Record 7174333;

    

trigger OnInsert();    begin
               //QUOSII.T53.begin
               actualizarEstadoAEATIM(Rec."Ship No.", Rec."Document Type");
               //QUOSII.T53.end

               //QuoSII1.4.03.begin
               SIIDocumentShipment.GET("Ship No.");
               if SIIDocumentShipment."Shipment Type" = 'A0' then begin

                 SIIDocuments.RESET;
                 SIIDocuments.SETRANGE("Entry No.", "Entry No.");
                 SIIDocuments.SETRANGE("Register Type","Register Type");
                 if SIIDocuments.FINDFIRST then begin
                   SIIDocuments.VALIDATE(Status, SIIDocuments.Status::Pendiente);
                   SIIDocuments.MODIFY(TRUE);
                 end;
               end;
               //QuoSII1.4.03.end
             end;

trigger OnModify();    var
//                Text0001@1000000000 :
               Text0001: TextConst ENU='No se puede modificar el documento %1 porque tiene estado %2.',ESP='No se puede modificar el documento %1 porque tiene estado %2.';
             begin
               //if (xRec."AEAT Status" IN ['CORRECTO','PARCIALMENTECORRECTO','ANULADA']) then  //QuoSII_1.4.0.012//QuoSII_1.4.02.042.18
               //  ERROR(Text0001,"Ship No.",'CORRECTO, PARCIALMENTECORRECTO o ANULADA');//QuoSII_1.4.02.042.18

               //QUOSII.T53.begin
               actualizarEstadoAEATIM(Rec."Ship No.", Rec."Document Type");
               //QUOSII.T53.end
             end;

trigger OnDelete();    var
//                SIIDocuments@1000000000 :
               SIIDocuments: Record 7174333;
//                Text0001@80000 :
               Text0001: TextConst ENU='No se puede eliminar el documento %1 porque tiene estado %2.',ESP='No se puede eliminar el documento %1 porque tiene estado %2.';
             begin
               SIIDocumentShipment.GET("Ship No.");

               //JAV 12/05/22: - QuoSII 1.06.07 Permitir eliminar l¡neas en estado CORRECTO cuando no han sido enviadas (tipo A1 y C-14)
               if (SIIDocumentShipment."Shipment Status" <> SIIDocumentShipment."Shipment Status"::Pendiente) and (UPPERCASE("AEAT Status") IN ['CORRECTO', 'PARCIALMENTECORRECTO', 'ANULADA']) then begin //QuoSII1.4
                 ERROR(Text0001,"Document No.","AEAT Status");
               end else begin
                 SIIDocuments.RESET;
                 SIIDocuments.SETRANGE("Document Type","Document Type");
                 SIIDocuments.SETRANGE("Document No.","Document No.");
                 SIIDocuments.SETRANGE("Entry No.","Entry No.");
                 SIIDocuments.SETRANGE("Register Type","Register Type");  //JAV Nuevo campo clave
                 if SIIDocuments.FINDFIRST then begin
                   SIIDocuments."Is Emited" := FALSE;
                   SIIDocuments.MODIFY;
                 end;
               end;

               //QUOSII.T53.begin
               actualizarEstadoAEATD(Rec."Ship No.", Rec."Document Type");
               //QUOSII.T53.end

               //QuoSII1.4.03.begin
               if SIIDocumentShipment."Shipment Type" = 'A0' then begin
                 SIIDocuments.RESET;
                 SIIDocuments.SETRANGE("Entry No.", "Entry No.");
                 SIIDocuments.SETRANGE("Register Type", "Register Type");
                 if SIIDocuments.FINDFIRST then begin
                   SIIDocuments.VALIDATE(Status, SIIDocuments.Status::" ");
                   SIIDocuments.MODIFY(TRUE);
                 end;
               end;
               //QuoSII1.4.03.end
             end;



// LOCAL procedure actualizarEstadoAEATIM (NoEnvio@1100286002 : Code[20];TipoDoc@1100286003 :
LOCAL procedure actualizarEstadoAEATIM (NoEnvio: Code[20];TipoDoc: Option)
    var
//       SIIDocShipLine@1100286000 :
      SIIDocShipLine: Record 7174336;
//       SIIDocShip@1100286001 :
      SIIDocShip: Record 7174335;
//       SIIDocuments@1000000000 :
      SIIDocuments: Record 7174333;
    begin
      //QUOSII.T53.begin
      SIIDocShipLine.RESET;
      SIIDocShipLine.SETFILTER(SIIDocShipLine."Ship No.",NoEnvio);
      SIIDocShipLine.SETFILTER(SIIDocShipLine."Document Type",FORMAT(TipoDoc));
      SIIDocShipLine.SETFILTER("Document No.",'<>%1',Rec."Document No.");
      SIIDocShipLine.SETRANGE(SIIDocShipLine."AEAT Status", 'INCORRECTO');
      if (not SIIDocShipLine.FINDFIRST()) and ("AEAT Status" <> 'INCORRECTO') then begin
        SIIDocShipLine.RESET;
        SIIDocShipLine.SETFILTER(SIIDocShipLine."Ship No.",NoEnvio);
        SIIDocShipLine.SETFILTER(SIIDocShipLine."Document Type",FORMAT(TipoDoc));
        SIIDocShipLine.SETFILTER("Document No.",'<>%1',Rec."Document No.");
        SIIDocShipLine.SETRANGE(SIIDocShipLine."AEAT Status", 'PARCIALMENTECORRECTO');
        if (not SIIDocShipLine.FINDFIRST()) and ("AEAT Status" <> 'PARCIALMENTECORRECTO') then begin
          SIIDocShipLine.RESET;
          SIIDocShipLine.SETFILTER(SIIDocShipLine."Ship No.",NoEnvio);
          SIIDocShipLine.SETFILTER(SIIDocShipLine."Document Type",FORMAT(TipoDoc));
          SIIDocShipLine.SETFILTER("Document No.",'<>%1',Rec."Document No.");
          SIIDocShipLine.SETRANGE(SIIDocShipLine."AEAT Status", '');
          if (not SIIDocShipLine.FINDFIRST()) and ("AEAT Status" <> '') then begin
            SIIDocShipLine.RESET;
            SIIDocShipLine.SETFILTER(SIIDocShipLine."Ship No.",NoEnvio);
            SIIDocShipLine.SETFILTER(SIIDocShipLine."Document Type",FORMAT(TipoDoc));
            SIIDocShipLine.SETFILTER("Document No.",'<>%1',Rec."Document No.");
            SIIDocShipLine.SETFILTER("AEAT Status",'%1|%2', 'CORRECTO','ANULADA'); //QuoSII1.4
            if (not SIIDocShipLine.FINDFIRST()) and (("AEAT Status" <> 'CORRECTO') or ("AEAT Status" <> 'ANULADA')) then begin //QuoSII1.4
              if ("AEAT Status" = 'CORRECTO') or ("AEAT Status" = 'ANULADA') then begin//QuoSII_1.4.02.042.18
                SIIDocShip.RESET;//QuoSII_1.4.02.042.18
                SIIDocShip.SETFILTER("Ship No.", NoEnvio);//QuoSII_1.4.02.042.18
                SIIDocShip.SETFILTER("Document Type", FORMAT(TipoDoc));//QuoSII_1.4.02.042.18
                if SIIDocShip.FINDFIRST then begin//QuoSII_1.4.02.042.18
                  SIIDocShip."AEAT Status" := 'CORRECTO';//QuoSII_1.4.02.042.18
                  SIIDocShip.MODIFY;//QuoSII_1.4.02.042.18
                end;//QuoSII_1.4.02.042.18
              end else begin//QuoSII_1.4.02.042.18
                SIIDocShip.RESET;//QuoSII_1.4.02.042.18
                SIIDocShip.SETFILTER("Ship No.", NoEnvio);//QuoSII_1.4.02.042.18
                SIIDocShip.SETFILTER("Document Type", FORMAT(TipoDoc));//QuoSII_1.4.02.042.18
                if SIIDocShip.FINDFIRST then begin//QuoSII_1.4.02.042.18
                  SIIDocShip."AEAT Status" := '';//QuoSII_1.4.02.042.18
                  SIIDocShip.MODIFY;//QuoSII_1.4.02.042.18
                end;
              end;
            end else begin
              SIIDocShip.RESET;
              SIIDocShip.SETFILTER("Ship No.", NoEnvio);
              SIIDocShip.SETFILTER("Document Type", FORMAT(TipoDoc));
              if SIIDocShip.FINDFIRST then begin
                SIIDocShip."AEAT Status" := 'CORRECTO'; //QuoSII_1.4.02.042.18
                SIIDocShip.MODIFY;
              end;
            end;
          end else begin
            SIIDocShip.RESET;
            SIIDocShip.SETFILTER("Ship No.", NoEnvio);
            SIIDocShip.SETFILTER("Document Type", FORMAT(TipoDoc));
            if SIIDocShip.FINDFIRST then begin
              SIIDocShip."AEAT Status" := '';
              SIIDocShip.MODIFY;
            end;
          end;
        end else begin
          SIIDocShip.RESET;
          SIIDocShip.SETFILTER("Ship No.", NoEnvio);
          SIIDocShip.SETFILTER("Document Type",FORMAT(TipoDoc));
          if SIIDocShip.FINDFIRST then begin
            SIIDocShip."AEAT Status" := 'PARCIALMENTECORRECTO';
            SIIDocShip.MODIFY;
          end;
        end;
      end else begin
        SIIDocShip.RESET;
        SIIDocShip.SETFILTER("Ship No.", NoEnvio);
        SIIDocShip.SETFILTER("Document Type", FORMAT(TipoDoc));
        if SIIDocShip.FINDFIRST then begin
          SIIDocShip."AEAT Status" := 'INCORRECTO';
          SIIDocShip.MODIFY;
        end;
      end;
      //QUOSII.T53.end
    end;

//     LOCAL procedure actualizarEstadoAEATD (NoEnvio@1100286002 : Code[20];TipoDoc@1100286003 :
    LOCAL procedure actualizarEstadoAEATD (NoEnvio: Code[20];TipoDoc: Option)
    var
//       SIIDocShipLine@1100286000 :
      SIIDocShipLine: Record 7174336;
//       SIIDocShip@1100286001 :
      SIIDocShip: Record 7174335;
    begin
      //QUOSII.T53.begin
      SIIDocShipLine.RESET;
      SIIDocShipLine.SETFILTER(SIIDocShipLine."Ship No.",NoEnvio);
      SIIDocShipLine.SETFILTER(SIIDocShipLine."Document Type",FORMAT(TipoDoc));
      SIIDocShipLine.SETFILTER("Document No.",'<>%1',Rec."Document No.");
      SIIDocShipLine.SETRANGE(SIIDocShipLine."AEAT Status", 'INCORRECTO');
      if not SIIDocShipLine.FINDFIRST() then begin
        SIIDocShipLine.RESET;
        SIIDocShipLine.SETFILTER(SIIDocShipLine."Ship No.",NoEnvio);
        SIIDocShipLine.SETFILTER(SIIDocShipLine."Document Type",FORMAT(TipoDoc));
        SIIDocShipLine.SETFILTER("Document No.",'<>%1',Rec."Document No.");
        SIIDocShipLine.SETRANGE(SIIDocShipLine."AEAT Status", 'PARCIALMENTECORRECTO');
        if not SIIDocShipLine.FINDFIRST() then begin
          SIIDocShipLine.RESET;
          SIIDocShipLine.SETFILTER(SIIDocShipLine."Ship No.",NoEnvio);
          SIIDocShipLine.SETFILTER(SIIDocShipLine."Document Type",FORMAT(TipoDoc));
          SIIDocShipLine.SETFILTER("Document No.",'<>%1',Rec."Document No.");
          SIIDocShipLine.SETRANGE(SIIDocShipLine."AEAT Status", '');
          if not SIIDocShipLine.FINDFIRST() then begin
            SIIDocShipLine.RESET;
            SIIDocShipLine.SETFILTER(SIIDocShipLine."Ship No.",NoEnvio);
            SIIDocShipLine.SETFILTER(SIIDocShipLine."Document Type",FORMAT(TipoDoc));
            SIIDocShipLine.SETFILTER("Document No.",'<>%1',Rec."Document No.");
            SIIDocShipLine.SETFILTER("AEAT Status",'%1|%2', 'CORRECTO','ANULADA');//QuoSII1.4
            if SIIDocShipLine.FINDFIRST() then begin
              SIIDocShip.RESET;
              SIIDocShip.SETFILTER("Ship No.", NoEnvio);
              SIIDocShip.SETFILTER("Document Type", FORMAT(TipoDoc));
              if SIIDocShip.FINDFIRST then begin
                SIIDocShip."AEAT Status" := 'CORRECTO';
                SIIDocShip.MODIFY;
              end;
            end else begin
              SIIDocShip.RESET;
              SIIDocShip.SETFILTER("Ship No.", NoEnvio);
              SIIDocShip.SETFILTER("Document Type", FORMAT(TipoDoc));
              if SIIDocShip.FINDFIRST then begin
                SIIDocShip."AEAT Status" := '';
                SIIDocShip.MODIFY;
              end;
            end;
          end else begin
            SIIDocShip.RESET;
            SIIDocShip.SETFILTER("Ship No.", NoEnvio);
            SIIDocShip.SETFILTER("Document Type", FORMAT(TipoDoc));
            if SIIDocShip.FINDFIRST then begin
              SIIDocShip."AEAT Status" := '';
              SIIDocShip.MODIFY;
            end;
          end;
        end else begin
          SIIDocShip.RESET;
          SIIDocShip.SETFILTER("Ship No.", NoEnvio);
          SIIDocShip.SETFILTER("Document Type",FORMAT(TipoDoc));
          if SIIDocShip.FINDFIRST then begin
            SIIDocShip."AEAT Status" := 'PARCIALMENTECORRECTO';
            SIIDocShip.MODIFY;
          end;
        end;
      end else begin
        SIIDocShip.RESET;
        SIIDocShip.SETFILTER("Ship No.", NoEnvio);
        SIIDocShip.SETFILTER("Document Type", FORMAT(TipoDoc));
        if SIIDocShip.FINDFIRST then begin
          SIIDocShip."AEAT Status" := 'INCORRECTO';
          SIIDocShip.MODIFY;
        end;
      end;
      //QUOSII.T53.end
    end;

    /*begin
    //{
//      QuoSII_1.3.02.005 171108 MCM - Se incluye el filtro 'Entry No.=FIELD(Entry No.)' en la propiedad CalcFormula de
//                                     los campos 'Base Imponible' e 'Importe IVA'
//      QuoSII1.4.03 09/03/2018 PEL
//      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci¢n de enviar a la ATCN
//      QuoSII_1.4.02.042.18 MCM 27/02/19 - Se modifica la propiedad Editable del campo AEAT Status.
//      JAV 08/09/21: - QuoSII 1.5z Se cambia el nombre del campo "Line Type" a "Register Type" que es mas informativo y as¡ no entra en confusi¢n con campos denominados Type
//      JAV 12/05/22: - QuoSII 1.06.07 Permitir eliminar l¡neas en estado CORRECTO cuando no han sido enviadas (tipo A1 y C-14)
//      JAV 09/09/22: - QuoSII 1.06.12 Se a¤ade el campo "Register Type" al CalcFormula de los campos 20 y 21
//    }
    end.
  */
}







