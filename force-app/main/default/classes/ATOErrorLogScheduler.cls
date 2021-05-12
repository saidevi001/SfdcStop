public class ATOErrorLogScheduler implements Schedulable{
    
    public static String sched = '0 0 22 * * ? *';  //Every Day at Midnight 

    public static String scheduleMe() {
        ATOErrorLogScheduler SC = new ATOErrorLogScheduler(); 
        return System.schedule('ATOErrorLog Delete batch', sched, SC);
    }

    public void execute(SchedulableContext sc) {
        ATODeleteBatch b1 = new ATODeleteBatch('ATO_Error_Log__c');
        ID batchprocessid = Database.executeBatch(b1,50);           
    }
	
}