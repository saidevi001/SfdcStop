
import { LightningElement, api, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Governance_Communication_Status__c from '@salesforce/schema/BOC_Intake__c.Governance_Communication_Status__c';
import Governance_Comment__c from '@salesforce/schema/BOC_Intake__c.Governance_Comment__c';
//import { updateRecord } from 'lightning/uiRecordApi';



export default class BOCGovernance extends LightningElement {
   
  @api recordId;
  @api objectApiName;
  @track isChanged = false;
  @track status;
  @track comment;
  @track fstatus;
  @track fcomment;
  @track viewform = true;
  disp3 =false;
  disp2=false;
  viewAgain=false;
  fields = [Governance_Communication_Status__c,Governance_Comment__c];

  
  onEditview(){
    this.disp2 = true;
    this.viewform=false;
   }

 /* statushandleChange(event){
    this.status= event.target.value;
    //this.isChanged = true;
  }
  commenthandleChange(event){
    this.comment= event.target.value;
    //this.isChanged = true;
  }*/

 clickEvent(event){
  const fields = event.detail.fields;
      this.template.querySelector('lightning-record-edit-form').submit(fields);
     
      this.fcomment=fields.Governance_Comment__c;
      this.fstatus =fields.Governance_Communication_Status__c;

         const evt = new ShowToastEvent({
             message: "Record saved successfully.",
             variant: "success"
         });
         this.dispatchEvent(evt);
         
         this.disp2 = false;
         this.disp3 =true;
         console.log('disp3 value'+this.disp3);
         console.log('disp2 value'+this.disp2);
         //this.isChanged = false;
//this.viewform = true;
//updateRecord({ fields: { Id: this.recordId } });

}

handleSubmit(event){
  this.fcomment=fields.Governance_Comment__c;
      this.fstatus =fields.Governance_Communication_Status__c;

         const evt = new ShowToastEvent({
             message: "Record saved successfully.",
             variant: "success"
         });
         this.dispatchEvent(evt);
         
         this.disp2 = false;
         this.disp3 =true;
         console.log('comment'+this.fcomment);
         console.log('status'+this.status);
         console.log('disp3 value'+this.disp3);
         console.log('disp2 value'+this.disp2);
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

        //this.viewform = true;
        this.disp2=false;
     }
}

