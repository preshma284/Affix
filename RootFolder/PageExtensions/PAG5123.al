pageextension 50216 MyExtension5123 extends 5123//5092
{
layout
{
addafter("CurrSalesCycleStage")
{
    field("QB_QuoteNo";rec."Quote No.")
    {
        
}
}

}

actions
{
addafter("Co&mments")
{
    action("QB_SeeQuote")
    {
        
                      CaptionML=ENU='See Quote',ESP='Mostrar estudio';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=quote;
                      
                                trigger OnAction()    VAR
                                 rJob : Record 167;
                               BEGIN
                                 IF rJob.GET(rec."Quote No.") THEN
                                   PAGE.RUN(PAGE::"Quotes Card",rJob);
                               END;


}
}

}

//trigger

//trigger

var
      Text001 : TextConst ENU='untitled',ESP='SinT¡tulo';
      OppNotStarted : Boolean;
      OppInProgress : Boolean;
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      CurrSalesCycleStage : Text;

    
    

//procedure
//Local procedure Caption() : Text[260];
//    var
//      CaptionStr : Text[260];
//    begin
//      CASE TRUE OF
//        BuildCaptionContact(CaptionStr,Rec.GETFILTER(rec."Contact Company No.")),
//        BuildCaptionContact(CaptionStr,Rec.GETFILTER(rec."Contact No.")),
//        BuildCaptionSalespersonPurchaser(CaptionStr,Rec.GETFILTER(rec."Salesperson Code")),
//        BuildCaptionCampaign(CaptionStr,Rec.GETFILTER(rec."Campaign No.")),
//        BuildCaptionSegmentHeader(CaptionStr,Rec.GETFILTER(rec."Segment No.")):
//          exit(CaptionStr)
//      end;
//
//      exit(Text001);
//    end;
//Local procedure BuildCaptionContact(var CaptionText : Text[260];Filter : Text) : Boolean;
//    var
//      Contact : Record 5050;
//    begin
//      WITH Contact DO
//        exit(BuildCaption(CaptionText,Contact,Filter,FIELDNO(rec."No."),FIELDNO(Name)));
//    end;
//Local procedure BuildCaptionSalespersonPurchaser(var CaptionText : Text[260];Filter : Text) : Boolean;
//    var
//      SalespersonPurchaser : Record 13;
//    begin
//      WITH SalespersonPurchaser DO
//        exit(BuildCaption(CaptionText,SalespersonPurchaser,Filter,FIELDNO(Code),FIELDNO(Name)));
//    end;
//Local procedure BuildCaptionCampaign(var CaptionText : Text[260];Filter : Text) : Boolean;
//    var
//      Campaign : Record 5071;
//    begin
//      WITH Campaign DO
//        exit(BuildCaption(CaptionText,Campaign,Filter,FIELDNO(rec."No."),FIELDNO(rec."Description")));
//    end;
//Local procedure BuildCaptionSegmentHeader(var CaptionText : Text[260];Filter : Text) : Boolean;
//    var
//      SegmentHeader : Record 5076;
//    begin
//      WITH SegmentHeader DO
//        exit(BuildCaption(CaptionText,SegmentHeader,Filter,FIELDNO(rec."No."),FIELDNO(rec."Description")));
//    end;
//Local procedure BuildCaption(var CaptionText : Text[260];RecVar : Variant;Filter : Text;IndexFieldNo : Integer;TextFieldNo : Integer) : Boolean;
//    var
//      RecRef : RecordRef;
//      IndexFieldRef : FieldRef;
//      TextFieldRef : FieldRef;
//    begin
//      Filter := DELCHR(Filter,'<>','''');
//      if ( Filter <> ''  )then begin
//        RecRef.GETTABLE(RecVar);
//        IndexFieldRef := RecRef.FIELD(IndexFieldNo);
//        IndexFieldRef.SETRANGE(Filter);
//        if ( RecRef.FINDFIRST  )then begin
//          TextFieldRef := RecRef.FIELD(TextFieldNo);
//          CaptionText := COPYSTR(FORMAT(IndexFieldRef.VALUE) + ' ' + FORMAT(TextFieldRef.VALUE),1,MAXSTRLEN(CaptionText));
//        end;
//      end;
//
//      exit(Filter <> '');
//    end;

//procedure
}

