@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Nombre Cuenta Contable en español'
define view entity Z_NOMCUENTA as select from I_GlAccountTextInCompanycode as BD1
{
 key BD1.GLAccount,
 key BD1.CompanyCode,
  BD1.Language,
  BD1.ChartOfAccounts,
  BD1.GLAccountName,
  BD1.GLAccountLongName


} where BD1.Language='S'
