@AbapCatalog.sqlViewName: 'Z_ITEM_BP_HBT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bp con partidas abiertas'
define view Z_OPEN_ITEMS_BP_HBT
as select distinct from I_BusinessPartner as partner
join I_OperationalAcctgDocItem as openItem
on partner.BusinessPartner = openItem.Customer


{
   key partner.BusinessPartner
}

where openItem.AmountInCompanyCodeCurrency < 0 and openItem.ClearingJournalEntry = '' and openItem.DebitCreditCode = 'H'
and openItem.InvoiceReference = '' and (openItem.AccountingDocumentType = 'DZ' or openItem.AccountingDocumentType = 'RV')

group by partner.BusinessPartner

