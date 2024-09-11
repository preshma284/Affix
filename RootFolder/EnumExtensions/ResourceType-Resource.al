enumextension 50100 "ResourceTypeEnum" extends "Resource Type"
{
    //OptionString=Person,Machine,Subcontracting,ExternalWorker,PartidaPresupuestaria;
    //Options defined in the text file: for the base table.
    value(100; "Subcontracting")
    {
        Caption = 'Subcontracting';
    }

    value(101; "PartidaPresupuestaria")
    {
        Caption = 'Partida Presupuestaria';
    }
    value(102; "ExternalWorker")
    {
        Caption = 'External Worker';
    }
    // Add other values as needed
}