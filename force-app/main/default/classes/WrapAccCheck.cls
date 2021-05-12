public class WrapAccCheck {
    
    map<Integer, List<String>> mp = new map<Integer,List<String>>();
    Map<String, List<String>> stMp;
    public WrapAccCheck(){
        stmp = new Map<String, List<String>>();
        mp.put(1, new List<String>{'a'});
    }
    public void print(){
        List<Account> acList = new List<Account>();
        Account ac = new Account(name='devi acc');
        acList.add(ac);
        
        List<Account> acList1 = new List<Account>{
            new Account(name='devi')
                };    
                    }
    
    public  void addToMap(){
        stmp.put('name', new List<String>{'Sai','Devi','uppalapati'});
        
        if(stmp.containsKey('name')){
            stmp.put('age', new List<String>{'20','30'});
        }
        for(String s:stmp.keySet()){
            system.debug('stmp key '+s);
            system.debug('stmp value '+stmp.get(s));
        }
        
    }
    
    
}