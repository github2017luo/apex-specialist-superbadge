public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @Future(callout = true)
    public static void runWarehouseEquipmentSync() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200) {
            String parsedResponse = parseInput(response.getBody());
            List<SObject> results = (List<SObject>) JSON.deserialize(parsedResponse, List<Product2>.class);
            
            upsert results;
        
        } else {
            System.debug('Response status code:' + response.getStatusCode()
                            + '. Status message: ' + response.getStatus());
        }
    }

    private static String parseInput(String rawInput) {
        // ignoring '_id' field as it's not valid Salesforce id
        return rawInput.replace('replacement', 'Replacement_Part__c')
                       .replace('quantity', 'QuantityUnitOfMeasure')
                       .replace('name', 'Name')
                       .replace('maintenanceperiod', 'Maintenance_Cycle__c')
                       .replace('lifespan', 'Lifespan_Months__c')
                       .replace('cost', 'Cost__c')
                       .replace('sku', 'Warehouse_SKU__c');
    }

}