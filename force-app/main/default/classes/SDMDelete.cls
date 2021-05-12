public class SDMDelete {
/***********************************************************************
* Copyright (C) 2020
* United Services Automobile Association 
* All Rights Reserved
* Name    : ESC_SharedDataModel_DeleteBatch
* Purpose : The purpose of this Batch class is to populate Enterprise object data(on delete) to Aggregate Objects.
* i.e When source record is deleted - ESC_INF_Source_isDeleted__c on target is set to 'true'

* Below is the Source-Target object mapping
* ESC_Level_3_Service_Category__c  - ESC_Service_Taxonomy__c  
* ESC_LE_Service_Provider__c - ESC_Cost_Buildup__c   
* ESC_LE_Relationship__c, ESC_Tier__c  - ESC_LE_to_LE_Relationship__c  

* Test Class:ESC_SharedDataModel_Delete_Test
***********************************************************************/
/*
global class ESC_SharedDataModel_DeleteBatch implements Database.Batchable<sObject>,Database.Stateful {
    public Integer totRecProcessed = 0;
    public Integer successRec =0;
    public Integer failRecs =0;
    List<String> errRec = new List<String>();
    List<String> successIds = new List<String>();
    public string query {get; set;}
    List<id> recordIds {get; set;}
    public String copyObject {get; set;}
    public String targetObject {get; set;}
    List<ESC_Exception_Log__c> logs {get; set;}
    
    public ESC_SharedDataModel_DeleteBatch(String copyObject){
        this.copyObject = copyObject;
        this.targetObject = ESC_SharedDataModel_BatchHelper.getTargetObject(copyObject);
        //System.debug('@@ sourceObject : '+this.copyObject+' targetObject : '+this.targetObject);
        recordIds = new List<Id>();
        logs = new List<ESC_Exception_Log__c>();
        query = 'SELECT Id '; //, ESC_INF_Tier_Source_ID__c, ESC_INF_Source_ID__c
        query += (this.copyObject == ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_TARGET)?', ESC_INF_Tier_Source_ID__c, ESC_INF_Source_ID__c':', ESC_INF_Source_ID__c';
        query += ' FROM';
        query += ' '+this.copyObject;
        System.debug('@@ Val : '+query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(Sobject s :scope){
             totRecProcessed++;
        }
        List<Sobject> recToUpdate = new List<Sobject>();
        try{
            ESC_SharedDataModel_Delete_Helper delHandler = new ESC_SharedDataModel_Delete_Helper(copyObject,targetObject);
            
            recToUpdate = delHandler.deleteObjects(scope);
            if(test.isRunningTest()){
                    System.debug('>> TC: '+recToUpdate);
                }
            if(recToUpdate.size()>0){
                List<Database.saveResult> ur = Database.update(recToUpdate,false);
                for(Integer i=0;i<ur.size();i++){
                    if(ur.get(i).isSuccess()){successRec+=1;}
                    else if(!ur.get(i).isSuccess()){
                        failRecs+=1;
                        Database.Error e = ur.get(i).getErrors().get(0);
                        errRec.add('ID : '+recToUpdate.get(i).Id+' | Error : '+e.getMessage()+' | Field : '+e.getFields());
                    }}
                System.debug('>>errRec Delete'+errRec.toString());
                if(errRec.size()>0){
                    //log exception to ESC_Exception_Log__c on record failures
                    ESC_Exception_Log__c excptn = ESC_Utils.createLogRecordFailure(BC.getJobId(),errRec,successRec, failRecs,totRecProcessed,ESC_Constants.LOG_LEVEL_CRITICAL, 'Execute',ESC_Constants.LOG_RECORDTYPE_BATCH);
                    logs.add(excptn);
                }
            }
        }
        catch(Exception ex){
            logs.add(ESC_Utils.createBatchExceptionLogInstance(ESC_SharedDataModel_DeleteBatch.class.getName(),ESC_Constants.LOG_BATCH_SHARED_DATA_MODEL_DELETE,ESC_Constants.LOG_LEVEL_CRITICAL,ex.getStackTraceString(),ex.getMessage(), ESC_Constants.EMPTY_STRING, BC.getJobId()));
        }
        
    }
    global void finish(Database.BatchableContext BC){
        //System.debug('error size'+errRec.size()+errRec);
        //system.debug('Success ids :'+successIds.size() +successIds.toString());
        ESC_Exception_Log__c exc = ESC_Utils.createInfoLogInstance(BC.getJobId(),ESC_Constants.LOG_RECORDTYPE_BATCH,totRecProcessed, ESC_Constants.LOG_LEVEL_INFO,'Finish', successRec, failRecs);
        logs.add(exc);
        
        if(logs.size()>0){
            insert logs;
        }
        
    }
}
*/
    //----------------------------
    //
    /*
    public class ESC_SharedDataModel_Delete_Helper {
    Map<Id,Id> recordIds {get; set;}
    Map<Id,Id> tierIds {get; set;}
    public String copyObject {get; set;}
    public String targetObject {get; set;}
    public List<Sobject> finalListtoUpdate{get;set;}
    List<ESC_Exception_Log__c> logs {get; set;}

    public ESC_SharedDataModel_Delete_Helper(String copyObject ,String targetObject){
        this.copyObject = copyObject;
        this.targetObject = targetObject;
        logs = new List<ESC_Exception_Log__c>();
        recordIds = new Map<Id,Id>();
        tierIds = new Map<Id,Id>();
    }
    
    /*
* @description Method to delete copyobject based on the scope we have
* @lstObjects list of SObject (copy)
* @return void
    /*public List<Sobject> deleteObjects(List<SObject> lstObjects){
        //List<SObject> recordForDeletion = new List<SObject>();
        List<SObject> recordForUpdate = new List<SObject>();
        String idVals;
        
            for(SObject obj: lstObjects){
                addIdInList(obj);//we will get recordIds (key - target record id, value is ESC_INF_sourceID__C) 
            }
            idVals=ESC_SharedDataModel_BatchHelper.getIdString(recordIds.values()); //string of all sourceid's on the copy records
            
            String query = 'Select Id from '+targetObject+' where Id in ('+idVals+')';
        System.debug('idVals = '+idVals);
        System.debug('query = '+query);
            List<Sobject> results = Database.query(query);
            Map<Id,SObject> finalMap = new Map<Id,SObject>(results);//main object id and record
            
            if(copyObject == ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_TARGET){
                //getting Tier data
                if(tierIds.size()>0){
                    idVals = ESC_SharedDataModel_BatchHelper.getIdString(tierIds.values());//string of all source tier id's on the copy Le Relationship
                    query = 'Select Id from ESC_Tier__c where Id in ('+idVals+')';//main Tier record ID, record
                    results = Database.query(query);
                }
                Map<Id,SObject> tierMap = new Map<Id,SObject>();
                if(results.size()>0){
                    tierMap = new Map<Id,SObject>(results);
                }
                
                Set<Id> comKeyIds = new Set<Id>();
                for(SObject obj: lstObjects){
                    ESC_LE_to_LE_Relationship__c targetObject = (ESC_LE_to_LE_Relationship__c)obj;
                    Id leRID = recordIds.get(targetObject.Id); //A //getting the original source ler ID from copy record
                    System.debug('@ leRID :'+leRID);
                    Id tierId = tierIds.get(targetObject.Id); //B//getting the original source Tier ID from copy record
                    System.debug('@ tierId :'+tierId);
                    String compositeKey ='';
                    if(leRID!=null && (!finalMap.containsKey(leRID))){
                        compositeKey = leRID; 
                    } 
                    System.debug('@ Compositekey :'+compositeKey);
                    if(tierId!=null && (!tierMap.containsKey(tierId))){ compositeKey = leRID+''+tierId;} 
                    System.debug('@ Compositekey :'+compositeKey);
                    String tempKey = targetObject.ESC_INF_Source_ID__c;
                    tempKey += targetObject.ESC_INF_Tier_Source_ID__c==null?'': targetObject.ESC_INF_Tier_Source_ID__c;
                    if(compositeKey == tempKey){
                        recordForUpdate.add(obj);
                    }
                }
            }else{
                for(SObject obj: lstObjects){
                    if(obj.getSObjectType()==Schema.ESC_Cost_Buildup__c.getSObjectType()){
                        if(!finalMap.containsKey(((ESC_Cost_Buildup__c)obj).ESC_INF_Source_ID__c)){
                            recordForUpdate.add(obj);
                        }
                    }
                    if(obj.getSObjectType()==Schema.ESC_Service_Taxonomy__c.getSObjectType()){
                        if(!finalMap.containsKey(((ESC_Service_Taxonomy__c)obj).ESC_INF_Source_ID__c)){
                            recordForUpdate.add(obj);
                        }
                    }
                }
            }
            System.debug('@ Record for Update: '+recordForUpdate);
            //Setting ESC_INF_Source_isDeleted__c = true, if source record is deleted
            for(Sobject obj:recordForUpdate){
                if(obj.getSObjectType()==Schema.ESC_LE_to_LE_Relationship__c.getSObjectType()){
                    ((ESC_LE_to_LE_Relationship__c)obj).ESC_INF_Source_isDeleted__c  = 'true';
                }
                if(obj.getSObjectType()==Schema.ESC_Cost_Buildup__c.getSObjectType()){
                    ((ESC_Cost_Buildup__c)obj).ESC_INF_Source_isDeleted__c   = 'true';
                }
                if(obj.getSObjectType()==Schema.ESC_Service_Taxonomy__c.getSObjectType()){
                    ((ESC_Service_Taxonomy__c)obj).ESC_INF_Source_isDeleted__c   = 'true';
                }        
            }
            System.debug('FinalList size : '+recordForUpdate.size());
           // update recordForUpdate;
          return recordForUpdate;
    }
  
    //Method to Add SourceId to RecordIds List
    public void addIdInList(SObject obj){
        String recId,sourceId,tierId;
        if(obj.getSObjectType()==Schema.ESC_LE_to_LE_Relationship__c.getSObjectType()){
            recId = ((ESC_LE_to_LE_Relationship__c)obj).Id;
            sourceId = ((ESC_LE_to_LE_Relationship__c)obj).ESC_INF_Source_ID__c;
            tierId = ((ESC_LE_to_LE_Relationship__c)obj).ESC_INF_Tier_Source_ID__c;
            recordIds.put(recId,sourceId);
            if(tierId!=null){
                tierIds.put(recId,tierId);
            }
            
        }
        if(obj.getSObjectType()==Schema.ESC_Cost_Buildup__c.getSObjectType()){
            recId = ((ESC_Cost_Buildup__c)obj).Id;
            sourceId = ((ESC_Cost_Buildup__c)obj).ESC_INF_Source_ID__c;
            recordIds.put(recId,sourceId);
        }
        if(obj.getSObjectType()==Schema.ESC_Service_Taxonomy__c.getSObjectType()){
            recId = ((ESC_Service_Taxonomy__c)obj).Id;
            sourceId = ((ESC_Service_Taxonomy__c)obj).ESC_INF_Source_ID__c;
            recordIds.put(recId,sourceId);
        }
        
    }
}*/
//------------------------------------
//
/*@isTest
public class ESC_SharedDataModel_Delete_Test {
    
    @testSetup static void setup() {
        //account creation
        Account accObj = ESC_TestDataFactory.createAccountInstanceOnly(ESC_SharedDataModel_BatchHelper.TEST_ACCOUNT,ESC_SharedDataModel_BatchHelper.LEGAL_ENTITY);
        insert accObj;
        List<Account> accList = [Select Id,Name from Account where Id =: accObj.Id];
        System.assert(accList.size()>0,'Account is not created');
        
        //level1 object
        ESC_Level_1_Service_Category__c srvs_level1 = ESC_TestDataFactory.createLevel1_ServiceCategoryInstanceOnly('TestLevel1','L');
        insert srvs_level1;
        List<ESC_Level_1_Service_Category__c> srvs_level1List = [Select Id from ESC_Level_1_Service_Category__c where Id =: srvs_level1.Id];
        System.assert(srvs_level1List.size()>0,'ESC_Level_1_Service_Category__c is not created');
        
        //level2 object
        ESC_Level_2_Service_Category__c srvs_level2 = ESC_TestDataFactory.createLevel2_ServiceCategoryInstanceOnly('TestLevel1',srvs_level1.Id);
        insert srvs_level2;
        List<ESC_Level_2_Service_Category__c> srvs_level2List = [Select Id from ESC_Level_2_Service_Category__c where Id =: srvs_level2.Id];
        System.assert(srvs_level2List.size()>0,'ESC_Level_2_Service_Category__c is not created');
        
        //level3 object
        ESC_Level_3_Service_Category__c srvs_level3 = ESC_TestDataFactory.createLevel3_ServiceCategoryInstanceOnly('TestLevel001',srvs_level1.Id,srvs_level2.ID,accObj.Id);
        insert srvs_level3;
        List<ESC_Level_3_Service_Category__c> srvs_level3List = [Select Id from ESC_Level_3_Service_Category__c where Id =: srvs_level3.Id];
        System.assert(srvs_level3List.size()>0,'ESC_Level_2_Service_Category__c is not created');     
    }
    @isTest
    static void TestLeRElationship(){
        
        Account accObj = [Select id from Account];
        ESC_Level_3_Service_Category__c srvs_level3 = [Select id from ESC_Level_3_Service_Category__c];
        ESC_LE_Relationship__c leRelObj = ESC_TestDataFactory.createLERelationship_InstanceOnly(srvs_level3.Id,accObj.Id);
        insert leRelObj;
        Test.startTest();
        ESC_LE_to_LE_Relationship__c leTarget = new ESC_LE_to_LE_Relationship__c();
        leTarget.ESC_INF_Source_ID__c =leRelObj.Id;
        insert leTarget;
        delete leRelObj;
        Database.executeBatch(new ESC_SharedDataModel_DeleteBatch('ESC_LE_to_LE_Relationship__c'));
        Test.stopTest();
        ESC_LE_to_LE_Relationship__c le = [SELECT id, ESC_INF_Source_isDeleted__c, ESC_INF_Source_ID__c from ESC_LE_to_LE_Relationship__c
                                           WHERE ESC_INF_Source_ID__c =:leRelObj.Id];
        System.assertEquals('true', le.ESC_INF_Source_isDeleted__c);
    }
    @isTest
    static void TestLeRelationshipWithTierData(){
        
        Account accObj = [Select id from Account];
        ESC_Level_3_Service_Category__c srvs_level3 = [Select id from ESC_Level_3_Service_Category__c];   
        //createLERelationship
        ESC_LE_Relationship__c leRelObj = ESC_TestDataFactory.createLERelationship_InstanceOnly(srvs_level3.Id,accObj.Id);
        insert leRelObj;
        List<ESC_LE_Relationship__c> leRelObjList = [Select Id from ESC_LE_Relationship__c where Id =: leRelObj.Id];
        System.assert(leRelObjList.size()>0,'ESC_LE_Relationship__c is not created');
        
        //create Tier Data
        ESC_Tier__c tierData = ESC_TestDataFactory.createTier_InstanceOnly(leRelObj.Id);
        insert tierData;
        List<ESC_Tier__c> tierObjList = [Select Id from ESC_Tier__c where Id =: tierData.Id];
        System.assert(tierObjList.size()>0,'ESC_Tier__c is not created');
        Test.startTest();
        ESC_LE_to_LE_Relationship__c leTarget = new ESC_LE_to_LE_Relationship__c();
        leTarget.ESC_INF_Source_ID__c =leRelObj.Id;
        insert leTarget;
        delete leRelObj;
        Database.executeBatch(new ESC_SharedDataModel_DeleteBatch('ESC_LE_to_LE_Relationship__c'));
        Test.stopTest();
        ESC_LE_to_LE_Relationship__c le = [SELECT id, ESC_INF_Source_isDeleted__c, ESC_INF_Source_ID__c from ESC_LE_to_LE_Relationship__c
                                           WHERE ESC_INF_Source_ID__c =:leRelObj.Id];
        System.assertEquals('true', le.ESC_INF_Source_isDeleted__c);
    }
    
    @isTest
    static void TestServiceProder(){
        Account accObj = [Select id from Account];
        ESC_Level_3_Service_Category__c srvs_level3 = [Select id from ESC_Level_3_Service_Category__c];
        
        ESC_CFO_Functional_Area__c cfoObj = ESC_TestDataFactory.create_CFO_Functional_Area_InstanceOnly('b_abc','b_abc');
        insert cfoObj;
        
        Test.startTest();
        //create_LE_Service_Provider_InstanceOnly
        ESC_LE_Service_Provider__c sprovider = ESC_TestDataFactory.create_LE_Service_Provider_InstanceOnly(srvs_level3.Id,cfoObj.Id);
        insert sprovider;
        List<ESC_LE_Service_Provider__c> sproviderList = [Select Id from ESC_LE_Service_Provider__c where Id =: sprovider.Id];
        System.assert(sproviderList.size()>0,'ESC_LE_Service_Provider__c is not created');
        ESC_Cost_Buildup__c cb = new ESC_Cost_Buildup__c();
        cb.ESC_INF_Source_ID__c =sprovider.Id;
        insert cb;
        delete sprovider;
        Database.executeBatch(new ESC_SharedDataModel_DeleteBatch('ESC_Cost_Buildup__c'));
        Test.stopTest();
        ESC_Cost_Buildup__c sp = [SELECT id, ESC_INF_Source_isDeleted__c, ESC_INF_Source_ID__c from ESC_Cost_Buildup__c
                                  WHERE ESC_INF_Source_ID__c =:sprovider.Id];
        System.assertEquals('true', sp.ESC_INF_Source_isDeleted__c);
    }
    @isTest
    static void TestServiceLevel3(){
        Account accObj = [Select id from Account];
        ESC_Level_1_Service_Category__c srvs_level1 = [Select id from ESC_Level_1_Service_Category__c limit 1];
        ESC_Level_2_Service_Category__c srvs_level2 = [Select id from ESC_Level_2_Service_Category__c limit 1];
        //level3 object
        List<ESC_Level_3_Service_Category__c> serviceList = new List<ESC_Level_3_Service_Category__c>();
        ESC_Level_3_Service_Category__c srvs_level3 = ESC_TestDataFactory.createLevel3_ServiceCategoryInstanceOnly('TestLevel1',srvs_level1.Id,srvs_level2.ID,accObj.Id);
        srvs_level3.ESC_Service_Type__c ='C2C';
        serviceList.add(srvs_level3);
        insert serviceList;
        Test.startTest();
        ESC_SharedDataModel bt = new ESC_SharedDataModel(ESC_SharedDataModel_BatchHelper.LEVEL3_SERVICE_SOURCE);
        Database.executeBatch(bt);
        List<ESC_Service_Taxonomy__c> stList = new List<ESC_Service_Taxonomy__c>();
        ESC_Service_Taxonomy__c e = new ESC_Service_Taxonomy__c();
        e.ESC_INF_Source_ID__c =srvs_level3.Id;
        stList.add(e);
        ESC_Service_Taxonomy__c eOne = new ESC_Service_Taxonomy__c();
        stList.add(eOne);
        insert stList;
        ESC_Service_Taxonomy__c stbefore = [SELECT id, ESC_INF_Source_isDeleted__c, ESC_INF_Source_ID__c from ESC_Service_Taxonomy__c
                                            WHERE ESC_INF_Source_ID__c =:srvs_level3.Id];
        delete srvs_level3;
        Database.executeBatch(new ESC_SharedDataModel_DeleteBatch('ESC_Service_Taxonomy__c'));
        Test.stopTest();
        List<ESC_Service_Taxonomy__c> stAfter = [SELECT id, ESC_INF_Source_isDeleted__c, ESC_INF_Source_ID__c from ESC_Service_Taxonomy__c
                                                ];
        for(ESC_Service_Taxonomy__c s:stAfter){
            if(s.ESC_INF_Source_isDeleted__c != null){
                System.assertEquals('true', s.ESC_INF_Source_isDeleted__c);
            }
        }
    }
}*/
}