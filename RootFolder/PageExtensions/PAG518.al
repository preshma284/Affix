pageextension 50219 MyExtension518 extends 518//39
{
layout
{
addafter("Outstanding Quantity")
{
    field("Outstanding Amount";rec."Outstanding Amount")
    {
        
}
} addafter("Outstanding Amount (LCY)")
{
    field("Outstanding Amt. Ex. VAT (LCY)";rec."Outstanding Amt. Ex. VAT (LCY)")
    {
        
}
    field("Amt. Rcd. Not Invoiced";rec."Amt. Rcd. Not Invoiced")
    {
        
}
}

}

actions
{


}

//trigger

//trigger

var
      PurchHeader : Record 38;
      ShortcutDimCode : ARRAY [8] OF Code[20];

    

//procedure

//procedure
}

