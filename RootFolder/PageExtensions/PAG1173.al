pageextension 50114 MyExtension1173 extends 1173//1173
{
layout
{
addafter("Document Flow Sales")
{
    field("QFA Send";rec."QFA Send")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      FromRecRef : RecordRef;
      SalesDocumentFlow : Boolean;
      FileDialogTxt : TextConst ENU='Attachments (%1)|%1',ESP='Datos adjuntos (%1)|%1';
      FilterTxt : TextConst ENU='"*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*"',ESP='"*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*"';
      ImportTxt : TextConst ENU='Attach a document.',ESP='Permite adjuntar un documento.';
      SelectFileTxt : TextConst ENU='Select File...',ESP='Seleccionar archivo...';
      PurchaseDocumentFlow : Boolean;
      FlowToPurchTxt : TextConst ENU='Flow to Purch. Trx',ESP='Flujo a transac. compra';
      FlowToSalesTxt : TextConst ENU='Flow to Sales Trx',ESP='Flujo a transac. venta';
      FlowFieldsEditable : Boolean;

    
    

//procedure
//Local procedure GetCaptionClass(FieldNo : Integer) : Text;
//    begin
//      if ( SalesDocumentFlow and PurchaseDocumentFlow  )then
//        CASE FieldNo OF
//          9:
//            exit(FlowToPurchTxt);
//          11:
//            exit(FlowToSalesTxt);
//        end;
//    end;
//
//    //[External]
//procedure OpenForRecRef(RecRef : RecordRef);
//    var
//      FieldRef : FieldRef;
//      RecNo : Code[20];
//      DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
//      LineNo : Integer;
//    begin
//      Rec.RESET;
//
//      FromRecRef := RecRef;
//
//      Rec.SETRANGE("Table ID",RecRef.NUMBER);
//
//      if ( RecRef.NUMBER = DATABASE::Item  )then begin
//        SalesDocumentFlow := TRUE;
//        PurchaseDocumentFlow := TRUE;
//      end;
//
//      CASE RecRef.NUMBER OF
//        DATABASE::Customer,
//        DATABASE::"Sales Header",
//        DATABASE::"Sales Line",
//        DATABASE::"Sales Invoice Header",
//        DATABASE::"Sales Invoice Line",
//        DATABASE::"Sales Cr.Memo Header",
//        DATABASE::"Sales Cr.Memo Line":
//          SalesDocumentFlow := TRUE;
//        DATABASE::Vendor,
//        DATABASE::"Purchase Header",
//        DATABASE::"Purchase Line",
//        DATABASE::"Purch. Inv. Header",
//        DATABASE::"Purch. Inv. Line",
//        DATABASE::"Purch. Cr. Memo Hdr.",
//        DATABASE::"Purch. Cr. Memo Line":
//          PurchaseDocumentFlow := TRUE;
//      end;
//
//      CASE RecRef.NUMBER OF
//        DATABASE::Customer,
//        DATABASE::Vendor,
//        DATABASE::Item,
//        DATABASE::Employee,
//        DATABASE::"Fixed Asset",
//        DATABASE::Job,
//        DATABASE::Resource:
//          begin
//            FieldRef := RecRef.FIELD(1);
//            RecNo := FieldRef.VALUE;
//            Rec.SETRANGE("No.",RecNo);
//          end;
//      end;
//
//      CASE RecRef.NUMBER OF
//        DATABASE::"Sales Header",
//        DATABASE::"Sales Line",
//        DATABASE::"Purchase Header",
//        DATABASE::"Purchase Line":
//          begin
//            FieldRef := RecRef.FIELD(1);
//            DocType := FieldRef.VALUE;
//            Rec.SETRANGE("Document Type",DocType);
//
//            FieldRef := RecRef.FIELD(3);
//            RecNo := FieldRef.VALUE;
//            Rec.SETRANGE("No.",RecNo);
//
//            FlowFieldsEditable := FALSE;
//          end;
//      end;
//
//      CASE RecRef.NUMBER OF
//        DATABASE::"Sales Line",
//        DATABASE::"Purchase Line":
//          begin
//            FieldRef := RecRef.FIELD(4);
//            LineNo := FieldRef.VALUE;
//            Rec.SETRANGE("Line No.",LineNo);
//          end;
//      end;
//
//      CASE RecRef.NUMBER OF
//        DATABASE::"Sales Invoice Header",
//        DATABASE::"Sales Cr.Memo Header",
//        DATABASE::"Purch. Inv. Header",
//        DATABASE::"Purch. Cr. Memo Hdr.":
//          begin
//            FieldRef := RecRef.FIELD(3);
//            RecNo := FieldRef.VALUE;
//            Rec.SETRANGE("No.",RecNo);
//
//            FlowFieldsEditable := FALSE;
//          end;
//      end;
//
//      CASE RecRef.NUMBER OF
//        DATABASE::"Sales Invoice Line",
//        DATABASE::"Sales Cr.Memo Line",
//        DATABASE::"Purch. Inv. Line",
//        DATABASE::"Purch. Cr. Memo Line":
//          begin
//            FieldRef := RecRef.FIELD(3);
//            RecNo := FieldRef.VALUE;
//            Rec.SETRANGE("No.",RecNo);
//
//            FieldRef := RecRef.FIELD(4);
//            LineNo := FieldRef.VALUE;
//            Rec.SETRANGE("Line No.",LineNo);
//
//            FlowFieldsEditable := FALSE;
//          end;
//      end;
//
//      OnAfterOpenForRecRef(Rec,RecRef);
//    end;
//
//    [Integration]
//Local procedure OnAfterOpenForRecRef(var DocumentAttachment : Record 1173;var RecRef : RecordRef);
//    begin
//    end;

//procedure
}

