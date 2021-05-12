({
	doSearch : function(component, event, helper) {
		var action= component.get("c.getAcc");
        action.setParams({ accname : Component.get("v.accName")});
        action.setCallback(this, function(response) {
          
            if (response.getState() === "SUCCESS") {
             component.set('v.accrec', a.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
 
        $A.enqueueAction(action);
	}
})