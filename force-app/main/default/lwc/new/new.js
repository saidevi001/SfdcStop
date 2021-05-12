import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Governance_Communication_Status__c from '@salesforce/schema/BOC_Intake__c.Governance_Communication_Status__c';
import Governance_Comment__c from '@salesforce/schema/BOC_Intake__c.Governance_Comment__c';

export default class New extends LightningElement {
   @api recordId;
   @api objectApiName;
   viewform=true;
   disp2=false;
   disp3 =false;
   @track fstatus;
   @track fcomment;

  onEditClick(event){
    this.viewform=false;
    this.disp2=true;
  }

  handleSubmit(event){
      console.log('uuuuuuuuu');
      const fields =event.detail.fields;
      this.fcomment=fields.Governance_Comment__c;
      this.fstatus =fields.Governance_Communication_Status__c;
      console.log('comment'+this.fcomment);
      console.log('status'+this.fstatus);
      this.template.querySelector('lightning-record-edit-form').submit(fields);
      const evt = new ShowToastEvent({
        message: "Record saved successfully.",
        variant: "success"
    });
    this.dispatchEvent(evt);
    this.disp2=false;
    //this.disp3 = true;
    this.viewform = true;
 
  }

  onEditview(event){
      this.disp3 = false;
      this.disp2=true;


  }

  handleReset(event)
     {
      
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        this.disp2=false;
       // this.disp3 = true;
       this.viewform = true;
        
     }

}