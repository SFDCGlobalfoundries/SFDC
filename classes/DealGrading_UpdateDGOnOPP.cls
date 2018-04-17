/*
Type Name: DealGrading_UpdateDGOnOPP
Author : Vijay Vemuru
Description: This Handler class method - updateOPP reflects the fields values of a Deal Grading record on its corresponding Opportunity record 
Test Class: DealGrading_UpdateDGOnOPPTest
History:  6/19/2016   code creation
*/          
public class DealGrading_UpdateDGOnOPP {

    public static void updateOPP(List<Deal_Grading__c> Deal_Grading) {
        List<Opportunity> oppList=new List<Opportunity>();
        for(Deal_Grading__c dg: Deal_Grading){
            Opportunity opp = new opportunity (id=dg.Opportunity1__c);
            opp.DG_create_Date__c = dg.CreatedDate;
            opp.DG_Graded_Date__c = dg.Graded_Date__c;
            //oppList.add(opp);
            if(dg.Result__c!=null && dg.Deal_Grading_Status__c!=null){            
                opp.Deal_Grading_Result__c  =   dg.Result__c; 
                opp.Deal_Grading_Status__c  =   dg.Deal_Grading_Status__c;
                //oppList.add(opp);
            } 
            oppList.add(opp);        
        }       
        try{
            update oppList; 
            
        }catch(Exception excp) { GlobalUtility.logMessage('Error','DealGrading_UpdateDGOnOPP','updateOPP',oppList[0].id,'Exception while Updating the Opportunity records',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);}                         
    }    
}