controladdin "Microsoft.Dynamics.Nav.Client.SocialListening" {
EVENT AddInReady();
EVENT DetermineUserAuthenticationResult(result : Integer);
EVENT MessageLinkClick(identifier : Integer);
}

//Obsolete page
page 51568 "Social Listening FactBox"
{
CaptionML=ENU='Social Media Insights',ESP='Informaci�n de medios sociales';
    // SourceTable=871;
    PageType=CardPart;
    
  layout
{
area(content)
{
    usercontrol("SocialListening";"Microsoft.Dynamics.Nav.Client.SocialListening")
    {
        trigger AddInReady();
    BEGIN
      IsAddInReady := TRUE;
      UpdateAddIn;
    END;

    trigger DetermineUserAuthenticationResult(result : Integer);
    BEGIN
      // CASE result OF
      //   -1: // Error
      //     CurrPage.SocialListening.ShowMessage(SocialListeningMgt.GetAuthenticationConectionErrorMsg);
      //   0: // User is not authenticated
      //     CurrPage.SocialListening.ShowMessage(SocialListeningMgt.GetAuthenticationUserErrorMsg);
      //   1: // User is authenticated
      //     CurrPage.SocialListening.ShowWidget(SocialListeningMgt.GetAuthenticationWidget(rec."Search Topic"));
      // END;
    END;

    trigger MessageLinkClick(identifier : Integer);
    BEGIN
      CASE identifier OF
        1: // Refresh
          UpdateAddIn;
      END;
    END;

        }

}
}
  


trigger OnAfterGetCurrRecord()    BEGIN
                           IsDataReady := TRUE;
                           UpdateAddIn;
                         END;



    var
      SocialListeningMgt : Codeunit 50455;
      IsDataReady : Boolean;
      IsAddInReady : Boolean;

    LOCAL procedure UpdateAddIn();
    var
      // SocialListeningSetup : Record 870;
    begin
      // if rec."Search Topic" = '' then
      //   exit;
      // if not IsAddInReady then
      //   exit;

      // if not IsDataReady then
      //   exit;

      // if not SocialListeningSetup.GET or
      //    (SocialListeningSetup."Solution ID" = '')
      // then
      //   exit;

      // CurrPage.SocialListening.DetermineUserAuthentication(SocialListeningMgt.MSLAuthenticationStatusURL);
    end;

    // begin//end
}







