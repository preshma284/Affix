pageextension 50221 MyExtension5200 extends 5200//5200
{
layout
{
addafter("General")
{
    part("QM_Data_Synchronization_Log";7174395)
    {
        
                SubPageView=SORTING("Table","RecordID","With Company");SubPageLink="Table"=CONST(18), "Code 1"=field("No.");
                Visible=verMasterData;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 QMMasterDataManagement : Codeunit 7174368;
               BEGIN
                 SetNoFieldVisible;
                 IsCountyVisible := FormatAddress.UseCounty(rec."Country/Region Code");

                 //JAV 01/03/21: - QB 1.08.19 Se pasan funciones de QBSetup a Functions QB
                 //JAV 14/02/22: - QM 1.00.00 Se pasana las funciones de MasterData a su propia CU
                 verMasterData := QMMasterDataManagement.SetMasterDataVisible(DATABASE::Employee);
               END;
trigger OnAfterGetCurrRecord()    VAR
                           QMMasterDataManagement : Codeunit 7174368;
                         BEGIN
                           //JAV 14/02/22: - QM 1.00.00 Se pasan los valores adecuados a la subp gina
                           CurrPage.QM_Data_Synchronization_Log.PAGE.SetData(Rec.RECORDID);
                         END;


//trigger

var
      ShowMapLbl : TextConst ENU='Show on Map',ESP='Mostrar en el mapa';
      FormatAddress : Codeunit 365;
      NoFieldVisible : Boolean;
      IsCountyVisible : Boolean;
      "------------------------ QB" : Integer;
      FunctionQB : Codeunit 7207272;
      verMasterData : Boolean;

    
    

//procedure
Local procedure SetNoFieldVisible();
   var
     DocumentNoVisibility : Codeunit 1400;
   begin
     NoFieldVisible := DocumentNoVisibility.EmployeeNoIsVisible;
   end;

//procedure
}

