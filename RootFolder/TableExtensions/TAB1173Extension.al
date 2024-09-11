tableextension 50186 "MyExtension50186" extends "Document Attachment"
{
  
  
    CaptionML=ENU='Document Attachment',ESP='Documento adjunto';
  
  fields
{
    field(7174365;"QFA Send";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Send to Facturae',ESP='Enviar a Facturae';
                                                   Description='QFA 1.3i - JAV 31/03/21 - Si se env¡a como adjunto a Facturae' ;


    }
}
  keys
{
   // key(key1;"Table ID","No.","Document Type","Line No.","ID")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(Brick;"No.","File Name","File Extension","File Type")
   // {
       // 
   // }
}
  
    var
//       NoDocumentAttachedErr@1000 :
      NoDocumentAttachedErr: TextConst ENU='Please attach a document first.',ESP='Adjunte primero un documento.';
//       EmptyFileNameErr@1006 :
      EmptyFileNameErr: TextConst ENU='Please choose a file to attach.',ESP='Elija un archivo para adjuntar.';
//       NoContentErr@1007 :
      NoContentErr: TextConst ENU='The selected file has no content. Please choose another file.',ESP='El archivo seleccionado no tiene contenido. Elija otro archivo.';
//       FileManagement@1001 :
      FileManagement: Codeunit 419;
//       IncomingFileName@1003 :
      IncomingFileName: Text;
//       DuplicateErr@1002 :
      DuplicateErr: TextConst ENU='This file is already attached to the document. Please choose another file.',ESP='Este archivo ya est  adjunto al documento. Elija otro archivo.';

    
    


/*
trigger OnInsert();    begin
               if IncomingFileName <> '' then begin
                 VALIDATE("File Extension",FileManagement.GetExtension(IncomingFileName));
                 VALIDATE("File Name",COPYSTR(FileManagement.GetFileNameWithoutExtension(IncomingFileName),1,MAXSTRLEN("File Name")));
               end;

               if not "Document Reference ID".HASVALUE then
                 ERROR(NoDocumentAttachedErr);

               VALIDATE("Attached Date",CURRENTDATETIME);
               "Attached By" := USERSECURITYID;
             end;

*/



// procedure Export (ShowFileDialog@1002 :

/*
procedure Export (ShowFileDialog: Boolean) : Text;
    var
//       TempBlob@1001 :
      TempBlob: Record 99008535;
//       FileManagement@1000 :
      FileManagement: Codeunit 419;
//       DocumentStream@1004 :
      DocumentStream: OutStream;
//       FullFileName@1006 :
      FullFileName: Text;
    begin
      if ID = 0 then
        exit;
      // Ensure document has value in DB
      if not "Document Reference ID".HASVALUE then
        exit;

      FullFileName := "File Name" + '.' + "File Extension";
      //TempBlob.Blob.CREATEOUTSTREAM(DocumentStream); 
 //To be tested 
 TempBlob.CREATEOUTSTREAM(DocumentStream);
      "Document Reference ID".EXPORTSTREAM(DocumentStream);
      exit(FileManagement.BLOBExport(TempBlob,FullFileName,ShowFileDialog));
    end;
*/


    
//     procedure SaveAttachment (RecRef@1001 : RecordRef;FileName@1000 : Text;TempBlob@1003 :
    
/*
procedure SaveAttachment (RecRef: RecordRef;FileName: Text;TempBlob: Record 99008535)
    var
//       FieldRef@1007 :
      FieldRef: FieldRef;
//       DocStream@1004 :
      DocStream: InStream;
//       RecNo@1006 :
      RecNo: Code[20];
//       DocType@1005 :
      DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
//       LineNo@1002 :
      LineNo: Integer;
    begin
      OnBeforeSaveAttachment(Rec,RecRef,FileName,TempBlob);

      if FileName = '' then
        ERROR(EmptyFileNameErr);
      // Validate file/media is not empty
      if not TempBlob.HASVALUE then
        ERROR(NoContentErr);

      IncomingFileName := FileName;

      VALIDATE("File Extension",FileManagement.GetExtension(IncomingFileName));
      VALIDATE("File Name",COPYSTR(FileManagement.GetFileNameWithoutExtension(IncomingFileName),1,MAXSTRLEN("File Name")));

      //TempBlob.Blob.CREATEINSTREAM(DocStream); 
 //To be tested 
 TempBlob.CREATEINSTREAM(DocStream);
      // IMPORTSTREAM(stream,description, mime-type,filename)
      // description and mime-type are set empty and will be automatically set by platform code from the stream
      "Document Reference ID".IMPORTSTREAM(DocStream,'','',IncomingFileName);
      if not "Document Reference ID".HASVALUE then
        ERROR(NoDocumentAttachedErr);

      VALIDATE("Table ID",RecRef.NUMBER);

      CASE RecRef.NUMBER OF
        DATABASE::Customer,
        DATABASE::Vendor,
        DATABASE::Item,
        DATABASE::Employee,
        DATABASE::"Fixed Asset",
        DATABASE::Resource,
        DATABASE::Job:
          begin
            FieldRef := RecRef.FIELD(1);
            RecNo := FieldRef.VALUE;
            VALIDATE("No.",RecNo);
          end;
      end;

      CASE RecRef.NUMBER OF
        DATABASE::"Sales Header",
        DATABASE::"Purchase Header",
        DATABASE::"Sales Line",
        DATABASE::"Purchase Line":
          begin
            FieldRef := RecRef.FIELD(1);
            DocType := FieldRef.VALUE;
            VALIDATE("Document Type",DocType);

            FieldRef := RecRef.FIELD(3);
            RecNo := FieldRef.VALUE;
            VALIDATE("No.",RecNo);
          end;
      end;

      CASE RecRef.NUMBER OF
        DATABASE::"Sales Line",
        DATABASE::"Purchase Line":
          begin
            FieldRef := RecRef.FIELD(4);
            LineNo := FieldRef.VALUE;
            VALIDATE("Line No.",LineNo);
          end;
      end;

      CASE RecRef.NUMBER OF
        DATABASE::"Sales Invoice Header",
        DATABASE::"Sales Cr.Memo Header",
        DATABASE::"Purch. Inv. Header",
        DATABASE::"Purch. Cr. Memo Hdr.":
          begin
            FieldRef := RecRef.FIELD(3);
            RecNo := FieldRef.VALUE;
            VALIDATE("No.",RecNo);
          end;
      end;

      CASE RecRef.NUMBER OF
        DATABASE::"Sales Invoice Line",
        DATABASE::"Sales Cr.Memo Line",
        DATABASE::"Purch. Inv. Line",
        DATABASE::"Purch. Cr. Memo Line":
          begin
            FieldRef := RecRef.FIELD(3);
            RecNo := FieldRef.VALUE;
            VALIDATE("No.",RecNo);

            FieldRef := RecRef.FIELD(4);
            LineNo := FieldRef.VALUE;
            VALIDATE("Line No.",LineNo);
          end;
      end;

      OnBeforeInsertAttachment(Rec,RecRef);
      INSERT(TRUE);
    end;
*/


    
//     LOCAL procedure OnBeforeInsertAttachment (var DocumentAttachment@1000 : Record 1173;var RecRef@1001 :
    
/*
LOCAL procedure OnBeforeInsertAttachment (var DocumentAttachment: Record 1173;var RecRef: RecordRef)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeSaveAttachment (var DocumentAttachment@1000 : Record 1173;var RecRef@1003 : RecordRef;FileName@1002 : Text;var TempBlob@1001 :
    
/*
LOCAL procedure OnBeforeSaveAttachment (var DocumentAttachment: Record 1173;var RecRef: RecordRef;FileName: Text;var TempBlob: Record 99008535)
    begin
    end;

    /*begin
    end.
  */
}




