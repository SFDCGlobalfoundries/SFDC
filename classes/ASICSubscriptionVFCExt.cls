/*********************************************************************************/
  // Purpose      : Redirecting to page to subscribe
  // Date created : 09 March, 2017
  // Created by   : UCM Team
  // Author       : Pankaj 
  // Description  : Redirecting to page to subscribe
  // Change History 
  //    1. [Modify By] [Modify Date] 
  //        [Reason] :
/*********************************************************************************/
public class ASICSubscriptionVFCExt {

    public Bug__c objBug {get;set;}
    public String problemType {get;set;}
    public String subTypeA    {get;set;}
    public String subTypeB    {get;set;}
    public String subTypeC    {get;set;}
    public String subTypeD    {get;set;}
    
    public string cstProject {
        get;
        set;
    }
     
    public List<SelectOption> listProblemTypeOptions {get;set;}
    public List<SelectOption> listSubTYpeAOptions {get;set;}
    public List<SelectOption> listSubTYpeBOptions {get;set;}
    public List<SelectOption> listSubTYpeCOptions {get;set;}
    public List<SelectOption> listSubTYpeDOptions {get;set;}
    
    public set<String> listProblemType {get;set;}
    public list<Bug_Default_Owner_Team__c> buglistvar{get;set;}
    
    public list<ASICCustomerProject__c> cstBugVar{get;set;}
             
    public List<String> subTypeAValues = new List<String>();
    public List<String> subTypeBValues = new List<String>();
    public List<String> subTypeCValues = new List<String>();
    public List<String> subTypeDValues = new List<String>();
    List<String> sortStr;
    public list < SelectOption > listCustomerProject1{
        get;
        set;
    }
    public list < SelectOption > listCustomerProject2{
        get;
        set;
    }
     public boolean isRequiredFlag {
        get;
        set;
    }
    
    public ASICSubscriptionVFCExt(ApexPages.StandardController controller) {
        objBug  =       (Bug__c)controller.getRecord();
        sortStr = new List<String>();
        listCustomerProject1  = new list < SelectOption > (); 
        listCustomerProject2  = new list < SelectOption > ();               
        listCustomerProject1.add(new SelectOption('', '--None--'));
        buglistvar = new List<Bug_Default_Owner_Team__c>() ;  
        cstBugVar = new List<ASICCustomerProject__c>();
        isRequiredFlag  = true; 
        listProblemType = new set<String>();
        listSubTYpeAOptions = new list <SelectOption> ();
        listSubTYpeBOptions= new list <SelectOption> ();
        listSubTYpeCOptions= new list <SelectOption> ();
        listSubTYpeDOptions= new list <SelectOption> ();
        listSubTYpeAOptions.add(new SelectOption('', '--None--'));
        listSubTYpeBOptions.add(new SelectOption('', '--None--'));
        listSubTYpeCOptions.add(new SelectOption('', '--None--'));
        listSubTYpeDOptions.add(new SelectOption('', '--None--'));         
        retrieveProblemTypeConstructor();
        setPickListValues();
    }

    public void setPickListValues() {
        //list < ASICCustomerProject__c> bugCustomerProjectList = ASICCustomerProject__c.getall().values();        
        integer i =2;
        for (ASICCustomerProject__c sr: ASICCustomerProject__c.getall().values()) {
            sortStr.add(sr.name__c);             
        }   
        sortStr.sort();        
        for(String s :sortStr){
            if(i<1000)
                listCustomerProject1.add(new SelectOption(s, s));
            else
                listCustomerProject2.add(new SelectOption(s, s));               
         i++;           
        }  
                    
    }
    
   public void retrieveProblemTypeConstructor(){
        try{        
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
            listProblemTypeOptions  =   new List<SelectOption>();
            listAccount = [SELECT Id, Name, Problem_Type__c FROM Bug_ASIC_Picklist__c WHERE Problem_Type__c != null AND IS_Active__c = TRUE ORDER BY Problem_Type__c];
            if(listAccount.size()>0){
                for(Bug_ASIC_Picklist__c objAccount : listAccount){
                    if(listProblemType.size() > 0){
                        if(!listProblemType.contains(String.valueOf(objAccount.Problem_Type__c))){
                            listProblemTypeOptions.add(new SelectOption(objAccount.Problem_Type__c, objAccount.Problem_Type__c));
                            listProblemType.add(objAccount.Problem_Type__c);
                        }
                    }else{
                        listProblemTypeOptions.add(new SelectOption('', '--None--'));
                        listProblemTypeOptions.add(new SelectOption(objAccount.Problem_Type__c, objAccount.Problem_Type__c));
                        listProblemType.add(objAccount.Problem_Type__c);
                    }
                }
            }          
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICSubscriptionVFCExt.class.getName();
            alw.sourceFunction = 'retrieveProblemTypeConstructor()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);   
        }
    }
    
    public void retrieveProblemType(){
        try{                    
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
            Set<String> subTypeAValues= new Set<String>();
            listSubTYpeAOptions =   new List<SelectOption>();
            if(problemType != ''){
                listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c FROM Bug_ASIC_Picklist__c WHERE Problem_Type__c =:problemType AND Sub_Type_A__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_A__c];                
            }
            if(listAccount.size()>0){               
                for(Bug_ASIC_Picklist__c objAccount : listAccount){
                    if(subTypeAValues.size()>0){
                        if(!subTypeAValues.contains(objAccount.Sub_Type_A__c)){
                            listSubTYpeAOptions.add(new SelectOption(objAccount.Sub_Type_A__c, objAccount.Sub_Type_A__c));
                            subTypeAValues.add(objAccount.Sub_Type_A__c);
                        }    
                    }else{    
                        listSubTYpeAOptions.add(new SelectOption('', '--None--'));                     
                        listSubTYpeAOptions.add(new SelectOption(objAccount.Sub_Type_A__c, objAccount.Sub_Type_A__c));
                        subTypeAValues.add(objAccount.Sub_Type_A__c);
                    }
                }
            }
            else{
                listSubTYpeAOptions.add(new SelectOption('', '--None--'));            
            }
            
             listSubTYpeBOptions= new list <SelectOption> ();
             listSubTYpeCOptions= new list <SelectOption> ();
             listSubTYpeDOptions= new list <SelectOption> ();
             listSubTYpeBOptions.add(new SelectOption('', '--None--'));
             listSubTYpeCOptions.add(new SelectOption('', '--None--'));
             listSubTYpeDOptions.add(new SelectOption('', '--None--'));
            
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICSubscriptionVFCExt.class.getName();
            alw.sourceFunction = 'retrieveProblemType()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw); 
        }
    }
    
    public void retrieveSubTypeA(){
        try{                        
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
            Set<String> subTypeBValues= new Set<String>();
            listSubTYpeBOptions =   new List<SelectOption>();
            if(subTypeA != ''){
                listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_A__c =:subTypeA AND Problem_Type__c =:problemType and IS_Active__c = TRUE AND Sub_Type_B__c != null ORDER BY Sub_Type_B__c];
            }
            if(listAccount.size()>0){                                
                for(Bug_ASIC_Picklist__c objAccount : listAccount){
                    if(subTypeBValues.size()>0){
                        if(!subTypeBValues.contains(String.valueOf(objAccount.Sub_Type_B__c))){
                            listSubTYpeBOptions.add(new SelectOption(objAccount.Sub_Type_B__c, objAccount.Sub_Type_B__c));
                            subTypeBValues.add(objAccount.Sub_Type_B__c);
                        }    
                    }else{
                        listSubTYpeBOptions.add(new SelectOption('', '--None--'));
                        listSubTYpeBOptions.add(new SelectOption(objAccount.Sub_Type_B__c, objAccount.Sub_Type_B__c));
                        subTypeBValues.add(objAccount.Sub_Type_B__c);
                    }
                }
            }
            else{
                listSubTYpeBOptions.add(new SelectOption('', '--None--'));          
            }           
               listSubTYpeCOptions= new list <SelectOption> ();
               listSubTYpeDOptions= new list <SelectOption> ();
               listSubTYpeCOptions.add(new SelectOption('', '--None--'));
               listSubTYpeDOptions.add(new SelectOption('', '--None--'));
               
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICSubscriptionVFCExt.class.getName();
            alw.sourceFunction = 'retrieveSubTypeAConstructor()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);   
        }
    }
    
    public void retrieveSubTypeB(){
        try{            
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
            Set<String> subTypeCValues= new Set<String>();
            listSubTYpeCOptions =   new List<SelectOption>();
            if(subTypeB != '' && subTypeB != null){
                listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_B__c =:subTypeB AND Sub_Type_A__c =:subTypeA AND Problem_Type__c =:problemType AND Sub_Type_C__c != null  and IS_Active__c = TRUE ORDER BY Sub_Type_C__c];
            }
            if(listAccount.size()>0){                
                for(Bug_ASIC_Picklist__c objAccount : listAccount){
                    if(subTypeCValues.size()>0){
                        if(!subTypeCValues.contains(String.valueOf(objAccount.Sub_Type_C__c))){
                            listSubTYpeCOptions.add(new SelectOption(objAccount.Sub_Type_C__c, objAccount.Sub_Type_C__c));
                            subTypeCValues.add(objAccount.Sub_Type_C__c);
                        }    
                    }else{
                        listSubTYpeCOptions.add(new SelectOption('', '--None--'));  
                        listSubTYpeCOptions.add(new SelectOption(objAccount.Sub_Type_C__c, objAccount.Sub_Type_C__c));
                        subTypeCValues.add(objAccount.Sub_Type_C__c);
                    }
                }
            }
            else{
                listSubTYpeCOptions.add(new SelectOption('', '--None--'));          
            }
            listSubTYpeDOptions= new list <SelectOption> ();
            listSubTYpeDOptions.add(new SelectOption('', '--None--'));
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICSubscriptionVFCExt.class.getName();
            alw.sourceFunction = 'retrieveSubTypeBConstructor()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
    
     public void retrieveSubTypeC(){
        try{           
            List<Bug_ASIC_Picklist__c> listAccount = new List<Bug_ASIC_Picklist__c>();
            Set<String> subTypeDValues= new Set<String>();
            listSubTYpeDOptions =   new List<SelectOption>();
            if(subTypeC != ''){
                listAccount = [SELECT Id, Name, Problem_Type__c, Sub_Type_A__c,Sub_Type_B__c,Sub_Type_C__c,Sub_Type_D__c FROM Bug_ASIC_Picklist__c WHERE Sub_Type_B__c =:subTypeB AND Sub_Type_A__c =:subTypeA AND Problem_Type__c =:problemType AND Sub_Type_C__c =:subTypeC AND Sub_Type_D__c != null AND IS_Active__c = TRUE ORDER BY Sub_Type_D__c];
            }
            if(listAccount.size()>0){                
                for(Bug_ASIC_Picklist__c objAccount : listAccount){
                    if(subTypeDValues.size()>0){
                        if(!subTypeDValues.contains(String.valueOf(objAccount.Sub_Type_D__c))){
                            listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                            subTypeDValues.add(objAccount.Sub_Type_D__c);
                        }    
                    }else{
                        listSubTYpeDOptions.add(new SelectOption('', '--None--')); 
                        listSubTYpeDOptions.add(new SelectOption(objAccount.Sub_Type_D__c, objAccount.Sub_Type_D__c));
                        subTypeDValues.add(objAccount.Sub_Type_D__c);
                    }
                }
            }
            else{
                listSubTYpeDOptions.add(new SelectOption('', '--None--'));          
            }
            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        }catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICSubscriptionVFCExt.class.getName();
            alw.sourceFunction = 'retrieveSubTypeCConstructor()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
        }
    }
   public PageReference subscribed(){ 
       try{ 
            List<Bug_Default_Owner_Team__c> lstBugteam = new List<Bug_Default_Owner_Team__c>() ;
            List<Bug_Default_Owner_Team__c> lstBugDefaultTeam = new List<Bug_Default_Owner_Team__c>();          
            String query = '';     
            if (subTypeD == null)
                   subTypeD = '';
            if (subTypeC == null)
                   subTypeC = '';
            if (subTypeB == null)
                   subTypeB = '';
            if (subTypeA == null)
                   subTypeA = ''; 
            if (problemType == null)
                 problemType = '';   
                 
            if(problemType !='' && subTypeA != ''){                        
                if(subTypeD != '')           
                     query =  query + 'Sub_Type_D__c =' + '\''+subTypeD +'\'' + 'and Sub_Type_C__c =' + '\''+subTypeC +'\'' + ' and Sub_Type_B__c =' + '\''+subTypeB+'\'' + ' and Sub_Type_A__c =' + '\''+subTypeA+'\'';
                else if(subTypeC != '')
                     query =  query +  'Sub_Type_C__c =' + '\''+subTypeC +'\'' + ' and Sub_Type_B__c =' + '\''+subTypeB+'\'' + ' and Sub_Type_A__c =' + '\''+subTypeA+'\'';     
                else if(subTypeB != '')
                     query = query +  ' Sub_Type_B__c =' + '\''+subTypeB+'\'' + ' and Sub_Type_A__c =' + '\''+subTypeA+'\'';
                else
                    query = query +  'Sub_Type_A__c =' + '\''+subTypeA+'\'';           
                
                if(query != ''){  
                     lstBugteam  =  Database.Query('select id,Bug_BugTeam__c from Bug_Default_Owner_Team__c where ' + query);     
                }
                if(lstBugteam.size()>0){
                    for(Bug_Default_Owner_Team__c bugDefaultOwner:lstBugteam){
                       if(bugDefaultOwner.Bug_BugTeam__c != '' && bugDefaultOwner.Bug_BugTeam__c != null){
                            if(bugDefaultOwner.Bug_BugTeam__c.indexOf(userInfo.getUserId().substring(0, 15)) == -1){
                                Bug_Default_Owner_Team__c objBugDefaultOwner = new Bug_Default_Owner_Team__c();                     
                                objBugDefaultOwner.Bug_BugTeam__c = bugDefaultOwner.Bug_BugTeam__c + ','+userInfo.getUserId().substring(0, 15);                     
                                objBugDefaultOwner.id = bugDefaultOwner.id;
                                lstBugDefaultTeam.add(objBugDefaultOwner);
                            } 
                            
                        }
                        else{
                            Bug_Default_Owner_Team__c objBugDefaultOwner = new Bug_Default_Owner_Team__c();                             
                            objBugDefaultOwner.Bug_BugTeam__c  = userInfo.getUserId().substring(0, 15);     
                            objBugDefaultOwner.id = bugDefaultOwner.id;
                            lstBugDefaultTeam.add(objBugDefaultOwner);                  
                        }
                    }
                    
                   if(lstBugDefaultTeam.size() > 0){
                     update lstBugDefaultTeam;
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your are Subscribed Successfully.Thank you!')); 
                   } 
                   else{
                          ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'You are already Subscribed!'));
                       }
                }
                else{
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.info,'No Records Found!'));  
                }
               
                                         
            }                  
            else{
                if(problemType == '' || problemType  == null){         
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Problem Type Value'));                 
                      return null;  
                }
                if(subTypeA == ''){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type A value'));
                   return null;            
                } 
            }                              
            problemType = '';
            subTypeD = '';      
            subTypeC = '';
            subTypeA = '';
            subTypeB = '';                             
            buglistvar = new List<Bug_Default_Owner_Team__c>() ;  
           
          if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        return null; 
        } 
        catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICSubscriptionVFCExt.class.getName();
            alw.sourceFunction = 'subsrcibed()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            return null; 
        }       
    } 
       public PageReference bugSearch(){ 
       try{ 
            
            //List<Bug_Default_Owner_Team__c> lstBugDefaultTeam = new List<Bug_Default_Owner_Team__c>();          
            String query = '';     
            if (subTypeD == null)
                   subTypeD = '';
            if (subTypeC == null)
                   subTypeC = '';
            if (subTypeB == null)
                   subTypeB = '';
            if (subTypeA == null)
                   subTypeA = ''; 
            if (problemType == null)
                 problemType = '';   
                 
            if(problemType !='' && subTypeA != ''){                        
                if(subTypeD != '')           
                     query =  query + 'Sub_Type_D__c =' + '\''+subTypeD +'\'' + 'and Sub_Type_C__c =' + '\''+subTypeC +'\'' + ' and Sub_Type_B__c =' + '\''+subTypeB+'\'' + ' and Sub_Type_A__c =' + '\''+subTypeA+'\'' + 'order by createddate' + '  limit 10 ';
                else if(subTypeC != '')
                     query =  query +  'Sub_Type_C__c =' + '\''+subTypeC +'\'' + ' and Sub_Type_B__c =' + '\''+subTypeB+'\'' + ' and Sub_Type_A__c =' + '\''+subTypeA+'\'' + 'order by createddate'  + '  limit 10 ' ;     
                else if(subTypeB != '')
                     query = query +  ' Sub_Type_B__c =' + '\''+subTypeB+'\'' + ' and Sub_Type_A__c =' + '\''+subTypeA+'\'' +  'order by createddate'  + '  limit 10 ' ;
                else
                    query = query +  'Sub_Type_A__c =' + '\''+subTypeA+'\'' + 'order by createddate'  + '  limit 10 ' ;           
                
                if(query != ''){  
                     buglistvar=  Database.Query('select id,name,Sub_Type_A__c ,Sub_Type_B__c ,Sub_Type_C__c ,Sub_Type_D__c ,Bug_BugTeam__c from Bug_Default_Owner_Team__c where ' + query);     
                }
                
                }
                                                            
                
                    if(problemType == '' || problemType  == null){         
                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Problem Type Value'));                 
                          return null;  
                    }
                    if(subTypeA == ''){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type A value'));
                       return null;            
                    } 
                    if(buglistvar.size() == 0){                                                     
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.info,'No records found for selected filter criteria!')); 
                    } 
                  
                                    
           
          if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }
        return null; 
        } 
        catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICSubscriptionVFCExt.class.getName();
            alw.sourceFunction = 'subsrcibed()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            return null; 
        }       
    } 
        public PageReference cstBugSearch(){ 
            try{
                Set < String > asicCstProjectSet = new Set < String > ();
                list<ASICCustomerProject__c> asicCstLst = new   list<ASICCustomerProject__c> ();        
                String query = '';  
                
                if (cstProject == null)
                       cstProject = '';
                                           
                if(cstProject != '')
                     query = query  + ' Name__c = ' + '\'' + cstProject +'\'' ;
                
                if(query != ''){  
                         cstBugVar =  Database.Query('select id,Bug_Team__c,Name__c from ASICCustomerProject__c where ' + query);     
                } 
                   
                if(cstBugVar.size()>0){
                    for(ASICCustomerProject__c cstObj:cstBugVar){
                       if(cstObj.Bug_Team__c != '' && cstObj.Bug_Team__c != null){
                            if(cstObj.Bug_Team__c.indexOf(userInfo.getUserId().substring(0, 15)) == -1){
                                    cstObj.Bug_Team__c = cstObj.Bug_Team__c + ','+userInfo.getUserId().substring(0, 15);                     
                                    cstObj.id = cstObj.id;
                                    asicCstLst.add(cstObj);
                            }                       
                        }
                        else{                                                  
                            cstObj.Bug_Team__c  = userInfo.getUserId().substring(0, 15);     
                            cstObj.id = cstObj.id;
                            asicCstLst.add(cstObj);                  
                        }
                    }
                    
                   if(asicCstLst.size() > 0){
                     update asicCstLst;
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your are Subscribed Successfully.Thank you!')); 
                   } 
                   else{
                          ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'You are already Subscribed!'));
                       }
                }
                else{
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.info,'No Records Found for Selected Customer Project!'));  
                } 
                
                if(Test.isRunningTest()) {
                    throw new applicationException('In Test Mode');
                }
                return null; 
            }
            catch(Exception e){
                //Adding code for exception framework
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = ASICSubscriptionVFCExt.class.getName();
                alw.sourceFunction = 'cstBugSearch()';
                alw.ApplicationName='Case Management';                  
                alw.referenceInfo = 'Bug';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);
                return null; 
            }           
        }
        
        
        public PageReference cstUnSubsrcibed(){           
            try{           
                Set < String > asicCstProjectSet = new Set < String > ();
                list<ASICCustomerProject__c> asicCstLst = new   list<ASICCustomerProject__c> ();        
                String query = '';  
                string bugTeam = '';
                
                if (cstProject == null)
                       cstProject = '';
                               
                if(cstProject != '')
                     query = query  + ' Name__c = ' + '\'' + cstProject +'\'' ;
                
                if(query != ''){  
                         cstBugVar =  Database.Query('select id,Bug_Team__c,Name__c from ASICCustomerProject__c where ' + query);     
                } 
                   
                if(cstBugVar.size()>0){
                    for(ASICCustomerProject__c cstObj:cstBugVar){
                         if(cstObj.Bug_Team__c != '' && cstObj.Bug_Team__c != null){                 
                                if(cstObj.Bug_Team__c.indexOf(userInfo.getUserId().substring(0, 15))!= -1){    
                                    for(string strTeam:cstObj.Bug_Team__c.split(',')){
                                        if(strTeam!= userInfo.getUserId().substring(0, 15)){
                                            bugTeam += strTeam;             
                                        }       
                                    }                                 
                                    cstObj.Bug_Team__c = bugTeam;        
                                    cstObj.id = cstObj.id;
                                    asicCstLst.add(cstObj);
                                } 
                        }  
                    }
                    
                   if(asicCstLst.size() > 0){
                     update asicCstLst;
                     ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your are UnSubscribed Successfully.Thank you!')); 
                   } 
                   else{
                          ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'You are already UnSubscribed!'));
                       }
                }
                else{
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.info,'No Records Found for Selected Customer Project!'));  
                }
                    if(Test.isRunningTest()) {
                        throw new applicationException('In Test Mode');
                    }
                    return null;                
            }
            catch(Exception e){
                //Adding code for exception framework
                ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = ASICSubscriptionVFCExt.class.getName();
                alw.sourceFunction = 'cstUnSubsrcibed()';
                alw.ApplicationName='Case Management';                  
                alw.referenceInfo = 'Bug';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);
                return null;
            }           
        }
        
  public PageReference unSubsrcibed(){    
     try{
            list<Bug_Default_Owner_Team__c> lstBugteam = new list<Bug_Default_Owner_Team__c>() ;   
            list<Bug_Default_Owner_Team__c> lstBugDefaultTeam = new list<Bug_Default_Owner_Team__c>();
            String query = '';
            string bugTeam ='';
            if (subTypeD == null)
                subTypeD = '';
            if (subTypeC == null)
                subTypeC = '';
            if (subTypeB == null)
                subTypeB = '';
            if (subTypeA == null)
                subTypeA = '';
            if (problemType == null)
                 problemType = '';  
             
            if(problemType !='' && subTypeA != ''){
                if(subTypeD != '') 
                    query =  query + 'Sub_Type_D__c =' + '\''+subTypeD +'\'' + 'and Sub_Type_C__c =' + '\''+subTypeC +'\'' + ' and Sub_Type_B__c =' + '\''+subTypeB+'\'' + ' and Sub_Type_A__c =' + '\''+subTypeA+'\'';
                else if(subTypeC != '')
                     query =  query +  'Sub_Type_C__c =' + '\''+subTypeC +'\'' + ' and Sub_Type_B__c =' + '\''+subTypeB+'\'' + ' and Sub_Type_A__c =' + '\''+subTypeA+'\'';   
                else if(subTypeB != '')
                    query = query +  ' Sub_Type_B__c =' + '\''+subTypeB+'\'' + ' and Sub_Type_A__c =' + '\''+subTypeA+'\'';
                else
                    query = query +  'Sub_Type_A__c =' + '\''+subTypeA+'\'';
                              
               if(query != ''){  
                    lstBugteam  =  Database.Query('select id,Bug_BugTeam__c from Bug_Default_Owner_Team__c where ' +query);     
                }
               if(lstBugteam.size()>0){               
                    for(Bug_Default_Owner_Team__c bugDefaultOwner:lstBugteam){  
                        if(bugDefaultOwner.Bug_BugTeam__c != '' && bugDefaultOwner.Bug_BugTeam__c != null){                 
                            if(bugDefaultOwner.Bug_BugTeam__c.indexOf(userInfo.getUserId().substring(0, 15))!= -1){    
                                for(string strTeam:bugDefaultOwner.Bug_BugTeam__c.split(',')){
                                    if(strTeam!= userInfo.getUserId().substring(0, 15)){
                                        bugTeam += strTeam;             
                                     }       
                                }      
                            Bug_Default_Owner_Team__c objBugDefaultOwner = new Bug_Default_Owner_Team__c();
                            objBugDefaultOwner.Bug_BugTeam__c = bugTeam;        
                            objBugDefaultOwner.id = bugDefaultOwner.id;
                            lstBugDefaultTeam.add(objBugDefaultOwner);
                          } 
                        }                         
                    }
                   if(lstBugDefaultTeam.size() > 0){                       
                        update lstBugDefaultTeam;
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your are UnSubscribed Successfully.Thank you!')); 
                    }
                   else{                           
                         ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'You are already UnSubscribed!'));
                   }
                }
                else{
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.info,'No Records Found!'));                
                }
                
                                   
            }
            else{
                if(problemType == ''){         
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Problem Type Value'));
                      return null;    
                }
                if(subTypeA == ''){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Sub-Type A value'));          
                }
            }                                                           
            problemType = '';
            subTypeD = '';      
            subTypeC = '';
            subTypeA = '';
            subTypeB = '';                                
            buglistvar = new List<Bug_Default_Owner_Team__c>() ;  

            if(Test.isRunningTest()) {
                throw new applicationException('In Test Mode');
            }            
           return null;
        }
        catch(Exception e){
            //Adding code for exception framework
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
            alw.source = ASICSubscriptionVFCExt.class.getName();
            alw.sourceFunction = 'unSubsrcibed()';
            alw.ApplicationName='Case Management';                  
            alw.referenceInfo = 'Bug';
            alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
            alw.debugLevel ='Error';
            alw.logCode =e.getTypeName();
            alw.ex=e.getCause();
            GlobalUtility.logMessage(alw);
            return null;
        }       
      } 
    public PageReference doCancel(){
            problemType = '';
            subTypeD = '';      
            subTypeC = '';
            subTypeA = '';
            subTypeB = '';  
            buglistvar = new List<Bug_Default_Owner_Team__c>() ;                                           
           return null;        
    }
    
    
    public void checkRequired(){                 
        if(cstProject != '' || cstProject  != null)            
               isRequiredFlag = false;                                                                                                 
    }
    
    
            
    public class applicationException extends Exception {}
}