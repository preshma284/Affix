pageextension 50278 MyExtension77 extends 77//156
{
layout
{
addafter("Type")
{
    field("QB Proformable";rec."QB Proformable")
    {
        
}
    field("Global Dimension 1 Code";rec."Global Dimension 1 Code")
    {
        
}
}

}

actions
{
addafter("Costs")
{
    action("QB_GetTransferCost")
    {
        CaptionML=ENU='Transfer Cost',ESP='Costes de Cesi¢n';
                      Visible=FALSE;
                      Image=CalculateCost;
                      Promoted=true;
                      PromotedCategory=Process;
}
}

}

//trigger

//trigger

var
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;

    

//procedure
//procedure GetSelectionFilter() : Text;
//    var
//      Resource : Record 156;
//      SelectionFilterManagement : Codeunit 46;
//    begin
//      CurrPage.SETSELECTIONFILTER(Resource);
//      exit(SelectionFilterManagement.GetSelectionFilterForResource(Resource));
//    end;
//
//    //[External]
//procedure SetSelection(var Resource : Record 156);
//    begin
//      CurrPage.SETSELECTIONFILTER(Resource);
//    end;

//procedure
}

