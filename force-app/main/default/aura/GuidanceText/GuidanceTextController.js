({
    doInit : function(component, event, helper) {
        //on change of status, to reduce the float to -20
       // var startPoint =-10;
       // var lWidth = window.innerWidth ;//Get the window's width
        //The setInterval() method calls a function or 
        //evaluates an expression at specified intervals (in milliseconds).
        helper.getRecordDetails(component, event, helper);
        //component.set("v.intervalId",startPoint);
        
     /* window.setInterval($A.getCallback(function() { 
            helper.shiftDiv(component, event,lWidth);
        } ), 400);*/
    }
})