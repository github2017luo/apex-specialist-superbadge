@isTest
private class WarehouseCalloutServiceTest {

    @isTest
    private static void testRunWarehouseEquipmentSyncPositive() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(true));
        
        List<Product2> equipment = [SELECT Id FROM Product2];
        System.assertEquals(0, equipment.size());

        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        equipment = [SELECT Id FROM Product2];
        System.assertEquals(WarehouseCalloutServiceMock.EQUIPMENT_COUNT, equipment.size());
    }

    @isTest
    private static void testRunWarehouseEquipmentSyncNegative() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(false));
        
        List<Product2> equipment = [SELECT Id FROM Product2];
        System.assertEquals(0, equipment.size());

        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();

        equipment = [SELECT Id FROM Product2];
        System.assertEquals(0, equipment.size());
    }
}