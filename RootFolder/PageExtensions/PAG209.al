pageextension 50152 MyExtension209 extends 209//204
{
layout
{
addafter("International Standard Code")
{
    field("QFA Unit of measure code FACE";rec."QFA Unit of measure code FACE")
    {
        
                Visible=seeFacturae ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    VAR
                 CRMIntegrationManagement : Codeunit 5330;
               BEGIN
                 CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
                 //QFA
                 seeFacturae := FunctionQB.AccessToFacturae;
               END;


//trigger

var
      CRMIntegrationEnabled : Boolean;
      CRMIsCoupledToRecord : Boolean;
      "---------------------------- QB" : Integer;
      seeFacturae : Boolean;
      FunctionQB : Codeunit 7207272;

    

//procedure

//procedure
}

