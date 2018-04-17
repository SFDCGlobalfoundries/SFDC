/*
    Author:        Ariz Solito
    Description:   Apex class for NPCGroupVF component.
    History: 
        Ariz Solito    10292013    - Apex code created            
*/

public class NPCGroupCtrl {
    private static final string OPPTY_PROG_TM_ROLE_CE = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_CE');
    private static final string OPPTY_PROG_TM_ROLE_FTS = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FTS');
    private static final string OPPTY_PROG_TM_ROLE_CS = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_CS');
    public String recID;
    
    public Boolean isHTML {get; set;}        
    public Boolean showCE {get; set;}
    public Boolean showFE {get; set;}
    public Boolean showCSR {get; set;}
    public NPCGroup groups {get; set;}   
        
    public String getRecID(){return this.recID;}
    
    public void setRecID(String recID){
        this.recID = recId;
        getMembers();
    } 
    
    private void getMembers(){  
        for(New_Part_Creation_Form__c n: [SELECT base_device__r.opportunity_program__c
                                            FROM New_Part_Creation_Form__c
                                            WHERE id = :this.recID]){   
                                            	           
            List<Opportunity_Program_Team_Member__c> members = [SELECT team_role__c,user_full_name__c,user_email__c,user__r.phone                                                           
                                                                  FROM Opportunity_Program_Team_Member__c
                                                                  WHERE opportunity_program__c = :n.base_device__r.opportunity_program__c];
            this.groups = new NPCGroup(members);
        }
    }
    
    public string newLine {
        get {return '\r\n';}
        set;
    }
    
    public class NPCGroup {
        public String CEDetails {get; set;}
        public String FEDetails {get; set;}
        public String CSRDetails {get; set;}                
    
        public NPCGroup(List<Opportunity_Program_Team_Member__c> members){
            addGroup(members);
        }
        
        private void addGroup(List<Opportunity_Program_Team_Member__c> members){
            this.CEDetails = '';
            this.FEDetails = '';
            this.CSRDetails = '';
            
            for(Opportunity_Program_Team_Member__c m : members){
                String userPhone;
                String memberDetails = '';
                if(m.user__r.phone <> null){
                    userPhone = ' ('+ m.user__r.phone + '), ';       
                }else{
                    userPhone = ','; 
                }
                
                if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_FTS)){
                    this.FEDetails += m.user_full_name__c + userPhone;
                } else if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_CE)){
                    this.CEDetails += m.user_full_name__c + userPhone;    
                } else if(m.team_role__c.contains(OPPTY_PROG_TM_ROLE_CS)){
                    this.CSRDetails += m.user_full_name__c + userPhone;
                }
            }
            
            this.CEDetails = this.CEDetails.removeEnd(',');
            this.FEDetails = this.FEDetails.removeEnd(',');
            this.CSRDetails = this.CSRDetails.removeEnd(',');            
        }            
    }                
}