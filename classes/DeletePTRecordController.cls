/**********************************************************************************************************************************
Class:         DeletePTRecordController 
-----------------------------------------------------------------------------------------------------------------------------------
Author:        Amrita Agawala.
Description:    It will delete all PT records for the current CPQMLGPLUS
History:
***********************************************************************************************************************************/


public class DeletePTRecordController {
    private CPQ_MLGPLUS__c cpqMlgplus;
    public string pt_Number {get;set;} 
    public Id recordId ;
    
    public DeletePTRecordController(ApexPages.StandardController stdController){
        cpqMlgplus = (CPQ_MLGPLUS__c)stdController.getRecord();
        cpqMlgplus = [select id, Process_Technology__c from CPQ_MLGPLUS__c where id = :cpqMlgplus.id];
        
        recordID = ApexPages.CurrentPage().getparameters().get('id');
        pt_Number = cpqMlgplus.Process_Technology__c ;
        
        
    }
    
    public PageReference init(){
        
        CPQConfigDataClass.removeAll(pt_Number , TRUE);
        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.CONFIRM,'Process Technology '+pt_Number+' deletion successful.')); 
        
        return null;
        
    }
    
}