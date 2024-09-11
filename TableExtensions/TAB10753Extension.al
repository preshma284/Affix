tableextension 50210 "QBU SII SessionExt" extends "SII Session"
{
  
  
    CaptionML=ENU='SII Session',ESP='Sesi¢n de SII';
  
  fields
{
}
  keys
{
   // key(key1;"Id")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  

    // procedure StoreRequestXml (RequestText@1100001 :

/*
procedure StoreRequestXml (RequestText: Text)
    var
//       TextMgt@1100002 :
      TextMgt: Codeunit 41;
//       OutStream@1100000 :
      OutStream: OutStream;
    begin
      "Request XML".CREATEOUTSTREAM(OutStream,TEXTENCODING::UTF8);
      OutStream.WRITETEXT(TextMgt.XMLTextIndent(RequestText));
      CALCFIELDS("Request XML");
      MODIFY;
    end;
*/


//     procedure StoreResponseXml (ResponseText@1100001 :
    
/*
procedure StoreResponseXml (ResponseText: Text)
    var
//       TextMgt@1100002 :
      TextMgt: Codeunit 41;
//       OutStream@1100000 :
      OutStream: OutStream;
    begin
      "Response XML".CREATEOUTSTREAM(OutStream,TEXTENCODING::UTF8);
      OutStream.WRITETEXT(TextMgt.XMLTextIndent(ResponseText));
      CALCFIELDS("Response XML");
      MODIFY;
    end;

    /*begin
    end.
  */
}





