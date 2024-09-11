page 7206923 "Contracts Control Add"
{
CaptionML=ESP='A�adir manual al Control de Contratos';
    PageType=Document;
    
  layout
{
area(content)
{
group("Group")
{
        
group("group25")
{
        
                CaptionML=ESP='Datos';
    field("Proyecto";Proyecto)
    {
        
                CaptionML=ESP='Proyecto';
                TableRelation=Job ;
    }
    field("Contrato";Contrato)
    {
        
                CaptionML=ESP='Contrato';
                TableRelation="Purchase Header"."No." WHERE ("Document Type"=FILTER("Order"|"Blanket Order"));
                
                          ;trigger OnLookup(var Text: Text): Boolean    BEGIN
                           QBPageSubscriber.LookUpContrat(Contrato);
                         END;


    }
    field("Proveedor";Proveedor)
    {
        
                CaptionML=ESP='Proveedor';
                TableRelation=Vendor ;
    }
    field("Fecha";Fecha)
    {
        
                CaptionML=ESP='Fecha';
    }
    field("Importe";Importe)
    {
        
                CaptionML=ESP='Importe';
                BlankZero=true;
    }

}

}

}
}
  trigger OnOpenPage()    BEGIN
                 IF NOT UserSetup.GET(USERID) THEN
                   ERROR(txt000);
                 IF (NOT UserSetup."Control Contracts") THEN
                   ERROR(txt001);

                 Fecha := TODAY;
               END;



    var
      ControlContratos : Record 7206912;
      UserSetup : Record 91;
      QBPageSubscriber : Codeunit 7207349;
      Proyecto : Code[20];
      Contrato : Code[20];
      Proveedor : Code[20];
      Fecha : Date;
      Importe : Decimal;
      txt000 : TextConst ESP='No existe el registro de control del usuario';
      txt001 : TextConst ESP='No tiene permisos para crear nuevos registros';

    procedure GuardarDatos();
    begin
      ControlContratos.INIT;
      ControlContratos.Linea := 0;
      ControlContratos.Proyecto := Proyecto;
      ControlContratos."Tipo Movimiento" := ControlContratos."Tipo Movimiento"::Movimiento;
      ControlContratos.Contrato := Contrato;
      ControlContratos.Proveedor := Proveedor;
      ControlContratos.User := USERID;
      ControlContratos."Tipo Documento" := ControlContratos."Tipo Documento"::Manual;
      ControlContratos."No. Documento" := Contrato;
      ControlContratos.Fecha := Fecha;
      ControlContratos."Importe Ampliaciones" := Importe;
      ControlContratos.INSERT(TRUE);
    end;

    // begin//end
}








