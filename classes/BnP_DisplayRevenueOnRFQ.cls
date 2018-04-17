/*
Type Name: BnP_DisplayRevenueOnRFQ
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP)
Created Date: 08/02/2017
Description: This class serves controller for BnP_PopulateQuarterlyRevenue page. This class is used for displaying Opportunity Quarterly Revenue on the Request Information record section 'Annual Revenue' 
History:  08/02/2017  code creation
*/            
public class  BnP_DisplayRevenueOnRFQ  {

    //Get the current Request Information record id
    
    Id recid=ApexPages.CurrentPage().getparameters().get('id');
    Id OppId;
    string quoteStatus;
    public map<string,revenueDetails> revenueMap{get;set;}
    public list<revenueDetails> revenueDetails{get;set;}
    public boolean isModuleChip{get;set;}
    public boolean isquoteAccRej{get;set;}
    Public Request_Information__c objApplicant{get; set;}
    public List<Request_Information_Revenue_Snap__c> revenueSnapShotList {get; set;}
    public BnP_DisplayRevenueOnRFQ(ApexPages.StandardController con) { 
        this.objApplicant = (Request_Information__c)con.getRecord();
        OppId           =   ((Request_Information__c)con.getRecord()).Opportunity__c;
        revenueMap      =   new map<string,revenueDetails>();
        revenueDetails  =   new list<revenueDetails>();
        Request_Information__c req = [SELECT id, Quote_Status__c from Request_Information__c WHERE id =: this.objApplicant.id ];
        isquoteAccRej = false;
        if(req.Quote_Status__c == 'Accept' || req.Quote_Status__c == 'Reject'){
            isquoteAccRej = true;
        }
    }
    
    /**
    *  The Purpose of this method is to display Opportunity Annual Revenue 
    *  @name <displayRevenue>
    *  @param <NA> 
    *  @return <Pagereference>
    *  @throws exception-<exception description>
    */
    public pageReference displayRevenue(){
        
        getRevenueSnapShotList();
        return null;
    }
    
     /**
    *  The getter method used in the page to display Opportunity Annual Revenue
    *  @name <getRevenueSnapShotList>
    *  @param <NA>
    *  @return <List <Request_Information_Revenue_Snap__c>>
    *  @throws exception-<exception description>
    */
    Public List <Request_Information_Revenue_Snap__c> getRevenueSnapShotList(){
        revenueSnapShotList = [Select id, Name, ASP__c,ASP_Module_Chip__c,Deliverable_Type__c,Volume_Module_Chip__c, NRE__c, Total_Revenue_K__c, Volume__c, Year__c, Turnkey_ASP__c from Request_Information_Revenue_Snap__c where Request_Information__c = :objApplicant.id];
        if(!revenueSnapShotList.isEmpty()){
            for(Request_Information_Revenue_Snap__c reqInforev : revenueSnapShotList){
                if(reqInforev.Deliverable_Type__c == 'Module' || reqInforev.Deliverable_Type__c == 'Chip'){
                    isModuleChip = true;
                }
            }
            
        }
        
        return revenueSnapShotList;
    }
    
    public list<revenueDetails>  getcalSum() 
    {   
        try{
            for(Quarterly_Revenue_Object__c qrev : [SELECT Fiscal_Quarter__c,Wafer_ASP__c,Wafer_Vol__c,Module_Die_ASP__c,Module_Die_Vol__c, Current_Year__c, NRE__c,ASP__c,Volume__c, Revenue__c,opportunity__c,RMT_ASP__c,RMT_Volume__c,Turnkey_ASP__c,Net_Parts_Per_Wafer__c,ASP_Module_Chip__c,Volume_Module_Chip__c,Opportunity__r.Deliverable_Type__c 
                                                        FROM Quarterly_Revenue_Object__c WHERE Opportunity__r.id=:OppId ORDER BY Fiscal_Quarter__c ASC]){
                string fisYear          =   qrev.Fiscal_Quarter__c.substring(0,4);
                integer currentyear     =   integer.valueOf(fisYear);
                revenueDetails revenue  =   new revenueDetails();
                
                if(qrev.Opportunity__r.Deliverable_Type__c == 'Module' || qrev.Opportunity__r.Deliverable_Type__c == 'Chip'){
                    isModuleChip = true;
                }
                if(revenueMap.containsKey(fisYear) && revenueMap.get(fisYear) !=null) {
                    revenue             =   revenueMap.get(fisYear);
                    revenue.year        =   (currentyear >revenue.year)? (currentyear):revenue.year;
                    revenue.volume      =   revenue.volume+(qrev.Volume__c != null ? qrev.Volume__c:0);
                    revenue.totalRev    =   revenue.totalRev + (qrev.Revenue__c != null ? qrev.Revenue__c:0);
                    Decimal totalAsp    =   (revenue.asp * revenue.recCount)+ (qrev.asp__c != null ?  qrev.asp__c :0);
                    Decimal totalAspModChip    =   (revenue.aspModChip * revenue.recCount) + (qrev.ASP_Module_Chip__c != null ?  qrev.ASP_Module_Chip__c :0);
                    revenue.recCount    =   revenue.recCount+1;
                    revenue.asp         =   (totalAsp/revenue.recCount);
                    revenue.aspModChip         =   (totalAspModChip/revenue.recCount);
                    revenue.volumeModChip      =   revenue.volumeModChip+(qrev.Volume_Module_Chip__c != null ? qrev.Volume_Module_Chip__c:0);
                    revenue.delType  = qrev.Opportunity__r.Deliverable_Type__c;
                } else {
                    revenue.year        =   currentyear;
                    revenue.Asp         =   (qrev.ASP__c != null ? qrev.ASP__c:0);
                    revenue.volume      =   (qrev.Volume__c != null ? qrev.Volume__c:0); 
                    revenue.totalRev    =   (qrev.Revenue__c != null ? qrev.Revenue__c:0);
                    revenue.recCount    =   revenue.recCount+1;
                    revenue.aspModChip         =   (qrev.ASP_Module_Chip__c != null ? qrev.ASP_Module_Chip__c:0);
                    revenue.volumeModChip      =   (qrev.Volume_Module_Chip__c != null ? qrev.Volume_Module_Chip__c:0);
                    revenue.delType  = qrev.Opportunity__r.Deliverable_Type__c;
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
        public Decimal WaferASP{get;set;}
        public Decimal WaferVol{get;set;}
        public Decimal ModuleDieASP{get;set;}
        public Decimal ModuleDieVol{get;set;}
        public Decimal RMTASP{get;set;}
        public Decimal RMTVOL{get;set;}
        public Decimal TRNYASP{get;set;}
        public integer NPW{get;set;}
        public Decimal aspModChip{get;set;}
        public Decimal volumeModChip{get;set;}
        public String delType{get;set;}
        
        
            revenueDetails(){
                year        =   0;
                NRE         =   0;
                ASP         =   0;
                volume      =   0;
                totalRev    =   0;
                recCount    =   0;
                WaferASP    =   0;
                WaferVol    =   0;
                ModuleDieASP    =   0;
                ModuleDieVol    =   0;
                RMTASP  =        0;
                RMTVOL = 0;
                TRNYASP = 0;
                NPW = 0;
                aspModChip         =   0;
                volumeModChip      =   0;
                delType = '';
           }
                
    }
    
}