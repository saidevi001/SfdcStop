public class SDM {
   /***********************************************************************
* Copyright (C) 2020
* United Services Automobile Association 
* All Rights Reserved
* Name    : ESC_SharedDataModel
* Purpose : The purpose of this Batch class is to populate Enterprise object data(on Insert/Update) to Aggregate Objects.

* Below is the Source-Target object mapping
* ESC_Level_3_Service_Category__c	- ESC_Service_Taxonomy__c	
* ESC_LE_Service_Provider__c - ESC_Cost_Buildup__c 	
* ESC_LE_Relationship__c, ESC_Tier__c	- ESC_LE_to_LE_Relationship__c	

* Test Class : ESC_SharedDataModel_Batch_Test
***********************************************************************/
/*
global class ESC_SharedDataModel implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
    public Integer totRecProcessed = 0;
    public Integer successRec =0;
    public Integer failRecs =0;
    List<String> errRec = new List<String>();
    public string query {get; private set;}
    public String sourceObject {get; set;}
    public String targetObject {get; set;}
    private ESC_SharedDataModel_Handler handler{get; set;}
    List<id> recordIds {get; set;}
    List<ESC_Exception_Log__c> logs {get; set;}
    List<String> successIds = new List<String>();
    
    public ESC_SharedDataModel(String sourceObject){
        this.sourceObject = sourceObject;
        this.targetObject = ESC_SharedDataModel_BatchHelper.getTargetObject(sourceObject);
        //System.debug('@@ sourceObject : '+this.sourceObject+' TargetObject : '+this.targetObject);
        recordIds = new List<Id>();
        logs = new List<ESC_Exception_Log__c>();
        query = ESC_SharedDataModel_BatchHelper.getStringQuery(this.sourceObject);
        query += ' where ESC_IsProcessed__c  = false';//setting this to true in finish()
        //query += ' LIMIT 50';
        //System.debug('@@ Query : '+query);
    }
 

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
  

    global void execute(Database.BatchableContext BC, List<sObject> scope){
                List<Sobject> finalList = new List<Sobject>();

       try{
             handler = new ESC_SharedDataModel_Handler(scope,targetObject);
             finalList= handler.createOrUpdateRecords();
           	 totRecProcessed = finalList.size();
          
           if(finalList.size()>0){
               List<Database.UpsertResult> ur = Database.upsert(finalList,false);
                   for(Integer i=0;i<ur.size();i++){
                    if(ur.get(i).isSuccess()){
                        successRec+=1;
                        successIds.add(ur.get(i).Id);
                    }
                    else if(!ur.get(i).isSuccess()){
                        failRecs+=1;
                        Database.Error e = ur.get(i).getErrors().get(0);
                        errRec.add('ID : '+finalList.get(i).Id+' | Error : '+e.getMessage()+' | Field : '+e.getFields());
                    }
                }
               System.debug('>>errRec batch'+errRec.toString());
                if(errRec.size()>0){
                   //log exception to ESC_Exception_Log__c on record failures
                   ESC_Exception_Log__c excptn = ESC_Utils.createLogRecordFailure(BC.getJobId(),errRec,successRec, failRecs,totRecProcessed,ESC_Constants.LOG_LEVEL_CRITICAL, 'Execute',ESC_Constants.LOG_RECORDTYPE_BATCH);
                    logs.add(excptn);
                }
           }
       }
        catch(Exception ex){
            logs.add(ESC_Utils.createBatchExceptionLogInstance(ESC_SharedDataModel.class.getName(),ESC_Constants.LOG_BATCH_SHARED_DATA_MODEL,ESC_Constants.LOG_LEVEL_CRITICAL,ex.getStackTraceString(),ex.getMessage(), ESC_Constants.EMPTY_STRING, BC.getJobId()));
        }
        
        //To set ESC_IsProcessed__c to true in finish()
        for(SObject obj:scope){
            recordIds.add(obj.Id);
        }
    }
    
 
    
    global void finish(Database.BatchableContext BC){
        List<Sobject> objList;
        //get the records whoes Id in recordIds.
        if(sourceObject == ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_SOURCE){
            objList = [SELECT Id,ESC_IsProcessed__c	 FROM ESC_LE_Relationship__c where Id in:recordIds];
        }
        if(sourceObject == ESC_SharedDataModel_BatchHelper.LE_SERVICE_PROVIDER_SOURCE){
            objList = [SELECT Id,ESC_IsProcessed__c	 FROM ESC_LE_Service_Provider__c where Id in:recordIds];
        }
        if(sourceObject == ESC_SharedDataModel_BatchHelper.LEVEL3_SERVICE_SOURCE){
            objList = [SELECT Id,ESC_IsProcessed__c	 FROM ESC_Level_3_Service_Category__c where Id in:recordIds];
        }
        System.debug('Final records:'+objList.size());
        //update the checkbox to false
        for(SObject obj: objList){
            
            if(obj.getSObjectType()==Schema.ESC_LE_Relationship__c.getSObjectType()){
                ((ESC_LE_Relationship__c)obj).ESC_IsProcessed__c	 = true;
            }
            if(obj.getSObjectType()==Schema.ESC_LE_Service_Provider__c.getSObjectType()){
                ((ESC_LE_Service_Provider__c)obj).ESC_IsProcessed__c	 = true;
            }
            if(obj.getSObjectType()==Schema.ESC_Level_3_Service_Category__c.getSObjectType()){
                ((ESC_Level_3_Service_Category__c)obj).ESC_IsProcessed__c	 = true;
            }
        }
        update objList;
      
        ESC_Exception_Log__c exc = ESC_Utils.createInfoLogInstance(BC.getJobId(),ESC_Constants.LOG_RECORDTYPE_BATCH,totRecProcessed, ESC_Constants.LOG_LEVEL_INFO,'Finish', successRec, failRecs);
        logs.add(exc); 
        
        if(!logs.isEmpty())
        {
            insert logs; 
            
        }
        //uncomment
       ESC_SharedDataModel_DeleteBatch obj = new ESC_SharedDataModel_DeleteBatch(targetObject);
       Database.executeBatch(obj,50);
    }
    
    global void execute(SchedulableContext SC) {
        ESC_SharedDataModel bt = new ESC_SharedDataModel(this.sourceObject); 
        Database.executeBatch(bt,50);
    }
    
}*/
//--------------------------------
/*public class ESC_SharedDataModel_BatchHelper {
    
     public static String LEVEL3_SERVICE_SOURCE {get; set;}
    public static String LE_SERVICE_PROVIDER_SOURCE {get; set;} 
    public static String LE_RELATIONSHIP_SOURCE {get; set;}
    
    public static String LEVEL3_SERVICE_TARGET {get; set;}
    public static String LE_SERVICE_PROVIDER_TARGET {get; set;}
    public static String LE_RELATIONSHIP_TARGET {get; set;}
    
    public static String TEST_ACCOUNT {get; set;}
    public static String LEGAL_ENTITY {get; set;}
    public static String LNAME {get; set;}
  public static String TIER {get; set;}
    
    static{
        LEVEL3_SERVICE_SOURCE = 'ESC_Level_3_Service_Category__c';
        LE_SERVICE_PROVIDER_SOURCE = 'ESC_LE_Service_Provider__c';
        LE_RELATIONSHIP_SOURCE = 'ESC_LE_Relationship__c';
        
        LEVEL3_SERVICE_TARGET = 'ESC_Service_Taxonomy__c';
        LE_SERVICE_PROVIDER_TARGET = 'ESC_Cost_Buildup__c';
        LE_RELATIONSHIP_TARGET = 'ESC_LE_to_LE_Relationship__c';
        
        TEST_ACCOUNT = 'Test Account';
        LEGAL_ENTITY = 'Corporation';
        LNAME = 'User';
       TIER = 'ESC_Tier__c';
    }   
    
    public static String getTargetObject (String sourceObject){
        String targetObjectName;
        if(sourceObject == LEVEL3_SERVICE_SOURCE){
            targetObjectName = LEVEL3_SERVICE_TARGET;
        }
        if(sourceObject == LE_SERVICE_PROVIDER_SOURCE){
            targetObjectName = LE_SERVICE_PROVIDER_TARGET;
        }
        if(sourceObject == LE_RELATIONSHIP_SOURCE){
            targetObjectName = LE_RELATIONSHIP_TARGET;
        }
         if(sourceObject == LE_RELATIONSHIP_TARGET){
            targetObjectName = LE_RELATIONSHIP_SOURCE;
        }
        if(sourceObject == LE_SERVICE_PROVIDER_TARGET){
            targetObjectName = LE_SERVICE_PROVIDER_SOURCE;
        }
        if(sourceObject == LEVEL3_SERVICE_TARGET){
            targetObjectName =LEVEL3_SERVICE_SOURCE;
        }
        System.debug('@@ TargetObject : '+targetObjectName);
        return targetObjectName;
    }
    
    
    public static Map<String, String> getSourceTargetFieldMapping (String sourceObjName, String targetobjName){
        
        Map<String, String> fieldMapping = new Map<String, String>();
        List<ESC_SharedDataModel__mdt> objMapping = [SELECT Id,
                                                        ESC_Is_Active__c,
                                                        ESC_SourceFieldName__c,
                                                        ESC_SourceObjectName__c  ,
                                                        ESC_TargetFieldName__c,
                                                        ESC_TargetObjectName__c
                                                        FROM ESC_SharedDataModel__mdt
                                                        WHERE ESC_SourceObjectName__c =: sourceObjName AND
                                                        ESC_TargetObjectName__c =: targetobjName AND
                                                        ESC_Is_Active__c = true];
        
        for(ESC_SharedDataModel__mdt mdtObj : objMapping){
            fieldMapping.put(mdtObj.ESC_TargetFieldName__c, mdtObj.ESC_SourceFieldName__c);
        }
        return fieldMapping;
    }
    
    public static String getQuery(String sourceObjName){
        String query = '';
        List<ESC_SharedDataModel__mdt> objMapping = [SELECT Id,
                                                         ESC_SourceFieldName__c,
                                                        ESC_Is_Active__c
                                                        FROM ESC_SharedDataModel__mdt
                                                        WHERE ESC_Is_Active__c = true AND
                                                        ESC_SourceObjectName__c =: sourceObjName];
        
        for(ESC_SharedDataModel__mdt mdtObj : objMapping){
            if(query == ''){
                query = mdtObj.ESC_SourceFieldName__c;
            } else {
                query += ','+ mdtObj.ESC_SourceFieldName__c;
            }
        }
        System.debug('@ Query :'+query);
        return query;
    }
    
    public static Map<String,Id> LoadData(String targetObjName, Set<Id> sourceIds){
        System.debug('@ Target Object Name :'+ targetObjName);
        Map<String, Id> sourceWiseTargetID = new Map<String, ID>();
        List<SObject> targetObjList;
        //get list of target object
        if(targetObjName == ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_TARGET){
            targetObjList = [Select Id,ESC_INF_Source_ID__c,ESC_INF_Tier_Source_ID__c FROM ESC_LE_to_LE_Relationship__c where ESC_INF_Source_ID__c in:sourceIds];
        }
        if(targetObjName == ESC_SharedDataModel_BatchHelper.LEVEL3_SERVICE_TARGET){
            targetObjList = [Select Id,ESC_INF_Source_ID__c FROM ESC_Service_Taxonomy__c  where ESC_INF_Source_ID__c in:sourceIds];
        }
        if(targetObjName == ESC_SharedDataModel_BatchHelper.LE_SERVICE_PROVIDER_TARGET){
            targetObjList = [Select Id,ESC_INF_Source_ID__c FROM ESC_Cost_Buildup__c  where ESC_INF_Source_ID__c in:sourceIds];
        }
        
        for(SObject obj: targetObjList){

            if(obj.getSObjectType()==Schema.ESC_LE_to_LE_Relationship__c.getSObjectType()){
                if((!String.isEmpty(((ESC_LE_to_LE_Relationship__c)obj).ESC_INF_Source_ID__c))){
                    //forming composite key if LE Relationsip has Tier data
                    String tempKey = ((ESC_LE_to_LE_Relationship__c)obj).ESC_INF_Source_ID__c;
                    tempKey += ((ESC_LE_to_LE_Relationship__c)obj).ESC_INF_Tier_Source_ID__c==null?'': ((ESC_LE_to_LE_Relationship__c)obj).ESC_INF_Tier_Source_ID__c;
                    
                    System.debug('@@ tempKey : '+tempKey);
                    sourceWiseTargetID.put(tempKey, obj.Id);
                }
            }
            if(obj.getSObjectType()==Schema.ESC_Cost_Buildup__c.getSObjectType()){
                if(!String.isEmpty(((ESC_Cost_Buildup__c)obj).ESC_INF_Source_ID__c)){
                    sourceWiseTargetID.put(((ESC_Cost_Buildup__c)obj).ESC_INF_Source_ID__c, obj.Id);
                }
            }
            if(obj.getSObjectType()==Schema.ESC_Service_Taxonomy__c.getSObjectType()){
                if(!String.isEmpty(((ESC_Service_Taxonomy__c)obj).ESC_INF_Source_ID__c)){
                    sourceWiseTargetID.put(((ESC_Service_Taxonomy__c)obj).ESC_INF_Source_ID__c, obj.Id);
                }
            }
        }
        System.debug('@ SourcewiseID : '+sourceWiseTargetID);
        //return map of source and target record id's
        return sourceWiseTargetID;
    }
    
      //getting value of source relationship fields
     public static Object getRelatedFieldValue(sObject sourceObj, String sourceFieldName) {
         System.debug('@@ Field Name : '+sourceFieldName);
         System.debug('@@ obj Name : '+sourceObj);
         Object objVal = null;
         if(sourceObj!=null){
             if(sourceFieldName.contains('.')){
                 String relation = sourceFieldName.substringBefore('.');
                 String relatedField = sourceFieldName.substringAfter('.');
                 System.debug('@@ relation Name : '+relation);
                 System.debug('@@ relatedField Name : '+relatedField);
                 objVal =  getRelatedFieldValue((sObject)sourceObj.getSObject(relation), relatedField);
             } else {
                 objVal = sourceObj.get(sourceFieldName);
             }
         }
         return objVal;
        
    }
    
     public static String getIdString(List<Id> recordIds){
        String idVals='';
         if(test.isRunningTest()){
             idVals= '\'\'';
         }
        for(Id idVal:recordIds){
            if(String.isEmpty(idVals)) {
                idVals += '\''+idVal+'\'';
            } else {
                idVals += ',\''+idVal+'\'';
            }
        }
        return idVals;
    }
    
    public static String getStringQuery(String objectName){
        String query = 'SELECT';
        query += ' '+String.valueof(ESC_SharedDataModel_BatchHelper.getQuery(objectName));
        query += ' FROM';
        query += ' '+objectName;
        return query;
    }
}*/
    //----------------------
   /* public class ESC_SharedDataModel_Handler {
    
    private List<SObject> sourceObjects {get; set;}
    private String targetObjectName {get; set;}
    private String sourceObjectName {get; set;}
    private List<Sobject> objectToInsert {get; set;}
    private List<Sobject> objectToUpdate {get; set;}
    private Map<Id,List<ESC_Tier__c>> relWiseTiers {get; set;}
    private Map<String,String> fieldMapping {get; set;}
    private Map<String,String> tierFieldMapping{get; set;}
    private Map<String,Id> ObjectWiseObj {get; set;}
    private Set<Id> sourceRecIds{get; set;}
    List<Sobject> finalList = new List<Sobject>();
    
    
    public ESC_SharedDataModel_Handler(List<Sobject> sourceObjects,String targetObj){
        this.sourceObjects = sourceObjects;
        if(sourceObjects.size()>0){
            this.sourceObjectName = sourceObjects[0].getSObjectType().getDescribe().getName();
        }else{
            this.sourceObjectName='';
        }
        
        this.sourceRecIds=  (new Map<ID,Sobject>(sourceObjects)).keySet();
        System.debug('Set : '+sourceRecIds);
        this.targetObjectName = targetObj;
        initInstances();
    }
    
    private void initInstances(){
        this.fieldMapping = new Map<String,String>();
        this.objectToInsert = new List<Sobject>();
        this.objectToUpdate = new List<Sobject>();
        this.tierFieldMapping =new Map<String,String>();
        this.ObjectWiseObj = new Map<String,Id>();
    }
    
    
    //getting Map of ESC_LE_Relationship__c with related tier data 
    private void fetchTierData(){
        String idVals='';
        relWiseTiers = new Map<Id,List<ESC_Tier__c>>();
        if(sourceObjectName == ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_SOURCE){
            //fetching all LE Relationship ids
            for(SObject obj:sourceObjects){
                Id idVal = ((ESC_LE_Relationship__c)obj).Id;
                if(String.isEmpty(idVals)) {
                    idVals += '\''+idVal+'\'';
                } else {
                    idVals += ',\''+idVal+'\'';
                }
            }
            //prepare Tier Query  
            String query = 'SELECT';
            query += ' '+String.valueof(ESC_SharedDataModel_BatchHelper.getQuery(ESC_SharedDataModel_BatchHelper.TIER));
            query += ' FROM';
            query += ' '+ESC_SharedDataModel_BatchHelper.TIER;
            query += ' Where ESC_LE_Relationship__c in ('+idVals+')';
            
            List<ESC_Tier__c> tierLst = Database.query(query);
            List<ESC_Tier__c> tempList;
            
            //prepare le relationship wise Tier objects
            for(ESC_Tier__c tiers:tierLst){
                if(relWiseTiers.containsKey(tiers.ESC_LE_Relationship__c)){
                    tempList = (List<ESC_Tier__c>)relWiseTiers.get(tiers.ESC_LE_Relationship__c);
                    tempList.add(tiers);
                }else{
                    tempList = new List<ESC_Tier__c>();
                    tempList.add(tiers);
                }
                relWiseTiers.put(tiers.ESC_LE_Relationship__c,tempList);
            }
        }
    }
    
    public List<Sobject> createOrUpdateRecords(){
        //Target object record list to insert/update
        List<SObject> dRecordLst; 
        List<ESC_Tier__c> tierList;
        //get target and source field mapping
        fieldMapping = ESC_SharedDataModel_BatchHelper.getSourceTargetFieldMapping(sourceObjectName,targetObjectName);
        //get source and target field mapping where source is ESC_Tier__C
        //getting tier data
        if(sourceObjectName==ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_SOURCE){
            fetchTierData();
            tierFieldMapping = ESC_SharedDataModel_BatchHelper.getSourceTargetFieldMapping(ESC_SharedDataModel_BatchHelper.TIER,targetObjectName);
            
        }
        //return map of source and target record id's
        ObjectWiseObj = ESC_SharedDataModel_BatchHelper.LoadData(targetObjectName,sourceRecIds);
        for(SObject obj:sourceObjects){
            //check the type of source object is LE_RELATIONSHIP
            if(sourceObjectName==ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_SOURCE){
                processLERelationship(obj);
            }else{
                //check the type of source object is other than LE_RELATIONSHIP
                dRecordLst = new List<SObject>(); 
                dRecordLst.add(initialObject(targetObjectName));
                for(Sobject dRecord:dRecordLst){
                    for(String key:fieldMapping.keySet()){
                        //getting source field name
                        String fieldName = fieldMapping.get(key);
                        //getting value of source field.
                        String val = String.valueOf(ESC_SharedDataModel_BatchHelper.getRelatedFieldValue(obj,fieldName));
                        //Map target field and source field
                        dRecord.put(key,val);
                    }
                    //ObjectWiseObj--> map of source and target record id's
                    if(ObjectWiseObj.containsKey(obj.Id)){
                        dRecord.put('Id',ObjectWiseObj.get(obj.Id));
                        objectToUpdate.add(dRecord);
                    }else{
                        objectToInsert.add(dRecord);
                    }
                }
            }
            System.debug('@@ objectToUpdate : '+objectToUpdate);
            System.debug('@@ objectToInsert : '+objectToInsert);
        }
        finalList.addAll(objectToUpdate);
        finalList.addAll(objectToInsert);
       System.debug('finalList from Handler :'+finalList.size());
       return finalList;
    }
    
    //If Object is LE RElationship with or without Tier Data
    //obj - source
    private void processLERelationship(SObject obj){
        List<ESC_Tier__c> tierList;
        List<Sobject> dRecordLst = new  List<Sobject>();
        //get related Tiers for the source record
        if(relWiseTiers.containsKey(obj.Id)){
            tierList = (List<ESC_Tier__c>)relWiseTiers.get(obj.Id);
        }else{
            tierList = new List<ESC_Tier__c>();
        }
        
        if(tierList.size()>0){ //with tier data
            //based on tier list we create new objects.
            for(integer i=0;i<tierList.size();i++){
                dRecordLst.add(initialObject(targetObjectName));
            }
        }else{//without tier data
            dRecordLst.add(initialObject(targetObjectName)); 
        }
        Integer count=0;
        //Iterating the object for mapping key and value
        for(Sobject dRecord:dRecordLst){
            
            //Le-rationship records
            for(String key:fieldMapping.keySet()){
                //getting source field name
                String fieldName = fieldMapping.get(key);
                //getting value of source field.
                String val = String.valueOf(ESC_SharedDataModel_BatchHelper.getRelatedFieldValue(obj,fieldName));
                //putting the values on destination object.
                dRecord.put(key,val);
            }
            
            if(tierList.size()>0){
                //tier records
                for(String key:tierFieldMapping.keySet()){
                    //getting source field name
                    String fieldName = tierFieldMapping.get(key);
                    //getting value of source field.
                    ////should we iterate over each tier and get composite key?
                    String val = String.valueOf(ESC_SharedDataModel_BatchHelper.getRelatedFieldValue(tierList[count],fieldName));
                    //putting the values on destination object.
                    dRecord.put(key,val);
                }
            }
            String compositeKey = tierList.size()>0?obj.Id +String.valueOf(tierList[count].Id):obj.Id;
            if(ObjectWiseObj.containsKey(compositeKey)){
                dRecord.put('Id',ObjectWiseObj.get(compositeKey));
                objectToUpdate.add(dRecord);
            }else{
                objectToInsert.add(dRecord);
            }
            count++;
            System.debug('@@ objectToInsert.size : '+objectToInsert.size());
        }
        
    }
    
    //Method which instantiate the object based on the target object name
    private Sobject initialObject(String typeName){
        Sobject obj;
        if(typeName == ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_TARGET){
            obj = new ESC_LE_to_LE_Relationship__c();
        }
        if(typeName==ESC_SharedDataModel_BatchHelper.LEVEL3_SERVICE_TARGET){
            obj =  new ESC_Service_Taxonomy__c();
        }
        if(typeName==ESC_SharedDataModel_BatchHelper.LE_SERVICE_PROVIDER_TARGET){
            obj =  new ESC_Cost_Buildup__c();
        }
        return obj;
    }
    // Method to insert Object
    private void insertObjects(){
        if(objectToInsert.size()>0){
            List<Database.SaveResult> sr= Database.insert(objectToInsert, false);
        } 
    }
    //Method to update object
    private void updateObjects(){
        if(objectToUpdate.size()>0)
            Database.update(objectToUpdate, false);
    }
}*/
    
    //Test
   /* @isTest
public class ESC_SharedDataModel_Batch_Test {
    
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
        
        //createLERelationship
        ESC_LE_Relationship__c leRelObj = ESC_TestDataFactory.createLERelationship_InstanceOnly(srvs_level3.Id,accObj.Id);
        insert leRelObj;
        
        Test.startTest();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        String jobId = System.schedule('SharedDataModel batch',  CRON_EXP, new ESC_SharedDataModel(ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_SOURCE));
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
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
        ESC_SharedDataModel bt = new ESC_SharedDataModel(ESC_SharedDataModel_BatchHelper.LE_RELATIONSHIP_SOURCE);
        database.executeBatch(bt);
        Test.stopTest();
        
        ESC_LE_to_LE_Relationship__c le= [Select Id, ESC_INF_Source_ID__c from ESC_LE_to_LE_Relationship__c where ESC_INF_Source_ID__c =:leRelObj.Id];
        System.assertEquals(leRelObj.Id, le.ESC_INF_Source_ID__c);
    }
    
    @isTest
    static void TestServiceProvider(){
        Account accObj = [Select id from Account];
        ESC_Level_3_Service_Category__c srvs_level3 = [Select id from ESC_Level_3_Service_Category__c];
        
        ESC_CFO_Functional_Area__c cfoObj = ESC_TestDataFactory.create_CFO_Functional_Area_InstanceOnly('b_abc','b_abc');
        insert cfoObj;
        
        //create_LE_Service_Provider_InstanceOnly
        ESC_LE_Service_Provider__c sprovider = ESC_TestDataFactory.create_LE_Service_Provider_InstanceOnly(srvs_level3.Id,cfoObj.Id);
        insert sprovider;
        List<ESC_LE_Service_Provider__c> sproviderList = [Select Id from ESC_LE_Service_Provider__c where Id =: sprovider.Id];
        System.assert(sproviderList.size()>0,'ESC_LE_Service_Provider__c is not created');
        
        Test.startTest();
        ESC_SharedDataModel bt = new ESC_SharedDataModel(ESC_SharedDataModel_BatchHelper.LE_SERVICE_PROVIDER_SOURCE);
        Database.executeBatch(bt);
        Test.stopTest();
        
        ESC_Cost_Buildup__c sp = [SELECT id, ESC_INF_Source_ID__c from ESC_Cost_Buildup__c Limit 1];
        System.assertEquals(sprovider.Id, sp.ESC_INF_Source_ID__c);
    }
    @isTest
    static void TestServiceLevel3(){
        Account accObj = [Select id from Account];
        ESC_Level_3_Service_Category__c srvs_level3 = [Select id from ESC_Level_3_Service_Category__c];
        
        Test.startTest();
        ESC_SharedDataModel bt = new ESC_SharedDataModel(ESC_SharedDataModel_BatchHelper.LEVEL3_SERVICE_SOURCE);
        Database.executeBatch(bt); 
        Test.stopTest();
        
        ESC_Service_Taxonomy__c st = [SELECT id, ESC_INF_Source_ID__c from ESC_Service_Taxonomy__c Limit 1];
        System.assertEquals(srvs_level3.Id, st.ESC_INF_Source_ID__c);
    }
}*/
}