table 7174372 "QBU QuoFacturae Session"
{
  
  
    CaptionML=ENU='QuoFacturae Session',ESP='Sesi¢n QuoFacturae';
  
  fields
{
    field(1;"Id";Integer)
    {
        AutoIncrement=true;
                                                   CaptionML=ENU='Id',ESP='Id';
                                                   NotBlank=true;


    }
    field(2;"Request XML";BLOB)
    {
        CaptionML=ENU='Request XML',ESP='Request XML';


    }
    field(3;"Response XML";BLOB)
    {
        CaptionML=ENU='Response XML',ESP='Response XML';


    }
    field(10;"Request XML Len";Integer)
    {
        DataClassification=ToBeClassified;


    }
    field(11;"Response XML Len";Integer)
    {
        DataClassification=ToBeClassified ;


    }
}
  keys
{
    key(key1;"Id")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    // procedure StoreRequestXml (RequestText@1100001 :
procedure StoreRequestXml (RequestText: Text)
    var
//       OutStream@1100000 :
      OutStream: OutStream;
    begin
      "Request XML".CREATEOUTSTREAM(OutStream,TEXTENCODING::UTF8);
      OutStream.WRITE(RequestText);
      CALCFIELDS("Request XML");
      "Request XML Len" := "Request XML".LENGTH;
      MODIFY;
    end;

//     procedure StoreResponseXml (ResponseText@1100001 :
    procedure StoreResponseXml (ResponseText: Text)
    var
//       OutStream@1100000 :
      OutStream: OutStream;
    begin
      "Response XML".CREATEOUTSTREAM(OutStream,TEXTENCODING::UTF8);
      OutStream.WRITE(ResponseText);
      CALCFIELDS("Response XML");
      "Response XML Len" := "Response XML".LENGTH;
      MODIFY;
    end;

    /*begin
    end.
  */
}







