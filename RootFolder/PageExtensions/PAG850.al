pageextension 50282 MyExtension850 extends 850//847
{
layout
{
addafter("Overdue")
{
    field("Document Date";rec."Document Date")
    {
        
}
} addafter("Amount (LCY)")
{
    field("Document Situation";rec."Document Situation")
    {
        
}
} addafter("Dimension Set ID")
{
    field("QB Job No.";rec."QB Job No.")
    {
        
}
    field("QB Payment Method Code";rec."QB Payment Method Code")
    {
        
}
    field("QB Bank Account";rec."QB Bank Account")
    {
        
}
    field("QB Currency Code";rec."QB Currency Code")
    {
        
}
    field("QB Piecework Code";rec."QB Piecework Code")
    {
        
}
}


modify("Payment Discount")
{
Visible=FALSE ;


}

}

actions
{


}

//trigger

//trigger

var
      DimensionSetIDFilter : Page 481;

    

//procedure

//procedure
}

