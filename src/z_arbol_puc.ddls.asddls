@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Arbol de Cuentas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_ARBOL_PUC
  as select distinct from Z_JERARQUIA_PUC as PUC left outer join Z_NOMCUENTA as NomCuenta on PUC.Cuenta = NomCuenta.GLAccount
{
  key PUC.Cuenta,PUC.Company,
      left( PUC.Cuenta , 3 ) as DigitoC,
      /*case left( PUC.Cuenta, 3 )
              when '001' then 'Activo'
              when '002' then 'Pasivo'
              when '003' then 'Patrimonio'
              when '004' then 'Ingresos'
              when '005' then 'Gastos'
              when '006' then 'Costos'
              when '007' then 'Costos de Produccion o de Operacion'
              when '008' then 'Otros Gastos'
              when '009' then 'Cajon 9'
              else*/ NomCuenta.GLAccountName
             /* end        */    as Nombre_Cajon,
      length( PUC.Cuenta )   as Longitud,

      case
        when length( PUC.Cuenta ) = 3
      then 'Nivel1'
      when length( PUC.Cuenta ) = 4
      then 'Nivel2'
        when length( PUC.Cuenta ) = 5
      then 'Nivel3'
      when length( PUC.Cuenta ) = 6
      then 'Nivel4'
      when length( PUC.Cuenta ) = 7
      then 'Nivel5'
      when length( PUC.Cuenta ) = 8
        then 'Nivel6'
         when length( PUC.Cuenta ) = 9
        then 'Nivel7'
         when length( PUC.Cuenta ) = 10
        then 'Nivel8'

          else 'XXX'
      end                    
      as Nivel_Cuenta



}
where
      left( PUC.Cuenta , 3 ) <> '0'
  and left( PUC.Cuenta , 3 ) <> '00'
