public class ATOInterfaceScheduler implements Schedulable{
    
    public static String sched = '0 0 22 * * ? *';  //Every Day at Midnight 

    public static String scheduleMe() {
        ATOInterfaceScheduler SC = new ATOInterfaceScheduler(); 
        return System.schedule('ATOInterfaceResult delete batch', sched, SC);
    }

    public void execute(SchedulableContext sc) {
        ATODeleteBatch b1 = new ATODeleteBatch('ATO_Interface_Result__c');
        ID batchprocessid = Database.executeBatch(b1,50);           
    }
	
}