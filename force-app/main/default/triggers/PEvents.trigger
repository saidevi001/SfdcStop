trigger PEvents on Test_Event__e (after insert) {
    List<Exception_Log__c > updates = new List<Exception_Log__c>();
    for(Test_Event__e e :Trigger.new){
        system.debug('in event trigger');
        Exception_Log__c ex = new Exception_Log__c  ();
        ex.Error_Message__c = 'From Platform Event'+e.Firstname__c+' '+e.LastName__c;
        updates .add(ex);
    }
    insert updates;
}