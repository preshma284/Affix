query 50138 "QB BI Acopios"
{
  
  
  elements
{

DataItem("Posted_Output_Shipment_Lines";"Posted Output Shipment Lines")
{

Column("JobNo";"Job No.")
{

}Column("DocumentNo";"Document No.")
{

}Column("LineNo";"Line No.")
{

}Column("No";"No.")
{

}Column("Description";"Description")
{

}Column("Description2";"Description 2")
{

}Column("Amount";"Amount")
{

}Column("ShortcutDimension1Code";"Shortcut Dimension 1 Code")
{

}Column("ShortcutDimension2Code";"Shortcut Dimension 2 Code")
{

}Column("Quantity";"Quantity")
{

}Column("UnitCost";"Unit Cost")
{

}Column("OutboundWarehouse";"Outbound Warehouse")
{

}Column("ProduccionUnit";"Produccion Unit")
{

}Column("TotalCost";"Total Cost")
{

}Column("SalesPrice";"Sales Price")
{

}Column("UnitofMeasureCode";"Unit of Measure Code")
{

}Column("Billable";"Billable")
{

}Column("UnitofMensureQuantity";"Unit of Mensure Quantity")
{

}Column("QuantityBase";"Quantity (Base)")
{

}Column("VariantCode";"Variant Code")
{

}Column("NoSerieforTracking";"No. Serie for Tracking")
{

}Column("NoLotforTracking";"No. Lot for Tracking")
{

}Column("SourceDocumentType";"Source Document Type")
{

}Column("NoSourceDocument";"No. Source Document")
{

}Column("NoSourceDocumentLine";"No. Source Document Line")
{

}Column("JobTaskNo";"Job Task No.")
{

}Column("DimensionSetID";"Dimension Set ID")
{

}DataItem("Posted_Output_Shipment_Header";"Posted Output Shipment Header")
{

DataItemLink="Job No."= "Posted_Output_Shipment_Lines"."Job No.",
                            "No."= "Posted_Output_Shipment_Lines"."Document No.";
Column("AutomaticShipment";"Automatic Shipment")
{

}Column("PostingDate";"Posting Date")
{

}DataItem("Purch_Rcpt_Header";"Purch. Rcpt. Header")
{

DataItemLink="No."= "Posted_Output_Shipment_Header"."Purchase Rcpt. No.";
Column("BuyfromVendorNo";"Buy-from Vendor No.")
{

}Column("BuyfromVendorName";"Buy-from Vendor Name")
{

}
}
}
}
}
  

    /*begin
    end.
  */
}








