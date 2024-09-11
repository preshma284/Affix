tableextension 50118 "MyExtension50118" extends "Sales Comment Line"
{
  
  
    CaptionML=ENU='Sales Comment Line',ESP='L¡n. comentario venta';
    LookupPageID="Sales Comment List";
    DrillDownPageID="Sales Comment List";
  
  fields
{
    field(7207271;"User";Code[50])
    {
        TableRelation=User."User Name";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User',ESP='Usuario';
                                                   Description='QB 1.00 - QBA5412' ;


    }
}
  keys
{
   // key(key1;"Document Type","No.","Document Line No.","Line No.")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  

    
    
/*
procedure SetUpNewLine ()
    var
//       SalesCommentLine@1000 :
      SalesCommentLine: Record 44;
    begin
      SalesCommentLine.SETRANGE("Document Type","Document Type");
      SalesCommentLine.SETRANGE("No.","No.");
      SalesCommentLine.SETRANGE("Document Line No.","Document Line No.");
      SalesCommentLine.SETRANGE(Date,WORKDATE);
      if not SalesCommentLine.FINDFIRST then
        Date := WORKDATE;
    end;
*/


    
//     procedure CopyComments (FromDocumentType@1000 : Integer;ToDocumentType@1001 : Integer;FromNumber@1002 : Code[20];ToNumber@1003 :
    
/*
procedure CopyComments (FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    var
//       SalesCommentLine@1004 :
      SalesCommentLine: Record 44;
//       SalesCommentLine2@1005 :
      SalesCommentLine2: Record 44;
//       IsHandled@1006 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCopyComments(SalesCommentLine,ToDocumentType,IsHandled);
      if IsHandled then
        exit;

      SalesCommentLine.SETRANGE("Document Type",FromDocumentType);
      SalesCommentLine.SETRANGE("No.",FromNumber);
      if SalesCommentLine.FINDSET then
        repeat
          SalesCommentLine2 := SalesCommentLine;
          SalesCommentLine2."Document Type" := ToDocumentType;
          SalesCommentLine2."No." := ToNumber;
          SalesCommentLine2.INSERT;
        until SalesCommentLine.NEXT = 0;
    end;
*/


    
//     procedure CopyLineComments (FromDocumentType@1000 : Integer;ToDocumentType@1001 : Integer;FromNumber@1002 : Code[20];ToNumber@1003 : Code[20];FromDocumentLineNo@1008 : Integer;ToDocumentLineNo@1007 :
    
/*
procedure CopyLineComments (FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20];FromDocumentLineNo: Integer;ToDocumentLineNo: Integer)
    var
//       SalesCommentLineSource@1004 :
      SalesCommentLineSource: Record 44;
//       SalesCommentLineTarget@1005 :
      SalesCommentLineTarget: Record 44;
//       IsHandled@1006 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCopyLineComments(
        SalesCommentLineTarget,IsHandled,FromDocumentType,ToDocumentType,FromNumber,ToNumber,FromDocumentLineNo,ToDocumentLineNo);
      if IsHandled then
        exit;

      SalesCommentLineSource.SETRANGE("Document Type",FromDocumentType);
      SalesCommentLineSource.SETRANGE("No.",FromNumber);
      SalesCommentLineSource.SETRANGE("Document Line No.",FromDocumentLineNo);
      if SalesCommentLineSource.FINDSET then
        repeat
          SalesCommentLineTarget := SalesCommentLineSource;
          SalesCommentLineTarget."Document Type" := ToDocumentType;
          SalesCommentLineTarget."No." := ToNumber;
          SalesCommentLineTarget."Document Line No." := ToDocumentLineNo;
          SalesCommentLineTarget.INSERT;
        until SalesCommentLineSource.NEXT = 0;
    end;
*/


    
//     procedure CopyHeaderComments (FromDocumentType@1000 : Integer;ToDocumentType@1001 : Integer;FromNumber@1002 : Code[20];ToNumber@1003 :
    
/*
procedure CopyHeaderComments (FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    var
//       SalesCommentLineSource@1004 :
      SalesCommentLineSource: Record 44;
//       SalesCommentLineTarget@1005 :
      SalesCommentLineTarget: Record 44;
//       IsHandled@1006 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCopyHeaderComments(SalesCommentLineTarget,IsHandled,FromDocumentType,ToDocumentType,FromNumber,ToNumber);
      if IsHandled then
        exit;

      SalesCommentLineSource.SETRANGE("Document Type",FromDocumentType);
      SalesCommentLineSource.SETRANGE("No.",FromNumber);
      SalesCommentLineSource.SETRANGE("Document Line No.",0);
      if SalesCommentLineSource.FINDSET then
        repeat
          SalesCommentLineTarget := SalesCommentLineSource;
          SalesCommentLineTarget."Document Type" := ToDocumentType;
          SalesCommentLineTarget."No." := ToNumber;
          SalesCommentLineTarget.INSERT;
        until SalesCommentLineSource.NEXT = 0;
    end;
*/


    
//     procedure DeleteComments (DocType@1000 : Option;DocNo@1001 :
    
/*
procedure DeleteComments (DocType: Option;DocNo: Code[20])
    begin
      SETRANGE("Document Type",DocType);
      SETRANGE("No.",DocNo);
      if not ISEMPTY then
        DELETEALL;
    end;
*/


    
//     procedure ShowComments (DocType@1001 : Option;DocNo@1002 : Code[20];DocLineNo@1003 :
    
/*
procedure ShowComments (DocType: Option;DocNo: Code[20];DocLineNo: Integer)
    var
//       SalesCommentSheet@1000 :
      SalesCommentSheet: Page 67;
    begin
      SETRANGE("Document Type",DocType);
      SETRANGE("No.",DocNo);
      SETRANGE("Document Line No.",DocLineNo);
      CLEAR(SalesCommentSheet);
      SalesCommentSheet.SETTABLEVIEW(Rec);
      SalesCommentSheet.RUNMODAL;
    end;
*/


    
//     LOCAL procedure OnBeforeCopyComments (var SalesCommentLine@1000 : Record 44;ToDocumentType@1001 : Integer;var IsHandled@1002 :
    
/*
LOCAL procedure OnBeforeCopyComments (var SalesCommentLine: Record 44;ToDocumentType: Integer;var IsHandled: Boolean)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCopyLineComments (var SalesCommentLine@1000 : Record 44;var IsHandled@1002 : Boolean;FromDocumentType@1005 : Integer;ToDocumentType@1001 : Integer;FromNumber@1004 : Code[20];ToNumber@1003 : Code[20];FromDocumentLineNo@1007 : Integer;ToDocumentLine@1006 :
    
/*
LOCAL procedure OnBeforeCopyLineComments (var SalesCommentLine: Record 44;var IsHandled: Boolean;FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20];FromDocumentLineNo: Integer;ToDocumentLine: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCopyHeaderComments (var SalesCommentLine@1000 : Record 44;var IsHandled@1002 : Boolean;FromDocumentType@1005 : Integer;ToDocumentType@1001 : Integer;FromNumber@1004 : Code[20];ToNumber@1003 :
    
/*
LOCAL procedure OnBeforeCopyHeaderComments (var SalesCommentLine: Record 44;var IsHandled: Boolean;FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    begin
    end;

    /*begin
    //{
//      QBA5412 PGM 26/12/2018 - A¤adido campo User
//    }
    end.
  */
}




