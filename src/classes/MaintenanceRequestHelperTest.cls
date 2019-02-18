@isTest
private class MaintenanceRequestHelperTest {

    @TestSetup
    static void prepareData() {
        List<Case> requests = new List<Case>();

        for(Integer i = 0; i < 5; i++) {
            String type = (Math.mod(i, 2) == 0) ? 'Routine Maintenance' : 'Repair';

            Case request = new Case(
                Subject = 'Some subject',
                Type = type,
                Status = 'In Progress',
                Vehicle__c = new Vehicle__c().Id,
                Equipment__c = new Product2().Id,
                Date_Reported__c = Date.today()
            );

            requests.add(request);
        }

        insert requests;
    }

    @isTest
    private static void testUpdateWorkersNegative() {
        Map<Id, Case> oldRequests = new Map<Id, Case>();

        for(Case request : [SELECT Id, Status, Type, Subject FROM Case]) {
            oldRequests.put(request.Id, request);
        }

        Map<Id, Case> newRequests = oldRequests.deepClone();

        for(Case request : newRequests.values()) {
            request.Subject = 'Some other subject then before';
        }

        Test.startTest();
        MaintenanceRequestHelper.updateWorkOrders(oldRequests, newRequests);
        Test.stopTest();

        List<Case> requestsAfterTest = [SELECT Id FROM Case];
        System.assertEquals(oldRequests.size(), requestsAfterTest.size());
    }

    @isTest
    private static void testUpdateWorkersPositive() {
        Map<Id, Case> oldRequests = new Map<Id, Case>();

        // variables to compare in asserts
        Id vehicle;
        Id equipment;

        for(Case request : [SELECT Id, Status, Type, Subject, Vehicle__c, Equipment__c FROM Case]) {
            oldRequests.put(request.Id, request);
        }

        Map<Id, Case> newRequests = oldRequests.deepClone();

        Integer skippingCounter = 0;

        for(Case request : newRequests.values()) {
            skippingCounter++;

            if(skippingCounter != 4)
                continue;

            request.Status = 'Closed';

            vehicle = request.Vehicle__c;
            equipment = request.Equipment__c;
        }

        Test.startTest();
        MaintenanceRequestHelper.updateWorkOrders(oldRequests, newRequests);
        Test.stopTest();

        List<Case> newlyCreatedRequests = [SELECT Subject, Type, Status, Vehicle__c,
                                            Equipment__c, Date_Reported__c
                                            FROM Case WHERE Status = 'New'];
                                            
        System.assertEquals(1, newlyCreatedRequests.size());
        
        for(Case request : newlyCreatedRequests) {
            System.assertEquals('Routine Maintenance', request.Subject);
            System.assertEquals('Routine Maintenance', request.Type);
            System.assertEquals(vehicle, request.Vehicle__c);
            System.assertEquals(equipment, request.Equipment__c);
            System.assertEquals(Date.today(), request.Date_Reported__c);
        }
    }
}