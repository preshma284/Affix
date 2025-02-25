pageextension 50199 MyExtension460 extends 460//312
{
layout
{
addafter("Default Accounts")
{
group("QB_RealEstate")
{
        
                CaptionML=ENU='Real Estate',ESP='Real Estate';
                Visible=seere;
    field("PurchPaySetupExt.QB_Create Vendor from Contact";PurchPaySetupExt."QB_Create Vendor from Contact")
    {
        
                CaptionML=ESP='Crear Proveedor desde Contacto';
                ToolTipML=ESP='Solo para Real Estate. Si se marca este campo, al crear un contacto de tipo Empresa relacionado con Proveedores, se crea el Proveedor autom ticamente';
                Visible=seere;
                
                            ;trigger OnValidate()    BEGIN
                             PurchPaySetupExt.MODIFY;
                           END;


}
}
group("QB_QuoBuilding")
{
        
                CaptionML=ESP='QuoBuilding';
group("Control1100286047")
{
        
                CaptionML=ENU='Posting',ESP='Registro';
    field("Expense Notes No. Series";rec."Expense Notes No. Series")
    {
        
}
    field("Post. Expe. Notes No. Series";rec."Post. Expe. Notes No. Series")
    {
        
}
    field("Invoice Exp. Notes No. Series";rec."Invoice Exp. Notes No. Series")
    {
        
}
    field("Always Use FRI";rec."Always Use FRI")
    {
        
}
}
group("Control1100286046")
{
        
                CaptionML=ENU='Posting',ESP='Stocks';
    field("QB Stocks Active New Function";rec."QB Stocks Active New Function")
    {
        
}
    field("QB Not Item Neg. Cost";rec."QB Not Item Neg. Cost")
    {
        
}
}
group("Control1100286045")
{
        
                CaptionML=ENU='Posting',ESP='Archivo';
    field("QB Archive when reopen";rec."QB Archive when reopen")
    {
        
}
}
group("Control1100286018")
{
        
                CaptionML=ENU='Comparative',ESP='Comparativos';
    field("Comparative Quotes No. Series";rec."Comparative Quotes No. Series")
    {
        
}
    field("Vendor Conditions Type";rec."Vendor Conditions Type")
    {
        
}
    field("Vendor Conditions No.";rec."Vendor Conditions No.")
    {
        
}
    field("Vendor Conditions CA";rec."Vendor Conditions CA")
    {
        
}
    field("Vendor Conditions Piecework";rec."Vendor Conditions Piecework")
    {
        
}
}
    field("QB Comp Value Qty.  Purc. Line";rec."QB Comp Value Qty.  Purc. Line")
    {
        
}
group("Control1100286003")
{
        
                CaptionML=ENU='Calidad',ESP='Calidad';
    field("Evaluations Nos. No. Series";rec."Evaluations Nos. No. Series")
    {
        
}
}
group("Obralia")
{
        
                CaptionML=ENU='Obralia',ESP='Obralia';
    field("Obralia Activated";rec."Obralia Activated")
    {
        
}
    field("Obralia WS";rec."Obralia WS")
    {
        
}
    field("Obralia User";rec."Obralia User")
    {
        
}
    field("Obralia Password";rec."Obralia Password")
    {
        
}
    field("Obralia Green";rec."Obralia Green")
    {
        
                ToolTipML=ESP='Valores que indican semaforo Verde para Obralia, pueden ser varias letras';
}
    field("Obralia Red";rec."Obralia Red")
    {
        
                ToolTipML=ESP='Valores que indican semaforo Rojo para Obralia, pueden ser varias letras';
}
}
group("Control1100286028")
{
        
                CaptionML=ENU='Background Posting',ESP='Firmantes de Comparativos';
    field("QB Comp Firmantes";rec."QB Comp Firmantes")
    {
        
                ToolTipML=ESP='Indica la forma por defecto en que se van a agrupar las l¡neas de las facturas proforma e la hora de imprimirlas.';
                
                                ;trigger OnValidate()    BEGIN
                             CurrPage.UPDATE;
                           END;

trigger OnControlAddIn(Index: Integer; Data: Text)    BEGIN
                                 SetEditable;
                               END;


}
    field("QB Comp Cargo Firmante 1";rec."QB Comp Cargo Firmante 1")
    {
        
                Editable=edNewCharge ;
}
    field("QB Comp Cargo Firmante 2";rec."QB Comp Cargo Firmante 2")
    {
        
                Editable=edNewCharge ;
}
    field("QB Comp Cargo Firmante 3";rec."QB Comp Cargo Firmante 3")
    {
        
                Editable=edNewCharge ;
}
    field("QB Comp Cargo Firmante 4";rec."QB Comp Cargo Firmante 4")
    {
        
                Editable=edNewCharge ;
}
    field("QB Comp Firmante 1";rec."QB Comp Firmante 1")
    {
        
                Editable=edOldCharge ;
}
    field("QB Comp Firmante 2";rec."QB Comp Firmante 2")
    {
        
                Editable=edOldCharge ;
}
    field("QB Comp Firmante 3";rec."QB Comp Firmante 3")
    {
        
                Editable=edOldCharge ;
}
    field("QB Comp Firmante 4";rec."QB Comp Firmante 4")
    {
        
                Editable=edOldCharge ;
}
}
}
group("Control1100286019")
{
        
                CaptionML=ENU='Proformas',ESP='Proformas';
    field("QB Proform All";rec."QB Proform All")
    {
        
                ToolTipML=ESP='Si se marca indica que se desea proformar cualquier producto o recurso';
}
    field("QB No Validate Proform";rec."QB No Validate Proform")
    {
        
                ToolTipML=ESP='Si se marca no es obligatorio validar las proformas para poder facturarlas.';
}
    field("QB Proforma No. Series";rec."QB Proforma No. Series")
    {
        
                ToolTipML=ESP='Especifica el c¢digo de la serie num‚rica que se va a utilizar para asignar n£meros a las proformas';
}
    field("QB Proforma Date";rec."QB Proforma Date")
    {
        
                ToolTipML=ESP='Indica con que fecha se va a crear la proforma, la del d¡a en que se crea o a partir del pedido de compra';
}
    field("QB % Proforma";rec."QB % Proforma")
    {
        
                ToolTipML=ESP='Indica en los pedidos de compra que porcentaje se va a proformar por defecto sobre la cantidad a recibir, si es cero se indica cero como cantidad a convertir en proforma, si es el 100% se proforma lo mismo que se recibe.';
}
group("Control1100286027")
{
        
                CaptionML=ENU='Print',ESP='Impresi¢n';
    field("QB Proforma Def. Group";rec."QB Proforma Def. Group")
    {
        
                ToolTipML=ESP='Indica la forma por defecto en que se van a agrupar las l¡neas de las facturas proforma e la hora de imprimirlas.';
}
    field("QB_Text1";"QB_Text1")
    {
        
                CaptionML=ESP='Texto para Proforma';
                ToolTipML=ESP='Texto que se imprime al pie de las facturas proforma que no est‚n marcadas como la £iltima.';
                MultiLine=true;
                
                            ;trigger OnValidate()    BEGIN
                             rec.QB_SetText(QB_Text1);
                             CurrPage.UPDATE;
                           END;


}
    field("QB_Text2";"QB_Text2")
    {
        
                CaptionML=ESP='Texto para £ltima Proforma';
                ToolTipML=ESP='Texto que se imprime al pie de las facturas proforma que est‚ marcada como la £ltima factura proforma.';
                MultiLine=true;
                
                            ;trigger OnValidate()    BEGIN
                             rec.QB_SetLastText(QB_Text2);
                             CurrPage.UPDATE;
                           END;


}
}
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 Rec.RESET;
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;

                 //QRE15717-LCG-091221-INI
                 PurchPaySetupExt.Read(Rec);
                 //QRE15717-LCG-091221-FIN

                 //JAV 06/05/22: - QB 1.10.40 Ver temas de Real Estate
                 seeRE := FunctionQB.AccessToRealEstate;
               END;
trigger OnAfterGetRecord()    BEGIN
                       SetEditable;
                     END;
trigger OnAfterGetCurrRecord()    BEGIN
                           SetEditable;
                         END;


//trigger

var
      PurchPaySetupExt : Record 7238431;
      FunctionQB : Codeunit 7207272;
      QREFunctions : Codeunit 7238197;
      QB_Text1 : Text;
      QB_Text2 : Text;
      edOldCharge : Boolean;
      edNewCharge : Boolean;
      seeRE : Boolean;

    
    

//procedure
LOCAL procedure SetEditable();
    begin
      QB_Text1 := rec.QB_GetText();
      QB_Text2 := rec.QB_GetLastText();

      edNewCharge := Rec."QB Comp Firmantes";
      edOldCharge := not Rec."QB Comp Firmantes";
    end;

//procedure
}

