pageextension 50134 MyExtension142 extends 142//110
{
layout
{


}

actions
{
addafter("&Print")
{
    action("QB_FacturaProforma")
    {
        
                      CaptionML=ENU='Factura proforma',ESP='Prefactura';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=PrintForm;
                      PromotedCategory=Report;
                      
                                trigger OnAction()    VAR
                                 SalesShipmentHeader : Record 110;
                                 QBReportSelections : Record 7206901;
                               BEGIN
                                 //JAV 08/10/19: - Se a¤ade la acci¢n que imprime el albar n como prefactura
                                 SalesShipmentHeader.SETRANGE("No.",rec."No.");
                                 QBReportSelections.Print(QBReportSelections.Usage::V1, SalesShipmentHeader);
                               END;


}
}

}

//trigger

//trigger

var
      IsOfficeAddin : Boolean;

    

//procedure

//procedure
}

