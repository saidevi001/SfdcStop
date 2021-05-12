public class u {
    
    /**********************************************************************************
* Copyright (C) 2020
* United Services Automobile Association 
* All Rights Reserved 
* Name      :   ESC_Utils.Cls
* Purpose   :   This is a utility class used across ESC apex classes
***********************************************************************************
*  Ver     Date         Name            Description
*  ---     -------      ----------      ---------------------
*  1.0     02/24/2020   HCL Dev Team    Initial Creation.
*  2.0     6/4/2020     Thausief        Added methods to generate singleEmailMessage instance and to retrive email template id
*  3.0     08/20/2020   HCL Dev Team    Added methods to create exception logs from Apex,Batch & webservice callouts
*  4.0     11/10/2020   Sergio Ponce    Added methods to send email based on log level per PTA-5241
***********************************************************************************/
/*Code coverage is in multiple Test classes : ESC_Update_LERelationship_Batch_Test, ESC_Exception_Log_Trigger_Test, ESC_SharedDataModel_Batch_Test,	
	ESC_SharedDataModel_Delete_Test, ESC_ESCToGEMSCallouts_Test, ESC_Notification_to_PBRO_CBROTest, ESC_NotifyCBROTest,ESC_Level3_ServiceCat_TriggerHandlerTest
*/
/*public class ESC_Utils {
    
    /******************************************************************************************************************************
@ Method Name :  checkRestrictedCharacter
@ Parameter   :  String , List<sObject>
@ Description :  This method will check all text fields related given object and restrict pipe(|) character
******************************************************************************************************************************/
   /* public static void checkRestrictedCharacter(string objectName, List<sObject> sobjList)
    {
        List<String> fieldNameList = new List<String>();
        string[] charList=Label.ESC_RestrictedCharacters.toLowerCase().split(',');
        SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        for(String  fieldName : fieldMap.keySet()){    
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();           
            if(fielddataType.name().toUpperCase() == 'ADDRESS' || fielddataType.name().toUpperCase() == 'STRING' || fielddataType.name().toUpperCase() == 'TEXTAREA'){                
                fieldNameList.add(fieldName);
            }
        }
        if(fieldNameList.size()>0)
        {           
            if(!sobjList.isEmpty())
            {
                for(sObject obj:sobjList){
                    //boolean status =false;
                    for(String fieldName: fieldNameList){
                        system.debug('sdfs__'+obj.get(fieldName));
                        if(obj.get(fieldName)!=null)
                        {
                            if(obj.get(fieldName).tostring().toLowerCase().contains('|'))
                            {   
                                // status = true;
                                obj.addError(ESC_Constants.PIPE_ERROR_MSG);
                                break;
                            }                                
                        }
                        system.debug('fieldName_'+fieldName);                       
                    }                                       
                }
            }
        }
    }   
    
    /******************************************************************************************************************************
@ Method Name :  getSingleEmailMessageInstance
@ Parameter   :  Id, Id, Id, List<String>, Id
@ Description :  This method will generate a singleEmailMessage instance.
******************************************************************************************************************************/
   /* public static Messaging.SingleEmailMessage getSingleEmailMessageInstance(Id emailTemplateId, Id targetObjectId, Id whatId, List<String> toAddresses)
    {
        Messaging.SingleEmailMessage email =  new Messaging.SingleEmailMessage();
        email.setTemplateId(emailTemplateId);
        email.setTargetObjectId(targetObjectId);
        email.setTreatTargetObjectAsRecipient(false);
        email.setwhatid(whatId);
        email.setToAddresses(toAddresses);
        email.setOrgWideEmailAddressId(ESC_Constants.ESC_ORG_WIDE_EMAIL_ID);
        email.setSaveAsActivity(false);
        return email;
    }
    
    /******************************************************************************************************************************
@ Method Name :  getEmailTemplateId
@ Parameter   :  String
@ Description :  This method will retrive email template's id for the provided name.
******************************************************************************************************************************/
  /*  public Static Id getEmailTemplateId(String name)
    {
        return [SELECT Id FROM EmailTemplate WHERE Name =: name LIMIT 1].Id;
    }
    /******************************************************************************************************************************
@ Method Name :  createApexExceptionLog
@ Parameter   :  string ,string ,string ,string ,string  
@ Description :  This method will create exception log from apex class failures
******************************************************************************************************************************/
   /* public static void createApexExceptionLog(string className,string methodName,string logLevel,string stackTraceString,string errorMsg,string recordId)
    {
        ESC_Exception_Log__c objLog = new ESC_Exception_Log__c();
        objLog.Name = className;
        objLog.ESC_MethodName__c = methodName;
        objLog.ESC_Log_Level__c = logLevel;
        objLog.ESC_ErrorLineNo__c = stackTraceString;
        objLog.ESC_ErrorMessage__c = errorMsg;
        objLog.ESC_RecordId__c = recordId;
        objLog.RecordTypeId = Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(ESC_Constants.LOG_RECORDTYPE_APEXCLASS).getRecordTypeId();
        try
        {
            insert objLog;
        }
        catch(exception ex)
        {
            
        }
    }
    /******************************************************************************************************************************
@ Method Name :  createBatchExceptionLog
@ Parameter   :  string ,string ,string ,string ,string ,string 
@ Description :  This method will create exception log from Batch failures
******************************************************************************************************************************/
   /* public static void createBatchExceptionLog(string className,string methodName,string logLevel,string stackTraceString,string errorMsg,string recordId,string asyncJobId)
    {
        ESC_Exception_Log__c objLog = new ESC_Exception_Log__c();
        objLog.Name = className;
        objLog.ESC_MethodName__c = methodName;
        objLog.ESC_Log_Level__c = logLevel;
        objLog.ESC_ErrorLineNo__c = stackTraceString;
        objLog.ESC_ErrorMessage__c = errorMsg;
        objLog.ESC_RecordId__c = recordId;
        objLog.ESC_AsyncApexJobId__c = asyncJobId;
        objLog.RecordTypeId = Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(ESC_Constants.LOG_RECORDTYPE_BATCH).getRecordTypeId();
        try
        {
            insert objLog;
        }
        catch(exception ex)
        {   
        }
    }
    /******************************************************************************************************************************
@ Method Name :  createWebserviceExceptionLog
@ Parameter   :  string ,string,string ,string ,string ,string ,string,string,string,string
@ Description :  This method will create a exception log from webservice callout
******************************************************************************************************************************/
   /* public static ESC_Exception_Log__c createWebserviceExceptionLog(string className,string methodName,string logLevel,string stackTraceString,string errorMsg,string requestBody,string responseBody,string responseStatus,string messageType,string errorType,string endPoint,string methodType)
    {
        ESC_Exception_Log__c objLog = new ESC_Exception_Log__c();
        objLog.Name = className;
        objLog.ESC_MethodName__c = methodName;
        objLog.ESC_Log_Level__c = logLevel;
        objLog.ESC_ErrorLineNo__c = stackTraceString;
        objLog.ESC_ErrorMessage__c = errorMsg;
        objLog.ESC_RequestBody__c = requestBody;
        objLog.ESC_ResponseBody__c = responseBody;
        objLog.ESC_ResponseStatus__c = responseStatus;
        objLog.ESC_MessageType__c = messageType;
        objLog.ESC_Error_Type__c = errorType;
        objLog.ESC_Endpoint__c = endPoint;
        objLog.ESC_MethodType__c = methodType;
        objLog.RecordTypeId = Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(ESC_Constants.LOG_RECORDTYPE_WEBSERVICE).getRecordTypeId();
        return objLog;
    }
    
    /******************************************************************************************************************************
@ Method Name :  createBatchExceptionLogInstance
@ Parameter   :  string ,string ,string ,string ,string ,string 
@ Description :  This method will create exception log from Batch failures
******************************************************************************************************************************/
   /* public static ESC_Exception_Log__c createBatchExceptionLogInstance(string className,string methodName,string logLevel,string stackTraceString,string errorMsg,string recordId,string asyncJobId)
    {
        ESC_Exception_Log__c objLog = new ESC_Exception_Log__c();
        objLog.Name = className;
        objLog.ESC_MethodName__c = methodName;
        objLog.ESC_Log_Level__c = logLevel;
        objLog.ESC_ErrorLineNo__c = stackTraceString;
        objLog.ESC_ErrorMessage__c = errorMsg;
        objLog.ESC_RecordId__c = recordId;
        objLog.ESC_AsyncApexJobId__c = asyncJobId;
        objLog.RecordTypeId = Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(ESC_Constants.LOG_RECORDTYPE_BATCH).getRecordTypeId();
        return objLog;
    }
    
    /******************************************************************************************************************************
@ Method Name :  getSingleEmailMessageWithoutTemplateInstance
@ Parameter   :  String, String, List<String>
@ Description :  This method will generate a singleEmailMessage without template instance.
******************************************************************************************************************************/
   /* public static Messaging.SingleEmailMessage getSingleEmailMessageWithoutTemplateInstance(String subject, String htmlbody, List<String> toAddresses)
    {
        Messaging.SingleEmailMessage email =  new Messaging.SingleEmailMessage();
        email.setSubject(subject);
        email.setToAddresses(toAddresses);
        email.setHtmlBody(htmlbody);
        email.setOrgWideEmailAddressId(ESC_Constants.ESC_ORG_WIDE_EMAIL_ID);
        email.setSaveAsActivity(false);
        return email;
    }
    
    
    /******************************************************************************************************************************
@ Method Name :  getSingleEmailMessageForLogInstance
@ Parameter   :  Map, Map, Map
@ Description :  This method will generate and send an email with critical log records
******************************************************************************************************************************/
   /* public static void getSingleEmailMessageForLogInstance(Map<ESC_Exception_Log__c,String> errorBatchMap,Map<ESC_Exception_Log__c,String> errorWebMap,Map<ESC_Exception_Log__c,String> errorApexMap)
    {
        List<String> toAddress = new List<String>();
        toAddress.add(System.Label.ESC_PTA_Distro_Email);
        
        String baseURL =System.Label.ESC_BaseURL+'/';
        String messageBody = ESC_Constants.BATCH_EMAIL_BODY_MESSAGE_START;
        
        if(!errorBatchMap.isEmpty()){
            messageBody +=ESC_Constants.BATCH_EMAIL_BODY_FAILED_RECORDS_TABLE_START;
            //build batch table
            for(ESC_Exception_Log__c errorRecord : errorBatchMap.keySet()){
                messageBody +='<tr><td> <a href="'+baseURL+errorRecord.get('id')+'">'+errorRecord.Name+'</a></td><td>'+errorBatchMap.get(errorRecord)+'</td><td>'+errorRecord.ESC_AsyncApexJobId__c+'</td></tr><br>';
            }
            messageBody +=ESC_Constants.BATCH_EMAIL_BODY_CLOSE_TABLE;
        }
        if(!errorWebMap.isEmpty()){
            messageBody +=ESC_Constants.GENERAL_EMAIL_BODY_FAILED_RECORDS_TABLE_START;
            //build web table
            for(ESC_Exception_Log__c errorRecord : errorWebMap.keySet() ){
                messageBody +='<tr><td> <a href="'+baseURL+errorRecord.get('id')+'">'+errorRecord.Name+'</a></td><td>'+errorWebMap.get(errorRecord)+'</td></tr><br>';        
            }
            messageBody +=ESC_Constants.BATCH_EMAIL_BODY_CLOSE_TABLE;
        }
        if(!errorApexMap.isEmpty()){
            messageBody +=ESC_Constants.GENERAL_EMAIL_BODY_FAILED_RECORDS_TABLE_START;
            //build apex table
            for(ESC_Exception_Log__c errorRecord : errorApexMap.keySet() ){
                messageBody +='<tr><td> <a href="'+baseURL+errorRecord.get('id')+'">'+errorRecord.Name+'</a></td><td>'+errorApexMap.get(errorRecord)+'</td></tr><br>';        
            }
            messageBody +=ESC_Constants.BATCH_EMAIL_BODY_CLOSE_TABLE;
        }    
        messageBody +=ESC_Constants.BATCH_EMAIL_BODY_MESSAGE_END;
        Messaging.SingleEmailMessage mail = getSingleEmailMessageWithoutTemplateInstance('ESC Logs: CRITICAL ERROR',messageBody,toAddress);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
    /******************************************************************************************************************************
@ Method Name :  checkLogLevel
@ Parameter   :  Map
@ Description :  This method will check if the log level is critical
******************************************************************************************************************************/
   /* public static void checkLogLevel(Map<id, ESC_Exception_Log__c> errorMap){
        
        Map<ESC_Exception_Log__c, String> criticalBatchRecordsMap = new Map<ESC_Exception_Log__c, String>();
        Map<ESC_Exception_Log__c, String> criticalWebserviceRecordsMap = new Map<ESC_Exception_Log__c, String>();
        Map<ESC_Exception_Log__c, String> criticalApexRecordsMap = new Map<ESC_Exception_Log__c, String>();
        
        for(ESC_Exception_Log__c objExceptionLog : errorMap.values()){
            //check for critical logs and sort by record type
            if(objExceptionLog.ESC_Log_Level__c == ESC_Constants.LOG_LEVEL_CRITICAL){           
                if(objExceptionLog.RecordTypeId == Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(ESC_Constants.LOG_RECORDTYPE_BATCH).getRecordTypeId()){
                    criticalBatchRecordsMap.put(objExceptionLog, objExceptionLog.ESC_ErrorMessage__c);
                }
                if(objExceptionLog.RecordTypeId == Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(ESC_Constants.LOG_RECORDTYPE_WEBSERVICE).getRecordTypeId()){
                    criticalWebserviceRecordsMap.put(objExceptionLog, objExceptionLog.ESC_ErrorMessage__c);	
                }
                if(objExceptionLog.RecordTypeId == Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(ESC_Constants.LOG_RECORDTYPE_APEXCLASS).getRecordTypeId()){
                    criticalApexRecordsMap.put(objExceptionLog, objExceptionLog.ESC_ErrorMessage__c);
                }
            }    
        }
        //send email if at least 1 map has a value
        if(!criticalBatchRecordsMap.isEmpty() | !criticalWebserviceRecordsMap.isEmpty() | !criticalApexRecordsMap.isEmpty()){
            ESC_Utils.getSingleEmailMessageForLogInstance(criticalBatchRecordsMap, criticalWebserviceRecordsMap, criticalApexRecordsMap);
        }
    }  
    
    /******************************************************************************************************************************
@ Method Name :  createInfoLogInstance
@ Parameter   :  jobId, log Recordtype, recordcount
@ Description :  This method is used to capture current batch details 
******************************************************************************************************************************/
   /* public static ESC_Exception_Log__c createInfoLogInstance(Id jobId, String recordTypeName, Integer totalRecords, String logLevel, String MethodName,Integer successCount, Integer failCount){ 
        
        AsyncApexJob objAsyncJob = [SELECT Id,ApexClass.Name, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, ExtendedStatus, CompletedDate, CreatedDate FROM AsyncApexJob WHERE Id =:jobId];       
        String execSummary = 'Batch job \''+objAsyncJob.ApexClass.Name+'\''+' with Id '+ objAsyncJob.Id + ' is completed. \n' + 'Job Status : '+objAsyncJob.Status
            +'\n' +'Total Records in Scope : '+totalRecords+'\n'
            +'Total Batches : '+objAsyncJob.TotalJobItems+'\n'
            +'Success records : '+successCount+'\n';
        if(failCount>0){ 
          execSummary+= 'failed records : '+failCount+'\n';
        }
        execSummary+= 'Start time: ' + objAsyncJob.CreatedDate.format('MM/dd/yyyy HH:mm') + '\n'
            + 'End time: ' + objAsyncJob.CompletedDate.format('MM/dd/yyyy HH:mm') + '\n';
          
        
        ESC_Exception_Log__c objLog = new ESC_Exception_Log__c();
        objLog.Name = objAsyncJob.ApexClass.Name;
        objLog.ESC_MethodName__c = MethodName;
        objLog.ESC_Batch_Run_Date__c = objAsyncJob.CreatedDate;
        objLog.ESC_Log_Level__c =logLevel;
        objLog.ESC_AsyncApexJobId__c = jobId;
        objLog.ESC_Execution_Summary__c =execSummary;
        objLog.RecordTypeId = Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return objLog;
    }
    
      /******************************************************************************************************************************
@ Method Name :  createLogRecordFailure
@ Parameter   :  
@ Description :  This method is used to log exceptions when the batch job fails to process atleast one record
******************************************************************************************************************************/
    
   /* public static ESC_Exception_Log__c createLogRecordFailure(Id jobId, List<String> errRec, Integer successCount,Integer failCount, Integer totalRecordsInScope, String logLevel, String MethodName,String recordTypeName){ 
        AsyncApexJob objAsyncJob = [SELECT Id,ApexClass.Name, Status, CreatedDate FROM AsyncApexJob WHERE Id =:jobId];       
        String execSummary = 'Batch job \''+objAsyncJob.ApexClass.Name+'\''+' with Id '+ objAsyncJob.Id + ' is completed. \n' + 'Job Status : '+objAsyncJob.Status+'\n' +'Total Records in scope : '+totalRecordsInScope+'\n';
        execSummary+= 'Start time: ' + objAsyncJob.CreatedDate.format('MM/dd/yyyy HH:mm') + '\n';
        String errorMsg ='';
        if(errRec.size()>0){
        execSummary+= 'Total records failed : '+failCount+'\n\n'+'Exception Details Below : \n';
        for(String s: errRec){
            errorMsg+= s+ '\n' ;
        }
            execSummary+=errorMsg;
        }
        ESC_Exception_Log__c objLog = new ESC_Exception_Log__c();
        objLog.Name = objAsyncJob.ApexClass.Name;
        objLog.ESC_MethodName__c = MethodName;
        objLog.ESC_Log_Level__c =logLevel;
        objLog.ESC_AsyncApexJobId__c = jobId;
        objLog.ESC_ErrorMessage__c =errorMsg; 
        objLog.ESC_Execution_Summary__c =execSummary;
        objLog.RecordTypeId = Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return objLog;
    }
    

      /******************************************************************************************************************************
@ Method Name :  getLastRunDate
@ Parameter   :  
@ Description :  This method is used to get the LastRunDate for the Batch Start() query
******************************************************************************************************************************/    
  /*  public static String getLastRunDate(String className){
        DateTime currentDate = system.today(); 
        String dateFromJob;
        String dateFromLogs;
        String lastRunDate ;
        List<AsyncApexJob> lastBatchRunRec = [SELECT Status, CompletedDate 
                                              FROM AsyncApexJob 
                                              WHERE ApexClass.Name =:className
                                              AND Status='Completed' AND NumberOfErrors = 0
                                              ORDER BY CompletedDate Desc LIMIT 1];
        //lastBatchRunRec = new List<AsyncApexJob>();
        if(lastBatchRunRec != null && lastBatchRunRec.size() > 0 && !lastBatchRunRec.isEmpty()){
            dateFromJob =  lastBatchRunRec[0].CompletedDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        }
        List<ESC_Exception_Log__c> InfoLogRec = [Select Id, createdDate,ESC_Batch_Run_Date__c from ESC_Exception_Log__c
                                                 WHERE Name =:className AND ESC_Log_Level__c='Info'
                                                 ORDER BY createdDate DESC LIMIT 1];
       // InfoLogRec = new List<ESC_Exception_Log__c>();
        
        if(InfoLogRec != null && InfoLogRec.size() > 0 && !InfoLogRec.isEmpty()){
            dateFromLogs = InfoLogRec[0].ESC_Batch_Run_Date__c.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        }
        if(dateFromJob!=null && dateFromLogs != null ){
            //System.debug('>>>Looking for older date');
            if(dateFromJob<dateFromLogs){
                lastRunDate = dateFromJob;
            }else if(dateFromLogs<dateFromJob){
                lastRunDate = dateFromLogs;
            }else if (dateFromLogs==dateFromJob){
                lastRunDate = dateFromJob;
            }
        }else if(dateFromJob ==null && dateFromLogs != null){
            lastRunDate = dateFromLogs;
            //system.debug('>>>Date from logs : '+dateFromLogs);
        }else if(dateFromJob !=null && dateFromLogs == null){
            lastRunDate = dateFromJob;
             // system.debug('>>>Date from Job : '+dateFromJob);
        }else if(String.isBlank(dateFromJob)&& String.isBlank(dateFromLogs)){
           // System.debug('>>>Set to current date since logs are null');
            lastRunDate = currentDate.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        }
       // System.debug('>>>dateToSet : '+lastRunDate+' Date from logs : '+dateFromLogs+'>>>Date from Job'+dateFromJob);
        return lastRunDate;
    }
    /******************************************************************************************************************************
@ Method Name :  createInfoLogWebserviceInstance
@ Parameter   :  jobId, log Recordtype, recordcount
@ Description :  This method is used to capture current batch details 
******************************************************************************************************************************/
  /*  public static ESC_Exception_Log__c createInfoLogWebServiceInstance(String className,  String MethodName, String recordTypeName, Integer totalRecords, String logLevel,Integer successCount, Integer failCount){ 
        DateTime currentDateTime = System.today();
        String execSummary = 'Future webservice callout: \''+className+'\'' + ' is completed. \n'
            +'Callout Start time: ' +  currentDateTime.formatGMT('yyyy-MM-dd\'T\'00:00:00\'Z\'')
            +'\n' +'Total Legal Entities from GEMS : '+totalRecords+'\n'
            +'Success records : '+successCount+'\n';
        if(failCount>0){ 
          execSummary+= 'failed records : '+failCount+'\n';
        }
 
        ESC_Exception_Log__c objLog = new ESC_Exception_Log__c();
        objLog.Name = className;
        objLog.ESC_MethodName__c = MethodName;
        objLog.ESC_Batch_Run_Date__c = currentDateTime;
        objLog.ESC_Log_Level__c =logLevel;
        //objLog.ESC_ErrorMessage__c = execSummary;
        //objLog.ESC_AsyncApexJobId__c = jobId;
        objLog.ESC_Execution_Summary__c =execSummary;
        objLog.RecordTypeId = Schema.SObjectType.ESC_Exception_Log__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return objLog;
    }
    
    
}*/

}