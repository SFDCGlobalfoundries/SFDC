/*
    Author: Ariz Solito
    Description: Apex class for IP declaration form matching
    History: 
    Asolito      06252013    - Apex coded created
    Asolito      07042013    - Added IP and VCID Override processes
    Asolito      09052013    - Modified matching batch job to handle Next Matching Process flag
    Asolito      10082013    - Added stage filter = Design In the matching process 
    Asolito      10102013    - added fix for task 430
    Asolito      10132013    - added fix for task 433
    Nbustillos   10172013    - Updated logic to update IPDeclaration first before matching result.
                             - Added condition to check if email object is null. If so do not send email.
    Asolito      10312013    - Added "send to martinistore" checkbox field as enhancement for TASK 489
    Nbustillos   110/2013    - Updated VCID matching email recipient to only DE team members. 
                             - Added logic to only send if there are recipients for VCID matching email.
    Asolito      11202013    - Added code to set the status of the IP declaration record to "Approved" if
                               matching status = "Matched"
    Asolito      12092013    - Added vendor field population on the IP matching result for override by IP process     
    Asolito      01072014    - Added auto approval process for overriden IPs                                                                                              
*/
global class IPDeclarationMatching {
    public static Boolean hasMatchingRun = false;
    
    private static final string OPPTY_PROG_TM_ROLE_DE = EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_DE');
    
    //Method will be called via JS to update next matching process checkbox
    webservice static String setToNextMatchingProcess(String recordID){
        List<IP_Declaration_Form__c> updateRecs = new List<IP_Declaration_Form__c>();
         
        for(IP_Declaration_Form__c c: [SELECT next_matching_process__c 
                                         FROM IP_Declaration_Form__c
                                         WHERE id = :recordID]){
            c.next_matching_process__c = true;
            updateRecs.add(c);                                  
        }    
        try {
            update updateRecs;
            return 'success';
        } catch(Exception e){
            System.debug(e);            
        }
        return 'error';
    }
                        
    //Method will do IP override this will be called via a custom button thru a VF page
    public static String overrideIP(List<String> IPDeclarationFormIDs){
        IPMatching IPMatch = new IPMatching(); 
        
        //set the conversion to only run once on a given process instance
        if(!Test.isRunningTest()){
            hasMatchingRun = true;
        }
                
        for(IP_Declaration_Form__c i: [SELECT id,name,status__c,device__r.requested_process_id__r.name,CRM_Device_ID__c,
                                              device__r.account__r.customer_number__c,device__r.account__r.short_name__c,
                                              ownerID__c,other_3rd_party_ip__c,device__r.account__r.primary_contact__c, 
                                              device__r.opportunity_program__c,device__r.account__r.primary_contact__r.email,
                                              matching_status__c,
                                              (SELECT id,vendor__c,tech_type__c,tech_geometry__c,design_ID__c,ip_component__c,
                                                      ip_type_desc__c,ip_type__c,oic_ip_component__c,ip_vcid_override__c
                                                 FROM IP_Declaration_Component__r)
                                         FROM IP_Declaration_Form__c
                                         WHERE id IN :IPDeclarationFormIDs]){
            IPMatch.addRow(i);                                                                                              
        }                               
                                              
        //do a matching on the ip declaration forms and VCID components
        return IPMatch.overrideIP();              
    }   
    
    //Method will do VCID override this will be called via a custom button thru a VF page   
    public static String overrideVCID(List<String> IPDeclarationFormIDs){
        List<String> CRMDIDs = new List<String>();
        List<String> processIDs = new List<String>();
        IPMatching IPMatch = new IPMatching(); 
        
        //set the conversion to only run once on a given process instance
        if(!Test.isRunningTest()){
            hasMatchingRun = true;
        }
                
        for(IP_Declaration_Form__c i: [SELECT id,name,status__c,device__r.requested_process_id__r.name,CRM_Device_ID__c,
                                              device__r.account__r.customer_number__c,device__r.account__r.short_name__c,
                                              ownerID__c,other_3rd_party_ip__c,device__r.opportunity_program__c,
                                              device__r.account__r.primary_contact__r.email,device__r.account__r.primary_contact__c,
                                              matching_status__c,
                                              (SELECT id,vendor__c,tech_type__c,tech_geometry__c,design_ID__c,ip_component__c,
                                                      ip_type_desc__c,ip_type__c,oic_ip_component__c,ip_vcid_override__c
                                                 FROM IP_Declaration_Component__r)
                                         FROM IP_Declaration_Form__c
                                         WHERE id IN :IPDeclarationFormIDs]){
            IPMatch.addRow(i);
            CRMDIDs.add(i.CRM_Device_ID__c);
            //processIDs.add(i.device__r.requested_process_id__r.name);                                                                                           
        }
        
        List<IP_VCID_Component__c> VCIDs = [SELECT CRM_DID__c,library__c,process_ID__c,vendor__c,program__c,technology_geometry__c,
                                                   oic_ip_component__c,customer__c                                                 
                                              FROM IP_VCID_Component__c
                                              WHERE CRM_DID__c IN :CRMDIDs
                                              /*AND process_ID__c IN :processIDs*/];
        //add the VCIDs
        IPMatch.addVCIDs(VCIDs);
            
        //do matching on the ip declaration form and VCID components
        return IPMatch.overrideVCID();                        
    }
    
    //Method will do a matching process to the ip declaration form and VCID components
    //called from the IP Declaration component trigger
    public static void processMatching(Set<String> IPDeclarationFormIDs){
        List<String> processRecIds = new List<String>();
        processRecIDs.addAll(IPDeclarationFormIDs);
        
        processMatching(processRecIDs); 
    }
    
    //Method will do a matching process to the ip declaration form and VCID components
    //called by IP Declaration trigger  
    public static void processMatching(List<String> IPDeclarationFormIDs){
        List<String> CRMDIDs = new List<String>();
        List<String> processIDs = new List<String>();   
        IPMatching IPMatch = new IPMatching();  
        Boolean canDoMatching = false;  
        
        //set the conversion to only run once on a given process instance
        if(!Test.isRunningTest()){
            hasMatchingRun = true;
        }
        
        System.debug('Process IP Matching IDs :'+IPDeclarationFormIDs);
        
        for(IP_Declaration_Form__c i: [SELECT id,name,status__c,device__r.requested_process_id__r.name,CRM_Device_ID__c,
                                              device__r.account__r.customer_number__c,device__r.account__r.short_name__c,
                                              ownerID__c,other_3rd_party_ip__c,device__r.opportunity_program__c,
                                              device__r.account__r.primary_contact__c,device__r.account__r.primary_contact__r.email,
                                              matching_status__c,
                                              (SELECT id,vendor__c,tech_type__c,tech_geometry__c,design_ID__c,ip_component__c,
                                                      ip_type_desc__c,ip_type__c,oic_ip_component__c,ip_vcid_override__c
                                                 FROM IP_Declaration_Component__r)
                                         FROM IP_Declaration_Form__c
                                         WHERE id IN :IPDeclarationFormIDs
                                         /*AND status__c IN('Pending Reconciliation','Draft','Submitted','Pending Resubmission','Undeclared')*/
                                         AND next_matching_process__c = false]){
            IPMatch.addRow(i);                                          
            CRMDIDs.add(i.CRM_Device_ID__c);
            //processIDs.add(i.device__r.requested_process_id__r.name);
            
            //Call matching process if there are is at least 1 IP Declaration Form record to match
            canDoMatching = true;                                                   
        }       
        
        if(canDoMatching){
            List<IP_VCID_Component__c> VCIDs = [SELECT CRM_DID__c,library__c,process_ID__c,vendor__c,program__c,technology_geometry__c,
                                                       oic_ip_component__c,customer__c                                                 
                                                  FROM IP_VCID_Component__c
                                                  WHERE CRM_DID__c IN :CRMDIDs
                                                  /*AND process_ID__c IN :processIDs*/];
    
            //add the VCIDs
            IPMatch.addVCIDs(VCIDs);
            
            //clear the current IP Matching Result
            IPMatch.clearAllIPMatchingRecords();                                                                    
                                              
            //do a matching on the ip declaration forms and VCID components
            IPMatch.doMatching();
        }       
    }       
    
    //Method will do a matching process to the ip declaration form and VCID components
    //called by IP Declaration batch    
    public static void batchProcessMatching(List<String> IPDeclarationFormIDs){
        List<String> CRMDIDs = new List<String>();
        List<String> processIDs = new List<String>();   
        IPMatching IPMatch = new IPMatching();  
        Boolean canDoMatching = false;  
        
        //set the conversion to only run once on a given process instance
        if(!Test.isRunningTest()){
            hasMatchingRun = true;
        }
        
        for(IP_Declaration_Form__c i: [SELECT id,name,status__c,device__r.requested_process_id__r.name,CRM_Device_ID__c,
                                              device__r.account__r.customer_number__c,device__r.account__r.short_name__c,
                                              ownerID__c,other_3rd_party_ip__c,device__r.opportunity_program__c,
                                              device__r.account__r.primary_contact__c,device__r.account__r.primary_contact__r.email,
                                              next_matching_process__c,
                                              (SELECT id,vendor__c,tech_type__c,tech_geometry__c,design_ID__c,ip_component__c,
                                                      ip_type_desc__c,ip_type__c,oic_ip_component__c,ip_vcid_override__c
                                                 FROM IP_Declaration_Component__r)
                                         FROM IP_Declaration_Form__c
                                         WHERE id IN :IPDeclarationFormIDs
                                         AND status__c IN('Pending Reconciliation','Draft','Submitted','Pending Resubmission','Undeclared')]){                    
            IPMatch.addRow(i);                                          
            CRMDIDs.add(i.CRM_Device_ID__c);
            //processIDs.add(i.device__r.requested_process_id__r.name);                                                    
        }       
             
        //Call matching process if there are is at least 1 IP Declaration Form record to match
        if(CRMDIDs.size() > 0){
            canDoMatching = true;
        }  
        
        System.debug('To process CRMDIDs '+CRMDIDs);                                                 
        System.debug('To process process IDs '+processIDs);
                
        if(canDoMatching){
            List<IP_VCID_Component__c> VCIDs = [SELECT CRM_DID__c,library__c,process_ID__c,vendor__c,program__c,technology_geometry__c,
                                                       oic_ip_component__c,customer__c                                                 
                                                  FROM IP_VCID_Component__c
                                                  WHERE CRM_DID__c IN :CRMDIDs
                                                  /*AND process_ID__c IN :processIDs*/];
    
            //add the VCIDs
            IPMatch.addVCIDs(VCIDs);
            
            //clear the current IP Matching Result
            IPMatch.clearAllIPMatchingRecords();                                                                    
                                              
            //do a matching on the ip declaration forms and VCID components
            IPMatch.doBatchMatching();
        }       
    }                   
    
    //Sub class for the matching process
    public class IPMatching {
        public List<IPDeclaration> IPDeclarations;
        private List<String> IPDeclarationIDs;      
        private List<IP_Form_Matching_Result__c> matchResults;
        private List<IP_Declaration_Form__c> updateIPDecs;
        private List<String> opptyProgramIDs;   
        
        public IPMatching(){
            this.IPDeclarations = new List<IPDeclaration>();
            this.IPDeclarationIDs = new List<String>();   
            this.matchResults = new List<IP_Form_Matching_Result__c>();
            this.updateIPDecs = new List<IP_Declaration_Form__c> ();
            this.opptyProgramIDs = new List<String>();          
        }
        
        //Method will add IP Declaration Form records
        public void addRow(IP_Declaration_Form__c dec){
            this.IPDeclarations.add(new IPDeclaration(dec));
            this.IPDeclarationIDs.add(dec.id);
            this.opptyProgramIDs.add(dec.device__r.opportunity_program__c);
        }
        
        //Method will add VCID records      
        //Filter VCIDs with the same CRMDID to the corresponding 
        //IP Declaration Form records
        public void addVCIDs(List<IP_VCID_Component__c> VCIDs){
           for(IP_VCID_Component__c v: VCIDs){
                for(IPDeclaration i: this.IPDeclarations){                  
                    if(i.dec.CRM_Device_ID__c == v.CRM_DID__c){
                        i.addVCID(v);   
                    }
                }
            }                          
        } 
        
        //Method will delete the existing IP Matching Result records
        public void clearAllIPMatchingRecords(){
            List<IP_Form_Matching_Result__c> recs = new List<IP_Form_Matching_Result__c>([
                SELECT id
                  FROM IP_Form_Matching_Result__c
                  WHERE ip_declaration_form__c IN :this.IPDeclarationIDs                  
            ]);     
            delete recs;    
        }
        
        //Method will do IP Matching override by IP
        public String overrideIP(){                     
            for(IPDeclaration i: this.IPDeclarations){      
                List<IP_Form_Matching_Result__c> currResult = i.overrideIP();
                
                if(currResult.size() > 0){
                    this.updateIPDecs.add(i.dec);
                    this.matchResults.addAll(currResult);
                }
            }   
            
            //insert match results and send emails to matched ip declaration forms
            try {                                
                if(matchResults.size() > 0){                                        
                    //delete existing IP matching results
                    clearAllIPMatchingRecords();
                    
                    // to support integration with martinistore, IP must be updated first
                    update this.updateIPDecs;
                    insert this.matchResults;
                    sendEmail();
                    
                    return 'success';
                } 
            } catch (Exception e){
                System.debug(e);
                return 'exception';
            }   
            return 'failed';
        }
        
        //Method will do IP Matching override by VCID
        public String overrideVCID(){       
            List<IP_Declaration_Component__c> newComps = new List<IP_Declaration_Component__c>();
            List<IP_Declaration_Component__c> updateComps = new List<IP_Declaration_Component__c>();
            List<IP_Declaration_Component__c> deleteComps = new List<IP_Declaration_Component__c>();
            
            System.debug('To process IP Dec for override '+this.IPDeclarations);            
            for(IPDeclaration i: this.IPDeclarations){                                                              
                List<IP_Form_Matching_Result__c> currResult = i.overrideVCID();
                System.debug('Override VCID lists for processing '+currResult);    
                
                if(currResult.size() > 0){
                    this.updateIPDecs.add(i.dec);
                    this.matchResults.addAll(currResult);                                       
                } 
                
                Map<String,List<IP_Declaration_Component__c>> tempComps = i.generateIPCompFromVCID();
                if(tempComps.containsKey('insert')){
                    newComps.addAll(tempComps.get('insert'));
                }
                
                if(tempComps.containsKey('update')){
                    updateComps.addAll(tempComps.get('update'));
                }
                
                if(tempComps.containsKey('delete')){
                    deleteComps.addAll(tempComps.get('delete'));
                }
                
                
            }   
            
            //insert match results and send emails to matched ip declaration forms
            try {              
                if(this.matchResults.size() > 0){
                    //delete existing IP matching results
                    clearAllIPMatchingRecords();
                    
                    // to support integration with martinistore, IP must be updated first
                    update this.updateIPDecs;
                    insert this.matchResults;
                    
                    insert newComps;                               
                    update updateComps;           
                    delete deleteComps;
                    
                    sendEmail();
                    
                    return 'success';
                } 
            } catch (Exception e){
                System.debug(e);
                return 'exception';
            }   
            return 'failed';                    
        }
        
        //Method will do normal IP Matching via batch
        public void doBatchMatching(){
            for(IPDeclaration i: this.IPDeclarations){
                this.matchResults.addAll(i.doMatching());
                i.dec.next_matching_process__c = false;
                this.updateIPDecs.add(i.dec);           
            }   
            
            System.debug('Processed Records '+this.matchResults);
            
            //insert match results and send emails to matched ip declaration forms
            try {
                // to support integration with martinistore, IP must be updated first
                update this.updateIPDecs;
                insert this.matchResults;
                sendEmail();
            } catch (Exception e){
                System.debug(e);
            }
        }
        
        //Method will do normal IP Matching
        public void doMatching(){
            for(IPDeclaration i: this.IPDeclarations){
                this.matchResults.addAll(i.doMatching());
                this.updateIPDecs.add(i.dec);           
            }   
            
            System.debug('Processed Records '+this.matchResults);
            //insert match results and send emails to matched ip declaration forms
            try {
                // to support integration with martinistore, IP must be updated first
                update this.updateIPDecs;
                insert this.matchResults;
                sendEmail();
            } catch (Exception e){
                System.debug(e);
            }
        }
        
        //Method will send emails to the customer, FE and DE
        public void sendEmail(){
            Map<String,List<User>> opptyMemberEmails = new Map<String,List<User>>(); 
            for(Opportunity_Program_Team_Member__c o: [SELECT user__r.name,user__r.email,opportunity_program__c
                                                         FROM Opportunity_Program_Team_Member__c
                                                         WHERE opportunity_program__c IN :this.opptyProgramIDs
                                                         and team_role__c like :(OPPTY_PROG_TM_ROLE_DE + '%')]){
                if(opptyMemberEmails.containsKey(o.opportunity_program__c)){
                    opptyMemberEmails.get(o.opportunity_program__c).add(o.user__r);
                } else {
                    opptyMemberEmails.put(o.opportunity_program__c,new List<User>{o.user__r});
                }                                       
            }                                                           

            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
            List<User> lstUsers = new List<User>();
            for(IPDeclaration i: this.IPDeclarations){              
                if(opptyMemberEmails.containsKey(i.dec.device__r.opportunity_program__c)){
                    lstUsers = opptyMemberEmails.get(i.dec.device__r.opportunity_program__c);
                    // Check if there are recipients
                    if(lstUsers.size()>0){
                        Messaging.SingleEmailMessage emailMsg = i.generateEmail(lstUsers);
                        // Check if Email Messge is blank
                        if(emailMsg!=null){
                            emails.add(emailMsg);
                        }
                    }
                }
            }
            
            try {
                if(!Test.isRunningTest()){
                    
                    if(emails.size()>0){
                        Messaging.reserveSingleEmailCapacity(lstUsers.size());
                        Messaging.sendEmail(emails);
                    }
                }
            } catch(Exception e){
                System.debug('Failed email sending. ' + e.getMessage());
            }
        }                       
    }
    
    //Sub class to store and process matching of ip declaration forms
    public class IPDeclaration {
        private IP_Declaration_Form__c dec;
        private Map<String,IP_Declaration_Component__c> components; 
        private Map<String,IP_VCID_Component__c> VCIDs; 
        public Boolean matched;
        
        public IPDeclaration(IP_Declaration_Form__c dec){
            this.dec = dec;
            this.matched = true;
            this.components = new Map<String,IP_Declaration_Component__c>();
            this.VCIDs = new Map<String,IP_VCID_Component__c>();
            
            for(IP_Declaration_Component__c d: dec.IP_Declaration_Component__r){
                this.components.put(d.id,d);    
            }                                   
        }
        
        //Method will add VCID records for matching
        //the VCID passed here matches to the IP Declaration form's CRMDID and Process ID
        public void addVCID(IP_VCID_Component__c v){
            Boolean isDuplicate = false;
            for(String key : this.VCIDs.keySet()){
                IP_VCID_Component__c i = this.VCIDs.get(key);
                if(i.oic_ip_component__c == v.oic_ip_component__c){
                    isDuplicate = true;
                    break;
                }
            }
            
            if(!isDuplicate){                    
                this.VCIDs.put(v.id,v);
            }
        }   
        
        //Method will generate email for the matching results
        public Messaging.SingleEmailMessage generateEmail(List<User> users){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            //get the email templates
            EmailTemplate template = [SELECT id from EmailTemplate where name = 'IP Declaration Matching Result'];                      
            List<String> emailAddresses = new List<String>();
            for(User u: users){
                if(UtilsString.isNotBlank(u.email)){            
                    emailAddresses.add(u.email);
                }
            }                                  
            return EmailUtil.generateEmailTemplate(template.id,this.dec.id,null,emailAddresses,null,null);            
            //return null;
        }
        
        //Method will auto approve IP declaration record if its already submitted and overriden by IP or vcid
        private void approveIPDec(String overrideType){
            for(ProcessInstanceWorkitem workItem  : [SELECT id 
                                                       FROM ProcessInstanceWorkitem 
                                                       WHERE processInstance.targetObjectId = :this.dec.id
                                                       AND processInstance.status = 'Pending'
                                                       LIMIT 1]){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setComments('Auto approval - '+overrideType);
                req.setAction('Approve'); 
                req.setWorkitemId(workItem.id);
                
                Approval.ProcessResult result =  Approval.process(req);                                                                      
            }                                                                          
        }
        
        //Method will overide matching with IP
        public List<IP_Form_Matching_Result__c> overrideIP(){
            List<IP_Form_Matching_Result__c> result = generateFromIP(this.components.values(),'Overridden by IP');
            
            if(result.size() > 0){
                approveIPDec('Overridden by IP');
                this.dec.status__c = 'Approved';
                this.dec.matching_status__c = 'Overridden by IP';                
            }
            return result;
        } 
        
        //Method will overide matching with VCID
        public List<IP_Form_Matching_Result__c> overrideVCID(){
            List<IP_Form_Matching_Result__c> result = generateFromVCID(this.VCIDs.values(),'Overridden by VCID');
            
            if(result.size() > 0){
                approveIPDec('Overridden by VCID');
                this.dec.status__c = 'Approved';
                this.dec.matching_status__c = 'Overridden by VCID';                
            }
            return result;
        }        
        
        //Method will match the IP declaration form against VCIDs       
        public List<IP_Form_Matching_Result__c> doMatching(){
            List<IP_Form_Matching_Result__c> matchResults = new List<IP_Form_Matching_Result__c>();                                 
             
            //With VCID and IP List
            if(this.components.size() > 0 && this.VCIDs.size() > 0){
                matchResults = processMatching();
                //Added Asolito 11202013 - set status to approved when matching status = matched 
                if(this.matched){              
                    this.dec.matching_status__c = 'Matched';
                    this.dec.status__c = 'Approved';
                } else {
                    this.dec.matching_status__c = 'Unmatched';
                } 
                                                                                    
            //No VCIDs              
            } else if(this.components.size() > 0 && this.VCIDs.size() == 0){
                matchResults = generateFromIP(this.components.values(),'Unmatched - No VCID Component');
                this.dec.matching_status__c = 'Unmatched - No VCID';
            
            //No IP list                                        
            } else if(this.components.size() == 0 && this.VCIDs.size() > 0){
                matchResults = generateFromVCID(this.VCIDs.values(),'Unmatched - No IP Declaration');
                this.dec.matching_status__c = 'Unmatched - No IP';
            }
                                
            return matchResults;
        }  
        
        //Method will generate IP declaration components from VCIDs
        //this will happen during VCID Override
        public Map<String,List<IP_Declaration_Component__c>> generateIPCompFromVCID(){
            Map<String,List<IP_Declaration_Component__c>> result = new Map<String,List<IP_Declaration_Component__c>>();            
            
            Set<String> OICIPComps = new Set<String>();
            for(String key : this.VCIDs.keySet()){
                OICIPComps.add(this.VCIDs.get(key).oic_ip_component__c);
            }
            
            //set ip declaration components with the same oic ip component from VCIDs
            //to ip vcid override = true
            //while unmatched will flag for deletion
            Set<String> matchedOICIPComps = new Set<String>();
            for(String key : this.components.keySet()){
                IP_Declaration_Component__c i = this.components.get(key);
                
                if(OICIPComps.contains(i.oic_ip_component__c)){
                    i.ip_vcid_override__c = true;
                    if(result.containsKey('update')){
                       result.get('update').add(i);         
                    } else {
                       result.put('update',new List<IP_Declaration_Component__c>{i});
                    }
                    matchedOICIPComps.add(i.oic_ip_component__c);
                } else {
                    if(result.containsKey('delete')){
                        result.get('delete').add(i);         
                    } else {
                        result.put('delete',new List<IP_Declaration_Component__c>{i});
                    }
                }
            }
            
            Map<String,String> oicMap = new Map<String,String>();
            for(IP_Component_From_ERP__c i :[SELECT id,name
                                               FROM IP_Component_From_ERP__c
                                               WHERE name IN :OICIPComps]){
                oicMap.put(i.name,i.id);                                                               
            }                             
            
            //only create IP Dec components from VCID with no matching oic ip components
            //from the existing IP Dec components
            for(String key : this.VCIDs.keySet()){                
                IP_VCID_Component__c c = this.VCIDs.get(key);
                if(oicMap.containsKey(c.oic_ip_component__c)){                                
                    if(!matchedOICIPComps.contains(c.oic_ip_component__c)){
                        IP_Declaration_Component__c temp = new IP_Declaration_Component__c();
                        
                        temp.master_ip_component__c = oicMap.get(c.oic_ip_component__c);
                        temp.ip_declaration_form__c = this.dec.id;
                        temp.oic_ip_component__c = c.oic_ip_component__c;
                        temp.ip_component__c = c.oic_ip_component__c;
                        temp.vendor__c = c.vendor__c;
                        temp.tech_type__c = c.program__c;
                        temp.ip_vcid_override__c = true;
                        
                        if(result.containsKey('insert')){
                           result.get('insert').add(temp);         
                        } else {
                           result.put('insert',new List<IP_Declaration_Component__c>{temp});
                        }                        
                    }    
                }
            }    
                                                 
            return result;
        }                     
                                
        //Method will generate IP Matching result based on IP list
        private List<IP_Form_Matching_Result__c> generateFromIP(List<IP_Declaration_Component__c> components,String resultStatus){
            List<IP_Form_Matching_Result__c> matchResults = new List<IP_Form_Matching_Result__c>();
                                                        
            for(IP_Declaration_Component__c c: components){             
                IP_Form_Matching_Result__c result = new IP_Form_Matching_Result__c();                                           
                
                result.account_shortname__c = this.dec.device__r.account__r.short_name__c;
                result.ip_declaration_form__c = this.dec.id;                       
                result.CRM_DID__c = this.dec.CRM_Device_ID__c;                
                result.customer_number__c = this.dec.device__r.account__r.customer_number__c;
                result.ip_decl_form_id__c = this.dec.name;
                result.form_owner__c = this.dec.ownerId__c;
                result.other_party_ip__c = this.dec.other_3rd_party_ip__c;              
                result.matching_result__c = resultStatus;                                                                           
                result.ip_decl_flag__c = 'Y';
                result.vcid_flag__c = 'N';                                              
                result.source__c = 'VCID';                                              
                result.design_id__c = c.design_id__c;
                result.ip_component_id__c = c.ip_component__c;
                result.ip_type_desc__c = c.ip_type_desc__c;             
                result.technical_type__c = c.tech_type__c;
                result.ip_library_type__c = c.ip_type__c;                                
                result.oic_ip_component_id__c = c.oic_ip_component__c;                 
                result.send_to_martinistore__c = true;
                
                //Added ASOLITO 12092013
                //**********************************************
                result.ip_vendor__c = c.vendor__c;
                result.technical_geometry__c = c.tech_geometry__c;
                //**********************************************
                                                                                                        
                matchResults.add(result);
            }                               
            return matchResults;
        }
        
        //Method will generate IP Matching result based on VCID
        private List<IP_Form_Matching_Result__c> generateFromVCID(List<IP_VCID_Component__c> VCIDs,String resultStatus){
            List<IP_Form_Matching_Result__c> matchResults = new List<IP_Form_Matching_Result__c>();
                                                        
            for(IP_VCID_Component__c v: VCIDs){
                IP_Form_Matching_Result__c result = new IP_Form_Matching_Result__c();
                                                                
                result.account_shortname__c = this.dec.device__r.account__r.short_name__c;
                result.ip_declaration_form__c = this.dec.id;                            
                result.ip_decl_form_id__c = this.dec.name;
                result.form_owner__c = this.dec.ownerId__c;
                result.other_party_ip__c = this.dec.other_3rd_party_ip__c;  
                result.CRM_DID__c = this.dec.CRM_Device_ID__c;                                  
                result.customer_number__c = this.dec.device__r.account__r.customer_number__c;
                result.oic_ip_component_id__c = v.oic_ip_component__c;
                result.ip_vendor__c = v.vendor__c;
                result.technical_geometry__c = v.technology_geometry__c;
                result.matching_result__c = resultStatus;       
                result.program__c = v.program__c;
                result.ip_library_type__c = v.library__c;
                result.ip_decl_flag__c = 'N';
                result.vcid_flag__c = 'Y';                                              
                result.source__c = 'VCID';  
                result.customer__c = v.customer__c;   
                result.send_to_martinistore__c = true;                      
                
                matchResults.add(result);                                                                               
            }                                   
            return matchResults;
        }                                  
                                                                                                         
        //Method will match the ip declaration form against VCIDs
        private List<IP_Form_Matching_Result__c> processMatching(){
            Set<IP_Form_Matching_Result__c> matchResults = new Set<IP_Form_Matching_Result__c>();
            Map<String,IP_Declaration_Component__c> unmatchedComponents;    
            Map<String,IP_VCID_Component__c> unmatchedVCIDs;
            
            List<IP_Declaration_Component__c> matchedComponents = new List<IP_Declaration_Component__c>();
            unmatchedComponents = this.components.deepClone();
            unmatchedVCIDs = this.VCIDs.deepClone();    
                                     
            for(IP_Declaration_Component__c c: this.components.values()){                
                
                List<IP_VCID_Component__c> matched = filterComponents(c,unmatchedVCIDs.values());
                
                for(IP_VCID_Component__c v: matched){ 
                    IP_Form_Matching_Result__c result = new IP_Form_Matching_Result__c();               
                    result.ip_declaration_form__c = this.dec.id;
                    result.ip_decl_form_id__c = this.dec.name;                      
                    result.customer_number__c = this.dec.device__r.account__r.customer_number__c;
                    result.CRM_DID__c = this.dec.CRM_Device_ID__c;
                    result.account_shortname__c = this.dec.device__r.account__r.short_name__c;
                    result.form_owner__c = this.dec.ownerId__c;
                    result.other_party_ip__c = this.dec.other_3rd_party_ip__c;
                    result.oic_ip_component_id__c = v.oic_ip_component__c;
                    result.ip_vendor__c = v.vendor__c;
                    result.technical_geometry__c = v.technology_geometry__c;                        
                    result.ip_library_type__c = v.library__c;
                    result.matching_result__c = 'Matched';                              
                    result.program__c = v.program__c;                               
                    result.technical_type__c = v.library__c;                                                            
                    result.ip_decl_flag__c = 'Y'; 
                    result.vcid_flag__c = 'Y';                                              
                    result.source__c = 'VCID';  
                    result.design_id__c = c.design_id__c;
                    result.ip_component_id__c = c.ip_component__c;
                    result.ip_type_desc__c = c.ip_type_desc__c;                                         
                    result.customer__c = v.customer__c;
                    result.send_to_martinistore__c = true;

                    //remove matched IP and VCID components from the matching process
                    //unmatchedComponents.remove(c.id);
                    unmatchedVCIDs.remove(v.id);
                    matchedComponents.add(c);
                                
                    matchResults.add(result);                                                                                                                                                       
                }                                                                                                
            }
            
            for(IP_Declaration_Component__c m: matchedComponents){
                unmatchedComponents.remove(m.id);
            }
            
            //tag the IP Declaration form as unmatched            
            if(unmatchedVCIDs.size() > 0 || unmatchedComponents.size() > 0){                
                this.matched = false;
            }
            
            matchResults.addAll(generateFromVCID(unmatchedVCIDs.values(),'Unmatched - No IP Declaration'));
            matchResults.addAll(generateFromIP(unmatchedComponents.values(),'Unmatched - No VCID Component'));
            
            List<IP_Form_Matching_Result__c> result = new List<IP_Form_Matching_Result__c>();
            result.addAll(matchResults);
            
            return result;
        }
        
        //Method will match the ip declaration form against VCIDs
        private List<IP_VCID_Component__c> filterComponents(IP_Declaration_Component__c c,List<IP_VCID_Component__c> VCIDs){
            //MATCHING CRITERIA :
            //vcid.crmdid = device.crmdid 
            //vcid.vendor = ip component.vendor (DISREGARD as per Chui Mun)
            //vcid.library = ip component.ip type (DISREGARD as per Chui Mun)
            //vcid.oic ip component = ip component.oic ip component
            //
            //NOTE:
            //VCID records are already filtered during the instantiation 
            System.debug('Filter VCIDs '+VCIDs);
            
            List<IP_VCID_Component__c> matched = new List<IP_VCID_Component__c>();
            for(IP_VCID_Component__c v: VCIDs){
                System.debug('CRMDID '+v.CRM_DID__c+ ' '+this.dec.CRM_Device_ID__c);
                System.debug('Vendor '+v.vendor__c +' '+ c.vendor__c);                
                System.debug('Library '+v.library__c+' '+c.ip_type__c);
                System.debug('OIC IP Component '+v.oic_ip_component__c+' '+c.oic_ip_component__c);
                
                //Matched IP declaration component and VCID
                if(/*v.vendor__c == c.vendor__c && v.library__c == c.ip_type__c &&*/ v.oic_ip_component__c == c.oic_ip_component__c){
                    System.debug('VCID Matched');
                    matched.add(v);
                }
            }                           
            
            return matched;
        }           
    }
}