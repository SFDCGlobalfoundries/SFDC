/*
     Author: Devendra
    Description: 
    History: 
        Devendra      April2017    - Code creation.
        Anushri      May2017    - Code modification.
*/

public with sharing class OPP_GenerateDemandGenCtrl
{
    public List<opportunity> oppList{get;set;}
    public Map<id,List<Device_Gap__c>> oppDGMap{get;set;}
    public string xmlheader {get;set;}
    public string endfile{get;set;}
    
    public OPP_GenerateDemandGenCtrl() 
    {   
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        endfile = '</Workbook>';
                
        string ids=ApexPages.currentPage().getParameters().get('idList');
        List<string> idList=ids.split(',');
       oppList=[select id,Account.Name,Name,Demand_Factor__c,X2016_C__c,X2016_P__c,X2016_A_M__c,Target_Process_Node__c,Probability,Process_Geometry__c,Prob_P__c,LTR_Rev_M__c,
                                   X2017_C__c,X2017_P__c,X2017_A_M__c,Owner.Name,Probability_P__c,X2018_C__c,X2018_P__c,X2018_A_M__c,StageName,Worst_Issue_Status__c,
                                   X1st_Product_Production_Date__c,X2019_C__c,X2019_P__c,X2019_A_M__c,CloseDate,LT_Wafers_kwfr__c,X2020_C__c,Worst_Issue_Status_P__c,
                                   X2020_P__c,X2020_A_M__c,X1st_Product_TO_Date__c,In_Base_Forecast1__c,X2021_C__c,X2021_P__c,X2021_A_M__c,
                                   X2022_C__c,X2022_P__c,X2022_A_M__c,X2023_C__c,X2023_P__c,X2023_A_M__c,X2024_C__c,X2024_P__c,X2024_A_M__c,
                                   X2025_C__c,X2025_P__c,X2025_A_M__c from opportunity where id in:idList];
        
        List<Device_Gap__c> oppIssueList=getOppIssues(idList);
        oppDGMap=new Map<id,List<Device_Gap__c>>();
        for(opportunity opp:oppList){
            opp.Description__c = opp.Target_Process_Node__c;
            //to avoid null error im
            if(opp.Worst_Issue_Status__c != null && opp.Worst_Issue_Status__c.contains('G -')){
                opp.Worst_Issue_Status__c = 'StatusGreenColor';
            } else if(opp.Worst_Issue_Status__c != null && opp.Worst_Issue_Status__c.contains('Y -')){
                opp.Worst_Issue_Status__c = 'StatusYellowColor';                
            } else if(opp.Worst_Issue_Status__c != null && opp.Worst_Issue_Status__c.contains('R1 -')){
                opp.Worst_Issue_Status__c = 'StatusRed1Color';            
            } else if(opp.Worst_Issue_Status__c != null && opp.Worst_Issue_Status__c.contains('R2 -')){
                opp.Worst_Issue_Status__c = 'StatusRed2Color';            
            } else if(opp.Worst_Issue_Status__c != null && opp.Worst_Issue_Status__c.contains('R3 -')){
                opp.Worst_Issue_Status__c = 'StatusRed3Color';            
            } else if(opp.Worst_Issue_Status__c != null && opp.Worst_Issue_Status__c.contains('B -')){
                opp.Worst_Issue_Status__c = 'StatusBlueColor';            
            } else {
                opp.Worst_Issue_Status__c = 's16WithoutColorLeft';        
            }

            if(opp.Worst_Issue_Status_P__c != null && opp.Worst_Issue_Status_P__c.contains('G -')){
                opp.Worst_Issue_Status_P__c = 'StatusGreenColor';
            } else if(opp.Worst_Issue_Status_P__c != null && opp.Worst_Issue_Status_P__c.contains('Y -')){
                opp.Worst_Issue_Status_P__c = 'StatusYellowColor';                
            } else if(opp.Worst_Issue_Status_P__c != null && opp.Worst_Issue_Status_P__c.contains('R1 -')){
                opp.Worst_Issue_Status_P__c = 'StatusRed1Color';            
            } else if(opp.Worst_Issue_Status_P__c != null && opp.Worst_Issue_Status_P__c.contains('R2 -')){
                opp.Worst_Issue_Status_P__c = 'StatusRed2Color';            
            } else if(opp.Worst_Issue_Status_P__c != null && opp.Worst_Issue_Status_P__c.contains('R3 -')){
                opp.Worst_Issue_Status_P__c = 'StatusRed3Color';            
            } else if(opp.Worst_Issue_Status_P__c != null && opp.Worst_Issue_Status_P__c.contains('B -')){
                opp.Worst_Issue_Status_P__c = 'StatusBlueColor';            
            } else {
                opp.Worst_Issue_Status_P__c = 's16WithoutColorLeft';        
            }
            oppDGMap.put(opp.id,new List<Device_Gap__c>());
        }
        for(Device_Gap__c dg:oppIssueList){
            if(dg.Status_BgColor__c != null && dg.Status_BgColor__c.contains('green')){
                dg.Select_Status__c = 'StatusGreenColor';
            } else if(dg.Status_BgColor__c != null && dg.Status_BgColor__c.contains('yellow')){
                dg.Select_Status__c = 'StatusYellowColor';                
            } else if(dg.Status_BgColor__c != null && dg.Status_BgColor__c.contains('red')){
                dg.Select_Status__c = 'StatusRedColor';            
            } else if(dg.Status_BgColor__c != null && dg.Status_BgColor__c.contains('blue')){
                dg.Select_Status__c = 'StatusBlueColor';            
            } else {
                dg.Select_Status__c = 's16WithoutColorLeft';        
            }

            if(dg.Status_P_BgColor__c != null && dg.Status_P_BgColor__c.contains('green')){
                dg.Previous_Status__c = 'StatusGreenColor';
            } else if(dg.Status_P_BgColor__c != null && dg.Status_P_BgColor__c.contains('yellow')){
                dg.Previous_Status__c = 'StatusYellowColor';                
            } else if(dg.Status_P_BgColor__c != null && dg.Status_P_BgColor__c.contains('red')){
                dg.Previous_Status__c = 'StatusRedColor';            
            } else if(dg.Status_P_BgColor__c != null && dg.Status_P_BgColor__c.contains('blue')){
                dg.Previous_Status__c = 'StatusBlueColor';            
            } else{
                dg.Previous_Status__c = 's16WithoutColorLeft';     
            }
            
            if(oppDGMap.get(dg.Opportunity__c)!=null)oppDGMap.get(dg.Opportunity__c).add(dg);
            else oppDGMap.put(dg.Opportunity__c,new List<Device_Gap__c>{dg});
        }
    }
    
  

    // Intialize and return Opportunity Issues
    public List<Device_Gap__c> getOppIssues(List<string> oppIdSet) {
        List<Device_Gap__c> oppIssueList=[SELECT ID, Name, Area__c, Opportunity__c,Issue_Comments__c, Status_P_BgColor__c, Status_P__c, 
                     Status_BgColor__c, Status__c, Improve_Prob_P__c, Improve_Prob__c, Action_to_Close_Issue__c,Previous_Status__c,Select_Status__c,
                     Solution_Owner__r.Name, Action_Close_Date_P__c, Action_Close_Date__c FROM Device_Gap__c 
                     where Stage__c  !='Void' and Opportunity__c IN:oppIdSet];
        
        return oppIssueList;
    }
    
    
}