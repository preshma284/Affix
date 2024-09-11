table 7206921 "QB Version Changes"
{
  
  
    DataPerCompany=false;
    CaptionML=ESP='Cambios efectuados en QuoBuilding';
  
  fields
{
    field(1;"Product";Text[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='Producto';


    }
    field(2;"Version";Text[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Version',ESP='Versi¢n';


    }
    field(3;"Line";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Linea';


    }
    field(9;"Order";Text[30])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Orden';


    }
    field(10;"Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Future Currency',ESP='Fecha';


    }
    field(11;"Type";Option)
    {
        OptionMembers="Base","Mejora","Arreglo","Fin";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Tipo';
                                                   OptionCaptionML=ESP='"Base,Mejora,Arreglo, "';
                                                   


    }
    field(12;"Description";Text[250])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Date',ESP='Descripci¢n';


    }
    field(13;"Siglas";Text[5])
    {
        DataClassification=ToBeClassified;
                                                   Description='JAV 11/05/22: Siglas del que ha efectuado el desarrollo' ;


    }
}
  keys
{
    key(key1;"Product","Version","Line")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QBVersionChanges@1100286010 :
      QBVersionChanges: Record 7206921;
//       Prod@1100286000 :
      Prod: Text;
//       Ver@1100286001 :
      Ver: Text;
//       Fec@1100286002 :
      Fec: Date;
//       Lin@1100286003 :
      Lin: Integer;
//       mQB@1100286004 :
      mQB: TextConst ESP='QuoBuilding';
//       mQS@1100286007 :
      mQS: TextConst ESP='QuoSync';
//       mQF@1100286005 :
      mQF: TextConst ESP='QuoFacturae';
//       mQSII@1100286006 :
      mQSII: TextConst ESP='QuoSII';
//       mSP@1100286008 :
      mSP: TextConst ESP='SharePoint';
//       mQPR@1100286009 :
      mQPR: TextConst ESP='QPR';
//       mRE@1100286011 :
      mRE: TextConst ESP='RE';
//       mData@1100286012 :
      mData: TextConst ESP='DataVersion';
//       mEmpresa@1100286013 :
      mEmpresa: TextConst ESP='Empresa';
//       mMD@1100286014 :
      mMD: TextConst ESP='Master Data';
//       mDP@1100286015 :
      mDP: TextConst ESP='Prorrata IVA';

    

trigger OnInsert();    begin
               Order := PADSTR(Version, MAXSTRLEN(Version), '_') + FORMAT(10000 - Line);
             end;



procedure GetKey_DV () : Code[20];
    begin
      //Retorna la clave del registro de Versi¢n de Datos
      exit(mData);
    end;

    procedure GetDataVersion () : Code[20];
    var
//       DataVersion@1100286000 :
      DataVersion: Code[20];
    begin
      //Retorna la versi¢n de datos actual
      QBVersionChanges.RESET;
      QBVersionChanges.SETRANGE(Product, GetKey_DV);
      if (QBVersionChanges.FINDLAST) then
        exit(QBVersionChanges.Version);

      //Si es la primera vez no tengo este dato, lo busco con la versi¢n actual de QuoBuilding. Esta parte es temporal hasta que todos los clientes est‚n en el nuevo sistema
        //Busco la versi¢n de QB, si no hay ninguna es la primera
        AddAll;
        QBVersionChanges.RESET;
        QBVersionChanges.SETRANGE(Product, mQB);
        if not QBVersionChanges.FINDLAST then
          exit('00000');

        //Estas son versiones anteriores al nuevo sistema de control de la estructura de datos
        CASE QBVersionChanges.Version OF
          '1.09.06' : exit('00001');
          '1.09.19' : exit('00002');
          '1.09.20' : exit('00003');
          '1.09.22' : exit('00004');
          '1.09.26' : exit('00005');
        end;

      //No hay nada, por tanto es la primera versi¢n.
      exit('00000');
    end;

//     procedure SetDataVersion (pVersion@1100286000 : Code[10];pOld@1100286002 :
    procedure SetDataVersion (pVersion: Code[10];pOld: Code[10])
    var
//       nLin@1100286001 :
      nLin: Integer;
    begin
      //Guardamos la Versi¢n de Datos
      QBVersionChanges.RESET;
      QBVersionChanges.SETRANGE(Product, GetKey_DV);
      QBVersionChanges.SETRANGE(Version, pVersion);
      if QBVersionChanges.FINDLAST then
        nLin := QBVersionChanges.Line + 1
      else
        nLin := 1;

      QBVersionChanges.INIT;
      QBVersionChanges.Product := GetKey_DV;
      QBVersionChanges.Version := pVersion;
      QBVersionChanges.Line := nLin;
      QBVersionChanges.Date := TODAY;
      QBVersionChanges.Description := 'Realizado cambio de versi¢n desde la ' + pOld;
      QBVersionChanges.INSERT;
    end;

    procedure UpdateConf ()
    var
//       QBLogChanges@1100286004 :
      QBLogChanges: Record 7206921;
//       QBGlobalConf@1100286006 :
      QBGlobalConf: Record 7206985;
//       QuoBuildingSetup@1100286000 :
      QuoBuildingSetup: Record 7207278;
    begin
      //Actualizar datos de configuraci¢n
      QBGlobalConf.GetGlobalConf('');
      QBLogChanges.RESET;
      QBLogChanges.SETRANGE(Product, mQB);   if QBLogChanges.FINDLAST then QBGlobalConf."Version QB"      := QBLogChanges.Version;
      QBLogChanges.SETRANGE(Product, mQS);   if QBLogChanges.FINDLAST then QBGlobalConf."Version QuoSync" := QBLogChanges.Version;
      QBLogChanges.SETRANGE(Product, mSP);   if QBLogChanges.FINDLAST then QBGlobalConf."Version SP"      := QBLogChanges.Version;
      QBLogChanges.SETRANGE(Product, mQF);   if QBLogChanges.FINDLAST then QBGlobalConf."Version QFA"     := QBLogChanges.Version;
      QBLogChanges.SETRANGE(Product, mQSII); if QBLogChanges.FINDLAST then QBGlobalConf."Version QuoSII"  := QBLogChanges.Version;
      QBLogChanges.SETRANGE(Product, mQPR);  if QBLogChanges.FINDLAST then QBGlobalConf."QPR Version"     := QBLogChanges.Version;
      QBLogChanges.SETRANGE(Product, mRE);   if QBLogChanges.FINDLAST then QBGlobalConf."RE Version"      := QBLogChanges.Version;
      QBLogChanges.SETRANGE(Product, mMD);   if QBLogChanges.FINDLAST then QBGlobalConf."MD Version"      := QBLogChanges.Version;  //Master Data
      QBLogChanges.SETRANGE(Product, mDP);   if QBLogChanges.FINDLAST then QBGlobalConf."DP Version"      := QBLogChanges.Version;  //Proformas

      QBGlobalConf.MODIFY;
    end;

//     LOCAL procedure AddVer (pProduct@1100286000 : Text;pVersion@1100286001 : Text;pDate@1100286002 :
    LOCAL procedure AddVer (pProduct: Text;pVersion: Text;pDate: Date)
    var
//       QBLogChanges@1100286004 :
      QBLogChanges: Record 7206921;
//       QBGlobalConf@1100286006 :
      QBGlobalConf: Record 7206985;
    begin
      //A¤adir una versi¢n
      Prod := pProduct;
      Ver  := pVersion;
      Fec  := pDate;
      Lin  := 0;

      INIT;
      Product := Prod;
      Version := Ver;
      Line    := 9999;
      Type    := Rec.Type::Fin;
      if not INSERT(TRUE) then;

      QBGlobalConf.GetGlobalConf('');
      CASE Prod OF
        mQB   : if (QBGlobalConf."Version QB"     < Ver) then begin QBGlobalConf."Version QB"     := Ver; QBGlobalConf.MODIFY; end;
        mSP   : if (QBGlobalConf."Version SP"     < Ver) then begin QBGlobalConf."Version SP"     := Ver; QBGlobalConf.MODIFY; end;
        mQF   : if (QBGlobalConf."Version QFA"    < Ver) then begin QBGlobalConf."Version QFA"    := Ver; QBGlobalConf.MODIFY; end;
        mQSII : if (QBGlobalConf."Version QuoSII" < Ver) then begin QBGlobalConf."Version QuoSII" := Ver; QBGlobalConf.MODIFY; end;
        mQPR  : if (QBGlobalConf."QPR Version"    < Ver) then begin QBGlobalConf."QPR Version"    := Ver; QBGlobalConf.MODIFY; end;
        mRE   : if (QBGlobalConf."RE Version"     < Ver) then begin QBGlobalConf."RE Version"     := Ver; QBGlobalConf.MODIFY; end;
        mDP   : if (QBGlobalConf."DP Version"     < Ver) then begin QBGlobalConf."DP Version"     := Ver; QBGlobalConf.MODIFY; end;
      end;
    end;

//     LOCAL procedure AddLog (pSiglas@1100286000 : Text;pType@1100286005 : Option;pText@1100286003 :
    LOCAL procedure AddLog (pSiglas: Text;pType: Option;pText: Text)
    var
//       QBLogChanges@1100286004 :
      QBLogChanges: Record 7206921;
//       QuoBuildingSetup@1100286006 :
      QuoBuildingSetup: Record 7207278;
    begin
      //A¤adir una entrada
      Lin += 1;

      INIT;
      Product := Prod;
      Version := Ver;
      Line := Lin;
      Type := pType;
      if (Lin = 1) then
        Date := Fec;
      Description := pText;
      if (pSiglas <> 'JAV') then
        Siglas := pSiglas;
      INSERT(TRUE);
    end;

    procedure AddAll ()
    var
//       QBVersionChanges@1100286001 :
      QBVersionChanges: Record 7206921;
    begin
      RESET;
      SETFILTER(Product, '<>%1', GetKey_DV);  //No eliminamos los registros de cambios de versi¢n de datos
      DELETEALL;

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      AddVer(mSP, '0.1',   20200415D); AddLog('   ',0,'Se adapta QuoBuilding a partir de la versi¢n 1.00.00 para el manejo del enlace con SharePoint.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      AddVer(mQF, '0.1a',  20200415D); AddLog('   ',0,'Se a¤aden el manejo de SharePoint a la lista y la ficha del comparativo de ofertas.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      AddVer(mQS,'1.00.00',20200415D); AddLog('   ',0,'Se incluye la primera versi¢n del m¢dulo de sincronizaci¢n entre empresas:');
      AddVer(mQS,'1.00.01',20200415D); AddLog('   ',0,'Arreglos menores en el m¢dulo.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      AddVer(mQSII,'1.05',  20200415D); AddLog('   ',0,'Se adapta QuoBuilding a partir de la versi¢n 1.06.02 para el manejo de mQSI.');
      AddVer(mQSII,'1.05a', 20200415D); AddLog('   ',0,'Se a¤ade el tipo de CIF/NIF en la ficha del proveedor. Peque¤os arreglos en la exportaci¢n.');
      AddVer(mQSII,'1.05b', 20200415D); AddLog('   ',0,'Peque¤os arreglos en la exportaci¢n.');
      AddVer(mQSII,'1.05c', 20200415D); AddLog('   ',0,'Se ocultan campos en los abonos de compra y venta que no son necesarios.');
      AddVer(mQSII,'1.05d', 20200415D); AddLog('   ',0,'Se ocultan mas campos en los abonos de compra y venta que no son necesarios.');
      AddVer(mQSII,'1.05e', 20200415D); AddLog('   ',0,'Se a¤ade Ejercicio y Periodo de declaraci¢n en las facturasde facturas de compra y de venta.');
                                      AddLog('   ',0,'   - En las de venta, se a¤ade la fecha de operaci¢n manual tras la fecha de fin del periodo de facturaci¢n, el periodo-ejercicio y la fecha de operaci¢n.');
                                      AddLog('   ',0,'   - Para obtener la fecha de operaci¢n se usa o la manual, si no hay la de fin del periodo de facturaci¢n, y si no hay la del documento.');
                                      AddLog('   ',0,'   - El periodo y ejercicio se obtiene a partir de la fecha de operaci¢n.');
                                      AddLog('   ',0,'   - En las de compra se a¤ade el periodo-ejercicio.');
                                      AddLog('   ',0,'   - El dato se obtiene a partir de la fecha del documento, si es del mes anterior al actual y estamos en la primera quincena ser  del mes anterior.');
                                      AddLog('   ',0,'   - Para que actue hay que informar configuraci¢n de QuoSII "Periodo de Facturas Recibidas" e indicar en "D¡a periodo anterior compras" el £ltimo d¡a a considerar, si no se indica ser  el 15.');
      AddVer(mQSII,'1.05f', 20200415D); AddLog('   ',0,'Si se modifica desde los documentos del QuoSII una factura de compra o de venta, se actualizan el tipo y r‚gimen especial en la factura registrada.');
                                      AddLog('   ',0,'Se a¤ade una fecha m¡nima para obtener los documentos a incluir en el SII, si se informa solo se incluyen a partir de esa fecha inclusive.');
      AddVer(mQSII,'1.05g', 20200415D); AddLog('   ',0,'Para las facturas emitidas de tipo 14 se informa como fecha de operaci¢n la fecha de vencimiento.');
      AddVer(mQSII,'1.05h', 20200415D); AddLog('   ',0,'Se amplia el guardarse en los abonos los cambios en documentos desde el QuoSII.');
                                      AddLog('JAV',2,'Se arregla un error al indicar la fecha de registro de los documentos de compra que no sean de tipo 14.');
      AddVer(mQSII,'1.05i', 20200415D); AddLog('   ',0,'Se a¤ade el campo de Tipo de CIF/NIF en el panel QuoSII de la ficha de clientes y proveedores.');
      AddVer(mQSII,'1.05j', 20200415D); AddLog('   ',0,'Se a¤ade en la configuraci¢n un campo para indicar si el env¡o a la cola de proyectos se hace en entorno Real o en entorno de Pruebas.');
      AddVer(mQSII,'1.05k', 20200415D); AddLog('   ',0,'Se a¤ade el tratamiento de los registros tipo 14 para el IVA no devengado en construcci¢n para empresas publicas.');
                                      AddLog('JAV',1,'   - Al crear la factura con r‚gimen especial 14 e IVA diferido, se crea en el QuoSII el documento con ese tipo y por el total del IVA.');
                                      AddLog('JAV',1,'   - Se sube normalmente a la AEAT este registro como facturas emitidas del tipo A0.');
                                      AddLog('JAV',1,'   - Al cobrar la factura se crean dos documentos nuevos, uno por la factura con R‚gimen Especial 01, y otro como cobro de factura del tipo 14 para dejarla a cero.');
                                      AddLog('JAV',1,'   - Se debe subir a la AEAT el registro de la factura como factura emitidas con tipo A0.');
                                      AddLog('JAV',1,'   - Se sube subir a la AEAT el registro de la anulaci¢n como cobro de factura con tipo A1.');
                                      AddLog('   ',0,'Se a¤ade un campo para indicar que el documento no se suba al SII, si se marca en los documentos de compra o de venta la factura no aparece al importar documentos al QuoSII.');
      AddVer(mQSII,'1.05l', 20200415D); AddLog('   ',0,'Se a¤ade el tipo de env¡o por defecto general en la configuraci¢n del QuoSII.');
      AddVer(mQSII,'1.05m', 20200415D); AddLog('   ',0,'Se permite marcar en los documentos que no se desean subir al SII.');
                                      AddLog('JAV',1,'   - Se a¤aden un campo para indicar que no se suben en los documentos sin registrar.');
                                      AddLog('JAV',1,'   - Se a¤aden la posibilidad de cambiarlo en los documentos registrados.');
                                      AddLog('JAV',1,'   - Al capturar documentos se crean con el tipo "No subir al SII" para que quede constancia de esos documentos.');
                                      AddLog('JAV',1,'Mejora en la pantalla de documentos, se ponen colores para indicar el estado de este, la pantalla se ordena ahora por fecha de registro.');
      AddVer(mQSII,'1.05n', 20200415D); AddLog('   ',0,'Se cambia la forma de enviar los documentos de tipo 14 a la AEAT.');
      AddVer(mQSII,'1.05o', 20200415D); AddLog('   ',0,'Se a¤ade la descripci¢n de la operaci¢n en la subida al SII si est  informada.');
                                      AddLog('   ',0,'Ajustes para los cobros de facturas de certificaciones con IVA diferido del tipo 14.');
      AddVer(mQSII,'1.05p', 20200415D); AddLog('   ',0,'Se revisan temas para emitidas y sus cobros de tipo 14 y pagos de tipo 07.');
      AddVer(mQSII,'1.05q', 20200415D); AddLog('   ',0,'Se revisan temas para la marca de documentos como No Subir al SII.');
      AddVer(mQSII,'1.05r', 20200415D); AddLog('   ',0,'Se mejora el proceso de las colas. Se a¤ade la navegaci¢n en los env¡os de un documento. Al eliminar un env¡o no quitaba la marca en los documentos. ');
      AddVer(mQSII,'1.05s', 20200415D); AddLog('   ',0,'Se amplia el campo del password del WS de 30 a 100 caracteres.');
                                      AddLog('   ',0,'Se incluyen los hist¢ricos de documentos en el men£ del QuoSII.');
                                      AddLog('   ',0,'Se incluye el estado del QuoSII en las listas de hist¢ricos de documentos.');
                                      AddLog('JAV',2,'Se elimina la variable duplicada "QuoSII Do not Send" con nombre "No subir al SII".');
      AddVer(mQSII,'1.05t', 20200415D); AddLog('JAV',2,'Si en las colas no se indican fechas de inicio y fin no se lanza la creaci¢n de ciertas operaciones que lo requieren (cobros en met lico, bienes de inversi¢n, seguros.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      AddVer(mQF, '0.3',   20200415D); AddLog('   ',0,'Se adapta QuoBuilding a partir de la versi¢n 1.00.00 para el env¡o a Facturae.');
      AddVer(mQF, '0.3a',  20200415D); AddLog('   ',0,'Se arregla un error en los abonos de venta cuando no existe la configuracion del m¢dulo.');
      AddVer(mQF, '1.3b',  20200415D); AddLog('   ',0,'Arreglos menores en el m¢dulo de la eFactura.');
      AddVer(mQF, '1.3c',  20200415D); AddLog('   ',0,'Se a¤ade el mail de la empresa en la configuraci¢n de QuoFacturae, en lugar de sacarlo de informaci¢n de empresa');
      AddVer(mQF, '1.3d',  20200415D); AddLog('   ',0,'Se a¤aden mensajes de error para c¢digos postales incorrectos al generar el XML.');
      AddVer(mQF, '1.3e',  20200415D); AddLog('   ',0,'Se soluciona un error al entrar en la p gina de configuraci¢n de los endpoits para Facturae.');
      AddVer(mQF, '1.3f',  20200415D); AddLog('   ',0,'Se soluciona un error en el XML con el tipo de IVA y la unidad de medida.');
      AddVer(mQF, '1.3g',  20200415D); AddLog('   ',0,'Se a¤aden nuevos elementos para enviar a Facturae.');
                                     AddLog('JAV',1,'   - Se a¤ade un par metro para decidir si las facturas se remiten agrupadas o desglosadas.');
                                     AddLog('JAV',1,'   - Si se env¡an agrupadas, se usa el campo "descripci¢n del trabajo" como descripci¢n de la l¡nea.');
                                     AddLog('JAV',1,'   - Si se env¡an detalladas, si se informa del campo "descripci¢n del trabajo" se remite como informaci¢n de la factura.');
                                     AddLog('JAV',1,'   - Se a¤aden campos para fecha de inicio y de final del periodo de facturaci¢n, solo se remiten si se informan.');
                                     AddLog('JAV',1,'   - En el hist¢rico de facturas de venta, bot¢n "Actualizar documentos", se a¤aden los campos "Descripci¢n del trabajo" y las fechas del periodo de facturaci¢n.');
                                     AddLog('JAV',1,'   - Se a¤aden los documentos anexos de tipo PDF en el env¡o a Facturae.');
      AddVer(mQF, '1.3h',  20200415D); AddLog('   ',0,'Se a¤aden los botones de Facturae en las pantallas de lista y ficha de facturas y abonos de venta registrados.');
                                     AddLog('   ',0,'Se a¤ade informaci¢n de vencimientos y banco al XML de la factura generada.');
      AddVer(mQF, '1.3i',  20200415D); AddLog('   ',0,'En los documentos adjuntos a una factura se pueden marcar los que se van a remitir por Face.');
      AddVer(mQF, '1.3j',  20200415D); AddLog('   ',0,'Se a¤aden nuevos par metro para enviar a Facturae.');
                                     AddLog('JAV',1,'   - Si se desea enviar la descripci¢n del trabajo como la primera l¡nea de la fatura sin importes.');
                                     AddLog('JAV',1,'   - Si se desea enviar siempre las fechas del periodo de facturaci¢n.');
      AddVer(mQF, '1.3k',  20200415D); AddLog('   ',0,'Mejoras en el envio a FACE.');
                                     AddLog('JAV',1,'   - Se a¤ade en los documentos de venta la posibilidad de indicar que se ha subido manualmente a Facturae con un bot¢n "A¤adir al Log".');
                                     AddLog('JAV',1,'   - Se marcan en colores verde y rojo los envios seg£n sean correcto o con error.');
      AddVer(mQF, '1.3l',  20200415D); AddLog('   ',0,'XML enviado:');
                                     AddLog('JAV',1,'   - Se guarda en cada env¡o el XML generado. En las pantallas del log se a¤ade una columna XML, si tiene valor pinchando se desrga el XML guardado.');
                                     AddLog('JAV',1,'Mejoras:');
                                     AddLog('JAV',1,'   - Se pone el factbox de documentos en mos movimientos de clientes, y el factbox de Facturae en la factura registrada.');
      AddVer(mQF, '1.3m',  20200415D); AddLog('   ',0,'Versi¢n interna para cambiar de lugar algunas funciones que eran del m¢dulo.');
      AddVer(mQF, '1.3n',  20200415D); AddLog('   ',0,'Si no se informan de las fechas del periodo de facturaci¢n no se informan en la eFactura.');
      AddVer(mQF, '1.3o',  20200415D); AddLog('   ',0,'Se informa del vencimiento y el banco tambi‚n para facturas, no solo para efectos.');
      AddVer(mQF, '1.3p',  20200415D); AddLog('   ',0,'Se unifican las versiones y se arregla un error en la longitud de la provincia de la tabla de entidades.');
                                     AddLog('JAV',2,'Se arregla un error de longitud cuando la respuesta con un motivo de rechazo tiene mas de 250 caracteres.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      AddVer(mQB,'1.00',20200415D);
      AddLog('   ',0,'Reforma general para generar la nueva versi¢n base de QuoBuilding 1.00');
      AddLog('JAV',1,'Los representantes de clientes y proveedores ahora son contactos.');

      AddVer(mQB,'1.01',20200415D);
      AddLog('   ',0,'Los textos extendidos de los descompuestos son ahora textos largos f cilmente editables:');
      AddLog('JAV',1,'   - En la pantalla se ven simult neamente el texto para coste y el de venta de la Unidad de Obra');
      AddLog('JAV',1,'   - Si solo se define el primero, se usa en ambos.');
      AddLog('   ',0,'Cuando desde una oferta/contrato de compra se solicita cargar la producci¢n:');
      AddLog('JAV',1,'   - Se calcula para todas los descompuestos de la partida, no solo para el primero.');
      AddLog('JAV',1,'   - Se presenta una pantalla con el resultado antes de aplicarlos, que se puede modificar.');
      AddLog('   ',0,'Se mejora la integraci¢n con los m¢dulos opcionales Sharepoint y eFactura.');
      AddLog('   ',0,'Se a¤ade la versi¢n de QB y esta lista en la pantalla de configuraci¢n.');

      AddVer(mQB,'1.02',20200415D);
      AddLog('   ',0,'Los descompuestos, comparativos y contratos disponen de textos extendidos:');
      AddLog('JAV',1,'   - En la pantalla se ven simult neamente el texto para coste y el de venta del descompuesto');
      AddLog('JAV',1,'   - Si solo se define el primero, se usa en ambos.');
      AddLog('   ',0,'Las actividades se definen a nivel de descompuesto:');
      AddLog('JAV',1,'   - El valor por defecto se carga a partir del producto o recurso usado');
      AddLog('JAV',1,'   - Si se define actividad en la unidad de obra esta pasa al descompuesto, pero se puede cambiar en el mismo.');
      AddLog('JAV',1,'   - Si se subcontrata una unidad de obra, la actividad pasa al descompuesto en donde se puede cambiar. aunque no se recomienda.');
      AddLog('JAV',1,'   - Desde el diario de contrataci¢n se permite separar por actividades. Si se cambia en la l¡nea cambia en el descompuesto asociado.');
      AddLog('   ',0,'Cuando se subcontrata una partida:');
      AddLog('JAV',1,'   - Se combinan los textos de los descompuestos en el nuevo descompuesto de subcontrataci¢n');
      AddLog('JAV',1,'   - Si luego se anula deja los descompuestos de la partida como estaban originalmente.');
      AddLog('   ',0,'En la pantalla del diario de necesidades:');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n de puntos de uso, donde se ve en que unidades de obra se emplea.');
      AddLog('JAV',1,'   - Al calcular las necesidades se a¤aden los textos extendidos de los descompuestos a las l¡neas.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n para ver los textos ampliados.');
      AddLog('JAV',1,'   - Se a¤ade una columna "Generar", las casillas marcadas ser n las que se lleven a los comparativos.');
      AddLog('   ',0,'En los comparativos de compras:');
      AddLog('JAV',1,'   - Se a¤ade una columna que indica si tiene texto extendido, y un bot¢n para verlos.');
      AddLog('JAV',1,'   - Se a¤ade una columna con la cantidad a segregar y el bot¢n de segregar en otro comparativo.');
      AddLog('JAV',1,'   - Al generar el contrato, los textos extendidos pasan a las l¡neas de este.');
      AddLog('JAV',1,'   - En los comparativos del estudio se habilita el bot¢n para pasar el comparativo al proyecto.');
      AddLog('   ',0,'En los contratos de compras:');
      AddLog('JAV',1,'   - Se a¤ade una columna que indica si tiene texto extendido, y un bot¢n para verlos.');
      AddLog('   ',0,'Al importar un BC3 en un preciario permite establecer el valor para el primer cap¡tulo a importar.');
      AddLog('   ',0,'Al importar un preciario en un proyecto permite establecer el valor para el primer cap¡tulo a importar.');
      AddLog('   ',0,'Se a¤ade el departamento por defecto cuando se crea el almac‚n en los proyectos.');
      AddLog('   ',0,'Se hacen navegables los importes facturado y coste en el factBox del proyecto.');
      AddLog('   ',0,'Otros arreglos:');
      AddLog('JAV',2,'   - No cargaba en los preciarios los textos de venta si eran diferentes a los de coste.');
      AddLog('JAV',2,'   - Se arregla un error con el campo "estado licencia" de los proyectos operativos.');
      AddLog('JAV',2,'   - Se arregla la impresi¢n de las proformas al incluir los textos extendidos.');
      AddLog('JAV',2,'   - Se permite definir cliente en los proyectos que no lo tengan informado, aunque tengan movimientos.');
      AddLog('JAV',2,'   - Se arregla un error al eliminar un presupuesto del proyecto.');
      AddLog('JAV',2,'   - Se arregla un error al generar retenciones en facturas de compra y de venta.');

      AddVer(mQB,'1.03',20200415D);
      AddLog('   ',0,'Mejoras en las aprobaciones de documentos:');
      AddLog('JAV',1,'   - Se a¤ade un asistente de configuraci¢n de aprobaciones.');
      AddLog('JAV',1,'   - Se a¤ade el manejo de aprobaci¢n de facturas antes de registrarlas.');
      AddLog('JAV',1,'   - Se a¤ade un asistente de configuraci¢n de aprobaciones.');
      AddLog('JAV',1,'   - En las facturas a pagar se a¤ade el panel lateral con el documento escaneado y un bot¢n para acceder a la factura.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de retener la aprobaci¢n de pagos de facturas.');
      AddLog('JAV',1,'   - Se a¤ade ver el comentario de la aprobaci¢n, rechazo o retenci¢n en los documentos.');
      AddLog('JAV',1,'   - En las facturas a pagar se a¤ade el panel lateral con el documento y un bot¢n para verlo directamente.');
      AddLog('   ',0,'Mejora en las necesidades de compra de los proyectos:');
      AddLog('JAV',1,'   - Se mejora el manejo de las secciones.');
      AddLog('JAV',1,'   - Se a¤ade un par metro en el c lculo para no incluir los que est‚n en otras secciones.');
      AddLog('   ',0,'Se a¤ade el campo CIF/NIF en las pantallas de clientes y proveedores justo debajo del nombre.');
      AddLog('   ',0,'Otros arreglos:');
      AddLog('JAV',2,'   - Se corrige un problema en el c lculo de los indirectos fijos periodificables.');
      AddLog('JAV',2,'   - Se eliminan enlaces err¢neos en las pantallas del rolcenter.');
      AddLog('JAV',2,'   - Se arregla un error al navegar a las versiones de un estudio.');
      AddLog('JAV',2,'   - Se arregla un error al copiar l¡neas o crear un abono correctivo.');
      AddLog('JAV',2,'   - Se arregla un error al actualizar precios desde el comparativo a la obra.');

      AddVer(mQB,'1.04',20200415D);
      AddLog('   ',0,'Archivar estudios y proyectos operativos:');
      AddLog('JAV',1,'   - Se a¤ade un campo para marcar cuando se desea archivar estudios y proyectos operativos.');
      AddLog('JAV',1,'   - Se a¤aden en el men£ entradas para estudios archivados y para proyectos operativos archivados.');
      AddLog('JAV',1,'   - Al marcar como archivado cambia de lista, y al contrario al desmarcar retorna a la lista principal.');
      AddLog('   ',0,'Mejoras en documentos de compra y de venta:');
      AddLog('JAV',1,'   - Se a¤ade un campo en cabecera para no subir al SII el documento de forma autom tica.');
      AddLog('JAV',1,'   - Para subir al SII estos documentos se har n de forma manual o se deber  ir al hist¢rico y quitar la marca usando  el bot¢n de actualizar documento.');
      AddLog('JAV',1,'   - En los documentos de compra se puede buscar directamente producto, recurso o cuenta desde la l¡nea sin sacar otra pantalla, igual que hace en ventas.');
      AddLog('JAV',1,'   - En los pedidos de compra se a¤ade el importe de la base imponible del albar n a registrar.');
      AddLog('JAV',1,'   - En facturas de compra se definen hasta tres posibles circuitos de aprobaci¢n independientes.');
      AddLog('JAV',2,'   - Se arreglan errores en la presentaci¢n de los totales de los documentos.');
      AddLog('   ',0,'Mejoras en Retenciones:');
      AddLog('JAV',1,'   - Se mejora la vista previa de registro de los documentos a¤adiendo las retenciones.');
      AddLog('JAV',1,'   - Se revisa en correcto funcionamiento de las retenciones en documentos.');
      AddLog('JAV',1,'   - En la lista de retenciones, se a¤ade la columna de "Fecha de fin de garant¡a de la obra".');
      AddLog('JAV',1,'   - Se a¤ade en configuraci¢n los d¡as de aviso para vencimiento de las retenciones de garant¡a.');
      AddLog('JAV',1,'   - Tanto la fecha de vencimiento como la de fin de garant¡a de la obra aparecen en rojo si est n fuera del plazo de aviso.');
      AddLog('JAV',1,'   - Al liquidar un movimiento de retenci¢n con factura, se genera una factura borrador por el importe.');
      AddLog('JAV',1,'   - Al registrar la factura de liquidaci¢n se marca el movimiento como liquidado.');
      AddLog('JAV',1,'   - Al liquidar un movimiento de retenci¢n de pago, se informa del n£mero del documento y efecto generado.');
      AddLog('JAV',1,'   - Nuevo informe "Retenciones de IRPF de Proveedores".');
      AddLog('   ',0,'Mejoras en Mediciones:');
      AddLog('JAV',1,'   - Al seleccionar proyecto si es multi cliente hay que informarlo, si no se asocia con el cliente del proyecto.');
      AddLog('JAV',1,'   - Solo se deja establecer un cliente de los asociados al proyecto.');
      AddLog('   ',0,'Mejoras en Relaciones de cobros:');
      AddLog('JAV',1,'   - Se crea una nueva pantalla de configuraci¢n.');
      AddLog('JAV',1,'   - Se cambia el manejo general del tipo "por certificaci¢n".');
      AddLog('   ',0,'Se optimiza el informe de Almac‚n para que salga mucho m s r pido.');
      AddLog('   ',0,'Se crea una nueva pantalla de configuraci¢n de relaciones de pagos.');
      AddLog('   ',0,'En la pantalla de salidas de almac‚n del proyecto:');
      AddLog('JAV',2,'   - Al cargar la pantalla no actualizaba el stock, informando del £ltimo cargado en lugar del actual.');
      AddLog('JAV',2,'   - Al informar cantidad actualizaba el stock, pero err¢neamente calculaba el remanente sobre el stock anterior.');
      AddLog('   ',0,'Otros arreglos:');
      AddLog('JAV',2,'   - Se mejora la presentaci¢n de errores en el proceso de cierre del mes.');
      AddLog('JAV',2,'   - Se mejora la presentaci¢n de errores en el proceso de c lculo del presupuesto anal¡tico.');
      AddLog('JAV',2,'   - Se arregla un error al pasar un estudio a proyecto con separaci¢n coste/venta.');
      AddLog('JAV',2,'   - Se arregla un error en el c lculo de la columna de medici¢n pendiente de la pantalla de costes directos.');
      AddLog('JAV',2,'   - Se arregla un error de filtros al llamar desde la ficha de la Unidad de Obra a sus descompuestos.');

      AddVer(mQB,'1.05',20200415D);
      AddLog('   ',0,'Mejoras en mediciones y certificaciones:');
      AddLog('JAV',1,'   - Se a¤aden hasta 4 decimales en campos de mediciones y hasta 6 en porcentajes, mostrando 2 por defecto.');
      AddLog('JAV',1,'   - Se mejora la pantalla de totales separando las totales del proyecto y los de las U.O. incluidas en las l¡neas.');
      AddLog('JAV',1,'   - En las pantallas de documentos registrados, se guarda el valor a origen en el momento de registro para mantener los datos correctos.');
      AddLog('JAV',1,'   - Se cambia el nombre del campo Importe Contrato para que refleje que es a origen.');
      AddLog('   ',0,'Enlace con MS-PROYECT, desde el presupuesto se permite exportar e importar.');
      AddLog('   ',0,'Nueva pantalla de asistente de configuraci¢n del almac‚n, dividida en varias zonas.');
      AddLog('JAV',1,'   - El panel de configuraci¢n general.');
      AddLog('JAV',1,'   - El panel de configuraci¢n de cuentas para los grupos de existencias por defecto, al cambiar un dato se replica en todos los almacenes.');
      AddLog('JAV',1,'   - Nuevo panel con la lista editable de almacenes y sus datos relacionados con QuoBuilding.');
      AddLog('   ',0,'Retenciones:');
      AddLog('JAV',1,'   - Al liberar la retenci¢n de pago usa la misma forma de pago de la factura original.');
      AddLog('JAV',2,'   - Se reordenan los botones y se a¤ade uno para navegar al movimiento de liberaci¢n.');
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se revisan las pilas para que se pueda navegar al pulsar una de aprobaciones.');
      AddLog('JAV',2,'   - Se arregla un error cuando un usuario aparece varias veces en el circuito.');
      AddLog('JAV',2,'   - Al finalizar el circuito no marcaba correctamente el estado aprobado.');
      AddLog('   ',0,'Agrupaciones de coste/venta:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de ver los datos desde el coste o desde la venta.');
      AddLog('JAV',1,'   - Se revisan las pantallas y sus campos para hacerlos acordes a verse desde coste o venta.');
      AddLog('JAV',1,'   - Se a¤ade el n£mero de unidades de venta sin asignar en la cabecera.');
      AddLog('   ',0,'Partes de trabajo:');
      AddLog('JAV',1,'   - Se unifican las pantallas por recursos y productos, revisando su funcionamiento y mejorando el panel lateral de estad¡stica.');
      AddLog('JAV',1,'   - Se a¤ade un nuevo tipo de parte Mixto, que permite usar varios proyectos y recursos en el mismo parte.');
      AddLog('JAV',1,'   - Se a¤ade para los mixtos la posibilidad de importar una hoja Excel con las horas del parte.');
      AddLog('   ',0,'Importaci¢n de Excel:');
      AddLog('JAV',1,'   - Se mejora la importaci¢n de Relaci¢n Valorada, Mediciones y Partes de horas.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de elegir si el c¢digo de unidad de obra de la Excel es el de Presto o el del Proyecto.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de indicar que columna ser  la que se lea para cada dato a importar.');
      AddLog('   ',0,'Se a¤aden en las pantallas de facturas y abonos de compra y venta ejercicio y periodo del SII en que se declarar  el documento.');
      AddLog('JAV',1,'   - Se mejora la impresi¢n de las facturas proforma, pueden ser a origen o del periodo, agrupadas por U.O. o sin agrupar.');
      AddLog('JAV',1,'   - Se posibilita anular cualquier albar n, no solo los FRI.');
      AddLog('JAV',1,'   - Se corrige la anulaci¢n para que genere mejor los asientos contables, que no lo hac¡a en todos los casos.');
      AddLog('   ',0,'Se mejora la carga de los BC3, si no se indica coste=venta no se vuelve a leer el de coste para cargar la venta.');
      AddLog('   ',0,'Retenciones de Buena Ejecuci¢n.');
      AddLog('JAV',1,'   - Al registrar desde un pedido de compra directamente la factura no se generaba la retenci¢n de Buena Ejecuci¢n correctamente.');
      AddLog('JAV',1,'   - Al registrar desde un pedido de compra la recepci¢n se inclu¡an err¢neamente l¡neas de retenci¢n de Buena Ejecuci¢n.');
      AddLog('JAV',1,'   - Al registrar desde un pedido de venta directamente la factura no se generaba la retenci¢n de Buena Ejecuci¢n correctamente.');
      AddLog('JAV',1,'   - Al registrar desde un pedido de venta el env¡o se inclu¡an err¢neamente l¡neas de retenci¢n de Buena Ejecuci¢n.');
      AddLog('   ',0,'Otros arreglos:');
      AddLog('JAV',2,'   - Se corrige un error al llamar a los certificados desde la ficha del proveedor.');
      AddLog('JAV',2,'   - Se corrige un error que hac¡a no editable el precio en facturas de compra.');
      AddLog('JAV',2,'   - Se corrige un error el generar el Confirming Est ndar.');
      AddLog('JAV',2,'   - Se corrige un error al calcular el stock en los albaranes de salida de almac‚n.');
      AddLog('JAV',2,'   - Se corrige c lculos no correctos en el informe de Gesti¢n de Obra.');
      AddLog('JAV',2,'   - Se corrige un error por el que no mostraba bien la descripci¢n de la obra en los hist¢ricos de facturas.');
      AddLog('JAV',2,'   - Se corrige un error atraer una certificaci¢n negativa a un abono de venta.');
      AddLog('JAV',2,'   - Se corrige un error por el que no anulaba el asiento de previsi¢n contable de los albaranes y FRI.');

      AddVer(mQB,'1.06.01',20200415D);
      AddLog('   ',0,'Mejoras en clientes y proveedores:');
      AddLog('JAV',1,'   - Se a¤ade una subcategor¡a en las fichas.');
      AddLog('JAV',1,'   - Se puede definir el nombre del campo para categor¡a y subcategor¡a .');
      AddLog('   ',0,'Mejoras en Estudios:');
      AddLog('JAV',1,'   - Se a¤ade el "% Baja media Competencia" en la ficha, y se mejora el apartado de Competencia con botones para pasar el calculado a la ficha".');
      AddLog('   ',0,'Mejoras en proyectos operativos:');
      AddLog('JAV',1,'   - Se a¤ade en el panel de "Duraci¢n y licitaci¢n" la "Fecha Acta Recepci¢n".');
      AddLog('   ',0,'Cambio en la opci¢n de Multi-cliente en los proyectos, ahora tiene tres posibles valores:');
      AddLog('JAV',1,'   1- No: El proyecto es para un solo cliente.');
      AddLog('JAV',1,'   2- Por clientes: En los presupuestos de venta, en cada uno de los expedientes se puede elegir el cliente al que facturar el expediente.');
      AddLog('JAV',1,'   3- Por porcentajes: Usando el bot¢n "Clientes" en el presupuesto de venta y en las certificaciones se configurar los clientes a los que facturar y su porcentaje".');
      AddLog('JAV',1,'   - Desde la certificaci¢n se a¤ade un bot¢n "Generar facturas", en el tipo 1 y 2 se genera una sola factura, en el tipo 3 se generan tantas como clientes configurados.');
      AddLog('JAV',1,'   - Tambi‚n a la certificaci¢n se a¤aden botones para "Ver facturas" que muestra las generadas y "Ver facturas registradas" cuando se registre.');
      AddLog('   ',0,'Nueva posibilidad de sincronizar datos entre empresas:');
      AddLog('JAV',1,'   - Se a¤ade en la configuraci¢n la opci¢n "Empresas Relacionadas", donde se indica que empresa es la m ster y cuales las sincronizadas.');
      AddLog('JAV',1,'   - Solo se pueden dar altas en la empresa marcada como m ster de clientes, proveedores, bancos, empleados y tablas relacionadas con estas.');
      AddLog('JAV',1,'   - En las empresas sincronizadas se puede elegir que campos se sincronizan y cu les no.');
      AddLog('   ',0,'Nueva posibilidad para generar anticipos a clientes:');
      AddLog('JAV',1,'   - Se a¤ade en la configuraci¢n de QuoBuilding la opci¢n "Grupo producto para prepagos", que se usa al generar las facturas de prepago.');
      AddLog('JAV',1,'   - Se a¤aden en la ficha de clientes, en la de proveedores (de momento sin uso) y en la de proyectos el importe de los anticipos generados.');
      AddLog('JAV',1,'   - En la ficha del proyecto, se a¤ade la posibilidad de ver y generar los anticipos a clientes.');
      AddLog('JAV',1,'   - Al crear una factura, si el cliente tiene un anticipo pregunta el importe que se desea liquidar del mismo.');
      AddLog('   ',0,'Mejoras en compras:');
      AddLog('JAV',1,'   - Si se activa, el sistema no permite mezclar en una factura albaranes con diferentes condiciones.');
      AddLog('JAV',1,'   - Se a¤aden la posibilidad de usar diferentes formas de calcular vencimientos seg£n fecha del documento o de recepci¢n.');
      AddLog('JAV',1,'   - Se a¤aden en la configuraci¢n de usuarios una columna para permitir al usuario marcar un check en la factura que permite mezclar albaranes.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de usar diferentes fases de pago en los documentos, al registrar se elije la fase que se desea utilizar.');
      AddLog('JAV',1,'   - En la ficha del proveedor se a¤ade la posibilidad de establecer la forma de c lculo del vto y la fase de pago por defecto a usar.');
      AddLog('JAV',1,'   - Al crear un comparativo, se posibilida elegir fases de pago en los proveedores, aparecen en el informe, y pasan al documento de compra generado.');
      AddLog('   ',0,'Otros arreglos:');
      AddLog('JAV',1,'   - Se mejora el formato del informe de Albaranes pendientes, no aparecen a cero o cancelados.');
      AddLog('JAV',2,'   - Al generar el confirming Est ndar, elimina los espacios por delante de los campos de texto.');

      AddVer(mQB,'1.06.02',20200415D);
      AddLog('   ',0,'Mejoras en compras:');
      AddLog('JAV',1,'   - Se filtran los documentos para que solo aparezcan los que el usuario tenga permisos por las obras que maneja.');
      AddLog('JAV',1,'   - Al desplegar la lista de proyectos solo aparecen los que tiene acceso el usuario, no aparecen los estudios aunque se puede quitar dicho filtro.');
      AddLog('JAV',1,'   - Se controla que no pueda introducir manualmente uno que no est‚ entre los asociados el usuario.');
      AddLog('   ',0,'Cartera:');
      AddLog('JAV',1,'   - Se a¤ade en todas las pantallas de remesas y ¢rdenes de pago el nombre del cliente o proveedor.');
      AddLog('JAV',1,'   - Se permite cambiar en las l¡neas de las ¢rdenes de pago la fecha de vencimiento y el banco del proveedor.');
      AddLog('   ',0,'SII Microsoft:');
      AddLog('JAV',1,'   - Se a¤ade una tabla de tipos de operaci¢n, donde se pueden dar de alta las que se desee.');
      AddLog('JAV',1,'   - Uno de los tipos se puede marcar para que salgo por defecto, si no se indica en el proveedor otro se usar  este tipo en los documentos.');
      AddLog('JAV',1,'   - En la ficha de los proveedores se a¤ade el campo para el tipo de operaci¢n que se usar  por defecto con este proveedor.');
      AddLog('JAV',1,'   - Se a¤ade en todas las pantallas de compra el cmpo de tipo de operaci¢n, se toma del proveedor. Con el valor de este campo se rellena el campo del SII.');
      AddLog('   ',0,'Otros arreglos:');
      AddLog('JAV',1,'   - Se a¤ade el formato espec¡fico de confirming de Bankinter.');

      AddVer(mQB,'1.06.03',20200415D);
      AddLog('   ',0,'Otros arreglos:');
      AddLog('JAV',1,'   - Cuando no est  activado el criterio de caja, las facturas con IVA diferido se remiten con la clave 01, en lugar de la 07.');
      AddLog('JAV',1,'   - Al importar un preciario se a¤ade la posibilidad de a¤adir un prefijo a las unidades importadas.');
      AddLog('JAV',1,'   - En los presupuestos de venta se a¤ade el bot¢n para ver las agrupaciones de costes, si el proyecto es por agrupaciones.');
      AddLog('JAV',2,'   - Se corrige un error en el c lculo del porcentaje  coste/venta en las agrupaciones de costes, no siempre lo ejecutaba correctamente.');

      AddVer(mQB,'1.06.04',20200415D);
      AddLog('   ',0,'Integraci¢n con mQSI:');
      AddLog('JAV',1,'   - Se a¤aden en las l¡neas de las facturas de venta los campos para tipo de inmueble y referencia catastral.');
      AddLog('JAV',2,'   - Se corrigen peque¤os errores con la integraci¢n con mQSI.');
      AddLog('   ',0,'Otros arreglos:');
      AddLog('JAV',1,'   - En la pantalla de aprobaciones y en la de documentos a pagar en cartera se a¤aden los documentos relacionados con la factura en el panel de documentos.');
      AddLog('JAV',1,'   - Se a¤ade el campo "C¢digo adicional" en varias pantallas de unidades de obra, es un c¢digo interno de la empresa de uso libre para esa unidad de obra.');
      AddLog('JAV',2,'   - Se corrige un error por el que no guardaba los importes de las diferencias de IVA informadas por el usuario en la estad¡stica de los documentos de compra.');

      AddVer(mQB,'1.06.05',20200415D);
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade un par metro en la configuraci¢n para que se lancen autom ticamente o no las aprobaciones de facturas a pagar.');
      AddLog('JAV',1,'Se mejora la recepci¢n de facturas:');
      AddLog('JAV',1,'   - Se mejora el control de facturas recibidas, se puede indicar sobre que importe se desea controlar el importe.');
      AddLog('JAV',1,'   - Se mejora el sistema de c lculo de la fecha de vencimiento, se puede configurar como est ndar o una de las fechas controladas.');
      AddLog('JAV',1,'   - Si se indica est ndar, no se hace ning£n cambio en los c lculos. Si se indica otra fecha, aparecen nuevos campos en las fichas para su control.');
      AddLog('JAV',1,'   - En los proveedores se puede indicar sobre qu‚ fecha se calculan sus vencimientos, si se indica est ndar es la configurada general.');
      AddLog('JAV',1,'   - En las facturas aparece el nuevo campo de sobre qu‚ fecha se desea efectuar el c lculo, adem s de un campo con la fecha base para el c lculo.');
      AddLog('   ',0,'Mejoras en las relaciones valoradas:');
      AddLog('JAV',1,'   - Se mejora la sincronizaci¢n entre las l¡neas de la Relaci¢n Valorada y las l¡neas de medici¢n relacionadas con estas.');
      AddLog('JAV',1,'   - Al proponer unidades de producci¢n, se salta las que ya est‚n incluidas en las l¡neas.');
      AddLog('JAV',2,'   - Se corrige un error por el que al buscar una unidad desde la l¡nea sacaba las de venta y no las de coste.');

      AddVer(mQB,'1.06.06',20200415D);
      AddLog('   ',0,'Obralia:');
      AddLog('JAV',1,'   - Se mejora el proceso de los sem foros, aparece en las pantallas la palabra verde, rojo o el error retornado.');
      AddLog('JAV',1,'   - Los valores adecuados seg£n respuesta para el sem foro verde o rojo se configuran en Compras y Pagos.');
      AddLog('JAV',1,'   - En la ficha de los proveedores se muestra un campo Verificar con Obralia, con tres valores que afectan a los pagos:');
      AddLog('JAV',1,'      - Si es posible: Validar el proveedor con Obralia, si no est  dado de alta contin£a normalmente, si lo est  mira el sem foro verde.');
      AddLog('JAV',1,'      - Obligatorio..: Solo se puede insertar el documento en la relaci¢n si el sem foro es verde.');
      AddLog('JAV',1,'      - Nunca........: No se intenta validar el proveedor con Obralia.');
      AddLog('JAV',1,'   - Se a¤ade en los documentos a pagar en cartera la posibilidad de llamar a Obralia para un documento o para varios.');
      AddLog('JAV',1,'   - Cuando se insertan documentos en una orden de pago se verifica que en ese momento tengan en verde el sem foro de Obralia.');
      AddLog('JAV',2,'   - Los registros de los hist¢ricos apuntaban mal a la tabla de obralia, aunque esto no daba ning£n problema.');

      AddVer(mQB,'1.06.07',20200415D);
      AddLog('   ',0,'Mejoras menores:');
      AddLog('JAV',1,'   - Se a¤ade en documentos de compra y de venta un nuevo campo editable con la fecha de vencimiento de la retenci¢n de buena ejecuci¢n.');
      AddLog('JAV',1,'   - Se a¤ade un nuevo informe de Certificaci¢n con m s opciones de configuraci¢n.');
      AddLog('JAV',1,'   - El informe "Almac‚n 1" se valora por precio medio, se a¤ade un nuevo informe "Almac‚n 2" que calcula por diferencia entre importes de entradas y salidas.');
      AddLog('JAV',1,'   - Se a¤ade un campo de texto largo en informaci¢n de empresa para la posible impresi¢n en documentos.');
      AddLog('JAV',2,'   - Al cambiar un dato en las l¡neas de los partes de trabajo no cambiaba bien las dimensiones de esa l¡nea.');

      AddVer(mQB,'1.06.08',20200415D);
      AddLog('   ',0,'Mejoras en las unidades de obra y la relaci¢n valorada al sobrepasar el 100% de medici¢n de producci¢n:');
      AddLog('JAV',1,'   - Se crean nuevos campos en el presupuesto de costes directos, para poder ver la medici¢n, el precio y el importe iniciales de la Unidad de Obra.');
      AddLog('JAV',1,'   - Si en la Valorada la producci¢n sobrepasa el 100%, da un mensaje de aviso y si se indica que es correcto:');
      AddLog('JAV',1,'     - Copia los datos actuales a los iniciales de la unidad de obra, si no ten¡an un valor anteriormente.');
      AddLog('JAV',1,'     - Aumenta la medici¢n actual con el valor indicado, de forma que ahora la medici¢n es el 100% ejecutado.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n en el presupuesto de costes directos para pasar el valor actual a estos campos, solo de los que no tengan uno informado.');
      AddLog('JAV',1,'   - Se elimina el campo para indicar si es a origen o del periodo, pues ya no se usaba para nada.');
      AddLog('JAV',1,'   - Se a¤ade un par metro en la importaci¢n de Excel en relaciones valoradas para que aumente autom ticamente sin preguntar cada vez.');
      AddLog('   ',0,'Mejoras en Estudios:');
      AddLog('JAV',1,'   - En las pantallas que muestran unidades de obra se ponen en negrita los datos de las unidades de mayor para diferenciarlas de las de trabajo.');
      AddLog('   ',0,'Mejoras en proyectos:');
      AddLog('JAV',1,'   - En las pantallas que muestran unidades de obra se ponen en negrita los datos de las unidades de mayor para diferenciarlas de las de trabajo.');
      AddLog('JAV',1,'   - El proceso de test de las unidades de obra marca como coste las que no tengan marcado coste ni venta.');
      AddLog('JAV',2,'   - Al dar de alta el estado interno desde un proyecto se creaban siempre para su uso en estudios y sin tomar bien el orden.');
      AddLog('   ',0,'Mejoras en productos y recursos:');
      AddLog('JAV',1,'   - Se a¤ade en la ficha el campo "Concepto Anal¡tico", adem s se hacen visibles otros campos de QuoBuilding.');
      AddLog('JAV',1,'   - Cuando se usa el producto o el recurso en un descompuestos se rellena autom ticamente la "Actividad" si la tiene informada en su ficha.');
      AddLog('JAV',1,'   - Cuando se usa el producto se rellena el "Concepto Anal¡tico" si lo tiene informado, si no lo saca del grupo contable de inventario del producto.');
      AddLog('JAV',1,'   - Cuando se usa el recurso se rellena el "Concepto Anal¡tico" si lo tiene informado, si no lo saca del registro de coste asociado al recurso.');
      AddLog('   ',0,'Mejoras en comparativos:');
      AddLog('JAV',1,'   - Se a¤aden campos para mostrar la evaluaci¢n del proveedor de la actividad y la media, al seleccionarlo o tras incluirlo.');
      AddLog('   ',0,'Mejoras menores:');
      AddLog('JAV',1,'   - Se a¤ade un par metro en configuraci¢n de Quobuiding para mostrar el campo "N§ de serie de registro" en las facturas venta, cuando se usan varias series.');
      AddLog('JAV',1,'   - En el aumento de precios de las unidades de venta se a¤ade la posibilidad de aumenta con una k m s un porcentaje de gastos, por defecto usa los indicados en el proyecto.');
      AddLog('JAV',1,'   - Se a¤ade un nuevo campo "C¢digo de empresa" en informaci¢n de empresa, se usar  en algunos informes £nicamente.');
      AddLog('JAV',1,'   - Se arregla la llamada al informe de albaranes pendientes de facturar desde la ficha de la obra.');
      AddLog('JAV',1,'   - Se arregla un error al usar el bot¢n de dimensiones de un pedido de compra.');

      AddVer(mQB,'1.06.09',20200415D);
      AddLog('   ',0,'Mejoras en preciarios:');
      AddLog('JAV',1,'   - Se unifican la pantalla de ficha de preciario y la de unidades de obra en la misma pantalla.');
      AddLog('JAV',1,'   - Se muestran en negrita los datos de las unidades de mayor para diferenciarlas de las de trabajo, y de otro color los datos de venta.');
      AddLog('JAV',1,'   - Se a¤ade la medici¢n de venta, que puede ser diferente a la de coste.');
      AddLog('JAV',1,'   - Se permite a¤adir descompuestos y mediciones para venta, si existen se calculan los precios de venta y la medici¢n de venta a partir de estos.');
      AddLog('JAV',1,'   - En la importaci¢n de los BC3 se pueden incluir descompuestos y mediciones de venta.');
      AddLog('JAV',1,'   - En la configuraci¢n de unidades de obra se a¤ade un campo para indicar si se marca este campo por defecto.');
      AddLog('   ',0,'Mejoras en estudios:');
      AddLog('JAV',2,'   - Se corrige un error por el que no guardaba siempre el c¢digo del proyecto generado.');
      AddLog('JAV',1,'   - Se a¤ade en la lista de versiones el acceso a los botones de presupuesto de coste, presupuesto de venta y los rec lculos.');
      AddLog('JAV',1,'   - En las pantallas que muestran unidades de obra en versiones se ponen en negrita los datos de las unidades de mayor para diferenciarlas de las de trabajo.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de usar descompuestos en las unidades de venta, diferentes a los de coste.');
      AddLog('JAV',1,'   - En la importaci¢n de preciarios se a¤ade un par metro para indicar si se desea importar descompuestos y mediciones de venta.');
      AddLog('JAV',1,'   - Cuando una partida de coste o de venta tiene descompuestos, el precio de venta aparece en gris y no es editable directamente, hay que modificar los descompuestos');
      AddLog('JAV',1,'   - Cuando una partida de coste o de venta tiene medici¢n detallada, la medici¢n aparece en gris y no es editable directamente, hay que modificarla por la detallada.');
      AddLog('JAV',1,'   - Al crear el proyecto, traspasa descompuesto y mediciones de venta si las tiene.');
      AddLog('   ',0,'Mejoras en proyectos:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de usar descompuestos en las unidades de venta, diferentes a los de coste, aunque la unidad sea de coste y de venta.');
      AddLog('JAV',1,'   - Cuando una partida de coste o de venta tiene descompuestos, el precio de venta aparece en gris y no es editable directamente, hay que modificar los descompuestos');
      AddLog('JAV',1,'   - Cuando una partida de coste o de venta tiene medici¢n detallada, la medici¢n aparece en gris y no es editable directamente, hay que modificarla por la detallada.');
      AddLog('JAV',1,'   - En la importaci¢n de preciarios se a¤ade un par metro para indicar si se desea importar descompuestos y mediciones de venta.');

      //TO-DO Descompuestos de venta, revisar las utilidades varias en los Estudios y Proyectos

      AddVer(mQB,'1.06.10',20200415D);
      AddLog('   ',0,'C¢digo adicional en unidades de obra:');
      AddLog('JAV',1,'   - Se a¤ade en todas las pantallas de proyectos y estudios en que aparece el c¢digo de presto el campo de c¢digo adicional.');
      AddLog('JAV',1,'   - Se a¤ade un par metro en configuraci¢n de QuoBuilding para usar o no ese campo, si no se usa no aparece en las pantallas.');
      AddLog('   ',0,'Partes de horas de trabajadores externos:');
      AddLog('JAV',1,'   - Se a¤ade en la posibilidad de registrar las horas usadas por trabajadores de las subcontratas en las partidas.');
      AddLog('JAV',1,'   - Se a¤ade un par metro en configuraci¢n de QuoBuilding sobre la manera que se desea imputar estos partes.');
      AddLog('JAV',1,'   - Al registrar esos partes de trabajo se carga el coste previsto en la partida, junto al movimiento de proyecto, y la posibilidad de un asiento de previsi¢n.');
      AddLog('JAV',1,'   - Al introducir el pedido del proveedor informa de si hay l¡neas de partes sin imputar, y se debe indicar contra que l¡neas de los partes se realizar .');
      AddLog('JAV',1,'   - Al registrar el pedido del proveedor, se deshace la imputaci¢n en la partida y la contable si se ha efectuado.');
      AddLog('JAV',1,'   - Se a¤ade un par metro en configuraci¢n de QuoBuilding sobre la manera que se desea imputar estos partes.');
      AddLog('   ',0,'Horas previstas y reales en las partidas:');
      AddLog('JAV',1,'   - Se a¤ade en la posibilidad de indicar las horas previstas de trabajo en la partida.');
      AddLog('JAV',1,'   - Se pueden indicar las horas reales autom ticamente  a partir de los partes de trabajo de los trabajadores, o indicarlas manualmente para los ajustes.');
      AddLog('JAV',1,'   - Se a¤aden columnas con las diferencias entre previsto y ejecutado, y el pendiente sobre lo previsto.');
      AddLog('JAV',1,'   - Se a¤ade en configuraci¢n de QuoBuilding si aparecen en las pantallas estas columnas, y si se desea incluir las horas de los trabajadores externos.');
      AddLog('   ',0,'Presupuesto inicial en obras:');
      AddLog('JAV',1,'   - Ya no es editable en la ficha del proyecto, ahora se marca desde los presupuestos de obra cual es, con una columna que lo indica.');
      AddLog('JAV',1,'   - En la ficha de unidades de coste directo las columnas de datos iniciales salen del presupuesto marcado como inicial.');
      AddLog('JAV',1,'   - En cualquier presupuesto de costes directos siempre hay referencia a los datos iniciales, remarcados en otro color.');
      AddLog('JAV',1,'   - En la ficha de los presupuestos de coste se a¤ade un bot¢n "Evoluci¢n de las U.O." donde se pueden ver los datos de todos los presupuestos.');
      AddLog('   ',0,'Relaciones valoradas:');
      AddLog('JAV',1,'   - Se a¤ade un campo con el porcentaje  de avance del coste (coste incurrido/coste total presupuesto)');

      AddVer(mQB,'1.06.11',20200415D);
      AddLog('   ',0,'Mejoras en Cash Flow:');
      AddLog('JAV',1,'   - Mejoras en Cash Flow para incluir m s  informaci¢n');

      AddVer(mQB,'1.06.12',20200415D);
      AddLog('   ',0,'Facturas de venta registradas:');
      AddLog('JAV',1,'   - Se incluyen en la pantalla los datos de las retenciones.');
      AddLog('JAV',1,'   - Se incluye la posibilidad de modificar la fecha de vencimiento de la retenci¢n o el banco de cobro.');
      AddLog('   ',0,'Contratos marco multiempresa:');
      AddLog('JAV',1,'   - Se incluye el desarrollo inicial de los contratos marco, todav¡a no operativo.');
      AddLog('   ',0,'Agrupaciones de coste:');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n ÊDistribuci¢n autom tica de porcentajesË para hacer una distribuci¢n autom tica cuando una partida de venta est  asignada a varias de coste.');
      AddLog('JAV',1,'   - El proceso calcula el porcentaje de certificaci¢n que le corresponde a cada partida de coste en funci¢n del peso del importe de coste de cada partida.');
      AddLog('JAV',2,'   - Se cambia el proceso de rec lculo de los presupuestos para que tome correctamente el precio de venta de las unidades de coste agrupadas.');
      AddLog('JAV',1,'   - Se mejoran levemente las pantallas de agrupaciones de coste.');
      AddLog('   ',0,'Segunda posibilidad de sincronizar datos entre empresas:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de sincronizar registros de clientes, proveedores, bancos y empleados, seleccionando en sus fichas hacia que empresas se deben sincronizar.');
      AddLog('JAV',1,'   - Se a¤ade en las fichas una tabla de empresas contra las que sincronizar, con posibilidad de sincronizar o actualizar datos en los registros.');
      AddLog('JAV',1,'   - Solo se pueden dar altas en la empresa marcada como m ster de clientes, proveedores, bancos y empleados.');
      AddLog('JAV',1,'   - Solo se pueden modificar desde la empresa m ster los campos que se indiquen de las fichas de clientes, proveedores, bancos y empleados.');
      AddLog('JAV',1,'   - En las empresas sincronizadas se a¤ade un campo con la fecha y hora en que se crearon o actualizaron desde la empresa m ster.');
      AddLog('   ',0,'Creaci¢n autom tica de valores de dimensi¢n:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de crear y asociar valores de dimensi¢n autom ticamente a las tablas de clientes, proveedores, proyectos, bancos y empleados.');
      AddLog('JAV',1,'   - Se configura que campos deben crear valores de dimensi¢n asociadas al registro, y al insertar o modificar el registro se crean o actualizan los valores de dimensi¢n.');
      AddLog('   ',0,'Nuevos asistentes de configuraci¢n:');
      AddLog('JAV',1,'   - Se a¤ade un asistente para la configuraci¢n de descripciones de campos.');
      AddLog('JAV',1,'   - Se a¤ade un asistente para la configuraci¢n de campos obligatorios en tablas.');
      AddLog('JAV',1,'   - Se a¤ade un asistente para la configuraci¢n de dimensiones autom ticas en registros.');
      AddLog('JAV',1,'   - Se a¤ade un asistente para la configuraci¢n de la sincronizaci¢n de tablas entre empresas.');
      AddLog('   ',0,'Mejoras menores:');
      AddLog('JAV',1,'   - Se arregla un error por el que no verificaba que las facturas de compra estuvieran aprobadas para poder registrarlas.');

      AddVer(mQB,'1.06.13',20200415D);
      AddLog('   ',0,'Importaci¢n / Exportaci¢n de Excel:');
      AddLog('JAV',1,'   - Se incluyen un nuevo men£ para la importaci¢n/exportaci¢n gen‚rica configurable de/hacia Excel, para cualquier tabla del sistema.');
      AddLog('JAV',1,'   - La importaci¢n/exportaci¢n permite substituir datos seg£n una tabla de equivalencias.');
      AddLog('JAV',1,'   - La importaci¢n se puede hacer agrupada por los criterios que se deseen, £til para importar diarios que no necesitan detalle, como los de n¢minas.');

      AddVer(mQB,'1.06.14',20200415D);
      AddLog('   ',0,'Nuevo asistente de configuraci¢n:');
      AddLog('JAV',1,'   - Se a¤ade un asistente para la configuraci¢n de usuarios, permite modificar los usuarios existentes o crear nuevos usuarios de dominio en Business Central.');
      AddLog('JAV',1,'   - El asistente permite asociar al usuario sus tipos, mail, Rol (entre los de QuoBuiding), empresas a las que puede acceder y datos de configuraci¢n.');
      AddLog('   ',0,'Mejoras menores:');
      AddLog('JAV',1,'   - Se ampl¡an con m s columnas de importes la lista de proyectos operativos.');
      AddLog('JAV',1,'   - Se corrige un error en los textos configurables en idiomas.');
      AddLog('JAV',1,'   - Se corrige un error en el c lculo del importe de la producci¢n aceptada del expediente.');

      AddVer(mQB,'1.06.15',20200415D);
      AddLog('   ',0,'Mejoras en relaciones valoradas con obras de medici¢n abierta:');
      AddLog('JAV',1,'   - Si se sobrepasa el 100% de la medici¢n, se aumentan tanto la medici¢n de coste como la de venta, recalculando la unidad de obra completamente.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n para igualar coste y venta en todas las partidas, solo para proyectos de medici¢n abierta.');
      AddLog('   ',0,'Unificaci¢n de la sincronizaci¢n de datos entre empresas:');
      AddLog('JAV',1,'   - Se unifican en una sola las dos opciones de sincronizaci¢n.');
      AddLog('JAV',1,'   - Se configura en cada empresa para las tablas sincronizables si se debe efectuar de manera autom tica, de manera manual o que no se sincronice.');
      AddLog('   ',0,'Nuevas acciones en proyectos operativos:');
      AddLog('JAV',1,'   - Nuevo bot¢n de acci¢n "Seguimiento por c¢digo de compras", que muestra por descompuesto de subcontrataci¢n los datos de seguimiento de subcontrataci¢n.');
      AddLog('JAV',1,'   - Nuevo informe que muestra la informaci¢n del An lisis de producci¢n con detalle de los descompuestos, mostrando coste previsto versus incurrido.');
      AddLog('   ',0,'Control de confirming multi-empresa:');
      AddLog('JAV',1,'   - Se a¤ade una opci¢n para configurar l¡neas de confirming con un importe m ximo, que luego se asocian a las cuentas de bancos desde la ficha del banco.');
      AddLog('JAV',1,'   - Una l¡nea pude tener asociadas l¡neas de confirming de varias empresas.');
      AddLog('JAV',1,'   - Se a¤ade un check en las ¢rdenes de pago para indicar que es de confirming y la l¡nea de cr‚dito relacionada.');
      AddLog('JAV',1,'   - Se avisa al a¤adir documentos a las ¢rdenes de pago de tipo confirming que no se sobrepase el l¡mite global, y no deja registrar una orden que lo sobrepase.');
      AddLog('JAV',1,'   - Se puede modificar el vencimiento de un documento registrado antes de su liquidaci¢n, se conserva la fecha original en otro campo.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - En la planificaci¢n de unidades de obra se muestran las partidas de producci¢n y no las de certificaci¢n.');
      AddLog('JAV',1,'   - Se arregla un error en la inicializaci¢n de la producci¢n para la separaci¢n coste/venta.');

      AddVer(mQB,'1.06.16',20200415D);
      AddLog('   ',0,'Control de existencias de consumibles:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de configurar productos asociados a un almac‚n como dep¢sito  de consumibles (papel, tinta, EPIS, etc).');
      AddLog('JAV',1,'   - En la compra los estos productos la entrada se efectua directamente al almac‚n configurado.');
      AddLog('JAV',1,'   - Las salidas se efect£an  por partes de salida de material.');
      AddLog('   ',0,'Control de factoring multi-empresa:');
      AddLog('JAV',1,'   - Se a¤ade una opci¢n para configurar l¡neas de factoring con un importe m ximo, que luego se asocian a las cuentas de bancos desde la ficha del banco.');
      AddLog('JAV',1,'   - Una l¡nea pude tener asociadas l¡neas de factoring de varias empresas.');
      AddLog('JAV',1,'   - Los factoring tienen control del importe m ximo asegurado a los clientes, multiempresa, se asocian los clientes usando su NIF.');
      AddLog('JAV',1,'   - Se avisa al a¤adir documentos a las remesas de cobro de tipo factoring que no se sobrepase el l¡mite global, y no deja registrar una orden que lo sobrepase.');
      AddLog('JAV',1,'   - Se avisa al a¤adir documentos a las remesas de cobro de tipo factoring que no se sobrepase el l¡mite del cliente, dejando el resto del importe como no cubierto.');
      AddLog('   ',0,'M¢dulo gen‚rico  de importaci¢n/exportaci¢n:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de importar y exportar ficheros en formato Excel, CSV o de texto plano.');
      AddLog('JAV',1,'   - Se puede configurar completamente la estructura del fichero a generar o leer.');
      AddLog('JAV',1,'   - La importaci¢n se puede realizar agrupada por varios criterios, y existen tablas de substituciones para realizar  reemplazos autom ticos.');

      AddVer(mQB,'1.06.17',20200415D);
      AddLog('   ',0,'Control de documentaci¢n en compras:');
      AddLog('JAV',1,'   - Se a¤ade una pantalla en la que aparecen facturas registradas sin pagar o no registradas, que permiten marcar si se ha revisado la documentaci¢n.');
      AddLog('JAV',1,'   - Desde esta pantalla se puede poner una factura en espera marc ndola con las iniciales del bloqueado, al estar en espera no se puede incluir en un pago.');
      AddLog('   ',0,'Facturaci¢n por Hitos:');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n de acci¢n para fijar los hitos de facturaci¢n de los proyectos.');
      AddLog('JAV',1,'   - Para cambiar el tipo de facturaci¢n, el sistema controla que existan hitos definidos para permitir o no el cambio.');

      AddVer(mQB,'1.06.18',20200415D);
      AddLog('   ',0,'Proyectos con separaci¢n Coste/Venta:');
      AddLog('JAV',1,'   - Se a¤ade un aviso antes de permitir el cambio, que ahora es irreversible.');
      AddLog('JAV',1,'   - Si se confirma y existen unidades marcadas como de coste y venta, el sistema crea una nueva unidad de venta anteponiendo una V al c¢digo y la asocia a la de coste.');
      AddLog('JAV',1,'   - Si fuera necesario se modificar¡a en las mediciones y certificaciones los c¢digos de las unidades de venta.');
      AddLog('JAV',2,'   - Se arregla un error por el que no mostraba correctamente en los expedientes de venta los importes de costes directos cuando trabajamos con separaci¢n.');
      AddLog('   ',0,'Importaci¢n de preciarios desde Excel:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de importar los presupuestos de coste+venta, o solo el de venta.');
      AddLog('JAV',1,'   - Se a¤ade un check para eliminar los datos existentes en el preciario, por defecto si se importa coste+venta se marca, si es solo de venta se desmarca.');
      AddLog('JAV',1,'   - Se a¤ade en la pantalla la configuraci¢n de los datos de la Excel que se van a importar');
      AddLog('   ',0,'Reestimaciones:');
      AddLog('JAV',1,'   - Se revisa el funcionamiento de las reestimaciones, que no funcionaban correctamente.');
      AddLog('JAV',1,'   - Al crear un nuevo presupuesto se debe asociar a una reestimaci¢n, seg£n sus fechas.');
      AddLog('JAV',1,'   - La reestimaci¢n se maneja como una dimensi¢n, y desde su lista de valores se crean usando un bot¢n de acci¢n.');
      AddLog('JAV',1,'   - El resultado de las reestimaciones se puede ver desde los presupuestos contables.');
      AddLog('   ',0,'Sincronizaci¢n de datos entre empresas:');
      AddLog('JAV',1,'   - Se permite marcar en la empresa m ster las tablas a sincronizar autom ticamente, se sincronizar n en todas las empresas sin necesidad de indicarlo expresamente.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n para resincronizar los datos marcados como autom ticos en todas las empresas, da altas y modificaciones de todos los registros.');
      AddLog('JAV',1,'   - Se a¤ade la sincronizaci¢n de Dimensiones y de Socios IC.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se muestra el nombre del cliente, proveedor o banco en el hist¢rico de movimientos contables.');
      AddLog('JAV',2,'   - Se arregla un error en la carga de preciarios desde Excel por el que repet¡a el proceso continuamente.');
      AddLog('JAV',2,'   - Se arregla un error por el que no calculaba correctamente si las Unidades de Obra eran planificables, y se a¤ade el campo visible en la ficha.');

      AddVer(mQB,'1.06.19',20200415D);
      AddLog('   ',0,'Relaciones de pagos:');
      AddLog('JAV',1,'   - Se a¤ade la opci¢n de generar ¢rdenes de pago agrupando facturas por proveedor y fecha de vencimiento.');
      AddLog('JAV',1,'   - Se modifican los formatos de generaci¢n de los ficheros de confirming para que desglose los efectos agrupados.');

      AddVer(mQB,'1.06.20',20200415D);
      AddLog('   ',0,'Vista previa de registro en pedidos de compra:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de hacer vista previa de los registros para los FRI/Albaranes, adem s de los de la factura.');
      AddLog('   ',0,'Provisionar albaranes al proveedor:');
      AddLog('JAV',1,'   - Se a¤ade en la configuraci¢n de QuoBuilding la posibilidad de crear movimientos de proveedor en la provisi¢n de albaranes pendientes de recibir factura.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de marcar en movimientos de proveedor el tipo "Albar n" en los diarios de contabilidad.');
      AddLog('JAV',1,'   - Se modifica el proceso de provisi¢n/desprovisi¢n de albaranes para usar movimientos de proveedor en lugar de cuenta.');
      AddLog('   ',0,'Ajustes de divisa:');
      AddLog('JAV',1,'   - Los movimientos de ajustes de divisa se cargan a una unidad de indirectos del proyecto.');
      AddLog('JAV',1,'   - Se a¤ade la generaci¢n de ajustes de divisa para albaranes de compra cuando el movimiento va contra el proveedor.');

      AddVer(mQB,'1.06.21',20200415D);
      AddLog('   ',0,'Activos Fijos:');
      AddLog('JAV',1,'   - Se a¤ade en la ficha del activo el proyecto y la Unidad de Obra en la que cargar el gasto, aunque los guarda en el libro de amortizaci¢n del Activo.');
      AddLog('JAV',1,'   - Se a¤ade en el diario de activos la Unidad de Obra en la que cargar el gasto.');
      AddLog('JAV',2,'   - No tomaba bien al generar la amortizaci¢n el proyecto y la Unidad de Obra en las l¡neas del gasto.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - En la lista de grupos de retenci¢n se a¤ade una columna para indicar la forma de pago que usar  para liberar la retenci¢n, en caso de que la del documento no genere cartera.');
      AddLog('JAV',1,'   - En las facturas de compra registradas se muestra el campo "Esperar" y se a¤ade a los que se pueden cambiar usando el bot¢n "Actualizar documento".');
      AddLog('JAV',1,'   - En el hist¢rico del SII se a¤ade una columna para ver el £ltimo estado del documento si se ha enviado m s de una vez.');
      AddLog('JAV',2,'   - Se limitan las descripciones al librar movimientos de retenci¢n de clientes para que no de error de desbordamiento.');

      AddVer(mQB,'1.07.00',20200415D);
      AddLog('   ',0,'Aprobaciones por departamentos:');
      AddLog('JAV',1,'   - Se a¤aden una configuraci¢n de los usuarios que trabajan en los departamentos, sus niveles e importes.');
      AddLog('JAV',1,'   - Se a¤ade la aprobaci¢n por departamentos de las Ordenes de Pago en los circuitos de aprobaci¢n.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Si no existen datos de configuraci¢n para "Presupuesto inicial" o "Expediente inicial" da un error y no deja crear el proyecto.');
      AddLog('JAV',2,'   - Se soluciona un error por el que al informar del cliente en el proyecto daba un mensaje de que no estaba actualizado el registro.');
      AddLog('JAV',2,'   - Se soluciona un error de longitud al entrar en las mediciones de coste o de venta.');

      AddVer(mQB,'1.07.01',20200415D);
      AddLog('   ',0,'Preciarios:');
      AddLog('JAV',1,'   - Se hace editable directamente la lista de unidades del preciario.');
      AddLog('JAV',2,'   - Se arregla un error al importar Excel al preciario que no marcaba los cap¡tulos como unidades de certificaci¢n.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Cuando se cambia el precio de un descompuesto, pregunta si desea cambiarlo en todos los que sean iguales en el proyecto.');
      AddLog('JAV',1,'   - Se cambia en los proyectos el nombre de "Albaranes de Salida" a "Albaranes de Almac‚n", ya que pueden ser tambi‚n de entrada.');
      AddLog('JAV',1,'   - Se trasladan los botones de generar Solicitudes de precios a proveedores de los comparativos a la ficha de condiciones de los proveedores.');
      AddLog('JAV',1,'   - Cambios menores en la gesti¢n de las divisas en varios puntos del programa.');
      AddLog('JAV',1,'   - Cambios menores en nombres e iconos de acciones algunas pantallas para ajustarlas mejor a pantallas peque¤as.');
      AddLog('JAV',2,'   - Arreglos menores en la gesti¢n de los partes de trabajadores externos.');
      AddLog('JAV',2,'   - Arreglo de un error en el c lculo del importe de venta en los preciarios.');

      AddVer(mQB,'1.07.02',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.07.03',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores en el registro de albaranes y facturas en divisas.');
      AddLog('JAV',2,'   - Arreglos menores en generaci¢n de pagos electr¢nicos.');

      AddVer(mQB,'1.07.04',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤aden los objetos para explotar el Power BI desde QuoBuilding.');
      AddLog('JAV',2,'   - Arreglos menores en formatos de pagos electr¢nicos.');

      AddVer(mQB,'1.07.05',20200415D);
      AddLog('   ',0,'Obra en curso:');
      AddLog('JAV',1,'   - Se crean de manera adicional movimientos de cliente en el c lculo de la obra en curso, aunque no afectan al saldo del mismo.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de marcar en movimientos de cliente el tipo "OEC" en los diarios de contabilidad.');
      AddLog('JAV',1,'   - Se modifica el proceso de registro de la obra en curso para usar movimientos de clente en lugar de cuenta.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se evita el mensaje de que ha cambiado precios al importar preciarios.');
      AddLog('JAV',1,'   - Se hacen no visibles campos del SII en facturas de compra y venta si no est  activado.');
      AddLog('JAV',2,'   - Se arregla un error por el que no se reten¡an las aprobaciones.');

      AddVer(mQB,'1.07.06',20200415D);
      AddLog('   ',0,'Proyectos operativos:');
      AddLog('JAV',1,'   - Se hace no visibles los campos de proyecto Matriz y Proyecto Hijo si no son de estos tipos.');
      AddLog('JAV',1,'   - Se reorganiza el panel de registro para que no cambien mucho las posiciones por los campos visibles o no seg£n los tipos de proyecto.');
      AddLog('   ',0,'Relaciones valoradas:');
      AddLog('JAV',1,'   - Se a¤ade una columna con la medici¢n inicial de la U.O., si se ampl¡a la medici¢n esta columna permanece con el valor inicial, pero cambia a rojo');
      AddLog('JAV',2,'   - Se arregla un error por el que el precio quedaba a cero y calculaba mal el importe del periodo.');
      AddLog('JAV',1,'   - Al importar la Excel en proyectos de medici¢n abierta pregunta solo una vez si se desean ampliar las mediciones.');
      AddLog('   ',0,'Preciarios:');
      AddLog('JAV',1,'   - Se han a¤adido opciones para exportar un preciario en XML e importarlo posteriormente en cualquier empresa, tanto de la base de datos como de bases de datos separadas.');
      AddLog('   ',0,'Albaranes de compra:');
      AddLog('JAV',1,'   - Se han a¤adido en las l¡neas columnas para precio e importe, y dos columnas m s para cantidad e importe a origen de la l¡nea.');
      AddLog('   ',0,'Relaciones de pago:');
      AddLog('JAV',1,'   - Se activa solo el bot¢n de registrar o el de crear orden de pago dependiendo del tipo de relaci¢n.');
      AddLog('JAV',1,'   - Se mejora el control de accesos a las pantallas relacionadas con las relaciones de pago.');
      AddLog('JAV',2,'   - Se soluciona un error en la generaci¢n de relaciones de pagos con la longitud del banco.');
      AddLog('JAV',2,'   - Se soluciona una incidencia en el registro de las relaciones que no sean del tipo orden de pago.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla un error por el que no informaba los importes del proyecto en divisas desde los apuntes que se hacen por diarios contables o amortizaciones.');

      AddVer(mQB,'1.07.07',20200415D);
      AddLog('   ',0,'Presupuestos de costes:');
      AddLog('JAV',1,'   - Se reorganizan los botones de la pantalla relacionados con c lculos.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n para calcular todos los presupuestos pendientes de c lculo.');
      AddLog('   ',0,'Preciarios:');
      AddLog('JAV',1,'   - Al importar un preciario desde Excel, si el campo es m s grande de lo permitido da un mensaje de recortar o cancelar.');
      AddLog('JAV',1,'   - Al importar un preciario desde Excel se emplean los m ximos decimales posibles en cantidades e importes para ajustar mejor los c lculos.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla un error con la longitud del campo "Actividad" en la ficha del producto.');

      AddVer(mQB,'1.07.08',20200415D);
      AddLog('   ',0,'Proyectos:');
      AddLog('JAV',1,'   - Se a¤ade un campo para poder calcular la producci¢n por periodos o a origen.');
      AddLog('JAV',1,'   - Se a¤ade en la configuraci¢n de QuoBuilding un campo para establecer el modo de c lculo de la producci¢n por defecto.');
      AddLog('JAV',1,'   - Se a¤ade en las pantallas de hist¢rico de abonos de compra y las facturas y abonos de venta los totales con retenciones.');
      AddLog('JAV',2,'   - Se arregla un error en los procesos de separaci¢n coste/venta de los Estudios que obligaba a tener presupuesto inicial.');

      AddVer(mQB,'1.07.09',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.07.10',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.07.11',20200415D);
      AddLog('   ',0,'Obra en curso:');
      AddLog('JAV',1,'   - Se a¤ade el manejo multi-divisa en la obra en curso.');

      AddVer(mQB,'1.07.12',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.07.13',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se cambian nombres de columnas y el panel de estad¡stica del presupuesto de venta.');
      AddLog('JAV',1,'   - En los comparativos se indica si un proveedor no ha presentado alg£n precio, tanto en pantalla como en la impresi¢n.');
      AddLog('JAV',1,'   - Se revisan nombres de campos en ingl‚s no definidos o incorrectos.');

      AddVer(mQB,'1.07.14',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se arreglan campos en el panel de la estad¡stica del proyecto en divisas.');
      AddLog('JAV',1,'   - Se arregla la selecci¢n del proyecto en la empresa UTE desde la p gina del proyecto.');
      AddLog('JAV',1,'   - Se revisan nombres de campos en ingl‚s no definidos o incorrectos.');
      AddLog('JAV',1,'   - Se revisan los signos de los importes en los registros del WIP.');

      AddVer(mQB,'1.07.15',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla un error en el asiento contable del WIP.');

      AddVer(mQB,'1.07.16',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de importar solo nuevos descompuestos al traer preciario al proyecto');
      AddLog('JAV',1,'   - Se renombran los campos del QuoSII para evitar conflictos con los de Business Central est ndar.');
      AddLog('JAV',2,'   - Se arregla un error en la liquidaci¢n de efectos.');

      AddVer(mQB,'1.07.17',20200415D);
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de indicar fechas de substituci¢n de un usuario en las aprobaciones, si se indican se reemplaza el usuario autom ticamente en esas fechas.');
      AddLog('JAV',1,'   - Se a¤ade un proceso para revisar los usuarios de aprobaci¢n por las substituciones autom ticas.');
      AddLog('   ',0,'Filtrado de documentos:');
      AddLog('JAV',1,'   - Se a¤ade en m s documentos el que se filtra que solo aparezcan los de proyectos asociados al usuario.');
      AddLog('JAV',1,'   - Se elimina el filtro por niveles pues no tiene sentido al disponer del filtro por proyectos.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla un error con las retenciones al copiar documentos o crear abonos correctivos.');
      AddLog('JAV',2,'   - Se arregla un error con las liquidaciones de efectos.');

      AddVer(mQB,'1.07.18',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Versi¢n solo para cambiar nombres de campos.');

      AddVer(mQB,'1.08.00',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla un error en el c lculo de importes de indirectos porcentuales.');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.01',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.02',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se eliminan botones no operativos en algunas pantallas.');

      AddVer(mQB,'1.08.03',20200415D);
      AddLog('   ',0,'Versi¢n intermedia.');

      AddVer(mQB,'1.08.04',20200415D);
      AddLog('   ',0,'Anticipos de proyectos:');
      AddLog('JAV',1,'   - Al crear uno nuevo no se registra autom ticamente, se presenta la pantalla para que el usuario lo pueda revisar, modificar y registrar.');
      AddLog('JAV',2,'   - Se arregla un error con los hist¢ricos de facturas y abonos para el B.I.');

      AddVer(mQB,'1.08.05',20200415D);
      AddLog('   ',0,'Formatos de confirming:');
      AddLog('JAV',1,'   - Se a¤ade el que se usar  en la cuenta del banco, si se informa no lo pregunta al generar el fichero electr¢nico.');

      AddVer(mQB,'1.08.06',20200415D);
      AddLog('   ',0,'Cartera de pagos:');
      AddLog('JAV',1,'   - Se a¤ade el filtro de proyectos a los tiene acceso el usuario para los documentos en cartera, de esta forma solo ver  los que sean de su proyecto.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla un error en la pantalla de mediciones con los filtros de proyecto.');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.07',20200415D);
      AddLog('   ',0,'Importaci¢n de preciarios desde venta:');
      AddLog('JAV',1,'   - Se soluciona un problema por el que no pon¡a el estado del expediente en las unidades de obra.');
      AddLog('   ',0,'Almac‚n:');
      AddLog('JAV',1,'   - Se cambia el nombre del campo "Coste medio por albar n" por el de "Almac‚n de obra" que es m s significativo.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.08',20200415D);
      AddLog('   ',0,'Comparativos de compras:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de indicar en el comparativo si crear  un nuevo contrato, o ampliar  uno existente.');
      AddLog('JAV',1,'   - Si se ampl¡a uno existente se guarda autom ticamente  que n£mero de ampliaci¢n del contrato se gener¢.');
      AddLog('JAV',1,'   - Si se ampl¡a uno existente, se debe indicar el n£mero del documento que se ampl¡a. Al generar se a¤aden l¡neas al documento de base');
      AddLog('JAV',1,'   - Si se elimina un documento desde el comparativo, solo elimina las l¡neas que se generaron de este comparativo.');
      AddLog('JAV',1,'   - Si se elimina el documento completo, se marcan los comparativos como no generados.');
      AddLog('JAV',1,'   - Cuando se ampl¡a o elimina un contrato, se a¤aden l¡neas nuevas al control de contratos.');
      AddLog('JAV',1,'   - No se puede ampliar la cantidad de las l¡neas del documento generado de un comparativo por encima de lo contratado.');
      AddLog('JAV',1,'   - Si se reduce la cantidad de una l¡nea que viene de un comparativo, se reduce la cantidad en el propio comparativo, por lo que puede volver a entrar en las solicitudes de compra.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.09',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.10',20200415D);
      AddLog('   ',0,'Configuraci¢n general:');
      AddLog('JAV',1,'   - Se unifican los par metros de configuraci¢n en la tabla de Configuraci¢n de QuoBuilding.');
      AddLog('   ',0,'Asistentes de configuraci¢n de aprobaciones:');
      AddLog('JAV',1,'   - En la de proyectos se realizan peque¤os arreglos y cambios menores.');
      AddLog('JAV',1,'   - En la de proyectos se a¤aden tres botones para ver uno o los dos paneles inferiores.');
      AddLog('JAV',1,'   - En la de proyectos se elimina el manejo de departamentos.');
      AddLog('JAV',1,'   - En la de departamentos se a¤ade su activaci¢n, junto a peque¤os arreglos y cambios menores.');
      AddLog('   ',0,'Sincronizaci¢n entre empresas:');
      AddLog('JAV',1,'   - Se a¤ade una columna para ver si la empresa es de QuoBuilding.');
      AddLog('JAV',1,'   - Se a¤ade una columna para sincronizar la configuraci¢n desde la m ster, pudiendo solo crear nuevos registros o crear nuevos y modificar los existentes.');
      AddLog('JAV',1,'   - Se a¤ade una nueva entrada de men£ "Asistente lista tablas de Configuraci¢n", con la definici¢n de las tablas a sincronizar y sus campos.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.11',20200415D);
      AddLog('   ',0,'Configuraci¢n general:');
      AddLog('JAV',1,'   - Se unifican m s par metros de configuraci¢n en la tabla de Configuraci¢n de QuoBuilding.');
      AddLog('   ',0,'Asistentes de configuraci¢n de empresa:');
      AddLog('JAV',1,'   - Se a¤ade un asistente para configurar autom ticamente la empresa, en la Configuraci¢n de QuoBuilding y en la de sincronizaci¢n de empresas.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se cambian algunos nombres en el diario de la Obra en Curso.');

      AddVer(mQB,'1.08.12',20200415D);
      AddLog('   ',0,'Presupuesto de costes del proyecto:');
      AddLog('JAV',1,'   - Se filtran correctamente los importes del gasto incurrido por la fecha del presupuesto.');
      AddLog('   ',0,'Presupuestos anal¡ticos:');
      AddLog('JAV',1,'   - Cuando el proyecto no tiene definido un presupuesto, lo informa para poder recalcular correctamente el presupuesto anal¡tico.');
      AddLog('JAV',1,'   - Se hacen navegables los importes de coste y venta anal¡ticos del FactBox "Estad.Proy.General" en la lista y ficha de los proyectos.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se ajustan datos en la creaci¢n de la configuraci¢n autom tica.');

      AddVer(mQB,'1.08.13',20200415D);
      AddLog('   ',0,'Arreglos menores:');
      AddLog('JAV',2,'   - No calculaba correctamente el importe del periodo en la Relaci¢n Valorada cuando no cambiaba la medici¢n, pero si el precio.');
      AddLog('JAV',2,'   - Se arregla un error por el que al crear una factura de venta no buscaba si exist¡a un anticipo del cliente para el proyecto.');
      AddLog('JAV',1,'   - Se ajustan datos en la creaci¢n de la configuraci¢n autom tica.');

      AddVer(mQB,'1.08.14',20200415D);
      AddLog('   ',0,'Mediciones/Certificaciones:');
      AddLog('JAV',1,'   - Se cambia el sistema, se presentan ahora siempre los importes del periodo y a origen, tanto a PEM como a PEC.');
      AddLog('JAV',1,'   - Se cambian las estad¡sticas de las pantallas para que presenten los importes a origen, del periodo, actual, GG/BI/Baja y del documento.');
      AddLog('JAV',1,'   - Al crear una medici¢n se a¤ade un bot¢n para incluir las l¡neas anteriormente medidas para no tener problemas con el dato a origen.');
      AddLog('JAV',1,'   - Al registrar la medici¢n se a¤aden las l¡neas medidas anteriormente para evitar problemas con el importe a origen.');
      AddLog('JAV',1,'   - Se hace los mismo con las certificaciones.');
      AddLog('JAV',1,'   - Al traer una medici¢n a una certificaci¢n solo se pueden elegir mediciones completas, para evitar problemas con el importe a origen.');
      AddLog('JAV',1,'   - Al facturar una certificaci¢n se muestran todos los importes a origen, anterior, actual, GG/BI/Baja y total del documento en la factura.');

      AddVer(mQB,'1.08.15',20200415D);
      AddLog('   ',0,'Relaciones de cobros y pagos:');
      AddLog('JAV',1,'   - Se independiza la configuraci¢n de estos m¢dulos.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se mejora la toma del concepto anal¡tico en la importaci¢n.');
      AddLog('JAV',2,'   - Se arregla un c lculo en la pantalla de los presupuestos de coste.');

      AddVer(mQB,'1.08.16',20200415D);
      AddLog('   ',0,'Certificaciones registradas:');
      AddLog('JAV',1,'   - Se a¤ade un check en la configuraci¢n de usuarios para indicar que pueden marcar las certificaciones como facturadas.');
      AddLog('JAV',1,'   - Se a¤ade un nuevo bot¢n en la pantalla de ficha de las certificaciones registradas para marcar o desmarcar como facturado.');
      AddLog('JAV',1,'   - Esta acci¢n es peligrosa, se debe efectuar bajo la responsabilidad del usuario que lo haga.');
      AddLog('   ',0,'Arreglos menores:');
      AddLog('JAV',1,'   - En la importaci¢n Excel de los preciarios se permite modificar las columnas que intervienen en la importaci¢n.');
      AddLog('JAV',1,'   - Se hace no editable el importe de producci¢n en la pantalla de descompuestos de las unidades de obra, siempre es la suma de los descompuestos.');
      AddLog('JAV',2,'   - Se arregla un error por el que no descontaba correctamente el importe de las l¡neas de descompuestos eliminadas en algunas ocasiones.');

      AddVer(mQB,'1.08.17',20200415D);
      AddLog('   ',0,'SII de Microsoft:');
      AddLog('JAV',1,'   - Se ajustan a la £ltima CU con las novedades.');

      AddVer(mQB,'1.08.18',20200415D);
      AddLog('   ',0,'Contratos Marco:');
      AddLog('JAV',1,'   - Se revisa el desarrollo del m¢dulo de contratos marco.');
      AddLog('   ',0,'Empresas no QuoBuilding:');
      AddLog('JAV',1,'   - Se revisan problemas de acceso a las pantallas cuando la empresa no era de QuoBuilding.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Arreglos menores.');

      AddVer(mQB,'1.08.19',20200415D);
      AddLog('   ',0,'Anticipos de Proveedores:');
      AddLog('JAV',1,'   - Se completa el desarrollo del m¢dulo de anticipos, a¤adiendo a los de clientes los de proveedores.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglo de un error en la pantalla de mediciones, contaba todas en lugar de solo las del presupuesto actual.');

      AddVer(mQB,'1.08.20',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla de un error en el c lculo del presupuesto de las versiones del estudio.');

      AddVer(mQB,'1.08.21',20200415D);
      AddLog('   ',0,'Unidades de obras:');
      AddLog('JAV',2,'   - Se arregla de un error al indicar las dimensiones de las unidades de obra.');
      AddLog('JAV',1,'   - Se toman correctamente las dimensiones asociadas a la unidad de obra en las l¡neas de los documentos de compra.');
      AddLog('JAV',1,'   - Se toman correctamente las dimensiones asociadas a la unidad de obra en las l¡neas de los diarios contables.');
      AddLog('   ',0,'Proyectos operativos:');
      AddLog('JAV',1,'   - Se a¤ade en la ficha un bot¢n para ver el presupuesto por C.A. del proyecto.');
      AddLog('   ',0,'Versiones de estudios:');
      AddLog('JAV',1,'   - Se a¤ade en la ficha un bot¢n para ver el presupuesto por C.A. de la versi¢n.');
      AddLog('JAV',2,'   - Se arregla de un error cuando no estaba definida la dimensi¢n para C.A. al crear una versi¢n de un estudio.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se cambian palabras mal escritas en varias pantallas (como ejemplo pon¡a identaci¢n en lugar de indentaci¢n).');
      AddLog('JAV',1,'   - Se modifica la forma de generar la impresi¢n de los comparativos de ofertas para simplificar la impresi¢n, de cara a futuros cambios.');
      AddLog('JAV',2,'   - Se arregla un error al crear un nuevo recurso con las plantillas de configuraci¢n.');

      AddVer(mQB,'1.08.22',20200415D);
      AddLog('   ',0,'Mediciones/Certificaciones:');
      AddLog('JAV',2,'   - Se arregla un error con los importes de mediciones y certificaciones registradas, no guardaba bien algunos importes.');
      AddLog('   ',0,'Anticipos de proveedores:');
      AddLog('JAV',2,'   - Se arregla un error en el m¢dulo de proveedores.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla un error en la pantalla de datos del contrato en la ficha del pedido de compra.');

      AddVer(mQB,'1.08.23',20200415D);
      AddLog('   ',0,'Contratos Marco:');
      AddLog('JAV',1,'   - Se completa el desarrollo del m¢dulo de contratos marco multi-empresa.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arreglan textos mal escritos en algunas pantallas.');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.24',20200415D);
      AddLog('   ',0,'Mediciones/Certificaciones:');
      AddLog('JAV',1,'   - Se revisa nuevamente el m¢dulo de mediciones y certificaciones.');
      AddLog('JAV',1,'   - En las certificaciones se muestran datos a origen y del periodo en todas las l¡neas.');
      AddLog('JAV',2,'   - Se arregla un error con los importes de mediciones y certificaciones registradas y se a¤aden campos en las pantallas.');

      AddVer(mQB,'1.08.25',20200415D);
      AddLog('   ',0,'M¢dulo de impresi¢n de contratos de compra:');
      AddLog('JAV',2,'   - Se ampl¡an los campos disponibles para la impresi¢n de los contratos de compra.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla un error en el m¢dulo de existencias.');
      AddLog('JAV',2,'   - Se arreglan textos mal escritos en algunas pantallas.');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.26',20200415D);
      AddLog('   ',0,'Versi¢n para compatibilizar con QuoFacturae 1.3g');

      AddVer(mQB,'1.08.27',20200415D);
      AddLog('   ',0,'Relaci¢n Valorada:');
      AddLog('JAV',1,'   - Cuando hay separaci¢n coste/venta el valor del precio de venta calculado se calcula como la producci¢n total dividido entre la medici¢n total.');
      AddLog('   ',0,'Mediciones/Certificaciones:');
      AddLog('JAV',1,'   - Se eliminan sumas de l¡neas que son redundantes con la pantalla de totales la zona derecha.');
      AddLog('JAV',1,'   - Se cambian algunos textos para que sean m s intuitivos.');
      AddLog('JAV',2,'   - Se corrige un error en la anulaci¢n de certificaciones.');
      AddLog('JAV',2,'   - Se corrige un error que permit¡a traer mediciones anuladas a una certificaci¢n.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arreglan errores al lanzar procesos desde botones de un pedido de compra.');
      AddLog('JAV',2,'   - Se a¤ade un par metro en configuraci¢n de QuoBuilding para decidir si tras calcular el presupuesto anal¡tico se deben recalcular las vistas de an lisis.');

      AddVer(mQB,'1.08.28',20200415D);
      AddLog('   ',0,'Mediciones/Certificaciones:');
      AddLog('JAV',1,'   - Se marcan en rojo las l¡neas con diferencias de precios en las mediciones que se est n introduciendo.');

      AddVer(mQB,'1.08.29',20200415D);
      AddLog('   ',0,'Versi¢n para compatibilizar con QuoFacturae 1.3h');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se hacen no visibles campos del SII est ndar cuando no est  habilitado.');
      AddLog('JAV',1,'   - Se ampl¡an campos en la impresi¢n de contratos.');

      AddVer(mQB,'1.08.30',20200415D);
      AddLog('   ',0,'Mediciones/Certificaciones:');
      AddLog('JAV',1,'   - Se permiten mediciones de ajuste de precios, en los que el precio PEM es editable.');
      AddLog('JAV',1,'   - Peque¤os ajustes en el m¢dulo de medici¢n y certificaci¢n.');

      AddVer(mQB,'1.08.31',20200415D);
      AddLog('   ',0,'Mediciones/Certificaciones:');
      AddLog('JAV',1,'   - Mejoras en la carga desde Excel de las mediciones, sacando al final un resumen de las acciones que pueden ser problem ticas.');
      AddLog('JAV',1,'   - Se marcan en colores cuando hay medici¢n negativa en el periodo y cuando hay exceso de medici¢n a origen.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se cambia un campo err¢neo en la tabla de proyectos para la unidad de almac‚n, que estaba duplicado.');
      AddLog('JAV',1,'   - Cambios de textos err¢neos en algunas tablas.');

      AddVer(mQB,'1.08.32',20200415D);
      AddLog('   ',0,'Valores de dimensi¢n:');
      AddLog('JAV',1,'   - Se hacen visibles o no columnas en las listas de valores de dimensi¢n en funci¢n de si es la dimensi¢n para Departamento, C.A. o Reestimaci¢n.');
      AddLog('   ',0,'Anulaci¢n de Albaranes y FRIs:');
      AddLog('JAV',1,'   - Se revisa por completo el proceso de anulaci¢n, mejorando las llamadas a procesos est ndar.');
      AddLog('JAV',1,'   - Se permite la cancelaci¢n de una sola l¡nea del documento, llamando al bot¢n de la zona de l¡neas "Acciones - Deshacer recepci¢n".');
      AddLog('JAV',2,'   - Se corrige un error por el que al cancelar un albar n que haya entrado en el almac‚n de la obra no se sacaba de este la cantidad anulada.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se corrige un error por el que pod¡an crearse movimientos de IVA sin importe al registrar albaranes.');

      AddVer(mQB,'1.08.33',20200415D);
      AddLog('   ',0,'Listas de proyectos:');
      AddLog('JAV',1,'   - Se eliminan los paneles laterales que ralentizaban mucho la lista si existen bastantes proyectos.');

      AddVer(mQB,'1.08.34',20200415D);
      AddLog('   ',0,'Anulaci¢n de Albaranes y FRIs:');
      AddLog('JAV',1,'   - Se permite la cancelaci¢n de l¡neas en negativo.');

      AddVer(mQB,'1.08.35',20200415D);
      AddLog('   ',0,'Anulaci¢n de Albaranes y FRIs:');
      AddLog('JAV',2,'   - Se corrige un error por el que solo cancelaba la primera l¡nea del documento.');
      AddLog('   ',0,'Impresi¢n externa de documentos:');
      AddLog('JAV',1,'   - Se prepara el sistema para la impresi¢n de documentos usando WebServices externos a QuoBuilding.');

      AddVer(mQB,'1.08.36',20200415D);
      AddLog('   ',0,'Anulaci¢n de Albaranes y FRIs:');
      AddLog('JAV',2,'   - Versi¢n solo para marcar correctamente los albaranes anulados.');

      AddVer(mQB,'1.08.37',20200415D);
      AddLog('   ',0,'Mediciones/Certificaciones:');
      AddLog('JAV',1,'   - Se revisa la medici¢n por l¡neas detalladas para solucionar una incidencia que no cambiaba los datos correctamente.');
      AddLog('JAV',1,'   - Se permiten 4 decimales en las cantidades del periodo y a origen.');

      AddVer(mQB,'1.08.38',20200415D);
      AddLog('   ',0,'Facturas de venta registradas:');
      AddLog('JAV',2,'   - Se arregla un error por el que no guardaba el banco de cobro en la factura registrada.');
      AddLog('JAV',1,'   - Se arregla un error al modificar datos usando "Actualizar documento", no guardaba la descripci¢n del trabajo si se hab¡a modificado cualquier otro campo.');
      AddLog('   ',0,'Medici¢n/Certificaci¢n:');
      AddLog('JAV',1,'   - Se a¤ade la fecha de env¡o al cliente del documento, por defecto ser  la fecha de la medici¢n/certificaci¢n');
      AddLog('JAV',1,'   - Se a¤aden datos en la Query para el Power BI.');
      AddLog('JAV',1,'   - Se a¤aden datos en los Web Services de impresi¢n de Mediciones.');
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de aprobar abonos de compra sin registrar.');
      AddLog('   ',0,'Confirming:');
      AddLog('JAV',1,'   - Se a¤aden nuevos formatos de bancos a los confirming (gentileza de Ivan Archilla).');

      AddVer(mQB,'1.08.39',20200415D);
      AddLog('   ',0,'Facturaci¢n de certificaciones:');
      AddLog('JAV',1,'   - Se ampl¡a para que se puedan generar como cuenta, producto o recurso las facturas de venta asociadas, se indica en el grupo registro de proyecto.');
      AddLog('JAV',2,'   - Se corrige un error por el que no tomaba el grupo de IVA del proyecto al crear la factura de certificaci¢n.');
      AddLog('   ',0,'Comparativos de ofertas:');
      AddLog('JAV',2,'   - Se cambian los nombres y ubicaci¢n de los campos de descripci¢n en las l¡neas del comparativo para que sean m s adecuados.');
      AddLog('   ',0,'Valores de dimensi¢n:');
      AddLog('JAV',2,'   - Se a¤ade un bot¢n para indentar los valores seg£n la longitud del c¢digo, y otro para cancelar la indentaci¢n.');

      AddVer(mQB,'1.08.40',20200415D);
      AddLog('   ',0,'Objetivos:');
      AddLog('JAV',1,'   - Se reemplaza la ficha APM por la ficha de objetivos, con la misma idea general, funcionando para cada presupuesto de forma independiente.');
      AddLog('JAV',1,'   - Se recalculan los importes aprobados e incurridos cada vez que se entre en la p gina. Si se borra la ficha al entrar se vuelve a calcular.');
      AddLog('JAV',1,'   - Se inserta como objetivos de ingresos la lista de expedientes cargados, y como objetivos de coste el total de directos y de indirectos.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de indicar Unidades de Obra en los objetivos, pero se suman de manera independiente a los asociados e Expedientes y Gastos.');
      AddLog('JAV',1,'   - Se debe indicar la probabilidad de conseguir el objetivo en cada l¡nea, esto calcula a partir de porcentajes informados en "Conf. unidades de Obra" el importe a considerar.');
      AddLog('JAV',1,'   - Se a¤aden comentarios a las l¡neas y a un nuevo bot¢n, ambos son el mismo comentario.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de indicar en cada l¡nea importes por fechas previstas junto a su probabilidad, sum ndose su importe total en la l¡nea.');
      AddLog('   ',0,'Pantalla inicial del jefe de obra:');
      AddLog('JAV',1,'   - Se a¤aden las aprobaciones pendientes de cartera en la pantalla de entrada.');
      AddLog('   ',0,'Pantallas de hist¢ricos de facturas y abonos de compra y de venta:');
      AddLog('JAV',1,'   - Se hacen no visibles campos del SII est ndar y del QuoSII si no est n activados.');
      AddLog('   ',0,'FactBox de estad¡stica general del proyecto:');
      AddLog('JAV',1,'   - Se a¤ade el estado de c lculo del presupuesto para indicar si los datos que se muestran est n actualizados.');

      AddVer(mQB,'1.08.41',20200415D);
      AddLog('   ',0,'Comparativos de ofertas:');
      AddLog('JAV',1,'   - Se a¤aden campos para poder disponer de varias versiones de precios de los proveedores en los comparativos, cada una con la fecha en que nos la ha dado.');
      AddLog('JAV',2,'   - Se corrige un bug por el que al eliminar el contrato generado no se eliminaba del descompuesto el proveedor seleccionado y el precio del contrato.');
      AddLog('   ',0,'Proformas:');
      AddLog('JAV',1,'   - Se crea una nueva entidad "Proformas", para registrar las que se van a emitir al proveedor de manera independiente a los albaranes/FRI.');
      AddLog('JAV',1,'   - Se a¤ade en las l¡neas de pedido/contrato la columna de si se puede generar proforma de la l¡nea, y de la cantidad de la proforma.');
      AddLog('JAV',1,'   - Se a¤ade en la cabecera del pedido/contrato un porcentaje de proforma autom tico, si se indica se informa ese porcentaje sobre la cantidad a recibir en el campo de cantidad de la proforma.');
      AddLog('JAV',1,'   - Se a¤ade en la cabecera del pedido/contrato el bot¢n de registrar la proforma, y otro para ver las proformas generadas desde el documento.');
      AddLog('JAV',1,'   - Al registrar las facturas de compra desde el pedido/contrato o desde el Albar n/FRI, se pasa la cantidad facturada a las proformas autom ticamente.');
      AddLog('JAV',1,'   - Se permiten descuentos solo aplicables en las proformas, se establecen en la ficha de la forma de pago.');
      AddLog('JAV',1,'   - Se permite a¤adir y eliminar l¡neas recurrentes a las proformas.');
      AddLog('JAV',1,'   - Se a¤aden las proformas a los documentos en los proyectos, y se permite crear proformas de cero eligiendo el pedido/contrato de origen de la proforma.');
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade un nuevo FactBox con m s detalles del documento a aprobar, ampliando datos de Comparativos y de Cartera.');
      AddLog('JAV',2,'   - Se corrige un error por el que no filtraba correctamente los documentos pendientes.');
      AddLog('   ',0,'Obra en curso:');
      AddLog('JAV',1,'   - Se mejora la pantalla del diario, presentando tanto el valor a origen como el valor del periodo de la obra en curso.');
      AddLog('JAV',2,'   - Se corrige un error en el registro de la obra en curso por el que el importe no era el correcto en el momento del registro.');
      AddLog('   ',0,'Facturaci¢n de certificaciones:');
      AddLog('JAV',1,'   - Se corrige un error en la pantalla del grupo registro de producto por el que permit¡a seleccionar facturaci¢n seg£n el est ndar, obligando a usar siempre por cuenta.');
      AddLog('JAV',2,'   - Se corrige un error al crear las facturas desde la certificaci¢n asociando el grupo registro de IVA del proyecto al grupo de negocio en lugar de al grupo de producto.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se arregla un error tras registrar un abono de venta sobre un campo que no existe.');
      AddLog('JAV',2,'   - Se arregla un error que no permit¡a eliminar Unidades de Obra si exist¡an presupuestos cerrados en el proyecto.');
      AddLog('JAV',2,'   - Se arregla un error por el que no calculaba los importes de retenci¢n al cambiar el tipo de retenci¢n en los documentos de compra o de venta.');

      AddVer(mQB,'1.08.42',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade una lista de l¡neas de partes de trabajo registrados para poder obtener todos y filtrar adecuadamente.');
      AddLog('JAV',2,'   - Al cancelar una relaci¢n valorada el sistema calculaba mal algunas veces el importe del periodo.');
      AddLog('JAV',2,'   - Se arregla un error por el que tomaba el almac‚n asociado al proveedor en los pedidos de QuoBuilding en lugar de dejarlo en blanco.');
      AddLog('JAV',2,'   - Se corrige un error al registrar abonos de venta "campo no existe".');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.43',20200415D);
      AddLog('   ',0,'SII est ndar de Microsoft:');
      AddLog('JAV',1,'   - Se actualiza al £ltimo upgrade de Microsoft con fecha de abril de 2021.');
      AddLog('   ',0,'Proformas:');
      AddLog('JAV',1,'   - Se mejora la configuraci¢n general a¤adiendo m s par metros.');
      AddLog('JAV',1,'   - Se mejora la impresi¢n de las proformas.');
      AddLog('JAV',2,'   - Peque¤os arreglos y mejoras.');
      AddLog('   ',0,'Compras:');
      AddLog('JAV',1,'   - Se a¤ade en la pantalla de pedidos/contratos de compra el importe de la base imponible del albar n, de la proforma y de la factura a generar.');
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Se prepara la gesti¢n de anticipos de proyectos generando directamente efecto, sin factura previa.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade en la lista de albaranes a incluir en la factura la fecha de registro y el N.§ de albar n del proveedor.');
      AddLog('JAV',1,'   - Se a¤ade una lista de l¡neas de partes de trabajo de trabajadores externos registrados para poder obtener todos y filtrar adecuadamente.');
      AddLog('JAV',2,'   - Se corrige un error en la cancelaci¢n de las relaciones valoradas, no respetaba el importe de la original cancelada.');
      AddLog('JAV',2,'   - Se corrige un error en la exportaci¢n de datos a B.I.');

      AddVer(mQB,'1.08.44',20200415D);
      AddLog('   ',0,'Proformas:');
      AddLog('JAV',1,'   - Se mejora el c lculo de la cantidad a origen de la proforma, y se ajusta levemente algunas pantallas.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Arreglos menores.');

      AddVer(mQB,'1.08.45',20200415D);
      AddLog('   ',0,'Proformas:');
      AddLog('JAV',1,'   - Se mejora el c lculo de la cantidad a origen de la proforma para que sea siempre correcto.');
      AddLog('JAV',1,'   - Se mejora la impresi¢n, permite ver o no l¡neas recurrentes y se corrigen problemas.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade la unidad de medida en todas las l¡neas de documentos de medici¢n y certificaci¢n.');
      AddLog('JAV',1,'   - Se a¤aden nuevos Web Services para Power BI.');
      AddLog('JAV',1,'   - Se a¤aden nuevos registros para la impresi¢n por Web Services en el selector de informes para QuoBuilding.');
      AddLog('JAV',2,'   - Se soluciona un error en el filtro de certificaciones al abrir la pantalla.');
      AddLog('JAV',2,'   - Se soluciona un error en el filtro de pedidos de compra al abrir la pantalla.');
      AddLog('JAV',2,'   - Se soluciona un error en el filtro de comparativos al generar el pedido/contrato.');
      AddLog('JAV',2,'   - Se soluciona un problema en la pantalla por el que marcaba err¢neamente las facturas y abonos de compra.');

      AddVer(mQB,'1.08.46',20200415D);
      AddLog('   ',0,'Versi¢n para compatibilizar cambios del QuoSII');

      AddVer(mQB,'1.08.47',20200415D);
      AddLog('   ',0,'Versi¢n para compatibilizar cambios del QuoSII');

      AddVer(mQB,'1.08.48',20200415D);
      AddLog('   ',0,'Valorada de producci¢n:');
      AddLog('JAV',1,'   - Se cambian los datos para que se vean correctamente los datos a PEC y a PEM en las l¡neas.');
      AddLog('JAV',1,'   - Se a¤ade el precio PEC anterior, resaltando si hay diferencias con el actual, y se pasa al hist¢rico al registrar');
      AddLog('JAV',1,'   - Se a¤aden los importes PEC en las listas, se a¤ade en ficha y lista la estad¡stica del panel lateral, que se ajusta mejor a los importes que se muestran.');
      AddLog('JAV',1,'   - Se vincula la edici¢n por medici¢n detallada a la l¡nea, si se ha cambiado por detallada no se puede cambiar por la l¡nea.');
      AddLog('JAV',1,'   - Se impide eliminar una valorada que no sea la £ltima emitida sin cancelar, para evitar discrepancias en los importes a origen.');
      AddLog('JAV',2,'   - Se arregla un problema por el que no numeraba el documento si no se entraba desde el proyecto.');
      AddLog('JAV',2,'   - En la cancelaci¢n se usa la fecha original. Se revisa que se use la fecha de registro para todos los c lculos en lugar de la fecha de la medici¢n.');
      AddLog('   ',0,'Mediciones:');
      AddLog('JAV',1,'   - Se vincula la edici¢n por medici¢n detallada a la l¡nea, si se ha cambiado por detallada no se puede cambiar por la l¡nea.');
      AddLog('JAV',1,'   - Se a¤ade la unidad de medida en la p gina y en el hist¢rico.');
      AddLog('JAV',2,'   - En la cancelaci¢n se usa la fecha original. Se revisa que se use la fecha de registro para todos los c lculos en lugar de la fecha de la medici¢n.');
      AddLog('   ',0,'Certificaciones:');
      AddLog('JAV',1,'   - Se a¤ade la unidad de medida en la p gina y en el hist¢rico.');
      AddLog('JAV',2,'   - En la cancelaci¢n se usa la fecha original. Se revisa que se use la fecha de registro para todos los c lculos en lugar de la fecha de la certificaci¢n.');
      AddLog('   ',0,'Ficha de an lisis de producci¢n:');
      AddLog('JAV',1,'   - Se cambia la columna "coste te¢rico producci¢n" para que sea el producto del precio previsto por la medici¢n de producci¢n ejecutada.');
      AddLog('JAV',1,'   - Se a¤ade la columna "coste medio producci¢n" para que sea la suma de lo ejecutado a su precio m s el pendiente al precio previsto.');
      AddLog('   ',0,'Generaci¢n del diario de necesidades de compras:');
      AddLog('JAV',1,'   - Al generar el diario de necesidades descontaba mal la cantidad en existencias, para mejorarlo se a¤ade un nuevo par metro para que se descuente o no estas cantidades.');
      AddLog('JAV',2,'   - Se arregla un error por el que no calculaba bien las cantidades en casos muy puntuales.');
      AddLog('   ',0,'Pedidos/Contratos de compra:');
      AddLog('JAV',1,'   - Se hacen editables los campos cantidad recibida a origen y cantidad en proforma a origen para facilitar el manejo de estos datos.');
      AddLog('JAV',1,'   - Se a¤ade un control para que la cantidad a recibir a origen no sea nunca inferior a la cantidad en profomas generadas.');
      AddLog('   ',0,'Proformas:');
      AddLog('JAV',1,'   - Se a¤aden los totales del documento (base, IVA, retenci¢n de pago, total a pagar) en el panel de la izquierda en la lista y en la ficha de proforma.');
      AddLog('JAV',1,'   - Se indica en el pedido el n£mero de proformas generadas, y se a¤ade un nuevo campo informativo que indica si se va a gestionar por proformas.');
      AddLog('JAV',1,'   - Al facturar albaranes se filtra que no se traigan albaranes de documentos relacionados con proformas, seg£n un nuevo campo que se ha puesto en la lista.');
      AddLog('JAV',1,'   - Si fuera necesario, ese filtro se puede eliminar, pero pedir  confirmaci¢n adicional si incluimos documentos de pedidos con proformas.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Al generar una proforma por registrar FRI + Proforma no tomaba bien las cantidades recibidas a origen.');
      AddLog('JAV',1,'   - Se mejora el proceso por el que al importar albaranes a las facturas de compra se cambian las condiciones del proveedor por las del contrato.');
      AddLog('JAV',2,'   - Se corrige un error de campo obsoleto al traer productos en las salidas de almac‚n de las obras.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.00',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se cambia el tipo de documento "Albar n" por "Dif. Cambio Albar n" para que sea m s claro.');
      AddLog('JAV',1,'   - Se a¤ade un mensaje al finalizar el c lculo de las diferencias en los presupuestos de coste de los proyectos.');
      AddLog('JAV',1,'   - En las l¡neas de albaranes se permite ver las facturas en que se han registrado en l¡neas de tipo recurso o cuenta.');
      AddLog('JAV',1,'   - En las proformas al generar las facturas agrupaba los datos por el producto sin considerar diferentes precios, unidades de media o unidades de obra.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error de RunModal al facturar o asociar una factura a una proforma.');
      AddLog('JAV',2,'   - Se arregla un error en los c lculos de totales de los Pedidos de compra que no consideraba los descuentos.');
      AddLog('JAV',2,'   - Se arregla un error en la consulta de proyecto por tener demasiados campos calculados.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.01',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se filtra la pantalla de planificaci¢n temporal para ver las unidades de coste directo o indirecto, en funci¢n de desde donde se llame.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de traer l¡neas de las proformas anteriores que no existan en la proforma actual para que cuadre a origen.');
      AddLog('JAV',1,'   - Se eliminan filtros no necesarios en la impresi¢n de la proforma.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.02',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de indicar el proyecto en l¡neas de diarios contables de tipo cliente o proveedor, pasando el proyecto al movimiento de cliente o proveedor');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - En los comparativo no calculaba el precio de compra al seleccionar el proveedor dej ndolo a cero, lo que afectaba si se actualizaban precios de los descompuestos.');
      AddLog('JAV',2,'   - Se arregla un error que no permit¡a incluir documentos en una relaci¢n de pagos en cartera si estaba activo el m¢dulo de confirming.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.03',20200415D);
      AddLog('   ',0,'Bloqueo de registro en los proyectos por fecha del presupuesto:');
      AddLog('JAV',1,'   - Se controla que en un proyecto no se pueda imputar costes en periodos donde el presupuesto est  cerrado.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de indicar en la configuraci¢n de usuarios mediante un nuevo check los que s¡ pueden saltarse esta restricci¢n.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - No guardaba correctamente el c¢digo del presupuesto anal¡tico de la tabla de estudios y proyectos por lo que pod¡a presentar los importes a cero.');
      AddLog('JAV',2,'   - Se arregla un error de desbordamiento al asociar un proyecto a un activo fijo.');
      AddLog('JAV',2,'   - Se arregla un error de desbordamiento al crear salidas de almac‚n de obra.');

      AddVer(mQSII,'1.05u', 20200415D);
      AddLog('   ',0,'Liberar IVA diferido de clientes:');
      AddLog('JAV',1,'   - Se a¤ade en la liberaci¢n de movimientos de IVA diferido de clientes una check para establecer que son del tipo 14 (Certificaci¢n de obra en entidades p£blicas).');
      AddLog('JAV',1,'   - Al traer cobros de clientes se incluyen los movimientos de IVA liberados marcados as¡ sin necesidad de cobrarlos, por tanto se pueden declarar antes del cobro.');
      AddLog('JAV',1,'   - En la pantalla de env¡os, se a¤ade un nuevo bot¢n "Env¡o C-14" que presenta la lista de documentos de ese tipo para incluir, marcando autom ticamente que es A1.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se impide que se vuelvan a traer documentos marcados como No subir al SII si ya se han procesado con otro tipo.');
      AddLog('JAV',2,'   - Cuando volvemos a obtener de nuevo documentos en algunos se borraba el n£mero de env¡o, con lo que se perd¡a el color de la l¡nea.');

      AddVer(mQF, '1.3q',  20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',1,'   - Se incluye en los abonos de venta registrados la posibilidad de modificar el periodo de facturaci¢n.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.04',20200415D);
      AddLog('   ',0,'Contratos Marco:');
      AddLog('JAV',1,'   - Se a¤ade un nuevo campo para indicar si es un contrato gen‚rico.');
      AddLog('JAV',1,'   - Cuando para una compra existe un contrato marco gen‚rico para el proveedor activo, se cambian las condiciones de pago con las del contrato marco.');
      AddLog('JAV',1,'   - Cuando se utiliza un contrato marco en una l¡nea se cambian las condiciones de pago del documento con las del contrato marco.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤aden m s tablas para su manejo por BI.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se eliminan tablas del SII de Microsoft fuera de licencia.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.05',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade el campo "No subir al SII" en pedidos y devoluciones de compra y venta, para que se puedan generar facturas directamente.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Si no est  activo el QuoSII daba un error en el hist¢rico de facturas y abonos de compra y de venta.');
      AddLog('JAV',2,'   - Se solucionan campos no correctos del periodo de facturaci¢n al modificar abonos de venta registrados.');

      AddVer(mQSII,'1.05v', 20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se revisan algunos puntos al liberar IVA diferido de facturas de compras y ventas');
      AddLog('JAV',2,'   - Al crear env¡os de tipo C-14 se marcan las l¡neas como correctas para que puedan enviarse a la AEAT como "A1 Modificaci¢n".');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.06',20200415D);
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Se mejora la configuraci¢n de anticipos en QuoBuilding y se a¤aden los contadores de documentos a generar.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de generar un anticipo sin factura, genera directamente un efecto en el cliente o el proveedor.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de descontar del pago de la factura que se est  creando el anticipo que ha generado efecto.');
      AddLog('JAV',1,'   - Se a¤aden los anticipos a la vista previa de registro y a la navegaci¢n.');
      AddLog('   ',0,'Facturaci¢n de certificaciones:');
      AddLog('JAV',1,'   - Se a¤ade en las unidades de venta una columna con el grupo de IVA asociado a la unidad de obra, si no se rellena se asume el general del proyecto.');
      AddLog('JAV',1,'   - Cuando se incluyen certificaciones en las facturas, se traen separadas por su IVA, dando los totales por cada grupo de IVA de las l¡neas.');
      AddLog('JAV',1,'   - Se a¤ade en la configuraci¢n de QuoBuilding la posibilidad de usar agrupaciones en las unidades de venta.');
      AddLog('JAV',1,'   - Se a¤ade en las unidades de venta una columna con un c¢digo de agrupaci¢n para las certificaciones, solo visible si est  activo el campo anterior.');
      AddLog('JAV',1,'   - Cuando se incluyen certificaciones en las facturas, se traen separadas por su agrupaci¢n, si hay m s de una se dan totales parciales en la factura.');
      AddLog('   ',0,'Vencimiento de retenciones:');
      AddLog('JAV',1,'   - Se a¤ade en las retenciones un campo para indicar si el c lculo se efect£a  a partir de la fecha del documento, de la de fin de trabajo o de la de fin de obra.');
      AddLog('JAV',1,'   - Se a¤ade en la ficha del proveedor un campo para indicar si se calcula el vto. seg£n el grupo asociado o se fuerza de otra manera para este proveedor.');
      AddLog('JAV',1,'   - Para proveedores se calcula sobre la fecha del documento, sobre la fecha de la £ltima proforma (fin de trabajo) o sobre la de fin de obra.');
      AddLog('JAV',1,'   - Para clientes se calcula sobre la fecha del documento o sobre la de fin de obra en los otros dos casos.');
      AddLog('JAV',1,'   - Cuando cambia la fecha de fin de obra o se marca la proforma como £ltima se solicita confirmaci¢n de si se desea cambiar las retenciones.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se hace configurable el control de fechas de los presupuestos, y se elimina el control de las fechas de inicio-fin del proyecto.');
      AddLog('JAV',1,'   - Se unifican las codeunit de vista previa de registro.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - No se mostraban las fechas del periodo de facturaci¢n en las facturas de venta con QuoSII activado, pero sin activar QuoFacturae.');
      AddLog('JAV',2,'   - Al a¤adir l¡neas a las proformas no filtraba que fueran del mismo pedido de compra.');
      AddLog('JAV',2,'   - Si no hay fecha de fin de obra ni de fin de garant¡a no dar error al verificar registros fuera de las fechas de un presupuesto abierto.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.07',20200415D);
      AddLog('   ',0,'Proyectos agrupados:');
      AddLog('JAV',1,'   - Se a¤ade en la lista de proyectos Matriz la indicaci¢n de que los importes son en la divisa local.');
      AddLog('JAV',1,'   - Se a¤ade en los paneles laterales de la lista y ficha de los proyectos operativos la posibilidad de ver los importes agrupados.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - En la planificaci¢n temporal del proyecto se a¤aden columnas con el total anterior y siguiente para los casos en que existan m s de 32 columnas.');
      AddLog('JAV',1,'   - Se mejora el tratamiento de los nombres de las fechas configurables seg£n los estados en proyectos.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',1,'   - No calculaba correctamente el vencimiento de las retenciones al crear un nuevo registro.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.08',20200415D);
      AddLog('   ',0,'Facturas Proforma:');
      AddLog('JAV',1,'   - Se a¤ade en la configuraci¢n de compras y pagos un nuevo campo para indicar que se desea generar proforma para todos los productos y recursos.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se mejora el tratamiento de los nombres de las fechas configurables seg£n los estados en estudios.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.09',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',1,'   - Daba un error en la tabla de estados de los presupuestos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.10',20200415D);
      AddLog('   ',0,'Proformas:');
      AddLog('JAV',1,'   - No se ten¡an en cuenta los descuentos en las proformas, se incluye la columna que se informa en el pedido y se arrastra correctamente a la proforma.');
      AddLog('JAV',1,'   - Se modifican los c lculos de los importes para que contemple el descuento asociado a la l¡nea de la proforma.');
      AddLog('JAV',1,'   - Al crear la factura de una proforma no mira si existen contratos marco gen‚ricos, no tiene sentido en las proformas.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.11',20200415D);
      AddLog('   ',0,'Reestimaciones:');
      AddLog('JAV',1,'   - En la configuraci¢n de QuoBuilding se a¤ade un grupo "Bloquear Reestimaciones", que incluye un campo para decidir si los meses en que se reestiman son fijos.');
      AddLog('JAV',1,'   - En la configuraci¢n de QuoBuilding se a¤aden campos para indicar los meses en que se desea reestimar.');
      AddLog('JAV',1,'   - En el proceso de cierre del mes se usa copiar o reestimar en funci¢n de si es un mes no marcado o uno con la marca.');
      AddLog('   ',0,'Objetivos:');
      AddLog('JAV',1,'   - En la configuraci¢n de QuoBuilding se a¤ade un campo "Controlar objetivo negativo".');
      AddLog('JAV',1,'   - Si est  marcado al salir de la ficha de objetivo si es negativo da un aviso.');
      AddLog('JAV',1,'   - Si est  marcado y el objetivo es negativo o no hay ficha de objetivo creada no permite crear nuevos presupuestos con reestimaci¢n (ver nuevo control en reestimaciones).');
      AddLog('JAV',1,'   - Si est  marcado en el proceso de cierre del mes solo se cierra los proyectos con objetivo positivo.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤aden m s tablas para su manejo por BI.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.12',20200415D);
      AddLog('   ',0,'Versi¢n para compatibilizar con QuoSII 1.05w');

      AddVer(mQSII,'1.05w', 20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Cuando se cobra una factura de la que se ha liberado anteriormente el IVA duplicaba el env¡o C-14');
      AddLog('JAV',2,'   - Al crear env¡os de tipo C-14 se marca el env¡o como "Facturas Emitidas" para que suban correctamente como A1.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.13',20200415D);
      AddLog('   ',0,'Proyectos agrupados:');
      AddLog('JAV',1,'   - Se a¤aden las mismas posibilidades de agrupaci¢n en los proyectos archivados.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se simplifica la ficha y a¤aden m s campos para los datos de impresi¢n de los contratos/pedidos de compra.');
      AddLog('JAV',1,'   - Se revisan los contratos en Word que se imprimen desde los pedidos/contratos de compra.');
      AddLog('JAV',1,'   - Se filtra la pantalla de planificaci¢n MSP para ver las unidades de coste directo £nicamente.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se elimina una relaci¢n de tabla err¢nea en la tabla de formas de pago.');

      AddVer(mQSII,'1.05x', 20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Al importar documentos duplicaba los F+01 cuando se cobraba la factura y el IVA diferido se hab¡a liquidado.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.14',20200415D);
      AddLog('   ',0,'Relaciones valoradas:');
      AddLog('JAV',1,'   - Se mejora el c lculo del precio de producci¢n.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n para incluir las l¡neas con medici¢n de relaciones anteriores en la presente.');
      AddLog('JAV',1,'   - Al crear una nueva y antes de registrar se incluyen las l¡neas existentes en las anteriores en la presente relaci¢n para tener correcto siempre el importe a origen.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.15',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - En el panel lateral del presupuesto de venta se a¤ade el c lculo del porcentaje indirecto.');
      AddLog('JAV',1,'   - Se a¤ade el campo del tipo de representante en la tabla de contactos.');
      AddLog('JAV',1,'   - Se a¤ade una nueva clave de ordenaci¢n en el hist¢rico de relaciones valoradas para presentar los datos por fechas correctamente.');
      AddLog('JAV',1,'   - Se hacen siempre visibles los campos del periodo de facturaci¢n.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Al cancelar albaranes de productos con varias l¡neas daba un error.');
      AddLog('JAV',1,'   - En los Contratos Marco estaban mal los datos de las columnas para cantidad en pedidos, en albaranes y en facturas, y no se navegaba correctamente a estos datos.');

      AddVer(mQSII,'1.05y', 20200415D);
      AddLog('   ',0,'Documentos de compra y de venta:');
      AddLog('JAV',2,'   - Se filtran los valores correctos de los campos de tipo de factura y tipo de rectificativa en los documentos de compra y de venta.');
      AddLog('JAV',2,'   - Se mejora el manejo de la edici¢n bloqueando campos correctamente en los documentos de compra y de venta.');
      AddLog('   ',0,'Documentos del QuoSII:');
      AddLog('JAV',2,'   - Se a¤aden el proyecto y el departamento en la lista y en la ficha.');
      AddLog('   ',0,'Usuario administrador:');
      AddLog('JAV',2,'   - Se a¤ade en la configuraci¢n el usuario administrador de QuoSII.');
      AddLog('JAV',2,'   - En las l¡neas de env¡os, al usuario administrador le aparece un bot¢n para marcar la l¡nea como enviada, y otro para quitar el estado del env¡o. Usar con precauci¢n.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.16',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade una nueva Query para BI.');
      AddLog('JAV',1,'   - Se hace no visible un campo del SII est ndar de la configuraci¢n de los grupos de IVA cuando no est  activo.');
      AddLog('JAV',1,'   - En los diarios generales se hacen visibles y no visibles columnas seg£n si QuoBuilding est  activado.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Los movimientos de tipo obra en curso en un diario general no siempre creaban movimientos de proyecto.');
      AddLog('JAV',2,'   - Se arreglan errores al abrir la ficha del proyecto operativo por objetos mal actualizados.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQSII,'1.05z', 20200415D);
      AddLog('   ',0,'Documentos del QuoSII:');
      AddLog('JAV',1,'   - Se permite modificar los n£meros de ticket informados en el documento.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1, '  - Se independiza completamente el m¢dulo de QuoBuilding.');
      AddLog('JAV',1, '  - Se a¤ade en la configuraci¢n la dimensi¢n relacionada con proyectos para que aparezca en la lista de documentos del QuoSII sin depender de campos de QuoBuilding.');
      AddLog('JAV',1, '  - Se mejora el c¢digo y se eliminan instrucciones que no se pueden usar en Extensiones.');
      AddLog('JAV',1,'   - Se mejora el manejo de los tres campos para el r‚gimen especial en clientes y proveedores.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.17',20200415D);
      AddLog('   ',0,'Pagos electr¢nicos:');
      AddLog('JAV',1,'   - Se cambia la forma de seleccionar el formato de los pagos electr¢nicos (confirming).');
      AddLog('JAV',1,'   - Hay un campo para indicarlo en la ficha del banco, si se tiene all¡ ya no hace falta indicarlo cada vez.');
      AddLog('JAV',1,'   - Se permite generar pagos electr¢nicos en las ¢rdenes de pago registradas, solo para algunos usuarios.');
      AddLog('JAV',1,'   - En la configuraci¢n de usuarios se a¤ade una columna para habilitar a estos usuarios.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se mejoran los men£s separ ndolos mejor por funcionalidades.');
      AddLog('JAV',1,'   - Se modifica el c lculo del precio en las relaciones valoradas y se simplifican las columnas.');
      AddLog('JAV',1,'   - Se mejoran los redondeos en los c lculos de los totales de las l¡neas de los pedidos de compra.');
      AddLog('JAV',1,'   - Se a¤aden m rgenes y totales al informe "Coste Real de Obra".');
      AddLog('JAV',1,'   - Se a¤ade una columna de ordenaci¢n de los KPI en el Web Service est ndar de datos de esquemas de cuentas.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error con el campo del n§ de la orden de pago del confirming de La Caixa.');
      AddLog('JAV',2,'   - Se aumenta la longitud en los campos relacionados con n£meros de serie que estaban definidos como Code[10] a Code[20].');
      AddLog('JAV',2,'   - Se revisan funciones que retornaban n£meros de serie limitadas a longitud 10 caracteres para que puedan retornar 20 caracteres.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.18',20200415D);
      AddLog('   ',0,'Mediciones:');
      AddLog('JAV',1,'   - Se a¤ade un nuevo campo con el precio del periodo que ajusta las diferencias de importes del periodo si hay cambios de precios sobre el origen.');
      AddLog('JAV',1,'   - Se hacen no visibles los campos relacionados con la redeterminaci¢n de precios, ya que actualmente no se puede usar.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se sincroniza con la versi¢n 0.00.00 de presupuestos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.19',20200415D);
      AddLog('   ',0,'Proformas:');
      AddLog('JAV',1,'   - Se cambia el orden de proceso de las l¡neas de las proformas al crear las facturas para que ajusten mejor.');
      AddLog('JAV',2,'   - Se arregla un error en el c lculo de retenciones de pago al crear las facturas desde la proforma.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Cuando en l¡neas de documentos de compra se indica que la unida de obra es la del almac‚n de la obra, se informa del C.A. de almac‚n y no se puede cambiar.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - El proceso de librar IVA diferido de proveedores se filtra para que solo se indiquen documentos de compra.');
      AddLog('JAV',2,'   - Se arregla un error con la dimensi¢n C.A. de la cabecera de salidas del almac‚n de obra, ahora siempre toma el de las l¡neas.');
      AddLog('JAV',2,'   - Se arregla un error de dimensiones en el m¢dulo de alquileres.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.20',20200415D);
      AddLog('   ',0,'Medici¢n y Certificaci¢n:');
      AddLog('JAV',2,'   - Se cambia la forma de calcular el importe del periodo, ahora es PERIODO = ORIGEN - ANTERIOR, antes era ANTERIOR = ORIGEN - PERIODO.');
      AddLog('JAV',1,'   - Se a¤ade una nueva columna para el precio del periodo, que se calcula como IMPORTE_PERIODO / MEDICION_PERIODO.');
      AddLog('JAV',2,'   - Se arregla un error de dimensiones en las l¡neas de comentarios al registrar la certificaci¢n.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se permiten caracteres de tabulaci¢n en la carga de los BC3.');
      AddLog('JAV',1,'   - Cuando no est  activo SII ni QuoSII, no se controlan que las fechas de registro sean a futuro.');
      AddLog('JAV',1,'   - Se sincroniza con la versi¢n 0.00.01 de presupuestos.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Cuando en el diario de necesidades se agrupaba por producto o por recurso, se perd¡a la descripci¢n.');
      AddLog('JAV',2,'   - Se arregla un error al indicar proyecto en diarios contables con l¡neas de clientes o proveedores.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.21',20200415D);
      AddLog('   ',0,'Pedidos de Servicio:');
      AddLog('JAV',2,'   - Se incorpora un nuevo m¢dulo para gestionar los pedidos de servicio que se realizan a los proyectos. Consulte con su comercial para mas informaci¢n.');
      AddLog('   ',0,'Almac‚n central:');
      AddLog('JAV',1,'   - Se incorpora un nuevo m¢dulo para gestionar el almac‚n central y la gesti¢n de material en dep¢sito. Consulte con su comercial para mas informaci¢n.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQSII,'1.06.00',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error de desbordamiento al obtener documentos ');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.22',20200415D);
      AddLog('   ',0,'Planificaci¢n de proyectos:');
      AddLog('JAV',1,'   - En la distribuci¢n proporcional se a¤ade la posibilidad de hacerlo como antes de las unidades seleccionadas o bien distribuirlas todas.');
      AddLog('JAV',1,'   - Se revisa el funcionamiento de la p gina de planificaci¢n de proyectos, mejorando su manejo y arreglando problemas.');
      AddLog('JAV',1,'   - Se a¤aden los importes ejecutados en la planificaci¢n temporal, en negrita y no editable.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n para ajustar directamente las diferencias en el £ltimo periodo en la pantalla.');
      AddLog('JAV',1,'   - Se vuelve a poner operativo el manejo por porcentajes.');
      AddLog('   ',0,'Planificaci¢n de Certificaci¢n:');
      AddLog('JAV',1,'   - En los presupuestos de venta se a¤ade un bot¢n para planificar las certificaciones.');
      AddLog('JAV',1,'   - Se puede partir de repartir las certificaciones pendientes proporcionalmente, usando el rango de fechas que se indique para ello, o copiar lo que hay en la planificaci¢n de costes.');
      AddLog('   ',0,'Previsiones de tesorer¡a:');
      AddLog('JAV',1,'   - Se incorpora en la ficha del proveedor un nuevo campo para indicar el banco de pagos predeterminado para el proveedor, igual al que hay en clientes.');
      AddLog('JAV',1,'   - Se mejora el m¢dulo incorporando los bancos, si no hay una remesa asociada al documento se usa el banco del cliente o proveedor.');
      AddLog('JAV',1,'   - Se mejora el m¢dulo, incorporando mejor la gesti¢n de divisas.');
      AddLog('JAV',1,'   - Se simplifican los movimientos que se generan desde los proyectos, solo aparecer  uno con la producci¢n pendiente por cada d¡a y unidad de obra del proyecto.');
      AddLog('JAV',1,'   - Se incluyen las previsiones de certificaci¢n si existen, si no existen se usa la de ingresos.');
      AddLog('JAV',1,'   - Se incluye en la configuraci¢n las cuentas para n¢minas y para partes de trabajo.');
      AddLog('JAV',1,'   - Se incluyen en los gastos e ingresos manuales del flujo la posibilidad de indicar banco y proyecto. En los gastos tambi‚n si son los gastos asociados a las n¢minas.');
      AddLog('JAV',1,'   - Se incluyen en la previsi¢n de tesorer¡a los gastos de personal, incluyendo las n¢minas (a partir de los gastos manuales) y los partes de trabajo.');
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se elimina el filtro de la pantalla de aprobaciones de los documentos para que se puedan ver por todos los usuarios, no solo los involucrados directamente.');
      AddLog('JAV',1,'   - Se elimina el bot¢n duplicado de aprobaciones en los abonos de compra.');
      AddLog('JAV',2,'   - Se soluciona un filtro err¢neo en la aprobaci¢n de abonos de compra.');
      AddLog('   ',0,'Albaranes de compra:');
      AddLog('JAV',1,'   - Se a¤aden dos campos informativos para indicar la cantidad y el importe provisionados de cada l¡nea del hist¢rico de albaranes.');
      AddLog('JAV',1,'   - La cantidad provisionada ser¡a la cantidad del albar n, la desprovisionada ser¡a la facturada m s la cancelada.');
      AddLog('JAV',1,'   - Se a¤aden las columnas en la pantalla de albaranes, pero no visibles por defecto.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se hace no editable el campo de Importe seg£n UTE en la pantalla de indirectos, cuando el proyecto no tiene UTE asociada.');
      AddLog('JAV',2,'   - Se cambia el orden de las fechas de registro y de documento en la pantalla de facturas de compra para que sea m s sencillo modificarla.');
      AddLog('JAV',2,'   - Se independizan las fechas de valoradas, mediciones y certificaciones para que se puedan informar individualmente.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error al importar certificaciones a una factura por el que no tra¡a siempre todas las l¡neas.');
      AddLog('JAV',2,'   - Se arregla un error con los importes de los expedientes de venta en la pantalla de objetivos.');
      AddLog('JAV',2,'   - Se arregla un error en el filtro de fechas del informe "Informe gastos por ppto nivel"');
      AddLog('JAV',2,'   - Se arregla un error en la importaci¢n de Excel directamente a los proyectos, no procesaba correctamente los textos le¡dos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.23',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade una consulta adicional para el PowerBI de acopios del almac‚n.');
      AddLog('JAV',1,'   - Arreglos menores en los m¢dulos de Pedidos de Servicio y Almac‚n central.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error al entrar en el presupuesto de costes directos de un estudio.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.24',20200415D);
      AddLog('   ',0,'Retenciones:');
      AddLog('JAV',1,'   - Posibilidad de impagar una retenci¢n, se a¤ade la cuenta en la pantalla de configuraci¢n de retenciones y un bot¢n para impagarlas en la lista de retenciones por B.E.');
      AddLog('JAV',1,'   - Mejoras en el m¢dulo para gestionar mejor los tipos de IRPF, se a¤ade una tabla de tipos y m s campos en la pantalla de configuraci¢n de retenciones.');
      AddLog('JAV',1,'   - Se a¤ade un proceso para exportar la declaraci¢n de IRPF a un fichero de texto que sea compatible con el que solicita la AEAT.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de gestionar la fecha de fin de obra usando la que est‚ informada entre "Fecha inicio garant¡a", "Fecha prevista Fin Construcci¢n" y "Fecha de fin".');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.25',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se sincroniza con la versi¢n 0.00.02 de presupuestos, se incluyen todos los objetos relacionados con presupuestos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.26',20200415D);
      AddLog('   ',0,'Importe de albaranes ptes. de recibir:');
      AddLog('JAV',1,'   - Se a¤ade en los albaranes de compra campos para ver importe total, facturado y pendiente, en la divida del documento, la local, la del proyecto y la de reporting.');
      AddLog('JAV',1,'   - Se mejora la velocidad del c lculo de los importes de albaranes pendientes de recibir facturas para no tener que calcularlo recorriendo las l¡neas de pedidos.');
      AddLog('JAV',1,'   - Ya no se calcula a partir de las l¡neas de los pedidos, sino sumando directamente l¡neas de albaranes.');
      AddLog('JAV',1,'   - Se cambia las pantallas de estad¡sticas y los paneles laterales del proyecto para usar el nuevo c lculo que es m s r pido.');
      AddLog('   ',0,'Grupos registro de IVA:');
      AddLog('JAV',1,'   - Se a¤ade un campo para indicar que cuando se use ese grupo en un abono de compra o de venta, se cambie autom ticamente por este, as¡ se simplifica el manejo.');
      AddLog('JAV',1,'   - Al indicar en Compras dentro de un abono o una devoluci¢n el proveedor, o al cambiar el grupo de IVA, se busca la equivalencia.');
      AddLog('JAV',1,'   - Al indicar en Ventas dentro de un abono o una devoluci¢n el cliente, o al cambiar el grupo de IVA, se busca la equivalencia.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se eliminan campos de importes no usados en facturas y abonos de compra registrados y en las proformas.');
      AddLog('JAV',1,'   - Se pasan a funciones globales algunas funciones de la tabla de proyectos para mejorar la velocidad de su manejo.');
      AddLog('JAV',1,'   - Arreglos menores en el m¢dulo de Pedidos de Servicio.');
      AddLog('JAV',1,'   - Se sincroniza con la versi¢n 0.00.03 de presupuestos.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error en la planificaci¢n temporal de los estudios.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.27',20200415D);
      AddLog('   ',0,'Cambios de versi¢n:');
      AddLog('JAV',1,'   - Se mejora el proceso de cambios de versiones para que se pueda lanzar m s f cilmente.');
      AddLog('JAV',1,'   - Se a¤ade como bot¢n en la configuraci¢n de QuoBuilding para lanzarlo cuando sea necesario.');
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Se usaba signo negativo en los anticipos de proveedores, se ha cambiado para que anticipo sea positivo y aplicaci¢n negativo siempre.');
      AddLog('JAV',2,'   - Al ser positivo arregla un error que no permit¡a aplicar el anticipo a una factura de proveedor.');
      AddLog('   ',0,'Proformas:');
      AddLog('JAV',2,'   - Al crear la factura cambiaba las fechas informadas en la proforma por la fecha de trabajo, se cambia para que se respeten.');
      AddLog('JAV',2,'   - Al crear la factura no establec¡a el proyecto en la cabecera de la nueva factura, se cambia para que lo haga.');
      AddLog('   ',0,'Divisas:');
      AddLog('JAV',2,'   - Se a¤aden campos de nombres y caracter¡sticas para imprimir mejor en divisas los importes en texto.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Arreglos menores en el m¢dulo de Pedidos de Servicio. Se a¤aden campos con descripciones configurables para sus tablas.');
      AddLog('JAV',1,'   - Se hace configurable la descripci¢n del campo "Responsable" en los proyectos.');
      AddLog('JAV',1,'   - Se sincroniza con las versiones 0.00.04 y 00.00.05 de presupuestos.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se da un mensaje de error correcto cuando en el proceso de c lculo de la obra en curso no est  configurado el diario, el que daba el est ndar no era informativo.');
      AddLog('JAV',2,'   - Se arregla un error en la propuesta de consumo del almac‚n cuando en los descompuestos se usan productos sin stock.');
      AddLog('JAV',2,'   - Se arregla un error en la sincronizaci¢n de tablas entre empresas para no considerar campo de £ltima modificaci¢n.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQPR,'1.00.00', 20200415D);
      AddLog('   ',0,'Nuevo m¢dulo de gesti¢n de Presupuestos (VERSION EN DESARROLLO, para mas informaci¢n contacte con su comercial):');
      AddLog('JAV',1,'   - 0.00.00 02/09/21 Se ha incorporado la primera fase de la nueva funcionalidad de gesti¢n de presupuestos globales.');
      AddLog('JAV',1,'   - 0.00.01 28/09/21 Se introducen mejoras generales.');
      AddLog('JAV',1,'   - 0.00.02 29/10/21 Se introducen campos nuevos en documentos de compra y de venta.');
      AddLog('JAV',1,'                      Se crean nuevos par metros de configuraci¢n para crear valores de dimensi¢n, Grupo Contable y Recurso desde las partidas presupuestarias.');
      AddLog('JAV',1,'                      Al introducir datos en los diarios contable, se busca la cuenta a partir de la partida y el grupo de producto asociado a la l¡nea.');
      AddLog('JAV',1,'                      En las listas de proyectos para incorporar en documentos se incluyen los proyectos de tipo presupuesto.');
      AddLog('JAV',1,'   - 0.00.03 30/10/21 Se presentan los importes de compras previstas, comprometidas y facturadas en la pantalla de los presupuestos.');
      AddLog('JAV',1,'                      Se incorporan campos en las l¡neas de los albaranes de compra para informar de importes facturados y pendientes.');
      AddLog('JAV',1,'                      Se mejora la creaci¢n de datos auxiliares al crear los presupuestos.');
      AddLog('JAV',1,'                      Se incorpora en documentos de compra y venta la gesti¢n de las Partidas Presupuestarias y su manejo.');
      AddLog('JAV',1,'   - 0.00.04 10/11/21 Se a¤aden m s campos de configuraci¢n.');
      AddLog('JAV',1,'                      Se a¤aden m s campos en las columnas de los presupuestos y su manejo.');
      AddLog('JAV',1,'                      Se a¤ade un tipo de Recurso "Partida Presupuestaria".');
      AddLog('JAV',1,'   - 0.00.05 15/11/21 Se a¤aden plantillas de presupuestos y su manejo.');
      AddLog('JAV',1,'   - 0.00.06 19/11/21 Se a¤ade la planificaci¢n temporal de los presupuestos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mRE,'1.00.00', 20200415D);
      AddLog('   ',0,'Nuevo m¢dulo de gesti¢n para Real Estate (VERSION EN DESARROLLO, para m s informaci¢n contacte con su comercial):');
      AddLog('JAV',1,'   - 0.00.00 18/09/21 Se ha incorporado la primera fase de la nueva funcionalidad de Real Estate.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.09.28',20200415D);
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de disponer de grupos de plantillas de responsables, para poder usar aprobaciones diferentes seg£n los grupos que se definan.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Arreglos menores en el m¢dulo de almac‚n Central para el control de cedidos.');
      AddLog('JAV',1,'   - Se a¤ade una consulta adicional para el PowerBI para el estado de las aprobaciones.');
      AddLog('JAV',1,'   - Se cambia la forma de buscar la presentaci¢n o no de los botones de manejo de divisas en las pantallas para compatibilizar con presupuestos y Real Estate.');
      AddLog('JAV',1,'   - Se sincroniza con la versi¢n 0.00.01 de Real Estate.');
      AddLog('JAV',1,'   - Se sincroniza con la versi¢n 0.00.06 de Presupuestos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.00',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un error por el que cuando no estaban activos los anticipos de clientes no se ve¡an los de proveedores.');
      AddLog('JAV',2,'   - Se soluciona un error al cambiar el proveedor en una factura de venta cuando ten¡a un anticipo.');
      AddLog('JAV',2,'   - Se soluciona un error que ralentizaba el c lculo de las v¡stas de an lisis al obligar a realizarlas siempre a origen.');
      AddLog('JAV',2,'   - Se da un mensaje de error m s explicativo para la falta de dimensi¢n departamento al registrar partes de trabajo.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.01',20200415D);
      AddLog('   ',0,'Banco de cobro y pago:');
      AddLog('JAV',1,'   - Hasta ahora solo se informaba en los clientes y proveedores, y se usaba en las previsiones de tesorer¡a.');
      AddLog('JAV',1,'   - Se a¤ade un par metro de configuraci¢n para indicar si es obligatorio tenerlo en todos los movimientos.');
      AddLog('JAV',1,'   - Se a¤ade en los documentos de compra y venta, en los movimientos de cliente y proveedor y en cartera sin registrar.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de puede modificar el banco en los movimientos registrados que no est‚n pagados o en una orden de cobro o pago.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.02',20200415D);
      AddLog('   ',0,'Proformas:');
      AddLog('JAV',1,'   - Se modifica los c lculos de las l¡neas que no siempre eran correctos.');
      AddLog('JAV',1,'   - Se modifica la creaci¢n de las facturas para que se a¤adan las lineas mirando el pedido de origen y no el producto o recurso a incluir.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Solo se consideran los anticipos en las facturas, no en los pedidos ni en los abonos.');
      AddLog('JAV',2,'   - Se arregla el importe de produccion en la cronovisi¢n del proyecto que sacaba incorrectamente el importe facturado.');
      AddLog('JAV',2,'   - Se marca por defecto "provisionar albaranes de compra" en todo tipo de proyecto, no solo en proyectos operativos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.03',20200415D);
      AddLog('   ',0,'Cambio de Dimensiones:');
      AddLog('JAV',1,'   - Se a¤ade un check en la configuraci¢n de usuarios para permitirles cambiar las dimesiones de documentos registrados.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n en los documentos contables registrados para poder cambiar las dimensiones, solo activo para los usuarios que lo tengan activo.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se iguala la pantalla de Relaciones Valoradas Registradas para que sea similar a la de sin Registrar.');
      AddLog('JAV',1,'   - Se elimina de la sincronizaci¢n de datos desde la empresa Master los campos que no son posible tratar.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrige un error con los decimales en el proceso de cambio de n£meros a letras para la impresi¢n de pagar‚s.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.04',20200415D);
      AddLog('   ',0,'Numeraci¢n de proyectos:');
      AddLog('JAV',1,'   - Se a¤ade en la tabla de clasificaci¢n de proyectos la posibilidad de indicar series diferentes para numerar los proyectos seg£n el registro seleccionado.');
      AddLog('JAV',1,'   - Si en esta tabla se indican contadores, antes del alta se presenta una pantalla para seleccionar la clasificaci¢n de proyecto que se desea utilizar.');
      AddLog('JAV',1,'   - Si en esta tabla solo un registro tiene un contador, se usar  este para el alta del registro.');
      AddLog('JAV',1,'   - Si en esta tabla ning£n registro tiene un contador, se usar  lo informado en la Configuraci¢n de QuoBuilding.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.05',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se eliminan de la ficha de Estudios campos del panel de UTE que no se utilizan.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrige un error por falta de licencia en las codeunit de Presupuestos para Proyectos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.06',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade en la pantalla de inicio de Jefe de Obra, Administrativo de Obra y Responsable de Compras una pila con los contratos pendientes de generar.');
      AddLog('JAV',1,'   - Al crear las mediciones desde un proyecto no informaba del cliente y el expediente de venta relacionado.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrigen errores en el proceso de generaci¢n de facturas de venta a partir de los hitos del proyecto.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.07',20200415D);
      AddLog('   ',0,'Preciarios:');
      AddLog('JAV',1,'   - Se permite definir los decimales que se desean usar para los redondeos en la carga de preciarios al sistema.');
      AddLog('JAV',2,'   - Se corrige un error en la carga de preciarios cuando el c¢digo de la partida tiene m s de 10 d¡gitos.');
      AddLog('   ',0,'Anulaci¢n de albaranes:');
      AddLog('JAV',2,'   - Se corrige un error por el que a¤ad¡a el almac‚n en los albaranes cuando se anulaban las l¡neas, adem s pod¡a dar un error general cuando se anulaban.');
      AddLog('JAV',2,'   - Se corrige un error por el que pod¡a dar un error general cuando se anulaban albaranes.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade un mensaje m s informativo en los procesos de sincronizaci¢n de la configuraci¢n desde la empresa Master.');
      AddLog('JAV',1,'   - Se a¤ade la columna del C¢digo de la U.O. de Presto en las relaciones valoradas.');
      AddLog('JAV',1,'   - Se a¤ade la £ltima letra que faltaba en la palabra "Pagar‚" en la pantalla de par metros para la generaci¢n de confirming est ndar.');
      AddLog('JAV',1,'   - En los Confirming con formato est ndar, si son de Pronto Pago se informa la fecha de cargo usando para ello la fecha de vencimiento.');
      AddLog('JAV',1,'   - Cuando se genera la factura desde una proforma, si el albar n tiene informado el almac‚n este no se traspasa a la factura para evitar errores al registrarlas.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se cambia el tipo de los campos de "Plazos oficiales" en los proyectos a tipo Texto en lugar de tipo duraci¢n.');
      AddLog('JAV',2,'   - Se corrige un error de permisos en la pantalla del hist¢rico de facturas de venta.');
      AddLog('JAV',2,'   - Se corrige un error en el panel lateral del proyecto por el que no filtraba cuando se indicaba el filtro de "Fecha de registro".');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.08',20200415D);
      AddLog('   ',0,'Comparativos:');
      AddLog('JAV',2,'   - Se corrigen errores diversos en la generaci¢n y lectura de las solicitudes de precios a los proveedores.');
      AddLog('JAV',1,'   - Se a¤ade en la cabecera y en las l¡neas la fecha de recepci¢n esperada, la de cabecera ser  la menor de las l¡neas.');
      AddLog('JAV',1,'   - Al calcular necesidades y generar comparativos, la fecha de necesidad pasa al comparativo.');
      AddLog('JAV',1,'   - Si hay fecha en la l¡nea del comparativo, se pasa a la l¡nea del pedido que se genere.');
      AddLog('JAV',1,'   - Se a¤ade en la configuraci¢n de QuoBuilding un check para indicar si se puede desglosar el comparativo por meses.');
      AddLog('JAV',1,'   - Se a¤ade un campo para indicar cuantos meses desea generar las l¡neas');
      AddLog('JAV',1,'   - Si se informan los meses, por cada l¡nea se generan en el pedido tantas l¡neas como meses se indiquen, con su fecha de necesidad aumentada un mes.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Si no est n activos ninguno de los m¢dulos propios de proyectos se hace que se tenga acceso a todos los proyectos.');
      AddLog('JAV',1,'   - Se mejoran los filtros de proyecto a los que tienen accesos los usuarios cuando la acci¢n se lanza desde el propio proyecto.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.09',20200415D);
      AddLog('   ',0,'Confirming:');
      AddLog('JAV',1,'   - Se permite marcar en las formas de pago que se usar n para confirming. Si es as¡ las marcadas usar n otras cuentas para su registro.');
      AddLog('JAV',1,'   - Se a¤ade en los grupos registro de cliente y proveedor las cuentas para el registro del confirming.');
      AddLog('JAV',1,'   - En el registro contable de documentos de confirming, si la forma de pago tiene marcado que es de este tipo, se usaran las nuevas cuentas.');
      AddLog('   ',0,'Informes de albaranes:');
      AddLog('JAV',1,'   - Se pasa el informe de albaranes pendientes de facturar al men£ de compras, y se a¤ade un nuevo informe que compara lo contabilizado con los albaranes para ver si hay diferencias.');
      AddLog('   ',0,'Selector de informes:');
      AddLog('JAV',1,'   - Se a¤ade el nombre a mostrar en la pantalla de selecci¢n, y se elimina de esta el n£mero del informe.');
      AddLog('JAV',2,'   - No se a¤aden los report est ndar cuando existe ya una configuraci¢n espec¡fica.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade los proyectos de Real Estate a los que se controlan por presupuestos.');
      AddLog('JAV',1,'   - Se ajusta ligeramente el formato de confirming del Deutsche Bank.');
      AddLog('JAV',1,'   - Se ajustan los campos de fecha en la impresi¢n de contratos de compra para que no incluyan la hora.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrige un posible error al cancelar albaranes con l¡neas de producto.');
      AddLog('JAV',2,'   - Se corrige un posible error en la configuraci¢n de presupuestos contables de proyectos cuando no hay reestimaciones.');
      AddLog('JAV',2,'   - Se hace no editable el campo de importe de anticipo en los totales de las l¡neas de las facturas de compra.');
      AddLog('JAV',2,'   - Se corrige un error en la cabecera de traspasos entre proyectos.');

      AddVer(mQPR,'0.00.07',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se unifica la gesti¢n de aprobaciones con la general.');
      AddLog('JAV',1,'   - Se cambia la llamada a la configuraci¢n de aprobaciones en el men£ de Presupuestos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.10',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se permite que las mediciones sean negativas al cargar los preciarios en un proyecto.');
      AddLog('JAV',1,'   - Se ajusta la impresi¢n de importes num‚ricos para algunos documentos.');
      AddLog('JAV',1,'   - Se incluye la impresi¢n de la certificaci¢n en borrador.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.11',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se eliminan campos no utilizados relacionados con contratos en los documentos de compras.');
      AddLog('JAV',1,'   - Se mejora el informe que compara lo contabilizado con los albaranes para ver si hay diferencias (incorporado en la versi¢n 1.10.09).');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error menor en el registro de los confirming a cuentas espec¡ficas de registro (incorporado en la versi¢n 1.10.09).');
      AddLog('JAV',2,'   - Se arregla un error en la distribuci¢n proporcional de los costes al marcar "usar todas las partidas" (incorporado en la 1.09.22).');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.12',20200415D);
      AddLog('   ',0,'Cartera:');
      AddLog('JAV',1,'   - Se a¤ade una pantalla para liquidar directamente los documentos pendientes en ¢rdenes de pago registradas sin necesidad de entrar en la orden.');
      AddLog('JAV',1,'   - Se a¤ade una pantalla para liquidar directamente los documentos pendientes en remesas de cobros registradas sin necesidad de entrar en la remesa.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se incluyen objetos solo para asegurar su distribuci¢n sin alterar su funcionalidad.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arreglan longitudes de campo que pueden producir un error de ejecuci¢n.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQSII,'1.06.01',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arreglan longitudes de campo que pueden producir un error de ejecuci¢n.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.13',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se mejora la impresi¢n de los contratos de compra, a¤adiendo en la pantalla del contrato el campo de Hitos de Facturaci¢n y eliminado otros redundantes.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error en el formato est ndar de confirming de tipo Pronto Pago por el que no inclu¡a la fecha de vencimiento.');
      AddLog('JAV',2,'   - Se arregla un error la creaci¢n de Unidades de Obra con separaci¢n en los estudios.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.14',20200415D);
      AddLog('   ',0,'Medici¢n y Certificaci¢n:');
      AddLog('JAV',1,'   - Se a¤ade en las l¡neas de los documentos el c¢digo del expediente de venta asociado a la unidad de obra, no editable.');
      AddLog('   ',0,'Comparativos de compra:');
      AddLog('JAV',1,'   - Se incluyen en la configuraci¢n de compras los cargos de los 4 posibles firmantes del comparativo, que se pueden establecer por nombre o por cargo.');
      AddLog('JAV',1,'   - Se incluye en la impresi¢n del comparativo la posibilidad de cambiar los cargos de los firmantes.');
      AddLog('JAV',1,'   - Se incluye en la impresi¢n los nombres de los firmantes si se establece por cargos, los obtiene a partir de los definidos en el proyecto.');
      AddLog('JAV',2,'   - Se arregla un error cuando un proveedor incluido no ten¡a l¡neas de condiciones definidas.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se incluyen formatos personalizados para la impresi¢n de facturas de venta sin registrar como Proformas.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.15',20200415D);
      AddLog('   ',0,'Albaranes de salida de existencias:');
      AddLog('JAV',1,'   - Al calcular el stock se a¤ade un check para que lo calcule a la fecha indicada como "Fecha de regularizaci¢n".');
      AddLog('JAV',1,'   - Si no se marca ese check se obtendr  el stock actual.');
      AddLog('   ',0,'Pedidos de servicio:');
      AddLog('JAV',1,'   - Se a¤aden nuevos campos en las pantallas y se mejora el tratamiento general.');
      AddLog('JAV',2,'   - Se solucionan errores menores a la hora de su facturaci¢n.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - En la separaci¢n coste-venta se a¤ade un bot¢n para recalcular los porcentajes de asignaci¢n inversa.');
      AddLog('JAV',1,'   - En la configuraci¢n de usuarios se a¤ade un bot¢n para copiar los permisos desde otro usuario.');
      AddLog('JAV',1,'   - Se a¤ade la £ltima letra que faltaba en la palabra "Pagar‚" en la pantalla de par metros para la generaci¢n de confirming est ndar.');
      AddLog('JAV',1,'   - Se a¤ade un nuevo Web Service para usarlo en el BI.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error por el que no guardaba bien los datos de la tabla extendida de ventas para pedidos de servicio.');
      AddLog('JAV',2,'   - Se arregla un error de tama¤o al crear amortizaciones de Activos Fijos.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.16',20200415D);
      AddLog('   ',0,'Facturas y abonos de venta:');
      AddLog('JAV',1,'   - En abonos de venta se a¤aden los campos "Descripci¢n de registro" y "N§ siguiente factura".');
      AddLog('JAV',1,'   - En facturas se ubica el campo "N§ siguiente factura" tras el texto de registro.');
      AddLog('   ',0,'Albaranes de salida de existencias:');
      AddLog('JAV',2,'   - Se arregla un error por el que no tomaba siempre las dimensiones adecuadas en las l¡neas al registrar.');
      AddLog('JAV',2,'   - Se arregla un error por el que registraban siempre todos los partes de regularizaci¢n de stock sin filtrar por el actual.');
      AddLog('   ',0,'Pedidos de servicio:');
      AddLog('JAV',1,'   - Se a¤aden nuevos campos en las tablas hist¢ricas.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤aden formatos de impresi¢n de facturas de venta personalizados.');
      AddLog('JAV',1,'   - Mejoras en el control de las personalizaciones de los clientes.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.17',20200415D);
      AddLog('   ',0,'Facturas y abonos de venta:');
      AddLog('JAV',1,'   - Se a¤ade en la cabecera el campo con el CIF/NIF del cliente, pero con importancia adicional, se ve al mostrar m s datos.');
      AddLog('   ',0,'Pedidos, Facturas y abonos de compra:');
      AddLog('JAV',1,'   - Se a¤ade en la cabecera el campo con el CIF/NIF del cliente, pero con importancia adicional, se ve al mostrar m s datos.');
      AddLog('JAV',1,'   - Se a¤ade en las l¡neas de las facturas las columnas "Gr. Reg. Negocio" y "Gr. Reg. Producto", no visibles por defecto y no editables para l¡neas que vienen de un albar n.');
      AddLog('JAV',2,'   - Se soluciona un error al lanzar la vista de las dimensiones en los abonos de compra.');

      //////////////////////////////////////////////////////////////////////////////////////////////////////////{--------------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.18',20200415D);
      AddLog('   ',0,'Previsi¢n de la certificaci¢n:');
      AddLog('JAV',1,'   - Se cambia la forma de planificar las certificaciones, se pueden realizar o bien por cada expediente o por el total.');
      AddLog('JAV',1,'   - Se a¤aden columnas para la planificaci¢n inicial y la ejecutada real. La inicial se fija usando un bot¢n en la cabecera.');
      AddLog('JAV',1,'   - Se a¤ade un nuevo Web Service para usarlo en el BI.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se mejora el informe que compara lo contabilizado con los albaranes para ver si hay diferencias (incorporado en la versi¢n 1.10.09).');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error interno en la pantalla de cambios de versi¢n.');
      AddLog('JAV',2,'   - Se arregla un error interno en el proceso de registro de albaranes de salida de almac‚n.');

      //{--- V00157 -----------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.19',20200415D);
      AddLog('   ',0,'Configuraci¢n de responsables de proyectos:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de disponer de varias plantillas de responsables en la configuraci¢n general, lo que se puede usar para varios tipos de obras.');
      AddLog('JAV',1,'   - Cuando se cargan los responsables de un proyecto, si hay varias plantillas se debe seleccionar primero que plantilla se va a utilizar.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade en las l¡neas abonos de compra las columnas "Gr. Reg. Negocio" y "Gr. Reg. Producto", no visibles por defecto y no editables para l¡neas que vienen de un albar n.');
      AddLog('JAV',1,'   - Se automatizan los procesos de cambios de versi¢n.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error de desbordamiento al calcular las amortizaciones.');
      AddLog('JAV',2,'   - Se arregla un error por el que no siempre cambiaba el banco de cobro/pago desde los documentos registrados de compra y de venta en los movimientos.');
      AddLog('JAV',2,'   - Se arregla un error por el que siempre necesitaba disponer de un flujo de aprobaci¢n en todos los documentos de compra (pedido abierto, pedido, factura, abono, devoluci¢n).');

      AddVer(mQSII,'1.06.02',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se filtra para que en los env¡os del QuoSII no se incluyan nunca documentos marcados como "No subir al SII".');
      AddLog('   ',0,'Pedidos abiertos de compra y de venta:');
      AddLog('JAV',2,'   - Se arregla un error de fechas la generar el pedido.');
      AddLog('JAV',2,'   - Se arregla un error por el que no incluia los datos del SII en el pedido que se generaba.');

      //{--- V00158 -----------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.20',20200415D);
      AddLog('   ',0,'Pedidos de servicio y Almac‚n central:');
      AddLog('JAV',1,'   - Se a¤aden las revisiones de precios para los pedidos de servicio.');
      AddLog('JAV',2,'   - Arreglos menores, se ponen correctos algunos filtros de las pantallas, se a¤aden campos y alguna acci¢n para ambos m¢dulos.');
      AddLog('   ',0,'Bancos de cobro y pago:');
      AddLog('JAV',1,'   - Se hace editable en las listas de documentos de cartera de cobros y de pagos el campo de banco de pago.');
      AddLog('JAV',1,'   - Al registrar una remesa u orden de pago, se actualizan los datos del documento con el banco real al que se ha llevado el cobro o pago.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade el campo de "Tipo de cliente" en la ficha de clientes, y se carga autom ticamente en el proyecto si lo tiene informado.');
      AddLog('JAV',1,'   - Se mejoran filtros y c lculos del m¢dulo de previsi¢n de certificaciones (incluido en la versi¢n 1.10.18).');
      AddLog('JAV',1,'   - Se a¤ade el nuevo manejo de las empresas M ster Data en su versi¢n 1.00.00');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error por el que no se activaba correctamente en las facturas de compra el campo de permitir mezclar condiciones en los albaranes.');
      AddLog('JAV',2,'   - Se arregla un error por el que recalculaba siempre el vencimiento de los abonos, aunque se hubiese establecido manualmente.');
      AddLog('JAV',2,'   - Se arregla nombre duplicado en la ficha de Estudios, pon¡a "Tipo oferta" en lugar de "Fase del proyecto".');

      AddVer(mMD,'1.00.00',20200415D);
      AddLog('   ',0,'Nuevo proceso de sincronizaci¢n de datos desde la empresa M ster:');
      AddLog('JAV',1,'   - Reemplaza al m¢dulo anterior, este es m s flexible y admite en autom tico cualquier tabla.');
      AddLog('JAV',1,'   - Consulte con su comercial si es £til su implementaci¢n.');

      //{--- V00159 -----------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.21',20200415D);
      AddLog('   ',0,'Competidores en los estudios:');
      AddLog('JAV',1,'   - Al cambiar el importe de licitaci¢n del estudio no cambiaba los porcentajes de baja de los competidores.');
      AddLog('JAV',1,'   - Permit¡a marcar como aceptado a varios competidores.');
      AddLog('JAV',1,'   - La p£ntuaci¢n m xima de las evaluaciones no estaba como editable.');
      AddLog('JAV',1,'   - Al cambiar el importe de licitaci¢n del estudio no cambiaba los porcentajes de baja de los competidores.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n en la lista de usuario para copiar los permisos desde otro usuario existente.');
      AddLog('JAV',1,'   - Ajustes de posici¢n de campos en las pantallas de facturas de compras y de ventas.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error por el que no tomaba correctamente el n£mero de la licencia al cargar el programa.');
      AddLog('JAV',2,'   - Se arregla un error por el que no indicaba el importe facturado de la certificaci¢n cuando se marca manualmente como facturado.');
      AddLog('JAV',2,'   - Se arregla un error que se produc¡a al abrir una relaci¢n valorada sin l¡neas.');
      AddLog('JAV',2,'   - Se arregla un error que se produc¡a al registrar una factura de venta que proviene de un pedido de servicio con la tabla de extensi¢n.');
      AddLog('JAV',2,'   - Se elimina la opci¢n del diario de producci¢n del men£ de Producci¢n y certificaci¢n que era err¢nea.');

      //{--- V00160 -----------------------------------------------------------------------------------------------------------------------}

      AddVer(mQB,'1.10.22',20200415D);
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se cambian los procesos de aprobaci¢n para conseguir mayor flexibilidad y la posibilidad de configurar varios circuitos en todos los documentos.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Ajustes de posici¢n de campos en cabeceras de facturas de compras y de ventas.');
      AddLog('JAV',1,'   - Se eliminan campos no usados en las tablas de compras: cabeceras, albaranes, facturas, abonos, archivo.');
      AddLog('JAV',1,'   - Se a¤aden el manejo de dimensiones en los comparativos de compra.');
      AddLog('JAV',1,'   - Se a¤aden traducciones al ingl‚s que faltaban en opciones de algunos men£s de obras.');
      AddLog('JAV',1,'   - Cuando se navega a un proyecto desde la cabecera o l¡neas de un documento, se posiciona en la lista en el proyecto actual.');

      //{--- V00161 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.23',20200415D);
      AddLog('   ',0,'Existencias:');
      AddLog('JAV',1,'   - Se a¤aden procesos para el manejo de las existencias en las devoluciones a los proveedores.');
      AddLog('JAV',1,'   - Se modifica el c lculo del coste medio para que se realice por proyecto y considere todas las entradas siempre.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se ajustan y ordenan por fechas los informes relacionados con pedidos de servicio.');
      AddLog('JAV',1,'   - Se cambian nombres en campos del circuito de aprobaci¢n para que sea m s claro.');
      AddLog('JAV',1,'   - Se mejoran las customizaciones del programa y se a¤aden formatos personalizados.');
      AddLog('JAV',1,'   - Se a¤ade la columna "Forma de pago" en la lista de clientes y en la de proveedores.');
      AddLog('JAV',1,'   - Se a¤ade la columna "N§ Doc. Externo" en las listas de documentos en cartera.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se distribuye la CodeUnit 7207352 que no se incluy¢ por error en el cambio a la versi¢n 1.10.20.');
      AddLog('JAV',2,'   - Se arregla un error al registrar las notas de gasto de los empleados.');
      AddLog('JAV',2,'   - Se arregla un error con los caracteres acentuados y especiales al guardar la descripci¢n del trabajo en documentos de ventas.');
      AddLog('JAV',2,'   - Se arregla un error de fecha del documento en los anticipos de proyecto.');

      //{--- V00162 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.24',20200415D);
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Mejora general del manejo de anticipos a proveedores, se comprueban al entrar en el documento, al solicitar aprobaci¢n o en los procesos de registro.');
      AddLog('JAV',1,'   - Si se cambia el proveedor, proyecto o divisa en un documento de compra con anticipo aplicado, se elimina el anticipo para que no sea incoherente.');
      AddLog('JAV',2,'   - Al generar un documento para un nuevo anticipo a proveedor se informa en el documento de la fecha del documento para evitar errores.');
      AddLog('JAV',2,'   - Arreglos menores en procesos de compra.');
      AddLog('JAV',1,'   - Mejora general del manejo de anticipos de clientes, se comprueban al entrar en el documento o en los procesos de registro.');
      AddLog('JAV',1,'   - Si se cambia el cliente, proyecto o divisa en un documento de venta con anticipo aplicado, se elimina el anticipo para que no sea incoherente.');
      AddLog('JAV',2,'   - Al generar un documento para un nuevo anticipo de cliente se informa en el documento de la fecha del documento para evitar errores.');
      AddLog('   ',0,'Comparativos de ofertas:');
      AddLog('JAV',1,'   - Se reordenan mejor las columnas de la lista de comparativos.');
      AddLog('JAV',1,'   - Se mejora el manejo de la partida presupuestaria en la cabecera y en las l¡neas del comparativo.');
      AddLog('JAV',1,'   - Para proyectos de Presupuesto y de Real Estate se permite cambiar el proyecto en las l¡neas del comparativo, para disponer de pedidos multiproyecto.');

      AddVer(mRE,'1.00.01',20200415D);
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Se a¤aden los anticipos a proyectos de Real Estate.');

      AddVer(mQPR,'1.00.08',20200415D);
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Se a¤aden los anticipos a proyectos de Presupuesto.');

      //{--- V00163 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.25',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Usaba la fecha de medici¢n como fecha de certificaci¢n al registrarlas, se cambia para que use la fecha correcta.');
      AddLog('JAV',2,'   - Al registrar partes de trabajo daba un error con la dimensi¢n del proyecto de desviaciones asociado al recurso.');
      AddLog('JAV',2,'   - Se corrige un error con las retenciones en los ficheros de l¡neas de devoluci¢n a proveedores y de recepci¢n desde clientes.');

      AddVer(mQSII,'1.06.03',20200415D);
      AddLog('   ',0,'Documentos:');
      AddLog('JAV',1,'   - Se a¤ade en la pantalla del documento el pa¡s del cliente o proveedor como referencia.');
      AddLog('JAV',2,'   - En la descripci¢n del r‚gimen especial siempre sacaba la de ventas, aunque fueran documentos de compra.');

      //{--- V00164 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.26',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',2,'   - Se a¤ade en la configuraci¢n de QuoBuilding una opci¢n para marcar la empresa como de pruebas, esto desactiva el SII autom ticamente.');

      AddVer(mQSII,'1.06.04',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade en la pantalla de configuraci¢n un bot¢n para Activar/Desactivar las colas de proyecto relacionadas con el QuoSII. Si no existen se crean antes de activarlas.');

      //{--- V00165 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.27',20200415D);
      AddLog('   ',0,'Presupuestos de proyectos operativos:');
      AddLog('JAV',1,'   - Al recalcular el presupuesto sin reestimaci¢n, cuando la unidad de obra estaba producida al 100% retornaba como importe cero, se cambia para que sea el total producido.');
      AddLog('   ',0,'Aprobaciones y movimientos:');
      AddLog('JAV',1,'   - Se a¤aden dos columnas para el c¢digo y nombre del cliente o proveedor en las pantallas de aprobaciones.');
      AddLog('JAV',1,'   - Se a¤ade el nombre del cliente en la pantalla de movimientos de clientes.');
      AddLog('JAV',1,'   - Se a¤ade el nombre del proveedor en la pantalla de movimientos de proveedores.');
      AddLog('   ',0,'BI:');
      AddLog('JAV',1,'   - Se a¤aden nuevos objetos para el manejo del BI.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de definir circuitos de aprobaci¢n por departamento (se usa en las aprobaciones de Remesas de Pagos).');
      AddLog('JAV',1,'   - Se hace no editable el precio de coste en la pantalla de salidas de existencias para evitar discrepancias.');
      AddLog('JAV',1,'   - Se ajustan permisos de algunos objetos.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Si solo exist¡a un registro en la tabla de clasificaci¢n de proyectos, se produc¡a un error al buscar el contador asociado.');

      AddVer(mQSII,'1.06.05',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se mejora la verificaci¢n de no activar simult neamente el SII est ndar y QuoSII.');
      AddLog('JAV',1,'   - Se hacen editables/visibles correctamente los campos del QuoSII en los abonos de venta.');

      AddVer(mQS,'1.00.04',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se ajustan permisos de algunos objetos.');

      //{--- V00166 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.28',20200415D);
      AddLog('   ',0,'Recircular documentos en cartera como factura:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de recircular en remesas y ¢rdenes de pago documentos de tipo factura en lugar de solo de tipo efecto.');
      AddLog('JAV',1,'   - Ser  la forma de pago original o la nueva la que indique si se generar n facturas o efectos en el nuevo documento.');
      AddLog('   ',0,'Retenciones:');
      AddLog('JAV',1,'   - Se a¤ade la columna del tipo de documento que ha generado la retenci¢n, factura o abono.');
      AddLog('JAV',1,'   - Se cambian los importes, las facturas siempre en positivo y los abonos siempre en negativo, independientemente de que sean retenciones de cliente o de proveedor.');
      AddLog('JAV',1,'   - Se permite liquidar las retenciones usando formas de pago que generen facturas a cartera en lugar de siempre generar efecto.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se arregla un error menor en los cambios de versi¢n del programa.');

      //{--- V00167 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.29',20200415D);
      AddLog('   ',0,'Vista previa de registro:');
      AddLog('JAV',1,'   - Se a¤aden los documentos en cartera que se van a crear en la vista previa de registro de cualquier diario o documento.');
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de aprobaciones por usuarios definidos en la propia plantilla de aprobaci¢n, por lo que no dependen del proyecto o del departamento.');
      AddLog('JAV',1,'   - Se mejora la pantalla de manejo de aprobaciones, se incluye el tipo a usar en cada aprobaci¢n, controlando mejor la coherencia de los datos registrados');
      AddLog('JAV',1,'   - Se a¤ade la aprobaci¢n de anticipos de proyecto a clientes o proveedores.');
      AddLog('   ',0,'Anticipos de proyecto para clientes y proveedores:');
      AddLog('JAV',1,'   - Se cambia el sistema de generaci¢n de anticipos a clientes y proveedores para los proyectos para que sea m s flexible.');
      AddLog('JAV',1,'   - Se a¤aden dos estados, borrador y registrado en los nuevos anticipos. Se pueden editar los anticipos antes de registrarlos las veces necesarias.');
      AddLog('JAV',1,'   - Se a¤ade una tabla de tipos de anticipo para quitar la limitaci¢n de que solo sean por materiales o por subcontratas. En esta tabla se configura el texto de registro.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de aprobar los anticipos, lanzarlos, volverlos a abrir, hasta el momento en que se registre la factura o se cree el efecto asociado.');
      AddLog('JAV',1,'   - Se a¤ade la vista previa de registro en la pantalla de edici¢n de los anticipos para los de tipo efecto.');
      AddLog('JAV',1,'   - Si no se indica forma de pago en la configuraci¢n para anticipos, se emplea la propia del cliente o proveedor.');
      AddLog('JAV',2,'   - Se soluciona un error de consistencia al generar los anticipos sin factura.');
      AddLog('JAV',2,'   - Se soluciona un error al sacar la lista de anticipos cuando solo estaban activos los anticipos de proveedor y no los de cliente.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Al cambiar el banco de cobro en documentos de compra registrados no se actualizaban bien los datos del documento.');
      AddLog('JAV',2,'   - Al registrar una remesa u orden de pago no se actualizan siempre los datos del documento con el banco real al que se ha llevado el cobro o pago.');

      AddVer(mQSII,'1.06.06',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',1,'   - Se corrige un error cuando el documento est  marcado como no subir al SII .');
      AddLog('JAV',1,'   - Se corrige un error al crear autom ticamente los datos auxiliares para facturas recibidas del tipo 14.');

      //{--- V00168 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.30',20200415D);
      AddLog('   ',0,'Mejora de Almac‚n:');
      AddLog('JAV',1,'   - Se cambia por completo el sistema de c lculo de los precios de productos en el almac‚n para que funcione siempre de la forma m s adecuada.');
      AddLog('JAV',1,'   - Por compatibilidad  con la versi¢n anterior, se a¤ade en Configuraci¢n de Compras y Pagos un campo para activar la nueva funcionalidad.');
      AddLog('   ',0,'Mejora de rendimiento:');
      AddLog('JAV',1,'   - Se a¤aden nuevas claves para que las pantallas funcionen m s r pidamente.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade el importe del parte de trabajo en la pantalla del hist¢rico.');
      AddLog('JAV',1,'   - Se eliminan registros no existentes en la pantalla de aprobaciones.');

      //{--- V00169 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.31',20200415D);
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade un nuevo tipo de aprobaci¢n por usuarios, estos se definen directamente en la plantilla de aprobaci¢n, en este tipo los cargos son opcionales y solo informativos');
      AddLog('JAV',1,'   - La aprobaci¢n por usuarios no depende del proyecto, partida/U.O. o departamento, por tanto, se debe seleccionar siempre la plantilla a usar manualmente.');
      AddLog('JAV',1,'   - Se mejora el asistente de configuraci¢n de aprobaciones para indicar para cada tipo de documento a aprobar el tipo de la plantilla (Proyecto/Departamento/Usuario).');
      AddLog('   ',0,'Anticipos de proyecto para clientes y proveedores:');
      AddLog('JAV',1,'   - Se mejora el manejo de los anticipos a clientes y proveedores para los proyectos para que sea m s est ndar, se pueden crear, modificar y eliminar como cualquier otro registro.');
      AddLog('JAV',1,'   - Se mejora el manejo de las aprobaciones de los anticipos.');
      AddLog('JAV',1,'   - Se a¤ade la posibilidad de indicar un n£mero de documento (como puede ser un pedido de compra o una referencia del cliente) sobre el que se solicita el anticipo.');
      AddLog('JAV',1,'   - Se filtran la lista de circuitos de aprobaci¢n para que sean de documento de tipo anticipo.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade permisos para los nuevos objetos.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',1,'   - Se corrige que al recircular efectos como facturas daba error de n£mero duplicado.');
      AddLog('JAV',1,'   - Al recircular efectos como facturas usaba la cuenta general en lugar la cuenta de confirming cuando la forma de pago tiene marcado usar cuenta de confirming.');

      //{--- V00170 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.32',20200415D);
      AddLog('   ',0,'B.I.:');
      AddLog('JAV',1,'   - Se cambian consultas y se renumeran objetos relacionados con el Business Inteligence.');

      //{--- V00171 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.33',20200415D);
      AddLog('   ',0,'Anticipos de proyecto para clientes y proveedores:');
      AddLog('JAV',1,'   - Se mejora la tabla de tipos de anticipo, a¤adiendo el tipo de documento a tratar y si es obligatorio indicarlo.');
      AddLog('JAV',1,'   - Se cambian nombres de campos en la pantalla de anticipo, se mejora el manejo del n£mero de documento sobre el que aplicar.');
      AddLog('JAV',2,'   - No se inclu¡a en la descripci¢n nunca el nombre del cliente o proveedor, aunque se le hubiese indicado sacarlo.');
      AddLog('   ',0,'Almac‚n:');
      AddLog('JAV',1,'   - Se ajustan permisos para modificar tablas en el nuevo m¢dulo de almac‚n.');
      AddLog('JAV',1,'   - Se ajusta el c lculo de los precios cuando se devuelven productos al almac‚n.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrige un error de permisos con el nuevo m¢dulo de almac‚n.');
      AddLog('JAV',2,'   - Se corrige un error de con las cuentas de confirming definibles por formas de pago.');
      AddLog('JAV',2,'   - Se corrige un error espor dico en el c lculo del presupuesto con las unidades indirectas con c lculo porcentual.');

      AddVer(mQPR,'1.00.09',20200415D);
      AddLog('   ',0,'Se prepara el sistema para la gesti¢n de los gastos activables.');
      AddLog('JAV',1,'   - Se a¤aden checks en la configuraci¢n.');
      AddLog('JAV',1,'   - Se a¤ade el check de si el estado interno del proyecto permite generar los gastos activables.');
      AddLog('JAV',1,'   - Se a¤ade el check de si el proyecto permite generar los gastos activables.');
      AddLog('JAV',1,'   - Se a¤ade el check de si la partida presupuestaria permite generar los gastos activables en plantillas y presupuestos.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se mejora el manejo de las plantillas de presupuestos.');

      AddVer(mRE,'1.00.02',20200415D);
      AddLog('   ',0,'Se prepara el sistema para la gesti¢n de los gastos activables.');
      AddLog('JAV',1,'   - Se a¤aden checks en la configuraci¢n.');
      AddLog('JAV',1,'   - Se a¤ade el check de si el estado interno del proyecto permite generar los gastos activables.');
      AddLog('JAV',1,'   - Se a¤ade el check de si el proyecto permite generar los gastos activables.');
      AddLog('JAV',1,'   - Se a¤ade el check de si la partida presupuestaria permite generar los gastos activables en plantillas y presupuestos.');

      //{--- V00172 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.34',20200415D);
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade el manejo del flujo de trabajo por aprobaciones de documentos vencidas en el asistente de configuraci¢n de aprobaciones.');
      AddLog('JAV',2,'   - Se corrige un error de clave duplicada al crear las notificaciones de aprobaci¢n vencidas cuando varios usuarios est n en el mismo nivel.');
      AddLog('   ',0,'Anticipos de proyecto para clientes y proveedores:');
      AddLog('JAV',2,'   - No traspasaba el estado de aprobaci¢n al documento generado cuando estaba asi indicado en la configuraci¢n.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se cambia el control de no permitir almac‚n negativo del campo propio de Configuraci¢n de QuoBuilding al est ndar ubicado en Configuraci¢n contable de inventario.');
      AddLog('JAV',1,'   - Se mejora el manejo del cambio de dimensi¢n m£ltiple en las unidades de obra y en los descompuestos.');
      AddLog('JAV',1,'   - Se eliminan funciones obsoletas y no utilizadas de aprobaci¢n de pagos de facturas de compra.');

      AddVer(mQPR,'1.00.10',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade la lista de presupuestos archivados.');

      AddVer(mRE,'1.00.10',20200415D);
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade la lista de proyectos inmobiliarios archivados.');
      AddLog('JAV',1,'   - Se a¤aden tablas y p ginas para el BI de Real Estate.');

      //{--- V00173 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.35',20200415D);
      AddLog('   ',0,'Anticipos de proyecto para clientes y proveedores:');
      AddLog('JAV',1,'   - Mejora general del m¢dulo. Se crea una nueva pantalla de configuraci¢n espec¡fica para este');
      AddLog('JAV',1,'   - Se a¤ade un par metro de configuraci¢n para forzar el documento a generar, y de forma paralela se puede establecer en la tabla de tipos de anticipo.');
      AddLog('JAV',1,'   - Se a¤aden filtros en la lista de anticipos para mejorar su manejo. Se a¤ade el nombre del cliente o proveedor.');
      AddLog('JAV',1,'   - Se a¤ade un comentario sobre el anticipo directamente sobre su pantalla, y de forma adicional se a¤aden los Paneles Laterales de notas y adjuntos.');
      AddLog('JAV',1,'   - En el momento de registrar se muestra una pantalla en la que establecer la fecha de registro del documento que se va a generar, por defecto ser  la del d¡a.');
      AddLog('JAV',2,'   - Se corrige un error por el que no eliminaba las l¡neas de totales al eliminar un registro.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se a¤ade en la lista de clientes el campo de "Saldo del periodo (DL)", su importe va en funci¢n del filtro de fechas establecido.');
      AddLog('JAV',1,'   - Se a¤ade en la lista de proyecto operativos y en la de proyectos operativos archivados el campo "Importe de Adjudicaci¢n".');
      AddLog('JAV',1,'   - Se limitan longitudes de campos que pueden producir un error en la carga de la configuraci¢n por defecto que se lanza desde la pantalla de configuraci¢n de QuoBuilding.');
      AddLog('JAV',1,'   - Se elimina el campo "Activable" de la ficha de las unidades de obra pues no se utiliza.');

      AddVer(mMD,'1.00.01', 20200415D);
      AddLog('   ',0,'Proceso de sincronizaci¢n de datos desde la empresa M ster:');
      AddLog('JAV',1,'   - Se a¤aden nuevas columnas y controles a la lista de campos sincronizables de las tablas.');
      AddLog('JAV',1,'   - Se mejora la pantalla de Empresa/Tabla, se ubica siempre primero la empresa Master Data tanto en las filas como en las columnas.');
      AddLog('JAV',2,'   - Se arregla un error por el que no funcionaba siempre la sincronizaci¢n autom tica.');
      AddLog('JAV',2,'   - Se arregla un error por el que no pod¡a renombrar los registros sincronizados correctamente.');

      //{--- V00174 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.36',20200415D);
      AddLog('   ',0,'Filtros por proyecto:');
      AddLog('JAV',1,'   - Se a¤ade filtros para ver documentos a los que el usuario tiene acceso seg£n el proyecto en las pantallas de Hojas de horas y las registradas');
      AddLog('JAV',1,'   - Se a¤ade filtros para ver documentos a los que el usuario tiene acceso seg£n el proyecto en las pantallas de Producci¢n y Certificaci¢n registradas');
      AddLog('JAV',1,'   - Se a¤ade filtros para ver documentos a los que el usuario tiene acceso seg£n el proyecto en la pantalla de Movimientos detallados de proveedores');
      AddLog('   ',0,'Anticipos de proyecto para clientes y proveedores:');
      AddLog('JAV',1,'   - Se filtra que los posibles documentos sobre los que se puede solicitar un anticipo deban estar lanzados.');
      AddLog('JAV',1,'   - Se a¤ade la forma de pago, el tipo de pago y la fecha de vencimiento en la ficha del anticipo a generar.');
      AddLog('JAV',1,'   - Se a¤aden la fecha del documento, el tipo de pago y la fecha de vencimiento en la pantalla para generar el documento del anticipo, tomando por defecto la fecha del d¡a.');
      AddLog('JAV',1,'   - Al generar el documento se traspasan forma de pago, m‚todo de pago y fecha de vencimiento a este.');
      AddLog('JAV',1,'   - Se permite ver el documento del anticipo desde las solicitudes de aprobaci¢n.');
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade en la configuraci¢n la posibilidad de enviar una notificaci¢n al usuario que lanz¢ la aprobaci¢n en el momento en que el documento se ha aprobado.');
      AddLog('JAV',1,'   - Se a¤ade en la lista de cargos una nueva columna que indica que ese cargo por defecto no interviene en las aprobaciones.');
      AddLog('JAV',1,'   - Se a¤ade en el asistente la f¢rmula para el c lculo del vencimiento de las aprobaciones, si no se indica nada vencen el mismo d¡a en que se solicitan.');
      AddLog('JAV',1,'   - Se mejora la creaci¢n autom tica de los flujos de trabajo, a¤adiendo el nuevo plazo de vencimiento de las aprobaciones.');
      AddLog('JAV',2,'   - Se corrige un error por el que al cambiar de nombre un circuito de aprobaci¢n no cambiaba todas sus l¡neas.');
      AddLog('   ',0,'Responsables por proyecto:');
      AddLog('JAV',1,'   - Se a¤ade en la lista de responsables de los proyectos una nueva columna que indica que el usuario no interviene en las aprobaciones.');
      AddLog('JAV',1,'   - Se a¤ade en la lista de responsables de los proyectos un bot¢n para ver como quedan los circuitos de aprobaci¢n con los usuarios del proyecto.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se eliminan entradas de los men£s, pantallas y funciones de sincronizaci¢n que datos que pasan al m¢dulo Master Data.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrige un error al seleccionar el C.A. adecuado en la importaci¢n de los BC3 a los preciarios.');

      AddVer(mMD,'1.00.02', 20200415D);
      AddLog('   ',0,'Proceso de sincronizaci¢n de la configuraci¢n:');
      AddLog('JAV',1,'   - Se traspasa al m¢dulo la funcionalidad de sincronizar la configuraci¢n entre empresas desde la master.');
      AddLog('   ',0,'Proceso de sincronizaci¢n de datos desde la empresa M ster:');
      AddLog('JAV',2,'   - Se elimina un error de recursividad excesiva al crear nuevos registros.');
      AddLog('JAV',2,'   - Se elimina un error que permit¡a intentar sincronizar datos de las tablas desde cualquier empresa que no fuera la master.');

      AddVer(mQPR,'1.00.11',20200415D);
      AddLog('   ',0,'Gastos activables.');
      AddLog('JAV',1,'   - Se a¤ade la p gina de configuraci¢n de Activaci¢n de Gastos.');

      AddVer(mRE,'1.00.11',20200415D);
      AddLog('   ',0,'Gastos activables.');
      AddLog('JAV',1,'   - Se a¤ade la p gina de configuraci¢n de Activaci¢n de Gastos.');

      //{--- V00175 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.37',20200415D);
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se a¤ade en la pantalla de documentos para aprobar el cargo de la persona que debe aprobar.');
      AddLog('JAV',1,'   - Se ampl¡a el env¡o del mail de documento aprobado para m s tipos de documento.');
      AddLog('   ',0,'Otros cambios:');
      AddLog('JAV',1,'   - Se mejora la gesti¢n de los precios medios de compra de los productos para que contemple un nuevo caso.');
      AddLog('JAV',1,'   - Se mejora el proceso de c lculo de la reestimaci¢n para mejorar su rendimiento.');
      AddLog('JAV',1,'   - Se mejora la verificaci¢n de datos correctos en los pedidos de compra para que se lance desde m s lugares.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrige un posible error de RunModal en los comparativos de compras.');

      //{--- V00176 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.38',20200415D);
      AddLog('   ',0,'Cancelaci¢n de albaranes de compra:');
      AddLog('JAV',1,'   - Se reordena la pantalla y se a¤aden el usuario y la fecha en que se cancel¢ el albar n, y la fecha con la que se cancel¢.');
      AddLog('JAV',2,'   - Se corrige un error por el que no usaba la fecha informada de cancelaci¢n del albar n al cancelar las l¡neas.');


      AddVer(mMD,'1.00.03', 20200415D);
      AddLog('   ',0,'Proceso de sincronizaci¢n de datos desde la empresa M ster:');
      AddLog('JAV',1,'   - Se a¤ade el tratamiento de las dimensiones por defecto de las tablas maestras.');
      AddLog('JAV',2,'   - Se ampl¡an las longitudes de los campos relacionados con nombres de tablas para evitar error de desbordamiento.');

      //{--- V00177 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.39',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade en la planificaci¢n temporal de las unidades de obra un bot¢n para ajustar todas las l¡neas con diferencias menores de 2 c‚ntimos.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrige un error por el que no indicaba la cantidad en el diario de productos al ajustar las existencias.');

      AddVer(mRE,'1.00.12',20200415D);
      AddLog('   ',0,'Vendedores y Compradores.');
      AddLog('JAV',1,'   - Se a¤aden campos en la tabla para los datos de la persona.');
      AddLog('JAV',1,'   - Se a¤ade la tabla de siglas de la calle.');

      //{--- V00178 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.40',20200415D);
      AddLog('   ',0,'Retenciones:');
      AddLog('JAV',1,'   - La liberaci¢n de las retenciones no sube al SII Est ndar de Navision ni al QuoSII.');
      AddLog('   ',0,'Comparativos:');
      AddLog('JAV',1,'   - Se a¤ade en la configuraci¢n un par metro que indica si al generar el pedido desea pasar la cantidad y el precio o el total con cantidad 1.');
      AddLog('JAV',1,'   - Se a¤ade en el comparativo un campo con el dato anterior, que se puede cambiar para ese que indica si al generar el pedido desea pasar la cantidad y el precio o el total con cantidad 1.');
      AddLog('JAV',1,'   - Se a¤ade en el comparativo el usuario que lo ha creado.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se eliminan funciones no usadas para la anterior sincronizaci¢n entre empresas.');
      AddLog('JAV',1,'   - Se a¤aden campos en querys para su uso con el BI.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('PSM',2,'   - Se pone el usuario correcto que ha rechazado la aprobaci¢n en lugar del £ltimo usuario de la cadena.');

      AddVer(mQSII,'1.06.07',20200415D);
      AddLog('   ',0,'Cobros y pagos del R‚gimen Especial de Criterio de Caja (RECC):');
      AddLog('JAV',1,'   - Se capturan correctamente los cobros y pagos desde cartera de facturas emitidas con el RECC.');
      AddLog('JAV',1,'   - Cuando desde un diario de indica la factura que se cobra o se paga, se informa en la l¡nea del diario el r‚gimen especial de dicha factura.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se permite cambiar la entidad en la cabecera cuando el documento tiene l¡neas, cambi ndolo en todas ellas si es necesario.');
      AddLog('JAV',1,'   - No se sube al SII los efectos creados al liberar una retenci¢n de cobro o de pago por garant¡a.');
      AddLog('JAV',1,'   - En los cobros de las certificaciones para Administraciones P£blicas (tipo C-14) la fecha de operaci¢n es la del cobro, no la de vencimiento original.');
      AddLog('JAV',1,'   - Se permite eliminar l¡neas en estado CORRECTO cuando no han sido enviadas (env¡o A1 de documentos C-14).');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('PSM',2,'   - No se hac¡a el desglose correcto cuando la factura era de Bienes o Servicios.');
      AddLog('JAV',2,'   - Se corrige un error por el que no rellenaba siempre las l¡neas de documentos con IVA exento.');
      AddLog('JAV',2,'   - Se corrige un error por el que no generaba los env¡os de pagos de certificaciones desde la cola de proyectos.');

      AddVer(mRE,'1.00.13',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤aden campos y tablas para igualar QuoBuilding con el m¢dulo de gesti¢n de los proyectos inmobiliarios.');

      AddVer(mQPR,'1.00.13',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤aden campos y tablas para igualar QuoBuilding con el m¢dulo de gesti¢n de presupuestos.');

      AddVer(mMD,'1.00.04', 20200415D);
      AddLog('   ',0,'Proceso de sincronizaci¢n de datos desde la empresa M ster:');
      AddLog('JAV',1,'   - Mejoras en el tratamiento de las dimensiones.');
      AddLog('JAV',1,'   - No se sincronizan campos auto-incrementales en las modificaciones de campos.');


      //{--- V00179 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.41',20200415D);
      AddLog('   ',0,'Env¡o Interno de facturas de venta:');
      AddLog('APC',1,'   - Se a¤ade la posibilidad de enviar de manera autom tica o manual un mail interno al registrar una factura o un abono de venta.');
      AddLog('JAV',1,'   - Se mejora la configuraci¢n del proceso y se a¤ade la posibilidad de enviar el cuerpo en HTML con un formato configurable.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se cambian los textos en ingl‚s err¢neos asociados a la tabla de usuarios.');
      AddLog('JAV',1,'   - Al cambiar en el diario de producci¢n los importes se calculan los complementarios y los campos en divisas.');
      AddLog('PGA',1,'   - Se a¤aden formatos de impresi¢n de pagar‚s en papel para impresi¢n l ser.');

      //{--- V00180 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.42',20200415D);
      AddLog('   ',0,'Lista de presupuestos de las obras:');
      AddLog('JAV',1,'   - IMPORTANTE: Para mejorar la velocidad se presenta solo el presupuesto activo del proyecto, pero se a¤aden botones para ver todos o solo el activo.');
      AddLog('   ',0,'Indirectos Porcentuales o Periodificables:');
      AddLog('JAV',1,'   - Al indicar un porcentaje distinto de cero se recalculan los importes de medici¢n y coste, y se ha a¤adido una columna con el importe base del c lculo, que ser  el importe de producci¢n.');
      AddLog('JAV',1,'   - Si se indica la medici¢n con el porcentaje a cero, se establece con fecha de inicio del proyecto y se calcula el nuevo importe de coste.');
      AddLog('JAV',1,'   - Se ha cambiado el sistema de c lculo de los indirectos porcentuales, ahora se calculan sobre el total del proyecto siempre, y el pendiente es siempre el total.');
      AddLog('JAV',1,'   - Se ha cambiado el nombre de la opci¢n de c lculo del diario de periodificables a "Calcular Indirectos Porcentuales".');
      AddLog('JAV',1,'   - En el proceso de c lculo, al informar de la fecha se rellena el n£mero de documento con el mes y a¤o, y se han cambiado los textos de registro para que sean m s informativos.');
      AddLog('JAV',1,'   - Tras el proceso de c lculo se presenta el diario generado para su revisi¢n y registro.');
      AddLog('   ',0,'Regularizaci¢n de stocks:');
      AddLog('CMS',1,'   - Se muestra la columna de CONCEPTO ANALÖTICO en las l¡neas.');
      AddLog('CMS',1,'   - Se deja en blanco la unidad de obra para que se informe obligatoriamente, en lugar de usar la configurada para el almac‚n.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se mejora el diario de la Obra en curso, informando una cantidad se calcula la complementaria, y se calculan los datos en divisas correctamente.');
      AddLog('JAV',1,'   - Se a¤aden campos y tablas para igualar QuoBuilding con el m¢dulo de gesti¢n de presupuestos y de Real Estate.');

      AddVer(mRE,'1.00.14',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤aden campos y tablas para igualar QuoBuilding con el m¢dulo de gesti¢n de los proyectos inmobiliarios.');

      AddVer(mQPR,'1.00.14',20200415D);
      AddLog('   ',0,'Partidas presupuestarias');
      AddLog('JAV',1,'   - Se puede a¤adir a cada partida presupuestaria uno o varios responsables de esta.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤aden campos y tablas para igualar QuoBuilding con el m¢dulo de gesti¢n de presupuestos.');

      //{--- V00181 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.43',20200415D);
      AddLog('   ',0,'Indirectos Porcentuales o Periodificables:');
      AddLog('JAV',2,'   - Al indicar el importe del gasto con porcentaje cero no siempre hac¡a el rec lculo correcto.');
      AddLog('   ',0,'Pantallas de compras:');
      AddLog('JAV',1,'   - Se a¤aden campos nuevos para el proyecto y la partida de aprobaci¢n, de forma que seanindepenientes de los indicados para el registro.');
      AddLog('JAV',1,'   - Se cambian las columnas en las l¡neas de los documentos de compra para que sea un poco mas sencillo de manejar, hay que restaurar las columnas predeterminadas para ver el cambio.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade una nueva clave para acelerar los procesos de c lculo de presupuestos.');
      AddLog('DGG',1,'   - En las pantallas donde se solicitan una aprobaci¢n el bot¢n para solicitarla solo estar  activo si el documento est  abierto.');
      AddLog('JAV',1,'   - Se a¤aden campos y tablas para igualar QuoBuilding con el m¢dulo de gesti¢n de presupuestos y de Real Estate.');

      AddVer(mRE,'1.00.15',20200415D);
      AddLog('   ',0,'Pantallas de compras:');
      AddLog('JAV',1,'   - Se a¤aden campos nuevos en cabecera para el proyecto y la partida de aprobaci¢n, de forma que sean independientes de los indicados para el registro.');
      AddLog('JAV',1,'   - Se cambian las columnas en las l¡neas de los documentos de compra para que sea un poco mas sencillo de manejar, hay que restaurar las columnas predeterminadas para ver el cambio.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤aden campos y tablas para igualar QuoBuilding con el m¢dulo de gesti¢n de los proyectos inmobiliarios.');

      AddVer(mQPR,'1.00.15',20200415D);
      AddLog('   ',0,'Pantallas de compras:');
      AddLog('JAV',1,'   - Se a¤aden campos nuevos para el proyecto y la partida de aprobaci¢n, de forma que sean indepenientes de los indicados para el registro.');
      AddLog('JAV',1,'   - Se cambian las columnas en las l¡neas de los documentos de compra para que sea un poco mas sencillo de manejar, hay que restaurar las columnas predeterminadas para ver el cambio.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤aden campos y tablas para igualar QuoBuilding con el m¢dulo de gesti¢n de presupuestos.');

      AddVer(mMD,'1.00.05', 20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade en el men£ el log de cambios de la sincronizaci¢n.');
      AddLog('JAV',1,'   - Si el registro existe en la empresa de destino, pero no en la master, guardar en el log y dar un mensaje de aviso.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - No procesar campos marcados como no activos o marcados como obsoletos en ning£n lugar del m¢dulo.');

      //{--- V00182 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.44',20200415D);
      AddLog('   ',0,'C lculo del presupuesto del proyecto:');
      AddLog('JAV',1,'   - Se a¤aden claves y mejoras generales para acelerar los procesos de c lculo de presupuestos.');
      AddLog('JAV',1,'   - Se a¤ade en la lista de presupuestos un nuevo bot¢n ubicado en el panel NAVEGAR para agrupar datos por fechas, as¡ los procesos ser n un poco m s r pidos.');
      AddLog('   ',0,'Movimientos de clientes y proveedores:');
      AddLog('JAV',1,'   - Se guarda la partida presupuestaria asociada al documento de compra o venta registrado.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se mejora la ficha de las unidades de obra para que solo se vean campos seg£n si es una unidad directa o indirecta.');
      AddLog('JAV',1,'   - En la vista previa del registro de facturas se elimina el mensaje "se ha solicitado aprobaci¢n" cuando estaba activa la aprobaci¢n de pagos.');

      //{--- V00183 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.45',20200415D);
      AddLog('   ',0,'Comparativos de ofertas:');
      AddLog('JAV',1,'   - El campo de Tipo de comparativo (producto, recurso o mixto) se establece autom ticamente en funci¢n de las l¡neas.');
      AddLog('JAV',1,'   - Se a¤aden campos nuevos para el proyecto y la partida de aprobaci¢n, de forma que sean independientes de los indicados para la l¡nea.');
      AddLog('JAV',1,'   - Al generar el contrato se respeta el proyecto y las dimensiones establecidas en la l¡nea del comparativo.');
      AddLog('   ',0,'Pantallas de compras:');
      AddLog('JAV',1,'   - Se mejora el tratamiento de los pedidos que van contra almac‚n y por tanto no se indica el proyecto en cabecera o l¡neas.');
      AddLog('JAV',1,'   - Se mejora el tratamiento de los campos relacionados con dimensiones que se establecieron en la versi¢n 1.10.43.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se elimina el cambio de versi¢n autom tico que produc¡a bloqueos no necesarios.');
      AddLog('DGG',1,'   - Se elimina el mensaje de confirmaci¢n al borrar una unidad de obra de mayor para eliminar todas las de trabajo relacionadas.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un problema por el que no se marcaba el circuito de aprobaci¢n en los pagos cuando se establece la aprobaci¢n manual.');
      AddLog('JAV',2,'   - Se soluciona un problema por el que necesitaba tener informado el proyecto en pedidos contra almac‚n.');
      AddLog('DGG',2,'   - Se soluciona un problema por el que no se traspasaban correctamente las aprobaciones del comparativo al contrato generado o del anticipo a la factura.');
      AddLog('AML',2,'   - Se soluciona un problema por el que cambiaba el signo en los registros hist¢ricos de salidas del almac‚n de obra.');

      AddVer(mRE,'1.00.16',20200415D);
      AddLog('   ',0,'Comparativos de ofertas:');
      AddLog('JAV',1,'   - El campo de Tipo de comparativo (producto, recurso o mixto) se establece autom ticamente en funci¢n de las l¡neas.');
      AddLog('JAV',1,'   - Se a¤aden campos nuevos para el proyecto y la partida de aprobaci¢n, de forma que sean independientes de los indicados para la l¡nea.');
      AddLog('JAV',1,'   - Al generar el contrato se respeta el proyecto y las dimensiones establecidas en la l¡nea del comparativo.');
      AddLog('   ',0,'Pantallas de compras:');
      AddLog('JAV',1,'   - Se mejora el tratamiento de los pedidos que van contra almac‚n y por tanto no se indica el proyecto en cabecera o l¡neas.');
      AddLog('JAV',1,'   - Se mejora el tratamiento de los campos relacionados con dimensiones que se establecieron en la versi¢n 1.10.43.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('DGG',1,'   - Se elimina el mensaje de confirmaci¢n al borrar una unidad de obra de mayor para eliminar todas las de trabajo relacionadas.');

      AddVer(mQPR,'1.00.16',20200415D);
      AddLog('   ',0,'Comparativos de ofertas:');
      AddLog('JAV',1,'   - El campo de Tipo de comparativo (producto, recurso o mixto) se establece autom ticamente en funci¢n de las l¡neas.');
      AddLog('JAV',1,'   - Se a¤aden campos nuevos para el proyecto y la partida de aprobaci¢n, de forma que sean independientes de los indicados para la l¡nea.');
      AddLog('JAV',1,'   - Al generar el contrato se respeta el proyecto y las dimensiones establecidas en la l¡nea del comparativo.');
      AddLog('   ',0,'Pantallas de compras:');
      AddLog('JAV',1,'   - Se mejora el tratamiento de los pedidos que van contra almac‚n y por tanto no se indica el proyecto en cabecera o l¡neas.');
      AddLog('JAV',1,'   - Se mejora el tratamiento de los campos relacionados con dimensiones que se establecieron en la versi¢n 1.10.43.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('DGG',1,'   - Se elimina el mensaje de confirmaci¢n al borrar una unidad de obra de mayor para eliminar todas las de trabajo relacionadas.');

      //{--- V00184 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.46',20200415D);
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Se hace no editable las l¡neas de la lista de anticipos, se deben modificar por su ficha antes de registrar.');
      AddLog('JAV',2,'   - Se corrige un error por el que no informaba del importe aplicado del anticipo en Divisa Local.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade el c¢digo del proyecto en el mail de notificaci¢n de aprobaciones, tras el importe a aprobar.');
      AddLog('JAV',1,'   - Se elimina el campo de configuraci¢n "Departamento para Labor" que no se utiliza.');
      AddLog('JAV',1,'   - Se a¤ade en los Partes de Coste Indirecto y en su hist¢rico el importe total del parte.');
      AddLog('JAV',1,'   - Se a¤aden algunas claves auxiliares para mejorar la velocidad del SQL.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un problema por el que al abrir la ficha de un producto cerraba el programa.');

      AddVer(mQSII,'1.06.08',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade en la pantalla de configuraci¢n del QuoSII enlaces a todas las tablas que se deben configurar.');

      AddVer(mRE,'1.00.17',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se corrige el texto err¢neo en la columna "Realizado" en los proyectos inmobiliarios.');

      AddVer(mQPR,'1.00.17',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se corrige el texto err¢neo en la columna "Realizado" en los Presupuestos.');

      //{--- V00185 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.47',20200415D);
      AddLog('   ',0,'Comparativos:');
      AddLog('JAV',1,'   - Se a¤ade un campo con el estado actual que puede ser: En proceso, Proveedor seleccionado, Aprobado/Lanzado, Generado contrato o Cerrado.');
      AddLog('JAV',1,'   - Por defecto en la lista de comparativos aparecen los que est‚n en proceso, se a¤aden listas para Comparativos Generados y Comparativos Cerrados');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n para poder marcar el comparativo como Cerrado, no se va a generar contrato y no se va a trabajar con ‚l. Esto libera las cantidades de contratos marco.');
      AddLog('JAV',1,'   - La acci¢n de volver a abrir quita la marca de Cerrado y lo retorna al estado anterior.');
      AddLog('JAV',1,'   - Se revisa el hacer no editables los campos y no activos los botones seg£n el estado del comparativo.');
      AddLog('JAV',1,'   - Al generar el contrato, se valida que si se emplea un contrato marco est‚ vigente y con cantidad disponible si la tiene limitada.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade en Configuraci¢n Quobuilding un bot¢n para revisar proyectos, establece correctamente la dimensi¢n "Proyecto" para este.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un problema por el que al informar de una unidad de obra con un recurso de subcontrataci¢n asociado daba un error de desbordamiento de memoria.');

      AddVer(mRE,'1.00.18',20200415D);
      AddLog('   ',0,'Comparativos y compras:');
      AddLog('JAV',1,'   - Para l¡neas asociadas a un proyecto de Presupuesto, al indicar la partida presupuestaria se rellenan los datos asociados.');
      AddLog('JAV',1,'   - Se a¤ade el men£ de Compras.');
      AddLog('JAV',1,'   - Por defecto en la lista de comparativos aparecen los que est‚n en proceso, se a¤aden listas para Comparativos Generados y Comparativos Cerrados');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade en Configuraci¢n de Proyectos Inmobiliarios un bot¢n para revisar proyectos, establece correctamente la dimensi¢n "Proyecto" para este.');
      AddLog('JAV',1,'   - Se mejora el manejo de la lista de Partidas presupuestarias con los campos apropiados.');

      AddVer(mQPR,'1.00.18',20200415D);
      AddLog('   ',0,'Comparativos y compras:');
      AddLog('JAV',1,'   - Para l¡neas asociadas a un proyecto de Real Estate, al indicar la partida presupuestaria se rellenan los datos asociados.');
      AddLog('JAV',1,'   - Se a¤ade el men£ de Compras.');
      AddLog('JAV',1,'   - Por defecto en la lista de comparativos aparecen los que est‚n en proceso, se a¤aden listas para Comparativos Generados y Comparativos Cerrados');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade en Configuraci¢n de presupuestos un bot¢n para revisar proyectos, establece correctamente la dimensi¢n "Proyecto" para este.');
      AddLog('JAV',1,'   - Se mejora el manejo de la lista de Partidas presupuestarias con los campos apropiados.');

      //{--- V00186 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mSP,'1.02',20200415D);
      AddLog('   ',0,'Drag&Drop:');
      AddLog('JAV',1,'   - Se mejora las condiciones para ver los paneles de SharePoint si no est  definida la configuraci¢n de la tabla asociada a la p gina.');
      AddLog('JAV',1,'   - Se revisa para las fichas de clientes y proveedores.');
      AddLog('JAV',1,'   - Se revisa para las fichas de Facturas de venta y Facturas de venta registradas.');
      AddLog('JAV',1,'   - Se revisa para las fichas de Facturas de compra.');

      //{--- V00187 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.49',20200415D);
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Cuando se accede a un documento con anticipo aplicado, se da un mensaje del importe aplicado en lugar de ir a la aplicaci¢n nuevamente.');
      AddLog('JAV',1,'   - Se mejora el manejo de los anticipos, ahora las aplicaciones se pueden realizar indicando individualmente a que anticipo se aplica, en lugar de por totales.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n en la lista de anticipos, pesta¤a navegar, para permitir cancelar anticipos total o parcialmente.');
      AddLog('JAV',1,'   - Como el tratamiento de aplicaciones y cancelaciones es por documento, tambi‚n las descripciones se hacen por cada l¡nea que se aplique o cancele.');
      AddLog('   ',0,'Retenciones:');
      AddLog('JAV',1,'   - Se mejora el manejo del campo del nombre del cliente o proveedor para que se pueda ordenar y filtrar.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('AML',1,'   - Se cambia la fecha por defecto al crear mediciones de unidades de obra para que use la de trabajo en lugar de la del sistema.');
      AddLog('JAV',1,'   - Se a¤ade la fecha de recepci¢n en las listas de facturas y abonos de compra sin registrar.');
      AddLog('JAV',1,'   - Se a¤aden campos en las consultas para su manejo por el BI.');
      AddLog('JAV',1,'   - Se mejora el manejo de la lista de Unidades de Obras o de Partidas presupuestarias con los campos apropiados.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un problema por el daba un posible error al intentar insertar albaranes en una factura o al pedir las dimensiones de la l¡nea.');
      AddLog('JAV',2,'   - Se soluciona un problema de desbordamiento al seleccionar muchas actividades en un comparativo.');
      AddLog('JAV',2,'   - Se soluciona un problema por el que no filtraba el presupuesto actual en la pantalla de datos de mediciones.');
      AddLog('JAV',2,'   - Se soluciona un problema por el que no presentaba el documento adjunto en la pantalla de aprobaci¢n.');
      AddLog('JAV',2,'   - Se soluciona un problema por el que daba un error incorrecto cuando no existe un usuario en las cadenas de aprobaci¢n.');
      AddLog('JAV',2,'   - Se soluciona un problema por el que daba un error incorrecto al facturar albaranes de compra.');

      AddVer(mQSII,'1.06.09',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade en la pantalla de configuraci¢n del QuoSII enlace a la configuraci¢n del SMTP.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un problema con la fecha de registro de los pagos por Criterio de Caja.');
      AddLog('JAV',2,'   - Se soluciona un problema por el que guardaba mal algunos campos en el hist¢rico de abonos de compra.');
      AddLog('PSM',2,'   - Se soluciona un problema por el que no se pod¡a volver a enviar un documento parcialmente correcto.');

      //{--- V00188 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.50',20200415D);
      AddLog('   ',0,'Comparativos y compras:');
      AddLog('JAV',1,'   - Al cambiar el proyecto en las l¡neas, si en el nuevo no existe la unidad de obra esta se deja en blanco para evitar incoherencias.');
      AddLog('JAV',1,'   - Se a¤ade un check en la configuraci¢n de QuoBuilding para indicar si se desea que al buscar un proyecto aparezcan por defecto los del mismo tipo al actual (QB/RE/CECO).');
      AddLog('JAV',2,'   - Al registrar documentos de compra contra almac‚n se controla mejor que la l¡nea y la cabecera no tengan informado el proyecto, aunque se indique como valor de dimensi¢n.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Al registrar facturas de compra y de venta, se lleva al movimiento contable la Unidad de Obra/Partida presupuestaria asociada a la l¡nea del documento.');

      //{--- V00189 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.51',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - En las p ginas "Doc. Pendientes en Remesas de Cobro" y "Doc. Pendientes en O. Pago" se a¤ade la columna banco, se marca los vencidos en rojo y se a¤aden botones para ver solo vencidos o todos.');
      AddLog('JAV',1,'   - El proceso de impresi¢n permite seleccionar entre varios Layout para los informes que se lancen desde el selector de informes de QuoBuilding.');
      AddLog('JAV',1,'   - Nuevo informe para comparar lo imputado en facturas de compra y lo imputado de las mismas a los proyectos.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un problema con el grupo registro al informar en l¡neas de compra del proyecto y la unidad de obra.');

      AddVer(mRE,'1.00.19',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un problema con el grupo registro al informar en l¡neas de compra del proyecto y la unidad de obra.');

      AddVer(mQPR,'1.00.19',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un problema con el grupo registro al informar en l¡neas de compra del proyecto y la unidad de obra.');

      //{--- V00190 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.52',20200415D);
      AddLog('   ',0,'Productos prestados:');
      AddLog('EPV',1,'   - Para los productos en dep¢sito o prestados por el cliente, se cambia la forma de calcular el precio para que refleje el precio medio del producto, no queda a cero.');
      AddLog('EPV',1,'   - Esta funcionalidad se activa desde la configuraci¢n de QuoBuilding, y dispone de un nuevo campo en los productos para informar del precio inicial de estos productos.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Nuevo informe ÊSituaci¢n de proveedoresË, proporciona los saldos pendientes de albaranes, facturas, etc.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un problema por el que pod¡a cambiar el recurso al pasar de comparativo a contrato.');
      AddLog('JAV',2,'   - Se soluciona un problema por el que los importes a PEC de las certificaciones no siempre eran correctos.');
      AddLog('JAV',2,'   - Se soluciona un error en la clave de la tabla al cargar los responsables de un proyecto.');
      AddLog('AML',2,'   - Se soluciona un error al registrar movimientos de proyecto desde productos del almac‚n.');

      AddVer(mRE,'1.00.20',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Nuevo informe ÊSituaci¢n de proveedoresË, proporciona los saldos pendientes de albaranes, facturas, etc.');

      AddVer(mQPR,'1.00.20',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Nuevo informe ÊSituaci¢n de proveedoresË, proporciona los saldos pendientes de albaranes, facturas, etc.');

      //{--- V00191 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.53',20200415D);
      AddLog('   ',0,'Producci¢n:');
      AddLog('JAV',1,'   - En las relaciones valoradas se incluyen columnas informativas para Precio, Importe del periodo e Importe a Origen a PEM y PEC.');

      //{--- V00192 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mDP,'1.00.00',20200415D);
      AddLog('   ',0,'Prorrata de IVA (Consulte con su comercial si necesita su implementaci¢n):');
      AddLog('JAV',1,'   - Se a¤ade un nuevo m¢dulo a QuoBuilding para el manejo de la prorrata de IVA en facturas de compra.');
      AddLog('JAV',1,'   - Operativo en primera fase: Gesti¢n de la prorrata en las facturas y abonos de compra, su registro contable y su subida al SII/QuoSII.');
      AddLog('JAV',1,'   - En desarrollo la segunda fase: Cierre del ejercicio, c lculo y registro de la prorrata definitiva, apertura del nuevo a¤o.');

      //{--- V00193 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.54',20200415D);
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se completan los cambios en el desarrollo de las aprobaciones por departamento para adaptarlas a las nuevas aprobaciones.');
      AddLog('JAV',1,'   - Se a¤ade una tabla de departamentos de la organizaci¢n para separarla de la dimensi¢n departamento que permanece para su manejo en la parte financiera.');
      AddLog('JAV',1,'   - Se a¤ade un bot¢n en el asistente de configuraci¢n de aprobaciones para manejar los departamentos organizativos.');
      AddLog('JAV',2,'   - Se corrige un error en las aprobaciones por usuario.');

      //{--- V00194 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.55',20200415D);
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Se a¤ade un segundo grupo registro de anticipos, uno para los que generan efecto y el otro para los que generan facturas.');
      AddLog('JAV',1,'   - Se ajustan los campos en las fichas de cliente, proveedor, facturas de venta y factura de compra.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrigen peque¤os errores que se produc¡a en algunas aprobaciones.');

      AddVer(mDP,'1.00.01',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un error en los abonos de compra registrados con los importes deducibles y no deducibles.');

      //{--- V00195 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.56',20200415D);
      AddLog('   ',0,'Almac‚n:');
      AddLog('AML',1,'   - Se a¤ade un campo en la configuraci¢n de compras para indicar no permitir precios negativos.');
      AddLog('AML',2,'   - Se ajustan datos en el registro de facturas de compra.');
      AddLog('CPM',2,'   - Se corrigen errores al registrar facturas de compra con albaranes de producto.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('QMD',1,'   - Nueva p gina para el BI con los esquemas de cuenta.');

      //{--- V00196 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.57',20200415D);
      AddLog('   ',0,'Anticipos:');
      AddLog('JAV',1,'   - Se completa la anulaci¢n de anticipos con factura y se revisan temas menores.');
      AddLog('JAV',2,'   - Cuando un anticipo con efecto se aplica a una factura cuya forma de pago la liquidaba autom ticamente daba un error de que no encontraba el movimiento a liquidar.');
      AddLog('   ',0,'Retenciones:');
      AddLog('JAV',2,'   - Cuando una retenci¢n de pago o de IRPF se aplica a una factura cuya forma de pago la liquidaba autom ticamente daba un error de que no encontraba el movimiento a liquidar.');
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Antes de solicitar la aprobaci¢n de cualquier documento, si no tiene el circuito de aprobaci¢n informado se busca.');
      AddLog('JAV',1,'   - Se mejora el sistema para aprobar documentos de Traspasos entre proyectos, a¤adiendo campos y ajustando los procesos.');
      AddLog('   ',0,'Notas de gasto:');
      AddLog('JAV',1,'   - Se a¤ade el panel para poder adjuntar documentos en la lista y ficha sin registrar, y verlos en la lista y ficha registrada.');
      AddLog('   ',0,'Documentos de compra:');
      AddLog('JAV',1,'   - No se permite cambiar Unidad de Obra/Partida Presupuestaria, Concepto Anal¡tico ni retenciones si el documento no est  abierto.');
      AddLog('JAV',2,'   - Se corrige el proyecto relacionado con el campo "Partida presupuestaria de aprobaci¢n" por el de "Proyecto para aprobaci¢n" en lugar de usar el proyecto de la cabecera.');
      AddLog('JAV',1,'   - Si en la configuraci¢n de compras est  marcado "recibir cantidad pendiente", al anular un albar n ajusta los campos de cantidad a recibir y cantidad a facturar.');
      AddLog('   ',0,'Relaciones de pagos:');
      AddLog('JAV',1,'   - No se incluyen en la propuesta de documentos los que no est‚n aprobados.');
      AddLog('JAV',1,'   - Si se incluye alguno no aprobado manualmente no se generar  un pagar‚ ni se podr  registrar la relaci¢n hasta su aprobaci¢n.');

      //{--- V00197 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.58',20200415D);
      AddLog('   ',0,'Reparto de la amortizaci¢n de activos:');
      AddLog('CPA',1,'   - Se incorpora una nueva funcionalidad para realizar el reparto de la amortizaci¢n de los activos entre varios proyectos de manera porcentual.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se modifica el sistema para revisar la configuraci¢n general, se acortan nombres y se revisa que no se modifiquen datos existentes, solo crea nuevos.');
      AddLog('JAV',1,'   - Se a¤ade la impresi¢n de abonos proforma para INESCO.');
      AddLog('JAV',1,'   - Se verifica que siempre que se crea un registro de movimiento de proyecto se informe del nombre del cliente o proveedor relacionado.');
      AddLog('JAV',1,'   - Se refactorizan algunas CU para preparar su paso a Extensiones.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se corrige un error en la pantalla que muestra los datos de aprobaci¢n de los responsables de los proyectos.');

      AddVer(mRE,'1.00.21',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se modifica el sistema para revisar la configuraci¢n general, se acortan nombres y se revisa que no se modifiquen datos existentes, solo crea nuevos.');

      AddVer(mQPR,'1.00.21',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se modifica el sistema para revisar la configuraci¢n general, se acortan nombres y se revisa que no se modifiquen datos existentes, solo crea nuevos.');

      AddVer(mDP,'1.00.02',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se completa el c lculo de la prorrata definitiva, con dos botones en la lista de ejercicios de la prorrata, uno calcula los datos y el segundo los aplica.');
      AddLog('JAV',1,'   - Se a¤ade una columna para indicar el nuevo tipo de prorrata que se usar  al aplicar, seg£n el c lculo establecido.');

      //{--- V00198 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.10.59',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se refactorizan varios objetos para simplificar su pase a Extensiones.');

      AddVer(mQF, '1.3r',  20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se refactorizan varios objetos para simplificar su pase a Extensiones.');

      //{--- V00199 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.11.00',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('CSM',1,'   - Se presenta correctamente el nombre del cliente o proveedor en cartera.');
      AddLog('JAV',1,'   - Se elimina bot¢n de "programar" al cancelar un albar n de compra.');
      AddLog('JAV',1,'   - Cuando se genera un contrato y no se indica unidad de obra en el comparativo va a la de almac‚n, se ajusta el C.A. asociado.');
      AddLog('JAV',1,'   - Se refactorizan varios objetos para simplificar su pase a Extensiones.');
      AddLog('JAV',1,'   - Se eliminan botones para liberar el IVA direfido de varias pantallas donde no tiene sentido mantenerlas.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se cambia el nombre a "Albaranes" en movimientos de contabilidad y de proveedor.');
      AddLog('JAV',2,'   - Se soluciona un error al generar el contrato cuando la cantidad se pasa a 1 y el precio es el total de la l¡nea.');
      AddLog('JAV',2,'   - Se soluciona un error con la fecha de anulaci¢n de las l¡neas de los albaranes y con la anulaci¢n de albaranes que no han entrado en almac‚n.');

      AddVer(mDP,'1.00.03',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se aumentan los importes del gasto en los proyectos por la parte no deducible de la prorrata de IVA.');
      AddLog('JAV',1,'   - Se aumentan los importes de compra del producto por la parte no deducible de la prorrata de IVA.');

      AddVer(mQSII,'1.06.10',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se verifica que la fecha de registro autom tica no pueda ser inferior a la de emisi¢n del documento de compra, si lo es se ajusta.');

      //{--- V00200 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.11.01',20200415D);
      AddLog('   ',0,'Archivo autom tico de pedidos de compra:');
      AddLog('DGG',1,'   - Se a¤ade en la pantalla de configuraci¢n de compras un campo para activar el archivo de los pedidos de compra.');
      AddLog('DGG',1,'   - Si se activa, cuando se reabre un pedido de compra lanzado se crea autom ticamente una nueva versi¢n del documento y se archiva la actual.');
      AddLog('   ',0,'Contratos Marco:');
      AddLog('CPA',1,'   - Se cambian los posibles estados del contrato a No Operativo, Operativo y Cerrado.');
      AddLog('CPA',1,'   - Se a¤aden nuevos campos para calcular las cantidades usadas y disponibles de m s tipos de documentos.');
      AddLog('JAV',1,'   - Se eliminan campos no usados de las pantallas.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se eliminan botones para liberar el IVA diferido de la ficha del proyecto donde no tiene sentido mantenerlas.');
      AddLog('JAV',1,'   - En pedidos de compra se cambia el nombre del campo "Contrato" por "Desde un comparativo" y se hace navegable.');
      AddLog('JAV',1,'   - En la ficha del comparativo se a¤ade en la cabecera la descripci¢n de la Unidad de Obra/Partida Presupuestaria.');
      AddLog('JAV',1,'   - En l¡neas de pedidos de compra y l¡neas del comparativo se a¤ade la descripci¢n del proyecto, no visible por defecto.');
      AddLog('JAV',1,'   - Se refactorizan varios objetos para simplificar su pase a Extensiones.');
      AddLog('CSM',1,'   - Se mejoran los informes de "Gastos por ppto nivel" y el de "Costes imputados por proveedores".');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('DGG',2,'   - Se soluciona un error en el bot¢n de seguimiento de l¡neas del documento en las l¡neas de pedidos de compra.');
      AddLog('AML',2,'   - Se soluciona un error de dimensiones y se mejora el control de negativos en el manejo del Almac‚n.');

      AddVer(mDP,'1.00.04',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - En la pantalla de facturas de compras se muestran importes totales del IVA deducible y el No Deducible.');

      AddVer(mRE,'1.00.22',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se eliminan botones para liberar el IVA diferido de la ficha del proyecto donde no tiene sentido mantenerlas.');

      AddVer(mQPR,'1.00.22',20200415D);
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se eliminan botones para liberar el IVA diferido de la ficha del proyecto donde no tiene sentido mantenerlas.');

      //{--- V00201 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.11.02',20200415D);
      AddLog('   ',0,'Actividades de Proyectos:');
      AddLog('JAV',1,'   - Se a¤ade la primera fase del control de actividades mensuales a efectuar en los proyectos, relacionadas con los cierres mensuales.');
      AddLog('JAV',0,'Nombres de campos configurables:');
      AddLog('JAV',1,'   - Se hacen configurables los nombres de los cargos fijos en los proyectos operativos.');
      AddLog('JAV',1,'   - Se hacen configurables campos auxiliares informativos en los proyectos operativos.');
      AddLog('JAV',2,'   - Se soluciona un error si el campo estaba mal configurado en la tabla.');
      AddLog('   ',0,'Otros Cambios:');
      AddLog('JAV',1,'   - Se a¤ade en la lista de movimientos contables una columna con el c¢digo del proyecto relacionado con el movimiento (si existe).');
      AddLog('JAV',1,'   - Se a¤ade el campo "Descripci¢n 2" en la ficha y lista de productos.');
      AddLog('CSM',1,'   - Se a¤ade un bot¢n en la lista de movimientos de proyecto para cargar el proveedor de origen y su nombre si no lo tiene informado.');
      AddLog('CSM',1,'   - Se a¤ade un bot¢n en la lista de movimientos contables para cargar el proveedor de origen y su nombre si no lo tiene informado.');
      AddLog('   ',0,'Aprobaciones:');
      AddLog('JAV',1,'   - Se mejora el formato del mail de la aprobaci¢n pendiente, a¤adiendo campos espec¡ficos para el proyecto y la partida.');
      AddLog('JAV',2,'   - Se soluciona un error con las aprobaciones de las notas de gasto.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un error por el que usaba el contador de estudios en lugar del de proyectos cuando se creaban desde una categor¡a de proyecto que usaba contadores.');
      AddLog('JAV',2,'   - Se soluciona un error al anular albaranes con productos de tipo sin stock.');
      AddLog('JAV',2,'   - Se soluciona un error en la pantalla de Seguimiento Certificaci¢n, ten¡a nombres de columnas de certificaci¢n err¢neos y estaba mal el c lculo de la diferencia prod/cert');

      AddVer(mQSII,'1.06.11',20200415D);
      AddLog('   ',0,'Operaciones de Tracto Sucesivo:');
      AddLog('JAV',1,'   - Se incluye el manejo de las operaciones del r‚gimen 15. En esta versi¢n se ha limitado su funcionalidad de forma que no admite cobros parciales o totales anticipados.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un error por el que no obten¡a el estado en el QuoSII correcto en la p gina de abonos registrados de compra.');
      AddLog('JAV',2,'   - Se soluciona un error por el que no obten¡a el documento original del tipo 14 cuando el pago se hac¡a desde un diario de ventas directamente.');

      AddVer(mMD,'1.00.06',20200415D);
      AddLog('   ',0,'Eliminar registros en otras empresas:');
      AddLog('JAV',1,'   - Se mejora el proceso para eliminar registros en todas las empresas, a¤adiendo en la configuraci¢n un tiempo m ximo de espera para evitar problemas y mejorar la temporizaci¢n');
      AddLog('JAV',2,'   - Se mejor el proceso para que d‚ solo errores y no otros mensajes no relacionados.');

      //{--- V00202 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.11.03',20200415D);
      AddLog('   ',0,'Aprobaciones en todas las empresas:');
      AddLog('EPV',1,'   - Se filtra para solo procesar empresas en las que el usuario tiene permisos.');
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',2,'   - Se soluciona un error por el que no se calculaban las necesidades de compras en los estudios.');

      AddVer(mDP,'1.00.05',20200415D);
      AddLog('   ',0,'Soluci¢n de errores:');
      AddLog('JAV',1,'   - Se soluciona un error cuando las l¡nea de compra no ten¡a establecido el grupo de IVA (l¡neas de comentarios).');

      AddVer(mQSII,'1.06.12',20200415D);
      AddLog('   ',0,'Fecha de Operaci¢n en Compras:');
      AddLog('JAV',1,'   - Se a¤ade un par metro para informar que fecha se usar  como fecha de operaci¢n por defecto en compras, en blanco o la fecha de emisi¢n del documento.');

      //{--- V00999 -----------------------------------------------------------------------------------------------------------------------}

      // AddVer(mQB,'1.10.47',20200415D);
      // AddLog('   ',0,'Importaci¢n de n¢minas:');
      // AddLog('JAV',1,'   - Se prepara el sistema para el proceso de importaci¢n y reparto de las n¢mina por proyectos. Estar  operativo en una pr¢xima versi¢n.');

      //{--- V00203 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.12.00',20200415D);
      AddLog('   ',0,'Gastos Activables:');
      AddLog('JAV',1,'   - Se incluye la activaci¢n de gastos (solo proyectos de RE y Presupuestos)');
      AddLog('JAV',1,'   - Se incluyen los grupos registro en los movimientos contables que se generan desde los albaranes de compra.');

      AddVer(mRE,'1.00.23',20200415D);
      AddLog('   ',0,'Gastos Activables:');
      AddLog('JAV',1,'   - Se incluye la activaci¢n de gastos (solo proyectos de RE y Presupuestos)');
      AddLog('JAV',1,'   - Se incluyen los grupos registro en los movimientos contables que se generan desde los albaranes de compra.');

      AddVer(mQPR,'1.00.23',20200415D);
      AddLog('   ',0,'Gastos Activables:');
      AddLog('JAV',1,'   - Se incluye la activaci¢n de gastos (solo proyectos de RE y Presupuestos)');
      AddLog('JAV',1,'   - Se incluyen los grupos registro en los movimientos contables que se generan desde los albaranes de compra.');

      //{--- V00204 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.12.01',20200415D);
      AddLog('   ',0,'Comp…rativos:');
      AddLog('JAV',1,'   - Se corrige un error al generar los pedidos por importe en lugar de por cantidad por el que pon¡a 1 en precio y 1 en cantidad.');

      //{--- V00205 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.12.02',20200415D);
      AddLog('   ',0,'Movimientos contables:');
      AddLog('JAV',1,'   - Se corrige un error en la entrada de la p gina cuando no est  activo QB, RE o QPR.');

      //{--- V00206 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.12.03',20200415D);
      AddLog('   ',0,'Retenciones:');
      AddLog('JAV',1,'   - Se corrige un error al liberar retenciones cuando los movimientos existentes no ten¡an un n£mero de efecto num‚rico.');

      //{--- V00207 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.12.04',20200415D);
      AddLog('   ',0,'Partes de trabajadores externos:');
      AddLog('JAV',1,'   - Se corrige un error por el que no hac¡a los movimientos de proyecto si estaba as¡ configurado, y daba un error al no tener un dialogo abierto.');

      //{--- V00208 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.12.05',20200415D);
      AddLog('   ',0,'Optimizaci¢n en mediciones:');
      AddLog('JAV',1,'   - Se optimizan algunos procesos en la parte de medici¢n/certificaci¢n para que sean m s r pidos.');

      //{--- V00209 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.12.06',20200415D);
      AddLog('   ',0,'Lista de unidades de obra/partidas presupuestarias:');
      AddLog('JAV',1,'   - Se cambia la condici¢n de visible de los campos "Descripci‡on" y "Descripcion 2".');

      //{--- V00210 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.12.07',20200415D);
      AddLog('   ',0,'Registro de facturas de compra:');
      AddLog('PSM',1,'   - Se muestra el mensaje de confirmaci¢n del registro aunque est‚ relleno el campo "Nro. Pedido"');

      //{--- V00211 -----------------------------------------------------------------------------------------------------------------------}
      AddVer(mQB,'1.12.08',20200415D);
      AddLog('   ',0,'Drag&Drop:');
      AddLog('CPA',1,'   - Se mejora el m¢dulo en general para mostrar los enlaces a los documentos en las fichas.');

      AddVer(mSP,'1.03',20200415D);
      AddLog('   ',0,'Drag&Drop:');
      AddLog('CPA',1,'   - Se mejora el m¢dulo en general para mostrar los enlaces a los documentos en las fichas.');
    end;

    /*begin
    end.
  */
}







