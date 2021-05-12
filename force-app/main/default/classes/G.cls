public class G {
/***********************************************************************
* Copyright (C) 2020
* United Services Automobile Association 
* All Rights Reserved
* Name    : ESC_ESCToGEMSCallouts
* Purpose : This is a main class to perform callouts to GEMS system
************************************************************************
*  Ver     Date         Name              Description
*  ---     -------      ----------        ---------------------
*  1       7/31/2020     Thausief         Implemented callout to GEMS to fetch legal entities 
************************************************************************/
/*public class ESC_ESCToGEMSCallouts 
{      
    static Id usaaLegalEntityRecordTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get(ESC_Constants.RECORD_TYPE_USAA_LEGAL_ENTITY).getRecordTypeId();
    static ESC_CalloutUtils.IntegrationSettings integrationSettings = ESC_CalloutUtils.getIntegrationSettings('GEMS_Search');
    static List<ESC_Exception_Log__c> lstLogs = new List<ESC_Exception_Log__c>();
    Set<String> fieldIds = new Set<String>();
    static Integer totRecProcessed = 0;
    static Integer successRec = 0;
    static Integer failRecs = 0;
    
    public ESC_ESCToGEMSCallouts()
    {
        retrieveDataFromGEMS();
    }
    
    @Future(callout=true)
    private static void retrieveDataFromGEMS()
    {
        if(integrationSettings != null)
        {
            String accessToken = retreiveAccessToken();
            if(String.isNotEmpty(accessToken))
            {
                HttpResponse res;
                res = makeGetCallout(accessToken);
                if(res.getStatusCode() == 200)
                {
                    lstLogs.add(ESC_Utils.createWebserviceExceptionLog(ESC_ESCToGEMSCallouts.class.getName(),ESC_Constants.LOG_METHOD_RETRIEVEDATAFROMGEMS,ESC_Constants.LOG_LEVEL_INFO,ESC_Constants.EMPTY_STRING,
                                                                   ESC_Constants.LOG_MESSAGE_SUCCESFULLY_RECIVED_RESPONSE,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING,
                                                                   ESC_Constants.EMPTY_STRING,ESC_Constants.LOG_ERRORTYPE_INFORMATION,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING));
                                
                    List<Account> lstAccount = new List<Account>();
                    String businessEntityIdFieldId;
                    getAccountData();
                    // Get the response body deserialized
                    Map<String, Object> deserializedResponse = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                    List<Object> lstFieldsInfo = (List<Object>)deserializedResponse.get('fields');
                    Map<String, String> gemsFieldIdToLabelMap = new Map<String, String>();
                    // Loop through the fields information to get the field ids
                    for(Object fieldInfo : lstFieldsInfo)
                    {
                        Map<String, Object> fieldsMap = (Map<String, Object>)fieldInfo;
                        // Create a map of GEMS field id => GEMS field label
                        gemsFieldIdToLabelMap.put(String.valueOf(fieldsMap.get('id')).toLowerCase(), String.valueOf(fieldsMap.get('label'))); 
                        if(String.valueOf(fieldsMap.get('label')) == 'Business Entity ID')
                        {
                            businessEntityIdFieldId = String.valueOf(fieldsMap.get('id')).toLowerCase();
                        }
                    }
                    //system.debug('gemsFieldIdToLabelMap-->' + gemsFieldIdToLabelMap);
                    List<Object> lstDataInfo = (List<Object>)deserializedResponse.get('result');
                    system.debug('lstDataInfo-->' + lstDataInfo);
                    Set<String> businessEntityIds =new Set<String>();
                    for(Object dataInfo : lstDataInfo)
                    {
                        Account acc;
                        Map<String, String> convertedDataMap = new Map<String, String>();
                        Map<String, Object> dataMap = (Map<String, Object>)dataInfo;
                        convertedDataMap = convertKeysToLowerCase(dataMap);                        
                        // Get business entity id's value from data map
                        String businessEntityId = convertedDataMap.get(businessEntityIdFieldId);
                        businessEntityIds.add(businessEntityId);
                        //system.debug('businessEntityId-->' + businessEntityId);
                        if(accountsMap.containsKey(businessEntityId))
                        {
                            acc = accountsMap.get(businessEntityId);
                            //system.debug('businessEntityId-->' + businessEntityId);
                            //system.debug('acc-->' + acc);
                        }
                        else
                        {
                            acc = new Account();
                            acc.RecordTypeId = usaaLegalEntityRecordTypeId;
                        }
                        Boolean isFieldValueChanged = false;
                        for(String field : convertedDataMap.keySet())
                        {
                            switch on gemsFieldIdToLabelMap.get(field)
                            {
                                when 'Client Code'
                                {
                                    acc.ESC_Client_Id__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'Business Entity ID' 
                                {
                                    acc.ESC_Business_Entity_Id__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'Name'
                                {
                                    acc.Name = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'Entity Type'
                                {
                                    acc.APTS_Legal_Entity_Type__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'Category'
                                {
                                    acc.ESC_Legal_Entity_Category__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'Address Line 1'
                                {
                                    acc.Apttus_SRM__SupplierAddress1__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'City'
                                {
                                    acc.Apttus_SRM__SupplierCity__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'State/Province'
                                {
                                    acc.Apttus_SRM__SupplierStateProvince__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'Zip/Post Code'
                                {
                                    acc.Apttus_SRM__SupplierZipPostalCode__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'Jurisdiction'
                                {
                                    acc.ESC_Jurisdiction__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'Reg W Affiliate'
                                {
                                    acc.ESC_Reg_W_Affiliate_Flag__c = convertedDataMap.get(field)=='Yes'?true:false;
                                    isFieldValueChanged = true;
                                }
                                when 'Formation Date'
                                {
                                    Date formationDate;
                                    if(convertedDataMap.get(field) != null)
                                    {
                                        acc.ESC_Formation_Date__c = Date.valueOf(convertedDataMap.get(field));  
                                        isFieldValueChanged = true;
                                    }
                                }
                                when 'Status'
                                {
                                    acc.ESC_Status__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'EIN'
                                {
                                    acc.ESC_Employer_Identification_Number__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                                when 'LEI Number'
                                {
                                    acc.ESC_LEI__c = convertedDataMap.get(field);
                                    isFieldValueChanged = true;
                                }
                            }
                        }
                        if(isFieldValueChanged)
                        {
                            lstAccount.add(acc);
                        }
                        //break; // added this temporarily, need to be removed
                    }
                    //system.debug('entity_ '+businessEntityList);
                    //system.debug('account_'+accountsMap);
                    //System.debug('check size -->' + lstAccount);
                    //System.debug('checkMap size-->' + accountsMap.keyset().size());
                                        
                    for(String entity : accountsMap.keySet())
                    {
                        if(!businessEntityIds.contains(entity))
                        {
                            Account acct = accountsMap.get(entity);
                            if(acct.ESC_Status__c == ESC_Constants.USAA_LEGAL_ENTITY_STATUS_ACTIVE)
                            {
                                acct.ESC_Status__c= ESC_Constants.USAA_LEGAL_ENTITY_STATUS_INACTIVE;
                                lstAccount.add(acct);
                                //system.debug('check_update1_'+entity);
                                //system.debug('check_update2_'+acct);                    
                            }                            
                        }
                    }
                        if(!lstAccount.isEmpty())
                        {
                            totRecProcessed = lstAccount.size();
                            //System.debug('lstAccount size -->' + lstAccount.size());
                            List<Database.UpsertResult> results = Database.upsert(lstAccount, false);
                            //system.debug('Affected rows -->' + Limits.getDmlRows());
                            String errorMsg;
                            List<String> errRec = new List<String>();
                           for(Integer i=0;i<results.size();i++){
                                if(results.get(i).isSuccess()){
                                    successRec+=1;
                                }
                               else if(!results.get(i).isSuccess()){
                                   failRecs+=1;
                                   // errorMsg += 'Record id:' + lstAccount.get(i).Id + '-->';
                                   Database.Error e = results.get(i).getErrors().get(0);
                                   if(lstAccount.get(i).Id != null){
                                       errorMsg +='ID : '+lstAccount.get(i).Id+' | Error : '+e.getMessage()+' | Field : '+e.getFields()+'\n';
                                       errRec.add('ID : '+lstAccount.get(i).Id+' | Error : '+e.getMessage()+' | Field : '+e.getFields());
                                   }else if (lstAccount.get(i).Id==null){
                                       errorMsg +=' Error : '+e.getMessage()+' | Field : '+e.getFields()+'\n';
                                       errRec.add(' Error : '+e.getMessage()+' | Field : '+e.getFields()); 
                                   }
                               }
                           }
                            system.debug('>>>errRec : '+errRec.toString());
                          
                            if(!String.isEmpty(errorMsg))
                            {
                              lstLogs.add(ESC_Utils.createWebserviceExceptionLog(ESC_ESCToGEMSCallouts.class.getName(),ESC_Constants.LOG_METHOD_RETRIEVEDATAFROMGEMS,ESC_Constants.LOG_LEVEL_CRITICAL,ESC_Constants.EMPTY_STRING,
                                                                   errorMsg,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING,
                                                                   ESC_Constants.EMPTY_STRING,ESC_Constants.LOG_ERRORTYPE_CATCHERROR,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING));
                                
                            }
                            
                        }
                }
                else
                {
                    lstLogs.add(ESC_Utils.createWebserviceExceptionLog(ESC_ESCToGEMSCallouts.class.getName(),ESC_Constants.LOG_METHOD_RETRIEVEDATAFROMGEMS,ESC_Constants.LOG_LEVEL_CRITICAL,ESC_Constants.EMPTY_STRING,
                                                           ESC_Constants.LOG_CALLOUT_FAILED, 'Request parameters sent: Primary Schema-->' + integrationSettings.primarySchema + ' Saved Search Counter-->' + integrationSettings.savedSearchCounter,
                                                           res.toString(),string.valueOf(res.getStatusCode()),ESC_Constants.LOG_METHODTYPE_OUTBOUND,ESC_Constants.LOG_ERRORTYPE_DATAERROR,integrationSettings.endPointURL,ESC_Constants.LOG_CALLOUTTYPE_GET));
                }
            }

        }
        else
        {
            lstLogs.add(ESC_Utils.createWebserviceExceptionLog(ESC_ESCToGEMSCallouts.class.getName(),ESC_Constants.LOG_METHOD_RETRIEVEDATAFROMGEMS,ESC_Constants.LOG_LEVEL_CRITICAL,ESC_Constants.EMPTY_STRING,
                                                   ESC_Constants.LOG_INTEGRATION_SETTINGS_EMPTY,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING,
                                                   ESC_Constants.EMPTY_STRING,ESC_Constants.LOG_METHODTYPE_OUTBOUND,ESC_Constants.LOG_ERRORTYPE_DATAERROR,
                                                   ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING));
        }
        ESC_Exception_Log__c exc = ESC_Utils.createInfoLogWebServiceInstance(ESC_ESCToGEMSCallouts.class.getName(),'retrieveDataFromGEMS',ESC_Constants.LOG_RECORDTYPE_WEBSERVICE,totRecProcessed, ESC_Constants.LOG_LEVEL_INFO, successRec, failRecs);
        lstLogs.add(exc);
        if(!lstLogs.isEmpty()){
            insert lstLogs;
        }
    }
    
    static Map<String, Account> accountsMap = new Map<String, Account>();
    public static void getAccountData()
    {
        for(Account acc : [SELECT Id, Apttus_SRM__SupplierCity__c,APTS_Legal_Entity_Type__c,ESC_Employer_Identification_Number__c,ESC_LEI__c,
                           ESC_Status__c,ESC_Formation_Date__c,Name,Apttus_SRM__SupplierStateProvince__c,Apttus_SRM__SupplierZipPostalCode__c,
                           ESC_Jurisdiction__c,ESC_Legal_Entity_Category__c,ESC_Client_Id__c,Apttus_SRM__SupplierAddress1__c,
                           ESC_Business_Entity_Id__c,ESC_Reg_W_Affiliate_Flag__c 
                           FROM Account WHERE RecordTypeId =: usaaLegalEntityRecordTypeId]) 
        {
           // system.debug('acct'+acc.ESC_Business_Entity_Id__c);
            if(acc.ESC_Business_Entity_Id__c!=null)
                accountsMap.put(acc.ESC_Business_Entity_Id__c, acc);
        }
        //System.debug('accountsMap size-->' + accountsMap.keyset().size());
    }
    
    private static HttpResponse makeGetCallout(String accessToken)
    {
        Http http = new Http();
        HttpResponse res;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(integrationSettings.endPointURL + integrationSettings.primarySchema + '/' +  integrationSettings.savedSearchCounter); // hardcoded values to be changed to labels
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setTimeout(60000);
        res = http.send(req);
        system.debug('ResponseBody = '+res);
        return res;
    }
    
    private static String retreiveAccessToken()
    {
        HttpResponse res;
        String accessToken;
        ESC_CalloutUtils.CredentialsManager credentialsManager = ESC_CalloutUtils.getCredentials('GEMS');
        if(credentialsManager!= null)
        {
            res = makePostCallout(credentialsManager);
            system.debug('ResponseBody access = '+res);
            if(res.getStatusCode() == 200)
            {      
                     
                system.debug('ResponseBody access .getBody() = '+res.getBody());
                JSONParser parser = JSON.createParser(res.getBody());
                while(parser.nextToken() != null)
                {
                    system.debug('ResponseBody access = '+res);
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'access_token')
                    {
                        system.debug('ResponseBody access = '+res);
                        parser.nextToken();
                        accessToken = parser.getText();
                        break;
                    }       
                }
                
            }
            else
            {
                lstLogs.add(ESC_Utils.createWebserviceExceptionLog(ESC_ESCToGEMSCallouts.class.getName(),ESC_Constants.LOG_METHOD_RETRIEVEACCESSTOKEN,ESC_Constants.LOG_LEVEL_CRITICAL,ESC_Constants.EMPTY_STRING,
                                                       ESC_Constants.LOG_ERROR_RETRIEVING_ACCESS_TOKEN,'Request parameters sent: Grant Type-->' + integrationSettings.grantType + ';Scope-->' + integrationSettings.scope,
                                                       res.toString(),string.valueOf(res.getStatusCode()), ESC_Constants.LOG_METHODTYPE_OUTBOUND,ESC_Constants.LOG_ERRORTYPE_DATAERROR,integrationSettings.endPointTokenURL,
                                                       ESC_Constants.LOG_CALLOUTTYPE_POST));
            }
        }
        else
        {
            lstLogs.add(ESC_Utils.createWebserviceExceptionLog(ESC_ESCToGEMSCallouts.class.getName(),ESC_Constants.LOG_METHOD_RETRIEVEACCESSTOKEN,ESC_Constants.LOG_LEVEL_CRITICAL,ESC_Constants.EMPTY_STRING,
                                                   ESC_Constants.LOG_CREDENTIALS_EMPTY,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING,
                                                   ESC_Constants.LOG_METHODTYPE_OUTBOUND,ESC_Constants.LOG_ERRORTYPE_DATAERROR,ESC_Constants.EMPTY_STRING,ESC_Constants.EMPTY_STRING));
        }
        system.debug('token-->' + accessToken);  
        return accessToken;
    }
     
    private static HttpResponse makePostCallout(ESC_CalloutUtils.CredentialsManager credentialsManager)
    {
        Http http =  new Http();
        HttpResponse res;
        HttpRequest req = new HttpRequest(); 
        req.setEndpoint(integrationSettings.endPointTokenURL); 
        req.setMethod('POST');
        req.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(credentialsManager.clientId + ':' + credentialsManager.clientSecret)));
        req.setBody('grant_type=' + integrationSettings.grantType + '&scope=' + integrationSettings.scope);
        res = http.send(req);
        system.debug('ResponseBody post = '+res);
        return res;
    }
    
    private static Map<String, String> convertKeysToLowerCase(Map<String, Object> dataMap)
    {
        Map<String, String> lowerCaseKeysMap = new Map<String, String>();
        for(String key : dataMap.keySet())
        {
            lowerCaseKeysMap.put(key.toLowerCase(), String.valueOf(dataMap.get(Key)));
        }
        return lowerCaseKeysMap;
    }
}*/
   // -----------------

/*@isTest
private class ESC_ESCToGEMSCallouts_Test {
    @isTest static void testCallout() {
        USAAInf_Service_Account__c objservice1 = new USAAInf_Service_Account__c();
        objservice1.Password__c='xxxx';
        objservice1.Username__c='xxxx';
        objservice1.Alias__c='GEMS';    
        insert objservice1;  
         System.assertNotEquals(objservice1.id, null);
        Account act = ESC_TestDataFactory.createAccountInstanceOnly('testacct','Corporation');
        act.ESC_Business_Entity_Id__c  ='1613';
            insert act;
        System.assertNotEquals(act.RecordType.Name , 'USAA Legal Entity'); 
        System.assertNotEquals(act.id, null);
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ESC_ESCToGEMS_MockHTTPResponseGenerator());
        // This causes a fake response to be sent
        ESC_ESCToGEMSCallouts obj = new ESC_ESCToGEMSCallouts();
        ESC_GEMSCalloutScheduler objScheduler = new ESC_GEMSCalloutScheduler();
        String CRON_EXP = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ESC_GEMSCalloutScheduler());
        ESC_Utils objUtils = new ESC_Utils();
        ESC_Utils.createBatchExceptionLog('test','test','','test','','','');
        ESC_Utils.createApexExceptionLog('test','test','','test','','');
    }
}*/
   // ------------------------------
  // ***********************************************************************

/*@isTest
global class ESC_ESCToGEMS_MockHTTPResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6InZUa1N3MlJubGJwNklwTjZLdm9pWnFxWDNiQSIsImtpZCI6InZUa1N3MlJubGJwNklwTjZLdm9pWnFxWDNiQSJ9.eyJpc3MiOiJodHRwczovL2dlbXMuY29tcHV0ZXJzaGFyZS5jb20vZ2Vtc2lkc3ZyIiwiYXVkIjoiaHR0cHM6Ly9nZW1zLmNvbXB1dGVyc2hhcmUuY29tL2dlbXNpZHN2ci9yZXNvdXJjZXMiLCJleHAiOjE1OTgyNzk4ODQsIm5iZiI6MTU5ODI3NjI4NCwiY2xpZW50X2lkIjoiZjMxYTk3OWEtYjQ3ZS00ZmZkLWI1MTUtN2M2MGZjZjdmODYxIiwic2NvcGUiOiJnZW1zd2ViYXBpIn0.nm_lwTnacOpz3svOG62rHQc78aMdNFy4BKicXNiS8yA2xZGRcpEAMCyOgzEBa_8lEN-f7pFyXWuBK7F14bC9cpKtusBGrkfcKrmhADe9dtfJ4jbPihq0K2tYw0AoYtBKMKBL2uNO0CZ0gD02QPBbvYy-K8w1FRvAiNRGLCV-wjo83tcmRlGiLmuzSZSZCqFgcDKTojGmfl32Q2rVwjXzEJefUkxBmdJgHt5FMdbUoZMc4eT2YK_X69oKcmj3wwSaURAh6RTPiPrBfv1jrulJ116vzIr8j7_7XAfEpCjRMx30EmQn9o5MrKsp_eibLnHqoPOigV8bQZMI2utPyFewxQ","expires_in":3600,"token_type":"Bearer","gemsVersion":"9.9.1","fields":[{"id":"primaryentitykeyid","dataType":"Int32","label":"CompanyBasics_0_Entity_EntityCounter","availableAsCriteria":true},{"id":"CompanyBasics_0_1_856739","dataType":"string","label":"Client Code","availableAsCriteria":true},{"id":"CompanyBasics_0_2_1086760","dataType":"digits","label":"Business Entity ID","availableAsCriteria":true},{"id":"CompanyBasics_0_3_856806","dataType":"string","label":"Name","availableAsCriteria":true},{"id":"CompanyBasics_0_4_856792","dataType":"string","label":"Entity Type","availableAsCriteria":true},{"id":"CompanyBasics_0_5_856741","dataType":"string","label":"Category","availableAsCriteria":true},{"id":"Address_6_1524_6_650078","dataType":"string","label":"Address Line 1","availableAsCriteria":true},{"id":"Address_6_1524_7_650072","dataType":"string","label":"City","availableAsCriteria":true},{"id":"Address_6_1524_8_650069","dataType":"string","label":"State/Province","availableAsCriteria":true},{"id":"Address_6_1524_9_650067","dataType":"string","label":"Zip/Post Code","availableAsCriteria":true},{"id":"CompanyBasics_0_10_856804","dataType":"string","label":"Jurisdiction","availableAsCriteria":true},{"id":"CompanyBasics_0_11_100000361","dataType":"string","label":"Reg W Affiliate","availableAsCriteria":true},{"id":"CompanyBasics_0_12_856801","dataType":"date","label":"Formation Date","availableAsCriteria":true},{"id":"CompanyBasics_0_13_856768","dataType":"string","label":"Status","availableAsCriteria":true},{"id":"CompanyBasics_0_14_856787","dataType":"string","label":"EIN","availableAsCriteria":true},{"id":"CompanyBasics_0_15_1086935","dataType":"string","label":"LEI Number","availableAsCriteria":true}],"recordKeyField":"primaryentitykeyid","keyField":"primaryentitykeyid","recordDescriptorField":"CompanyBasics_0_3_856806","result":[{"primaryentitykeyid":2725,"companyBasics_0_1_856739":null,"companyBasics_0_2_1086760":2725,"companyBasics_0_3_856806":"1 RIVERWALK, LLC","companyBasics_0_4_856792":"Limited Liability Company","companyBasics_0_5_856741":"RELP","address_6_1524_6_650078":"1980 Post Oak Blvd., Suite 1600","address_6_1524_7_650072":"Houston","address_6_1524_8_650069":"Texas","address_6_1524_9_650067":"77056","companyBasics_0_10_856804":"Texas","companyBasics_0_11_100000361":"Yes","companyBasics_0_12_856801":"2017-08-07T00:00:00","companyBasics_0_13_856768":"Active","companyBasics_0_14_856787":"82-2405577 ","companyBasics_0_15_1086935":"254900M6OLT701WLK955"}]}');
        res.setStatusCode(200);
        System.assertEquals(200, res.getStatusCode());
        //System.assert(false, 'https://gems.computershare.com/gemsidsvr/connect/token/' + req.getEndpoint());
        return res;
    }
}*/
}