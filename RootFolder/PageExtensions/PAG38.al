pageextension 50182 MyExtension38 extends 38//32
{
layout
{
addafter("Job No.")
{
    field("Job Purchase";rec."Job Purchase")
    {
        
}
} addafter("Dimension Set ID")
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
    field("QB Stocks Output Shipment No.";rec."QB Stocks Output Shipment No.")
    {
        
                Editable=false ;
}
}

}

actions
{


}

//trigger

//trigger

var
      Navigate : Page 344;
      DimensionSetIDFilter : Page 481;

    
    

//procedure
//Local procedure GetCaption() : Text;
//    var
//      GLSetup : Record 98;
//      ObjTransl : Record 377;
//      Item : Record 27;
//      ProdOrder : Record 5405;
//      Cust : Record 18;
//      Vend : Record 23;
//      Dimension : Record 348;
//      DimValue : Record 349;
//      SourceTableName : Text;
//      SourceFilter : Text;
//      Description : Text[100];
//    begin
//      rec."Description" := '';
//
//      CASE TRUE OF
//        Rec.GETFILTER("Item No.") <> '':
//          begin
//            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,27);
//            SourceFilter := Rec.GETFILTER("Item No.");
//            if ( MAXSTRLEN(Item."No.") >= STRLEN(SourceFilter)  )then
//              if ( Item.GET(SourceFilter)  )then
//                rec."Description" := Item.Description;
//          end;
//        (Rec.GETFILTER("Order No.") <> '') and ("Order Type" = "Order Type"::Production):
//          begin
//            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5405);
//            SourceFilter := Rec.GETFILTER("Order No.");
//            if ( MAXSTRLEN(ProdOrder."No.") >= STRLEN(SourceFilter)  )then
//              if ProdOrder.GET(ProdOrder.Status::Released,SourceFilter) or
//                 ProdOrder.GET(ProdOrder.Status::Finished,SourceFilter)
//              then begin
//                SourceTableName := STRSUBSTNO('%1 %2',ProdOrder.Status,SourceTableName);
//                rec."Description" := ProdOrder.Description;
//              end;
//          end;
//        Rec.GETFILTER("Source No.") <> '':
//          CASE "Source Type" OF
//            "Source Type"::Customer:
//              begin
//                SourceTableName :=
//                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,18);
//                SourceFilter := Rec.GETFILTER("Source No.");
//                if ( MAXSTRLEN(Cust."No.") >= STRLEN(SourceFilter)  )then
//                  if ( Cust.GET(SourceFilter)  )then
//                    rec."Description" := Cust.Name;
//              end;
//            rec."Source Type"::Vendor:
//              begin
//                SourceTableName :=
//                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,23);
//                SourceFilter := Rec.GETFILTER("Source No.");
//                if ( MAXSTRLEN(Vend."No.") >= STRLEN(SourceFilter)  )then
//                  if ( Vend.GET(SourceFilter)  )then
//                    rec."Description" := Vend.Name;
//              end;
//          end;
//        Rec.GETFILTER("Global Dimension 1 Code") <> '':
//          begin
//            GLSetup.GET;
//            Dimension.Code := GLSetup."Global Dimension 1 Code";
//            SourceFilter := Rec.GETFILTER("Global Dimension 1 Code");
//            SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
//            if ( MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter)  )then
//              if ( DimValue.GET(GLSetup."Global Dimension 1 Code",SourceFilter)  )then
//                rec."Description" := DimValue.Name;
//          end;
//        Rec.GETFILTER("Global Dimension 2 Code") <> '':
//          begin
//            GLSetup.GET;
//            Dimension.Code := GLSetup."Global Dimension 2 Code";
//            SourceFilter := Rec.GETFILTER("Global Dimension 2 Code");
//            SourceTableName := Dimension.GetMLName(GLOBALLANGUAGE);
//            if ( MAXSTRLEN(DimValue.Code) >= STRLEN(SourceFilter)  )then
//              if ( DimValue.GET(GLSetup."Global Dimension 2 Code",SourceFilter)  )then
//                rec."Description" := DimValue.Name;
//          end;
//        Rec.GETFILTER("Document Type") <> '':
//          begin
//            SourceTableName := Rec.GETFILTER("Document Type");
//            SourceFilter := Rec.GETFILTER("Document No.");
//            rec."Description" := Rec.GETFILTER("Document Line No.");
//          end;
//      end;
//      exit(STRSUBSTNO('%1 %2 %3',SourceTableName,SourceFilter,rec."Description"));
//    end;

//procedure
}

