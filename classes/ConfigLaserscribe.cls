/**
*   Class:  ConfigLaserscribe 
*-----------------------------------------------------------------------------------------------------------------------------------
*   Author: Ashwini Basavaraj
*   Description: This is the controller class for Config_Frontside_Laserscribe Page. 
*                 This page is designed to get all the Frontside laserscribe features.
*
*   History:
*       Ashwini     11042015     - code creation.
*       Prachi      23052017     - Added Frontside Laserscribe conditions
        Sunita      24112017     - Made changes for Case 00082630 and 00068808**/
 
public with sharing class ConfigLaserscribe {
    public Apttus_Proposal__Proposal__c config_plus{get; set;}
    public List<Configurator_Plus_Question__c> masterRec{get; set;} // Configurator Plus Master question List
    public List<Configurator_Plus_Response__c> responselist{get; set;} // Configurator Plus Response List - to be save
    public List<Configurator_Plus_Response__c> responselist1{get; set;} // Configurator Plus Response List - to be displayed
    
    ApexPages.StandardController controller;
    //public Boolean showedit{get; set;} // Variable: Whether to show edit button
    //public Boolean makero{get; set;} // Variable: Whether to make read only
    public String options {get;set;} // Variable: Options 
    public String show{get; set;} // Variable: Whether to Show
    public List<wrapperlaserscribe> quesWrapper{get; set;} // Wrapper variable : to be used in the page to displayed all the options.
    public Map<Id,string> mastermap = new Map<Id,string>(); // Master map of responses 
    public Map<String,string> mastermap1 = new Map<String,string>(); // Master map of responses 
    public Map<String,string> additionalResponsemap = new Map<String,string>(); // Additional Response map 
    public Map<String,List<String>> servantmap = new Map<String,List<String>>();
    
    //Modified By: Prachi, 23 May 2017 -- Start
    public boolean isPolymideOpeningGF{get;set;}
    public boolean isPolymideOpeningOSAT{get;set;}
    public boolean isPackgOptionWirebond{get;set;}
    public boolean isPackagingOptionFlipChip{get;set;}
    
    /*----new variable-----------------------------------------*/
     public string isfrontside{get;set;}
     public string isstandard{get;set;}
     public static string freeofPSPI{get;set;}
     public List<Configurator_Plus_Question__c> masterRec_new{get; set;}
     public Map<Id,string> mastermap_new = new Map<Id,string>(); // Master map of responses 
     public Map<String,string> mastermap1_new = new Map<String,string>(); // Master map of responses 
     public List<wrapperlaserscribe_new> quesWrapper_new{get; set;} // Wrapper variable : to be used in the page to displayed all the options.
     public Map<String,List<String>> servantmap_new = new Map<String,List<String>>();
     public List<Configurator_Plus_Response__c> responselist1_new{get; set;} // Configurator Plus Response List - to be displayed
     public Map<String,string> additionalResponsemap_new = new Map<String,string>(); // Additional Response map 
     public List<wrapperlaserscribe_new1> quesWrapper_new1{get; set;}
    /*----------------------------------------------------------*/
    public static final string CONFIGURATOR_PLUS_RESPONSE = 'Frontside Laserscribe needed?';
    private Map<String,Packaging_Option_Polymide_Opening__c> custSetMap;
    //Modified By: Prachi, 23 May 2017 -- END
    public ConfigLaserscribe(ApexPages.StandardController controller) {
        this.controller = controller;
        this.responselist1 = new List<Configurator_Plus_Response__c>();
        this.responselist1_new = new List<Configurator_Plus_Response__c>();
        show = '';
        //showedit = false;
        //makero = false;
        isPolymideOpeningGF = false;
        isPolymideOpeningOSAT = false;
        isPackagingOptionFlipChip = false;
        config_plus = (Apttus_Proposal__Proposal__c)controller.getRecord();
        quesWrapper = new List<wrapperlaserscribe>();
        quesWrapper_new = new List<wrapperlaserscribe_new>();
        quesWrapper_new1 = new List<wrapperlaserscribe_new1>();
        //isstandard=null;
        //Modified By: Prachi, 23 May 2017 -- Start
        //config_plus = [Select id, recordtype.DeveloperName From Apttus_Proposal__Proposal__c Where id =:this.config_plus.id];   
        config_plus = [Select id, recordtype.DeveloperName,Front_Side_Laser_Scribe_Required__c, Polymide_Opening__c, APTPS_Packaging_Option__c From Apttus_Proposal__Proposal__c Where id =:this.config_plus.id];   
        
        
        if(config_plus.APTPS_Packaging_Option__c=='Wirebond')
        {
        freeofPSPI='Wirebond';
        }
        else if(config_plus.APTPS_Packaging_Option__c=='Flip Chip')
        {
         freeofPSPI='Flip Chip';
        }
        system.debug('freeofPSPI###'+freeofPSPI);
        Boolean isFrontSideLaserScribereq = false;
        for(Configurator_Plus_Response__c CPR:[SELECT id,Name__c, Response__c FROM Configurator_Plus_Response__c WHERE Configurator_Plus__c=:config_plus.id AND Name__c=:CONFIGURATOR_PLUS_RESPONSE Limit 1]){
            if(string.isNotBlank(CPR.Response__c) && 'Yes'.equalsIgnoreCase(CPR.Response__c)){
               isFrontSideLaserScribereq = true;
               isfrontside='true';
            }
            else if(string.isNotBlank(CPR.Response__c) && 'No'.equalsIgnoreCase(CPR.Response__c)){
             isfrontside='false';
            }
        }
        for(Configurator_Plus_Response__c CPR:[SELECT id,Name__c, Response__c FROM Configurator_Plus_Response__c WHERE Configurator_Plus__c=:config_plus.id AND Name__c='Are below GLOBALFOUNDRIES standard settings to be used?' Limit 1]){
            if(string.isNotBlank(CPR.Response__c) && 'Yes'.equalsIgnoreCase(CPR.Response__c)){
               
               isstandard='true';
            }
            else if(string.isNotBlank(CPR.Response__c) && 'No'.equalsIgnoreCase(CPR.Response__c)){
             isstandard='false';
            }
            
        }
        
        system.debug('isstandard%%%'+isstandard);
        custSetMap = Packaging_Option_Polymide_Opening__c.getall();
        
        
        evaluateFlags(isFrontSideLaserScribereq);
        
        //Modified By: Prachi, 23 May 2017 -- END
        
        
        masterRec = new List<Configurator_Plus_Question__c>();
        masterRec_new =new List<Configurator_Plus_Question__c>();
       
       masterRec = [Select id, name, Question_Name__c,Active__c,Sequence__c,(Select id, Picklist_Values__c  From Configurator_Plus_Picklist_Values__r) From Configurator_Plus_Question__c Where (Question_Type__c= 'Frontside-Laserscribe' and Active__c=true and (Question_Name__c='Frontside Laserscribe needed?' or Question_Name__c='Are below GLOBALFOUNDRIES standard settings to be used?')) Order by Sequence__c];
       
       masterRec_new = [Select id, name, Question_Name__c,Active__c,Sequence__c,(Select id, Picklist_Values__c  From Configurator_Plus_Picklist_Values__r) From Configurator_Plus_Question__c Where (Question_Type__c= 'Frontside-Laserscribe' and Active__c=true and (Question_Name__c!='Frontside Laserscribe needed?' and Question_Name__c!='Are below GLOBALFOUNDRIES standard settings to be used?')) Order by Sequence__c];
       
      system.debug('masterRec ^^^'+masterRec );
       system.debug('masterRec1 ^^^'+masterRec_new ); 
        if(!masterRec.isEmpty()){
            List<String> tempStr = new List<String>();
            List<String> tempStr1 = new List<String>();
            for(Configurator_Plus_Question__c master : masterRec){
                mastermap.put(master.id,master.Question_Name__c);
                for(Configurator_Plus_Picklist_Value__c child : master.Configurator_Plus_Picklist_Values__r){
                
                system.debug('child.Picklist_Values__c$$'+child.Picklist_Values__c);
                    tempStr.add(child.Picklist_Values__c);
                }
                tempStr1.addAll(tempStr);
                
                if(tempStr1.size() > 0){
                    quesWrapper.add(new wrapperlaserscribe(master.Question_Name__c,tempStr1,'','',''));
                    servantmap.put(master.Question_Name__c,tempStr1);
                }else{
                    quesWrapper.add(new wrapperlaserscribe(master.Question_Name__c,null,'','',''));
                    servantmap.put(master.Question_Name__c,null);
                }     
                tempStr1 = new List<String>(); 
                tempStr.clear();
            }
         
        }
        
        if(!masterRec_new.isEmpty()){
            List<String> tempStr_new = new List<String>();
            List<String> tempStr1_new = new List<String>();
            for(Configurator_Plus_Question__c master : masterRec_new){
                mastermap_new.put(master.id,master.Question_Name__c);
                for(Configurator_Plus_Picklist_Value__c child : master.Configurator_Plus_Picklist_Values__r){
                
                system.debug('child.Picklist_Values__c$$'+child.Picklist_Values__c);
                    tempStr_new.add(child.Picklist_Values__c);
                }
                tempStr1_new.addAll(tempStr_new);
                
                if(tempStr1_new.size() > 0)
                {
                    quesWrapper_new.add(new wrapperlaserscribe_new(master.Question_Name__c,tempStr1_new,'','',''));
                    quesWrapper_new1.add(new wrapperlaserscribe_new1(master.Question_Name__c,tempStr1_new,'','',''));
                    
                    servantmap_new.put(master.Question_Name__c,tempStr1_new);
                }
                else{
                    quesWrapper_new.add(new wrapperlaserscribe_new(master.Question_Name__c,null,'','',''));
                    quesWrapper_new1.add(new wrapperlaserscribe_new1(master.Question_Name__c,null,'','',''));
                    
                    servantmap_new.put(master.Question_Name__c,null);
                }     
                tempStr1_new = new List<String>(); 
                tempStr_new.clear();
            }
         
        }
        
        this.responselist1 = [Select Id, Response__c, Question_ID__c, Name__c, Configurator_Plus__c, Configurator_Plus_Question__c, Response_Type__c, Additional_Response__c from Configurator_Plus_Response__c where Configurator_Plus__c =: config_plus.Id and Response_Type__c='Additional Requirement' and (Name__c='Frontside Laserscribe needed?' or Name__c='Are below GLOBALFOUNDRIES standard settings to be used?')];
        this.responselist1_new = [Select Id, Response__c, Question_ID__c, Name__c, Configurator_Plus__c, Configurator_Plus_Question__c, Response_Type__c, Additional_Response__c from Configurator_Plus_Response__c where Configurator_Plus__c =: config_plus.Id and Response_Type__c='Additional Requirement' and (Name__c!='Frontside Laserscribe needed?' and Name__c!='Are below GLOBALFOUNDRIES standard settings to be used?')];
        
     
        if(!responselist1.isEmpty()){
            for(Configurator_Plus_Response__c list2 : responselist1) {
                mastermap1.put(list2.Name__c, list2.Response__c);
                additionalResponsemap.put(list2.Name__c, list2.Additional_Response__c);
            }
            reteriveResponseValues(masterRec);
            
        }
        
        if(!responselist1_new.isEmpty()){
            for(Configurator_Plus_Response__c list2 : responselist1_new) {
                mastermap1_new.put(list2.Name__c, list2.Response__c);
                additionalResponsemap_new.put(list2.Name__c, list2.Additional_Response__c);
            }
            
            reteriveResponseValues_new(masterRec_new);
            
        }
        
    
    }  
    
    //Retrieving the saved values.   
    private void reteriveResponseValues(List<Configurator_Plus_Question__c> responselist1) {
        quesWrapper = new List<wrapperlaserscribe>();
        for(Configurator_Plus_Question__c list1 :  masterRec){  
                  
            quesWrapper.add(new wrapperlaserscribe(list1.Question_Name__c,servantmap.get(list1.Question_Name__c),mastermap1.get(list1.Question_Name__c),additionalResponsemap.get(list1.Question_Name__c),''));   
            
                  
        }
        
    }
    
     private void reteriveResponseValues_new(List<Configurator_Plus_Question__c> responselist1_new) {
        quesWrapper_new = new List<wrapperlaserscribe_new>();
        quesWrapper_new1 = new List<wrapperlaserscribe_new1>();
        for(Configurator_Plus_Question__c list1 :  masterRec_new){  
                  
            quesWrapper_new.add(new wrapperlaserscribe_new(list1.Question_Name__c,servantmap_new.get(list1.Question_Name__c),mastermap1_new.get(list1.Question_Name__c),additionalResponsemap_new.get(list1.Question_Name__c),''));   
            quesWrapper_new1.add(new wrapperlaserscribe_new1(list1.Question_Name__c,servantmap_new.get(list1.Question_Name__c),mastermap1_new.get(list1.Question_Name__c),additionalResponsemap_new.get(list1.Question_Name__c),''));   
            
                  
        }
        
        system.debug('quesWrapper_new1@@@'+quesWrapper_new1);
        
    }
   
   // Wrapper class defination.  
    public class wrapperlaserscribe{
        public String questions{get;set;}
        public List<selectOption> Picklistvalues{get;set;}
        public String option {get;set;}
        public List<String> Picklistoptions{get;set;}
        public String otherField{get;set;}
        public Boolean checkOther{get;set;}
        public String range{get;set;}
        
        
        
        public wrapperlaserscribe(String questions, List<String> Picklistoptions,String defaultvalue,String additonalResponse,String range) {  
            this.Picklistoptions= Picklistoptions;   
            this.questions = questions;
            checkOther = false;
            system.debug('defaultvalue $$$'+defaultvalue );
            if(defaultvalue <> null && defaultvalue <> '')
                this.option = defaultvalue;
            List<FrontSide_Laserscribe_errors__c> errorlist=[Select Error_Messages__c,name,Higher_range__c,Default_Value__c,
                                                                  Lower_range__c,Question_Name__c 
                                                                  from FrontSide_Laserscribe_errors__c];
          
            if(Picklistoptions!= null){                
                this.Picklistvalues = new List<selectOption>(); 
              
                this.Picklistvalues.add(new SelectOption('','--Select--'));
                for(string s : Picklistoptions){
                    this.Picklistvalues.add(new SelectOption(s,s));
                }
             
                if(defaultvalue == 'Yes'){
                        otherField = additonalResponse;
                        checkOther = true;
                }
            }
            
        }
    }
    public class wrapperlaserscribe_new{
        public String questions{get;set;}
        public List<selectOption> Picklistvalues{get;set;}
        public String option {get;set;}
        public List<String> Picklistoptions{get;set;}
        public String otherField{get;set;}
        public Boolean checkOther{get;set;}
        public String range{get;set;}
        
         
          
        public wrapperlaserscribe_new(String questions, List<String> Picklistoptions,String defaultvalue,String additonalResponse,String range) {  
            this.Picklistoptions= Picklistoptions;   
            this.questions = questions;
            checkOther = false;
         
            List<FrontSide_Laserscribe_errors__c> errorlist=[Select Error_Messages__c,name,Higher_range__c,Default_Value__c,
                                                                  Lower_range__c,Question_Name__c 
                                                                  from FrontSide_Laserscribe_errors__c];
             
             
            for(FrontSide_Laserscribe_errors__c error: errorlist)
            {   
                if(error.Question_Name__c ==questions)
                {
                this.range='Range-'+error.Lower_range__c+' to '+error.Higher_range__c;
                }
                
                if(error.Question_Name__c==questions && defaultvalue ==null)
                  {
                   
                    this.option =error.Default_Value__c;
                  }
                else if(error.Question_Name__c==questions && defaultvalue<>null)
                  {
                   
                   this.option=defaultvalue;
                  } 
                  else if(questions=='Laserscribe field free of PSPI?')
                  {
                   this.option=defaultvalue;
                  }                                                                                    
                                  
            }    
            if(Picklistoptions!= null){                
                this.Picklistvalues = new List<selectOption>();                
                this.Picklistvalues.add(new SelectOption('','--Select--'));
                for(string s : Picklistoptions){
                    this.Picklistvalues.add(new SelectOption(s,s));
                }
                if(defaultvalue == 'Yes'){
                        otherField = additonalResponse;
                        checkOther = true;
                }
            }
        }
    }
    
    /*----------------------------------------------------------------*/
     public class wrapperlaserscribe_new1{
        public String questions{get;set;}
        public List<selectOption> Picklistvalues{get;set;}
        public String option {get;set;}
        public List<String> Picklistoptions{get;set;}
        public String otherField{get;set;}
        public Boolean checkOther{get;set;}
        public String range{get;set;}
          
        public wrapperlaserscribe_new1(String questions, List<String> Picklistoptions,String defaultvalue,String additonalResponse,String range) {  
            this.Picklistoptions= Picklistoptions;   
            this.questions = questions;
            checkOther = false;
           
             if(Picklistoptions!= null)
                 {
                   /*-----------------------------------------------*/
                 if(freeofPSPI=='Wirebond' && questions=='Laserscribe field free of PSPI?')
                {   
                this.Picklistvalues = new List<selectOption>();        
                this.Picklistvalues.add(new SelectOption('','Yes'));
                this.option ='Yes'; 
                }
                else if(freeofPSPI=='Flip Chip' && questions=='Laserscribe field free of PSPI?')
                { 
                this.Picklistvalues = new List<selectOption>();            
                this.Picklistvalues.add(new SelectOption('','No'));
                this.option ='No'; 
                }
                }
            List<FrontSide_Laserscribe_errors__c> errorlist=[Select Error_Messages__c,name,Higher_range__c,Default_Value__c,
                                                                  Lower_range__c,Question_Name__c 
                                                                  from FrontSide_Laserscribe_errors__c];
             
             
        
            for(FrontSide_Laserscribe_errors__c error: errorlist)
              {
                if(error.Question_Name__c ==questions  && questions!='Laserscribe field free of PSPI?')
                {  
                 system.debug('enter1@@@'+questions);
                 if(Picklistoptions!= null)
                 {
                  system.debug('this.option@@@'+this.option);
                  this.Picklistvalues = new List<selectOption>(); 
                  this.Picklistvalues.add(new SelectOption('',error.Default_Value__c));
                  this.option =error.Default_Value__c; 
                  system.debug('this.option@@@'+this.option);
                 }
                 
                 else
                 {
                 this.option =error.Default_Value__c;
                 }
                }
              }   
                 
          }
        }  
    /*-------------------------------------------------------*/
    //save the form data.
    public PageReference  saveform(){       
        
        List<Configurator_Plus_Response__c> responsestoInsert = new list<Configurator_Plus_Response__c>();
        List<Configurator_Plus_Response__c> responsestoUpdate = new list<Configurator_Plus_Response__c>();
        Set<String> uniqueIds = new Set<String>();
        Set<String> uniqueIds_new = new Set<String>();
        boolean flag=false;
        If(responselist1!=null){
            for(Configurator_Plus_Response__c con : responselist1){
                uniqueIds.add(con.Question_ID__c);
            }
            
        }
        
        If(responselist1_new!=null){
            for(Configurator_Plus_Response__c con : responselist1_new){
                uniqueIds_new.add(con.Question_ID__c);
            }
        }
        
        for(Id masterid : mastermap.keyset()){
            Configurator_Plus_Response__c resp = new Configurator_Plus_Response__c();
            If(responselist1!=null){
                if(uniqueIds.contains(string.valueof(masterid)+'-'+string.valueof(config_plus.id))){                
                    for(Configurator_Plus_Response__c configResp : responselist1){
                        if(string.valueof(masterid)+'-'+string.valueof(config_plus.id) == configResp.Question_ID__c){
                            configResp.Configurator_Plus__c = config_plus.id;
                            configResp.Configurator_Plus_Question__c =masterid;
                            configResp.Name__c = mastermap.get(masterid);
                            configResp.Response_Type__c='Additional Requirement';
                            for(wrapperlaserscribe wrap: quesWrapper){
                                if(wrap.questions.equalsIgnoreCase(mastermap.get(masterid))){
                                    configResp.Response__c = wrap.option;
                                    configResp.Additional_Response__c = wrap.otherField;
                                    
                                }
                            }
                            responsestoUpdate.add(configResp);
                        }
                    }           
                } else{
                    resp.Configurator_Plus__c = config_plus.id;
                    resp.Configurator_Plus_Question__c =masterid;
                    resp.Name__c = mastermap.get(masterid);
                    resp.Response_Type__c='Additional Requirement';
                    resp.Question_ID__c = string.valueof(masterid)+'-'+string.valueof(config_plus.id);
                
                    for(wrapperlaserscribe wrap: quesWrapper){
                        if(wrap.questions.equalsIgnoreCase(mastermap.get(masterid))){
                            resp.Response__c = wrap.option;
                            resp.Additional_Response__c = wrap.otherField;
                            
                        }
                    }
                    responsestoInsert.add(resp); 
                }
            } else{
                resp.Configurator_Plus__c = config_plus.id;
                resp.Configurator_Plus_Question__c =masterid;
                resp.Name__c = mastermap.get(masterid);
                resp.Response_Type__c='Additional Requirement';
                resp.Question_ID__c = string.valueof(masterid)+'-'+string.valueof(config_plus.id);
            
                for(wrapperlaserscribe wrap: quesWrapper){
                    if(wrap.questions.equalsIgnoreCase(mastermap.get(masterid))){
                        resp.Response__c = wrap.option;
                        resp.Additional_Response__c = wrap.otherField;
                    }
                }
                responsestoInsert.add(resp);
            }
        }
        
        /*--------------------------------sunita----------------------------*/
          List<FrontSide_Laserscribe_errors__c> errorlist=[Select Error_Messages__c,name,Higher_range__c,Default_Value__c,
                                                                  Lower_range__c,Question_Name__c 
                                                                  from FrontSide_Laserscribe_errors__c];
          
          
          if(isstandard=='false')
          {
          for(Id masterid : mastermap_new.keyset()){
            Configurator_Plus_Response__c resp = new Configurator_Plus_Response__c();
            
            If(responselist1_new!=null){
                if(uniqueIds_new.contains(string.valueof(masterid)+'-'+string.valueof(config_plus.id))){                
                    for(Configurator_Plus_Response__c configResp : responselist1_new){
                        if(string.valueof(masterid)+'-'+string.valueof(config_plus.id) == configResp.Question_ID__c){
                            configResp.Configurator_Plus__c = config_plus.id;
                            configResp.Configurator_Plus_Question__c =masterid;
                            configResp.Name__c = mastermap_new.get(masterid);
                            configResp.Response_Type__c='Additional Requirement';
                            for(wrapperlaserscribe_new wrap: quesWrapper_new){
                                if(wrap.questions.equalsIgnoreCase(mastermap_new.get(masterid))){
                                    configResp.Response__c = wrap.option;
                                    configResp.Additional_Response__c = wrap.otherField;
                                    
                             /*----------------------------sunita---------------------------------------*/
                                    
                                    for(FrontSide_Laserscribe_errors__c error: errorlist)
                                    {
                                      
                                      
                                       /*----------------------------------------------------------*/
                                        if(error.Question_Name__c==wrap.questions && wrap.option <> null && wrap.option <> '' && error.Error_Messages__c<>null)
                                        {
                                         
                                            if((decimal.valueof(wrap.option)<error.Lower_range__c || decimal.valueof(wrap.option)>error.Higher_range__c))
                                            {
                                            
                                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,error.Error_Messages__c));
                                            flag=true;
                                            }
                                          }  
                                        
                                    
                                    }
                             /*-------------------------------------------------------------------------*/       
                                    
                                }
                            }
                            responsestoUpdate.add(configResp);
                        }
                    }           
                } else{
                    resp.Configurator_Plus__c = config_plus.id;
                    resp.Configurator_Plus_Question__c =masterid;
                    resp.Name__c = mastermap_new.get(masterid);
                    resp.Response_Type__c='Additional Requirement';
                    resp.Question_ID__c = string.valueof(masterid)+'-'+string.valueof(config_plus.id);
                
                    for(wrapperlaserscribe_new wrap: quesWrapper_new){
                        if(wrap.questions.equalsIgnoreCase(mastermap_new.get(masterid))){
                            resp.Response__c = wrap.option;
                            resp.Additional_Response__c = wrap.otherField;
                               /*----------------------------sunita---------------------------------------*/
                                for(FrontSide_Laserscribe_errors__c error: errorlist)
                                    {
                                      
                                    if(error.Question_Name__c==wrap.questions && wrap.option <> null && wrap.option <> '' && error.Error_Messages__c<>null)
                                    {
                                     
                                        if((decimal.valueof(wrap.option)<error.Lower_range__c || decimal.valueof(wrap.option)>error.Higher_range__c))
                                        {
                                        
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,error.Error_Messages__c));
                                        flag=true;
                                        }
                                      }  
                                    
                                    
                                    }
                             /*-------------------------------------------------------------------------*/       
                                  
                            
                        }
                    }
                    responsestoInsert.add(resp); 
                }
            } else{
                resp.Configurator_Plus__c = config_plus.id;
                resp.Configurator_Plus_Question__c =masterid;
                resp.Name__c = mastermap_new.get(masterid);
                resp.Response_Type__c='Additional Requirement';
                resp.Question_ID__c = string.valueof(masterid)+'-'+string.valueof(config_plus.id);
            
                for(wrapperlaserscribe_new wrap: quesWrapper_new){
                    if(wrap.questions.equalsIgnoreCase(mastermap_new.get(masterid))){
                        resp.Response__c = wrap.option;
                        resp.Additional_Response__c = wrap.otherField;
                    }
                     /*----------------------------sunita---------------------------------------*/
                               for(FrontSide_Laserscribe_errors__c error: errorlist)
                                    {
                                      
                                    if(error.Question_Name__c==wrap.questions && wrap.option <> null && wrap.option <> '' && error.Error_Messages__c<>null)
                                    {
                                     
                                        if((decimal.valueof(wrap.option)<error.Lower_range__c || decimal.valueof(wrap.option)>error.Higher_range__c))
                                        {
                                        
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,error.Error_Messages__c));
                                        flag=true;
                                        }
                                      }  
                                    
                                    
                                    }
                             /*-------------------------------------------------------------------------*/       
                                  
                }
                responsestoInsert.add(resp);
            }
        }
       
        }
        else if(isstandard=='true')
        {
        
        for(Id masterid : mastermap_new.keyset()){
            Configurator_Plus_Response__c resp = new Configurator_Plus_Response__c();
            
            If(responselist1_new!=null){
                if(uniqueIds_new.contains(string.valueof(masterid)+'-'+string.valueof(config_plus.id))){                
                    for(Configurator_Plus_Response__c configResp : responselist1_new){
                        if(string.valueof(masterid)+'-'+string.valueof(config_plus.id) == configResp.Question_ID__c){
                            configResp.Configurator_Plus__c = config_plus.id;
                            configResp.Configurator_Plus_Question__c =masterid;
                            configResp.Name__c = mastermap_new.get(masterid);
                            configResp.Response_Type__c='Additional Requirement';
                            for(wrapperlaserscribe_new1 wrap: quesWrapper_new1){
                                if(wrap.questions.equalsIgnoreCase(mastermap_new.get(masterid))){
                                    configResp.Response__c = wrap.option;
                                    configResp.Additional_Response__c = wrap.otherField;
                                    
                                    system.debug('configResp.Name__c##'+configResp.Name__c);
                                     system.debug('wrap.option##'+wrap.option);
                                     system.debug('configResp.Response__c##'+configResp.Response__c);
                             /*----------------------------sunita---------------------------------------*/
                                    
                                    for(FrontSide_Laserscribe_errors__c error: errorlist)
                                    {
                                      
                                      
                                       /*----------------------------------------------------------*/
                                        if(error.Question_Name__c==wrap.questions && wrap.option <> null && wrap.option <> '' && error.Error_Messages__c<>null)
                                        {
                                         
                                            if((decimal.valueof(wrap.option)<error.Lower_range__c || decimal.valueof(wrap.option)>error.Higher_range__c))
                                            {
                                            
                                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,error.Error_Messages__c));
                                            flag=true;
                                            }
                                          }  
                                        
                                    
                                    }
                             /*-------------------------------------------------------------------------*/       
                                    
                                }
                            }
                            responsestoUpdate.add(configResp);
                        }
                    }           
                } else{
                    resp.Configurator_Plus__c = config_plus.id;
                    resp.Configurator_Plus_Question__c =masterid;
                    resp.Name__c = mastermap_new.get(masterid);
                    resp.Response_Type__c='Additional Requirement';
                    resp.Question_ID__c = string.valueof(masterid)+'-'+string.valueof(config_plus.id);
                
                    for(wrapperlaserscribe_new1 wrap: quesWrapper_new1){
                        if(wrap.questions.equalsIgnoreCase(mastermap_new.get(masterid))){
                            resp.Response__c = wrap.option;
                            resp.Additional_Response__c = wrap.otherField;
                               /*----------------------------sunita---------------------------------------*/
                                for(FrontSide_Laserscribe_errors__c error: errorlist)
                                    {
                                      
                                    if(error.Question_Name__c==wrap.questions && wrap.option <> null && wrap.option <> '' && error.Error_Messages__c<>null)
                                    {
                                     
                                        if((decimal.valueof(wrap.option)<error.Lower_range__c || decimal.valueof(wrap.option)>error.Higher_range__c))
                                        {
                                        
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,error.Error_Messages__c));
                                        flag=true;
                                        }
                                      }  
                                    
                                    
                                    }
                             /*-------------------------------------------------------------------------*/       
                                  
                            
                        }
                    }
                    responsestoInsert.add(resp); 
                }
            } else{
                resp.Configurator_Plus__c = config_plus.id;
                resp.Configurator_Plus_Question__c =masterid;
                resp.Name__c = mastermap_new.get(masterid);
                resp.Response_Type__c='Additional Requirement';
                resp.Question_ID__c = string.valueof(masterid)+'-'+string.valueof(config_plus.id);
            
                for(wrapperlaserscribe_new1 wrap: quesWrapper_new1){
                    if(wrap.questions.equalsIgnoreCase(mastermap_new.get(masterid))){
                        resp.Response__c = wrap.option;
                        resp.Additional_Response__c = wrap.otherField;
                    }
                     /*----------------------------sunita---------------------------------------*/
                               for(FrontSide_Laserscribe_errors__c error: errorlist)
                                    {
                                      
                                    if(error.Question_Name__c==wrap.questions && wrap.option <> null && wrap.option <> '' && error.Error_Messages__c<>null)
                                    {
                                     
                                        if((decimal.valueof(wrap.option)<error.Lower_range__c || decimal.valueof(wrap.option)>error.Higher_range__c))
                                        {
                                        
                                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,error.Error_Messages__c));
                                        flag=true;
                                        }
                                      }  
                                    
                                    
                                    }
                             /*-------------------------------------------------------------------------*/       
                                  
                }
                responsestoInsert.add(resp);
            }
        }
        
        }
        /*--------------------------------------------------------------------*/
        
        If(responsestoUpdate!=null){
          if(flag==false)
          {
           try
           {
            //Database.saveResult[] sr = Database.update(responsestoUpdate,false);
           update responsestoUpdate;
            }
           catch(DmlException ex){

        ApexPages.addMessages(ex);

          }
            }
               
        }
        if(responsestoInsert != null){
        system.debug('responsestoInsert@@@@'+responsestoInsert);
        if(flag==false)
          {
            insert responsestoInsert;
            }
        }
        if(flag==false)
        {
        PageReference reRend = new PageReference('/' + config_plus.id);
        reRend.setRedirect(true);
        
        return reRend;
        }
        else
        {
        return null;
        }
    }
    
    // cancel functionality
    public PageReference cancel() {
        PageReference reRend = new PageReference('/' + config_plus.id);
        reRend.setRedirect(true);
        
        return reRend;
    }
   
    //Show new input field based on 'Others' selection in dropdown
    public pagereference setOtherField(){
       // isstandard=null;
        for(wrapperlaserscribe wl : quesWrapper){
            if(wl.Picklistoptions != null && wl.questions != null && wl.questions == CONFIGURATOR_PLUS_RESPONSE){
                Boolean currentFrontSideLaserScribeReqFlag = wl.option == 'Yes' ? true : false;
                evaluateFlags(currentFrontSideLaserScribeReqFlag);
            } 
                if(wl.option == 'Yes' &&  wl.questions == CONFIGURATOR_PLUS_RESPONSE)
                {
                  isfrontside ='true';
                      
                  break;
                }
                else if(wl.option == 'No' &&  wl.questions == CONFIGURATOR_PLUS_RESPONSE)
                
                {
                        
                 isfrontside ='false';
                 break;
                     
                 }
                 else
                {
                 isfrontside =null;
                }
                 
             }
                    
              for(wrapperlaserscribe wl : quesWrapper)
              {      
                 if(wl.option == 'Yes' &&  wl.questions == 'Are below GLOBALFOUNDRIES standard settings to be used?')
                { 
                  
                  isstandard='true';
                   break;
                }
                else if(wl.option == 'No' &&  wl.questions == 'Are below GLOBALFOUNDRIES standard settings to be used?')
                {
                    
                 //isfrontside =true;
                 isstandard='false';
                 break;
                }
                else
                {
                 isstandard=null;
                }
                
              
            }
          
            return null;
  
           
        
           }
    private void evaluateFlags(Boolean isFrontSideLaserScribereq){
        isPolymideOpeningGF = false;
        isPolymideOpeningOSAT = false;
        isPackagingOptionFlipChip = false;
        if(custSetMap.containsKey('GF') && custSetMap.containsKey('Wirebond') && custSetMap.containsKey('Flip Chip') && custSetMap.containsKey('OSAT') && custSetMap.containsKey('GF') && custSetMap.containsKey('Wirebond')){
            if(isFrontSideLaserScribereq && string.isNotBlank(config_plus.Polymide_Opening__c) && string.isNotBlank(config_plus.APTPS_Packaging_Option__c)&& config_plus.Polymide_Opening__c == custSetMap.get('GF').Value__c && config_plus.APTPS_Packaging_Option__c == custSetMap.get('Wirebond').Value__c){
              isPolymideOpeningGF = true;
            }

            else if(isFrontSideLaserScribereq && string.isNotBlank(config_plus.Polymide_Opening__c) && string.isNotBlank(config_plus.APTPS_Packaging_Option__c) && config_plus.Polymide_Opening__c== custSetMap.get('OSAT').Value__c && config_plus.APTPS_Packaging_Option__c == custSetMap.get('Wirebond').Value__c){
               isPolymideOpeningOSAT= true;
            }

            else if(isFrontSideLaserScribereq && string.isNotBlank(config_plus.Polymide_Opening__c) && string.isNotBlank(config_plus.APTPS_Packaging_Option__c)&& config_plus.Polymide_Opening__c== custSetMap.get('GF').Value__c && config_plus.APTPS_Packaging_Option__c == custSetMap.get('Flip Chip').Value__c){
              isPackagingOptionFlipChip = true;
            }
        }
    }
}