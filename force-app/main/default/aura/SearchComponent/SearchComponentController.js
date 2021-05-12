({
	handleClick : function(component, event, helper) {
        var a = component.get("v.displayName");
        component.set("v.outputName",a);
        
        var action = component.get("c.getOpp");
        
        action.setCallback(this,function(response){
            if(response.getstate()==="SUCCESS"){
                var op = response.getReturnValue().Name;
                component.set("v.outputName",op);
            }
        });
        $A.enqueueAction(action); 
	}
})