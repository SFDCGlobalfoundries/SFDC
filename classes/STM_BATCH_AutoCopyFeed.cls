/*
    Company:        Cognizant Technology Solution
    Description:    This batch class will Copy Reports for those Report Profiles which have Auto Copy enabled. 
                    System will create a copy based on the previous month report.
    History:
        NJain    11/06/2014    Class Creation
        
*/

public class STM_BATCH_AutoCopyFeed implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name, CreatedDate, Frequency__c, '+
                                          ' (SELECT id,CreatedDate ' +
                                          '  FROM STM_Tasks__r ' +
                                          '  WHERE Cancelled__c = False ' +
                                          '  ORDER BY CreatedDate desc LIMIT 1) ' +
                                         ' FROM ReportProjectProfile__c WHERE AutoCopy__c = True ');
    }
    
    public STM_BATCH_AutoCopyFeed(){
    }
    
    public void execute(Database.BatchableContext BC, List<ReportProjectProfile__c> lstProfilewithAutoCopy) {
        
        List<STMTask__c> finalAutoCopyTasks = new List<STMTask__c>();
        Set<Id>   lstTasksToClone = new Set<Id>();
        List<String> lstNewTaskIds = new List<String>();
        
        Datetime newCreationDate;
        
        if(lstProfilewithAutoCopy != NULL && !lstProfilewithAutoCopy.isEmpty()){
                        
            for(ReportProjectProfile__c reportProfile: lstProfilewithAutoCopy){
                if(!reportProfile.STM_Tasks__r.isEmpty()){
                    if(reportProfile.Frequency__c == 'Weekly'){
                        newCreationDate =  reportProfile.STM_Tasks__r[0].CreatedDate.addDays(7);
                    }
                    else if(reportProfile.Frequency__c == 'Monthly'){
                        //newCreationDate =  reportProfile.STM_Tasks__r[0].CreatedDate.addMonths(1);
                        newCreationDate =  Date.valueOf(reportProfile.STM_Tasks__r[0].CreatedDate.addMonths(1)).toStartOfMonth();
                    }
                    else if(reportProfile.Frequency__c == 'Quarterly'){
                        //newCreationDate =  reportProfile.STM_Tasks__r[0].CreatedDate.addMonths(3);
                        Date checkDate = Date.valueOf(reportProfile.STM_Tasks__r[0].CreatedDate);
                        Date todayDate= checkDate.toStartOfMonth();
                        Integer currentQtr = Decimal.valueOf(todayDate.month()).divide(3.0, 0, System.RoundingMode.UP).intValue();           
                        Date startOfYear = date.newInstance(checkDate.year(), 1, 1);
                        if(currentQtr == 1) {
                            newCreationDate = startOfYear.addMonths(3);
                        } else if(currentQtr == 2) {
                            newCreationDate = startOfYear.addMonths(6);
                        } else if(currentQtr == 3) {
                            newCreationDate = startOfYear.addMonths(9);
                        } else if(currentQtr == 4) {
                            newCreationDate = startOfYear.addMonths(12);
                        }
                    }
                    else if(reportProfile.Frequency__c == 'Semi-Annually'){
                        //newCreationDate =  reportProfile.STM_Tasks__r[0].CreatedDate.addMonths(6);
                        if(reportProfile.STM_Tasks__r[0].CreatedDate.Month() <=6){
                            newCreationDate  = Date.newInstance(Date.valueOf(reportProfile.STM_Tasks__r[0].CreatedDate).year(),7,1);
                        }else{
                            newCreationDate  = Date.newInstance(Date.valueOf(reportProfile.STM_Tasks__r[0].CreatedDate).year()+1,1,1);
                        }
                    }
                    else if(reportProfile.Frequency__c == 'Yearly'){
                        //newCreationDate =  reportProfile.STM_Tasks__r[0].CreatedDate.addMonths(12);
                        newCreationDate = Date.newInstance(Date.valueOf(reportProfile.STM_Tasks__r[0].CreatedDate).year()+1, 1, 1);
                    }
                    else{
                        newCreationDate = System.Today()+10; //These Profiles will never be Auto Copied.
                    }
                    system.debug('Start Date: '+newCreationDate );
                    
                    //Adding the tasks to be cloned
                    if(  Test.isRunningTest() || 
                        (!Test.isRunningTest() && newCreationDate == System.Today() && reportProfile.STM_Tasks__r[0] !=NULL)
                    ){
                        STMTask__c autoTask = new STMTask__c();
                        STMTaskChild__c  autoTaskChild = new STMTaskChild__c();
                        lstTasksToClone.add(reportProfile.STM_Tasks__r[0].Id);
                    }
                }
            }            
            //lstTasksToClone.add('aA3N00000008OZ1'); //For Testing
            system.debug('###lstTasksToClone###'+lstTasksToClone);
            
            try{
                //Cloning the tasks
                for(Id tasktoClone: lstTasksToClone){
                    STM_Clone cc=new STM_Clone();
                    string parentObjAPIName=cc.returnAPIObjectName(tasktoClone);
                    Map<string,string> objLabelobjAPI=cc.getAllChildObjNames(parentObjAPIName,tasktoClone); 
                    string clondedParentRecordID=cc.startsClone(tasktoClone, objLabelobjAPI.values());
                    lstNewTaskIds.add(clondedParentRecordID);
                }
                
                //Updating the new Task Name with the Latest Week Number/Month Number as per the Report Profile
                finalAutoCopyTasks.clear();
                String currentWeek = DateTime.newInstanceGmt(
                                        Date.newInstance(System.today().Year(), System.today().Month(),System.today().Day()
                                                         ).toStartOfWeek(), Time.NewInstance(12,0,0,0)
                                     ).format('w');
                String currentMonthNo = '';
                if(System.today().Month() <= 9){
                    currentMonthNo = '0'+ string.valueOf(System.today().Month());
                }else{
                    currentMonthNo = string.valueOf(System.today().Month());
                }
                
                List<String> lstPatterns = new List<String>();
                for(STM_FilePattern__c fPatt: [SELECT id, Name, Destination_Folder__c FROM STM_FilePattern__c]){
                    lstPatterns.add(fPatt.Name.toUpperCase());
                }
                
                for(STMTask__c stmTask: [SELECT Id,Name,ReportCategory__c,Report_Due_Date__c,Frequency__c,Report_Project_Profile__r.name
                                            FROM STMTask__c WHERE Id IN :lstNewTaskIds]){
                    system.debug('####Task Name #####' +stmTask.Name);
                    //Updating the name of the Task
                    string tempMatch='';
                    boolean taskMatchFound = false;
                    for(String str: lstPatterns){
                        Pattern profilePattern  = Pattern.Compile(str.replace('(','\\(').replace(')','\\)').replace('$','\\$').toUpperCase());
                        Matcher m1= profilePattern.matcher(stmTask.Name.toUpperCase());
                        
                        while (m1.find()){
                            if(m1.group(0) != NULL && m1.group(0) != ''){
                                system.debug('####m1#####'+m1.group(0));
                                if(tempMatch.length() < m1.group(0).length()){
                                    tempMatch = m1.group(0);
                                    taskMatchFound = True;
                                }
                                break;
                            }
                        }
                    }
                    if(taskMatchFound){
                        if(stmTask.Frequency__c == 'Monthly' || stmTask.Frequency__c == 'Yearly' || stmTask.Frequency__c == 'Quarterly' || stmTask.Frequency__c == 'Semi-Annually'){
                            stmTask.Name = tempMatch + '_' + System.TODAY().YEAR() + '-' + currentMonthNo;
                        }else{
                            stmTask.Name = tempMatch +'_W' + currentWeek;
                        }
                    }
                    system.debug('###DEBUG stmTask.Name###'+stmTask.Name);
                     
                    //Updating the Report Due-Date
                    if(stmTask.Frequency__c.equalsIgnoreCase('Weekly')){
                       stmTask.Report_Due_Date__c =  System.TODAY().addDays(7);
                    }
                    else if(stmTask.Frequency__c.equalsIgnoreCase('Monthly')){
                       stmTask.Report_Due_Date__c =  System.TODAY().addMonths(1);
                    }
                    else if(stmTask.Frequency__c.equalsIgnoreCase('Quarterly')){
                       stmTask.Report_Due_Date__c =  System.TODAY().addMonths(3);
                    }
                    else if(stmTask.Frequency__c.equalsIgnoreCase('Semi-Annually')){
                       stmTask.Report_Due_Date__c =  System.TODAY().addMonths(6);
                    }
                    else if(stmTask.Frequency__c.equalsIgnoreCase('Yearly')){
                       stmTask.Report_Due_Date__c =  System.TODAY().addMonths(12);
                    }else{
                        stmTask.Report_Due_Date__c = NULL;
                    }
                    
                    finalAutoCopyTasks.add(stmTask);
                }
                update(finalAutoCopyTasks);
                lstNewTaskIds.clear();
                lstTasksToClone.clear();
                
            }
            catch(Exception e){
                system.debug('#########Exception###### '+e.getMessage());
            }
            
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        system.debug('Auto Copy STM Task Batch Job Completed.');
    }
    
}