/*
    Author: Ariz Solito
    Description: Reassign export control form page
    History:
        Asolito     10032013    - apex code created
        Asolito     10092013    - added fix for task 351
*/
public class ReassignExportControlCtrl {

    private static final String OPPTY_PROG_TM_ROLE_FTS = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FTS');
    private static final String OPPTY_PROG_TM_ROLE_FAE = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FAE');
    private static final String OPPTY_PROG_TM_ROLE_AM = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_AM');
    private static final String OPPTY_PROG_TM_ROLE_PAM = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PAM');
    
    private static final String NO_EXPORT_CONTROL = 'There are no available export control forms to be reassigned to this device record';
    private static final String EXPORT_CONTROL_APPROVED = 'This device already have Approved Export Control in place, it\'s not necessary to associate to another Export Control Form';
    private static final String INVALID_USER = 'The current user does not have access permission to reassign export control';
    private static final String NO_EXP_SELECTED = 'Please select an export control to be reassigned';
    private static final string TEMPLATE1 = 'Device Reassign Export Control';
    private static final string  GTC_ROLE = EnvironmentVariable.get('GTC_ROLE');
    private static final string  GF_GLOBAL_ADMIN = EnvironmentVariable.get('GF Global Admin');
    private static final string  GF_SYSTEM_ADMIN = EnvironmentVariable.get('GF System Admin');
    private static final string  SYS_ADMIN  = EnvironmentVariable.get('System Administrator');
    
    public Junction junction {get; set;}
    public Boolean showReassign {get; set;}
    private String recID;
    
    public ReassignExportControlCtrl(){
        //paramater will be coming from device - export control junction detail page custom button  
        String eID = ApexPages.currentPage().getParameters().get('eid');
        
        //parameter will be coming from device - export control junction custom list button under the Device
        String dID = ApexPages.currentPage().getParameters().get('did'); 
        this.showReassign = false;
        this.junction = new Junction(dID,eID); 
        
        if(UtilsString.isNotBlank(eID)){
            this.recID = eID;
        } else if(UtilsString.isNotBlank(dID)){
            this.recID = dID;
        }
    }
    

    public PageReference init(){
        String result = checkReassign();
        
        if(result == null){
            if(this.junction.recordList.size() > 0){
              //show the device list
                this.showReassign = true;
            } else {
                ApexPages.addmessage(
                    new ApexPages.Message(ApexPages.severity.WARNING,NO_EXPORT_CONTROL));
            }
        } else {            
            ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.WARNING,result));
        }
        return null;
    }
                    
    public PageReference save(){       
        this.junction.save();          
        return new PageReference('/' +this.recId); 
    }
    
    public PageReference cancel(){
        return new PageReference('/'+this.recId);
    }
    
    private String checkReassign(){
        //check if export control is not yet completed
        if(this.junction.rec.export_control_form__r.status__c == 'Approved'){
            return EXPORT_CONTROL_APPROVED;
        }              
                      
        //check if user profile is valid
        Boolean isValidUser = false;
        for(Opportunity_Program_Team_Member__c o : [SELECT team_role__c,user__c, Is_FAE__c
                                                      FROM Opportunity_Program_Team_Member__c 
                                                      WHERE opportunity_program__c =  :this.junction.rec.device__r.opportunity_program__c]){
            if((o.team_role__c.contains(OPPTY_PROG_TM_ROLE_FTS) || 
                o.team_role__c.contains(OPPTY_PROG_TM_ROLE_FAE) ||
                (o.team_role__c.contains(OPPTY_PROG_TM_ROLE_AM) && o.Is_FAE__c == TRUE) ||
                (o.team_role__c.contains(OPPTY_PROG_TM_ROLE_PAM) && o.Is_FAE__c == TRUE) ) &&
                 o.user__c == userInfo.getUserId()){
                isValidUser = true;
            }                                                                    
        } 
        
        //check if current user is GTC or Admin
        Boolean isGTC = false;
        Boolean isAdmin = false;
        for(User u : [SELECT userRole.name,profile.name FROM User WHERE id = :userInfo.getUserId()]){
            if(u.userRole.name == GTC_ROLE){
                isGTC = true;
            } 
            
            if(u.profile.name == SYS_ADMIN || u.profile.name == GF_GLOBAL_ADMIN || u.profile.name == GF_SYSTEM_ADMIN){
                isAdmin = true;
            }           
        }    
        
        if(isValidUser || isGTC || isAdmin){
            return null;
        }          
        
        return INVALID_USER;        
    }
    
    public class Junction {
        public Device_Export_Control_Junction__c rec;  
        public List<Record> recordList {get; set;} 
        private Device__c dev;
        
        
        public Junction(String deviceId,String exportControlId){
            String query = 'SELECT id,device__c,device__r.id,export_control_form__c,export_control_form__r.status__c, '+
                           '       device__r.account__c,device__r.opportunity_program__c,device__r.reassigned_export_control__c, '+
                           '       device__r.approve_reassign_export_control_number__c,device__r.export_control_status__c '+
                           '  FROM Device_Export_Control_Junction__c ';
                                       
            if(UtilsString.isNotBlank(deviceId)){
                query += ' WHERE device__c = \''+ deviceId + '\'';
            } else if(UtilsString.isNotBlank(exportControlId)){
                query += ' WHERE export_control_form__c = \''+ exportControlId + '\'';
            }
            
            List<Device_Export_Control_Junction__c> recs = database.query(query);
            String accountId;            
            for(Device_Export_Control_Junction__c r: recs){
                this.rec = r;
                this.dev = r.device__r;
                accountId = r.device__r.account__c;
            }                       
            
            this.recordList = new List<Record>();
            for(Device_Export_Control_Junction__c r :[SELECT export_control_form__r.id,export_control_form__r.status__c,
                                                             export_control_form__r.d1_national_access_is_allowed__c,
                                                             export_control_form__r.customer_trade_compliance_contact_person__c,
                                                             export_control_form__r.lastModifiedBy.name,export_control_form__r.name
                                                        FROM Device_Export_Control_Junction__c
                                                        WHERE device__r.account__c = :accountId
                                                        AND export_control_form__c <> :this.rec.export_control_form__c]){
                if(r.export_control_form__r <> null){                                                        
                    this.recordList.add(new Record(r.export_control_form__r));                                                                        
                }
            }                                                                    
        }              
        
        public Boolean save(){
            for(Record r: this.recordList){
                if(r.isPicked){                                
                    try {                        
                        this.dev.reassigned_export_control__c = r.exp.id;
                        update this.dev;
                    } catch (Exception e){
                        System.debug(e);
                    }
                    if(r.exp.status__c == 'Approved'){
                        sendEmail(this.dev.id);                        
                    } else {
                        ReassignExportControl.processReassign(this.dev);
                    }
                    return true;
                }
            }
            return false;
        }
        
        //Method will send email notification to the GTC and FE thru custom button Reassign Export Control in Device
        private void sendEmail(String deviceID){
            
            //get gtc users
            List<String> GTCEmails = new List<String>();
            for(User u : [SELECT email FROM User WHERE userRole.name = :GTC_ROLE]){
                GTCEmails.add(u.email);
            }
            
                
            List<Messaging.SingleEmailMessage> msgs = new List<Messaging.SingleEmailMessage>();
            EmailTemplate temp1 = [SELECT id FROM EmailTemplate WHERE name = :TEMPLATE1];                            
            
            if(GTCEmails.size() > 0){        
                Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(temp1.id,
                                                                                   deviceID,
                                                                                   null,
                                                                                   GTCEmails,
                                                                                   new list<string>{Userinfo.getuseremail()},
                                                                                   null);
                                                                                                   
                try {
                    if(msg <> null){
                        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{msg});
                    }
                } catch(Exception e){
                    System.debug(e);
                }
            }
        }                   
    }       
    
    public class Record {
        public Boolean isPicked {get; set;}
        public Boolean isApproved {get; set;}
        public String expName {get; set;}
        public String status {get; set;}
        public String D1Access {get; set;}
        public String contactPerson {get; set;}
        public String modifiedBy {get; set;}
        public Export_Control_Form__c exp;
        
        public Record(Export_Control_Form__c  exp){
            this.exp = exp;
            this.isPicked = false;
            this.isApproved = exp.status__c == 'Approved' ? true : false;
            this.expName = exp.name;
            this.D1Access = exp.d1_national_access_is_allowed__c;
            this.status = exp.status__c;
            this.contactPerson = exp.customer_trade_compliance_contact_person__c;
            this.modifiedBy = exp.lastModifiedBy.name;
        }    
    }        
}