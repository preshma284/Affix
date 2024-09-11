tableextension 50117 "MyExtension50117" extends "Purch. Comment Line"
{
  
  
    CaptionML=ENU='Purch. Comment Line',ESP='L¡n. comentario compra';
    LookupPageID="Purch. Comment List";
    DrillDownPageID="Purch. Comment List";
  
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
//       PurchCommentLine@1000 :
      PurchCommentLine: Record 43;
    begin
      PurchCommentLine.SETRANGE("Document Type","Document Type");
      PurchCommentLine.SETRANGE("No.","No.");
      PurchCommentLine.SETRANGE("Document Line No.","Document Line No.");
      PurchCommentLine.SETRANGE(Date,WORKDATE);
      if not PurchCommentLine.FINDFIRST then
        Date := WORKDATE;
    end;
*/


    
//     procedure CopyComments (FromDocumentType@1000 : Integer;ToDocumentType@1001 : Integer;FromNumber@1002 : Code[20];ToNumber@1003 :
    procedure CopyComments (FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    var
//       PurchCommentLine@1004 :
      PurchCommentLine: Record 43;
//       PurchCommentLine2@1005 :
      PurchCommentLine2: Record 43;
//       IsHandled@1006 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      //BS::19798 CSM 20/10/23  Í Campos filtrables Êcomentarios filtroË y Ênotas filtroË. -
      //se comenta l¡nea estandar BC13 y se incluye nueva llamada seg£n BC14.

      //OnBeforeCopyComments(PurchCommentLine,ToDocumentType,IsHandled);
      OnBeforeCopyComments(PurchCommentLine,ToDocumentType,IsHandled,FromDocumentType,FromNumber,ToNumber);
      //BS::19798 CSM 20/10/23  Í Campos filtrables Êcomentarios filtroË y Ênotas filtroË. +

      if IsHandled then
        exit;

      PurchCommentLine.SETRANGE("Document Type",FromDocumentType);
      PurchCommentLine.SETRANGE("No.",FromNumber);
      if PurchCommentLine.FINDSET then
        repeat
          PurchCommentLine2 := PurchCommentLine;
          PurchCommentLine2."Document Type" := ToDocumentType;
          PurchCommentLine2."No." := ToNumber;
          PurchCommentLine2.INSERT;
        until PurchCommentLine.NEXT = 0;
    end;

    
//     procedure CopyLineComments (FromDocumentType@1000 : Integer;ToDocumentType@1001 : Integer;FromNumber@1002 : Code[20];ToNumber@1003 : Code[20];FromDocumentLineNo@1008 : Integer;ToDocumentLineNo@1007 :
    
/*
procedure CopyLineComments (FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20];FromDocumentLineNo: Integer;ToDocumentLineNo: Integer)
    var
//       PurchCommentLineSource@1004 :
      PurchCommentLineSource: Record 43;
//       PurchCommentLineTarget@1005 :
      PurchCommentLineTarget: Record 43;
//       IsHandled@1006 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCopyLineComments(
        PurchCommentLineTarget,IsHandled,FromDocumentType,ToDocumentType,FromNumber,ToNumber,FromDocumentLineNo,ToDocumentLineNo);
      if IsHandled then
        exit;

      PurchCommentLineSource.SETRANGE("Document Type",FromDocumentType);
      PurchCommentLineSource.SETRANGE("No.",FromNumber);
      PurchCommentLineSource.SETRANGE("Document Line No.",FromDocumentLineNo);
      if PurchCommentLineSource.FINDSET then
        repeat
          PurchCommentLineTarget := PurchCommentLineSource;
          PurchCommentLineTarget."Document Type" := ToDocumentType;
          PurchCommentLineTarget."No." := ToNumber;
          PurchCommentLineTarget."Document Line No." := ToDocumentLineNo;
          PurchCommentLineTarget.INSERT;
        until PurchCommentLineSource.NEXT = 0;
    end;
*/


    
//     procedure CopyHeaderComments (FromDocumentType@1000 : Integer;ToDocumentType@1001 : Integer;FromNumber@1002 : Code[20];ToNumber@1003 :
    
/*
procedure CopyHeaderComments (FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    var
//       PurchCommentLineSource@1004 :
      PurchCommentLineSource: Record 43;
//       PurchCommentLineTarget@1005 :
      PurchCommentLineTarget: Record 43;
//       IsHandled@1006 :
      IsHandled: Boolean;
    begin
      IsHandled := FALSE;
      OnBeforeCopyHeaderComments(PurchCommentLineTarget,IsHandled,FromDocumentType,ToDocumentType,FromNumber,ToNumber);
      if IsHandled then
        exit;

      PurchCommentLineSource.SETRANGE("Document Type",FromDocumentType);
      PurchCommentLineSource.SETRANGE("No.",FromNumber);
      PurchCommentLineSource.SETRANGE("Document Line No.",0);
      if PurchCommentLineSource.FINDSET then
        repeat
          PurchCommentLineTarget := PurchCommentLineSource;
          PurchCommentLineTarget."Document Type" := ToDocumentType;
          PurchCommentLineTarget."No." := ToNumber;
          PurchCommentLineTarget.INSERT;
        until PurchCommentLineSource.NEXT = 0;
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
//       PurchCommentSheet@1000 :
      PurchCommentSheet: Page 66;
    begin
      SETRANGE("Document Type",DocType);
      SETRANGE("No.",DocNo);
      SETRANGE("Document Line No.",DocLineNo);
      CLEAR(PurchCommentSheet);
      PurchCommentSheet.SETTABLEVIEW(Rec);
      PurchCommentSheet.RUNMODAL;
    end;
*/


    
//     LOCAL procedure OnBeforeCopyComments (var PurchCommentLine@1000 : Record 43;ToDocumentType@1002 : Integer;var IsHandled@1001 : Boolean;FromDocumentType@1100286002 : Integer;FromNumber@1100286001 : Code[20];ToNumber@1100286000 :
    LOCAL procedure OnBeforeCopyComments (var PurchCommentLine: Record 43;ToDocumentType: Integer;var IsHandled: Boolean;FromDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    begin
      //BS::19798 CSM 20/10/23  Í Campos filtrables Êcomentarios filtroË y Ênotas filtroË.
      //se a¤aden 3 par metros seg£n BC-14.
    end;

    
//     LOCAL procedure OnBeforeCopyLineComments (var PurchCommentLine@1000 : Record 43;var IsHandled@1002 : Boolean;FromDocumentType@1005 : Integer;ToDocumentType@1001 : Integer;FromNumber@1004 : Code[20];ToNumber@1003 : Code[20];FromDocumentLineNo@1007 : Integer;ToDocumentLine@1006 :
    
/*
LOCAL procedure OnBeforeCopyLineComments (var PurchCommentLine: Record 43;var IsHandled: Boolean;FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20];FromDocumentLineNo: Integer;ToDocumentLine: Integer)
    begin
    end;
*/


    
//     LOCAL procedure OnBeforeCopyHeaderComments (var PurchCommentLine@1000 : Record 43;var IsHandled@1002 : Boolean;FromDocumentType@1005 : Integer;ToDocumentType@1001 : Integer;FromNumber@1004 : Code[20];ToNumber@1003 :
    
/*
LOCAL procedure OnBeforeCopyHeaderComments (var PurchCommentLine: Record 43;var IsHandled: Boolean;FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    begin
    end;

    /*begin
    //{
//      QBA5412 PGM 26/12/2018 - A¤adido campo User
//      BS::19798 CSM 20/10/23  Í Campos filtrables Êcomentarios filtroË y Ênotas filtroË.
//    }
    end.
  */
}




