/*
    Author: Ariz Solito
    Description: Apex class controller for the VF ReferenceFlowDetail
    History: 
        Asolito     13062014    - Code creation.
        ARoy        08072014    - Code modified to add email functionality for Reference Flow Document Provisioning
                                  to FAE and AM.
*/
public class ReferenceFlowDetailCntrlr {
    final private static String ERROR_MESSAGE = Error_Codes__c.getInstance('REF_FLOW_NDA_ERR_MSG').Message__c;
    
    private String techFileId; 
    public String portalLoginUser;
    public String refFlowUrl {get; set;}
    public String OpenTextLoginServerURL {get; set;}
    public RecordDetail recordDetail {get; set;}
    public Boolean hasNDAAccess {get; set;}
    public Boolean isWhitePaper {get; set;}
    public Boolean isReferenceFlow {get; set;}
    User userObj = new User();    
    public Boolean isDocProvisioned {get; set;}
    public String emailProvRetMsg {get;set;} 
    
    public ReferenceFlowDetailCntrlr(){
        this.recordDetail = new RecordDetail();
        this.techFileId = ApexPages.currentPage().getParameters().get('id');
        this.hasNDAAccess = false;
        this.isReferenceFlow = false;
        this.isDocProvisioned = false;
        this.refFlowUrl = '';
        //this.emailProvRetMsg = '';
        
        //get the tech file        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Tech_File__c.FieldSets.Reference_Flow_Detail.getFields()) {
            query += f.getFieldPath() +', ';
        }
                
        query = query.substring(0,query.lastIndexOf(','));
        query += ' FROM Tech_File__c '+
                 ' WHERE id = :techFileId';
                 
        system.debug(query);                 
        
        String refFlowNum;         
        for(Tech_File__c t: database.query(query)){
            this.recordDetail.addTechFile(t);
            refFlowNum = t.name;                
        }
        
        //get the design spec
        String query2 = 'SELECT technology_geometry__c, ';
        for(Schema.FieldSetMember f : SObjectType.Design_Spec__c.FieldSets.Reference_Flow_Detail.getFields()) {
            query2 += f.getFieldPath() +', ';
        }
        
        query2 = query2.substring(0,query2.lastIndexOf(','));
        query2 += ' FROM Design_Spec__c '+
                 ' WHERE name = :refFlowNum';
        
        String techGeo;        
        for(Design_Spec__c d: database.query(query2)){
            this.recordDetail.addDesignSpec(d);
            
            if(UtilsString.isNotBlank(d.technology_geometry__c)){
                techGeo = d.technology_geometry__c.split('\\ ')[0];
            }
        } 
        
        //check if reference flow is white paper - not restriction
        if(refFlowNum.contains('WP')){
            this.hasNDAAccess = true;
            this.isWhitePaper = true;
            
        //check for NDA Access - digital and AMS reference flow            
        } else {            
            isReferenceFlow = true;
            for(User u: [SELECT contactId,contact.account.has_valid_NDA__c,contact.account.tech_geo_granted__c
                           FROM User
                           WHERE id = :userInfo.getUserId()]){
                
                //portal user           
                if(UtilsString.isNotblank(u.contactId)){
                    if(u.contact.account.has_valid_NDA__c){
                        if(UtilsString.isNotBlank(u.contact.account.tech_geo_granted__c)){
                            if(u.contact.account.tech_geo_granted__c.contains(techGeo)){
                                this.hasNDAAccess = true;
                            }
                        }
                    }
                //internal user                
                } else {
                    this.hasNDAAccess = true;
                }
            }
        }
        
        if(!this.hasNDAAccess){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ERROR_MESSAGE));
        }else if(this.recordDetail.tech != null && (this.recordDetail.tech.specification_type__c == 'Reference Flows' ||                 
                this.recordDetail.tech.specification_type__c == 'White Papers')){
                Boolean intUsrChk = false;
                // Getting the portal login user
                userObj = [SELECT accountId,FederationIdentifier,Portal_Login__c,UserType FROM User WHERE Id =:userInfo.getUserId()];
                if(userInfo.getusertype()=='CustomerSuccess' || userInfo.getusertype()=='PowerCustomerSuccess'){
                    portalLoginUser = userObj.Federationidentifier ;   
                }else{ 
                    portalLoginUser = null;
                    intUsrChk = true;
                } 
                portalLoginUser = userObj.Federationidentifier ; 
                // Prepare the open text server
                OpenTextLoginServerURL = System.Label.OTLoginServer+portalLoginUser;                
                
                if(this.recordDetail.tech.specification_type__c == 'Reference Flows'){
                    refFlowUrl = System.Label.Ref_Flow_OpenText_Url + this.recordDetail.tech.name + '&username=' + +portalLoginUser;
                } else if(this.recordDetail.tech.specification_type__c == 'White Papers'){
                    refFlowUrl = System.Label.White_Paper_OpenText_Url + this.recordDetail.tech.name + '&username=' + +portalLoginUser;
                }
                
                //AR 08072014 - Check whether the user has document provisioned - Start
                if(!intUsrChk){
                    List<Document_Provisioning__c> docProv = [ select  id
                                                               from    Document_Provisioning__c
                                                               where   Design_Spec__c = :this.recordDetail.design.Id
                                                               and     Status__c = 'Provisioned'
                                                               and     Final_User_Access__c = true
                                                               and     User__c = :UserInfo.getUserId()
                                                             ];
                    if(docProv.size()>0){
                        this.isDocProvisioned = true;
                    }
                }else{
                    this.isDocProvisioned = true;
                }
                // End
        }                                                                         
    }
    
    //AR 08072014 - Email to FAE and AM for Document Provisioning
    public void sendNotification(){
        List<String> userToList = new List<String>();
        Map<String,String> mergeFieldsMap = new Map<String,String>();
        String acctName = '';
        User usr = [select id, accountid from User where id=:UserInfo.getUserId()];
        for(Account_Team_Proxy__c atp : [select     id
                                                    , User_Email__c
                                                    , Account__r.Name
                                         from       Account_Team_Proxy__c
                                         where      Team_Role__c in ('Account Manager','Field Application Engineer','Primary Account Manager')
                                         and        Account__c = :usr.accountid
                                        ]){
            userToList.add(atp.User_Email__c);
            if(acctName == ''){
                acctName = atp.Account__r.Name;
            } 
        }
        mergeFieldsMap.put('##AccountName##', acctName);
        mergeFieldsMap.put('##ReferenceFlow##', this.recordDetail.tech.Name);
        try {
            Messaging.reserveSingleEmailCapacity(userToList.size());

            EmailTemplate emailTemp = [SELECT id from EmailTemplate where developername = 'CPQ_Reference_White_Paper_Provisioning'];
            
            List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage msg = EmailUtil.generateEmailTemplate(emailTemp.Id,
                                                                               this.recordDetail.tech.Id,
                                                                               null,
                                                                               userToList,
                                                                               null,
                                                                               mergeFieldsMap);
            msg.setToAddresses(userToList);           
                                                                                          
            if(userToList.size() > 0){
                lstMsgs.add(msg);
                Messaging.sendEmail(lstMsgs);                                                                                                             
            }
            this.emailProvRetMsg = 'success';              
        } catch (Exception e) {
            system.debug('Error in email sending to FAE and AM ==========> ' + e.getMessage());
            this.emailProvRetMsg = 'error';        
        }
    }
    // End

    public class RecordDetail {
        public Tech_File__c tech {get; set;}
        public Design_Spec__c design {get; set;}
    
        public RecordDetail(){}
        
        public void addTechFile(Tech_File__c tech){
            this.tech = tech;            
        }
        
        public void addDesignSpec(Design_Spec__c design){
            this.design = design;
        }
    }      
}