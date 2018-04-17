/**
* @ Author :- Navneet Rajput
* @ Company :- Globalfoundries
* @ Description :- Class handles DFM service request coming from PTSF (swift) system and create design waiver collaborator in SFDC  
* @ Date :- 09/14/2015
* @ Change History :- Navneet Rajput,8/9/2016
**/


global class WaiverCollaboratorService { 

     
    public static Savepoint sp;
    
    public WaiverCollaboratorService(){
        
    }
    
    webservice static PTSRResponseElements createWaiverCollaboratorReport(PTSRRequestElements ptsrRequest){
        
        Wavier_Collaborator__c DFM = new Wavier_Collaborator__c();
        List<Wavier_Collaborator__c> waiver =  new List<Wavier_Collaborator__c>();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        
        waiver = [SELECT Id FROM Wavier_Collaborator__c where PTSR_Number__c = : ptsrRequest.ptsrNumber];
            
        try{
                system.debug('Inside createWaiverCollaboratorReport ############ '+ptsrRequest);
                sp = Database.setSavepoint();
                if (!String.isEmpty(ptsrRequest.crmDeviceId)){
                    List<Device__c> device = [SELECT Id,CRMDID__c FROM Device__c WHERE CRMDID__c =:ptsrRequest.crmDeviceId]; 
                    if (device<>NULL && !device.isEmpty() && device[0].CRMDID__c <>NULL){
                        DFM.CRM_Device__c = device[0].Id;                   
                    }
                }
                
                if (!String.isEmpty(ptsrRequest.custShortName)){
                     List<Account> accList = [SELECT Id,Short_Name__c FROM Account WHERE Short_Name__c = : ptsrRequest.custShortName];
                     if (accList<>NULL && !accList.isEmpty()  && accList[0].Short_Name__c <>NULL){
                        DFM.Account__c = accList[0].Id;
                    }
                }  
            
                
                DFM.PTSR_Number__c = ptsrRequest.ptsrNumber;
                DFM.PTSR_Service_Type__c = ptsrRequest.ptsrServiceType;
                DFM.Account_Short_Name__c = ptsrRequest.custShortName;
                DFM.PTSR_Status__c = ptsrRequest.ptsrStatus;
                DFM.Submitted_By_Shortname__c = ptsrRequest.submitedBy;
                DFM.Submitted_Date__c = ptsrRequest.submitedDate;
                DFM.FAB__c = ptsrRequest.fab;
                DFM.Created_By_Shortname__c = ptsrRequest.createdBy;
                DFM.Created_Date__c = ptsrRequest.createdDate;
                DFM.DFM_Transaction_Id__c = ptsrRequest.transactionId;
                DFM.isAllPartyApproved__c=true;
                DFM.Progressbar_staus__c='Execution';
                DFM.Revert_Stage__c='none';
                if(waiver <> NULL && !waiver.isEmpty()){
                    DFM.Id = waiver[0].Id;
                } 
                upsert DFM;
                
                // Share DRC or DFM waiver collaborator with FAE and created by and submited by user
                // as soon as Waiver collaboratort report is relase from Swift PTSR system
                Set<Id> contactIds = new Set<Id>();
                List<Portal_Tab_Access__c> accessSetup = [SELECT Id,User__c FROM Portal_Tab_Access__c where PTRF__c=true and Account__r.Short_Name__c=:ptsrRequest.custShortName]; 
                for(Portal_Tab_Access__c accessSetupObj:accessSetup ){
                    contactIds.add(accessSetupObj.User__c);
                }
            
                List<String> uRoles = new List<String>{'Field Application Engineer','Primary Field Application Engineer'};
        		Set<Id> FAEs = DfmUtilityCls.getATPUsersByRole(ptsrRequest.custShortName,uRoles);
        		Set<Id> custIds = DfmUtilityCls.getCustomers(ptsrRequest.createdBy,ptsrRequest.submitedBy);
        		 Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
                 if(FAEs<>NULL && !FAEs.isEmpty()) {
                  if (custIds<>NULL && !custIds.isEmpty()){
                    FAEs.addAll(custIds);
                  }
                    if (contactIds<>NULL && !contactIds.isEmpty()){
                    FAEs.addAll(contactIds);
                  }
                DfmUtilityCls.shareRecord(DFM.Id,FAEs,'Read');
               
				}
                
                Set<Id> dfmSuperUsersIds = DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DWC_Super_Users').keySet():NULL;
                if(dfmSuperUsersIds<>NULL && !dfmSuperUsersIds.isEmpty()) {

                    DfmUtilityCls.shareRecord(DFM.Id,dfmSuperUsersIds,'Edit');
                   
                }
                
                // Fetch DFM header details from Swift 
                WaiverCollaboratorService.getDfmDetails(ptsrRequest.ptsrNumber,DFM.Id);
                //Fetch PTSR header details from swift 
                WaiverCollaboratorService.getPTSRDetails(ptsrRequest.ptsrNumber,DFM.Id);
                // Fetch Chip details from swift
                WaiverCollaboratorService.getChipDetails(ptsrRequest.ptsrNumber,DFM.Id);
              	//Fetch DRC layout data
              	WaiverCollaboratorService.getDRCLayoutDetails(ptsrRequest.ptsrNumber,DFM.Id);
            
            	WaiverCollaboratorService.getAttachmentDetails(ptsrRequest.ptsrNumber,DFM.Id);
               
               
                return new PTSRResponseElements(ptsrRequest.transactionId,DFM.PTSR_Number__c,DFM.Id,'','Success','',+baseUrl+ '/' + DFM.Id);
            
        } catch (exception e){
            //system.debug('e.getMessage() ###### '+e.getMessage());
            GlobalUtility.logMessage('Debug', 'WaiverCollaboratorService', 'createWaiverCollaboratorReport()', String.valueOf(DFM.Id), 'waver collaborator service', 'this is error message', 'payLoad','Other SFDC',e, 2300);
            Database.rollback(sp);
            return new PTSRResponseElements(ptsrRequest.transactionId,ptsrRequest.ptsrNumber,DFM.Id,DFM.Name,'Fail',e.getMessage(),'');
        }
    } 
    
    // share DFM report with customers and FAEs
    
    // Response service
    webservice static PTSRResponseElements getDfmReponse(Id DfmId){

        List<Wavier_Collaborator__c> waiverReport;
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        
        if (DfmId<>NULL){
            waiverReport = [SELECT Id,Name,DFM_Transaction_Id__c,PTSR_Number__c FROM Wavier_Collaborator__c WHERE Id = :DfmId];
        }
        if (waiverReport<>NULL && !waiverReport.isEmpty()){
            
            return new PTSRResponseElements(waiverReport[0].DFM_Transaction_Id__c,waiverReport[0].PTSR_Number__c,waiverReport[0].Id,waiverReport[0].Name,'Success','',+baseUrl+ '/' + waiverReport[0].Id);
        } else {
            return null;
        }
        
    }
    
    @future (callout=true)
    private static void getDfmDetails(String ptsrNo,Id dfmId){
        system.debug('inside getDfmDetails ####### ');
        QueryPtsrServiceCls.QueryPTSRService_pt ptsrObj = new QueryPtsrServiceCls.QueryPTSRService_pt();
            
        List<QueryPtsrServiceCls.GetDFMDetailsResponseDetailType> dfmDetails =  ptsrObj.GetDFMDetails(ptsrNo); 
        system.debug('dfmDetails ######### '+dfmDetails);
        
        if (dfmDetails<>NULL && !dfmDetails.isEmpty()){
            WaiverCollaboratorService.setDfmDetails(dfmDetails[0],dfmId);
        }   
             
    }
    
    @future (callout=true)
    private static void getChipDetails(String ptsrNo,Id dfmId){
        
        QueryPtsrServiceCls.QueryPTSRService_pt ptsrObj = new QueryPtsrServiceCls.QueryPTSRService_pt();
        
        List<QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType> dfmChipDetails = ptsrObj.GetDFMChipsDetails(ptsrNo);
        system.debug('dfmChipDetails >>>>>>>>>>> '+dfmChipDetails);
        
        if (dfmChipDetails<>NULL && !dfmChipDetails.isEmpty()){
            WaiverCollaboratorService.setDfmchipDetails(dfmChipDetails,dfmId);
        }   
    }
    
    @future (callout=true)
    private static void getPTSRDetails(String ptsrNo,Id dfmId){
        
        QueryPtsrServiceCls.QueryPTSRService_pt ptsrObj = new QueryPtsrServiceCls.QueryPTSRService_pt();
        List<QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType> ptsrDetails = ptsrObj.GetPTSRDetails(ptsrNo);
        system.debug('ptsrDetails >>>>>>>>>>>> '+ptsrDetails);
        
        if (ptsrDetails<>NULL && !ptsrDetails.isEmpty()){
            WaiverCollaboratorService.setPtsrDetails(ptsrDetails[0],dfmId);
        }       
    }
    
    
    @future (callout=true)
    private static void getDRCLayoutDetails(String ptsrNo,Id dfmId){
        
        QueryPtsrServiceCls.QueryPTSRService_pt ptsrObj = new QueryPtsrServiceCls.QueryPTSRService_pt();
        List<QueryPtsrServiceCls.GetDRCDetailsResponseDetailType> ptsrDetails = ptsrObj.GetDRCDetails(ptsrNo);
        system.debug('ptsrDetails >>>>>>>>>>>> '+ptsrDetails);
        
        if (ptsrDetails<>NULL && !ptsrDetails.isEmpty()){
            //to do add the layout details
             QueryPtsrServiceCls.GetDRCDetailsResponseDetailType[] drcRespTypeList= ptsrDetails;
             if(drcRespTypeList!=null && drcRespTypeList.size()>0){
                Wavier_Collaborator__c w=new Wavier_Collaborator__c(id=dfmId);
                w.Layout_Type__c=drcRespTypeList[0].LayoutType;
                w.Other_Layout_Type__c=drcRespTypeList[0].OtherLayoutType;
                w.Layout_Source__c=drcRespTypeList[0].LayoutSource;
                w.Other_Layout_Source__c=drcRespTypeList[0].OtherLayoutSource;
                w.DRCServiceoption__c=drcRespTypeList[0].DRCServiceOption;
                w.Additional_Comment__c=drcRespTypeList[0].AdditionalComments;
                //to add stop trigger
                DfmUtilityCls.stopTrigger=true;
                update w;
                
             }
             
             
        }       
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
             
    }
    
    
    // Update DFM details
    public static void setDWCAttachmentDetails(List<Queryptsrattachments.GetPTSRAttachmentResponseDetailsType> dwcAttachmentDetails,Id DfmId){
        
        system.debug('Inside setDfmDetails #### ');
        Wavier_Collaborator__c DFM = new Wavier_Collaborator__c();
        DFM.Id = DfmId;
        
        List<DWC_Attachment__c> existingAttachmentList = [select id from DWC_Attachment__c where Waiver_Collaborator__c =:DfmId];
        if(existingAttachmentList.size()>0){
            delete existingAttachmentList;
        }
        
        List<DWC_Attachment__c> newAttachmentList = new List<DWC_Attachment__c>();
        for (Queryptsrattachments.GetPTSRAttachmentResponseDetailsType attach : dwcAttachmentDetails){
           DWC_Attachment__c attachmentObj = new  DWC_Attachment__c();
           attachmentObj.Attach_To__c=attach.AttachTo;
           attachmentObj.Content_Type__c=attach.ContentType;
           attachmentObj.Created_By__c= attach.CreatedBy;
           DateTime crtdDate = constructDate(attach.CreatedDate); 
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
    
    public Static DateTime constructDate(String src){
        
        //src = '2015-09-09T16:56:33.75-07:00';
        //DateTime dt = new DateTime();
        String[] str = src.split('T');
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
            System.debug('myDate >>>> '+myDate);
            String newdate1 = myDate.format( 'yyyy.MM.dd HH:mm');
            //DateTime newGMTTime = DateTime.parse(newdate);
              
            System.debug('myDate >>>> '+newdate1);
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
            System.debug('newmydate >>>> '+newmydate);
            System.debug('myDate >>>> '+myDate);
             newdate1 = myDate.format( 'yyyy.MM.dd HH:mm');
            //DateTime newGMTTime = DateTime.parse(newdate);
              
            System.debug('myDate >>>> '+newdate1);
        }
        return newdate1;
    }

    
    
    
    
    
    // Add DFM Chip details to waiver collaborator object
    public static void setDfmchipDetails(List<QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType> dfmChipDetails,Id dfmId){
        List<Chip__c> lstOfDfmChip = new List<Chip__c>(); 
        Wavier_Collaborator__c waiverReport = [SELECT Id,Name,isMulti__c,File_Name__c, File_Size__c,DFM_Transaction_Id__c,PTSR_Number__c,Prime_Die__c,Prime_Die_Name__c,DFMServiceOption__c,DFM_Design_Type__c,PTSR_Service_Type__c FROM Wavier_Collaborator__c WHERE Id = :DfmId];
        String collaboratorPrimeDiename = '';
        if(dfmChipDetails!=null && dfmChipDetails.size()>1){
        	waiverReport.isMulti__c=true;
        }
        
        for (QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType chip : dfmChipDetails){
            
            Chip__c dfmChipObj = new Chip__c();
            
            dfmChipObj.Wavier_Collaborator__c = dfmId;
            dfmChipObj.Tapeout__c = chip.Tapeout;
            dfmChipObj.Chip_Name__c = chip.ChipName;
            collaboratorPrimeDiename= chip.ChipName;
            if(collaboratorPrimeDiename <> null && collaboratorPrimeDiename !=''){
            waiverReport.Prime_Die__c=collaboratorPrimeDiename;
            }
            if(chip.FileSize <> null && chip.FileSize !=''){
            waiverReport.File_Size__c=chip.FileSize;
            }
            if(chip.FileName <> null && chip.FileName !=''){
            waiverReport.File_Name__c=chip.FileName;
            }
            waiverReport.Top_Cell_Name__c =chip.TopCellName;
            dfmChipObj.File_Source__c = chip.FileSource;
            dfmChipObj.Top_Cell_Name__c = chip.TopCellName;
            dfmChipObj.File_Directory__c = chip.FileDirectory;
            dfmChipObj.Source_PTSR_Number__c = chip.SourcePTSRNumber;
            dfmChipObj.File_Name__c = chip.FileName;
            dfmChipObj.Database_Name__c = chip.DatabaseName;
            dfmChipObj.File_Size__c = chip.FileSize; 
            dfmChipObj.Database_Size__c = chip.DBSize;
            dfmChipObj.Md5Sum__c = chip.Md5Sum;
            dfmChipObj.File_Time_stamp__c = chip.FileTimestamp;
            dfmChipObj.WCLowerLeft_X__c = chip.WCLowerLeft_X;
            dfmChipObj.WCLowerLeft_Y__c = chip.WCLowerLeft_Y;
            dfmChipObj.WCUpperRight_X__c = chip.WCUpperRight_X;
            dfmChipObj.WCUpperRight_Y__c = chip.WCUpperRight_Y;
            dfmChipObj.AntiClockwise_Rotation__c = chip.AntiClockwiseRotation;
            dfmChipObj.EBeamShrink__c = chip.EBeamShrink;
            dfmChipObj.Chip_Size_X__c = chip.ChipSize_X;
            dfmChipObj.Chip_Size_Y__c = chip.ChipSize_Y;
            dfmChipObj.TapeIn_File_ID__c = chip.TapeInFileID;
            dfmChipObj.TapeIn_Database_ID__c = chip.TapeInDatabaseID;
            dfmChipObj.TapeIn_DB_Cell_ID__c = chip.TapeInDBCellID;
            
            lstOfDfmChip.add(dfmChipObj);
            
        }
        
        if (!lstOfDfmChip.isEmpty()){
            insert lstOfDfmChip; 
        }
        
        if(collaboratorPrimeDiename <> null && collaboratorPrimeDiename !='' && waiverReport<>null && waiverReport.Id <>null){
            DfmUtilityCls.initialExecution=true;
            update waiverReport;
        }
        
    }
    // Update DFM details
    public static void setDfmDetails(QueryPtsrServiceCls.GetDFMDetailsResponseDetailType dfmDetails,Id DfmId){
        
        system.debug('Inside setDfmDetails #### ');
        Wavier_Collaborator__c DFM = new Wavier_Collaborator__c();
        DFM.Id = DfmId;
        
        if (!String.isEmpty(dfmDetails.DFMServiceDRCPlus) && 
                (dfmDetails.DFMServiceDRCPlus.toUpperCase() =='TRUE' ||dfmDetails.DFMServiceDRCPlus.toUpperCase() =='YES'
                || dfmDetails.DFMServiceDRCPlus=='1')){
                    
            DFM.DFM_Service_DRCPLUS__c = true;
            
        } else {
            DFM.DFM_Service_DRCPLUS__c = false;
        }
        if (!String.isEmpty(dfmDetails.DFMServiceMCDMAS) && 
            (dfmDetails.DFMServiceMCDMAS.toUpperCase() == 'TRUE' ||dfmDetails.DFMServiceMCDMAS.toUpperCase() == 'YES' 
            || dfmDetails.DFMServiceMCDMAS =='1')){
                
            DFM.DFM_Service_MCDMAS__c = true;
        } else {
            DFM.DFM_Service_MCDMAS__c = false;
        }
        if (!String.isEmpty(dfmDetails.DFMServiceCMPModel) && 
            (dfmDetails.DFMServiceCMPModel.toUpperCase()=='TRUE'|| 
            dfmDetails.DFMServiceCMPModel.toUpperCase()=='YES' || dfmDetails.DFMServiceCMPModel=='1')){
            DFM.CMP__c = true;
        } else {
            DFM.CMP__c = false;
        }
        if (!String.isEmpty(dfmDetails.DFMServiceCMPModel) && 
            (dfmDetails.DFMServiceCMPModel.toUpperCase()=='TRUE'|| 
            dfmDetails.DFMServiceCMPModel.toUpperCase()=='YES' || dfmDetails.DFMServiceCMPModel=='1')){
            DFM.DFM_Service_CMP_Model__c = true;
        } else {
            DFM.DFM_Service_CMP_Model__c = false;
        }
        if (!String.isEmpty(dfmDetails.DFMServiceCAA) && 
            (dfmDetails.DFMServiceCAA.toUpperCase()=='TRUE' ||
            dfmDetails.DFMServiceCAA.toUpperCase()=='YES'|| dfmDetails.DFMServiceCAA=='1')){
                
            DFM.DFM_Service_CAA__c = true;
        } else {
            DFM.DFM_Service_CAA__c = false;
        }
        if(!String.isEmpty(dfmDetails.DFMServiceLitho) && 
            (dfmDetails.DFMServiceLitho.toUpperCase()=='TRUE' ||
            dfmDetails.DFMServiceLitho.toUpperCase()=='YES' || dfmDetails.DFMServiceLitho=='1')){
                
            DFM.DFM_Service_Litho__c = true;
        } else {
            DFM.DFM_Service_Litho__c = false;
        }
        DFM.DFM_Design_Type__c = dfmDetails.DFMDesignType;
        DFM.DFM_IPID__c = dfmDetails.DFM_IPID;
        DFM.Metal_Stacks__c = dfmDetails.MetalStacks;       
        DFM.Account_Manager__c = dfmDetails.AccountManager;
        DFM.DFM_Engineer__c = dfmDetails.DFMEngineer;
        DFM.QA_Engineer__c = dfmDetails.QAEngineer;
        DFM.Product_Line_Management__c = dfmDetails.ProdLineMngmt;
        DFM.Expected_Validation_Completion_Date__c = dfmDetails.ExpectedValidationCompletionDate;
        DFM.Expected_Execution_Completion_Date__c = dfmDetails.ExpectedExecutionCompletionDate;
        DFM.Expected_QA_Completion_Date__c = dfmDetails.ExpectedQACompletionDate;
        DFM.ExpectedDFM_Review_Completion_Date__c = dfmDetails.ExpectedDFMReviewCompletionDate;
        DFM.PLMDFM_Service_Request_Number__c = dfmDetails.PLMDFMServiceRequestNumber;
        
        DFM.DFMServiceOption__c = dfmDetails.DFMServiceOption;
        DfmUtilityCls.initialExecution=true;
        
        Set<Id> dfmManagerIds = DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team')<>NULL ?DfmUtilityCls.getUsersFromPublicGroup('DFM_Waiver_Team').keySet():NULL;
      
        //Set the short flow progress bar status
        if(dfmDetails <> null && dfmDetails.DFMServiceOption <> null && dfmDetails.DFMServiceOption != '' && dfmDetails.DFMServiceOption=='DFM Services and Analysis') {
           
            
                    if(dfmManagerIds<>NULL && !dfmManagerIds.isEmpty()) {
                        //added to share the dfm record with collaborator managers
                        DfmUtilityCls.shareRecord(DFM.Id,dfmManagerIds,'Edit');
                    }
                    
            DFM.Progressbar_staus__c='Initiated';
          }
        update DFM;     
    }
    // Update PTSR details of waiver collaborator
    public static void setPtsrDetails(QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType ptsrDetails,Id DFMId){

        Wavier_Collaborator__c DFM = new Wavier_Collaborator__c();      
        DFM.Id = DFMId;
        DFM.Customer_Full_Name__c = ptsrDetails.CustomerFullName;
        DFM.Tech_Geo__c = ptsrDetails.TechGeo;
        DFM.Process_ID__c = ptsrDetails.ProcessID;
        DFM.Mask_Set_Title__c = ptsrDetails.MaskSetTitle;
        
        if (!String.isEmpty(ptsrDetails.MaskSetTitle)){
            List<Mask_Set_Title__c> maskSetObjList = [SELECT Id,Name FROM Mask_Set_Title__c where Name=:ptsrDetails.MaskSetTitle];
            if (maskSetObjList<>NULL && !maskSetObjList.isEmpty()){
                DFM.Mask_Set_Title_ID__c = maskSetObjList[0].Id;                   
            }
            
        }
        
        DFM.Design_Rule_Main_Spec__c = ptsrDetails.DesignRuleMainSpec;
        DFM.Design_Rule_Main_Rev__c = ptsrDetails.DesignRuleMainRev;
        DFM.Design_Rule_Addendum_Spec__c = ptsrDetails.DesignRuleAddendumSpec;
        DFM.Design_Rule_Addendum_Ver__c = ptsrDetails.DesignRuleAddendumVer;
        DFM.FAE_Acc_ID__c = ptsrDetails.FEAccountID;
        DFM.D1_National__c = ptsrDetails.D1National;
        DFM.Secure_Device__c = ptsrDetails.SecureDevice;
        DFM.Process_Technology__c = ptsrDetails.ProcessTechnology;
        DFM.Tech_Type__c = ptsrDetails.TechType;
        DFM.PTSR_ID__c=ptsrDetails.PTSRID;  
        //system.debug('PTSRID++++' +DFM.PTSR_ID__c);
        DfmUtilityCls.initialExecution=true;
        update DFM;
        
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
        webservice String custShortName;
        webservice String ptsrStatus;
        webservice String submitedBy;
        webservice DateTime submitedDate;
        webservice String crmDeviceId;
        webservice String fab;
        webservice String createdBy;
        webservice DateTime createdDate;

        webservice String PARAM1;
        webservice String PARAM2;
        webservice String PARAM3;
        webservice String PARAM4;
        webservice String PARAM5;
        webservice String PARAM6;
        webservice String PARAM7;
        webservice String PARAM8;
        
    }   
    
}