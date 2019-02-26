public class WarehouseSyncSchedule implements Schedulable {

    // WarehouseSyncSchedule syncSchedule = new WarehouseSyncSchedule();
    // String cronExp = '0 0 1 * * ?';
    // System.schedule('Synchronize warehouse equipment', cronExp, syncSchedule);

    public void execute(SchedulableContext context) {
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }
}