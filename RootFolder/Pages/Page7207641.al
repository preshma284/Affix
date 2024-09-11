page 7207641 "RC Jefe Obra Activities"
{
CaptionML=ENU='CO Activities',ESP='Actividades';
    SourceTable=7206916;
    PageType=CardPart;
    
  layout
{
area(content)
{
group("group65")
{
        
                CaptionML=ENU='Approvals',ESP='Aprobaciones';
    field("My pending approvals";rec."My pending approvals")
    {
        
                DrillDownPageID="Requests to Approve" ;
    }
    field("Movements pending approval";rec."Movements pending approval")
    {
        
                DrillDownPageID="Approval Entries" ;
    }

}
group("group68")
{
        
                CaptionML=ENU='Approvals',ESP='Aprobaciones Compras';
    field("ApPen Comparativos";rec."ApPen Comparativos")
    {
        
                CaptionML=ENU='Approvals Pending Comparative',ESP='Ap. Pendientes Comparativos';
                DrillDownPageID="Approval Entries" ;
    }
    field("ApPen Cartera";rec."ApPen Cartera")
    {
        
                CaptionML=ENU='Approvals Pending Cartera',ESP='Ap. Pendientes Pagos';
                DrillDownPageID="Approval Entries" ;
    }
    field("ApPen Partes";rec."ApPen Partes")
    {
        
                CaptionML=ESP='Partes de trabajo';
                DrillDownPageID="Approval Entries" ;
    }
    field("ApPen Facturas Venta";rec."ApPen Facturas Venta")
    {
        
                CaptionML=ESP='Facturas Venta';
                DrillDownPageID="Approval Entries" ;
    }
    field("ApPen Contracts and Orders";rec."ApPen Contracts and Orders")
    {
        
                CaptionML=ENU='Jobs - WIP Not Posted',ESP='Ap. Ptes. Contratos / Pedido Compra';
                DrillDownPageID="Approval Entries" ;
    }
    field("ApPen Facturas Compra";rec."ApPen Facturas Compra")
    {
        
                CaptionML=ESP='Facturas Compra';
                DrillDownPageID="Approval Entries" ;
    }

}
group("group75")
{
        
                CaptionML=ENU='Invoicing',ESP='Producci¢n y Planificaci¢n';
    field("Facturas Venta";rec."Facturas Venta")
    {
        
                CaptionML=ESP='Facturas pdtes';
                DrillDownPageID="Sales List" ;
    }
    field("Mediciones";rec."Mediciones")
    {
        
                CaptionML=ESP='Mediciones';
                DrillDownPageID="Measurement List" ;
    }
    field("Relaciones Valoradas";rec."Relaciones Valoradas")
    {
        
                CaptionML=ESP='Relaciones Valoradas';
                DrillDownPageID="Prod. Measure List" ;
    }
    field("Partes de trabajo";rec."Partes de trabajo")
    {
        
                CaptionML=ESP='Partes de trabajo';
                DrillDownPageID="Bill of Items Piec Sales" ;
    }

}
group("group80")
{
        
                CaptionML=ENU='Work in Process',ESP='Imputaciones pendientes';
    field("Necesidades";rec."Necesidades")
    {
        
                CaptionML=ESP='Necesidades de material';
                DrillDownPageID="Purchase Journal Line" ;
    }
    field("Comparativos Ofertas";rec."Comparativos Ofertas")
    {
        
                CaptionML=ESP='Comparativo Ofertas';
                DrillDownPageID="Comparative Quote List" ;
    }
    field("Comparativos Ptes Gen.";rec."Comparativos Ptes Gen.")
    {
        
                DrillDownPageID="Comparative Quote List" ;
    }
    field("Pedidos de Compra";rec."Pedidos de Compra")
    {
        
                CaptionML=ENU='Jobs - WIP Not Posted',ESP='Pedidos de Compra';
                DrillDownPageID="Purchase List" ;
    }
    field("Facturas de Compra";rec."Facturas de Compra")
    {
        
                CaptionML=ESP='Facturas de Compra';
                DrillDownPageID="Purchase List" ;
    }
    field("Albaranes Salida";rec."Albaranes Salida")
    {
        
                CaptionML=ESP='Albaranes de salida';
                DrillDownPageID="Output Shipment List" 

  ;
    }

}

}
}
  

trigger OnOpenPage()    BEGIN
                 Rec.RESET;
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;

                 ApplyGlobalFilters;
                 UpdateActivities;
               END;

trigger OnAfterGetRecord()    BEGIN
                       UpdateActivities;
                       CalcNecesaryFields;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           CalcNecesaryFields;
                         END;



    var
      MyJob : Record 9154;
      i : Integer;
      JobsSelected : Code[250];

    procedure ApplyGlobalFilters();
    begin
      CLEAR(Rec);
      Rec.SETFILTER("Date Filter",'>=%1',WORKDATE);
      Rec.SETFILTER("Date Filter2",'<%1',WORKDATE);
      Rec.SETFILTER("User ID Filter",'=%1',USERID);
    end;

    procedure UpdateActivities();
    begin
      i := 1;
      JobsSelected := '';
      CLEAR(MyJob);
      MyJob.SETRANGE("User ID",USERID);
      if MyJob.FINDFIRST then begin
        repeat
          if i = 1 then begin
            JobsSelected := MyJob."Job No.";
          end ELSE if i < 13 then
            JobsSelected := JobsSelected + '|' + MyJob."Job No.";
          i := i + 1;
        until MyJob.NEXT = 0;
        Rec.SETFILTER(JobFilter,JobsSelected);
      end ELSE begin
        ApplyGlobalFilters;
      end;
    end;

    procedure CalcNecesaryFields();
    begin
      Rec.CALCFIELDS("Hitos facturacion vencidos","Facturas Venta",Mediciones,"Pedidos de Compra","Facturas de Compra",
                 rec."Albaranes Salida",rec."Partes de trabajo",rec."Comparativos Ofertas",Necesidades,rec."Relaciones Valoradas");
      Rec.CALCFIELDS("My pending approvals","Movements pending approval","ApPen Contracts and Orders","ApPen Partes","ApPen Facturas Venta","ApPen Facturas Compra");
      Rec.CALCFIELDS("ApPen Comparativos","ApPen Cartera");
    end;

    // begin//end
}







