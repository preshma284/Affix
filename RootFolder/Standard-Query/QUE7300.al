query 50231 "Lot Numbers by Bin 1"
{


    CaptionML = ENU = 'Lot Numbers by Bin', ESP = 'N�meros lote por ubicaci�n';
    OrderBy = Ascending(Bin_Code);

    elements
    {
        DataItem("Warehouse_Entry"; "Warehouse Entry")
        {

            Column("Location_Code"; "Location Code")
            {

            }
            Column("Item_No"; "Item No.")
            {

            }
            Column("Variant_Code"; "Variant Code")
            {

            }
            Column("Zone_Code"; "Zone Code")
            {

            }
            Column("Bin_Code"; "Bin Code")
            {

            }
            Column("Lot_No"; "Lot No.")
            {

            }
            Column("Serial_No"; "Serial No.")
            {

            }
            //Added in base query - Additional
            // column(Package_No; "Package No.")
            // {
            // }
            Column("Unit_of_Measure_Code"; "Unit of Measure Code")
            {

            }
            Column("Sum_Qty_Base"; "Qty. (Base)")
            {
                ColumnFilter = Sum_Qty_Base = FILTER(<> 0);
                //MethodType=Totals;
                Method = Sum;
            }
        }

    }
    /*begin
    end.
  */
}




