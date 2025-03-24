import { LightningElement, wire } from 'lwc';
import getExchangeRates from '@salesforce/apex/ExchangeRateController.getExchangeRates';

const columns = [
    { label: 'Base Currency', fieldName: 'Base_Currency__c' },
    { label: 'Target Currency', fieldName: 'Target_Currency__c'},
    { label: 'Rate', fieldName: 'Rate__c'},
    { label: 'Last Updated', fieldName: 'Last_Updated__c'}
];

export default class ExchangeRateTable extends LightningElement {
    data = [];
    filteredData = [];
    columns = columns;
    error;

    baseCurrencyFilter ='';
    targetCurrencyFilter = '';

    @wire(getExchangeRates)
    wiredExchangeRates({ error, data }) {
        if (data) {
            this.data = data;
            this.filteredData = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
            this.filteredData = [];
        }
    }

    handleBaseCurrencySearch(event){
        this.baseCurrencyFilter = event.target.value.toLowerCase();
        this.filterData();
    }

    handleTargetCurrencySearch(event){
        this.targetCurrencyFilter = event.target.value.toLowerCase();
        this.filterData();
    }

    filterData(){
        if (!this.data) {
            this.filteredData = [];
            return;
        }

        this.filteredData = this.data.filter(row => {
            const baseCurrencyMatch = this.baseCurrencyFilter
                ? row.Base_Currency__c?.toLowerCase().includes(this.baseCurrencyFilter)
                : true;

            const targetCurrencyMatch = this.targetCurrencyFilter
                ? row.Target_Currency__c?.toLowerCase().includes(this.targetCurrencyFilter)
                : true;

            return baseCurrencyMatch && targetCurrencyMatch;
        });
    }
}