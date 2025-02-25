pageextension 50229 MyExtension560 extends 560//349
{
layout
{
addafter("Consolidation Code")
{
    field("Type";rec."Type")
    {
        
                Visible=seeCA ;
}
    field("Jobs desviation";rec."Jobs desviation")
    {
        
                Visible=seeDpto ;
}
    field("Jobs Not Assigned";rec."Jobs Not Assigned")
    {
        
                Visible=seeDpto ;
}
    field("Job Structure Warehouse";rec."Job Structure Warehouse")
    {
        
                Visible=seeDpto ;
}
    field("Reestimation Date";rec."Reestimation Date")
    {
        
                Visible=seeReestimation ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 GLSetup.GET;

                 //JAV 02/04/21: - QB 1.08.32 Columnas visibles en funci¢n del tipo de dimensi¢n
                 seeCA := (FunctionQB.ReturnDimCA = rec."Dimension Code");
                 seeDpto := (FunctionQB.ReturnDimDpto = rec."Dimension Code");
                 seeReestimation := (FunctionQB.ReturnDimReest = rec."Dimension Code");
               END;


//trigger

var
      GLSetup : Record 98;
      Text000 : TextConst ENU='Shortcut Dimension %1',ESP='Dim. acceso dir. %1';
      Emphasize : Boolean ;
      NameIndent : Integer ;
      "------------------------- QB" : Integer;
      seeCA : Boolean;
      seeDpto : Boolean;
      seeReestimation : Boolean;
      FunctionQB : Codeunit 7207272;

    

//procedure
//procedure GetSelectionFilter() : Text;
//    var
//      DimVal : Record 349;
//      SelectionFilterManagement : Codeunit 46;
//    begin
//      CurrPage.SETSELECTIONFILTER(DimVal);
//      exit(SelectionFilterManagement.GetSelectionFilterForDimensionValue(DimVal));
//    end;
//
//    //[External]
//procedure SetSelection(var DimVal : Record 349);
//    begin
//      CurrPage.SETSELECTIONFILTER(DimVal);
//    end;
//Local procedure GetFormCaption() : Text[250];
//    begin
//      if ( Rec.GETFILTER("Dimension Code") <> ''  )then
//        exit(Rec.GETFILTER("Dimension Code"));
//
//      if ( Rec.GETFILTER("Global Dimension No.") = '1'  )then
//        exit(GLSetup."Global Dimension 1 Code");
//
//      if ( Rec.GETFILTER("Global Dimension No.") = '2'  )then
//        exit(GLSetup."Global Dimension 2 Code");
//
//      if ( Rec.GETFILTER("Global Dimension No.") = '3'  )then
//        exit(GLSetup."Shortcut Dimension 3 Code");
//
//      if ( Rec.GETFILTER("Global Dimension No.") = '4'  )then
//        exit(GLSetup."Shortcut Dimension 4 Code");
//
//      if ( Rec.GETFILTER("Global Dimension No.") = '5'  )then
//        exit(GLSetup."Shortcut Dimension 5 Code");
//
//      if ( Rec.GETFILTER("Global Dimension No.") = '6'  )then
//        exit(GLSetup."Shortcut Dimension 6 Code");
//
//      if ( Rec.GETFILTER("Global Dimension No.") = '7'  )then
//        exit(GLSetup."Shortcut Dimension 7 Code");
//
//      if ( Rec.GETFILTER("Global Dimension No.") = '8'  )then
//        exit(GLSetup."Shortcut Dimension 8 Code");
//
//      exit(STRSUBSTNO(Text000,rec."Global Dimension No."));
//    end;
//Local procedure FormatLines();
//    begin
//      Emphasize := rec."Dimension Value Type" <> rec."Dimension Value Type"::Standard;
//      NameIndent := rec."Indentation";
//    end;

//procedure
}

