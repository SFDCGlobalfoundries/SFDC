public class MCMController {
    
    PCM_Administration__c pcmAdminSetting = PCM_Administration__c.getInstance('CURRENT_SETTING'); 
    public PCM_MCM_Detail__c mcmDetailObj {get;set;}
    public Id deviceId {get;set;}
    public Id mcmId {get;set;} 
    public List<MCM_Yields__c> lstMcmAsmblyYld {get;set;}
    public List<MCM_BurnIn_duration__c> lstMcmBIYld {get;set;}
    public List<MCM_Yields__c> lstMcmTstYld {get;set;}
    public List<integer> qtrCount {get;set;}
    public Map<integer, string> testmap  {get;set;}
    public list<MCM_QUArTERLY_VOLUME__c> mcmQtrVol {get;set;}
    public list<MCM_Configuration_Detail__c> lstMcmConfDtl {get;set;}
    public list<Decimal> lstYield {get;set;} 
    public list<Decimal> lstBI {get;set;} 
    public PCM_MCM_Detail__c mcmCost {get;set;}
    public List<MCM_BurnIn_Duration__c> lstBIDuration {get;set;}
    public list<Decimal> lstUD {get;set;} 
    public list<Decimal> lstSbt {get;set;} 
    public Date tapeOutDate {get;set;}
    Integer startQtr {get;set;}
    integer month  {get;set;}
    integer year {get;set;}
    
    
    public List<MCM_Reporting_Data__c> lstUSubstrateCost {get;set;}
    

    public  MCMController ()
    {
        deviceId = ApexPages.currentPage().getParameters().get('Id');//Parent Device Id
        qtrCount = new list<integer>();
        lstBIDuration = new List<MCM_BurnIn_Duration__c>();
        lstMcmConfDtl = new List<MCM_Configuration_Detail__c>();
        lstBI = new list<decimal>();
        lstYield = new list<decimal>(); 
        lstUD = new List<Decimal>();
        lstSbt = new List<Decimal>();
        lstMcmAsmblyYld =new List<MCM_Yields__C>();
        mcmDetailObj = new PCM_MCM_Detail__C();
        lstUSubstrateCost =new List<MCM_Reporting_Data__c>();
        PCM_MCM_Detail__c[]  mcmObj = [SELECT Id,
                                       Test_Platform__c,No_of_DUTS__c,
                                       User_Defined_Time__c,Device__c, 
                                       Actual_Tapeout_Date_FAB_9_and_FAB_10__c,
                                  //     Actual_Tapeout_Date__c,
                                       Burn_In_Platform__c,
                                       Number_of_Sockets_Per_Boards__c,
                                       Fab__c,  Device__r.name,Device__r.Opportunity__c,    Device__r.Opportunity_Program__c,
                                       Cost_Report__c,
                                       (Select ID,year__c,q1_volume__c,q2_volume__c,q3_volume__c,q4_volume__c from MCM_QUArTERLY_VOLUME__r) 
                                       FROM PCM_MCM_Detail__c 
                                       WHERE     Device__c  = :deviceId limit 1];
        
        
        if(mcmObj.size()>0)
        {                                 
            mcmDetailObj =mcmObj[0];
            mcmId=mcmDetailObj.id;
            ApexPages.currentPage().getParameters().put('mcmId',mcmObj[0].id);  
            lstMcmConfDtl =[Select id,configuration__c,configuration__r.name,configuration__r.Process_Technology_Name__c,Chip_per_Technology__c,PCM_MCM_MCM__r.Device__r.name,configuration__r.device__r.Name,PCM_MCM_MCM__r.Device__r.Device_ID__c from MCM_Configuration_Detail__c where PCM_MCM_MCM__c=:mcmId];
            lstUSubstrateCost = [Select Id,Year__c,Quarter__c,Cost__c,Cost_Type__c From MCM_Reporting_Data__c where MCM__c =:mcmId and Cost_Type__c='Assembly & Substrate Cost (before Yield)' Order By Year__c,Quarter__c asc];
            
            //Start Year & Quarter
        
            /*Commented by Ravindra 
            if(mcmDetailObj.Fab__c == 'FAB 9' || mcmDetailObj.Fab__c == 'FAB 10'){
                tapeOutDate = mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c;    
            } else {
                tapeOutDate = mcmDetailObj.Actual_Tapeout_Date__c;
            }
            Comment End */
            
            tapeOutDate = mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c;    
            month = tapeOutDate.month();
            year = tapeOutDate.year();
            String yrStr = String.valueOf(year);
            if(month >= 1 && month <=3) {
                startQtr = 1;
            }
            if(month >= 4 && month <=6) {
                startQtr = 2;
            }
            if(month >= 7 && month <=9) {
                startQtr = 3;
            }
            if(month >= 10 && month <=12) {
                startQtr = 4;
            }
            
            //================================
            
            if(mcmId!=null || mcmId!='') loadMCMYields();
            loadBIDurations();
            
            integer qtrCnt=0;
            mcmQtrVol= new list<MCM_QUArTERLY_VOLUME__c>(); 
            for(PCM_MCM_Detail__c mcm:mcmObj)
            {
                for(MCM_QUArTERLY_VOLUME__c qtr:mcm.MCM_QUArTERLY_VOLUME__r){
                    if(qtr.q1_volume__c!=null) qtrCnt++;
                    if(qtr.q2_volume__c!=null) qtrCnt++;
                    if(qtr.q3_volume__c!=null) qtrCnt++;
                    if(qtr.q4_volume__c!=null) qtrCnt++;
                }
            }
            
            if( qtrCnt>0  ){
                generateList(qtrCnt);
            }
            
        }
        Else
        {
            mcmDetailObj = new PCM_MCM_Detail__c();
            mcmDetailObj.Device__c =  deviceId;
        }
        
    }
    
    //this method is used to generate dynamic yield columns in VF page
    public void generateList(integer cnt){
        qtrCount = new List<integer>();
        
        for(integer i=1;i<=cnt && i<25;i++){
            qtrCount.add(i);
        }
    }
    public pagereference SaveMCMData(){                
        if (validateDataSave()){
            try{
            
            if(mcmId==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Inside ValidateData'));
            }
            upsert mcmDetailObj;
            
            
            upsert lstMcmConfDtl;
            
            if (lstMcmAsmblyYld!=null) upsert lstMcmAsmblyYld;
            
            if(lstBIDuration!=null) upsert lstBIDuration;
            if(lstUSubstrateCost!=null) upsert lstUSubstrateCost;
        }
        catch(exception e){    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage())); }
        }
        else{
            return null;
        }
        
        PageReference pageRef = Page.MCMDetailPage;
        pageRef.getParameters().put('Id', '' + deviceId);
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    
    public PageReference gotoConfSelectionPage()
    {
        PageReference pr = Page.MCMConfigurationSelection;
        pr.getParameters().put('mcmId', '' + mcmDetailObj.Id);
        pr.getParameters().put('id', '' + deviceId);
        
        loadMCMConfiguration();
        pr.setRedirect(false);
        return pr;
    }
    public List<Apttus_Proposal__Proposal__c> lstConfObj {get;set;}
    
    public list<WrapperConf> lstWrapperConf{get;set;}
    
    
    Boolean isSelected = false;        
    
    public class WrapperConf{
        public Apttus_Proposal__Proposal__c configObj{get;set;}
        public boolean isSelected{get;set;}
        public id mcmConfDtlID {get;set;}
        public WrapperConf(Apttus_Proposal__Proposal__c conf) {
            configObj = conf;
            isSelected = false;
            
        }
        
        public WrapperConf(Apttus_Proposal__Proposal__c conf, boolean flag, id x) {
            configObj = conf;
            isSelected = flag;
            mcmConfDtlID = x     ;
        }
       
        
    } 
    
    //To load MCM Yield data from MCM_YIELDs__c
    public void loadMCMYields(){
        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.MCM_Yields__c.FieldSets.Quarter.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'recordtype.name FROM MCM_Yields__c Where MCM__c =:mcmId';
        lstMcmAsmblyYld =Database.query(query);
        
    }
       
    
    //To load MCM BI Duration data from MCM_BurnIn_DURATION__C
    public void loadBIDurations(){
        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.MCM_BurnIn_Duration__c.FieldSets.QuarterDuration.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'recordtype.name FROM MCM_BurnIn_Duration__c Where MCM__c =:mcmId';
        lstBIDuration =Database.query(query);                        
    }
    
   
    
    public void loadMCMConfiguration(){
        
        
        
        lstConfObj=[Select id,device__c,device__r.name,name,Apttus_Proposal__Proposal_Name__c,Process_Technology_Name__c,Apttus_Proposal__Approval_Stage__c,APTPS_Primary__c,
                    fab_name__c,Actual_Tapeout_Date_FAB_9_and_FAB_10__c //,Actual_Tapeout_Date__c
                 //   from Apttus_Proposal__Proposal__c where APTPS_Primary__c=True AND     Apttus_Proposal__Opportunity__c=:mcmDetailObj.Device__r.Opportunity__c] ;
        from Apttus_Proposal__Proposal__c where APTPS_Primary__c=True AND   Device__r.Opportunity_Program__c=:mcmDetailObj.Device__r.Opportunity_Program__c];
        
        lstWrapperConf = new list<WrapperConf>();
        
        lstMcmConfDtl =[Select id,configuration__c,configuration__r.Name,configuration__r.Process_Technology_Name__c,Chip_per_Technology__c,PCM_MCM_MCM__r.Device__r.Device_ID__c,configuration__r.device__r.Name,PCM_MCM_MCM__r.Device__r.NAme from MCM_Configuration_Detail__c where PCM_MCM_MCM__c=:mcmId];
      
        for(Apttus_Proposal__Proposal__c v : lstConfObj) {
            isSelected= false;
            Id mcmDtlId;
            for (MCM_Configuration_Detail__c c: lstMcmConfDtl){
                
                if(c.configuration__c==v.id){
                    isSelected=true;
                    mcmDtlId=c.Id;
                    break;
                }
            }
            
            lstWrapperConf.add(new WrapperConf(v,isSelected,mcmDtlId));
            
        }
        
    }   
    
    public pagereference redirectToMCMDetail(){   
        PageReference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){          
            pr = new PageReference('/GlobalfoundryView/apex/MCMDetailPage?id='+deviceId);
        }else{
            pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/MCMDetailPage?id='+deviceId);
        }
        return pr;
    } 
    
    
    public pagereference SaveDetail() {
        list<WrapperConf> lstAddConf = new list<WrapperConf>();
        list<Id> tempID = new list<Id>(); 
        list<MCM_Configuration_Detail__c > tempLstConf = new list<MCM_Configuration_Detail__c>();
        list<MCM_Configuration_Detail__c > tempDeleteLstConf = new list<MCM_Configuration_Detail__c>();
        Date confTapeoutDate ;
        Pagereference pf ;
        Integer confStartQtr;
        Integer confStartYear;
      
        for(WrapperConf cf : lstWrapperConf) {
            MCM_Configuration_Detail__c temp = new MCM_Configuration_Detail__c();  
            temp.PCM_MCM_MCM__c = mcmId;
            temp.Configuration__c = cf.configObj.id;
            temp.Id = cf.mcmConfDtlID;
            
            
            
            try{
            if(cf.isSelected) {
                //Start Year & Quarter
                //Commented by Ravindra --Start
                /*
                if(cf.configObj.Fab_Name__c == 'FAB 9' || cf.configObj.Fab_Name__c == 'FAB 10'){
                    confTapeoutDate = cf.configObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c;    
                } else {
                    confTapeoutDate = cf.configObj.Actual_Tapeout_Date__c;
                }
                */
                //comment End
                //
                confTapeoutDate = cf.configObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c; 
                confStartYear =(confTapeoutDate!=NULL)?confTapeoutDate.year():0;
                
                if(confTapeoutDate.month() >= 1 && confTapeoutDate.month()  <=3) {
                    confStartQtr = 1;
                }
                Else if(confTapeoutDate.month() >= 4 && confTapeoutDate.month() <=6) {
                    confStartQtr = 2;
                }
                else if(confTapeoutDate.month() >= 7 && confTapeoutDate.month() <=9) {
                    confStartQtr = 3;
                }
                else if(confTapeoutDate.month() >= 10 && confTapeoutDate.month() <=12) {
                    confStartQtr = 4;
                }
                if((confStartQtr==startQtr) &&(year==confStartYear))  { 
                    if(cf.configObj.id != NULL) {        
                        tempLstConf.add(temp);
                    }
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Tapeout Year/Quarter for MCM & selected Configuration is not same for :'+ cf.configObj.name)); 
                        loadMCMConfiguration();               
                    return null;
                }
            }
            else{
                tempID.add(temp.id);
            }
        }
            catch(Exception e){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please make sure selected configurations set up properly')); 
                return null;
            }
        }
        
        try{
        upsert tempLstConf;
        
        //To Delete Un-checked row which was saved earlier.
        tempDeleteLstConf =[Select Id from MCM_Configuration_Detail__c Where id =:tempID];
        delete tempDeleteLstConf;
        
        loadMCMConfiguration();
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please make sure selected configurations set up properly')); 
                return null;
        }
        
        pf = redirectToMCMDetail()  ;
        return pf;
        
    }
    
    
    
    Public boolean ValidateDataSave(){
        
        boolean validate = true;
        
        if(mcmDetailObj.Fab__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select Fab location')); 
            validate= false;
        }
        
        if(mcmDetailObj.Test_Platform__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select Test Platform')); 
            validate= false;
        }
        
        if(mcmDetailObj.No_of_DUTS__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select Number of DUTS')); 
            validate= false;
        }
        
        
        if(mcmDetailObj.User_Defined_Time__c==null || mcmDetailObj.User_Defined_Time__c<0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter User Defined time')); 
            validate= false;
        }
        
        if(mcmDetailObj.Burn_In_Platform__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select Burn In Platform')); 
            validate= false;
        }
        
        if(mcmDetailObj.Number_of_Sockets_Per_Boards__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Number of Sockets Per Boards')); 
            validate= false;
        }
        if(mcmDetailObj.Actual_Tapeout_Date_FAB_9_and_FAB_10__c == null){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Actual Tapeout Date')); 
            validate= false;  
                }
        integer cnt=0;
        for(mcm_yields__c yld: lstMcmAsmblyYld){
            lstYield.clear(); lstYield.add(yld.Q1__c);lstYield.add(yld.Q2__c);lstYield.add(yld.Q3__c);lstYield.add(yld.Q4__c);lstYield.add(yld.Q5__c);lstYield.add(yld.Q6__c);lstYield.add(yld.Q7__c);
            lstYield.add(yld.Q8__c);lstYield.add(yld.Q9__c);lstYield.add(yld.Q10__c);lstYield.add(yld.Q11__c);  lstYield.add(yld.Q12__c); lstYield.add(yld.Q13__c); lstYield.add(yld.Q14__c);
            lstYield.add(yld.Q15__c); lstYield.add(yld.Q16__c); lstYield.add(yld.Q17__c); lstYield.add(yld.Q18__c); lstYield.add(yld.Q19__c); lstYield.add(yld.Q20__c); lstYield.add(yld.Q21__c); lstYield.add(yld.Q22__c);
            lstYield.add(yld.Q23__c); lstYield.add(yld.Q24__c);
            cnt=0;
            
            for(decimal yldVal: lstYield){
                
                if(cnt<qtrCount.size()) {
                    
                    If(yldVal==null ||(yldVal>0 && yldVal<=1)){
                        cnt++;
                        
                    }
                    Else  {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Quarterly Values should be greater than 0 and less/equal to 1'  )); 
                        validate= false;
                        return validate;
                    }
                    
                }
              
            }
        }
        
        
        if(lstMcmConfDtl!=null && lstMcmConfDtl.size()>0){
            
            for(MCM_Configuration_Detail__c siD: lstMcmConfDtl){
                
                cnt=0;
                
                if(cnt<qtrCount.size()) {
                    If(siD.Chip_per_Technology__c>0 || siD.Chip_per_Technology__c==null){
                        cnt++;
                        
                    }
                    Else  {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Number of Chips per technology should be >0' )); 
                        validate= false;
                        return validate;
                    }
                    
                }
                
            }} 
        
        
        if(lstUSubstrateCost!=null && lstUSubstrateCost.size()>0){
            
            for(mcm_reporting_data__c siD: lstUSubstrateCost){
                
                cnt=0;
                
                if(cnt<qtrCount.size()) {
                    If(siD.cost__c>0 || siD.cost__c==null){
                        cnt++;
                        
                    }
                    Else  {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Assembly & Substrate Cost should be >0' )); 
                        validate= false;
                        return validate;
                    }
                    
                }
                
            }} 
        
        if(lstBIDuration!=null && lstBIDuration.size()>0){
            
            for(mcm_burnin_duration__c biD: lstBIDuration){
                lstBI.clear();
                lstBI.add(biD.Q1__c);lstBI.add(biD.Q2__c);lstBI.add(biD.Q3__c);lstBI.add(biD.Q4__c);lstBI.add(biD.Q5__c);lstBI.add(biD.Q6__c);lstBI.add(biD.Q7__c);
                lstBI.add(biD.Q8__c);lstBI.add(biD.Q9__c);lstBI.add(biD.Q10__c);lstBI.add(biD.Q11__c);  lstBI.add(biD.Q12__c); lstBI.add(biD.Q13__c); lstBI.add(biD.Q14__c);
                lstBI.add(biD.Q15__c); lstBI.add(biD.Q16__c); lstBI.add(biD.Q17__c); lstBI.add(biD.Q18__c); lstBI.add(biD.Q19__c); lstBI.add(biD.Q20__c); lstBI.add(biD.Q21__c); lstBI.add(biD.Q22__c);
                lstBI.add(biD.Q23__c); lstBI.add(biD.Q24__c);
                cnt=0;
                
                for(decimal b: lstBI){
                    
                    if(cnt<qtrCount.size()) {
                        If(b>0 || b==null){
                            cnt++;
                            
                        }
                        Else  {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Burn-In Durations should be >0' )); 
                            validate= false;
                            return validate;
                        }
                        
                    }
                      Else{
                    b=null;
                }
                }
            }
        }
        
        
        
        return validate;
    } 
    
    Public boolean ValidateDataReport(){
        
        boolean validate = true;
        
        if(mcmDetailObj.Fab__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select Fab location')); 
            validate= false;
        }
        
        if(mcmDetailObj.Test_Platform__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select Test Platform')); 
            validate= false;
        }
        
        if(mcmDetailObj.No_of_DUTS__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select Number of DUTS')); 
            validate= false;
        }
        
        
        if(mcmDetailObj.User_Defined_Time__c==null || mcmDetailObj.User_Defined_Time__c<0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter User Defined time')); 
            validate= false;
        }
     
        if(mcmDetailObj.Burn_In_Platform__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select Burn In Platform')); 
            validate= false;
        }
        
        if(mcmDetailObj.Number_of_Sockets_Per_Boards__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Number of Sockets Per Boards')); 
            validate= false;
        }
        
        
        integer cnt=0;
        for(mcm_yields__c yld: lstMcmAsmblyYld){
            lstYield.clear(); lstYield.add(yld.Q1__c);lstYield.add(yld.Q2__c);lstYield.add(yld.Q3__c);lstYield.add(yld.Q4__c);lstYield.add(yld.Q5__c);lstYield.add(yld.Q6__c);lstYield.add(yld.Q7__c);
            lstYield.add(yld.Q8__c);lstYield.add(yld.Q9__c);lstYield.add(yld.Q10__c);lstYield.add(yld.Q11__c);  lstYield.add(yld.Q12__c); lstYield.add(yld.Q13__c); lstYield.add(yld.Q14__c);
            lstYield.add(yld.Q15__c); lstYield.add(yld.Q16__c); lstYield.add(yld.Q17__c); lstYield.add(yld.Q18__c); lstYield.add(yld.Q19__c); lstYield.add(yld.Q20__c); lstYield.add(yld.Q21__c); lstYield.add(yld.Q22__c);
            lstYield.add(yld.Q23__c); lstYield.add(yld.Q24__c);
            cnt=0;
            
            for(decimal yldVal: lstYield){
                if(cnt<qtrCount.size()) {
                    
                    If( yldVal !=null && (yldVal>0 && yldVal<=1)){
                        cnt++;
                        
                    }
                    Else  {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Yields values for all quarter. Values should be greater than 0 and less/equal to 1'  )); 
                        validate= false;
                        return validate;
                    }
                    
                }
            }
        }
        //    }
        
        if(lstUSubstrateCost!=null && lstUSubstrateCost.size()>0){
            cnt=0;
            for(mcm_reporting_data__c siD: lstUSubstrateCost){
               
                If(siD.cost__c>0 && siD.cost__c!=null){
                    cnt++;
                    
                }
                Else  {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Assembly & Substrate Cost should be >0' )); 
                    validate= false;
                    return validate;
                }
                
                
                
            }} 
        
        if(lstMcmConfDtl!=null && lstMcmConfDtl.size()>0){
            
            for(MCM_Configuration_Detail__c siD: lstMcmConfDtl){
                
                cnt=0;
                
                if(cnt<qtrCount.size()) {
                    If(siD.Chip_per_Technology__c>0 && siD.Chip_per_Technology__c!=null){
                        cnt++;
                        
                    }
                    Else  {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Number of Chips per technology should be >0' )); 
                        validate= false;
                        return validate;
                    }
                    
                }
                
            }} 
        
        if(lstBIDuration!=null && lstBIDuration.size()>0){
            
            for(mcm_burnin_duration__c biD: lstBIDuration){
                lstBI.clear();
                lstBI.add(biD.Q1__c);lstBI.add(biD.Q2__c);lstBI.add(biD.Q3__c);lstBI.add(biD.Q4__c);lstBI.add(biD.Q5__c);lstBI.add(biD.Q6__c);lstBI.add(biD.Q7__c);
                lstBI.add(biD.Q8__c);lstBI.add(biD.Q9__c);lstBI.add(biD.Q10__c);lstBI.add(biD.Q11__c);  lstBI.add(biD.Q12__c); lstBI.add(biD.Q13__c); lstBI.add(biD.Q14__c);
                lstBI.add(biD.Q15__c); lstBI.add(biD.Q16__c); lstBI.add(biD.Q17__c); lstBI.add(biD.Q18__c); lstBI.add(biD.Q19__c); lstBI.add(biD.Q20__c); lstBI.add(biD.Q21__c); lstBI.add(biD.Q22__c);
                lstBI.add(biD.Q23__c); lstBI.add(biD.Q24__c);
                cnt=0;
                
                for(decimal b: lstBI){
                    if(cnt<qtrCount.size()) {
                        If( b !=null && b>0){
                            cnt++;
                            
                        }
                        Else  {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Burn-In Durations for all quarters' )); 
                            validate= false;
                            return validate;
                        }
                        
                    }
                }
            }
        }
                
        return validate;
    } 
    
    public Component.Apex.PageBlockTable getYieldsPageBlockTable(){
        integer rowCnt=1;
        integer yr=year;
        integer StQtr = startQtr;
              
        Component.Apex.PageBlockTable  table=new Component.Apex.PageBlockTable(var='mYld', Id='table1');
        table.expressions.value='{!lstMcmAsmblyYld}';
        Component.Apex.Column yld = new Component.Apex.Column(headerValue='Yield Type',  width='150px');
        yld.expressions.value = '{!mYld.recordtype.name}';
        table.childComponents.add(yld);
        
        
        Component.Apex.Column col ;
        Component.Apex.outputField qtr;
        //     Component.Apex.inputField qtr;   if need to make input field
        if(lstMcmAsmblyYld.size()>0  ){
            for (integer i: qtrCount){
                col = new Component.Apex.Column(headerValue=String.valueOf(yr)+'Q' + StQtr,  width='50px', id='col'+i);
                stQtr++;
                if(stQtr>4){
                    stQtr=1;
                    yr++;
                }
                qtr = new Component.Apex.outputField (Id='Vol'+rowCnt);
                qtr.expressions.value = '{!mYld.Q'+i +'__c}';
                
                Component.Apex.inlineEditSupport inEdit = new Component.Apex.inlineEditSupport ();
                inEdit.event='onclick';
                inEdit.showOnEdit='saveButton';
                
                qtr.childComponents.add(inEdit);
                col.childComponents.add(qtr);
                table.childComponents.add(col);
                
                rowCnt++;
            }
        }
        return table;
    }
    
    public Component.Apex.PageBlockTable getBIDurationPageBlockTable(){
        integer rowCnt=1; 
        integer yr=year;
        integer StQtr = startQtr;
        
        Component.Apex.PageBlockTable  table=new Component.Apex.PageBlockTable(var='mcmBI', Id='table2');
        table.expressions.value='{!lstBIDuration}';
        Component.Apex.Column dur = new Component.Apex.Column(headerValue='Duration (Seconds)',  width='150px');
        dur.expressions.value = '{!mcmBI.recordtype.name}';
        table.childComponents.add(dur);
        
        Component.Apex.Column col;
        Component.Apex.outputField qtr;

        if(lstBIDuration.size()>0  ){
            for (integer i: qtrCount){
                
                col = new Component.Apex.Column(headerValue=String.valueOf(yr)+'Q' + StQtr,  width='50px', id='clm'+i);
                
                stQtr++;
                if(stQtr>4){
                    stQtr=1;
                    yr++;
                }
                qtr = new Component.Apex.outputField (Id='Durr'+rowCnt);
                qtr.expressions.value = '{!mcmBI.Q'+i +'__c}';
                Component.Apex.inlineEditSupport inEdit = new Component.Apex.inlineEditSupport ();
                inEdit.event='onclick';
                qtr.childComponents.add(inEdit);
                col.childComponents.add(qtr);
                table.childComponents.add(col);
                
                rowCnt++;
            }
        }
        return table;
    }
        
    public Component.Apex.PageBlockTable getSubstrateCostPageBlockTable(){
        integer rowCnt=1; 
        integer yr=year;
        integer StQtr = startQtr;
        
        Component.Apex.PageBlockTable  table=new Component.Apex.PageBlockTable(var='cost', Id='table3', width='250px');
        table.expressions.value='{!lstUSubstrateCost}';
        Component.Apex.Column col1 = new Component.Apex.Column(headerValue='UserDefined Cost (USD)',  width='150px');
        Component.Apex.Column col2 = new Component.Apex.Column(headerValue= 'Year',  width='50px');
        col2.expressions.value = '{!cost.Year__c}' ;
        table.childComponents.add(col2);
        
        Component.Apex.Column col3 = new Component.Apex.Column(headerValue= 'Quarter',  width='50px' );
        col3.expressions.value = '{!cost.Quarter__c}' ;
        table.childComponents.add(col3);
        
        Component.Apex.Column col4 = new Component.Apex.Column(headerValue= '{!cost.cost__c}',  width='50px');
        
        Component.Apex.outputField qtr = new Component.Apex.outputField ();
        qtr.expressions.value = '{!cost.Cost__c}';
        Component.Apex.inlineEditSupport inEdit = new Component.Apex.inlineEditSupport ();
        inEdit.event='onclick';
        qtr.childComponents.add(inEdit);
        col4.childComponents.add(qtr);
        table.childComponents.add(col4);
        
        rowCnt++;
        
        
        return table;
    }    
    public pagereference redirectToMCMDevice(){   
        PageReference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){          
            pr = new PageReference('/GlobalfoundryView/'+deviceId);
        }else{
            pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/'+deviceId);
        }
        return pr;
    } 
    public pagereference GenerateCostReport(){
        
        
        if(ValidateDataReport()){
            
            try{  
                upsert mcmDetailObj;
                upsert lstMcmConfDtl;
                if (lstMcmAsmblyYld!=null) upsert lstMcmAsmblyYld;
                if(lstBIDuration!=null) upsert lstBIDuration;
                if(lstUSubstrateCost!=null) upsert lstUSubstrateCost;
                GenerateMCMYieldAndCost.generate(mcmID);
                Pagereference pf;
                if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){          
                    pf = new PageReference('/GlobalfoundryView/apex/MCMCostReport');
                }else{
                    pf = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/MCMCostReport?mcmId=' + mcmId);
                }
                return pf;
            }
            
            Catch(DMLException e){
                System.debug('Error encounter while generating report: ' + e.getMessage());
            }
            
        }
        return null;
    }      
    public pagereference DisplayCostReport(){
        
        try{  
            
            Pagereference pf;
            if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){          
                pf = new PageReference('/GlobalfoundryView/apex/MCMCostReport?mcmId=' + mcmId);
            }else{
                pf = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/MCMCostReport?mcmId=' + mcmId);
            }
            return pf;
        }
        
        Catch(Exception e){
            System.debug('Error encounter while generating report: ' + e.getMessage());
        }
        return null;
        
        
    }  
}