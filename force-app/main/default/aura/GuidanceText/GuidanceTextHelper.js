({
   

	/*shiftDiv: function(component, event,lWidth) {
       var changeposition = component.get("v.intervalId");
      //var floatElement = component.find('tofloat');

     var floatElement = document.getElementById('tofloat');
        
        console.log(changeposition + ' - '+lWidth);
        if(changeposition < lWidth){
           floatElement.style.right = changeposition+'px';
          //  var cmpTarget = cmp.find('changeIt');
           // $A.util.addClass(cmpTarget, 'Change');
            
            changeposition = changeposition + 4;
            component.set("v.intervalId",changeposition);
        }
        //reset the left to 0
        else{
            component.set("v.intervalId",0);
            floatElement.style.right = "0px";
            changeposition = component.get("v.intervalId");//resetting so as to hit the if block again
        }
    },*/
   
    getRecordDetails: function(component, event,helper){
    	 var action = component.get("c.getScifRecord");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var scifObj = response.getReturnValue();
                component.set("v.guidanceText", scifObj);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
	}
})