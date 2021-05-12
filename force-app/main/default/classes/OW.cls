public class OW {
      static boolean isFirstRun=true;
/*public class APTS_Overwatch_App {

    public String appPrefix {public get; private set;}
    public String emailAddress {public get; private set;}
    private List<ApexTestResult> failedTests;
    private List<ApexTestResult> passedTests;
    private List<ApexTestResult> queuedTests;

    public APTS_Overwatch_App(String appPrefix, String emailAddress) {
        this.appPrefix = appPrefix;
        this.emailAddress = emailAddress;
        this.failedTests = new List<ApexTestResult>();
        this.passedTests = new List<ApexTestResult>();
    }

    public void addFailedTestResult(ApexTestResult failedResult){
        if(failedResult.outcome.equalsIgnoreCase('FAIL')){
            this.failedTests.add(failedResult);
        }
    }

    public void addPassedTestResult(ApexTestResult passedResult){
        if(passedResult.outcome.equalsIgnoreCase('PASS')){
            this.passedTests.add(passedResult);
        }
    }

    public String getHtmlBody(){

        String emailHeader = buildEmailHeader();
        
        final String lineBreaks = '</br> </br>'; 

        String failureTable = getFailureTableBody();
        String successTable = getSuccessTableBody();

        String htmlBody = emailHeader + lineBreaks + failureTable + lineBreaks + successTable;

        return htmlBody;
    }

    private String buildEmailHeader(){

        String orgName = getOrgName();
        String emailHeader = '<article> <header>';
        emailHeader += '<h2> ' + orgName + ' Overwatch </h2>';
        emailHeader += '<p> App: ' + this.appPrefix + '</p>'; 
        emailHeader += '<p>  Date: ' + Date.today() + '</p> ';
        emailHeader += '</header> </article> ';

        return emailHeader;
    }

    private String getOrgName(){
        return String.valueOf(URL.getSalesforceBaseUrl().getHost().substringBetween('--','.'));
    }

    @TestVisible
    private String getFailureTableBody() {

        if(this.failedTests.isEmpty()){
            return 'Hooray! No test classes failed for the ' + this.appPrefix + ' prefix.'; 
        }

        List<String> columns = new List<String>{'Class', 'Method', 'Message', 'Stack Trace'};

        APTS_TableGenerator.setTitle('Overwatch Test Results - Failures');
        APTS_TableGenerator.createColumn(columns); 

        for(ApexTestResult test : this.failedTests){

            String className = String.valueOf(test.ApexClass.Name);
            String methodName = String.valueOf(test.MethodName);

            APTS_TableGenerator.addRow(new List<String>{className, methodName, test.Message, test.StackTrace});
        }

        String successTable = APTS_TableGenerator.getTable();

        return successTable;

    }

    @TestVisible
    private String getSuccessTableBody(){

        if(this.passedTests.isEmpty()){
            return 'Barnacles! No test classes passed for the ' + this.appPrefix + ' prefix.'; 
        }

        List<String> columns = new List<String>{'Class', 'Method', 'Runtime (ms)'};

        APTS_TableGenerator.setTitle('Overwatch Test Results - Successes');
        APTS_TableGenerator.createColumn(columns); 

        for(ApexTestResult test : this.passedTests){

            String className = String.valueOf(test.ApexClass.Name);
            String methodName = String.valueOf(test.MethodName);
            String runTime = String.valueOf(test.RunTime);

            APTS_TableGenerator.addRow(new List<String>{className, methodName, runTime});
        }

        String failureTable = APTS_TableGenerator.getTable();

        return failureTable;
    }
}
//--------------------------------
//@isTest
public class APTS_Overwatch_App_Test {

    private static Map<String, APTS_Overwatch_App> overWatchMapping;
    final static String PASSED_TESTS_ERROR_STRING = 'Barnacles! No test classes passed for the APTS prefix.';
    final static String FAILED_TESTS_ERROR_STRING = 'Hooray! No test classes failed for the APTS prefix.';

    @isTest
    private static void testFailures(){

        String appPrefix = 'APTS';
        String appEmail = 'gspit@usaa.com.test';

        APTS_Overwatch_App app = new APTS_Overwatch_App(appPrefix, appEmail);

        for(Integer i = 0; i < 250; i++){
            ApexTestResult failedResult = new ApexTestResult();
            failedResult.Outcome = 'Fail';
            app.addFailedTestResult(failedResult);
        }

        String htmlFailureTableBody = app.getFailureTableBody();
        String htmlSuccessTableBody = app.getSuccessTableBody();
        

        System.assert(String.isNotBlank(htmlFailureTableBody), 'The HTML should not be blank.'); 
        System.assertNotEquals(htmlFailureTableBody, FAILED_TESTS_ERROR_STRING, 'The HTML should not contains this message. Failed test classes should have been found.');
        System.assertEquals(htmlSuccessTableBody, PASSED_TESTS_ERROR_STRING, 'Success table body should contain error message since no tests passed.'); 


    }

    @isTest
    private static void testSuccess(){

        String appPrefix = 'APTS';
        String appEmail = 'gspit@usaa.com.test';

        APTS_Overwatch_App app = new APTS_Overwatch_App(appPrefix, appEmail);

        for(Integer i = 0; i < 250; i++){
            ApexTestResult successResult = new ApexTestResult();
            successResult.Outcome = 'Pass';
            app.addPassedTestResult(successResult);
        }

        String htmlSuccessTableBody = app.getSuccessTableBody();
        String htmlFailureTableBody = app.getFailureTableBody();
        
        System.assert(String.isNotBlank(htmlSuccessTableBody), 'Success table body returned value should not be blank.'); 
        System.assertNotEquals(htmlSuccessTableBody, PASSED_TESTS_ERROR_STRING, 'Items should have been added to success list.');
        System.assertEquals(htmlFailureTableBody, FAILED_TESTS_ERROR_STRING, 'This string should return with the expected error message.');
        

    }

    @isTest
    private static void lineCoverageOnly(){
    
        String appPrefix = 'APTS';
        String appEmail = 'gspit@usaa.com.test';

        APTS_Overwatch_App app = new APTS_Overwatch_App(appPrefix, appEmail);

        String htmlBody = app.getHtmlBody();
    }

}
//-------------------
//public class APTS_Overwatch_Batch implements Database.Batchable<sObject>{

    public Id bigJobId = null;
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = getQuery(); 
        return (Database.QueryLocator) Database.getQueryLocator(query);
   }

   private String getQuery(){
        Map<String, String> metadataMapping = getMetadata();

        if(metadataMapping.size() < 0) {
            return ''; //TODO: dont do this
        }

        String query = buildQuery(metadataMapping.keySet());

        return query;
    }

    private Map<String, String> getMetadata(){

        Map<String, String> metadataMapping = new Map<String, String>();
        //commentted before
       /* for(APTS_Overwatch__mdt metadataRecord : [SELECT APTS_App_Prefix__c, APTS_Notification_Email_Address__c FROM APTS_Overwatch__mdt]){
            metadataMapping.put(metadataRecord.APTS_App_Prefix__c, metadataRecord.APTS_Notification_Email_Address__c); 
        } */
       /* 
        return metadataMapping; 
    }

    private String buildQuery(Set<String> appPrefixes){
        String query = 'SELECT ID FROM ApexClass WHERE Name LIKE %test% AND';
        String queryDynamicCondition = ''; 

        Boolean firstPass = true; 
        
        // to create: "SELECT ID FROM ApexClass WHERE Name Like %test% AND (Name LIKE APTS% OR Name LIKE ASR%)"
        for(String appPrefix : appPrefixes){
            queryDynamicCondition = 'Name LIKE \'' + appPrefix + '%\''; 
            if(firstPass){
                query = query + ' (' + queryDynamicCondition;
            } 
            else {
                query = query + ' OR ' + queryDynamicCondition;
            }
            firstPass = false;
        }
        query += ' )';
        return query;
    }

   public void execute(Database.BatchableContext BC, List<sObject> scope){
        Id queueId = enqueueTests(scope);
        setJobIdFromQueueId(queueId);
   }

   public Id enqueueTests(List<ApexClass> testClasses) {
        List<ApexTestQueueItem> queueItems = new List<ApexTestQueueItem>();

        for (ApexClass cls : testClasses) {
            queueItems.add(new ApexTestQueueItem(ApexClassId = cls.Id));
        }

        insert queueItems;

        return queueItems[0].Id; 
    }

    private void setJobIdFromQueueId(Id queueId){
        // Get the job ID of the first queue item returned.
        Id apexTestQueueItemId = [
                                    SELECT ParentJobId 
                                    FROM ApexTestQueueItem 
                                    WHERE Id =: queueId
                                    ORDER BY CreatedDate LIMIT 1
                                ].parentJobId;

        this.bigJobId = apexTestQueueItemId;
    }
 
   public void finish(Database.BatchableContext BC){
       checkMethodStatus(this.bigJobId);
   } 


    public void checkMethodStatus(ID jobId) {
        ApexTestResult[] results = 
            [SELECT Outcome, ApexClass.Name, MethodName, Message, StackTrace 
            FROM ApexTestResult 
            WHERE AsyncApexJobId=:jobId];
        for (ApexTestResult atr : results) {
            System.debug(atr.ApexClass.Name + '.' + atr.MethodName + ': ' + atr.Outcome);
            if (atr.message != null) {
                System.debug(atr.Message + '\n at ' + atr.StackTrace);
            }
        }
    }

} 
//--------------------
//@isTest
public class APTS_Overwatch_Combined_Test {

    @isTest
    private static void setOverwatchMapping_Test(){
        APTS_Overwatch_Enqueue_Scheduled enqueueOverwatch = new APTS_Overwatch_Enqueue_Scheduled();
        enqueueOverwatch.setAppPrefixToResult();

        Map<String, APTS_Overwatch_App> appPrefixToResult = enqueueOverwatch.appPrefixToResult;
        Integer mapSize = appPrefixToResult.size();

        System.assertNotEquals(0, mapSize, 'The map should not be empty.');
    }
    
    @isTest 
    private static void getTestClasses_Test(){
        APTS_Overwatch_Enqueue_Scheduled enqueueOverwatch = new APTS_Overwatch_Enqueue_Scheduled();
        Boolean exceptionOccured = false;

        enqueueOverwatch.setAppPrefixToResult();
        
        try{
            enqueueOverwatch.getTestClasses(); 
        }
        catch(Exception e){
            String v = '';
            v += ' ' + e.getCause();
            v += ' ' + e.getLineNumber();
            v += ' ' + e.getMessage();
            v += ' ' + e.getStackTraceString();
            System.debug(v);
            exceptionOccured = true;
        }

        System.assert(!exceptionOccured);
    }


    @isTest 
    private static void scheduleJob_Test(){
        
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute()); 
        String ss = String.valueOf(Datetime.now().second());
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';

        APTS_Overwatch_Enqueue_Scheduled overwatchEnqueueScheduled = new APTS_Overwatch_Enqueue_Scheduled();

        String jobName = 'APTS_Overwatch_Enqueue_Scheduled_' + Date.today();

        Integer numberOfJobsBefore = [SELECT COUNT() FROM AsyncApexJob];
        System.assertEquals(0, numberOfJobsBefore, 'There should be no Async Jobs');
       
        Test.startTest();
            String jobId = System.schedule(jobName, nextFireTime, overwatchEnqueueScheduled);
            Integer invocations = Limits.getEmailInvocations();
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();

        
        System.assertEquals(nextFireTime, ct.CronExpression, 'Cron Trigger should match.'); 

        Integer numberOfJobsAfter = [SELECT COUNT() FROM AsyncApexJob where JobType = 'ScheduledApex'];
        System.assertEquals(1, numberOfJobsAfter, 'There should be one scheduled job');
    }
}
//-------------------
//public class APTS_Overwatch_Enqueue_Scheduled implements Schedulable {

    private Id apexTestQueueItemId;
    @TestVisible private Map<String, APTS_Overwatch_App> appPrefixToResult = new Map<String, APTS_Overwatch_App>();
    
    public void execute(SchedulableContext SC){
        try {
            setAppPrefixToResult();
            List<ApexClass> testClassesToRun = getTestClasses(); 
            enqueueTests(testClassesToRun);
            scheduleNextJob();
        }
       catch(Exception e){
           System.debug(e);
       }
   }


    @TestVisible
    private void setAppPrefixToResult(){

        String appPrefix = '';
        string emailAddress = '';

        for(APTS_Overwatch_Apps__mdt metadataRecord : [SELECT APTS_App_Prefix__c, APTS_Notification_Email_Address__c FROM APTS_Overwatch_Apps__mdt]){

            appPrefix = metadataRecord.APTS_App_Prefix__c;
            emailAddress = metadataRecord.APTS_Notification_Email_Address__c;

            APTS_Overwatch_App overwatchResult = new APTS_Overwatch_App(appPrefix, emailAddress);
            this.appPrefixToResult.put(appPrefix, overwatchResult);
        }
    }

    
    public List<ApexClass> getTestClasses(){

        String query = buildQuery();
        List<ApexClass> apexClassesToRun = Database.query(query);

        return apexClassesToRun;
    }

    public String buildQuery(){
        
        String query = 'SELECT ID FROM ApexClass WHERE Name LIKE \'%test%\' AND';
        String queryDynamicCondition = ''; 

        Boolean firstPass = true; 
        Set<String> appPrefixes = this.appPrefixToResult.keySet();
        
        // to create: "SELECT ID FROM ApexClass WHERE Name Like %test% AND (Name LIKE APTS_% OR Name LIKE ASR_%)"
        for(String appPrefix : appPrefixes){
            queryDynamicCondition = 'Name LIKE \'' + appPrefix + '%\''; 
            if(firstPass){
                query = query + ' (' + queryDynamicCondition;
            } 
            else {
                query = query + ' OR ' + queryDynamicCondition;
            }
            firstPass = false;
        }
        query += ' )';
        System.debug(query);
        return query;
    }

   private void enqueueTests(List<ApexClass> testClasses) {
       
        List<ApexTestQueueItem> queueItems = new List<ApexTestQueueItem>();

        for (ApexClass cls : testClasses) {
            queueItems.add(new ApexTestQueueItem(ApexClassId = cls.Id));
        }

        Database.insert(queueItems, false); 

        Id parentJobId = [select parentJobId from ApexTestQueueItem where id =: queueitems[0].Id].parentJobId;

        this.apexTestQueueItemId = parentJobId;
    }

   private void scheduleNextJob(){

        String numberOfHoursLater = System.Label.APTS_Overwatch_Offset_Hours;

        //Schedule for today at Midnight + value from custom metadata
        String month = String.valueOf(Datetime.now().month());
        String day = String.valueOf(Datetime.now().day());
        String year = String.valueOf(Datetime.now().year());
        String nextFireTime = '0 0 ' + numberOfHoursLater + ' ' + day + ' ' +  month + ' ? ' +  year; 
//        String nextFireTime = '0 15 13 18 11 ? 2020';// + numberOfHoursLater + ' ' + day + ' ' +  month + ' ? ' +  year; 

       APTS_Overwatch_Evaluation_Scheduled overwatchEvaluationScheduled = new APTS_Overwatch_Evaluation_Scheduled(this.apexTestQueueItemId, this.appPrefixToResult);

       String jobName = 'APTS_Overwatch_Evaluation_for_' + Date.today();

       System.schedule(jobName, nextFireTime, overwatchEvaluationScheduled);
   }

}
//----------------------
//@isTest
public class APTS_Overwatch_Enqueue_Test {

    @isTest
    private static void setOverwatchMapping_Test(){
        APTS_Overwatch_Enqueue_Scheduled enqueueOverwatch = new APTS_Overwatch_Enqueue_Scheduled();
        enqueueOverwatch.setAppPrefixToResult();

        Map<String, APTS_Overwatch_App> appPrefixToResult = enqueueOverwatch.appPrefixToResult;
        Integer mapSize = appPrefixToResult.size();

        System.assertNotEquals(0, mapSize, 'The map should not be empty.');
    }
    
    @isTest 
    private static void getTestClasses_Test(){
        APTS_Overwatch_Enqueue_Scheduled enqueueOverwatch = new APTS_Overwatch_Enqueue_Scheduled();
        Boolean exceptionOccured = false;

        enqueueOverwatch.setAppPrefixToResult();
        
        try{
            enqueueOverwatch.getTestClasses(); 
        }
        catch(Exception e){
            String v = '';
            v += ' ' + e.getCause();
            v += ' ' + e.getLineNumber();
            v += ' ' + e.getMessage();
            v += ' ' + e.getStackTraceString();
            System.debug(v);
            exceptionOccured = true;
        }

        System.assert(!exceptionOccured);
    }


    @isTest 
    private static void scheduleJob_Test(){
        
        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute()); 
        String ss = String.valueOf(Datetime.now().second());
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';

        APTS_Overwatch_Enqueue_Scheduled overwatchEnqueueScheduled = new APTS_Overwatch_Enqueue_Scheduled();

        String jobName = 'APTS_Overwatch_Enqueue_Scheduled_' + Date.today();

        Integer numberOfJobsBefore = [SELECT COUNT() FROM AsyncApexJob];
        System.assertEquals(0, numberOfJobsBefore, 'There should be no Async Jobs');
       
        Test.startTest();
            String jobId = System.schedule(jobName, nextFireTime, overwatchEnqueueScheduled);
            Integer invocations = Limits.getEmailInvocations();
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();

        
        System.assertEquals(nextFireTime, ct.CronExpression, 'Cron Trigger should match.'); 

        Integer numberOfJobsAfter = [SELECT COUNT() FROM AsyncApexJob where JobType = 'ScheduledApex'];
        System.assertEquals(1, numberOfJobsAfter, 'There should be one scheduled job');
    }
}
//-------------------
//public class APTS_Overwatch_Evaluation_Scheduled implements Schedulable{

    public class APTS_Overwatch_Admin_Exception extends Exception {}

    private Id enqueueJobId;
    private Map<String, APTS_Overwatch_App> appPrefixToResult;
    private List<String> adminErrorLog;
    private final String PASS = 'PASS';
    private final String FAIL = 'FAIL';

    public APTS_Overwatch_Evaluation_Scheduled(Id jobId, Map<String, APTS_Overwatch_App> appPrefixToResult) {
        
        this.appPrefixToResult = appPrefixToResult;
        this.adminErrorLog = new List<String>();
        this.enqueueJobId = jobId;
        
        Messaging.reserveSingleEmailCapacity(1);
    }


    public void execute(SchedulableContext sc) {  
        try{
            List<ApexTestResult> allTestResults = getAllTestResults();
            logResults(allTestResults);
            sendTestResultEmail();
        }
        catch(APTS_Overwatch_Admin_Exception e){
            System.debug('do stuff for the admin' + e);
        }
        catch(Exception e){
            System.debug('do stuff' + e);
        } 
    }

    @TestVisible
    private List<ApexTestResult> getAllTestResults(){

        List<ApexTestResult> testResults = [SELECT Outcome, ApexClass.Name, MethodName, Message, StackTrace, RunTime 
                                            FROM ApexTestResult 
                                            WHERE AsyncApexJobId =: this.enqueueJobId ];
        if(testResults.isEmpty()){
            throw new APTS_Overwatch_Admin_Exception('APTS_Overwatch_Exception. No ApexTestResult found for this job id: ' + this.enqueueJobId);
        }

        return testResults;
    }

    private void logResults(List<ApexTestResult> allResults){

        for(ApexTestResult result : allResults){

            String appPrefix = getAppPrefixFromClassName(result); 
            APTS_Overwatch_App overwatchResult = appPrefixToResult.get(appPrefix);

            if(overwatchResult == null){
                this.adminErrorLog.add('Error. App Prefix: ' + appPrefix + ' does not exist in mapping.');
                continue; 
            }
            if(result.outcome.equalsIgnoreCase(PASS)){
                overwatchResult.addPassedTestResult(result);
            }
            else if(result.outcome.equalsIgnoreCase(FAIL)){
                overwatchResult.addFailedTestResult(result);
            }
        }
    }
    @TestVisible
    private String getAppPrefixFromClassName(ApexTestResult result){

        String className = result.ApexClass.Name;
        
        Integer indexOfAppPrefix = className.indexOf('_');
        String appPrefix = className.substring(0, indexOfAppPrefix);

        return appPrefix;
    }

    @TestVisible
    private void sendTestResultEmail(){

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        List<APTS_Overwatch_App> overwatchApps = this.appPrefixToResult.values(); 

        for(APTS_Overwatch_App app : overwatchApps){
            Messaging.SingleEmailMessage email = buildSingleEmail(app);
            emails.add(email);
        }

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails);

    }

    @TestVisible
    private Messaging.SingleEmailMessage buildSingleEmail(APTS_Overwatch_App app){

        String appPrefix = app.appPrefix; 
        final String emailSubject = appPrefix + ' Overwatch Test Results: ' + System.today();

        List<String> emailAddress = new List<String> { app.emailAddress }; 
        String emailBody = app.getHTMLBody();
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(emailAddress);
        email.setSubject(emailSubject);
        email.setHtmlBody(emailBody);
        
        return email;
    }
}
//--------------
//@isTest
public class APTS_Overwatch_Evaluation_Test {


    private static void sendEmail_Test(){

        Map<String, APTS_Overwatch_App> overwatchMap = new Map<String, APTS_Overwatch_App>();
        overwatchMap.put('APTS', new APTS_Overwatch_App('APTS', 'saman.attar@usaa.com'));
        String parentJobId = '7076C000016p6uuQAx'; 
        APTS_Overwatch_Evaluation_Scheduled evaluationScheduled = new APTS_Overwatch_Evaluation_Scheduled(parentJobId, overwatchMap);

        test.startTest();
        evaluationScheduled.sendTestResultEmail();
        Integer invocations = Limits.getEmailInvocations();
        test.stopTest();

        System.assertNotEquals(0, invocations, 'Emails should be sent');
    }

    @isTest
    private static void getAppPrefix_Test(){
        Map<String, APTS_Overwatch_App> overwatchMap = new Map<String, APTS_Overwatch_App>();
        overwatchMap.put('APTS', new APTS_Overwatch_App('APTS', 'saman.attar@usaa.com'));
        String parentJobId = '7076C000016p6uuQAx'; 
        ApexTestResult a = [select id, ApexClass.name from ApexTestResult limit 1]; 
        APTS_Overwatch_Evaluation_Scheduled evaluationScheduled = new APTS_Overwatch_Evaluation_Scheduled(parentJobId, overwatchMap);

        String prefix = evaluationScheduled.getAppPrefixFromClassName(a);
        System.assertEquals('APTS', prefix, 'Prefix not returned properly.');

    }

    @isTest
    private static void getAllTestResults_Test(){
        
        

        Map<String, APTS_Overwatch_App> overwatchMap = new Map<String, APTS_Overwatch_App>();
        overwatchMap.put('APTS', new APTS_Overwatch_App('APTS', 'saman.attar@usaa.com'));

        String parentJobId = '7076C000016p6uuQAx'; //this doesnt have to be real, relax

        Boolean exceptionCaught = false; 
        APTS_Overwatch_Evaluation_Scheduled evaluationScheduled = new APTS_Overwatch_Evaluation_Scheduled(parentJobId, overwatchMap);
        List<ApexTestResult> testResults = new List<ApexTestResult>();
        try{
            testResults = evaluationScheduled.getAllTestResults();
        }
        catch(APTS_Overwatch_Evaluation_Scheduled.APTS_Overwatch_Admin_Exception e){
                exceptionCaught = true;
        }

        System.assert(testResults.isEmpty());
        System.assert(exceptionCaught);
        
        
    }

    @isTest 
    private static void logResults_Test(){

        ApexClass singleClass = [SELECT Id from ApexClass where name like '%test%' and name like 'APTS%' Limit 1];


        String parentJobId = '7076C000016p6uuQAx'; //this doesnt have to be real, relax

        Map<String, APTS_Overwatch_App> overwatchMap = new Map<String, APTS_Overwatch_App>();
        overwatchMap.put('APTS', new APTS_Overwatch_App('APTS', 'saman.attar@usaa.com'));

        APTS_Overwatch_Evaluation_Scheduled evaluationScheduled = new APTS_Overwatch_Evaluation_Scheduled(parentJobId, overwatchMap);

        String hour = String.valueOf(Datetime.now().hour());
        String min = String.valueOf(Datetime.now().minute()); 
        String ss = String.valueOf(Datetime.now().second());
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';


        String jobName = 'APTS_Overwatch_Evaluation_Scheduled_' + Date.today();

        Test.startTest();
            String jobId = System.schedule(jobName, nextFireTime, evaluationScheduled);
        Test.stopTest();
    }

    @isTest 
    private static void exception_Test(){

        APTS_Overwatch_Exception overwatchExc = new APTS_Overwatch_Exception();

        Map<String, APTS_Overwatch_App> overwatchMap = new Map<String, APTS_Overwatch_App>();
        overwatchMap.put('APTS', new APTS_Overwatch_App('APTS', 'saman.attar@usaa.com'));
        String parentJobId = '7076C000016p6uuQAx'; //this doesnt have to be real, relax
        APTS_Overwatch_Evaluation_Scheduled evaluationScheduled = new APTS_Overwatch_Evaluation_Scheduled(parentJobId, overwatchMap);

        Boolean exceptionOccured = false;

        Test.startTest();
        try{
            evaluationScheduled.getAllTestResults();
        }
        catch(EXception e){
            exceptionOccured = true;
        }
        
        Test.stopTest();


        System.assert(exceptionOccured);
    }
    
   
}
//-----------------------------
//public class APTS_Overwatch_Exception extends Exception {}

//--------------------
//public class APTS_Overwatch_Result {

    private String appPrefix;
    private String emailAddress; 
    private List<ApexTestResult> failedTests;

    public APTS_Overwatch_Result(String appPrefix, String emailAddress) {
        this.appPrefix = appPrefix;
        this.emailAddress = emailAddress;
    }

    public void addFailedTestResult(ApexTestResult failedResult){
        if(failedResult.outcome == 'Failed'){
            this.failedTests.add(failedResult);
        }
    }
}*/
}