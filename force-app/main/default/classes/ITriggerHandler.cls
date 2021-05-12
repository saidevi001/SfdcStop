public Interface ITriggerHandler {
    
	void beforeInsert(List<Sobject> newItems);
    
    void beforeUpdate(Map<Id,Sobject> newItems, Map<Id,Sobject> oldItems);
    
    void beforeDelete(Map<Id,Sobject> oldItems);
    
    void afterInsert(Map<Id,Sobject> newItems);
    
    void afterUpdate(Map<Id,Sobject> newItems, Map<Id,Sobject> oldItems);
    
    void afterDelete(Map<Id,Sobject> oldItems);
    
    void afterUndelete(Map<Id,Sobject> oldItems);
    
    boolean isDisabled();
    
}