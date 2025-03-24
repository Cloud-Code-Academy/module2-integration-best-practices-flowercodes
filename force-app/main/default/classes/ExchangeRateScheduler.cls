/**
 * @description Scheduler class to run the exchange rate update on a schedule
 * Scheduling should be done in Salesforce Setup Apex Classes -> Schedule Apex
 */
global class ExchangeRateScheduler implements Schedulable {
    
    /**
     * @description Executes the scheduled job to update exchange rates
     * @param context The SchedulableContext
     */
    global void execute(SchedulableContext SC) {
        // TODO: Implement the method to update exchange rates
        // 1. Call ExchangeRateService.updateExchangeRates()
        // 2. Add error handling
        try{
            ExchangeRateWrapper wrapper = ExchangeRateService.getLatestRates();
        ExchangeRateService.processRates(wrapper);
        } catch(Exception e){
            System.debug('An error has occurred upon update of exchange rates: ' + e.getMessage());
        }
        
        // 3. Consider adding logging if available
    }
}