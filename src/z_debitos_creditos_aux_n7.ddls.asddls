@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debitos y Creditos por Cta Nivel 7 por Tercero'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_DEBITOS_CREDITOS_AUX_N7
  with parameters
    FechaInicial : datum,
    FechaFinal   : datum
    
         as select from Z_DEBITOS_CREDITOS (FechaInicial : $parameters.FechaInicial , FechaFinal : $parameters.FechaFinal) as Sumatoria
{
  key left(Sumatoria.GLAccount,8) as GLAccount,
  sum(Sumatoria.Debito) as DebitoAux,
  sum(Sumatoria.Credito) as CreditoAux,
   Sumatoria.AccountingDocumentItem as Linea
  
}
where Sumatoria.PostingDate >= $parameters.FechaInicial 
and  Sumatoria.PostingDate <= $parameters.FechaFinal

group by  Sumatoria.GLAccount, Sumatoria.AccountingDocumentItem 
    /*
  as select from Z_BALANCE_TERCEROS_HBT (FechaInicio : $parameters.FechaInicial , FechaFin : $parameters.FechaFinal) as Sumatoria
    inner join   Z_SOCIOS_BALANCE                                                                                    as Socios on Socios.NitSN   = Sumatoria.Tercero_Referencia
                                                                                                                               or Socios.SocioBP = Sumatoria.YY1_HBT_Tercero_S4_COB
{
  key left(Sumatoria.GLAccount,9) as GLAccount,
      sum(Sumatoria.Debito)       as DebitoAux,
      sum(Sumatoria.Credito)      as CreditoAux,
      Sumatoria.AccountingDocument,
      Sumatoria.CompanyCode,
      Sumatoria.FiscalYear,
      Sumatoria.LedgerGLLineItem,
      Sumatoria.AccountingDocumentType,
      Sumatoria.PostingDate,
      Sumatoria.FiscalPeriod,
      Sumatoria.TransactionCurrency,
      Sumatoria.ReferenceDocumentType,
      Sumatoria.OriginalReferenceDocument,
      Sumatoria.Debito,
      Sumatoria.Credito,
      Sumatoria.Bandera,
      Sumatoria.YY1_HBT_Tercero_S4_COB,
      Sumatoria.Tercero_Referencia,
      case when Sumatoria.Bandera = 'FIELREF' and Sumatoria.YY1_HBT_Tercero_S4_COB = '' or Sumatoria.YY1_HBT_Tercero_S4_COB is null or Sumatoria.YY1_HBT_Tercero_S4_COB is initial
      then Socios.NitSN
      when Sumatoria.Bandera = 'FIELUSR' and Sumatoria.Tercero_Referencia = '' or Sumatoria.Tercero_Referencia is null or Sumatoria.Tercero_Referencia is initial
      then Socios.NitSN
      else '0' end                as Ref1,
      Sumatoria.Ref2,
      Sumatoria.Ref3,
      Sumatoria.AssignmentReference,
      Sumatoria.Centro,
      Sumatoria.ProfitCenter,
      Sumatoria.PartnerProfitCenter,
      Sumatoria.PartnerSegment,
      Sumatoria.CostCenter,
      Sumatoria.TaxCode,
      Sumatoria.ReferenceDocumentItem,
      Sumatoria.DocumentItemText,
      Sumatoria.AccountAssignment,
      Sumatoria.YY1_HBTTercero_COB,
      Sumatoria.YY1_HBT_Tercero_JEI,
      Sumatoria.AccountingDocumentItem

}
where
      Sumatoria.PostingDate >= $parameters.FechaInicial
  and Sumatoria.PostingDate <= $parameters.FechaFinal

group by
  Sumatoria.GLAccount,
  Sumatoria.AccountingDocument,
  Sumatoria.CompanyCode,
  Sumatoria.FiscalYear,
  Sumatoria.LedgerGLLineItem,
  Sumatoria.AccountingDocumentType,
  Sumatoria.PostingDate,
  Sumatoria.FiscalPeriod,
  Sumatoria.TransactionCurrency,
  Sumatoria.ReferenceDocumentType,
  Sumatoria.OriginalReferenceDocument,
  Sumatoria.Debito,
  Sumatoria.Credito,
  Sumatoria.Ref1,
  Sumatoria.Ref2,
  Sumatoria.Ref3,
  Sumatoria.AssignmentReference,
  Sumatoria.Centro,
  Sumatoria.ProfitCenter,
  Sumatoria.PartnerProfitCenter,
  Sumatoria.PartnerSegment,
  Sumatoria.CostCenter,
  Sumatoria.TaxCode,
  Sumatoria.ReferenceDocumentItem,
  Sumatoria.DocumentItemText,
  Sumatoria.AccountAssignment,
  Sumatoria.YY1_HBTTercero_COB,
  Sumatoria.YY1_HBT_Tercero_S4_COB,
  Sumatoria.YY1_HBT_Tercero_JEI,
  Sumatoria.AccountingDocumentItem,
  Sumatoria.Bandera,Sumatoria.Tercero_Referencia,
  Socios.NitSN
  */
