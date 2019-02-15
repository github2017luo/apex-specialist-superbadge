trigger MaintenanceRequest on Case (before update, after update) {

    if(Trigger.isBefore && Trigger.isUpdate) {
        MaintenanceRequestHelper.updateWorkOrders(Trigger.oldMap, Trigger.newMap);
    }
}