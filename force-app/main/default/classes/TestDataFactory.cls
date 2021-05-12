public class TestDataFactory {
    
    public static List<Account> createAccounts(Integer count, Boolean doInsert){
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<count;i++){
            Account a = new Account();
            a.name = 'Acc'+i;
            accList.add(a);
        }
        if(doInsert){
            insert accList;
        }
      return accList;
    }

}