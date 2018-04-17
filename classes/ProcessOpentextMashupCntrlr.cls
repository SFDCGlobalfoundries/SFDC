/*
    Author: Ariz Solito
    Description: Apex class controller for the VF ProcessOpentextMashup
    History: 
        Asolito     14082014    - Code creation.
*/
public class ProcessOpentextMashupCntrlr {
    public String mashupURL {get; set;} 
    public String openTextLoginServerURL {get; set;}
    public Process__c process {get; set;}

    public ProcessOpentextMashupCntrlr(ApexPages.StandardController ctrl){
        this.mashupURL = EnvironmentVariable.get('PROCESS_OPENTEXT_MASHUP_URL');
        if(!test.isRunningTest()){
            ctrl.addFields(new List<String>{
                    'main_design_rule__c',
                    'frame_table_spec__c',
                    'drc_runset__c',
                    'EPSpec__c',
                    'ETSpec__c',
                    'main_generation_rule_spec__c',
                    'generation_rule_spec__c',
                    'process_flow_runsheet_spec__c',
                    'interconnect_spec__c',
                    'spice_model__c',
                    'design_rule__c'
                }
            );
        }
        this.process = (Process__c)ctrl.getRecord();                
        
        //check if internal user or external
                
        String portalLoginUser = null;
        User userObj = [SELECT accountId,FederationIdentifier,Portal_Login__c,UserType FROM User WHERE Id =:userInfo.getUserId()];
        
        if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess'){
            portalLoginUser = userObj.Federationidentifier ;   
        }
        
        this.openTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;  
        
        if(UtilsString.isNotBlank(this.process.main_design_rule__c)){
            this.mashupURL += this.process.main_design_rule__c +'|';   
        }
        
        if(UtilsString.isNotBlank(this.process.frame_table_spec__c)){
            this.mashupURL += this.process.frame_table_spec__c +'|';   
        }
        
        if(UtilsString.isNotBlank(this.process.drc_runset__c)){
            for(String s: this.process.drc_runset__c.split('\\;')){
                this.mashupURL += s +'|';   
            }            
        }
        
        if(UtilsString.isNotBlank(this.process.EPSpec__c)){
            this.mashupURL += this.process.EPSpec__c +'|';   
        }
        
        if(UtilsString.isNotBlank(this.process.ETSpec__c)){
            this.mashupURL += this.process.ETSpec__c +'|';   
        }
        
        if(UtilsString.isNotBlank(this.process.main_generation_rule_spec__c)){
            this.mashupURL += this.process.main_generation_rule_spec__c +'|';   
        }
        
        if(UtilsString.isNotBlank(this.process.generation_rule_spec__c)){
            this.mashupURL += this.process.generation_rule_spec__c +'|';   
        }
        
        if(UtilsString.isNotBlank(this.process.process_flow_runsheet_spec__c)){
            this.mashupURL += this.process.process_flow_runsheet_spec__c +'|';   
        }
        
        if(UtilsString.isNotBlank(this.process.interconnect_spec__c)){
            this.mashupURL += this.process.interconnect_spec__c +'|';   
        }
        
        if(UtilsString.isNotBlank(this.process.spice_model__c)){
            for(String s: this.process.spice_model__c.split('\\;')){
                this.mashupURL += s +'|';   
            }            
        } 
        
        if(UtilsString.isNotBlank(this.process.design_rule__c)){
            this.mashupURL += this.process.design_rule__c +'|';   
        }      
              
        this.mashupURL += '&username=' + portalLoginUser;    
    }
    
    
}