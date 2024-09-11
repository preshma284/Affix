page 7174389 "QM MasterData Conf. Tables"
{
  ApplicationArea=All;

CaptionML=ENU='MasterData Conf. Tables',ESP='MasterData Tablas de Configuraci�n';
    SourceTable=7174389;
    PageType=List;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Table No.";rec."Table No.")
    {
        
    }
    field("Table Name";rec."Table Name")
    {
        
    }
    field("Configuration";rec."Configuration")
    {
        
    }
    field("TxtAux";TxtAux)
    {
        
                CaptionML=ESP='Campos';
                
                              

  ;trigger OnAssistEdit()    BEGIN
                               QMMasterDataTableField.RESET;
                               QMMasterDataTableField.SETRANGE("Table No.", Rec."Table No.");

                               CLEAR(QMMasterDataSetupFields);
                               QMMasterDataSetupFields.SetType(1);
                               QMMasterDataSetupFields.SETTABLEVIEW(QMMasterDataTableField);
                               QMMasterDataSetupFields.RUNMODAL;
                             END;


    }

}

}
}actions
{
area(Processing)
{

    action("action1")
    {
        CaptionML=ESP='Cargar Datos por Defecto';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=SetupList;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 CargarListaTablas;
                               END;


    }
    action("action2")
    {
        CaptionML=ESP='Sincronizar Emp.Actual';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=Intercompany;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 IF (QMMasterDataManagement.CompanyIsMaster(COMPANYNAME)) THEN
                                   MESSAGE('Este proceso no se puede lanzar desde la empresa Master');

                                 QMMasterDataManagement.Configuration_UpdateCompany(COMPANYNAME, 0, TRUE, '');
                               END;


    }
    action("action3")
    {
        CaptionML=ESP='Sincronizar Todas';
                      Promoted=true;
                      PromotedIsBig=true;
                      Image=IntercompanyOrder;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    BEGIN
                                 QMMasterDataManagement.Configuration_UpdateAll;
                               END;


    }

}
}
  

trigger OnOpenPage()    BEGIN
                 TxtAux := Txt001;
               END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  Rec.Configuration := Rec.Configuration::OnlyQB;    //Si creo un nuevo registro, marco por defecto que lo sincronizo
                END;



    var
      QMMasterDataConfTables : Record 7174389;
      QMMasterDataTableField : Record 7174393;
      QMMasterDataManagement : Codeunit 7174368;
      QMMasterDataSetupFields : Page 7174393;
      Txt000 : TextConst ESP='Esta tabla no se puede usar para campos obligatorios';
      TxtAux : Text

[10];
      Txt001 : TextConst ESP='Campos';

    LOCAL procedure CargarListaTablas();
    begin
      //Generales de Business Central
      AddOne(DATABASE::"Inventory Posting Setup");
      AddOne(DATABASE::"General Ledger Setup");
      AddOne(DATABASE::"Accounting Period");
      AddOne(DATABASE::"No. Series");
      AddOne(DATABASE::"No. Series Line");
      AddOne(DATABASE::"No. Series Relationship");
      AddOne(DATABASE::"SII Setup");
      AddOne(DATABASE::"Gen. Business Posting Group");
      AddOne(DATABASE::"Gen. Product Posting Group");
      AddOne(DATABASE::"General Posting Setup");
      AddOne(DATABASE::"Customer Posting Group");
      AddOne(DATABASE::"Vendor Posting Group");
      AddOne(DATABASE::"FA Posting Group");
      AddOne(DATABASE::"Bank Account Posting Group");
      AddOne(DATABASE::"Inventory Posting Group");
      AddOne(DATABASE::"Employee Posting Group");
      AddOne(DATABASE::"VAT Business Posting Group");
      AddOne(DATABASE::"VAT Product Posting Group");
      AddOne(DATABASE::"VAT Posting Setup");
      AddOne(DATABASE::"VAT Clause");
      AddOne(DATABASE::"Source Code");
      AddOne(DATABASE::"Source Code Setup");
      AddOne(DATABASE::"Reason Code");
      AddOne(DATABASE::"Gen. Journal Template");
      AddOne(DATABASE::"Gen. Journal Batch");
      AddOne(DATABASE::"Standard Text");
      AddOne(DATABASE::"VAT Statement Template");
      AddOne(DATABASE::"Column Layout");
      AddOne(DATABASE::Currency);
      AddOne(DATABASE::"Payment Registration Setup");
      AddOne(DATABASE::"Acc. Schedule Name");
      AddOne(DATABASE::"Analysis View");
      AddOne(DATABASE::"Post Code");
      AddOne(DATABASE::Language);
      AddOne(DATABASE::"Country/Region");
      AddOne(DATABASE::Language);
      AddOne(DATABASE::"Payment Terms");
      AddOne(DATABASE::"Payment Method");
      AddOne(DATABASE::"Sales & Receivables Setup");
      AddOne(DATABASE::"Purchases & Payables Setup");
      AddOne(DATABASE::"Item Journal Template");

      //Propias de QuoBuilding
      AddOne(DATABASE::"QuoBuilding Setup");
      AddOne(DATABASE::"Rental Elements Setup");
      AddOne(DATABASE::"Piecework Setup");
      AddOne(DATABASE::"Units Posting Group");
      AddOne(DATABASE::"QB Report Selections");
      AddOne(DATABASE::"TAux Jobs Status");
      AddOne(DATABASE::"TAux Job Phases");
      AddOne(DATABASE::"Codes Evaluation");
      AddOne(DATABASE::"Vendor Certificates Types");
      AddOne(DATABASE::"Other Default Vendor Cond.");
      AddOne(DATABASE::"TAux General Categories");
      AddOne(DATABASE::"QB TAux General Sub-Categories");
      AddOne(DATABASE::"TAUX Budget Category");
      AddOne(DATABASE::"TAux Award procedure");
      AddOne(DATABASE::"QB SII Operation Description");
      AddOne(DATABASE::"QB Payments Phases");
      AddOne(DATABASE::"QB Payments Phases Lines");

      //Tablas de aprobaciones
      AddOne(DATABASE::"QB Approvals Setup");
      AddOne(DATABASE::"QB Position");
      AddOne(DATABASE::"QB Job Responsibles Group Tem.");
      AddOne(DATABASE::"QB Job Responsibles Template");
      AddOne(DATABASE::"QB Approval Circuit Header");
      AddOne(DATABASE::"QB Approval Circuit Lines");
    end;

    LOCAL procedure AddOne(pNro : Integer);
    begin
      Rec.INIT;
      rec."Table No." := pNro;
      if (pNro < 7100000) then
        Rec.Configuration := Rec.Configuration::Yes
      ELSE
        Rec.Configuration := Rec.Configuration::OnlyQB;
      if (Rec.INSERT) then ;
    end;

    LOCAL procedure AddFields(pTable : Integer;pField : Integer);
    begin
    end;

    // begin//end
}









