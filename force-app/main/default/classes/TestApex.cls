public class TestApex {
    
    public map<Integer, string> mp{get;set;}
    map<String,Account> acmp;
    list<Account> aclst;
    
    public TestApex(){
        aclst = [Select id, name from account];
        acmp = new Map<String,Account>();
        for(Account a :aclst){
            acmp.put(a.name, a);
        }
        
        mp= new map<Integer, String>{1=>'Devi',2=>'sai'};
    }
    public void print(){
       Account a = new Account();
        if(acmp.containsKey('United Oil & Gas Corp.')){
            a= acmp.get('United Oil & Gas Corp.');
        }
        system.debug(a);
    }

}