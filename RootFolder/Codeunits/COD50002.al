Codeunit 50002 "QuoSync  External"
{
  
  
    trigger OnRun()
VAR
            DatabaseName : Text;
            DatabaseConnectionString : Text;
          BEGIN
            DatabaseName := 'NAV130_KALAM';
            DatabaseConnectionString:= 'Data Source=localhost;Initial Catalog=NAV130_KALAM';    //;UserName=SUPER;Password=super

            IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, DatabaseName) THEN
              UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, DatabaseName);

            REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, DatabaseName, DatabaseConnectionString);
            SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, DatabaseName);
            MESSAGE('Done');
          END;

    /* BEGIN
END.*/
}









