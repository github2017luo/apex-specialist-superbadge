@isTest
private class MaintanceRequestTriggerTest {

    @TestSetup
    private static void prepareData() {
        List<Case> newRequests = new List<Case>();

        for(Integer i = 0; i < 300; i++) {
            String type = (Math.mod(i, 5) == 0) ? 'Routine Maintenance' : 'Repair';

            Case newRequest = new Case(
                Subject = 'Some subject',
                Type = type,
                Status = 'In Progress',
                Vehicle__c = new Vehicle__c().Id,
                Equipment__c = new Product2().Id,
                Date_Reported__c = Date.today()
            );

            newRequests.add(newRequest);
        }

        insert newRequests;    
    }

    @isTest
    private static void testBeforeUpdateNegative() {
        List<Case> requests = [SELECT Status, Type, Subject FROM Case];

        Integer skippingCounter = 0;

        for(Case request : requests) {
            skippingCounter++;

            if(Math.mod(skippingCounter, 100) != 0)
                continue;

            request.Subject = 'Some other subject than before';
        }

        Test.startTest();
        update requests;
        Test.stopTest();

        List<Case> requestsAfterTest = [SELECT Id FROM Case];
        System.assertEquals(requests.size(), requestsAfterTest.size());
    }

    @isTest
    private static void testBeforeUpdatePositive() {
        List<Case> requests = [SELECT Status, Type, Vehicle__c, Equipment__c FROM Case];

        // variables to compare in asserts
        Id vehicle;
        Id equipment;

        Integer skippingCounter = 0;

        for(Case request : requests) {
            skippingCounter++;

            if(skippingCounter != 256)
                continue;

            request.Status = 'Closed';
            vehicle = request.Vehicle__c;
            equipment = request.Equipment__c;
            
        }

        Test.startTest();
        update requests;
        Test.stopTest();

        List<Case> requestsAfterTest = [SELECT Subject, Type, Vehicle__c,
                                        Equipment__c, Date_Reported__c
                                        FROM Case WHERE Status = 'New'];

        System.assertEquals(1, requestsAfterTest.size());

        for(Case request : requestsAfterTest) {
            System.assertEquals('Routine Maintenance', request.Subject);
            System.assertEquals('Routine Maintenance', request.Type);
            System.assertEquals(vehicle, request.Vehicle__c);
            System.assertEquals(equipment, request.Equipment__c);
            System.assertEquals(Date.today(), request.Date_Reported__c);
        }
    }
}