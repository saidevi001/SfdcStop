global class ATODeleteBatch implements Database.Batchable<sObject> {
    public String sourceObject;
    
    public ATODeleteBatch(String sourceObject){
        this.sourceObject = sourceObject;
    }
     global Database.QueryLocator start(Database.BatchableContext BC){
         String query = getStringQuery(this.sourceObject);
        return Database.getQueryLocator(query);
    }
     global void execute(Database.BatchableContext BC, List<sObject> scope){
         for(sobject a: scope){
             system.debug('scope '+a);
         }
         delete scope;  
         
         Database.emptyRecycleBin(scope); 
     }
     global void finish(Database.BatchableContext BC){
        
    }
    public static String getStringQuery(String objectName){
        String query = 'SELECT ID';
        query += ' FROM';
        query += ' '+objectName;
        query += ' WHERE CreatedDate<LAST_N_DAYS:360';
        //query += ' WHERE CreatedDate=Today';
        return query;
    }

}