page 7206922 "Contracts Control List"
{
  ApplicationArea=All;

CaptionML=ENU='Contracts Control',ESP='Control de contratos';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7206912;
    SourceTableView=SORTING("Proyecto","Orden1","Orden2","Linea");
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Titulo";Titulo)
    {
        
                CaptionML=ESP='Tipo de movimiento';
                Style=None;
                StyleExpr=stColor ;
    }
    field("Proyecto";rec."Proyecto")
    {
        
                StyleExpr=stColor ;
    }
    field("Contrato";rec."Contrato")
    {
        
                StyleExpr=stColor ;
    }
    field("Proveedor";rec."Proveedor")
    {
        
                StyleExpr=stColor ;
    }
    field("Tipo Documento";rec."Tipo Documento")
    {
        
                StyleExpr=stColor ;
    }
    field("Documento";Documento)
    {
        
                CaptionML=ENU='Document',ESP='Documento';
                StyleExpr=stColor ;
    }
    field("Fecha";rec."Fecha")
    {
        
                StyleExpr=stColor ;
    }
    field("User";rec."User")
    {
        
                StyleExpr=stColor ;
    }
    field("Importe[1]_";Importe[1])
    {
        
                CaptionML=ESP='Importe Contrato';
                BlankZero=true;
                StyleExpr=stColor ;
    }
    field("Importe[2]_";Importe[2])
    {
        
                CaptionML=ESP='Importe M�ximo';
                BlankZero=true;
                StyleExpr=stColor ;
    }
    field("Importe[3]_";Importe[3])
    {
        
                CaptionML=ESP='Importe Albaranes';
                BlankZero=true;
                StyleExpr=stColor ;
    }
    field("Importe[4]_";Importe[4])
    {
        
                CaptionML=ESP='Importe Factura/Abono';
                BlankZero=true;
                StyleExpr=stColor ;
    }
    field("Importe[5]_";Importe[5])
    {
        
                CaptionML=ESP='Importe Ampliaciones';
                BlankZero=true;
                Visible=FALSE;
                StyleExpr=stColor ;
    }
    field("Importe[6]_";Importe[6])
    {
        
                CaptionML=ESP='Importe Pendiente';
                BlankZero=true;
                StyleExpr=stColor ;
    }
    field("d";rec."Linea")
    {
        
                Visible=false;
                StyleExpr=stColor ;
    }
    field("Orden1";rec."Orden1")
    {
        
                Visible=false ;
    }
    field("Orden2";rec."Orden2")
    {
        
                Visible=false 

  ;
    }

}

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='P&osting',ESP='Procesar';
                      Image=Post ;
    action("action1")
    {
        CaptionML=ESP='Entrada Manual';
                      Visible=verManuales;
                      Image=Add;
                      
                                
    trigger OnAction()    BEGIN
                                 AddManual;
                               END;


    }

}

}
}
  trigger OnInit()    BEGIN
             verManuales := FALSE;
           END;

trigger OnOpenPage()    BEGIN
                 FunctionQB.SetUserJobContractControlFilter(Rec);

                 IF UserSetup.GET(USERID) THEN
                   verManuales := (UserSetup."Control Contracts");
               END;

trigger OnAfterGetRecord()    BEGIN
                       EsTotales := rec."Linea de Totales";
                       //-Q20392
                       stColor := '';
                       IF EsTotales THEN stColor := 'Strong';
                       IF rec."Tipo Documento" IN [rec."Tipo Documento"::Order,rec."Tipo Documento"::Ampliacion] THEN stColor := 'Favorable';
                       //+Q20392
                       IF (rec."Extension No." = 0) THEN
                         Documento := rec."No. Documento"
                       ELSE
                         Documento := rec."No. Documento" + ' Amp.' + FORMAT(rec."Extension No.");

                       CLEAR(Importe);
                       CASE rec."Tipo Movimiento" OF
                         rec."Tipo Movimiento"::Movimiento :
                           BEGIN
                             Importe[1] := rec."Importe Contrato";
                             Importe[2] := rec."Importe Maximo";
                             Importe[3] := rec."Importe Albaran";
                             Importe[4] := rec."Importe Factura/abono";
                             Importe[5] := rec."Importe Ampliaciones";
                             Importe[6] := rec."Importe Pendiente";
                           END;
                         rec."Tipo Movimiento"::TotGrupo :
                           BEGIN
                             Rec.CALCFIELDS("Suma Importe Contrato", "Suma Importe Maximo", "Suma Importe Albaran", "Suma Importe Factura/abono",
                                        "Suma Importe Ampliaciones", "Suma Importe Pendiente");
                             Importe[1] := rec."Suma Importe Contrato";
                             Importe[2] := rec."Suma Importe Maximo";
                             Importe[3] := rec."Suma Importe Albaran";
                             Importe[4] := rec."Suma Importe Factura/abono";
                             Importe[5] := rec."Suma Importe Ampliaciones";
                             Importe[6] := rec."Suma Importe Pendiente";
                           END;
                         rec."Tipo Movimiento"::TotProyecto :
                           BEGIN
                             Rec.CALCFIELDS("Total Importe Contrato", "Total Importe Maximo", "Total Importe Albaran", "Total Importe Factura/abono",
                                        "Total Importe Ampliaciones", "Total Importe Pendiente");
                             Importe[1] := rec."Total Importe Contrato";
                             Importe[2] := rec."Total Importe Maximo";
                             Importe[3] := rec."Total Importe Albaran";
                             Importe[4] := rec."Total Importe Factura/abono";
                             Importe[5] := rec."Total Importe Ampliaciones";
                             Importe[6] := rec."Total Importe Pendiente";
                           END;
                       END;

                       CASE rec."Tipo Movimiento" OF
                         rec."Tipo Movimiento"::IniProyecto :
                           BEGIN
                             Titulo := txt000 + ' ' + rec.Proyecto;
                           END;
                         rec."Tipo Movimiento"::TotProyecto :
                           BEGIN
                             Titulo := txt001 + ' ' + rec.Proyecto;
                           END;
                         rec."Tipo Movimiento"::IniGrupo  :
                           BEGIN
                             IF (rec.Contrato <> '') THEN
                               Titulo := txt004 + ' '  + rec.Contrato
                             ELSE
                               Titulo := txt002 + ' ' + rec.Proveedor
                           END;
                         rec."Tipo Movimiento"::TotGrupo  :
                           BEGIN
                             IF (rec.Contrato <> '') THEN
                               Titulo := txt005 + ' '  + rec.Contrato
                             ELSE
                               Titulo := txt003 + ' '  + rec.Proveedor
                           END;
                         ELSE
                           BEGIN
                             Titulo := '    ' + FORMAT(rec."Tipo Documento") + ' ' + rec."No. Documento";
                           END;
                       END;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           EsTotales := rec."Linea de Totales";
                           //-Q20392
                           stColor := '';
                           IF EsTotales THEN stColor := 'Strong';
                           IF rec."Tipo Documento" IN [rec."Tipo Documento"::Order,rec."Tipo Documento"::Ampliacion] THEN stColor := 'Favorable'
                           //+Q20392
                         END;



    var
      UserSetup : Record 91;
      ControlContratos : Record 7206912;
      ControlContratosAdd : Page 7206923;
      FunctionQB : Codeunit 7207272;
      EsTotales : Boolean ;
      verManuales : Boolean ;
      Importe : ARRAY [10] OF Decimal;
      Titulo : Text;
      txt000 : TextConst ESP='Inicio del proyecto';
      txt001 : TextConst ESP='Total del proyecto';
      txt002 : TextConst ESP='"  Inicio Proveedor"';
      txt003 : TextConst ESP='"  Total Proveedor"';
      txt004 : TextConst ESP='"  Inicio Contrato"';
      txt005 : TextConst ESP='"  Total Contrato"';
      Documento : Text;
      stColor : Text[50];

    LOCAL procedure AddManual();
    begin
      CLEAR(ControlContratosAdd);
      ControlContratosAdd.LOOKUPMODE(TRUE);
      if ControlContratosAdd.RUNMODAL = ACTION::LookupOK then begin
        ControlContratosAdd.GuardarDatos;
      end;
    end;

    // begin
    /*{
      Q18495 (EPV) 21/12/22 - BUG EN CONTROL DE CONTRATOS
      Q20392 AML 3/11/23 Cambio en los colores
    }*///end
}









