pageextension 50146 MyExtension193 extends 193//137
{
layout
{


}

actions
{


}

//trigger

//trigger

var
      MainRecordRef : RecordRef;
      StyleExpressionTxt : Text;

    

//procedure
//procedure LoadDataFromRecord(MainRecordVariant : Variant);
//    var
//      IncomingDocument : Record 130;
//      DataTypeManagement : Codeunit 701;
//    begin
//      if ( not DataTypeManagement.GetRecordRef(MainRecordVariant,MainRecordRef)  )then
//        exit;
//
//      Rec.DELETEALL;
//
//      if ( not MainRecordRef.GET(MainRecordRef.RECORDID)  )then
//        exit;
//
//      if ( GetIncomingDocumentRecord(MainRecordVariant,IncomingDocument)  )then
//        rec.InsertFromIncomingDocument(IncomingDocument,Rec);
//      CurrPage.UPDATE(FALSE);
//    end;
//
//    //[External]
//procedure LoadDataFromIncomingDocument(IncomingDocument : Record 130);
//    begin
//      Rec.DELETEALL;
//      rec.InsertFromIncomingDocument(IncomingDocument,Rec);
//      CurrPage.UPDATE(FALSE);
//    end;
//
//    //[External]
//procedure GetIncomingDocumentRecord(MainRecordVariant : Variant;var IncomingDocument : Record 130) : Boolean;
//    var
//      DataTypeManagement : Codeunit 701;
//    begin
//      if ( not DataTypeManagement.GetRecordRef(MainRecordVariant,MainRecordRef)  )then
//        exit(FALSE);
//
//      CASE MainRecordRef.NUMBER OF
//        DATABASE::"Incoming Document":
//          begin
//            IncomingDocument.COPY(MainRecordVariant);
//            exit(TRUE);
//          end;
//        ELSE begin
//          if ( IncomingDocument.FindFromIncomingDocumentEntryNo(MainRecordRef,IncomingDocument)  )then
//            exit(TRUE);
//          if ( IncomingDocument.FindByDocumentNoAndPostingDate(MainRecordRef,IncomingDocument)  )then
//            exit(TRUE);
//          exit(FALSE);
//        end;
//      end;
//    end;
LOCAL procedure "-------------------------------------- QB"();
    begin
    end;
procedure SendUpdate();
    begin
      CurrPage.UPDATE(FALSE);
    end;

//procedure
}

