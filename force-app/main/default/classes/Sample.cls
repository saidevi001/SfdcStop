public class Sample {

    static String recId ='0033h000009ckLfAAI';
    static string recPrefix = recId.substring(0, 3);
    
    public static void action(){
        system.debug(''+recPrefix);
        Account a = new Account();
        boolean ab = a.getsobjecttype().getDescribe().fields.getmap().keyset().contains('accountnumber');
        system.debug(ab);
        
        System.debug('prefix'+Account.sobjecttype.getDescribe().getkeyprefix());
      //  List<Schema.childrelationship> sb =s.getChildRelationships();
       // system.debug(''+sb.size());
        Schema.DescribeFieldResult dfr = Schema.sObjectType.Account.fields.Name;
		Schema.DescribeFieldResult afr = Schema.sObjectType.Account.fields.getMap().get('Name').getdescribe();
        system.debug(dfr==afr);
    
    }
    public static void createRec(){
        Savepoint sp = Database.setSavepoint();
        Account a = new Account ();
        a.name ='Fail Acc';
        try{
        insert a;
        
        Opportunity opp=new opportunity();
        opp.closedate=system.today();
        //opp.StageName='Prospecting';
        opp.name='Opp Acc';
        opp.AccountId=a.Id;
        
            insert opp;
        }
        catch(Exception e){
            Database.rollback(sp);
            Exception_Log__c ex = new Exception_Log__c();
            ex.Error_Message__c	 = e.getStackTraceString();
            insert ex; 
        }
        
        
    }
}