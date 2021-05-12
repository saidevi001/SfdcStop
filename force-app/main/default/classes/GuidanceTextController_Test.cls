@isTest class GuidanceTextController_Test {
    
    static Id recordTypeId {get; set;}
    
    static {
        String RecordTypeDeveloperName = 'Terminate_A_Relationship';
        recordTypeId = Schema.SObjectType.SCIF_Request__c.getRecordTypeInfosByDeveloperName().get(RecordTypeDeveloperName).getRecordTypeId();
    }
    
    static testMethod void firstData(){
        SCIF_Request__c request = new SCIF_Request__c();
        request.RecordTypeId = recordTypeId;
        request.Name = '';
        request.Status__c = 'PBRO Review';
        insert request;
        
        GuidanceTextController.getScifRecord(request.Id);
    } 

}