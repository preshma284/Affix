tableextension 50167 "QBU Inventory SetupExt" extends "Inventory Setup"
{
  
  /*
Permissions=TableData 5896 m;
*/
    CaptionML=ENU='Inventory Setup',ESP='Config. inventario';
  
  fields
{
    field(7207270;"QBU OLD_Output Ship.Post Serie No.";Code[10])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='Output Ship. Posting Serie No.',ESP='No. Serie registro alb. salida';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207271;"QBU OLD_Stock Regulariz.Serie No.";Code[10])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='Stock Regularization Serie No.',ESP='No. serie regularizaci¢n stock';
                                                   Description='### ELIMINAR ### no se usa';


    }
    field(7207272;"QBU OLD_Output Ship. Serie No.";Code[10])
    {
        TableRelation="No. Series";
                                                   CaptionML=ENU='No. serie albaran salida',ESP='N§ serie albar n salida';
                                                   Description='### ELIMINAR ### no se usa' ;


    }
}
  keys
{
   // key(key1;"Primary Key")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       ItemLedgEntry@1000 :
      ItemLedgEntry: Record 32;
//       Text000@1001 :
      Text000: TextConst ENU='Some unadjusted value entries will not be covered with the new setting. You must run the Adjust Cost - Item Entries batch job once to adjust these.',ESP='La nueva configuraci¢n no cubrir  algunos movs. valor sin ajustar. Debe ejecutar el trabajo por lotes Valorar stock - movs. producto una vez para ajustarlos.';
//       Item@1002 :
      Item: Record 27;
//       InvtAdjmtEntryOrder@1003 :
      InvtAdjmtEntryOrder: Record 5896;
//       Text001@1005 :
      Text001: TextConst ENU='if you change the %1, the program must adjust all item entries.',ESP='Si cambia %1, el programa debe ajustar todos los movs. prod.';
//       Text002@1006 :
      Text002: TextConst ENU='The adjustment of all entries can take several hours.\',ESP='El ajuste de todos los movs. puede tardar diversas horas.\';
//       Text003@1007 :
      Text003: TextConst ENU='Do you really want to change the %1?',ESP='¨Quiere realmente cambiar %1?';
//       Text004@1008 :
      Text004: TextConst ENU='The program has cancelled the change that would have caused an adjustment of all items.',ESP='El programa ha cancelado el cambio que habr¡a causado un ajuste de todos los productos.';
//       Text005@1009 :
      Text005: TextConst ENU='%1 has been changed to %2. You should now run %3.',ESP='Se ha cambiado %1 a %2. Ahora deber¡a ejecutar %3.';
//       ObjTransl@1011 :
      ObjTransl: Record 377;
//       Text006@1004 :
      Text006: TextConst ENU='The field %1 should not be set to %2 if field %3 in %4 table is set to %5 because of possibility of deadlocks.',ESP='El campo %1 no debe estar establecido en %2 si el campo %3 de la tabla %4 est  definido en %5 debido a la posibilidad de bloqueos.';

    
/*
LOCAL procedure UpdateInvtAdjmtEntryOrder ()
    var
//       InvtAdjmtEntryOrder@1000 :
      InvtAdjmtEntryOrder: Record 5896;
    begin
      InvtAdjmtEntryOrder.SETCURRENTKEY("Cost is Adjusted","Allow Online Adjustment");
      InvtAdjmtEntryOrder.SETRANGE("Cost is Adjusted",FALSE);
      InvtAdjmtEntryOrder.SETRANGE("Allow Online Adjustment",FALSE);
      InvtAdjmtEntryOrder.SETRANGE("Is Finished",FALSE);
      InvtAdjmtEntryOrder.SETRANGE("Order Type",InvtAdjmtEntryOrder."Order Type"::Production);
      InvtAdjmtEntryOrder.MODIFYALL("Allow Online Adjustment",TRUE);
    end;
*/


//     LOCAL procedure UpdateAvgCostItemSettings (FieldCaption@1000 : Text[80];FieldValue@1001 :
    
/*
LOCAL procedure UpdateAvgCostItemSettings (FieldCaption: Text[80];FieldValue: Text[80])
    begin
      if not
         CONFIRM(
           STRSUBSTNO(
             Text001 +
             Text002 +
             Text003,FieldCaption),FALSE)
      then
        ERROR(Text004);

      CODEUNIT.RUN(CODEUNIT::"Change Average Cost Setting",Rec);

      MESSAGE(
        Text005,FieldCaption,FieldValue,
        ObjTransl.TranslateObject(ObjTransl."Object Type"::Report,REPORT::"Adjust Cost - Item Entries"));
    end;

    /*begin
    end.
  */
}





