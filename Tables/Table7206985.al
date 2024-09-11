table 7206985 "QBU Global Conf"
{
  
  
    DataPerCompany=false;
  
  fields
{
    field(1;"key";Integer)
    {
        DataClassification=ToBeClassified;


    }
    field(2;"License No.";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Company No.',ESP='N§ Licencia';


    }
    field(10;"Global Version";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Global Version',ESP='Versi¢n Global';
                                                   Description='VERSIONES. JAV 01/02/22: - Versi¢n Global del programa';


    }
    field(11;"Version QB";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n QB';
                                                   Description='VERSIONES. JAV 30/04/20: - Versi¢n de QB instalada';


    }
    field(12;"Version SP";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n SP';
                                                   Description='VERSIONES. JAV 30/04/20: - Versi¢n de SP instalada';


    }
    field(13;"Version QFA";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n QFA';
                                                   Description='VERSIONES. JAV 30/04/20: - Versi¢n de QFA instalada';


    }
    field(14;"Version QuoSII";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n QuoSII';
                                                   Description='VERSIONES. JAV 30/04/20: - Versi¢n de QuoSII instalado';


    }
    field(15;"Version QuoSync";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n QuoSync';
                                                   Description='VERSIONES. JAV 30/04/20: - Versi¢n de QuoSync instalada';


    }
    field(16;"QPR Version";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n QPR';
                                                   Description='VERSIONES. JAV 14/07/21: -  Versi¢n de QPR instalada';
                                                   Editable=false;


    }
    field(17;"RE Version";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n Real Estate';
                                                   Description='VERSIONES. JAV 17/11/21: - Versi¢n de Real Estate instalada';
                                                   Editable=false;


    }
    field(18;"MD Version";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n Master Data';
                                                   Description='VERSIONES. JAV 15/02/22: - Versi¢n de Master Data instalada';


    }
    field(19;"Data Version";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n de Datos';
                                                   Description='VERSIONES. JAV 10/03/21: - Versi¢n de datos actual';


    }
    field(20;"DP Version";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n de Prorratas';
                                                   Description='VERSIONES. JAV 21/06/21: - Versi¢n de manejo de proformas';


    }
    field(50;"Company";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Empresa';
                                                   Description='Para los cambios parciales por empresa';


    }
    field(51;"Version in Company";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Versi¢n en la Empresa';
                                                   Description='Para los cambios parciales por empresa' ;


    }
}
  keys
{
    key(key1;"key")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    // procedure GetGlobalConf (pCompany@1100286000 :
procedure GetGlobalConf (pCompany: Text)
    var
//       nro@1100286001 :
      nro: Integer;
    begin
      if (pCompany = '') then begin
        if not Rec.GET(0) then begin
          Rec.INIT;
          Rec.key := 0;
          Rec.INSERT;
        end;
      end else begin
        Rec.RESET;
        Rec.FINDLAST;
        nro := Rec.key;

        Rec.RESET;
        Rec.SETRANGE(Company, pCompany);
        if (not Rec.FINDFIRST) then begin
          Rec.INIT;
          Rec.key := nro+1;
          Rec.Company := pCompany;
          Rec.INSERT;
        end;
      end;
    end;

//     procedure ExistCompany (pCompany@1100286000 :
    procedure ExistCompany (pCompany: Text) : Boolean;
    begin
      Rec.RESET;
      Rec.SETRANGE(Company, pCompany);
      exit(not Rec.ISEMPTY);
    end;

//     procedure NeedChangeVersion (var Version@1100286000 : Text;var NeedChange@1100286001 :
    procedure NeedChangeVersion (var Version: Text;var NeedChange: Boolean)
    var
//       Object@1100286002 :
      Object: Record 2000000001;
//       QBGlobalConf@1100286003 :
      QBGlobalConf: Record 7206985;
//       FunctionQB@1100286004 :
      FunctionQB: Codeunit 7207272;
    begin
      //---------------------------------------------------------------------------------------------------------
      // JAV 18/06/22: - QB 1.10.51 Retorna la versi¢n actual y si hay que actualizar
      //---------------------------------------------------------------------------------------------------------

      //Buscar la versi¢n del programa en la tabla de cambios
      Object.RESET;
      Object.SETRANGE(Type, Object.Type::Table);
      Object.SETRANGE(ID, 7206921);
      Object.FINDFIRST;

      Version := COPYSTR(Object."Version List",1,6);

      //Leer el fichero de configuraci¢n global, si no existe lo crear 
      QBGlobalConf.GetGlobalConf('');
      if not FunctionQB.IsClient('CEI') then begin              //Si no est  con la licencia de CEI, ponemos la del cliente
        QBGlobalConf."License No." := SERIALNUMBER;
        QBGlobalConf.MODIFY;
      end;

      //Retornamos si ha cambiado la version
      NeedChange := (Version <> QBGlobalConf."Global Version");
    end;

    /*begin
    //{
//      JAV 18/06/22: - QB 1.10.51 Nueva funci¢n NeedVersionChange que retorna la versi¢n actual y si hay que actualizar
//      JAV 21/06/22: - DP 1.00.00 Nuevo campo para la versi¢n del m¢dulo de proformas
//    }
    end.
  */
}







