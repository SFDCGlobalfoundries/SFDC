/*
    Author: Nikhil Bajaj
    Description: This class help to insert/update group in IPelement,IPcell and IPrevision sharing object and send email to group member. 
    IPElement- Parent(Lookup Relationship)
    IPCell and IPRevision-Child
    Date-6-8-2016
*/

Public class IPElementSharing_TriggerHelper{ 

       
    public List<Messaging.SingleEmailMessage>  emailsList = new List<Messaging.SingleEmailMessage>();
    public Map<id,List<String>> Elid_Email= new Map<id,List<String>>();
    Public Map<id,List<List<String>>> ipelMap = new Map<Id,List<List<String>>>();
    Public Set<String> grpst = new Set<String>();
    Public Map<id,Set<String>> Id_gName = new Map<Id,Set<String>>();
    Public Map<String, id> gNameandID = new Map<String, id>();
    Public List<String> grpMem= new List<String>(); 
    Public IPElementCS__c CS = IPElementCS__c.getValues('IPDevCS');
    Public String bcc = CS.BccSender__c;
    Public String replyTo = CS.Reply__c;
    public String templateName = CS.Template_Name__c;
    Public EmailTemplate templateId;
    Public String []bcclist = new String[]{bcc};
    
    Public EmailTemplate getEmailTemplate(){
        if(templateName!=null){
            templateId=[SELECT Id,body,subject FROM EmailTemplate WHERE Name =:templateName];
         }
        return templateId;
    }
    
    public void getGrpname_and_Grpid(){
        
        for(IP_Element__c ipEl : (List<IP_Element__c>)Trigger.new){
           if(ipEl.GroupName__c!=null){
                List<String> grp =ipEl.GroupName__c.split(';');
                for(String s:grp){
                    grpst.add(s);
                 }
               Id_gName.put(ipEl.id,grpst);
           }
        }
        
        if(!grpst.isEmpty())  {
           List<Group>  gname=[select id,name from group where name in :grpst];
            if(!gname.isEmpty()){
                for(Group g:gname){
                    gNameandID.put(g.name,g.id);
                }
             }
        }   
        
       Set<Id> useridSet = new Set<Id>(); 
       Map<Id,Set<id>> useridMap= new Map<Id,Set<Id>>();
        
        if(!grpst.isEmpty()){
            List<Group> grpList = [SELECT Name, (select userOrGroupId ,Group.name from groupMembers) FROM group WHERE name in: grpst];
            
            for(IP_Element__c ipelRec:(List<IP_Element__c>)Trigger.new){
                if(ipelRec.GroupName__c!=null){
                   Set<String> gset = Id_gName.get(ipelRec.id); 
                   if(!grpList.isEmpty()){
                       for(Group grp:grpList){
                           if(grp.name!=null && gset.Contains(grp.name)){
                               for(GroupMember gm : grp.groupMembers) 
                                {   
                                     useridSet.add(gm.UserorGroupId);
                                     useridMap.put(ipelRec.id,useridSet);
                                }
                            }   
                        }
                     }
                  }
             }
            set<Id> gmemId =new set<Id>();
            List<String> emailList = new List<String>();
            Map<Id,User> usrMap;
            if(!useridSet.isEmpty()){
                 usrMap= new Map<Id,User>([Select email From User where id in :useridSet]);
             }
        
            for(IP_Element__c ipelRec:(List<IP_Element__c>)Trigger.new){
                if(ipelRec.GroupName__c!=null){
                    emailList = new List<String>();
                    gmemId =useridMap.get(ipelRec.id);
                    if(gmemId!=null){
                        String email;
                        for(Id id:gmemId){
                            email = usrMap.get(id).email;
                            emailList.add(email);
                        }
                    Elid_Email.put(ipelRec.id,emailList);
                    }   
                 }
              }
            
           }
    }
    
    /* ------------------Method returning template body(fields Used in email Template - ip__c and record id ) from template-'Email Notification to IPR group'-------------------*/
    public  String emailTemplate(String Temp,IP_Element__c el,User u){
    
        Temp=Temp.replaceAll('\\{!IP_Element__c.ip__c\\}',el.ip__c);
        String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + el.id;
        Temp=Temp.replaceAll('\\{!IP_Element__c.Link\\}',fullFileURL);
    
        return Temp;
    }
    
    /* --------------------Method returning template subject(setting subject in custom setting- IPDevCS)-------------------*/
    public  String emailTemplateSubject(String TempSub,IP_Element__c el){
        String Subject =el.ip__c;   
        TempSub=TempSub.replaceAll('\\{!IP_Element__c.ip__c\\}',Subject);
        return TempSub;
    }
    
    
    /*----------------After Insert-Once IpElement record is created we are inserting selected group name in IpElement sharing object---------------------------------------------*/
    Public void insertGroupInSharing(){
        
        EmailTemplate templateId =getEmailTemplate();
        List<IP_Element__Share> sharesToCreate = new List<IP_Element__Share>();
        Set<Id> useridSet = new Set<Id>();
        Set<String> grpset2 = new Set<String>();
        getGrpname_and_Grpid();
        for (IP_Element__c IPElem: (List<IP_Element__c>)Trigger.new){
            if(IPElem.GroupName__c  !=null){
                Set<String> gnameSet= Id_gName.get(IPElem.id);
                if(gnameSet!=null){
                    for(String gname:gnameSet){
                        IP_Element__Share IPEL_Share = new IP_Element__Share();
                        IPEL_Share.AccessLevel = 'Edit';
                        IPEL_Share.ParentID= IPElem.Id;
                        IPEL_Share.UserOrGroupId = gNameandID.get(gname);
                        sharesToCreate.add(IPEL_Share);
                     }
                    grpMem =  Elid_Email.get(IPElem.id);
                    if(IPElem.GroupName__c!=null && grpMem!=null){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        if(templateId.body !=null){
                            mail.setPlainTextbody(emailTemplate(templateId.body,IPElem,new User()));
                        }
                        if(templateId.subject !=null){
                            mail.setSubject(emailTemplateSubject(templateId.subject,IPElem));
                        }
                        mail.setToAddresses(grpMem);
                        if(bcc!=null){
                            mail.setBccAddresses(bcclist);
                        }
                        if(replyTo!=null){
                            mail.setReplyTo(replyTo);
                        }
                        mail.setSaveAsActivity(false); 
                        emailsList.add(mail);
                    }
                 }
             }
        }
        
       if(!sharesToCreate.isEmpty()){
            try{  
                Database.insert(sharesToCreate);
               if(emailsList!=null && grpMem.size()<100){
                    Messaging.sendEmail(emailsList);
                   
                }
               else{
                    for (IP_Element__c IPElem: (List<IP_Element__c>)Trigger.new){
                        IPElem.addError('Too many groups added. Please remove some of the groups.');
                     }
                }
              }catch(Exception excp) {
                   GlobalUtility.logMessage('Error','IPElementSharing_TriggerHelper','insertGroupInSharing','','Exception while inserting group in ipelementsharing object or sending email to grp member',String.valueof(excp.getMessage()),'','IP Request',excp,0);
               }
         }
    }  
    
    
    /*-------------After Update-Once IpElement record is Updated we are updating selected group name in IpElement sharing object and its child Cell and Revision sharing object---------------------------------------------*/  
    Public void updateGroupInSharing(){
        
        EmailTemplate templateId =getEmailTemplate();
        List<String> updtGrp = new List<String>();
        List<String> OldGrp = new List<String>();
        List<IP_Cell__Share> newCellShareList = new List<IP_Cell__Share>();  
        List<IP_Revision__Share> newRevShareList = new List<IP_Revision__Share>();
        Set<IP_Cell__c> cellSet = new Set<IP_Cell__c>();
        Set<IP_Revision__c > revSet = new Set<IP_Revision__c >();
        List<IP_Element__c> Elm_cell_revList=[Select id,GroupName__c, (SELECT Name,IPElement__c from IP_Cell__r),(SELECT Name,IP_Element__c from IP_Revisions__r) from IP_Element__c where id in:Trigger.new];
       
        Map<id,Set<IP_Cell__c>> cellMap= new Map<id,Set<IP_Cell__c>>();
        Map<id,Set<IP_Revision__c>> revMap= new Map<id,Set<IP_Revision__c>>();
        if(!Elm_cell_revList.isEmpty()){
            for(IP_Element__c  IPElem:Elm_cell_revList) {
                if(IPElem.GroupName__c !=null){
                    for(IP_Cell__c cellrec : IPElem.IP_Cell__r ){
                       if(cellrec.IPElement__c !=null){
                           cellSet.add(cellrec);
                           cellMap.put(IPElem.id,cellSet);
                       }
                    }
                    
                    for(IP_Revision__c revrec : IPElem.IP_Revisions__r){
                       if(revrec.IP_Element__c !=null){
                           revSet.add(revrec);
                           revMap.put(IPElem.id,revSet);
                       }
                     }
                  }
              }
          }
        
        Map<Id, IP_Element__c>   ipelNew = ((Map<Id, IP_Element__c >)Trigger.newMap);
        Map<Id, IP_Element__c> ipelOld = ((Map<Id, IP_Element__c >)Trigger.oldMap);
        List<IP_Element__Share> sharesToCreate = new List<IP_Element__Share>();
        Map<Id,String> shareIdsToDeleteMap = new Map<Id,String>();
        getGrpname_and_Grpid();
        
        for(IP_Element__c  IPElem:(List<IP_Element__c>)Trigger.new) {
            
            String newgrpname =ipelNew.get(IPElem.id).GroupName__c;
            String oldgrpname = ipelOld.get(IPElem.id).GroupName__c;
        
            if(ipelOld.get(IPElem.id).GroupName__c !=ipelNew.get(IPElem.id).GroupName__c && ipelNew.get(IPElem.id).GroupName__c !=null) {
               Set<String> gnameSet= Id_gName.get(IPElem.id);
               if(gnameSet !=null){
                    for(String gname:gnameSet){
                        IP_Element__Share IPEL_Share =  new IP_Element__Share();
                        IPEL_Share.AccessLevel = 'Edit';
                        IPEL_Share.ParentID= IPElem.Id;
                        IPEL_Share.UserOrGroupId =gNameandID.get(gname);
                        sharesToCreate.add(IPEL_Share);
                        Set<IP_Cell__c> cellrec =cellMap.get(IPElem.id);
                        
                        if(cellrec !=null){
                            for(IP_Cell__c cell :cellSet){
                                IP_Cell__Share IPCELL_Share = new IP_Cell__Share();
                                IPCELL_Share.AccessLevel = 'Edit';
                                IPCELL_Share.ParentID= cell.Id;
                                IPCELL_Share.UserOrGroupId =gNameandID.get(gname);
                                newCellShareList.add(IPCELL_Share);
                             }
                         }
                        Set<IP_Revision__c> revrec =revMap.get(IPElem.id);
                        if(revrec !=null){
                            for(IP_Revision__c rev :revrec){
                                IP_Revision__Share IPrev_Share = new IP_Revision__Share();
                                IPrev_Share.AccessLevel = 'Edit';
                                IPrev_Share.ParentID= rev.Id;
                                IPrev_Share.UserOrGroupId =gNameandID.get(gname);
                                newRevShareList.add(IPrev_Share);
                             } 
                         }  
                     }
                }
                   
                if(!String.isBlank(oldgrpname)){
                    shareIdsToDeleteMap.put(IPElem.id,oldgrpname);
                }
                grpMem =  Elid_Email.get(IPElem.id);
                
                if(IPElem.GroupName__c!=null && grpMem!=null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if(templateId.body !=null){
                        mail.setPlainTextbody(emailTemplate(templateId.body,IPElem,new User()));
                    }
                    mail.setToAddresses(grpMem);
                    mail.setSaveAsActivity(false);
                    if(templateId.subject !=null){
                        mail.setSubject(emailTemplateSubject(templateId.subject,IPElem));
                    }
                    if(bcc !=null){
                        mail.setBccAddresses(bcclist);
                    }
                    if(replyTo!=null){
                        mail.setReplyTo(replyTo);
                    }
                    emailsList.add(mail);
                }
           }
           else if(String.isBlank(newgrpname)){
               if(!String.isBlank(oldgrpname)){ 
                  shareIdsToDeleteMap.put(IPElem.id,oldgrpname);
                }
            }
        }
        
       
       if(!shareIdsToDeleteMap.isEmpty()){
            List<Id> eId = new List<Id>();
            String oldgname;
            List<String>  gId = new List<String>();
            for(IP_Element__c  IPEl:(List<IP_Element__c>)Trigger.old) {
                eId.add(IPEl.id); 
                oldgname =shareIdsToDeleteMap.get(IPEl.id);
                if(oldgname!=null){
                    gId=oldgname.Split(';');
                 }
            }   
            List<Group> oldg = new List<Group>();
            List<IP_Revision__c> revList = new List<IP_Revision__c>();
            List<IP_Cell__c> cellList = new List<IP_Cell__c>();
            List<IP_Element__Share> oldElShareList = new List<IP_Element__Share>();
            List<IP_Revision__Share> oldRevShareList = new List<IP_Revision__Share>();
            List<IP_Cell__Share> oldCellShareList = new List<IP_Cell__Share>();
            
            if(!gId.isEmpty()){
                oldg =[select id, name from Group where name in :gId];
            }
            
            
            if(!eId.isEmpty()){
                revList = [select id from IP_Revision__c where IP_Element__c in :eId];
                cellList = [select id from IP_Cell__c where IPElement__c in :eId];
            }
            
           if(!oldg.isEmpty() && !eId.isEmpty()){
            
                oldElShareList =[select id from IP_Element__Share where UserOrGroupId In:oldg and ParentID in:eId];
            }
            
            if(!oldg.isEmpty() && !revList.isEmpty()){
                oldRevShareList =[select id from IP_Revision__Share where UserOrGroupId In:oldg and ParentID in:revList];
            
            }
            if(!oldg.isEmpty() && !cellList.isEmpty()){
                oldCellShareList =[select id from IP_Cell__Share where UserOrGroupId In:oldg and ParentID in:cellList];
            }
            
            try{
                if(!oldElShareList.isEmpty()){
                     Database.delete(oldElShareList);
                 }
                 
                 if(!oldCellShareList.isEmpty()){
                     Database.delete(oldCellShareList);
                 }
                 
                 if(!oldRevShareList.isEmpty()){
                     Database.delete(oldRevShareList);
                 }
                 
              }catch (Exception excp) {
                GlobalUtility.logMessage('Error','IPElementSharing_TriggerHelper','updateGroupInSharing','','Exception while deleting group from ipelementsharing or ipcellsharing or iprevisionsharing object',String.valueof(excp.getMessage()),'','IP Request',excp,0);
              } 
        }
        
        
        if(!sharesToCreate.isEmpty()){
            try{
                Database.insert(sharesToCreate);
                
                if(!newCellShareList.isEmpty()){
                    Database.insert(newCellShareList);
                 }
                 if(!newRevShareList.isEmpty()){
                    Database.insert(newRevShareList);
                 }
                if(emailsList!=null && grpMem.size()<100){
                    Messaging.sendEmail(emailsList);
                 }else{
                    for(IP_Element__c IPElem: (List<IP_Element__c>)Trigger.new){
                        IPElem.addError('Too many groups added. Please remove some of the groups.');
                     }
                 }
             }catch (Exception excp) {
                GlobalUtility.logMessage('Error','IPElementSharing_TriggerHelper','updateGroupInSharing','','Exception while updating group in  ipelementsharing or ipcellsharing or iprevisionsharing object',String.valueof(excp.getMessage()),'','IP Request',excp,0);
            } 
         }
    } 
    
    /*----------Before Delete- Once IPElement Record is deleted we are deleting group from IPelement sharing object and its child cell and revision sharing object-----------------------*/
    Public void deleteGroupInSharing(){
        Set<IP_Cell__c> cellSet = new Set<IP_Cell__c>();
        Set<IP_Revision__c > revSet = new Set<IP_Revision__c >();
        
        List<IP_Element__c> Elm_cell_revList=[Select id,GroupName__c,(SELECT Name,IPElement__c from IP_Cell__r),(SELECT Name,IP_Element__c from IP_Revisions__r) from IP_Element__c where id in:Trigger.old];
        if(!Elm_cell_revList.isEmpty()){
            for(IP_Element__c  IPElem:Elm_cell_revList) {
                if(IPElem.GroupName__c !=null){ 
                    for(IP_Cell__c cellrec : IPElem.IP_Cell__r ){
                       if(cellrec.IPElement__c !=null){
                           cellSet.add(cellrec);
                       }
                    }
                    
                    for(IP_Revision__c revrec : IPElem.IP_Revisions__r){
                        if(revrec.IP_Element__c !=null){
                            revSet.add(revrec);
                        }
                     }
                 }    
             }
         }
         
        try{
             List<IP_Cell__Share>  cellshare = new List<IP_Cell__Share>();
              if(cellSet!=null){
                  cellshare =[select id from IP_Cell__Share  where ParentID in:cellSet and  RowCause = 'Manual'];
                }
              if(!cellshare.isEmpty()){
                  database.delete(cellshare);
               }
             
              List<IP_Revision__Share>  revshare = new List<IP_Revision__Share>();
              if(revSet!=null){
                  revshare =[select id from IP_Revision__Share where ParentID in:revSet and  RowCause = 'Manual'];
               }
               
              if(!revshare.isEmpty()){
                  database.delete(revshare);
              }
           }catch (Exception excp) {
                GlobalUtility.logMessage('Error','IPElementSharing_TriggerHelper','deleteGroupInSharing','','Exception while deleting group from  ipelement or ipcellsharing or iprevisionsharing object',String.valueof(excp.getMessage()),'','IP Request',excp,0);
              } 
     }
	 /*************************************************
Method Name: createIPRecord
Description: Creating Ip and IP Design Kit records
from IP Element records, calling inthe
events after insert and update.
Parameters : List<IP_Element__c>
Return Type: Void              
**************************************************/
    public void createIPRecord(){
        Set<String> lifeCycleOmittedValues = new Set<String>();
        for(IPElementLifecycleStage__c lifeCycle: IPElementLifecycleStage__c.getAll().values()){
            system.debug('==>'+lifeCycle.Name); 
            if(lifeCycle.Name != null) 
                lifeCycleOmittedValues.add(lifeCycle.Name.toUpperCase());
        }
        Map<String,Base_Ip__c> baseIpMap = new Map<String,Base_Ip__c>();
        List<IP__c> ipdkList = new List<IP__c>();
        List<IP__c> ipdkListDML = new List<IP__c>();
        Set<string> ipNumtoCheck = new Set<String>();
        set<string> techSet = new Set<String>();
        set<string> techChangeSet = new Set<String>();
        Map<string,Set<Id>> ipePTTechMap = new Map<string,Set<Id>>();
        Map<string,List<IP_PT_Map__c>> ipPTMap = new Map<string,List<IP_PT_Map__c>>();
        Map<Id,IP_Element__c> oldMap = (Map<Id,IP_Element__c>) trigger.OldMap;
        for(IP_Element__c ipe: (List<IP_Element__c>) trigger.new){
            string s;
            if(ipe.Name.contains('-'))
                s = ipe.Name.remove('-');
            else
                s = ipe.Name;
            ipNumtoCheck.add(s);
            techSet.add(ipe.Process_Technology__c);
            if(trigger.isUpdate && oldMap.get(ipe.Id).Process_Technology__c != ipe.Process_Technology__c){
                techChangeSet.add(ipe.Name.remove('-'));
            }
        }
        system.debug('techChangeSet==>'+techChangeSet);
        ipPTMap = getIPPTMap(techChangeSet);
        for(Process_Technology__c PT : [Select Id, Name,Tech_Geometry__c, Title__c,PT_Number__c,
                                        Lifecycle__c,IP_Technology_Name__c, IP_Geometry_Technology__c  from Process_Technology__c
                                        where IP_Technology_Name__c in: techSet]){
                                            if(ipePTTechMap.containsKey(PT.IP_Technology_Name__c))
                                                ipePTTechMap.get(PT.IP_Technology_Name__c).add(pt.Id);
                                            else{
                                                ipePTTechMap.put(PT.IP_Technology_Name__c,new set<Id>());
                                                ipePTTechMap.get(PT.IP_Technology_Name__c).add(pt.Id);
                                            }
                                            
                                        }
        system.debug('ipePTTechMap==>'+ipePTTechMap);
        Map<String,Id> existingBaseIpMap = new Map<String,Id>();
        Map<String,Id> existingIpdkMap = new Map<String,Id>(); 
        for(Base_IP__c ip: [Select Id,Name, (Select Id from IP_Design_Kit__r where Latest_Design_Kit__c = true) from Base_IP__c where Name in: ipNumtoCheck]){
            existingBaseIpMap.put(ip.Name,ip.id);
            if(ip.IP_Design_Kit__r.size() > 0)
                existingIpdkMap.put(ip.Name,ip.IP_Design_Kit__r[0].Id);
        }
        Map<String,String> IPfieldMap = getIPFieldMappings();
        Map<String,String> IPDKfieldMap = getIPDKFieldMappings();
        
        for(IP_Element__c ipe: (List<IP_Element__c>) trigger.new){
            if((ipe.devstatus__c != null && !lifeCycleOmittedValues.contains(ipe.devstatus__c.toUpperCase())) || ipe.devstatus__c == null){
                //IP from IPE
                Base_Ip__c ip = new Base_Ip__c();
                string s;
                string iptype;
                if(ipe.iptype__c != null)
                    iptype = ipe.iptype__c;
                else
                    iptype = 'Other';
                if(ipe.Name.contains('-'))
                    s = ipe.Name.remove('-');
                else
                    s = ipe.Name;
                if(existingBaseIpMap.containsKey(s))
                    ip.Id = existingBaseIpMap.get(s);
                ip.Name = s;
                ip.Display_in_IP_Catalog__c = 'Yes';
                ip.Is_ASIC_IP__c = true;
                ip.IP_Number__c = s;
                for(String ipeField: IPfieldMap.keySet()){
                    ip.put(IPfieldMap.get(ipeField), ipe.get(ipeField));
                }
                ip.Ip_Type__c = iptype;
                
                baseIpMap.put(s,ip);
                
                //IPDK from IPE
                IP__c ipdk = new IP__c();
                if(existingIpdkMap.containsKey(s))
                    ipdk.Id = existingIpdkMap.get(s);
                ipdk.Name = s + '-00';
                ipdk.IP_ID__c = s;
                ipdk.Latest_Version__c = s + '-00';
                ipdk.Lifecycle__c = 'FB Design Kit Approved';
                ipdk.IP_Type__c = iptype;
                for(String ipeField: IPDKfieldMap.keySet()){
                    ipdk.put(IPDKfieldMap.get(ipeField), ipe.get(ipeField));
                }
                ipdkList.add(ipdk);
                
            }
        }
        try{
            if(baseIpMap.size() > 0)
                upsert baseIpMap.values();
        }
        catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPElementTriggerHelper','CreateIpRecord','','Exception while creating IP from IPE',String.valueof(excp.getMessage()),'','IP Element',excp,0);
        }
        //Assigning IP to IPDK and Creation of IP PT Map
        List<IP_PT_Map__c> ipPtList = new List<IP_PT_Map__c>();   
        for(IP__c ipdk: ipdkList){
            if(baseIpMap.containsKey(ipdk.IP_ID__c) && baseIpMap.get(ipdk.IP_ID__c).Id != null){
                ipdk.IPNumber__c = baseIpMap.get(ipdk.IP_ID__c).Id;
                ipdkListDML.add(ipdk);
            }
        }
        try{
            if(ipdkListDML.size() > 0)
                upsert ipdkListDML;
        }
        catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPElementTriggerHelper','CreateIpRecord','','Exception while creating IPDK from IPE',String.valueof(excp.getMessage()),'','IP Element',excp,0);
        }
        List<IP_PT_Map__c> deleteIpPtList = new List<IP_PT_Map__c>();
        for(IP_Element__c ipe: (List<IP_Element__c>) trigger.new){
            if(ipePTTechMap.containsKey(ipe.Process_Technology__c)){
                string ipName = ipe.Name.remove('-');
                system.debug('ipPTMap.containsKey(ipName)==>'+ipPTMap.containsKey(ipName) + '=='+ipPTMap + '==' + ipName);
                //IP_PT_Map__c ippt = new IP_PT_Map__c();
                if(trigger.isupdate && ipPTMap.containsKey(ipName)){
                    List<Id> ptIds = new list<Id>(ipePTTechMap.get(ipe.Process_Technology__c));
                    List<IP_PT_Map__c> ippts = ipPTMap.get(ipName);
                    if(techChangeSet.contains(ipName)){
                        deleteIpPtList.addAll(ipPTMap.get(ipName));
                        if(baseIpMap.containsKey(ipName) && baseIpMap.get(ipName).Id != null && ipePTTechMap.containsKey(ipe.Process_Technology__c) && ipePTTechMap.get(ipe.Process_Technology__c).size() == 1){
                            IP_PT_Map__c ippt = new IP_PT_Map__c();
                            ippt.PT_Number__c = new List<Id>(ipePTTechMap.get(ipe.Process_Technology__c))[0];
                            ippt.IPNumber__c = baseIpMap.get(ipName).id;
                            ipPtList.add(ippt);
                        }
                    }
                }
                if(trigger.isInsert){
                    IP_PT_Map__c ippt = new IP_PT_Map__c();
                    if(baseIpMap.containsKey(ipName) && baseIpMap.get(ipName).Id != null && ipePTTechMap.containsKey(ipe.Process_Technology__c) && ipePTTechMap.get(ipe.Process_Technology__c).size() == 1){
                        ippt.PT_Number__c = new List<Id>(ipePTTechMap.get(ipe.Process_Technology__c))[0];
                        ippt.IPNumber__c = baseIpMap.get(ipName).id;
                        ipPtList.add(ippt);
                    }
                }
            }    
        }
        
        try{
            if(ipPtList.size() > 0)
                upsert ipPtList;
            if(deleteIpPtList.size() > 0)
                delete deleteIpPtList;
        }
        catch(Exception excp) {
            GlobalUtility.logMessage('Error','IPElementTriggerHelper','CreateIpRecord','','Exception while creating IP-PT Mapping from IPE',String.valueof(excp.getMessage()),'','IP Element',excp,0);
        }
    }
    private Map<String,String> getIPFieldMappings(){
        Map<string, string> fieldMapTable = new map<string,string>();
        for(IPE_IP_FieldMapping__c mappingTableRec : IPE_IP_FieldMapping__c.getall().Values()){
            if (mappingTableRec.Name != null && mappingTableRec.IP_Field_API_Name__c != Null ){
                fieldMapTable.put(mappingTableRec.Name , mappingTableRec.IP_Field_API_Name__c);
            }
        }
        return fieldMapTable;
    }
    private Map<String,String> getIPDKFieldMappings(){
        Map<string, string> fieldMapTable = new map<string,string>();
        for(IPE_IPDK_FieldMapping__c mappingTableRec : IPE_IPDK_FieldMapping__c.getall().Values()){
            if (mappingTableRec.Name != null && mappingTableRec.IP_Field_API_Name__c != Null ){
                fieldMapTable.put(mappingTableRec.Name , mappingTableRec.IP_Field_API_Name__c);
            }
        }
        return fieldMapTable;
    }
    private Map<String,List<IP_PT_Map__c>> getIPPTMap(Set<String> ipNumSet){
        Map<String,List<IP_PT_Map__c>> ipPtExistMap = new Map<String,List<IP_PT_Map__c>>();
        for(IP_PT_Map__c ippt: [Select Id, Name, IPNumber__r.Name,PT_Number__r.Name from IP_PT_Map__c where IPNumber__r.Name in: ipNumSet]){
            if(ipPtExistMap.containsKey(ippt.IPNumber__r.Name))
                ipPtExistMap.get(ippt.IPNumber__r.Name).add(ippt);
            else{
                ipPtExistMap.put(ippt.IPNumber__r.Name,new List<IP_PT_Map__c>());
                ipPtExistMap.get(ippt.IPNumber__r.Name).add(ippt);
            }
        }
        return ipPtExistMap;
    }
}