/*
    Company:     Cognizant Technology Solution
    Description: This Trigger will create a 'STM File Pattern' record as the 'Report File Name' 
                 whenever a new Report Profile is created.
    History:
        NJain    11/06/2014    Trigger Creation
        
*/
trigger STM_TRIGGER_ReportProjectProfile on ReportProjectProfile__c (after Insert) {
   
    if(System.Label.STM_TRIGGER_ReportProjectProfile_Enable.equalsIgnoreCase('True')){
        if(Trigger.isAfter && Trigger.isInsert){
            List<STM_FilePattern__c> lstFilePatterns = new List<STM_FilePattern__c>();
            
            for(ReportProjectProfile__c projProfile: Trigger.New){
                if(projProfile.Report_File_Name__c != NULL && projProfile.Report_File_Name__c != ''){
                    STM_FilePattern__c filePattern = new STM_FilePattern__c();
                    filePattern.Name = projProfile.Report_File_Name__c;
                    filePattern.Destination_Folder__c = '';
                    filePattern.ReportProjectProfile__c = projProfile.Id;
                    lstFilePatterns.add(filePattern);
                }
            }
            if(lstFilePatterns != NULL && !lstFilePatterns .isEmpty()){
                Database.Insert(lstFilePatterns);
            }
        }
    }
    
}