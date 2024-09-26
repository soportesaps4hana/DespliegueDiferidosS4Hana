@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista Final Balance de prueba HBT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED

}

define view entity Z_INFORME_BALANCE_TERCEROS_HBT 
with parameters
     FechaInicio : datum,
    FechaFin    : datum as
     select distinct from Z_BALANCE_PRUEBA_TERCEROS_HBT( FechaInicio: $parameters.FechaInicio , FechaFin: $parameters.FechaFin ) as BAL
    --as select from Z_BALANCE_PRUEBA_TERCEROS_HBT( FechaInicio: '20240101' , FechaFin: '20240522' ) 
   --- left outer join Z_SOCIOS_BALANCE as Socios on BAL.NIT  = Socios.NitSN 
    
{
   key BAL.Cuenta,
    --DigitoC,
    --Longitud,
    --Nivel_Cuenta,
    
    BAL.Nombre_Cajon as NombreCuenta,
    BAL.SaldoInicial,
    BAL.Debito,
    BAL.Credito,
    (BAL.SaldoInicial + BAL.Debito - BAL.Credito ) as SaldoFinal,
    BAL.AccountingDocument,
    substring(BAL.Linea,5,6) as Linea,    
    BAL.NIT,
    -- Socios.SocioBP as Codigo,
    -- substring(Socios.NombreSN,1,18) as Nombre,
      
    BAL.Codigo,
    substring(BAL.Nombre,1,18) as Nombre,
    
    
    BAL.PostingDate as FechaContabilizacion,
    BAL.CompanyCode,
    --FiscalYear,
    --FiscalPeriod,
    --TransactionCurrency,
    BAL.Centro,
    BAL.ProfitCenter as CentroBeneficio,
    --PartnerProfitCenter,
    BAL.CostCenter as CentroCosto,
    BAL.TaxCode as CodigoImpuesto
    --ReferenceDocumentItem
    
    
}
where BAL.Longitud != 9
---where Longitud != 8 and Longitud != 10


