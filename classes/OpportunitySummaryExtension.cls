// Extension to retreive Opportunity Issues 

public with sharing class OpportunitySummaryExtension
{
    @TestVisible private final Opportunity opp;
    
    public Opportunity oppty{get; set;}
    public string xmlheader {get;set;}
    public string endfile{get;set;}
   // Code added by Sunil arora for case # 52815 on 15/03/2016
    // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
    
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    getOppIssues();
  }
    
    
    // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'Engmt_Step__c'; } return sortField;  }
    set;
  }
    
    
    //sunil's code ends here
 
    public String AcctName{get;set;}  
    
    public OpportunityWrapper            oppWrapper          {get;set;} 
    public List<OpportunityWrapper>      oppWrapperList      {get;set;} 
    public List<OpportunityIssueWrapper> oppIssueWrapperList {get;set;} 
    public List<Opportunity>             oppList             {get;set;} 
    public String                        optyHealth          {get;set;} 
    public String                        designWinRevenue    {get;set;} 
   
    // Initialization
    public OpportunitySummaryExtension(ApexPages.StandardController stdController) 
    {   
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        endfile = '</Workbook>';
        this.opp = (Opportunity)stdController.getRecord();
        Opportunity opp1=new Opportunity();
        oppty = [select id,Account.Name,Name,Demand_Factor__c,X2016_C__c,X2016_P__c,X2016_A_M__c,Target_Process_Node__c,Probability,Process_Geometry__c,Prob_P__c,LTR_Rev_M__c,
                                   X2017_C__c,X2017_P__c,X2017_A_M__c,Owner.Name,Probability_P__c,X2018_C__c,X2018_P__c,X2018_A_M__c,StageName,Worst_Issue_Status__c,
                                   X1st_Product_Production_Date__c,X2019_C__c,X2019_P__c,X2019_A_M__c,CloseDate,LT_Wafers_kwfr__c,X2020_C__c,Worst_Issue_Status_P__c,
                                   X2020_P__c,X2020_A_M__c,X1st_Product_TO_Date__c,In_Base_Forecast1__c,X2021_C__c,X2021_P__c,X2021_A_M__c,
                                   X2022_C__c,X2022_P__c,X2022_A_M__c,X2023_C__c,X2023_P__c,X2023_A_M__c,X2024_C__c,X2024_P__c,X2024_A_M__c,
                                   X2025_C__c,X2025_P__c,X2025_A_M__c, Opty_Health__c, Owner.Id, Design_Win_FAE__c, Design_Win_FAE__r.Id, Design_Win_FAE__r.Name, Design_Win_Region__c, Business_Unit__c, Product_Line__c, Market_Segment__c, End_Application_for_Opty__c, Semiconductor_Device__c, Fab_Assignment_1__c, Opportunity_Health__c, Design_Win_Revenue__c, Customer_Decision_Maker__c, Primary_Opportunity_FAE__c, Primary_Opportunity_FAE__r.Id, Primary_Opportunity_FAE__r.Name from Opportunity where id=:opp.id];
        AcctName= oppty.Account.Name;
        AcctName=AcctName.replaceAll(',', ' ');
        if(oppty.Worst_Issue_Status__c != null && oppty.Worst_Issue_Status__c.contains('G -')){
            oppty.Worst_Issue_Status__c = 'StatusGreenColor';
        } else if(oppty.Worst_Issue_Status__c != null && oppty.Worst_Issue_Status__c.contains('Y -')){
            oppty.Worst_Issue_Status__c = 'StatusYellowColor';                
        } else if(oppty.Worst_Issue_Status__c != null && oppty.Worst_Issue_Status__c.contains('R1 -')){
            oppty.Worst_Issue_Status__c = 'StatusRed1Color';            
        } else if(oppty.Worst_Issue_Status__c != null && oppty.Worst_Issue_Status__c.contains('R2 -')){
            oppty.Worst_Issue_Status__c = 'StatusRed2Color';            
        } else if(oppty.Worst_Issue_Status__c != null && oppty.Worst_Issue_Status__c.contains('R3 -')){
            oppty.Worst_Issue_Status__c = 'StatusRed3Color';            
        } else if(oppty.Worst_Issue_Status__c != null && oppty.Worst_Issue_Status__c.contains('B -')){
            oppty.Worst_Issue_Status__c = 'StatusBlueColor';            
        } else {
            oppty.Worst_Issue_Status__c = 's16WithoutColorLeft';        
        }

        if(oppty.Worst_Issue_Status_P__c != null && oppty.Worst_Issue_Status_P__c.contains('G -')){
            oppty.Worst_Issue_Status_P__c = 'StatusGreenColor';
        } else if(oppty.Worst_Issue_Status_P__c != null && oppty.Worst_Issue_Status_P__c.contains('Y -')){
            oppty.Worst_Issue_Status_P__c = 'StatusYellowColor';                
        } else if(oppty.Worst_Issue_Status_P__c != null && oppty.Worst_Issue_Status_P__c.contains('R1 -')){
            oppty.Worst_Issue_Status_P__c = 'StatusRed1Color';            
        } else if(oppty.Worst_Issue_Status_P__c != null && oppty.Worst_Issue_Status_P__c.contains('R2 -')){
            oppty.Worst_Issue_Status_P__c = 'StatusRed2Color';            
        } else if(oppty.Worst_Issue_Status_P__c != null && oppty.Worst_Issue_Status_P__c.contains('R3 -')){
            oppty.Worst_Issue_Status_P__c = 'StatusRed3Color';            
        } else if(oppty.Worst_Issue_Status_P__c != null && oppty.Worst_Issue_Status_P__c.contains('B -')){
            oppty.Worst_Issue_Status_P__c = 'StatusBlueColor';            
        } else {
            oppty.Worst_Issue_Status_P__c = 's16WithoutColorLeft';        
        }        
        system.debug('AcctName@@@'+AcctName);
        
        oppWrapper = new OpportunityWrapper(oppty);
        oppList = new List<Opportunity>{oppty};
        
        optyHealth = 's16WithoutColorCenter';
        if(oppty.Opportunity_Health__c != NULL && oppty.Opportunity_Health__c.contains('On Track')){
            optyHealth = 'Green';
        }
        else if(oppty.Opportunity_Health__c != NULL && oppty.Opportunity_Health__c.contains('Minor Obstacles')){
            optyHealth = 'Yellow';
        }
        else if(oppty.Opportunity_Health__c != NULL && oppty.Opportunity_Health__c.contains('Major Obstacles')){
            optyHealth = 'Red';
        }
        
        Decimal tempMillion = 0;
        if(oppty.Design_Win_Revenue__c != NULL){
            tempMillion = oppty.Design_Win_Revenue__c;
        }
        tempMillion = (tempMillion / 1000000);
        designWinRevenue = '$' + tempMillion.setScale(2) + 'M';
        
        List<Quarterly_Revenue_Object__c> quarterlyRevenueList = [SELECT Id, Fiscal_Quarter__c, Volume__c FROM Quarterly_Revenue_Object__c WHERE Opportunity__c = :opp.Id];
        for(Quarterly_Revenue_Object__c quarterlyRevenue : quarterlyRevenueList){
            if(quarterlyRevenue.Fiscal_Quarter__c != NULL 
             && quarterlyRevenue.Volume__c != NULL 
             && quarterlyRevenue.Fiscal_Quarter__c.contains('2018')){
                
                oppWrapper.kwafer_2018 += quarterlyRevenue.Volume__c;
            }
            else if(quarterlyRevenue.Fiscal_Quarter__c != NULL 
             && quarterlyRevenue.Volume__c != NULL 
             && quarterlyRevenue.Fiscal_Quarter__c.contains('2019')){
                
                oppWrapper.kwafer_2019 += quarterlyRevenue.Volume__c;
            }
            else if(quarterlyRevenue.Fiscal_Quarter__c != NULL 
             && quarterlyRevenue.Volume__c != NULL 
             && quarterlyRevenue.Fiscal_Quarter__c.contains('2020')){
                
                oppWrapper.kwafer_2020 += quarterlyRevenue.Volume__c;
            }
            else if(quarterlyRevenue.Fiscal_Quarter__c != NULL 
             && quarterlyRevenue.Volume__c != NULL 
             && quarterlyRevenue.Fiscal_Quarter__c.contains('2021')){
                
                oppWrapper.kwafer_2021 += quarterlyRevenue.Volume__c;
            }
            else if(quarterlyRevenue.Fiscal_Quarter__c != NULL 
             && quarterlyRevenue.Volume__c != NULL 
             && quarterlyRevenue.Fiscal_Quarter__c.contains('2022')){
                
                oppWrapper.kwafer_2022 += quarterlyRevenue.Volume__c;
            }
            else if(quarterlyRevenue.Fiscal_Quarter__c != NULL 
             && quarterlyRevenue.Volume__c != NULL 
             && quarterlyRevenue.Fiscal_Quarter__c.contains('2023')){
                
                oppWrapper.kwafer_2023 += quarterlyRevenue.Volume__c;
            }
            else if(quarterlyRevenue.Fiscal_Quarter__c != NULL 
             && quarterlyRevenue.Volume__c != NULL 
             && quarterlyRevenue.Fiscal_Quarter__c.contains('2024')){
                
                oppWrapper.kwafer_2024 += quarterlyRevenue.Volume__c;
            }
            else if(quarterlyRevenue.Fiscal_Quarter__c != NULL 
             && quarterlyRevenue.Volume__c != NULL 
             && quarterlyRevenue.Fiscal_Quarter__c.contains('2025')){
                
                oppWrapper.kwafer_2025 += quarterlyRevenue.Volume__c;
            }
        }
        
        oppWrapper.kwafer_2018 = (oppWrapper.kwafer_2018 / 1000).setScale(2);
        oppWrapper.kwafer_2019 = (oppWrapper.kwafer_2019 / 1000).setScale(2);
        oppWrapper.kwafer_2020 = (oppWrapper.kwafer_2020 / 1000).setScale(2);
        oppWrapper.kwafer_2021 = (oppWrapper.kwafer_2021 / 1000).setScale(2);
        oppWrapper.kwafer_2022 = (oppWrapper.kwafer_2022 / 1000).setScale(2);
        oppWrapper.kwafer_2023 = (oppWrapper.kwafer_2023 / 1000).setScale(2);
        oppWrapper.kwafer_2024 = (oppWrapper.kwafer_2024 / 1000).setScale(2);
        oppWrapper.kwafer_2025 = (oppWrapper.kwafer_2025 / 1000).setScale(2);
        
        oppWrapperList = new List<OpportunityWrapper>();
        oppWrapperList.add(oppWrapper);
    }
    
    //Code changed by Sunil arora for case # 52815 on 15/03/2016
    // Intialize and return Opportunity Issues
    public List<Device_Gap__c> getOppIssues() {
        List<Device_Gap__c> oppIssueList = new List<Device_Gap__c>();
        oppIssueWrapperList = new List<OpportunityIssueWrapper>(); 
        
        Id oppId=opp.Id;
        string soql='SELECT  ID, Name, Engmt_Step__c, Area__c, Opportunity__c,Issue_Comments__c, Status_P_BgColor__c, Status_P__c,'+ 
                     'Status_BgColor__c, Status__c, Improve_Prob_P__c, Improve_Prob__c, Action_to_Close_Issue__c,Previous_Status__c,Select_Status__c,'+
                     'Solution_Owner__r.Name, Action_Close_Date_P__c, Action_Close_Date__c FROM Device_Gap__c where Stage__c  !=\''+'Void'+'\' and Opportunity__c =\''+oppId+'\' AND Select_Status__c != \'B - Major Issue Closed\' ';
        if(sortField == 'Engmt_Step__c'){
            oppIssueList = Database.query(soql + ' ORDER BY Engmt_Step__c ' + sortDir + ', Action_Close_Date__c ASC, Status__c ASC');
        }
        else{
            oppIssueList = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' NULLS LAST');
        }
        
        OpportunityIssueWrapper tempOppWrapper;
        for(Device_Gap__c dg:oppIssueList){
            
            tempOppWrapper = new OpportunityIssueWrapper();
            tempOppWrapper.status = dg.Select_Status__c;
            tempOppWrapper.previousStatus = dg.Previous_Status__c;
            tempOppWrapper.deviceGap = dg;
            
            if(dg.Status_BgColor__c != null && dg.Status_BgColor__c.contains('green')){
                dg.Select_Status__c = 'StatusGreenColor';
            } else if(dg.Status_BgColor__c != null && dg.Status_BgColor__c.contains('yellow')){
                dg.Select_Status__c = 'StatusYellowColor';                
            } else if(dg.Status_BgColor__c != null && dg.Status_BgColor__c.contains('red')){
                dg.Select_Status__c = 'StatusRedColor';            
            } else if(dg.Status_BgColor__c != null && dg.Status_BgColor__c.contains('blue')){
                dg.Select_Status__c = 'StatusBlueColor';  
            } else if(dg.Status_BgColor__c != null && dg.Status_BgColor__c.contains('black')){
                 dg.Select_Status__c = 'StatusBlackColor'; 
            } else {
                dg.Select_Status__c = 's16WithoutColorHorizontalCenter';        
            }

            if(dg.Status_P_BgColor__c != null && dg.Status_P_BgColor__c.contains('green')){
                dg.Previous_Status__c = 'StatusGreenColor';
            } else if(dg.Status_P_BgColor__c != null && dg.Status_P_BgColor__c.contains('yellow')){
                dg.Previous_Status__c = 'StatusYellowColor';                
            } else if(dg.Status_P_BgColor__c != null && dg.Status_P_BgColor__c.contains('red')){
                dg.Previous_Status__c = 'StatusRedColor';            
            } else if(dg.Status_P_BgColor__c != null && dg.Status_P_BgColor__c.contains('blue')){
                dg.Previous_Status__c = 'StatusBlueColor';
            } else if(dg.Status_P_BgColor__c != null && dg.Status_P_BgColor__c.contains('black')){
                dg.Previous_Status__c = 'StatusBlackColor';             
            } else{
                dg.Previous_Status__c = 's16WithoutColorHorizontalCenter';     
            }  

            oppIssueWrapperList.add(tempOppWrapper);
        }
        return oppIssueList;
    }
    
    public PageReference exportToExcel() {
        
        PageReference excel = Page.OpportunitySummaryExport;
        excel.getParameters().put('id',opp.Id);
                 
        return excel;
    }
    
    public PageReference close() {
        PageReference pageRef = new PageReference('/' + opp.Id);
        return pageRef;
    }
    
    public class OpportunityWrapper{
    
        public Opportunity opp{get;set;}
        public String closeDate{get;set;}
        public String optyHealthImageSrc{get;set;}
        public Boolean isOptyHealthImageExist{get;set;}
        
        public Decimal kwafer_2018{get;set;}
        public Decimal kwafer_2019{get;set;}
        public Decimal kwafer_2020{get;set;}
        public Decimal kwafer_2021{get;set;}
        public Decimal kwafer_2022{get;set;}
        public Decimal kwafer_2023{get;set;}
        public Decimal kwafer_2024{get;set;}
        public Decimal kwafer_2025{get;set;}
        
        public OpportunityWrapper(Opportunity oppObj){
            
            isOptyHealthImageExist = FALSE;
            
            opp = oppObj;
            if(oppObj.CloseDate != NULL){
                closeDate = oppObj.CloseDate.format();
            }
            if(oppObj.Opty_Health__c != NULL){
                optyHealthImageSrc = oppObj.Opty_Health__c.substringAfter('src="').split('"')[0]; 
                isOptyHealthImageExist = TRUE;
            }
            
            kwafer_2018 = 0;
            kwafer_2019 = 0;
            kwafer_2020 = 0;
            kwafer_2021 = 0;
            kwafer_2022 = 0;
            kwafer_2023 = 0;
            kwafer_2024 = 0;
            kwafer_2025 = 0;
        }
    }
    
    public class OpportunityIssueWrapper{
        
        public Device_Gap__c deviceGap      {get;set;}
        public String        status         {get;set;}
        public String        previousStatus {get;set;}
    }
}