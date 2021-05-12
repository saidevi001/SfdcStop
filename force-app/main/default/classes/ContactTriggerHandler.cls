public class ContactTriggerHandler implements ITriggerHandler{
    
    public static boolean disableTrigger = false;
    
    public boolean isDisabled(){
        TriggerSettings__c t = TriggerSettings__c.getInstance('Account');
        if(t.TriggerDisabled__c==true){
            return true;
        }else 
            return disableTrigger;
    }
    
    public void beforeInsert(List<Sobject> newItems){
        system.debug('in before insert');
        for(contact c :(List<contact>)newItems){
            c.lastname+='LN';
        }
    }
    
    public void beforeUpdate(Map<Id,Sobject> newItems, Map<Id,Sobject> oldItems){
        for(contact c :(List<contact>)newItems.values()){
            c.phone='2222222222';
        }
        system.debug('before update');
    }
    
    public void beforeDelete(Map<Id,Sobject> oldItems){
        for(contact c : (List<Contact>)oldItems.values()){
            c.addError('Trigger prevents contact delete');
        }
        system.debug('before delete');
    }
    
    public void afterInsert(Map<Id,Sobject> newItems){
        
    }
    
    public void afterUpdate(Map<Id,Sobject> newItems, Map<Id,Sobject> oldItems){}
    
    public void afterDelete(Map<Id,Sobject> oldItems){}
    
    public void afterUndelete(Map<Id,Sobject> oldItems){}
    
    
}