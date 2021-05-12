public class GuidanceTextController {
    
    public static Map<String,String> recTypeStatusWiseMessage {get; private set;}
    
    static{
        recTypeStatusWiseMessage = new Map<String,String>();
        //loading all values from custom metadata
        List<GuidanceText__mdt> textList = [Select id,
                                            GuidanceText__c, 
                                            RecordTypeName__c,
                                            Status__c 
                                            from GuidanceText__mdt];
        for(GuidanceText__mdt gtext:textList){
            //key = recordTypeName+'_'+status
            //value = Guidance Text
            String key = gtext.RecordTypeName__c + '_'+gtext.Status__c.replace(' ','_');
            String val = gtext.GuidanceText__c;
            recTypeStatusWiseMessage.put(key,val);
        }
    }
    
    @AuraEnabled public static String getScifRecord(String recordId){
        String recordTypeName;
        String status;
        String key;
        List<SCIF_Request__c> SCIFList = [SELECT Id, RecordType.DeveloperName , Status__c FROM SCIF_Request__c where Id=:recordId];
        recordTypeName = SCIFList[0].RecordType.DeveloperName ;
        status = SCIFList[0].Status__c.replace(' ','_'); 
        key = recordTypeName+'_'+status ;
        return recTypeStatusWiseMessage.containsKey(key)?recTypeStatusWiseMessage.get(key):'';
        
        
    }
    @AuraEnabled
    public static Account getAcc(String s){
        Account acc =[Select id , name from account where name =:s limit 1];
        return acc;
    }
}