table 7206974 "QB Serv. Order Type"
{


    CaptionML = ENU = 'QB Service Order Type', ESP = 'QB Tipo pedido servicio';
    LookupPageID = "QB Service Order Types";

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code', ESP = 'C�digo';
            NotBlank = true;


        }
        field(2; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';
            ;


        }
    }
    keys
    {
        key(key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }




    trigger OnDelete();
    var
        //                DimMgt@1000 :
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimMgt.DeleteDefaultDim(DATABASE::"Service Order Type", Code);
    end;



    /*begin
        end.
      */
}







