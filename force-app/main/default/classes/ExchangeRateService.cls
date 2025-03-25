/**
 * @description Service class that handles API callouts to the Exchange Rate API
 * Students will implement the methods to make callouts and process responses
 */
public with sharing class ExchangeRateService {
    
    // The named credential to use for the callout
    private static final String NAMED_CREDENTIAL = 'ExchangeRate_API';
    
    // The base currency to use for exchange rates
    private static final String BASE_CURRENCY = 'USD';

    //API Key stored in Custom Metadata Type
    private static final String API_KEY = [SELECT API_KEY__c FROM API_Key_Vault__mdt WHERE DeveloperName ='ExchangeRateKey'].API_KEY__c;
    
    /**
     * @description Makes a callout to the Exchange Rate API to get the latest exchange rates
     * @return ExchangeRateWrapper containing the response data
     */
    public static ExchangeRateWrapper getLatestRates() {
        
        // TODO: Implement the method to make a callout to the Exchange Rate API
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' +  API_KEY  + '/latest/' + BASE_CURRENCY);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse res = h.send(req);

        if(res.getStatusCode() < 200 || res.getStatusCode() > 299){
            throw new CalloutException('Error: ' + res.getStatusCode());
        }

        ExchangeRateWrapper wrapper = ExchangeRateWrapper.parse(res.getBody());
        return wrapper;
    }
    
    
    /**
     * @description Processes the exchange rate data and creates or updates records
     * @param rateData The wrapper containing exchange rate data
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    
     public static List<Exchange_Rate__c> processRates(ExchangeRateWrapper rateData) {
        // TODO: Implement the method to process rates and create/update records
        ExchangeRateWrapper wrapperInstance = new ExchangeRateWrapper();
        List<Exchange_Rate__c> exchangeRates = wrapperInstance.toExchangeRates(rateData);
        return exchangeRates; 
    }
    
    /**
     * @description Combines getting and processing rates into a single operation
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    
     public static List<Exchange_Rate__c> updateExchangeRates() {
        List<Exchange_Rate__c> exchangeRates = new List<Exchange_Rate__c>();
        // TODO: Implement the method to get and process rates
        // 1. Call getLatestRates to retrieve the data
        ExchangeRateWrapper rateData = getLatestRates();
        // 2. Call processRates to create/update records
        exchangeRates = ExchangeRateService.processRates(rateData);
        System.debug('Exchange Rates: ' + exchangeRates);
        // 3. Return the list of records

        return exchangeRates;
    }

    

}