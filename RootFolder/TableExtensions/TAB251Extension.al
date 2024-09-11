tableextension 50157 "MyExtension50157" extends "Gen. Product Posting Group"
{
  
  DataCaptionFields="Code","Description";
    CaptionML=ENU='Gen. Product Posting Group',ESP='Grupo registro producto gen.';
    LookupPageID="Gen. Product Posting Groups";
  
  fields
{
    field(7174331;"QuoSII Type";Option)
    {
        OptionMembers=" ","Servicios","Entrega de bienes";CaptionML=ENU='SII Type',ESP='Tipo SII';
                                                   OptionCaptionML=ENU='" ,Servicios,Entrega de bienes"',ESP='" ,Servicios,Entrega de bienes"';
                                                   
                                                   Description='QuoSII.001';


    }
    field(7174332;"QuoSII IRPF Type";Boolean)
    {
        CaptionML=ENU='IRPF',ESP='IRPF';
                                                   Description='QuoSII1.3_014' ;


    }
}
  keys
{
   // key(key1;"Code")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(Brick;"Code","Description","Def. VAT Prod. Posting Group")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='Change all occurrences of %1 in %2\where %3 is %4\and %1 is %5.',ESP='Cambiar todas apariciones de %1 en %2\donde %3 es %4\y %1 es %5.';
//       GLAcc@1001 :
      GLAcc: Record 15;
//       GLAcc2@1002 :
      GLAcc2: Record 15;
//       Item@1003 :
      Item: Record 27;
//       Item2@1004 :
      Item2: Record 27;
//       Res@1005 :
      Res: Record 156;
//       Res2@1006 :
      Res2: Record 156;
//       ItemCharge@1007 :
      ItemCharge: Record 5800;
//       ItemCharge2@1008 :
      ItemCharge2: Record 5800;

    
//     procedure ValidateVatProdPostingGroup (var GenProdPostingGrp@1000 : Record 251;EnteredGenProdPostingGroup@1001 :
    
/*
procedure ValidateVatProdPostingGroup (var GenProdPostingGrp: Record 251;EnteredGenProdPostingGroup: Code[20]) : Boolean;
    begin
      if EnteredGenProdPostingGroup <> '' then
        GenProdPostingGrp.GET(EnteredGenProdPostingGroup)
      else
        GenProdPostingGrp.INIT;
      exit(GenProdPostingGrp."Auto Insert Default");
    end;

    /*begin
    end.
  */
}




