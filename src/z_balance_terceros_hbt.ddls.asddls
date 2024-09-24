@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Balance de prueba por terceros HBT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define view entity Z_BALANCE_TERCEROS_HBT
  with parameters
    FechaInicio : datum,
    FechaFin    : datum



  as select distinct from Z_DIARIO_NIVEL_6          as Balance
    left outer join       I_OperationalAcctgDocItem as Referencias on  Referencias.CompanyCode            = Balance.CompanyCode
                                                                   and Referencias.AccountingDocument     = Balance.AccountingDocument
                                                                   and Referencias.FiscalYear             = Balance.FiscalYear
                                                                   and Referencias.AccountingDocumentItem = Balance.AccountingDocumentItem
   left outer join Z_SOCIOS_BALANCE as Socios on Socios.NitSN = Referencias.Reference1IDByBusinessPartner  or Socios.SocioBP = Balance.YY1_HBT_Tercero_S4_COB
   
   
  
   
{


  key  Balance.AccountingDocument,
  key  Balance.CompanyCode,
  key  Balance.FiscalYear,
       Balance.LedgerGLLineItem,
       Balance.AccountingDocumentType,
       Balance.PostingDate,
       Balance.FiscalPeriod,
       --Balance.CreationTime,
       -- Balance.AccountingDocCreatedByUser,
       --Balance.TransactionCode,
       --Balance.DocumentReferenceID,
       Balance.TransactionCurrency,
       -- Balance.BusinessTransactionType,
       Balance.ReferenceDocumentType,
       Balance.OriginalReferenceDocument,
       Balance.GLAccount,
       --Balance.SaldoInicial,
       Balance.Debito,
       Balance.Credito,
       -- Balance.SaldoInicial + Balance.Debito - Balance.Credito as SaldoFinal,
       
       
       case when Balance.YY1_HBT_Tercero_S4_COB is initial
       then Referencias.Reference1IDByBusinessPartner
       else Balance.YY1_HBT_Tercero_S4_COB
       end as Ref1,
       
         case when Balance.YY1_HBT_Tercero_S4_COB is initial
       then Socios.SocioBP --Referencias.Reference2IDByBusinessPartner
       else Socios.SocioBP
       end as Ref2,
       
         case when Balance.YY1_HBT_Tercero_S4_COB is initial
       then Socios.NombreSN---Referencias.Reference3IDByBusinessPartner
       else Socios.NombreSN
       end as Ref3,
       
       
       /*
       Referencias.Reference1IDByBusinessPartner as Ref1,
       Referencias.Reference2IDByBusinessPartner as Ref2,
       Referencias.Reference3IDByBusinessPartner as Ref3,
       */

       case when Balance.YY1_HBTTercero_COB is initial
       then concat_with_space(Referencias.Reference1IDByBusinessPartner,Referencias.Reference3IDByBusinessPartner,1)
       else Balance.YY1_HBT_Tercero_S4_COB
       end                                       as YY1_HBTTercero_COB,


       case when Balance.YY1_HBT_Tercero_S4_COB is initial
       then  Referencias.Reference1IDByBusinessPartner
       --concat_with_space(Referencias.Reference1IDByBusinessPartner,Referencias.Reference3IDByBusinessPartner,1)
       else Balance.YY1_HBT_Tercero_S4_COB
       end                                       as YY1_HBT_Tercero_S4_COB,

       case when Balance.YY1_HBT_Tercero_JEI is initial
       then concat_with_space(Referencias.Reference1IDByBusinessPartner,Referencias.Reference3IDByBusinessPartner,1)
       else Balance.YY1_HBT_Tercero_S4_COB
       end                                       as YY1_HBT_Tercero_JEI,

       Balance.AssignmentReference,
       Balance.Plant                             as Centro,
       --Balance.AccountAssignmentType,
       Balance.ProfitCenter,
       Balance.PartnerProfitCenter,
       /*Balance.Segment,*/
       Balance.PartnerSegment,
       Balance.CostCenter,
       Balance.TaxCode,
       Balance.ReferenceDocumentItem,
       Balance.DocumentItemText,
       Balance.AccountAssignment,

       Balance.AccountingDocumentItem,
       Balance.Ledger



}

where
      Balance.PostingDate >= $parameters.FechaInicio
  and Balance.PostingDate <= $parameters.FechaFin
