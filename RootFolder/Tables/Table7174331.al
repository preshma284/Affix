table 7174331 "SII Type List Value"
{
  
  
  
    LookupPageID="SII Type";
    DrillDownPageID="SII Type";
  
  fields
{
    field(1;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[250])
    {
        

                                                   CaptionML=ENU='Description',ESP='Descripci¢n';

trigger OnValidate();
    begin 
                                                                //{SIITypeListValue.RESET;
//                                                                SIITypeListValue.SETRANGE(Description,Description);
//                                                                IF NOT SIITypeListValue.ISEMPTY THEN
//                                                                  ERROR(Text00001,Description);     }
                                                              END;


    }
    field(3;"Type";Option)
    {
        OptionMembers="CommunicationType","Period","SalesInvType","PurchInvType","KeySpecialSalesInv","KeySpecialPurchInv","CountryIDType","CorrectedInvType","PropertyLocation","SujNoSuj","ExentType","ThirdParty","PaymentMethod","IntraType","IntraKey","ShipStatus","InvStatus","MultipleDest","OpKey","InvF4R5","Cupon","SIIEntity","IDType","NoVATType";CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU=',CommunicationType,Period,SalesInvType,PurchInvType,KeySpecialSalesInv,KeySpecialPurchInv,CountryIDType,CorrectedInvType,PropertyLocation,SujNoSuj,ExentType,ThirdParty,PaymentMethod,IntraType,IntraKey,ShipStatus,InvStatus,MultipleDest,OpKey,InvF4R5,Cupon,SIIEntity,IDType,NoVATType',ESP=',TipoComunicacion,Periodo,TipoFactEmitida,TipoFactRecibida,ClaveRegEspecialTrasFactEmitida,ClaveRegEspecialTrasFactRecibida,TipoIDPaisResi,TipoFactRectificativa,SituacionInmueble,SujNoSuj,TipoExenta,EmitidaTercero,MedioCobroPago,TipoOpIntracomunitaria,ClaveDeclaradoIntra,EstadoEnvio,EstadoFactura,VariosDestinatarios,ClaveOperacion,FacturaF4R5,Cupon,EntidadSII,TipoID,TipoNoSujeta';
                                                   


    }
    field(4;"Value";Text[100])
    {
        CaptionML=ENU='Value',ESP='Valor';


    }
    field(5;"SII Entity";Code[10])
    {
        CaptionML=ENU='SII Entity',ESP='Entidad SII';
                                                   Description='QuoSII_1.4.2.042' ;


    }
}
  keys
{
    key(key1;"Code","Type","SII Entity")
    {
        Clustered=true;
    }
}
  fieldgroups
{
    fieldgroup(DropDown;"Code","Description")
    {
        
    }
}
  
    var
//       SIITypeListValue@80000 :
      SIITypeListValue: Record 7174331;
//       Text00001@80001 :
      Text00001: TextConst ENU='No se puede insertar el registro. Ya existe un registro con la descripci¢n %1.';

    

trigger OnInsert();    begin
               SIITypeListValue.RESET;
               SIITypeListValue.SETRANGE(Description,Description);
               if not SIITypeListValue.ISEMPTY then
                 ERROR(Text00001,Description);   
             end;

trigger OnModify();    begin
               SIITypeListValue.RESET;
               SIITypeListValue.SETRANGE(Description,Description);
               if not SIITypeListValue.ISEMPTY then
                 ERROR(Text00001,Description);    
             end;



// procedure GetDocumentType (DocumentName@80003 :
procedure GetDocumentType (DocumentName: Text[250]) : Code[20];
    begin
      SIITypeListValue.RESET;
      SIITypeListValue.SETRANGE(Description,DocumentName);
      if SIITypeListValue.FINDFIRST then
        exit(SIITypeListValue.Code);

      exit('');
    end;

//     procedure GetDocumentName (Type@80003 : Integer;Code@1100286000 :
    procedure GetDocumentName (Type: Integer;Code: Code[20]) : Text[250];
    begin
      SIITypeListValue.RESET;
      SIITypeListValue.SETRANGE(Code,Code);
      SIITypeListValue.SETRANGE(Type,Type);
      if SIITypeListValue.FINDFIRST then
        exit(SIITypeListValue.Description);

      exit('');
    end;

    /*begin
    //{
//      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci¢n de enviar a la ATCN
//    }
    end.
  */
}







