page 7207548 "Comparative Quote List"
{
  ApplicationArea=All;

CaptionML=ENU='"Comparative Quote" List',ESP='Lista comparativo ofertas';
    InsertAllowed=false;
    SourceTable=7207412;
    SourceTableView=WHERE("Comparative Status"=FILTER("InProcess"|"Selected"|"Approved"));
    DataCaptionFields="Job No.";
    PageType=List;
    CardPageID="Comparative Quote";
    RefreshOnActivate=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("No.";rec."No.")
    {
        
    }
    field("Comparative Status";rec."Comparative Status")
    {
        
    }
    field("Description";rec."Description")
    {
        
    }
    field("Job No.";rec."Job No.")
    {
        
    }
    field("Comparative Date";rec."Comparative Date")
    {
        
    }
    field("Activity Filter";rec."Activity Filter")
    {
        
    }
    field("GetDescriptionActivity";rec."GetDescriptionActivity")
    {
        
                CaptionML=ESP='Descrip. Actividad';
    }
    field("Approval Status";rec."Approval Status")
    {
        
    }
    field("Amount Purchase";rec."Amount Purchase")
    {
        
    }
    field("Selected Vendor";rec."Selected Vendor")
    {
        
    }
    field("VendorName";"VendorName")
    {
        
                CaptionML=ENU='Vendor Name',ESP='Nombre Proveedor';
                Editable=FALSE ;
    }
    field("Generated Contract Doc No.";rec."Generated Contract Doc No.")
    {
        
    }
    field("Generated Contract Date";rec."Generated Contract Date")
    {
        
    }
    field("Comparative Type";rec."Comparative Type")
    {
        
                Visible=FALSE ;
    }
    field("Area Activity";rec."Area Activity")
    {
        
    }
    field("Location Code";rec."Location Code")
    {
        
    }
    field("QBApprovalManagement.GetLastStatus(Rec.RECORDID, Approval Status)";QBApprovalManagement.GetLastStatus(Rec.RECORDID, rec."Approval Status"))
    {
        
                CaptionML=ESP='Situaci�n';
    }
    field("QBApprovalManagement.GetLastDateTime(Rec.RECORDID)";QBApprovalManagement.GetLastDateTime(Rec.RECORDID))
    {
        
                CaptionML=ESP='Ult.Acci�n';
    }
    field("QBApprovalManagement.GetLastComment(Rec.RECORDID)";QBApprovalManagement.GetLastComment(Rec.RECORDID))
    {
        
                CaptionML=ESP='Ult.Comentario';
    }
    field("QB User ID";rec."QB User ID")
    {
        
    }

}

}
area(FactBoxes)
{
    part("DropArea";7174655)
    {
        
                Visible=seeDragDrop;
    }
    part("FilesSP";7174656)
    {
        
                Visible=seeDragDrop;
    }
    part("part3";7207627)
    {
        SubPageLink="No."=FIELD("No.");
    }
    systempart(Notes;Notes)
    {
        ;
    }

}
}
  trigger OnOpenPage()    BEGIN
                 FunctionQB.SetUserJobComparativeFilter(Rec);

                 //Q7357 -
                 seeDragDrop := FunctionQB.AccessToDragAndDrop(Rec.RECORDID);
                 IF seeDragDrop THEN
                   CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Comparative Quote Header");
                 //Q7357 +
               END;

trigger OnAfterGetRecord()    BEGIN

                       VendorName := '';
                       IF Vendor.GET(Rec."Selected Vendor") THEN
                         VendorName := Vendor.Name;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           //+Q8636
                           IF seeDragDrop THEN BEGIN
                             CurrPage.DropArea.PAGE.SetFilter(Rec);
                             CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           END;
                           //-Q8636
                         END;



    var
      VendorName : Text;
      Vendor : Record 23;
      FunctionQB : Codeunit 7207272;
      seeDragDrop : Boolean;
      QBApprovalManagement : Codeunit 7207354;/*

    begin
    {
      JAV 26/12/18: - Se a�aden las columnas "Status" y "Contract No."
      PER 16/10/19: - Quitar opci�n nuevo.
      JAV 20/01/21: - SP 1.01 Se a�ade el enlace con SharePoint
      PSM 14/03/22: - QRE16697 Se a�ade "Situaci�n", "Ult.Acci�n" y "Ult.Comentario"
      DGG 26/04/22: - QRE17046 Se muestra el campo "ID Usuario"
      PSM 04/05/22: - Cambiar propiedad Visible a False en campo rec."Comparative Type"
      JAV 02/06/22: - QB 1.10.47 Se a�ade el campo Status. Se filtra que solo sean registros no generados ni cerrados
    }
    end.*/
  

}








