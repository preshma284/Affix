pageextension 50148 MyExtension20 extends 20//17
{
layout
{
addafter("Job No.")
{
    field("QB_PieceworkCode";rec."QB Piecework Code")
    {
        
}
//     field("Source Type";rec."Source Type")
//     {
        
// }
//     field("Source No.";rec."Source No.")
//     {
        
// }
    field("GetName";rec.GetName)
    {
        
                CaptionML=ENU='Name',ESP='Nombre';
}
} addafter("Global Dimension 2 Code")
{
    field("QB_Proyecto";FunctionQB.GetDimValueFromID(FunctionQB.ReturnDimJobs, Rec."Dimension Set ID"))
    {
        
                CaptionML=ESP='C¢d. Proyecto';
}
} addafter("External Document No.")
{
    field("QiuoSII Entity";rec."QiuoSII Entity")
    {
        
                Visible=vQuoSII ;
}
    field("QB_TransactionNo";rec."Transaction No.")
    {
        
}
} addafter("Period Trans. No.")
{
    field("QB Stocks Document Type";rec."QB Stocks Document Type")
    {
        
                Editable=false ;
}
    field("QB Stocks Document No";rec."QB Stocks Document No")
    {
        
                Editable=false ;
}
    field("QB Stocks Output Shipment Line";rec."QB Stocks Output Shipment Line")
    {
        
                Editable=false ;
}
    field("QB Stocks Item No.";rec."QB Stocks Item No.")
    {
        
                Editable=false ;
}
    field("DP_OriginalVATAmount";rec."DP Original VAT Amount")
    {
        
                Visible=seeProrrata or seeNonDeductible ;
}
    field("DP_NonDeductiblePorc";rec."DP Non Deductible %")
    {
        
                Visible=seeNonDeductible ;
}
    field("DP_NonDeductibleAmount";rec."DP Non Deductible Amount")
    {
        
                Visible=seeNonDeductible ;
}
    field("DP_Prorrata";rec."DP Prorrata Type")
    {
        
                Visible=seeProrrata ;
}
    field("DP_ProvProrrataPorc";rec."DP Prov. Prorrata %")
    {
        
                Visible=seeProrrata ;
}
}

}

actions
{
addafter("ReverseTransaction")
{
    action("FillSourceNo")
    {
        CaptionML=ENU='Fill Source No',ESP='Rellena N§ origen';
                    //   RunObject=Report 7207462;
                      Image=Action;
}
} addafter("SetPeriodTransNos")
{
group("Action1100286004")
{
        CaptionML=ESP='QuoBuilding';
                      //ActionContainerType=NewDocumentItems ;
    action("QB_ChangeDim")
    {
        
                      CaptionML=ENU='Change Dimensions',ESP='Modificar Dimensiones';
                      Visible=seeChangeDim;
                      Image=ChangeDimensions;
                      
                                
    trigger OnAction()    VAR
                                 GLEntry : Record 17;
                                //  QBChangeDimension : Report 7207329;
                               BEGIN
                                 GLEntry.SETRANGE(GLEntry."Entry No.",rec."Entry No.");
                                 GLEntry.FINDFIRST;
                                 GLEntry.SETRECFILTER;

                                 IF (CONFIRM('Ha seleccionado %1 registos a los que cambiar una dimensi¢n, este proceso es irreversible y puede ser largo. Confirme que desea hacerlo realmente', FALSE, GLEntry.COUNT)) THEN BEGIN
                                   COMMIT; //Por el RunModal
                                //    CLEAR(QBChangeDimension);
                                //    QBChangeDimension.SETTABLEVIEW(GLEntry);
                                //    QBChangeDimension.RUNMODAL;
                                 END;
                               END;


}
}
}

}

//trigger
trigger OnOpenPage()    BEGIN
                 SetConrolVisibility;

                 IF Rec.GETFILTERS <> '' THEN
                   IF Rec.FINDFIRST THEN;

                 //QB
                 vQuoSII := FunctionQB.AccessToQuoSII;

                 //JAV 29/11/21: - QB 1.10.03 Cambio de dimensiones
                 IF (UserSetup.GET(USERID)) THEN
                   seeChangeDim := UserSetup."Can Change Dimensions";

                 //JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
                 seeProrrata := DPManagement.AccessToProrrata;
                 seeNonDeductible := DPManagement.AccessToNonDeductible;  //JAV 14/07/22: - DP 1.00.04 Se a¤ade el IVA no deducible
               END;


//trigger

var
      GLAcc : Record 15;
      DimensionSetIDFilter : Page 481;
      HasIncomingDocument : Boolean;
      AmountVisible : Boolean;
      DebitCreditVisible : Boolean;
      "--------------------- QB" : Integer;
      UserSetup : Record 91;
      FunctionQB : Codeunit 7207272;
      vQuoSII : Boolean;
      seeChangeDim : Boolean;
      "----------------------------------------------- Prorrata" : Integer;
      DPManagement : Codeunit 7174414;
      seeProrrata : Boolean;
      seeNonDeductible : Boolean;

    
    

//procedure
//Local procedure GetCaption() : Text[250];
//    begin
//      if ( GLAcc."No." <> rec."G/L Account No."  )then
//        if ( not GLAcc.GET(rec."G/L Account No.")  )then
//          if ( Rec.GETFILTER(rec."G/L Account No.") <> ''  )then
//            if ( GLAcc.GET(Rec.GETRANGEMIN(rec."G/L Account No."))  )then;
//      exit(STRSUBSTNO('%1 %2',GLAcc."No.",GLAcc.Name))
//    end;
Local procedure SetConrolVisibility();
   var
     GLSetup : Record 98;
   begin
     GLSetup.GET;
     AmountVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Debit/Credit Only");
     DebitCreditVisible := not (GLSetup."Show Amounts" = GLSetup."Show Amounts"::"Amount Only");
   end;

//procedure
}

