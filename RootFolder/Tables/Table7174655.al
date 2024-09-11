table 7174655 "Library Types Values SP"
{
  
  
    CaptionML=ENU='Library Types Values SP',ESP='Valores de tipos de librer¡as SP';
    LookupPageID="Library Types";
    DrillDownPageID="Library Types";
  
  fields
{
    field(1;"Metadata Site Defs";Code[20])
    {
        CaptionML=ENU='Metadata Site Defs',ESP='No. Definici¢n Metadatos';


    }
    field(2;"Name";Text[100])
    {
        CaptionML=ENU='Name',ESP='Nombre';


    }
    field(3;"Value";Text[100])
    {
        

                                                   CaptionML=ENU='Value',ESP='Valor';
                                                   NotBlank=true;

trigger OnValidate();
    BEGIN 

                                                                FncCheckValue(Rec);
                                                              END;


    }
    field(4;"Description";Text[50])
    {
        CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(499;"Last Date Modified";DateTime)
    {
        CaptionML=ENU='Last User Modified',ESP='Fecha £lt. modificaci¢n';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Metadata Site Defs","Name","Value")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       TEXT000@1100286007 :
      TEXT000: TextConst ENU='Error, process not supported.',ESP='Error, proceso no soportado.';
//       TEXT001@1100286006 :
      TEXT001: TextConst ENU='Error, no blanks or the following special characters are allowed ;/():?¨*`ù[]{}\¦!""ú$%&/',ESP='Error, no se permiten espacios en blanco ni los siguientes car cteres especiales  ;/():?¨*`ù[]{}\¦!""ú$%&/';
//       TEXT002@1100286005 :
      TEXT002: TextConst ENU='The metadata schema will be opened and then it will need to be checked again. ¨Do you wish to continue?',ESP='Se abrir  el esquema de los metadatos y despues ser  necesario volver a comprobarlo. ¨Desea continuar?';
//       TEXT003@1100286004 :
      TEXT003: TextConst ENU='Operation canceled by the user.',ESP='Operaci¢n cancelada por el usuario.';
//       TEXTWORDRESERVE@1100286003 :
      TEXTWORDRESERVE: TextConst ENU='Name,Type,Description',ESP='Name,Type,Description';
//       TEXT004@1100286002 :
      TEXT004: TextConst ENU='It is not possible to use the following words reserved %1.',ESP='Error, no es posible utilizar las siguientes palabras reservadas %1.';
//       TEXT005@1100286001 :
      TEXT005: TextConst ENU='Error, it is not possible to repeat the field value.',ESP='Error, no es posible repetir el campo valor.';
//       TEXT006@1100286008 :
      TEXT006: TextConst ENU='Error, no blanks or the following special characters are allowed %1',ESP='Error, no se permiten espacios en blanco ni los siguientes car cteres especiales %1';
//       TEXTERROR@1100286000 :
      TEXTERROR: TextConst ENU=' ;/():?¨*`ù[]{}\¦!""ú$%&/.,',ESP=' ;/():?¨*`ù[]{}\¦!""ú$%&/.,';

    

trigger OnInsert();    begin
               "Last Date Modified"  := CREATEDATETIME(TODAY,TIME);
             end;

trigger OnModify();    begin
               "Last Date Modified"  := CREATEDATETIME(TODAY,TIME);
             end;



// LOCAL procedure FncCheckValue (var pLibTypesValuesSP@1100286001 :
LOCAL procedure FncCheckValue (var pLibTypesValuesSP: Record 7174655)
    var
//       LibraryTypesValuesSP@1100286000 :
      LibraryTypesValuesSP: Record 7174655;
//       I@1100286002 :
      I: Integer;
//       V@1100286003 :
      V: Text;
//       vLetters@1100286004 :
      vLetters: Text;
    begin

      FOR I:=1 TO STRLEN(pLibTypesValuesSP.Value) DO begin
        V := UPPERCASE(COPYSTR(pLibTypesValuesSP.Value,I,1));
        vLetters := FORMAT(TEXTERROR);
        if STRPOS(vLetters,V) <> 0 then
          ERROR(TEXT006,TEXTERROR);
      end;

      ///Comprobar que no se repite el mmismo nombre de columna
      LibraryTypesValuesSP.RESET;
      LibraryTypesValuesSP.SETRANGE("Metadata Site Defs",pLibTypesValuesSP."Metadata Site Defs");
      LibraryTypesValuesSP.SETRANGE(Name,pLibTypesValuesSP.Name);
      LibraryTypesValuesSP.SETRANGE(Value,pLibTypesValuesSP.Value);
      if LibraryTypesValuesSP.COUNT >= 1 then
        ERROR(TEXT005);
    end;

    /*begin
    //{
//      QUONEXT 20.07.17 DRAG&DROP. Selecci¢n del tipo de libreria de sharepoint (se lleva un metadato con el valor asociado al arrastrar ficheros)
//    }
    end.
  */
}







