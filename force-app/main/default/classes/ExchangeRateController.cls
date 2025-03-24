public with sharing class ExchangeRateController {
    @AuraEnabled (cacheable = true)
    public static List<Exchange_Rate__c> getExchangeRates(){
      return [SELECT Id, Name, Base_Currency__c, Target_Currency__c, Rate__c, Last_Updated__c FROM Exchange_Rate__c];
    }

}