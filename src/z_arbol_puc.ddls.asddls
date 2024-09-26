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
  as select distinct from Z_JERARQUIA_PUC as PUC
    left outer join       Z_NOMCUENTA     as NomCuenta on PUC.Cuenta = NomCuenta.GLAccount
{
  key PUC.Cuenta,
      PUC.Company,
      left( PUC.Cuenta , 3 )  as DigitoC,
      NomCuenta.GLAccountName as Nombre_Cajon,
      length( PUC.Cuenta )    as Longitud,

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
      end                     as Nivel_Cuenta



}
where
      left( PUC.Cuenta , 3 ) <> '0'
  and left( PUC.Cuenta , 3 ) <> '00'
