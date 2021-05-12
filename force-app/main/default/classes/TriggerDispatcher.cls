public class TriggerDispatcher {
    
    public static void run(ITriggerHandler handlr){
        if(handlr.isDisabled()){
            system.debug('TRIGGER SHUTDOWN'+trigger.operationtype);
            return;
        }
        switch on trigger.operationType
        {
            when BEFORE_INSERT{
                handlr.beforeInsert(Trigger.new);
            }
             when BEFORE_UPDATE{
                handlr.beforeUpdate(Trigger.newmap, Trigger.oldMap);
            }
             when BEFORE_DELETE{
                handlr.beforeDelete(trigger.oldMap);
            }
             when AFTER_INSERT{
                handlr.afterInsert(trigger.newmap);
            }
             when AFTER_UPDATE{
                handlr.afterUpdate(trigger.newMap, trigger.oldmap);
            } when AFTER_DELETE{
                handlr.afterdelete(trigger.oldmap);
            }
             when AFTER_UNDELETE{
                 handlr.afterUndelete(trigger.oldmap);
            }
        }
    }
}