global class  DWC_Attachment_WebserviceCall {
    
    public static Savepoint sp;
    
    public DWC_Attachment_WebserviceCall(){
        
    }
    
     webservice static PTSRResponseElements createWaiverCollaboratorAttachment(PTSRRequestElements ptsrRequest){
         Wavier_Collaborator__c DFM = new Wavier_Collaborator__c();
         List<Wavier_Collaborator__c> waiver =  new List<Wavier_Collaborator__c>();
         String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
         waiver = [SELECT Id FROM Wavier_Collaborator__c where PTSR_Number__c = : ptsrRequest.ptsrNumber];
         try{
            system.debug('Inside createWaiverCollaboratorAttachment ############ '+ptsrRequest); 
            
             if(waiver <> NULL && !waiver.isEmpty()){
                 DFM.Id = waiver[0].Id;
             }  
            system.debug('Inside DFM.Id >>>>>>>>>>>> '+DFM.Id); 
             
             
             DWC_Attachment_WebserviceCall.getAttachmentDetails(ptsrRequest.ptsrNumber,DFM.Id);
             
             
             return new PTSRResponseElements(ptsrRequest.transactionId, '' , '' ,'','Success','',+baseUrl+ '/' + '');
         }catch (exception e){
             GlobalUtility.logMessage('Debug', 'DWC_Attachment_WebserviceCall', 'createWaiverCollaboratorAttachment()', ' ', ' ', 'this is error message', 'payLoad','Other SFDC',e, 2300);
             Database.rollback(sp);
             return new PTSRResponseElements(ptsrRequest.transactionId,ptsrRequest.ptsrNumber,' ',' ','Fail',e.getMessage(),'');
         }
         
         return null;
     }
    
    public Static DateTime constructDate(String src){
        
       
        String[] str = src.split('T');
        System.debug('str[0] >>>> '+str[0]);
        System.debug('str[1] >>>> '+str[1]);
         DateTime myDate ;
        
        if(str.size()>0){
            String[] newdates = str[0].split('-');
            String[] newTimes = str[1].split(':');
            
            
            System.debug('str >>>> '+str);
            System.debug('newdates >>>> '+newdates);
            System.debug('newTimes >>>> '+newTimes);
            String newmydate;
                
            if(newdates.size()>1 && newTimes.size() > 0)  {  
                newmydate=Integer.valueOf(newdates[1])+'/'+Integer.valueOf(newdates[2])+'/'+Integer.valueOf(newdates[0])+
                ' '+Integer.valueOf(newTimes[0])+':'+Integer.valueOf(newTimes[1]);
            myDate =datetime.newInstance(Integer.valueOf(newdates[0]), Integer.valueOf(newdates[1]), 
                                         Integer.valueOf(newdates[2]), Integer.valueOf(newTimes[0]), Integer.valueOf(newTimes[1]), Integer.valueOf(0));
            }
            System.debug('newmydate >>>> '+newmydate);
            System.debug('Newtimes >>>> '+newTimes);
            System.debug('myDate >>>> '+myDate);
            String newdate1 = myDate.format( 'yyyy.MM.dd HH:mm');
            //DateTime newGMTTime = DateTime.parse(newdate);
              
            System.debug('newdate1 >>>> '+newdate1);
               
        }
        return myDate;
    }
    
     public Static String constructDate1(String src){
        
        //src = '2015-09-09T16:56:33.75-07:00';
        //DateTime dt = new DateTime();
        String[] str = src.split('T');
         DateTime myDate ;
          String newdate1;
        if(str.size()>0){
            String[] newdates = str[0].split('-');
            String[] newTimes = str[1].split(':');
            
            
            
            System.debug('str >>>> '+str);
            System.debug('newdates >>>> '+newdates);
            System.debug('newTimes >>>> '+newTimes);
            String newmydate;
                
            if(newdates.size()>1 && newTimes.size() > 0)  {  
                newmydate=Integer.valueOf(newdates[1])+'/'+Integer.valueOf(newdates[2])+'/'+Integer.valueOf(newdates[0])+
                ' '+Integer.valueOf(newTimes[0])+':'+Integer.valueOf(newTimes[1]);
            myDate =datetime.newInstance(Integer.valueOf(newdates[0]), Integer.valueOf(newdates[1]), 
                                         Integer.valueOf(newdates[2]), Integer.valueOf(newTimes[0]), Integer.valueOf(newTimes[1]), Integer.valueOf(0));
            }
            //System.debug('newmydate >>>> '+newmydate);
           // System.debug('myDate >>>> '+myDate);
             newdate1 = myDate.format( 'yyyy.MM.dd HH:mm');
            //DateTime newGMTTime = DateTime.parse(newdate);
              
           // System.debug('newdate >>>> '+newdate1);
        }
        return newdate1;
    }

    
    @future (callout=true)
    private static void getAttachmentDetails(String ptsrNo,Id dfmId){
        system.debug('inside getAttachmentDetails ####### ');
        Queryptsrattachments.QueryPTSRAttachmentService_pt ptsrObj = new Queryptsrattachments.QueryPTSRAttachmentService_pt();
            
        List<Queryptsrattachments.GetPTSRAttachmentResponseDetailsType> dwcAttachments =  ptsrObj.QueryPTSRAttachment(ptsrNo); 
        system.debug('dwcAttachments ######### '+dwcAttachments);
        
        if (dwcAttachments<>NULL && !dwcAttachments.isEmpty()){
            DWC_Attachment_WebserviceCall.setDWCAttachmentDetails(dwcAttachments,dfmId);
        }  
        
        
        if (dwcAttachments == NULL){
            system.debug('dwcAttachment fro delete');
            //DWC_Attachment_WebserviceCall.setDWCAttachmentDetails(dwcAttachments,dfmId);
            List<DWC_Attachment__c> existingAttachmentList = [select id from DWC_Attachment__c where Waiver_Collaborator__c =:DfmId];
            delete existingAttachmentList;

        }     
    }
    
    
    // Update DFM details
    public static void setDWCAttachmentDetails(List<Queryptsrattachments.GetPTSRAttachmentResponseDetailsType> dwcAttachmentDetails,Id DfmId){
        
        system.debug('Inside setDfmDetails #### ');
        Wavier_Collaborator__c DFM = new Wavier_Collaborator__c();
        DFM.Id = DfmId;
        
        List<DWC_Attachment__c> existingAttachmentList = [select id from DWC_Attachment__c where Waiver_Collaborator__c =:DfmId];
        if(existingAttachmentList.size()>=0){
            delete existingAttachmentList;
        }
        
        List<DWC_Attachment__c> newAttachmentList = new List<DWC_Attachment__c>();
        for (Queryptsrattachments.GetPTSRAttachmentResponseDetailsType attach : dwcAttachmentDetails){
           DWC_Attachment__c attachmentObj = new  DWC_Attachment__c();
           attachmentObj.Attach_To__c=attach.AttachTo;
           attachmentObj.Content_Type__c=attach.ContentType;
           attachmentObj.Created_By__c= attach.CreatedBy;
           DateTime crtdDate =  constructDate(attach.CreatedDate);
           if(crtdDate<>null){
           attachmentObj.Created_Date__c = constructDate(attach.CreatedDate);
           }else{
           attachmentObj.Created_Date__c = Date.valueOf(attach.CreatedDate);
           }
           attachmentObj.CreatedDate__c=constructDate1(attach.CreatedDate);
           attachmentObj.Created_By__c= attach.CreatedBy;
           attachmentObj.File_ID__c=attach.FileID;
           attachmentObj.File_Name__c=attach.FileName;
           attachmentObj.File_Size__c=attach.FileSize;
           attachmentObj.PTSR_ID__c=attach.PTSRID;
           attachmentObj.PTSR_Number__c=attach.PTSRNumber;
           attachmentObj.Reference__c=attach.Reference;
           attachmentObj.Waiver_Collaborator__c= DfmId;
           newAttachmentList.add(attachmentObj);
        }
        
        upsert newAttachmentList;
    }
    
     // Prepare response parameters after collaborator is created or fail to create in SFDC
    global class PTSRResponseElements {
    
        webservice String ptsrTransId;
        webservice String ptsrNumber;
        webservice String DWC_Id;
        webservice String DWC_Name;
        webservice String status;
        webservice String errorMsg;
        webservice string refURL;
        
        public PTSRResponseElements(String ptsrTransId,String ptsrNumber,String DWC_Id,
                                    String DWC_Name,String status,String errorMsg,String refURL){
            
            this.ptsrTransId = ptsrTransId;
            this.ptsrNumber = ptsrNumber;
            this.DWC_Id = DWC_Id;
            this.DWC_Name = DWC_Name;
            this.status = status;
            this.errorMsg = errorMsg;
            this.refURL = refURL; 
        }
    }
    
    global class PTSRRequestElements {

        webservice String transactionId;
        webservice String ptsrNumber;
        webservice String ptsrServiceType;        
        webservice String submitDate;
        webservice String actionValue;
        
        
    }


}