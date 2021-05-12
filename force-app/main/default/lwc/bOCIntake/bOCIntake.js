import { LightningElement, api, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Governance_Communication_Status__c from '@salesforce/schema/BOC_Intake__c.Governance_Communication_Status__c';
import Governance_Comment__c from '@salesforce/schema/BOC_Intake__c.Governance_Comment__c';

export default class BOCGovernance extends LightningElement {
  @api recordId;
  @api objectApiName;
  viewform = true;
  error;
  stack;   
  fields = [Governance_Communication_Status__c,Governance_Comment__c];

  onEditview(){
    console.log('before'+this.viewform);
    this.viewform = false;
    console.log('after'+this.viewform);
   }

   errorCallback(error, stack) {
     console.log('error'+this.error);
     console.log('stack'+this.stack);
    this.error = error;
}

handleSubmit(event){
  event.preventDefault();
  console.log('submitted');
  const fields = event.detail.fields;
  if(fields.Governance_Communication_Status__c!==""){
    this.template.querySelector('lightning-record-form').submit(fields);
    const evt = new ShowToastEvent({
      message: "Record saved successfully",
      variant: "success"
  });
  this.dispatchEvent(evt);
  }else{
    const evt = new ShowToastEvent({
      title:"Required field missing",
      message: "Governance communication status cannot be blank.",
      variant: "error",
      mode:"pester"
  });
  this.dispatchEvent(evt);
  } 
}
}

