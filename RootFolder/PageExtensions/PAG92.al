pageextension 50287 MyExtension92 extends 92//169
{
layout
{
addafter("Dimension Set ID")
{
    field("Piecework No.";rec."Piecework No.")
    {
        
}
    field("Piecework Type";rec."Piecework Type")
    {
        
}
    field("Piecework Indirect Type";rec."Piecework Indirect Type")
    {
        
}
    field("External Document No.";rec."External Document No.")
    {
        
}
    field("Job Deviation Mov.";rec."Job Deviation Mov.")
    {
        
}
    field("Movement of Closing of Job";rec."Movement of Closing of Job")
    {
        
}
    field("Job in progress";rec."Job in progress")
    {
        
}
    field("Compute for hours";rec."Compute for hours")
    {
        
}
//     field("Global Dimension 1 Code";rec."Global Dimension 1 Code")
//     {
        
//                 CaptionML=ENU='rec."Global Dimension 1 Code"',ESP='Dimensi¢n Global 1';
// }
//     field("Global Dimension 2 Code";rec."Global Dimension 2 Code")
//     {
        
//                 CaptionML=ENU='rec."Global Dimension 2 Code"',ESP='Dimensi¢n Global 2';
// }
    field("Source Type";rec."Source Type")
    {
        
}
    field("Source Document Type";rec."Source Document Type")
    {
        
}
    field("Source No.";rec."Source No.")
    {
        
}
    field("Source Name";rec."Source Name")
    {
        
}
    field("Transaction Currency";rec."Transaction Currency")
    {
        
}
    field("Total Cost (TC)";rec."Total Cost (TC)")
    {
        
}
    field("Total Cost (FC)";rec."Total Cost (FC)")
    {
        
}
    field("Provision";rec."Provision")
    {
        
}
    field("Unprovision";rec."Unprovision")
    {
        
}
    field("OLD_QB Activate Expense No";rec."OLD_QB Activate Expense No")
    {
        
                ToolTipML=ESP='Indica en que documento de activaci¢n de gastos se ha incluido este movimiento de proyecto';
}
    field("OLD_QB Activate Expense Line";rec."OLD_QB Activate Expense Line")
    {
        
                ToolTipML=ESP='Indica en que l¡nes de un documento de activaci¢n de gastos se ha incluido este movimiento de proyecto';
}
}

}

actions
{
addafter("Transfer To Planning Lines")
{
    action("FillSourceNo")
    {
        CaptionML=ENU='Fill Source No',ESP='Rellena N§ origen';
                    //   RunObject=Report 7207461;
                      Image=Action;
}
}

}

//trigger

//trigger

var
      Navigate : Page 344;
      DimensionSetIDFilter : Page 481;

    

//procedure

//procedure
}

