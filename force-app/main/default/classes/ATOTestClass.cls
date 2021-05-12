@isTest
private class ATOTestClass {
    @testsetup
    private static void testset(){
        ATO_Interface_Result__c a = new ATO_Interface_Result__c();
        insert a;
        Test.setCreatedDate(a.Id, DateTime.now().addMonths(-14));
        ATO_Interface_Result__c ab = [Select createddate from ATO_Interface_Result__c limit 1];
        system.debug('created date'+ab.CreatedDate);
    }
    
    @isTest
    static void testbatch1(){
        List<ATO_Interface_Result__c> Li = [Select id, createddate from ATO_Interface_Result__c];
        system.debug('post count '+li.size());
        Test.startTest();
        ATODeleteBatch b = new ATODeleteBatch('ATO_Interface_Result__c');
        database.executeBatch(b);
        Test.stopTest();
        List<ATO_Interface_Result__c> af = [Select id, createddate from ATO_Interface_Result__c ];
        system.debug('post count '+af.size());
        
    }
    
    @isTest
    static void testbatch2(){
        List<ATO_Error_Log__c> Li = [Select id, createddate from ATO_Error_Log__c];
        system.debug('post count '+li.size());
        Test.startTest();
        ATODeleteBatch b = new ATODeleteBatch('ATO_Error_Log__c');
        database.executeBatch(b);
        Test.stopTest();
        List<ATO_Error_Log__c> af = [Select id, createddate from ATO_Error_Log__c ];
        system.debug('post count '+af.size());
        
    }
    @isTest
    static void testInterfaceScheduler(){
        List<ATO_Interface_Result__c> Li = [Select id, createddate from ATO_Interface_Result__c];
        Test.startTest();
        ATOInterfaceScheduler.scheduleMe();
        Test.stopTest();
        Integer executedJobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'BatchApex'];
        system.assertEquals(1, executedJobs, 'The job should be scheduled');
    }
    
     @isTest
    static void testErrorScheduler(){
        List<ATO_Error_Log__c> Li = [Select id, createddate from ATO_Error_Log__c];
        Test.startTest();
        ATOErrorLogScheduler.scheduleMe();
        Test.stopTest();
        Integer executedJobs = [SELECT count() FROM AsyncApexJob WHERE JobType = 'BatchApex'];
        system.assertEquals(1, executedJobs, 'The job should be scheduled');
    }
}