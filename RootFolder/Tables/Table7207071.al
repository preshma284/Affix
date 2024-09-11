table 7207071 "QB Sales Header Ext."
{
  
  
    CaptionML=ENU='Sales Header Ext',ESP='Cab. venta Ext';
  
  fields
{
    field(1;"Record Id";RecordID)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Document Type',ESP='ID. Registro';


    }
    field(11;"Expenses/Investment";Option)
    {
        OptionMembers="Expenses","Investment","Emergencies";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Expenses/Investment',ESP='Gastos/Inversi¢n';
                                                   OptionCaptionML=ENU='Expenses,Investment,Emergencies',ESP='Gastos,Inversi¢n,Urgencia';
                                                   
                                                   Description='PARA Pedidos de servicio';


    }
    field(12;"Grouping Criteria";Code[20])
    {
        TableRelation="QB Grouping Criteria";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Grouping Criteria',ESP='Criterios de agrupaci¢n';
                                                   Description='PARA Pedidos de servicio';


    }
    field(13;"Contract No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Contract No.',ESP='N§ contrato';
                                                   Description='PARA Pedidos de servicio';


    }
    field(14;"Failiure Benefit Centre";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Benefit Centre',ESP='Centro beneficio';
                                                   Description='PARA Pedidos de servicio';


    }
    field(15;"Failiure Budget Pos.";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Budget Pos.',ESP='Pos. presup.';
                                                   Description='PARA Pedidos de servicio';


    }
    field(16;"Failiure Order";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Order',ESP='Orden';
                                                   Description='PARA Pedidos de servicio';


    }
    field(17;"Failiure Pep.";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Pep.';
                                                   Description='PARA Pedidos de servicio';


    }
    field(18;"Failiure Order No.";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Order No.',ESP='N§ pedido';
                                                   Description='PARA Pedidos de servicio';


    }
    field(19;"Price review percentage";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Price review percentage',ESP='Porcentaje revision precios';
                                                   Description='PARA Pedidos de servicio';


    }
    field(20;"IPC/Rev aplicado";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='IPC/Rev aplicado',ESP='IPC/Rev aplicado';
                                                   Description='PARA Pedidos de servicio';


    }
    field(21;"Price review";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Price review',ESP='Revision precios';
                                                   Description='PARA Pedidos de servicio';

trigger OnValidate();
    VAR
//                                                                 lrPriceReview@100000000 :
                                                                lrPriceReview: Record 7206965;
//                                                                 errNoPriceReview@100000001 :
                                                                errNoPriceReview: TextConst ENU='There is no price review for the job %1.',ESP='No hay ninguna revisi¢n de precios para el proyecto %1.';
//                                                                 lPriceReviewList@100000002 :
                                                                lPriceReviewList: Page 7207053;
//                                                                 errSelectCode@100000003 :
                                                                errSelectCode: TextConst ENU='You must select a price review code.',ESP='Debe seleccionar un codigo de revisi¢n de precios.';
//                                                                 errReviewApplied@100000004 :
                                                                errReviewApplied: TextConst ENU='The price review has been applied.',ESP='La revisi¢n de precios ya ha sido aplicada.';
//                                                                 SalesHeader@1100286000 :
                                                                SalesHeader: Record 36;
                                                              BEGIN 
                                                                IF "IPC/Rev aplicado" THEN
                                                                  ERROR(errReviewApplied);

                                                                IF (NOT "Price review") THEN BEGIN 
                                                                  //Si no es una revisi¢n de precio, eliminados valores de estos campos
                                                                  VALIDATE("Price review code", '');
                                                                  VALIDATE("Price review percentage", 0);
                                                                END ELSE BEGIN 
                                                                  //. Si el proyecto no tiene ning£n c¢digo de revisi¢n, no dejamos marcar este campo
                                                                  SalesHeader.GET(Rec."Record Id");
                                                                  lrPriceReview.RESET;
                                                                  lrPriceReview.SETRANGE("Job No.", SalesHeader."QB Job No.");
                                                                  CASE lrPriceReview.COUNT OF
                                                                    0 : ERROR(errNoPriceReview, SalesHeader."QB Job No.");
                                                                    1 : lrPriceReview.FINDFIRST;
                                                                    ELSE //. Si existen varias revisiones hacemos que el usuario escoja una
                                                                      BEGIN 
                                                                        CLEAR(lPriceReviewList);
                                                                        lPriceReviewList.SETTABLEVIEW(lrPriceReview);
                                                                        lPriceReviewList.LOOKUPMODE(TRUE);
                                                                        lPriceReviewList.EDITABLE(FALSE);
                                                                        IF lPriceReviewList.RUNMODAL <> ACTION::LookupOK THEN
                                                                          ERROR(errSelectCode);
                                                                        lPriceReviewList.GETRECORD(lrPriceReview);
                                                                      END;
                                                                  END;

                                                                  VALIDATE("Price review code", lrPriceReview."Review code");
                                                                  VALIDATE("Price review percentage", lrPriceReview.Percentage);
                                                                END;
                                                              END;


    }
    field(22;"Price review code";Code[10])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Price review code',ESP='Cod. Revision precios';
                                                   Description='PARA Pedidos de servicio' ;

trigger OnValidate();
    BEGIN 
                                                                //"qb Price x job review"."Review code" WHERE (Job No.=FIELD(Job No.))
                                                              END;


    }
}
  keys
{
    key(key1;"Record Id")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       gJobNo@1100286000 :
      gJobNo: Code[20];

//     procedure Read (rID@1100286002 :
    procedure Read (rID: RecordID) : Boolean;
    begin
      //Busca un registro, si no existe lo inicializa, retorna encontrado o no
      Rec.RESET;
      Rec.SETRANGE("Record Id", rID);
      if not Rec.FINDFIRST then begin
        Rec.INIT;
        Rec."Record Id" := rID;
        exit(FALSE);
      end;
      exit(TRUE)
    end;

    procedure Save ()
    begin
      //Guarda el registro
      if not Rec.MODIFY then
        Rec.INSERT;
    end;

//     procedure Copy (oQBSalesHeaderExt@1100286001 : Record 7207071;rID@1100286000 :
    procedure Copy (oQBSalesHeaderExt: Record 7207071;rID: RecordID)
    var
//       dQBSalesHeaderExt@1100286002 :
      dQBSalesHeaderExt: Record 7207071;
    begin
      if (Read(rID)) then begin
        Rec."Record Id" := rID;
        Rec.MODIFY;
      end else begin
        dQBSalesHeaderExt := oQBSalesHeaderExt;
        dQBSalesHeaderExt."Record Id" := rID;
        dQBSalesHeaderExt.INSERT;
      end;
    end;

    /*begin
    //{
//      // Q12733 18/02/22 (EPV) Revisi¢n de precios
//    }
    end.
  */
}







