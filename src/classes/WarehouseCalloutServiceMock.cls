public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    public static final Integer EQUIPMENT_COUNT = 5;

    private Boolean isSuccessful;
    
    public WarehouseCalloutServiceMock(Boolean isSuccessful) {
        this.isSuccessful = isSuccessful;
    }

    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-type', 'application/json');

        if(this.isSuccessful) {
            res.setStatusCode(200);

            String body = '[';
            for(Integer i = 0; i < EQUIPMENT_COUNT; i++) {
                body += '{"_id":"55d66226726b611100aaf74' + i + '","replacement":false,"quantity":3,"name":"Item' 
                            + i + '","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"10000' + i + '"}';

                if(i < EQUIPMENT_COUNT - 1)
                    body += ',';
            }

            res.setBody(body + ']');
        }

        else {
            res.setStatusCode(404);
            res.setBody('');
        }

        return res;
    }
}