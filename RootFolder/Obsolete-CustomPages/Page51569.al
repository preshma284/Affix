page 51569 "Social Listening Setup FactBox"
{
CaptionML=ENU='Social Media Insights Setup',ESP='Configuraci�n de informaci�n de medios sociales';
    // SourceTable=871;
    PageType=CardPart;
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
    field("InfoText";InfoText)
    {
        
                CaptionML=ENU='Search Topic',ESP='Tema de b�squeda';
                ToolTipML=ENU='Specifies the search topic for social media insights.',ESP='Permite especificar el tema de b�squeda en informaci�n de medios sociales.';
                ApplicationArea=Suite;
                
                             

  // ;trigger OnDrillDown()    VAR
  //                             TempSocialListeningSearchTopic : Record 871 TEMPORARY ;
  //                           BEGIN
  //                             TempSocialListeningSearchTopic := Rec;
  //                             TempSocialListeningSearchTopic.INSERT;
  //                             PAGE.RUNMODAL(PAGE::"Social Listening Search Topic",TempSocialListeningSearchTopic);

  //                             IF TempSocialListeningSearchTopic.FIND AND
  //                                (TempSocialListeningSearchTopic."Search Topic" <> '')
  //                             THEN BEGIN
  //                               Rec.VALIDATE("Search Topic",TempSocialListeningSearchTopic."Search Topic");
  //                               IF NOT Rec.MODIFY THEN
  //                                 Rec.INSERT;
  //                               CurrPage.UPDATE;
  //                             END ELSE
  //                               IF Rec.DELETE THEN
  //                                 Rec.INIT;

  //                             SetInfoText;

  //                             CurrPage.UPDATE(FALSE);
  //                           END;


    }

}
}
  trigger OnAfterGetCurrRecord()    BEGIN
                           SetInfoText;
                         END;



    var
      InfoText : Text;
      SetupRequiredTxt : TextConst ENU='Setup is required',ESP='Se requiere configuraci�n';

    

LOCAL procedure SetInfoText();
    begin
      // if rec."Search Topic" = '' then
      //   InfoText := SetupRequiredTxt
      // ELSE
      //   InfoText := rec."Search Topic";
    end;

    // begin//end
}







