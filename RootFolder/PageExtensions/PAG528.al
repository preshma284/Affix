pageextension 50222 MyExtension528 extends 528//121
{
layout
{
addafter("Buy-from Vendor No.")
{
    field("Posting Date";rec."Posting Date")
    {
        
}
} addafter("Location Code")
{
//     field("Quantity";rec."Quantity")
//     {
        
//                 ToolTipML=ENU='Specifies the number of units of the item specified on the line.',ESP='Indica el n£mero de unidades del art¡culo especificado en la l¡nea.';
//                 ApplicationArea=Basic,Suite;
// }
    field("Direct Unit Cost";rec."Direct Unit Cost")
    {
        
}
    field("Unit Cost (LCY)";rec."Unit Cost (LCY)")
    {
        
}
    field("Quantity * Direct Unit Cost";rec."Quantity" * rec."Direct Unit Cost")
    {
        
                CaptionML=ENU='Amount',ESP='Importe';
}
    field("Qty. Rcd. Not Invoiced";rec."Qty. Rcd. Not Invoiced")
    {
        
}
    field("Qty. Rcd. Not Invoiced * Direct Unit Cost";rec."Qty. Rcd. Not Invoiced" * rec."Direct Unit Cost")
    {
        
                CaptionML=ENU='Pending Amount',ESP='Importe Pendiente';
}
} addafter("Job No.")
{
    field("Piecework N§";rec."Piecework NÂº")
    {
        
}
} addafter("Quantity Invoiced")
{
    field("QB_Accounted";rec."Accounted")
    {
        
}
    field("QB_ReceivedOnFRIS";rec."Received on FRI")
    {
        
}
    field("QB_Cancelled";rec."Cancelled")
    {
        
}
    field("QB Amount Invoiced";rec."QB Amount Invoiced")
    {
        
}
    field("QB Amount Invoiced (LCY)";rec."QB Amount Invoiced (LCY)")
    {
        
                Visible=false ;
}
    field("QB Amount Invoiced (JC)";rec."QB Amount Invoiced (JC)")
    {
        
                Visible=false ;
}
    field("QB Amount Invoiced (ACY)";rec."QB Amount Invoiced (ACY)")
    {
        
                Visible=false ;
}
    field("QB Amount Not Invoiced";rec."QB Amount Not Invoiced")
    {
        
}
    field("QB Amount Not Invoiced (LCY)";rec."QB Amount Not Invoiced (LCY)")
    {
        
                Visible=false ;
}
    field("QB Amount Not Invoiced (JC)";rec."QB Amount Not Invoiced (JC)")
    {
        
                Visible=false ;
}
    field("QB Amount Not Invoiced (ACY)";rec."QB Amount Not Invoiced (ACY)")
    {
        
                Visible=false ;
}
}

}

actions
{


}

//trigger

//trigger

var
      PurchRcptHeader : Record 120;

    

//procedure

//procedure
}

