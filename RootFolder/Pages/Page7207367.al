page 7207367 "Quotes Rejected"
{
CaptionML=ENU='You will decline the selected quote.',ESP='Va a rechazar la oferta seleccionada.';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    DataCaptionExpression=' ';
    
  layout
{
area(content)
{
    field("JobQuote.No.";JobQuote."No.")
    {
        
                CaptionML=ENU='Quote No.',ESP='N§ oferta';
                Editable=False;
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("JobQuote.Description";JobQuote.Description)
    {
        
                CaptionML=ENU='Quote Description',ESP='Descripci¢n oferta';
                Editable=False;
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("Reasons";Reasons)
    {
        
                CaptionML=ENU='Reason for Rejection',ESP='Motivos de rechazo';
                TableRelation="Reason for Rejection";
                Style=StandardAccent;
                StyleExpr=TRUE ;
    }
    field("Rejected";Rejected)
    {
        
                CaptionML=ENU='Observations',ESP='Observaciones';
    }

}
}
  trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF (CloseAction = ACTION::LookupOK) AND (Reasons = '') THEN
                         ERROR(Text000);
                     END;



    var
      JobQuote : Record 167;
      Rejected : Text[60];
      Reasons : Code[20];
      Text000 : TextConst ENU='You must specify a reason for rejection',ESP='Debe especificar un motivo de rechazo';
      JobQuotesRejected : Record 167;
      Text19008225 : TextConst ENU='You will decline the selected quote. Are you sure?',ESP='Va a rechazar la oferta seleccionada.';

    procedure GetQuote(JQuote : Record 167);
    begin
      JobQuote := JQuote;
    end;

    procedure SetRejected(var Job : Record 167);
    begin
      if Reasons = '' then
        ERROR(Text000);

      Job."Quote Status" := Job."Quote Status"::Rejected;
      Job."Rejection Reason" := Reasons;
      Job."Approved/Refused By" := USERID;
      Job.Observations := Rejected;
    end;

    // begin//end
}







