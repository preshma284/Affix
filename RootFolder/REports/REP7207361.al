report 7207361 "Vendor/Subcontractor Card"
{


    CaptionML = ENU = 'Vendor/Subcontractor Card', ESP = 'Ficha proveedor/subcontratista';

    dataset
    {

        DataItem("Vendor Quality Data"; "Vendor Quality Data")
        {

            DataItemTableView = SORTING("Vendor No.", "Activity Code");


            RequestFilterFields = "Vendor No.";
            Column(Vendor_Name; Vendor.Name)
            {
                //SourceExpr=Vendor.Name;
            }
            Column(Vendor__VAT_Registration_No__; Vendor."VAT Registration No.")
            {
                //SourceExpr=Vendor."VAT Registration No.";
            }
            Column(Vendor_Address; Vendor.Address)
            {
                //SourceExpr=Vendor.Address;
            }
            Column(Vendor__Phone_No__; Vendor."Phone No.")
            {
                //SourceExpr=Vendor."Phone No.";
            }
            Column(Vendor__Fax_No__; Vendor."Fax No.")
            {
                //SourceExpr=Vendor."Fax No.";
            }
            Column(Vendor_Contact; Vendor.Contact)
            {
                //SourceExpr=Vendor.Contact;
            }
            Column(CeCaln; CeCaln)
            {
                //SourceExpr=CeCaln;
            }
            Column(CeCals; CeCals)
            {
                //SourceExpr=CeCals;
            }
            Column(VendorQltyCertif__N__Certificado_; VendorQltyCertif."Certificate No.")
            {
                //SourceExpr=VendorQltyCertif."Certificate No.";
            }
            Column(VendorQltyCertif__Entidad_certificacion_; VendorQltyCertif."Entity Certification")
            {
                //SourceExpr=VendorQltyCertif."Entity Certification";
            }
            Column(VendorQltyCertif__Caducidad_ceritificado_; 0D)
            {
                //SourceExpr=0D;
            }
            Column(CeCalProdn; CeCalProdn)
            {
                //SourceExpr=CeCalProdn;
            }
            Column(CeCalProds; CeCalProds)
            {
                //SourceExpr=CeCalProds;
            }
            Column(VendorQltyCertif_Item__N__Certificado_; VendorQltyCertif_Item."Certificate No.")
            {
                //SourceExpr=VendorQltyCertif_Item."Certificate No.";
            }
            Column(VendorQltyCertif_Item__Entidad_certificacion_; VendorQltyCertif_Item."Entity Certification")
            {
                //SourceExpr=VendorQltyCertif_Item."Entity Certification";
            }
            Column(VendorQltyCertif_Item__Caducidad_ceritificado_; 0D)
            {
                //SourceExpr=0D;
            }
            Column(SisCaln; SisCaln)
            {
                //SourceExpr=SisCaln;
            }
            Column(SisCals; SisCals)
            {
                //SourceExpr=SisCals;
            }
            Column(VendorQltyCertif_System__Grado_de_implantacion_; VendorQltyCertif_System."Level of Implementation")
            {
                //SourceExpr=VendorQltyCertif_System."Level of Implementation";
            }
            Column(N9001; N9001)
            {
                //SourceExpr=N9001;
            }
            Column(N9002; N9002)
            {
                //SourceExpr=N9002;
            }
            Column(N9003; N9003)
            {
                //SourceExpr=N9003;
            }
            Column(N0; N0)
            {
                //SourceExpr=N0;
            }
            Column(NM14001; NM14001)
            {
                //SourceExpr=NM14001;
            }
            Column(VendorQltyCertif_Environ__Grado_de_implantacion_; VendorQltyCertif_Environ."Level of Implementation")
            {
                //SourceExpr=VendorQltyCertif_Environ."Level of Implementation";
            }
            Column(GesMedn; GesMedn)
            {
                //SourceExpr=GesMedn;
            }
            Column(GesMeds; GesMeds)
            {
                //SourceExpr=GesMeds;
            }
            Column(NM0; NM0)
            {
                //SourceExpr=NM0;
            }
            Column(VendorQltyCertif_System__Otras_normas_de_referencia_; VendorQltyCertif_System."Other Reference Standards")
            {
                //SourceExpr=VendorQltyCertif_System."Other Reference Standards";
            }
            Column(VendorQltyCertif_Environ__Otras_normas_de_referencia_; VendorQltyCertif_Environ."Other Reference Standards")
            {
                //SourceExpr=VendorQltyCertif_Environ."Other Reference Standards";
            }
            Column(NomActividad; NomActividad)
            {
                //SourceExpr=NomActividad;
            }
            Column(HistN; '')
            {
                //SourceExpr='';
            }
            Column(HistS; '')
            {
                //SourceExpr='';
            }
            Column(Datos_calidad_proveedor__Cod__Proveedor_; "Vendor No.")
            {
                //SourceExpr="Vendor No.";
            }
            Column(NomActividad_Control227; NomActividad)
            {
                //SourceExpr=NomActividad;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Codigo_Ult__revision_; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Fecha_Elt__revision_; "Vendor Quality Data"."Date Last Reviews")
            {
                //SourceExpr="Vendor Quality Data"."Date Last Reviews";
            }
            Column(Vendor__Post_Code_; Vendor."Post Code")
            {
                //SourceExpr=Vendor."Post Code";
            }
            Column(Vendor_City; Vendor.City)
            {
                //SourceExpr=Vendor.City;
            }
            Column(Vendor_County; Vendor.County)
            {
                //SourceExpr=Vendor.County;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Fecha_Elt__revision__Control233; "Vendor Quality Data"."Date Last Reviews")
            {
                //SourceExpr="Vendor Quality Data"."Date Last Reviews";
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Codigo_Ult__revision__Control235; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Descripcion_actividad_; "Vendor Quality Data"."Activity Description")
            {
                //SourceExpr="Vendor Quality Data"."Activity Description";
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Cod__Proveedor_; "Vendor Quality Data"."Vendor No.")
            {
                //SourceExpr="Vendor Quality Data"."Vendor No.";
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___N__revisiones_; "Vendor Quality Data"."No. of Evaluations")
            {
                //SourceExpr="Vendor Quality Data"."No. of Evaluations";
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Fecha_firma_seleccion_; "Vendor Quality Data"."Date Signature Selections")
            {
                //SourceExpr="Vendor Quality Data"."Date Signature Selections";
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Otros_productos_servicios_; 0.01)
            {
                //SourceExpr=0.01;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor__Garantia; "Vendor Quality Data".Warranty)
            {
                //SourceExpr="Vendor Quality Data".Warranty;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___N__sistemas_informaticos_; 0.01)
            {
                //SourceExpr=0.01;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor__Equipos; "Vendor Quality Data".Equipment)
            {
                //SourceExpr="Vendor Quality Data".Equipment;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___N__de_procesos_; 0.01)
            {
                //SourceExpr=0.01;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___N__de_directivos_; 0.01)
            {
                //SourceExpr=0.01;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___N__de_tacnicos_; 0.01)
            {
                //SourceExpr=0.01;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___N__de_empleados_; 0.01)
            {
                //SourceExpr=0.01;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___N__de_clientes_; 0.01)
            {
                //SourceExpr=0.01;
            }
            Column(Psn; Psn)
            {
                //SourceExpr=Psn;
            }
            Column(Pss; Pss)
            {
                //SourceExpr=Pss;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Fecha_Observaciones_; 0D)
            {
                //SourceExpr=0D;
            }
            Column(Ob5; Ob5)
            {
                //SourceExpr=Ob5;
            }
            Column(Ob4; Ob4)
            {
                //SourceExpr=Ob4;
            }
            Column(Ob3; Ob3)
            {
                //SourceExpr=Ob3;
            }
            Column(Ob2; Ob2)
            {
                //SourceExpr=Ob2;
            }
            Column(Ob1; Ob1)
            {
                //SourceExpr=Ob1;
            }
            Column(FICHA_GENERAL_DE_PROVEEDOR_SUBCONTRATISTACaption; FICHA_GENERAL_DE_PROVEEDOR_SUBCONTRATISTACaptionLbl)
            {
                //SourceExpr=FICHA_GENERAL_DE_PROVEEDOR_SUBCONTRATISTACaptionLbl;
            }
            Column(Rev_Caption; Rev_CaptionLbl)
            {
                //SourceExpr=Rev_CaptionLbl;
            }
            Column(DATOS_GENERALESCaption; DATOS_GENERALESCaptionLbl)
            {
                //SourceExpr=DATOS_GENERALESCaptionLbl;
            }
            Column(Razon_Social_Caption; Razon_Social_CaptionLbl)
            {
                //SourceExpr=Raz¢n_Social_CaptionLbl;
            }
            Column(NIF_CIF_Caption; NIF_CIF_CaptionLbl)
            {
                //SourceExpr=NIF_CIF_CaptionLbl;
            }
            Column(Direccion_Caption; Direccion_CaptionLbl)
            {
                //SourceExpr=Direcci¢n_CaptionLbl;
            }
            Column(Telefono_Caption; Telefono_CaptionLbl)
            {
                //SourceExpr=Tel‚fono_CaptionLbl;
            }
            Column(Telefax_Caption; Telefax_CaptionLbl)
            {
                //SourceExpr=Telefax_CaptionLbl;
            }
            Column(Persona_de_contacto_Caption; Persona_de_contacto_CaptionLbl)
            {
                //SourceExpr=Persona_de_contacto_CaptionLbl;
            }
            Column(Producto_Servicio_para_el_que_se_le_evalEa_Caption; Producto_Servicio_para_el_que_se_le_evalea_CaptionLbl)
            {
                //SourceExpr=Producto_Servicio_para_el_que_se_le_eval£a_CaptionLbl;
            }
            Column(Proveedor_historico_Caption; Proveedor_historico_CaptionLbl)
            {
                //SourceExpr=Proveedor_hist¢rico_CaptionLbl;
            }
            Column(INFORMACIàN_DEL_SISTEMA_DE_CALIDAD_Y_MEDIO_AMBIENTECaption; INFORMACIàN_DEL_SISTEMA_DE_CALIDAD_Y_MEDIO_AMBIENTECaptionLbl)
            {
                //SourceExpr=INFORMACIàN_DEL_SISTEMA_DE_CALIDAD_Y_MEDIO_AMBIENTECaptionLbl;
            }
            Column(Certificado_de_calidad_Caption; Certificado_de_calidad_CaptionLbl)
            {
                //SourceExpr=Certificado_de_calidad_CaptionLbl;
            }
            Column(NOCaption; NOCaptionLbl)
            {
                //SourceExpr=NOCaptionLbl;
            }
            Column(SICaption; SICaptionLbl)
            {
                //SourceExpr=SICaptionLbl;
            }
            Column(En_caso_afirmativo__indicar_Caption; En_caso_afirmativo__indicar_CaptionLbl)
            {
                //SourceExpr=En_caso_afirmativo__indicar_CaptionLbl;
            }
            Column(N__del_certificado_Caption; N__del_certificado_CaptionLbl)
            {
                //SourceExpr=N__del_certificado_CaptionLbl;
            }
            Column(Entidad_de_certificacion_Caption; Entidad_de_certificacion_CaptionLbl)
            {
                //SourceExpr=Entidad_de_certificaci¢n_CaptionLbl;
            }
            Column(Fecha_caducidad_certificado_Caption; Fecha_caducidad_certificado_CaptionLbl)
            {
                //SourceExpr=Fecha_caducidad_certificado_CaptionLbl;
            }
            Column(Certificado_de_calidad_de_producto_Caption; Certificado_de_calidad_de_producto_CaptionLbl)
            {
                //SourceExpr=Certificado_de_calidad_de_producto_CaptionLbl;
            }
            Column(NOCaption_Control45; NOCaption_Control45Lbl)
            {
                //SourceExpr=NOCaption_Control45Lbl;
            }
            Column(SICaption_Control48; SICaption_Control48Lbl)
            {
                //SourceExpr=SICaption_Control48Lbl;
            }
            Column(En_caso_afirmativo__indicar_Caption_Control49; En_caso_afirmativo__indicar_Caption_Control49Lbl)
            {
                //SourceExpr=En_caso_afirmativo__indicar_Caption_Control49Lbl;
            }
            Column(N__del_certificado_Caption_Control56; N__del_certificado_Caption_Control56Lbl)
            {
                //SourceExpr=N__del_certificado_Caption_Control56Lbl;
            }
            Column(Entidad_de_certificacion_Caption_Control57; Entidad_de_certificacion_Caption_Control57Lbl)
            {
                //SourceExpr=Entidad_de_certificaci¢n_Caption_Control57Lbl;
            }
            Column(Fecha_caducidad_certificado_Caption_Control58; Fecha_caducidad_certificado_Caption_Control58Lbl)
            {
                //SourceExpr=Fecha_caducidad_certificado_Caption_Control58Lbl;
            }
            Column(Implantacion_del_sistema_de_calidad_Caption; Implantacion_del_sistema_de_calidad_CaptionLbl)
            {
                //SourceExpr=Implantaci¢n_del_sistema_de_calidad_CaptionLbl;
            }
            Column(NOCaption_Control59; NOCaption_Control59Lbl)
            {
                //SourceExpr=NOCaption_Control59Lbl;
            }
            Column(SICaption_Control62; SICaption_Control62Lbl)
            {
                //SourceExpr=SICaption_Control62Lbl;
            }
            Column(Grado_de_implantacion_Caption; Grado_de_implantacion_CaptionLbl)
            {
                //SourceExpr=Grado_de_implantaci¢n_CaptionLbl;
            }
            Column(Norma_de_refencia_Caption; Norma_de_refencia_CaptionLbl)
            {
                //SourceExpr=Norma_de_refencia_CaptionLbl;
            }
            Column(V9001Caption; V9001CaptionLbl)
            {
                //SourceExpr=V9001CaptionLbl;
            }
            Column(V9002Caption; V9002CaptionLbl)
            {
                //SourceExpr=V9002CaptionLbl;
            }
            Column(V9003Caption; V9003CaptionLbl)
            {
                //SourceExpr=V9003CaptionLbl;
            }
            Column(OtrosCaption; OtrosCaptionLbl)
            {
                //SourceExpr=OtrosCaptionLbl;
            }
            Column(Norma_de_refencia_Caption_Control78; Norma_de_refencia_Caption_Control78Lbl)
            {
                //SourceExpr=Norma_de_refencia_Caption_Control78Lbl;
            }
            Column(Grado_de_implantacion_Caption_Control79; Grado_de_implantacion_Caption_Control79Lbl)
            {
                //SourceExpr=Grado_de_implantaci¢n_Caption_Control79Lbl;
            }
            Column(Implantacion_del_sistema_de_gestion_medioambiental_Caption; Implantacion_del_sistema_de_gestion_medioambiental_CaptionLbl)
            {
                //SourceExpr=Implantaci¢n_del_sistema_de_gesti¢n_medioambiental_CaptionLbl;
            }
            Column(V14001Caption; V14001CaptionLbl)
            {
                //SourceExpr=V14001CaptionLbl;
            }
            Column(NOCaption_Control90; NOCaption_Control90Lbl)
            {
                //SourceExpr=NOCaption_Control90Lbl;
            }
            Column(SICaption_Control97; SICaption_Control97Lbl)
            {
                //SourceExpr=SICaption_Control97Lbl;
            }
            Column(OtrosCaption_Control100; OtrosCaption_Control100Lbl)
            {
                //SourceExpr=OtrosCaption_Control100Lbl;
            }
            Column(NOCaption_Control213; NOCaption_Control213Lbl)
            {
                //SourceExpr=NOCaption_Control213Lbl;
            }
            Column(SICaption_Control217; SICaption_Control217Lbl)
            {
                //SourceExpr=SICaption_Control217Lbl;
            }
            Column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
                //SourceExpr=EmptyStringCaptionLbl;
            }
            Column(EmptyStringCaption_Control188; EmptyStringCaption_Control188Lbl)
            {
                //SourceExpr=EmptyStringCaption_Control188Lbl;
            }
            Column(Fecha_Caption; Fecha_CaptionLbl)
            {
                //SourceExpr=Fecha_CaptionLbl;
            }
            Column(Hoja_1_de_2Caption; Hoja_1_de_2CaptionLbl)
            {
                //SourceExpr=Hoja_1_de_2CaptionLbl;
            }
            Column(Cod__ProveedorCaption; Cod__ProveedorCaptionLbl)
            {
                //SourceExpr=C¢d__ProveedorCaptionLbl;
            }
            Column(ActividadCaption; ActividadCaptionLbl)
            {
                //SourceExpr=ActividadCaptionLbl;
            }
            Column(C_P__Caption; C_P__CaptionLbl)
            {
                //SourceExpr=C_P__CaptionLbl;
            }
            Column(Poblacion_Caption; Poblacion_CaptionLbl)
            {
                //SourceExpr=Poblaci¢n_CaptionLbl;
            }
            Column(Provincia_Caption; Provincia_CaptionLbl)
            {
                //SourceExpr=Provincia_CaptionLbl;
            }
            Column(FICHA_GENERAL_DEL_PROVEEDOR_SUBCONTRATISTACaption; FICHA_GENERAL_DEL_PROVEEDOR_SUBCONTRATISTACaptionLbl)
            {
                //SourceExpr=FICHA_GENERAL_DEL_PROVEEDOR_SUBCONTRATISTACaptionLbl;
            }
            Column(EVALUACIàN_Y_SELECCIàN_DEL_PROVEEDOR_SUBCONTRATISTACaption; EVALUACIàN_Y_SELECCIàN_DEL_PROVEEDOR_SUBCONTRATISTACaptionLbl)
            {
                //SourceExpr=EVALUACIàN_Y_SELECCIàN_DEL_PROVEEDOR_SUBCONTRATISTACaptionLbl;
            }
            Column(Hoja_2_de_2Caption; Hoja_2_de_2CaptionLbl)
            {
                //SourceExpr=Hoja_2_de_2CaptionLbl;
            }
            Column(Certificado_de_calidad_de_producto_Caption_Control103; Certificado_de_calidad_de_producto_Caption_Control103Lbl)
            {
                //SourceExpr=Certificado_de_calidad_de_producto_Caption_Control103Lbl;
            }
            Column(V0Caption; V0CaptionLbl)
            {
                //SourceExpr=V0CaptionLbl;
            }
            Column(V1Caption; V1CaptionLbl)
            {
                //SourceExpr=V1CaptionLbl;
            }
            Column(V2Caption; V2CaptionLbl)
            {
                //SourceExpr=V2CaptionLbl;
            }
            Column(V3Caption; V3CaptionLbl)
            {
                //SourceExpr=V3CaptionLbl;
            }
            Column(Requisitos_a_valorar_Caption; Requisitos_a_valorar_CaptionLbl)
            {
                //SourceExpr=Requisitos_a_valorar_CaptionLbl;
            }
            Column(Fecha_Caption_Control232; Fecha_Caption_Control232Lbl)
            {
                //SourceExpr=Fecha_Caption_Control232Lbl;
            }
            Column(Rev_Caption_Control234; Rev_Caption_Control234Lbl)
            {
                //SourceExpr=Rev_Caption_Control234Lbl;
            }
            Column(FechaCaption; FechaCaptionLbl)
            {
                //SourceExpr=FechaCaptionLbl;
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___Otros_productos_servicios_Caption; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor__GarantiaCaption; FIELDCAPTION(Warranty))
            {
                //SourceExpr=FIELDCAPTION(Warranty);
            }
            Column(Programas_informaticosCaption; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(Equipos_o_maquinariasCaption; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(Datos_calidad_proveedor__Datos_calidad_proveedor___N__de_procesos_Caption; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(N__DirectivoCaption; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(N__TacnicoCaption; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(N__EmpleadoCaption; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(Nombre_de_clientesCaption; 'ANULADO')
            {
                //SourceExpr='ANULADO';
            }
            Column(Firmado___Director_de_comprasCaption; Firmado___Director_de_comprasCaptionLbl)
            {
                //SourceExpr=Firmado___Director_de_comprasCaptionLbl;
            }
            Column(OBSERVACIONESCaption; OBSERVACIONESCaptionLbl)
            {
                //SourceExpr=OBSERVACIONESCaptionLbl;
            }
            Column(PersonalCaption; PersonalCaptionLbl)
            {
                //SourceExpr=PersonalCaptionLbl;
            }
            Column(NOCaption_Control1100231029; NOCaption_Control1100231029Lbl)
            {
                //SourceExpr=NOCaption_Control1100231029Lbl;
            }
            Column(SICaption_Control1100231032; SICaption_Control1100231032Lbl)
            {
                //SourceExpr=SICaption_Control1100231032Lbl;
            }
            Column(Proveedor_seleccionadoCaption; Proveedor_seleccionadoCaptionLbl)
            {
                //SourceExpr=Proveedor_seleccionadoCaptionLbl;
            }
            Column(Firmado___Director_de_comprasCaption_Control1100231035; Firmado___Director_de_comprasCaption_Control1100231035Lbl)
            {
                //SourceExpr=Firmado___Director_de_comprasCaption_Control1100231035Lbl;
            }
            Column(FechaCaption_Control1100231036; FechaCaption_Control1100231036Lbl)
            {
                //SourceExpr=FechaCaption_Control1100231036Lbl;
            }
            Column(Observaciones_a_la_evaluacionCaption; Observaciones_a_la_evaluacionCaptionLbl)
            {
                //SourceExpr=Observaciones_a_la_evaluaci¢nCaptionLbl;
            }
            Column(Datos_calidad_proveedor_Cod__actividad; "Activity Code")
            {
                //SourceExpr="Activity Code";
            }
            DataItem("Data Vendor Evaluation"; "Data Vendor Evaluation")
            {

                DataItemTableView = SORTING("Evaluation No.", "Activity Code", "Code")
                                 ORDER(Ascending);
                DataItemLink = "Vendor No." = FIELD("Vendor No."),
                            "Activity Code" = FIELD("Activity Code");
                Column(Ct3; Ct3)
                {
                    //SourceExpr=Ct3;
                }
                Column(Ct2; Ct2)
                {
                    //SourceExpr=Ct2;
                }
                Column(Ct1; Ct1)
                {
                    //SourceExpr=Ct1;
                }
                Column(Ct0; Ct0)
                {
                    //SourceExpr=Ct0;
                }
                Column(Datos_Evaluacion_Proveedor__Datos_Evaluacion_Proveedor__Descripcion; "Data Vendor Evaluation".Description)
                {
                    //SourceExpr="Data Vendor Evaluation".Description;
                }
                Column(Datos_calidad_proveedor___Puntuacion_media_revisiones_; "Vendor Quality Data"."Review Score")
                {
                    //SourceExpr="Vendor Quality Data"."Review Score";
                }
                Column(oCaption; oCaptionLbl)
                {
                    //SourceExpr=oCaptionLbl;
                }
                Column(Datos_calidad_proveedor___Puntuacion_media_revisiones_Caption; "Vendor Quality Data".FIELDCAPTION("Review Score"))
                {
                    //SourceExpr="Vendor Quality Data".FIELDCAPTION("Review Score");
                }
                Column(Datos_Evaluacion_Proveedor_Cod__evaluacion; "Evaluation No.")
                {
                    //SourceExpr="Evaluation No.";
                }
                Column(Datos_Evaluacion_Proveedor_Cod__Proveedor; "Vendor No.")
                {
                    //SourceExpr="Vendor No.";
                }
                Column(Datos_Evaluacion_Proveedor_Cod__Actividad; "Activity Code")
                {
                    //SourceExpr="Activity Code";
                }
                Column(Datos_Evaluacion_Proveedor_Codigo; Code)
                {
                    //SourceExpr=Code ;
                }
                trigger OnAfterGetRecord();
                BEGIN
                    CASE "Data Vendor Evaluation".Value OF
                        0:
                            BEGIN
                                Ct0 := 'X';
                                Ct1 := '';
                                Ct2 := '';
                                Ct3 := '';
                            END;
                        1:
                            BEGIN
                                Ct0 := '';
                                Ct1 := 'X';
                                Ct2 := '';
                                Ct3 := '';
                            END;
                        2:
                            BEGIN
                                Ct0 := '';
                                Ct1 := '';
                                Ct2 := 'X';
                                Ct3 := '';
                            END;
                        3:
                            BEGIN
                                Ct0 := '';
                                Ct1 := '';
                                Ct2 := '';
                                Ct3 := 'X';
                            END;
                        ELSE BEGIN
                            Ct0 := '';
                            Ct1 := '';
                            Ct2 := '';
                            Ct3 := '';
                        END;
                    END;
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                CALCFIELDS("No. of Certificates", "No. of Evaluations Total");

                Vendor.GET("Vendor No.");
                NomActividad := '';
                IF ActivityHP.GET("Activity Code") THEN
                    NomActividad := ActivityHP.Description;

                //JAV 06/11/19: - Se ajusta al nuevo certificado de proveedor
                VendorQltyCertif.RESET;
                VendorQltyCertif.SETRANGE("Vendor No.", "Vendor No.");
                // //VendorQltyCertif.SETRANGE("Type Certificate",VendorQltyCertif."Type Certificate"::"0");
                IF VendorQltyCertif.FINDLAST THEN BEGIN
                    CeCals := 'X';
                    CeCaln := '';
                END ELSE BEGIN
                    CeCals := '';
                    CeCaln := 'X';
                END;

                VendorQltyCertif_Item.RESET;
                VendorQltyCertif_Item.SETRANGE("Vendor No.", "Vendor No.");
                // //VendorQltyCertif_Item.SETRANGE("Type Certificate",VendorQltyCertif."Type Certificate"::"1");
                IF VendorQltyCertif_Item.FINDLAST THEN BEGIN
                    CeCalProds := 'X';
                    CeCalProdn := '';
                END ELSE BEGIN
                    CeCalProds := '';
                    CeCalProdn := 'X';
                END;

                VendorQltyCertif_System.RESET;
                VendorQltyCertif_System.SETRANGE("Vendor No.", "Vendor No.");
                // //VendorQltyCertif_System.SETRANGE("Type Certificate",VendorQltyCertif_System."Type Certificate"::"2");
                IF VendorQltyCertif_System.FINDLAST THEN BEGIN
                    SisCals := 'X';
                    SisCaln := '';
                    CASE VendorQltyCertif_System."Reference Standard" OF
                        ' ':
                            BEGIN
                                N9001 := '';
                                N9002 := '';
                                N9003 := '';
                                N0 := '';
                            END;
                        '9001':
                            BEGIN
                                N9001 := 'X';
                                N9002 := '';
                                N9003 := '';
                                N0 := '';
                            END;
                        '9002':
                            BEGIN
                                N9001 := '';
                                N9002 := 'X';
                                N9003 := '';
                                N0 := '';
                            END;
                        '9003':
                            BEGIN
                                N9001 := '';
                                N9002 := '';
                                N9003 := 'X';
                                N0 := '';
                            END;
                        ELSE BEGIN
                            N9001 := '';
                            N9002 := '';
                            N9003 := '';
                            N0 := 'X';
                        END;
                    END;
                END ELSE BEGIN
                    SisCals := '';
                    SisCaln := 'X';
                END;

                VendorQltyCertif_Environ.RESET;
                VendorQltyCertif_Environ.SETRANGE("Vendor No.", "Vendor No.");
                // //VendorQltyCertif_Environ.SETRANGE("Type Certificate",VendorQltyCertif_Environ."Type Certificate"::"3");
                IF VendorQltyCertif_Environ.FINDLAST THEN BEGIN
                    GesMeds := 'X';
                    GesMedn := '';
                    CASE VendorQltyCertif_Environ."Reference Standard" OF
                        ' ':
                            BEGIN
                                NM14001 := '';
                                NM0 := '';
                            END;
                        '14001':
                            BEGIN
                                NM14001 := 'X';
                                NM0 := '';
                            END;
                        ELSE BEGIN
                            NM14001 := '';
                            NM0 := 'X';
                        END;
                    END;
                END ELSE BEGIN
                    GesMeds := '';
                    GesMedn := 'X';
                END;

                Ob1 := COPYSTR("Last Evaluation Observations", 1, 50);
                Ob2 := COPYSTR("Last Evaluation Observations", 51, 50);
                Ob3 := COPYSTR("Last Evaluation Observations", 101, 50);
                Ob4 := COPYSTR("Last Evaluation Observations", 151, 50);
                Ob5 := COPYSTR("Last Evaluation Observations", 201, 50);

                IF "Selected Vendor" THEN BEGIN
                    Pss := 'X';
                    Psn := '';
                END ELSE BEGIN
                    Pss := '';
                    Psn := 'X';
                END;
            END;


        }
    }
    requestpage
    {

        layout
        {
        }
    }
    labels
    {
    }

    var
        //       PurchPayabSetup@7207276 :
        PurchPayabSetup: Record 312;
        //       Vendor@7207275 :
        Vendor: Record 23;
        //       ActivityHP@7207274 :
        ActivityHP: Record 7207280;
        //       VendorQltyCertif@7207273 :
        VendorQltyCertif: Record 7207419;
        //       VendorQltyCertif_Item@7207272 :
        VendorQltyCertif_Item: Record 7207419;
        //       VendorQltyCertif_System@7207271 :
        VendorQltyCertif_System: Record 7207419;
        //       VendorQltyCertif_Environ@7207270 :
        VendorQltyCertif_Environ: Record 7207419;
        //       CeCaln@7207277 :
        CeCaln: Text[1];
        //       CeCals@1100231002 :
        CeCals: Text[1];
        //       CeCalProdn@1100231003 :
        CeCalProdn: Text[1];
        //       CeCalProds@1100231004 :
        CeCalProds: Text[1];
        //       SisCals@1100231005 :
        SisCals: Text[1];
        //       SisCaln@1100231006 :
        SisCaln: Text[1];
        //       N9001@1100231007 :
        N9001: Text[1];
        //       N9002@1100231008 :
        N9002: Text[1];
        //       N9003@1100231009 :
        N9003: Text[1];
        //       N0@1100231010 :
        N0: Text[1];
        //       GesMeds@1100231011 :
        GesMeds: Text[1];
        //       GesMedn@1100231012 :
        GesMedn: Text[1];
        //       NM14001@1100231013 :
        NM14001: Text[1];
        //       NM0@1100231014 :
        NM0: Text[1];
        //       Ct0@1100231015 :
        Ct0: Text[1];
        //       Ct1@1100231016 :
        Ct1: Text[1];
        //       Ct2@1100231017 :
        Ct2: Text[1];
        //       Ct3@1100231018 :
        Ct3: Text[1];
        //       Cp0@1100231019 :
        Cp0: Text[1];
        //       Cp1@1100231020 :
        Cp1: Text[1];
        //       Cp2@1100231021 :
        Cp2: Text[1];
        //       Cp3@1100231022 :
        Cp3: Text[1];
        //       Pe0@1100231023 :
        Pe0: Text[1];
        //       Pe1@1100231024 :
        Pe1: Text[1];
        //       Pe2@1100231025 :
        Pe2: Text[1];
        //       Pe3@1100231026 :
        Pe3: Text[1];
        //       Sp0@1100231027 :
        Sp0: Text[1];
        //       Sp1@1100231028 :
        Sp1: Text[1];
        //       Sp2@1100231029 :
        Sp2: Text[1];
        //       Sp3@1100231030 :
        Sp3: Text[1];
        //       Pc0@1100231031 :
        Pc0: Text[1];
        //       Pc1@1100231032 :
        Pc1: Text[1];
        //       Pc2@1100231033 :
        Pc2: Text[1];
        //       Pc3@1100231034 :
        Pc3: Text[1];
        //       Ms0@1100231035 :
        Ms0: Text[1];
        //       Ms1@1100231036 :
        Ms1: Text[1];
        //       Ms2@1100231037 :
        Ms2: Text[1];
        //       Ms3@1100231038 :
        Ms3: Text[1];
        //       Ob1@1100231039 :
        Ob1: Text[50];
        //       Ob2@1100231040 :
        Ob2: Text[50];
        //       Ob3@1100231041 :
        Ob3: Text[50];
        //       Ob4@1100231042 :
        Ob4: Text[50];
        //       Ob5@1100231043 :
        Ob5: Text[50];
        //       Pss@1100231044 :
        Pss: Text[1];
        //       Psn@1100231045 :
        Psn: Text[1];
        //       NomActividad@1100231047 :
        NomActividad: Text[30];
        //       Varregistro@1100231050 :
        Varregistro: Code[20];
        //       FICHA_GENERAL_DE_PROVEEDOR_SUBCONTRATISTACaptionLbl@1656 :
        FICHA_GENERAL_DE_PROVEEDOR_SUBCONTRATISTACaptionLbl: TextConst ESP = 'FICHA GENERAL DE PROVEEDOR/SUBCONTRATISTA';
        //       Rev_CaptionLbl@5322 :
        Rev_CaptionLbl: TextConst ESP = 'Rev.';
        //       DATOS_GENERALESCaptionLbl@8145 :
        DATOS_GENERALESCaptionLbl: TextConst ESP = 'DATOS GENERALES';
        //       Raz¢n_Social_CaptionLbl@5111 :
        Razon_Social_CaptionLbl: TextConst ESP = 'Raz¢n Social:';
        //       NIF_CIF_CaptionLbl@7183 :
        NIF_CIF_CaptionLbl: TextConst ESP = 'NIF/CIF:';
        //       Direcci¢n_CaptionLbl@8058 :
        Direccion_CaptionLbl: TextConst ESP = 'Direcci¢n:';
        //       Tel‚fono_CaptionLbl@3856 :
        Telefono_CaptionLbl: TextConst ESP = 'Tel‚fono:';
        //       Telefax_CaptionLbl@3390 :
        Telefax_CaptionLbl: TextConst ESP = 'Telefax:';
        //       Persona_de_contacto_CaptionLbl@8791 :
        Persona_de_contacto_CaptionLbl: TextConst ESP = 'Persona de contacto:';
        //       Producto_Servicio_para_el_que_se_le_eval£a_CaptionLbl@4183 :
        Producto_Servicio_para_el_que_se_le_evalEa_CaptionLbl: TextConst ESP = 'Producto/Servicio para el que se le eval£a:';
        //       Proveedor_hist¢rico_CaptionLbl@6393 :
        Proveedor_historico_CaptionLbl: TextConst ESP = 'Proveedor hist¢rico:';
        //       INFORMACIàN_DEL_SISTEMA_DE_CALIDAD_Y_MEDIO_AMBIENTECaptionLbl@3071 :
        INFORMACIàN_DEL_SISTEMA_DE_CALIDAD_Y_MEDIO_AMBIENTECaptionLbl: TextConst ESP = 'INFORMACIàN DEL SISTEMA DE CALIDAD Y MEDIO AMBIENTE';
        //       Certificado_de_calidad_CaptionLbl@6314 :
        Certificado_de_calidad_CaptionLbl: TextConst ESP = 'Certificado de calidad:';
        //       NOCaptionLbl@3338 :
        NOCaptionLbl: TextConst ESP = 'NO';
        //       SICaptionLbl@8945 :
        SICaptionLbl: TextConst ESP = 'SI';
        //       En_caso_afirmativo__indicar_CaptionLbl@6983 :
        En_caso_afirmativo__indicar_CaptionLbl: TextConst ESP = 'En caso afirmativo, indicar:';
        //       N__del_certificado_CaptionLbl@4795 :
        N__del_certificado_CaptionLbl: TextConst ESP = 'N§ del certificado:';
        //       Entidad_de_certificaci¢n_CaptionLbl@8804 :
        Entidad_de_certificacion_CaptionLbl: TextConst ESP = 'Entidad de certificaci¢n:';
        //       Fecha_caducidad_certificado_CaptionLbl@3304 :
        Fecha_caducidad_certificado_CaptionLbl: TextConst ESP = 'Fecha caducidad certificado:';
        //       Certificado_de_calidad_de_producto_CaptionLbl@5120 :
        Certificado_de_calidad_de_producto_CaptionLbl: TextConst ESP = 'Certificado de calidad de producto:';
        //       NOCaption_Control45Lbl@8983 :
        NOCaption_Control45Lbl: TextConst ESP = 'NO';
        //       SICaption_Control48Lbl@2761 :
        SICaption_Control48Lbl: TextConst ESP = 'SI';
        //       En_caso_afirmativo__indicar_Caption_Control49Lbl@4584 :
        En_caso_afirmativo__indicar_Caption_Control49Lbl: TextConst ESP = 'En caso afirmativo, indicar:';
        //       N__del_certificado_Caption_Control56Lbl@4768 :
        N__del_certificado_Caption_Control56Lbl: TextConst ESP = 'N§ del certificado:';
        //       Entidad_de_certificaci¢n_Caption_Control57Lbl@1611 :
        Entidad_de_certificacion_Caption_Control57Lbl: TextConst ESP = 'Entidad de certificaci¢n:';
        //       Fecha_caducidad_certificado_Caption_Control58Lbl@2741 :
        Fecha_caducidad_certificado_Caption_Control58Lbl: TextConst ESP = 'Fecha caducidad certificado:';
        //       Implantaci¢n_del_sistema_de_calidad_CaptionLbl@8591 :
        Implantacion_del_sistema_de_calidad_CaptionLbl: TextConst ESP = 'Implantaci¢n del sistema de calidad:';
        //       NOCaption_Control59Lbl@4549 :
        NOCaption_Control59Lbl: TextConst ESP = 'NO';
        //       SICaption_Control62Lbl@4259 :
        SICaption_Control62Lbl: TextConst ESP = 'SI';
        //       Grado_de_implantaci¢n_CaptionLbl@2883 :
        Grado_de_implantacion_CaptionLbl: TextConst ESP = 'Grado de implantaci¢n:';
        //       Norma_de_refencia_CaptionLbl@9541 :
        Norma_de_refencia_CaptionLbl: TextConst ESP = 'Norma de refencia:';
        //       V9001CaptionLbl@8179 :
        V9001CaptionLbl: TextConst ESP = '9001';
        //       V9002CaptionLbl@8406 :
        V9002CaptionLbl: TextConst ESP = '9002';
        //       V9003CaptionLbl@6750 :
        V9003CaptionLbl: TextConst ESP = '9003';
        //       OtrosCaptionLbl@3450 :
        OtrosCaptionLbl: TextConst ESP = 'Otros';
        //       Norma_de_refencia_Caption_Control78Lbl@6379 :
        Norma_de_refencia_Caption_Control78Lbl: TextConst ESP = 'Norma de refencia:';
        //       Grado_de_implantaci¢n_Caption_Control79Lbl@2159 :
        Grado_de_implantacion_Caption_Control79Lbl: TextConst ESP = 'Grado de implantaci¢n:';
        //       Implantaci¢n_del_sistema_de_gesti¢n_medioambiental_CaptionLbl@4746 :
        Implantacion_del_sistema_de_gestion_medioambiental_CaptionLbl: TextConst ESP = 'Implantaci¢n del sistema de gesti¢n medioambiental:';
        //       V14001CaptionLbl@1565 :
        V14001CaptionLbl: TextConst ESP = '14001';
        //       NOCaption_Control90Lbl@4488 :
        NOCaption_Control90Lbl: TextConst ESP = 'NO';
        //       SICaption_Control97Lbl@2001 :
        SICaption_Control97Lbl: TextConst ESP = 'SI';
        //       OtrosCaption_Control100Lbl@2620 :
        OtrosCaption_Control100Lbl: TextConst ESP = 'Otros';
        //       NOCaption_Control213Lbl@4012 :
        NOCaption_Control213Lbl: TextConst ESP = 'NO';
        //       SICaption_Control217Lbl@4367 :
        SICaption_Control217Lbl: TextConst ESP = 'SI';
        //       EmptyStringCaptionLbl@5389 :
        EmptyStringCaptionLbl: TextConst ESP = '%';
        //       EmptyStringCaption_Control188Lbl@1533 :
        EmptyStringCaption_Control188Lbl: TextConst ESP = '%';
        //       Fecha_CaptionLbl@4743 :
        Fecha_CaptionLbl: TextConst ESP = 'Fecha:';
        //       Hoja_1_de_2CaptionLbl@3681 :
        Hoja_1_de_2CaptionLbl: TextConst ESP = 'Hoja 1 de 2';
        //       C¢d__ProveedorCaptionLbl@9727 :
        Cod__ProveedorCaptionLbl: TextConst ESP = 'C¢d. Proveedor';
        //       ActividadCaptionLbl@5070 :
        ActividadCaptionLbl: TextConst ESP = 'Actividad';
        //       C_P__CaptionLbl@7777 :
        C_P__CaptionLbl: TextConst ESP = ' C.P.:';
        //       Poblaci¢n_CaptionLbl@2534 :
        Poblacion_CaptionLbl: TextConst ESP = 'Poblaci¢n:';
        //       Provincia_CaptionLbl@1934 :
        Provincia_CaptionLbl: TextConst ESP = 'Provincia:';
        //       FICHA_GENERAL_DEL_PROVEEDOR_SUBCONTRATISTACaptionLbl@5841 :
        FICHA_GENERAL_DEL_PROVEEDOR_SUBCONTRATISTACaptionLbl: TextConst ESP = 'FICHA GENERAL DEL PROVEEDOR/SUBCONTRATISTA';
        //       EVALUACIàN_Y_SELECCIàN_DEL_PROVEEDOR_SUBCONTRATISTACaptionLbl@2015 :
        EVALUACIàN_Y_SELECCIàN_DEL_PROVEEDOR_SUBCONTRATISTACaptionLbl: TextConst ESP = 'EVALUACIàN Y SELECCIàN DEL PROVEEDOR/SUBCONTRATISTA';
        //       Hoja_2_de_2CaptionLbl@9210 :
        Hoja_2_de_2CaptionLbl: TextConst ESP = 'Hoja 2 de 2';
        //       Certificado_de_calidad_de_producto_Caption_Control103Lbl@1358 :
        Certificado_de_calidad_de_producto_Caption_Control103Lbl: TextConst ESP = 'Certificado de calidad de producto:';
        //       V0CaptionLbl@4298 :
        V0CaptionLbl: TextConst ESP = '0';
        //       V1CaptionLbl@4525 :
        V1CaptionLbl: TextConst ESP = '1';
        //       V2CaptionLbl@2869 :
        V2CaptionLbl: TextConst ESP = '2';
        //       V3CaptionLbl@4244 :
        V3CaptionLbl: TextConst ESP = '3';
        //       Requisitos_a_valorar_CaptionLbl@2939 :
        Requisitos_a_valorar_CaptionLbl: TextConst ESP = 'Requisitos a valorar:';
        //       Fecha_Caption_Control232Lbl@8457 :
        Fecha_Caption_Control232Lbl: TextConst ESP = 'Fecha:';
        //       Rev_Caption_Control234Lbl@5740 :
        Rev_Caption_Control234Lbl: TextConst ESP = 'Rev.';
        //       FechaCaptionLbl@1113491310 :
        FechaCaptionLbl: TextConst ESP = 'Fecha';
        //       Programas_inform ticosCaptionLbl@1169790060 :
        Programas_informaticosCaptionLbl: TextConst ESP = 'Programas informaticos';
        //       Equipos_o_maquinariasCaptionLbl@1152713679 :
        Equipos_o_maquinariasCaptionLbl: TextConst ESP = 'Equipos o maquinarias';
        //       N__DirectivoCaptionLbl@1103418181 :
        N__DirectivoCaptionLbl: TextConst ESP = 'N§ Directivo';
        //       N__T‚cnicoCaptionLbl@1195378351 :
        N__TacnicoCaptionLbl: TextConst ESP = 'N§ T‚cnico';
        //       N__EmpleadoCaptionLbl@1196451390 :
        N__EmpleadoCaptionLbl: TextConst ESP = 'N§ Empleado';
        //       Nombre_de_clientesCaptionLbl@1155229279 :
        Nombre_de_clientesCaptionLbl: TextConst ESP = 'Nombre de clientes';
        //       Firmado___Director_de_comprasCaptionLbl@1112232145 :
        Firmado___Director_de_comprasCaptionLbl: TextConst ESP = 'Firmado:  Director de compras';
        //       OBSERVACIONESCaptionLbl@1151743238 :
        OBSERVACIONESCaptionLbl: TextConst ESP = 'OBSERVACIONES';
        //       PersonalCaptionLbl@1122463270 :
        PersonalCaptionLbl: TextConst ESP = 'Personal';
        //       NOCaption_Control1100231029Lbl@1163653154 :
        NOCaption_Control1100231029Lbl: TextConst ESP = 'NO';
        //       SICaption_Control1100231032Lbl@1142529295 :
        SICaption_Control1100231032Lbl: TextConst ESP = 'SI';
        //       Proveedor_seleccionadoCaptionLbl@1126925368 :
        Proveedor_seleccionadoCaptionLbl: TextConst ESP = 'Proveedor seleccionado';
        //       Firmado___Director_de_comprasCaption_Control1100231035Lbl@1182249167 :
        Firmado___Director_de_comprasCaption_Control1100231035Lbl: TextConst ESP = 'Firmado:  Director de compras';
        //       FechaCaption_Control1100231036Lbl@1109864214 :
        FechaCaption_Control1100231036Lbl: TextConst ESP = 'Fecha';
        //       Observaciones_a_la_evaluaci¢nCaptionLbl@1144362851 :
        Observaciones_a_la_evaluacionCaptionLbl: TextConst ESP = 'Observaciones a la evaluaci¢n';
        //       oCaptionLbl@5383 :
        oCaptionLbl: TextConst ESP = 'o';



    trigger OnPreReport();
    begin
        PurchPayabSetup.GET;
    end;



    /*begin
        {
          JAV 06/11/19: - Se ajusta al nuevo certificado de proveedor
        }
        end.
      */

}



