public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(Map<Id, Case> oldRequests, Map<Id, Case> newRequests) {
        List<Case> newMaintenanceRequestsToInsert = new List<Case>();

        for(Id requestId : newRequests.keySet()) {
            Case oldRequest = oldRequests.get(requestId);
            Case newRequest = newRequests.get(requestId);

            if(oldRequest.Status != 'Closed' && newRequest.Status == 'Closed'
                && newRequest.Type == 'Repair' || newRequest.Type == 'Routine Maintenance') {

                    Case newMaintenanceRequest = new Case(
                        Subject = 'Routine Maintenance',
                        Type = 'Routine Maintenance',
                        Status = 'New',
                        Vehicle__c = newRequest.Vehicle__c,
                        Equipment__c = newRequest.Equipment__c,
                        Date_Reported__c = Date.today()
                    );

                    newMaintenanceRequestsToInsert.add(newMaintenanceRequest);
            }
        }

        insert newMaintenanceRequestsToInsert;
    }        
}