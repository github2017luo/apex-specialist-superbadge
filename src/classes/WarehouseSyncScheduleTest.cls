@isTest
private class WarehouseSyncScheduleTest {

    @isTest
    private static void testExecutePositive() {
        WarehouseSyncSchedule syncSchedule = new WarehouseSyncSchedule();
        String cronExp = '0 0 1 * * ?';

        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(true));
        
        Test.startTest();
        String jobId = System.schedule('Test synchronization', cronExp, syncSchedule);
        Test.stopTest();

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
                          
        System.assertEquals(cronExp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(calculateNextFireTime(), ct.NextFireTime);
    }

    private static DateTime calculateNextFireTime() {
        // declared this way to get only today's date with hour 00:00:000
        DateTime nextFireTime = (DateTime) Date.today();

        // set it to the next day only if test is executed after 1:00AM
        if(DateTime.now().hour() > 1) {
            nextFireTime = nextFireTime.addDays(1);
        }

        return nextFireTime.addHours(1);
    }
}