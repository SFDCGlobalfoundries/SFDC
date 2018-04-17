/*
Type Name: DisplayRevenueOnDG
Author: Vijay Vemuru

Description: This class is used for displaying aggregate results like year, Sum NRE, ASP, Sum Volume, Sum on the Visualforce page 'Deal Grading Populate VF' which is then displayed on the Deal Grading record section 'Current Opportunity Revenue' 
This Primarily supports the Deal Grading VF page
History:  4/20/2016  code creation
*/            
public class  DealGrading_DisplayRevenueOnDG  {

    //Get the current DG record id
    
    Id recid=ApexPages.CurrentPage().getparameters().get('id');
    id OppId;
    public map<string,revenueDetails> revenueMap{get;set;}
    public list<revenueDetails> revenueDetails{get;set;}
    public DealGrading_DisplayRevenueOnDG(ApexPages.StandardController con) { 
        OppId           =   ((Deal_Grading__c)con.getRecord()).Opportunity1__c;
        revenueMap      =   new map<string,revenueDetails>();
        revenueDetails  =   new list<revenueDetails>();
    }
   
    public list<revenueDetails>  getcalSum() 
    
    {   
        try{
            for(Quarterly_Revenue_Object__c qrev : [SELECT Fiscal_Quarter__c, Current_Year__c, NRE__c,ASP__c,Volume__c, Revenue__c,opportunity__c 
                                                        FROM Quarterly_Revenue_Object__c WHERE Opportunity__r.id=:OppId ORDER BY Fiscal_Quarter__c ASC]){
                string fisYear          =   qrev.Fiscal_Quarter__c.substring(0,4);
                integer currentyear     =   integer.valueOf(fisYear);
                revenueDetails revenue  =   new revenueDetails();
                if(revenueMap.containsKey(fisYear) && revenueMap.get(fisYear) !=null) {
                    revenue             =   revenueMap.get(fisYear);
                    revenue.year        =   (currentyear >revenue.year)? (currentyear):revenue.year;
                    revenue.NRE         =   revenue.NRE+(qrev.NRE__c != null ? qrev.NRE__c:0);
                    revenue.volume      =   revenue.volume+(qrev.Volume__c != null ? qrev.Volume__c:0);
                    revenue.totalRev    =   revenue.totalRev + (qrev.Revenue__c != null ? qrev.Revenue__c:0);
                    Decimal totalAsp    =   (revenue.asp * revenue.recCount)+ (qrev.asp__c != null ?  qrev.asp__c :0);
                    revenue.recCount    =   revenue.recCount+1;
                    revenue.asp         =   (totalAsp/revenue.recCount); 
                    
                } else {
                
                    revenue.year        =   currentyear;
                    revenue.NRE         =   (qrev.NRE__c != null ? qrev.NRE__c:0);
                    revenue.Asp         =   (qrev.ASP__c != null ? qrev.ASP__c:0);
                    revenue.volume      =   (qrev.Volume__c != null ? qrev.Volume__c:0); 
                    revenue.totalRev    =   (qrev.Revenue__c != null ? qrev.Revenue__c:0);
                    revenue.recCount    =   revenue.recCount+1;
                }
                
                revenueMap.put(fisYear,revenue);
            
            }         
        }catch(Exception excp){/*GlobalUtility.logMessage('Error','DealGrading_DisplayRevenueOnDG','getcalSum','','Exception while getting the  quarterly revenue data',String.valueof(excp.getMessage()),'','Deal Grading',excp,0);*/}
        if(revenueMap.size() > 0) {
            revenueDetails.addAll(revenueMap.values());
            
        }       
        
        return revenueDetails;
    }
  
    public class revenueDetails{
        public integer year{get;set;}
        public Decimal NRE{get;set;}
        public Decimal ASP{get;set;}
        public Decimal volume{get;set;}
        public Decimal totalRev{get;set;}
        public integer recCount{get;set;}
            revenueDetails(){
                year        =   0;
                NRE         =   0;
                ASP         =   0;
                volume      =   0;
                totalRev    =   0;
                recCount    =   0;
           }
                
    }
    
}