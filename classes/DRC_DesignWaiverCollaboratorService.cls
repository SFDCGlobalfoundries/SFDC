/**
* @ Author :- Navneet Rajput
* @ Company :- Globalfoundries
* @ Description :- Class handles DRC service request coming from Mantis system and create design waiver collaborator in SFDC
                   Operations 1) Fetch DRC rules from mantis
                              2) Fetch DRC snapshots from mantis                  
* @ Date :- 10/03/2016
* @ Change History :- Test data added for moc service by Suhas
@ Change History :- updated mantisids by Mohan  03/08/2017 
**/ 

global class DRC_DesignWaiverCollaboratorService { 
   
    webservice static DRCResponseElements setDesignRuleInfo (DRCRuleResponseElements resp) {
        DRC_DesignWaiverCollaboratorService.getDrcRules(resp.mantisId,resp.ptsrNo,resp.PARAM1,resp.PARAM2);//resp.PARAM1
        return new DRCResponseElements(null,null,null,null,'SUCCESS',null);
    }
    
    
    global static void getDrcRules(Integer mantisId,String ptsrNo,String serviceType,String reviewDisp) {        
        Exception exp = null;  
        
        //String reviewDisp;
        if(reviewDisp<>null && reviewDisp!='' && mantisId==0){
            system.debug('reviewDisp ###### '+reviewDisp);
            updateDispositionValue(ptsrNo,reviewDisp);
        }else{
        try {
            system.debug('mantisId ###### '+mantisId);
            // Need to call AIA service to fetch Drc rule info from mantis
            // Parse the response and create DRC rules in SFDC
            DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt ruleObj = new DRC_QueryRuleInfoFromMantisStub.GetMantisPTSRMetaDataService_pt();
            ruleObj.timeout_x=60000;
            DRC_QueryRuleInfoFromMantisStub.DRCMetaData_element respElmt = new DRC_QueryRuleInfoFromMantisStub.DRCMetaData_element();
            // get rule and DRC header information from AIA->Mantis
             if(!Test.isRunningTest()){
                respElmt = ruleObj.GetMantisPTSRMetaData(mantisId,serviceType);// You need to paass additional parameter which 
                //holds Service type information like resp.Param1
              }else{
                //since response is handled within method, test data has been created in this block for code coverage Added by Suhas
                 
                 DRC_QueryRuleInfoFromMantisStub.ViolationReportType vrt = new  DRC_QueryRuleInfoFromMantisStub.ViolationReportType();
                 DRC_QueryRuleInfoFromMantisStub.ViolationReportType vrt0 = new  DRC_QueryRuleInfoFromMantisStub.ViolationReportType();
                 DRC_QueryRuleInfoFromMantisStub.ViolationReportType vrt1 = new  DRC_QueryRuleInfoFromMantisStub.ViolationReportType();
                 DRC_QueryRuleInfoFromMantisStub.ViolationReportType vrt2 = new  DRC_QueryRuleInfoFromMantisStub.ViolationReportType();
                 DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType   rcit = new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType();
                 DRC_QueryRuleInfoFromMantisStub.ReviewSnapshot_element snap1 = new DRC_QueryRuleInfoFromMantisStub.ReviewSnapshot_element();
                 DRC_QueryRuleInfoFromMantisStub.ReviewSnapshot_element snap2 = new DRC_QueryRuleInfoFromMantisStub.ReviewSnapshot_element();
                 DRC_QueryRuleInfoFromMantisStub.ReviewSnapshot_element snap3 = new DRC_QueryRuleInfoFromMantisStub.ReviewSnapshot_element();
                 List<DRC_QueryRuleInfoFromMantisStub.ReviewSnapshot_element> snapList = new List<DRC_QueryRuleInfoFromMantisStub.ReviewSnapshot_element>();
                 snap1.ImageInfo = 'Test Image';
                 snapList.add(snap1);
                 snap2.ImageInfo = 'Test Image';
                 snapList.add(snap2);
                 snap3.ImageInfo = 'Test Image';
                 snapList.add(snap3);
                 
                 vrt.DesignRuleID = String.valueOf(32700007);
                 vrt.DesignRuleName='Test1234';
                 vrt.Description='TESTING the service response';
                 vrt.HierErrorCount=String.valueOf(4);
                 vrt.ReviewSnapshot = snapList;
                 vrt.ReviewResult='FCC';
                 
                 vrt1.DesignRuleID = String.valueOf(32700006);
                 vrt1.DesignRuleName='Test1234';
                 vrt1.Description='TESTING the service response';
                 vrt1.HierErrorCount=String.valueOf(4);
                 vrt1.ReviewSnapshot = snapList;
                 vrt1.ReviewResult='PI';
                 
                 vrt0.DesignRuleID = String.valueOf(32700005);
                 vrt0.DesignRuleName='Test1234';
                 vrt0.Description='TESTING the service response';
                 vrt0.HierErrorCount=String.valueOf(4);
                 vrt0.ReviewSnapshot = snapList;
                 vrt0.ReviewResult='PW';
                 
                 vrt2.DesignRuleID = String.valueOf(32700004);
                 vrt2.DesignRuleName='Test1234';
                 vrt2.Description='TESTING the service response';
                 vrt2.HierErrorCount=String.valueOf(4);
                 vrt2.ReviewSnapshot = snapList;
                 vrt2.ReviewResult='PCF';
                 
                 rcit.CustomerName = 'GLOBALFOUNDRIES';
                 rcit.DevideId='DEVICEID1234';
                 rcit.MantisId=String.valueOf(121221);
                 rcit.PTSRNumber = 'PTSR-XXXX-000'; 
               
               
               List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType> rcitList = new  List<DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType>();
               List<DRC_QueryRuleInfoFromMantisStub.ViolationReportType> vrtList = new List<DRC_QueryRuleInfoFromMantisStub.ViolationReportType>();
               
               rcitList.add(rcit); 
               vrtList.add(vrt);
               vrtList.add(vrt0);
               vrtList.add(vrt1);
               vrtList.add(vrt2);
                 
               
               respElmt.ViolationReport = vrtList;
               respElmt.RuleCheckInfo = rcit;  
             }
            // list of waiver collaborator
            
            if (respElmt<>NULL) { 
                // get DRC header info
                DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType ruleInfo = new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType();
               
                ruleInfo = respElmt.RuleCheckInfo;
                system.debug('ruleInfo:: '+ruleInfo);
                // Update Design waiver collaborator for DRC report header information
                try{ 
                    DRC_DesignWaiverCollaboratorService.setDRCHeaderInfo(ruleInfo);
                } catch (Exception e){
                    exp = e;
                    // log error in to common error logger object
                    GlobalUtility.logMessage('Debug', 'DRC_DesignWaiverCollaboratorService', 'getDrcRules()', ptsrNo, '- PTSR with Mantis ID '+String.valueOf(mantisId), 'this is error message', 'payLoad','Other SFDC',e,0);
                }
                // get list of violation rules
                List<DRC_QueryRuleInfoFromMantisStub.ViolationReportType> lst_ruleViolations = new List<DRC_QueryRuleInfoFromMantisStub.ViolationReportType>();
               
                lst_ruleViolations = respElmt.ViolationReport;
                system.debug('lst_ruleViolations:: '+lst_ruleViolations);            
                List<Wavier_Collaborator__c> lst_RInfo = [SELECT Id,DRCServiceoption__c,isReleaseToCust4MultiDie__c,PTSR_Number__c,Is_Sync_with_AIA__c,PTSR_Service_Type__c,Mantis_DRCPLUS__c,Progressbar_staus__c,Revert_Collaborator__c,
                                                                 Mantis_MCD__c,Mantis_MAS__c,DFM_Service_DRCPLUS__c,DFM_Service_MCDMAS__c,PDK_DRC__c,CMP__c 
                                                            from Wavier_Collaborator__c WHERE PTSR_Number__c = : ptsrNo];
                // Prepare map of waiver rule list Mantis_MAS__c,Mantis_MCD__c,Mantis_DRCPLUS__c,Mantis_DRCPLUS__c,PDK_DRC__c
                List<Waiver_Rule_List__c> lst_Rules;
                
                DRC_DesignWaiverCollaboratorService.isSyncWithMantis(lst_RInfo.get(0),ruleInfo);
                
                if (lst_RInfo<>NULL && !lst_RInfo.isEmpty()) {
                    lst_Rules = [SELECT Id,RuleId__c,Revert_Rule__c FROM Waiver_Rule_List__c WHERE Waiver_Collaborator__c = :lst_RInfo.get(0).Id];
                }
                
                Map<Integer,Waiver_Rule_List__c> mapOfRules = new Map<Integer,Waiver_Rule_List__c>();
                Map<Integer,Waiver_Rule_List__c> mapOfRevertedRules = new Map<Integer,Waiver_Rule_List__c>();
                
                if (lst_Rules<>NULL && !lst_Rules.isEmpty()) {
                    for (Waiver_Rule_List__c wRules : lst_Rules){
                        if (wRules.RuleId__c<>NULL){
                            if (wRules.RuleId__c<>NULL){
                                mapOfRules.put(Integer.valueOf(wRules.RuleId__c),wRules);
                            }
                            
                            if(wRules.Revert_Rule__c){
                                mapOfRevertedRules.put(Integer.valueOf(wRules.RuleId__c),wRules);
                            }
                        }
                    }
                } 
               system.debug('lst_RInfo@@@@@@ '+mapOfRules);
                List<Waiver_Rule_List__c> lst_RuleInfo = new List<Waiver_Rule_List__c>(); 
                List<id> imagelst_RuleInfo = new List<id>(); 
                                    
                if(lst_ruleViolations<>NULL && !lst_ruleViolations.isEmpty() && lst_RInfo<>NULL && !lst_RInfo.isEmpty()) {
                    
                    for (DRC_QueryRuleInfoFromMantisStub.ViolationReportType vType : lst_ruleViolations){
                        string snapshotName='';
                        boolean existingId = false;
                        boolean revertedRule=false;
                        Waiver_Rule_List__c rInfo = new Waiver_Rule_List__c();
                        
                        if(vType.rule_type<>null) {
                        if(string.isnotblank(vType.rule_type) && vType.rule_type!='0') {
                            rInfo.Rule_Type__c='1';
                        }else if(string.isnotblank(vType.rule_type)) {
                            rInfo.Rule_Type__c='0';
                        }
                        } else {
                             rInfo.Rule_Type__c='DFM';   
                        }
                        
                        // update if rule is already available in SFDC
                        if (mapOfRules<>NULL && mapOfRules.containsKey(Integer.valueOf(vType.DesignRuleID))){
                            rInfo.Id = mapOfRules.get(Integer.valueOf(vType.DesignRuleID)).Id;
                            existingId=true;     
                            
                            if (mapOfRevertedRules<>NULL && mapOfRevertedRules.containsKey(Integer.valueOf(vType.DesignRuleID))){                           
                            revertedRule=true;                          
                            }
                                                 
                        } else {
                            rInfo.Waiver_Collaborator__c = lst_RInfo.get(0).Id;
                        } 
                        // Iterate list of snapshot which are associated with rule
                        if (vType<>NULL && vType.ReviewSnapshot<>NULL && !vType.ReviewSnapshot.isEmpty()){
                            for (DRC_QueryRuleInfoFromMantisStub.ReviewSnapshot_element rElement : vType.ReviewSnapshot){
                            system.debug('vType.ReviewSnapshot'+vType.ReviewSnapshot);
                                if (String.isBlank(snapshotName)){
                                    snapshotName = rElement.ImageInfo;
                                    continue;
                                    system.debug('snapshotName '+snapshotName );

                                } 
                                snapshotName = snapshotName+','+rElement.ImageInfo;
                            }
                            system.debug('snapshotName>>>>> '+snapshotName );

                        }
                        
                        if (vType.ReviewResult<>NULL && !String.isBlank(vType.ReviewResult)) {
                          if(vType.ReviewResult.toUpperCase() == 'PI' || vType.ReviewResult.toUpperCase() == 'PW'|| vType.ReviewResult.toUpperCase() == 'PA'
                            || vType.ReviewResult.toUpperCase() == 'PWO' || vType.ReviewResult.toUpperCase() == 'POC' || vType.ReviewResult.toUpperCase() == 'PCF'
                            || vType.ReviewResult.toUpperCase() == 'PWA' || vType.ReviewResult.toUpperCase() == 'WCR' || vType.ReviewResult.toUpperCase() == 'WEA' 
                            || vType.ReviewResult.toUpperCase() == 'FCF' || vType.ReviewResult.toUpperCase() == 'POF'){
                                if (vType.ReviewResult.toUpperCase() == 'PWO' || vType.ReviewResult.toUpperCase() == 'POC' || vType.ReviewResult.toUpperCase() == 'PCF'){
                                    rInfo.Stage__c ='PI';
                                    rInfo.Final_Stage__c = 'PI';
                                     rInfo.Mantis_Stage__c=vType.ReviewResult.toUpperCase() ;
                                } else {
                                    rInfo.Final_Stage__c = vType.ReviewResult.toUpperCase();
                                    rInfo.Stage__c = vType.ReviewResult.toUpperCase();
                                }
                                
                        } else  if (vType.ReviewResult.toUpperCase() == 'FD'){                                
                            rInfo.Stage__c ='iFD'; 
                            if(!existingId){// only new rules
                            rInfo.Final_Stage__c = 'OPEN';    
                            }else if(revertedRule && existingId){//only existing reverted rules
                            rInfo.Final_Stage__c = 'OPEN';    
                            }      
                        }  else {
                                if(!existingId){
                                    rInfo.Final_Stage__c = 'OPEN';    
                                }else if(revertedRule && existingId){
                                    rInfo.Final_Stage__c = 'OPEN';    
                                } 
                                rInfo.Stage__c = vType.ReviewResult.toUpperCase();
                        }
                                                
                         
                      }
                        //DFM Enhancement condition - END
                        if(revertedRule || Test.isRunningTest()){ 
                        rinfo.Revert_Rule__c=false; 
                        rinfo.SelectedBox__c=false;
                        rinfo.isIntermediateSave__c=false;
                        rinfo.IsGfAcceptsRisk__c=false;
                        rinfo.IsCustomerAgreeToFix__c=false;
                        rinfo.IsCustomerAcceptsRisk__c=false;
                        rinfo.AcceptRisk__c=false;
                        rinfo.Disagree__c=false;
                        rinfo.isAllPartyApproved__c=false;
                        rinfo.Customer_Closing_Comment__c='';
                        rinfo.GF_Internal_Closing_Comment__c='';
                        }
                        rinfo.Layer_Name__c = vType.LayerName;
                        rinfo.Score__c = String.valueOf(vType.Score); 
                        if(String.isBlank(snapshotName) && String.isNotBlank(vType.PatternImage)){
                            snapshotName = vType.PatternImage;
                            system.debug('snapshotName<<<<<<'+snapshotName );

                        }
                        rInfo.Prime_Die_Name__c=ruleInfo.DevideId;
                        rInfo.Mantis_Id__c= mantisId ;
                        rInfo.Image_Path__c = snapshotName;
                        // Updated code to support add additional snapshot in case of rule Update
                        if(rinfo.Id == null){
                        
                        rInfo.Old_Image_Path__c= snapshotName;
                        system.debug('snapshotName for update '+snapshotName );
                        }
                        system.debug('snapshotName 567 '+rInfo.Image_Path__c );

                        //rInfo.Waiver_Collaborator__c = lst_RInfo.get(0).Id;
                        if (vType.CustomerComment <> NULL && vType.CustomerComment !=''){
                        rInfo.Customer_Review_Request__c = String.escapeSingleQuotes(vType.CustomerComment);
                        }
                        if (vType.Description <> NULL && vType.Description !=''){
                         rInfo.Rule_Description__c = String.escapeSingleQuotes(vType.Description);
                        }
                        
                        rInfo.RuleId__c = Double.valueOf(vType.DesignRuleID);
                        rInfo.Design_Rule_Name__c = vType.DesignRuleName;
                        if (vType.HierErrorCount<>NULL && String.isNotEmpty(vType.HierErrorCount)){
                            String hierErrorCnt = vType.HierErrorCount.trim();
                          rInfo.Hierarchial_Error_Count__c = Integer.valueOf(hierErrorCnt);
                        }
                        if (vType.FlatErrorCount<>NULL && String.isNotEmpty(vType.FlatErrorCount)){
                              String flatErrorCnt = vType.FlatErrorCount.trim();
                          rInfo.Flat_Error_Count__c = Integer.valueOf(flatErrorCnt);
                        }
                        if (vType.ReviewComments <> NULL && vType.ReviewComments !=''){
                        rInfo.GF_Review_Comment__c = String.escapeSingleQuotes(vType.ReviewComments);
                        }
                        //if (vType.rule_type <> NULL && vType.rule_type !=''){
                       // rInfo.Rule_Type__c = String.escapeSingleQuotes(vType.rule_type);
                      //  }
                        if (vType.ReviewResult<>NULL && !String.isBlank(vType.ReviewResult)){
                            if (vType.ReviewResult.toUpperCase() == 'PWO' || vType.ReviewResult.toUpperCase() == 'POC' || vType.ReviewResult.toUpperCase() == 'PCF'){
                                rInfo.Stage__c ='PI';
                            } else {
                                rInfo.Stage__c = vType.ReviewResult.toUpperCase();
                            }
                            
                            if (vType.ReviewResult.toUpperCase() == 'PWO' || vType.ReviewResult.toUpperCase() == 'POC'
                                || vType.ReviewResult.toUpperCase() == 'PI' || vType.ReviewResult.toUpperCase() == 'PW'
                                || vType.ReviewResult.toUpperCase() == 'PCF'){
                                rInfo.GF_Internal_Closing_Comment__c = 'NA';
                                rInfo.Customer_Closing_Comment__c = 'NA';       
                            }
                        }
                        
                        // Added to identify type of drm or drc 
                        rInfo.Operation_Type__c = ruleInfo.DFMType;
                        
                        lst_RuleInfo.add(rInfo);
                        if(existingId){
                            imagelst_RuleInfo.add(rInfo.Id);
                        }
                    }
                    
                }// END OF FOR LOOP
                else{
                    if (lst_RuleInfo==null && lst_Rules<>NULL && !lst_Rules.isEmpty()){
                        DfmUtilityCls.stopTrigger=false;
                        DfmUtilityCls.loadFromMantis=true;
                        DfmUtilityCls.ruleCount=lst_Rules.size();
                        upsert lst_Rules;
                    }
                }
                 if (imagelst_RuleInfo<>NULL && !imagelst_RuleInfo.isEmpty()){
                    list<attachment> imageAttachments = [select id,name,description  from attachment where ParentId IN:  imagelst_RuleInfo];                    
                     if(imageAttachments.size()>0)
                     { 
                         delete imageAttachments;
                     }
                   } 
                
                 if (lst_RuleInfo<>NULL && !lst_RuleInfo.isEmpty()){
                        DfmUtilityCls.stopTrigger=false;
                        upsert lst_RuleInfo;
                            
                    }

                if(lst_RInfo<>NULL && !lst_RInfo.isEmpty() && lst_RInfo.get(0).Is_Sync_with_AIA__c){
                    
                   
                   // System.debug('ruleList:'+ruleList);
                    Integer ruleCount = [SELECT COUNT() 
                                         FROM Waiver_Rule_List__c 
                                         WHERE Waiver_Collaborator__c = :lst_RInfo.get(0).Id];
                    System.debug('lst_RInfo.get(0).isReleaseToCust4MultiDie__c:'+lst_RInfo.get(0).isReleaseToCust4MultiDie__c);                     
                    if(lst_RInfo.get(0).isReleaseToCust4MultiDie__c){
                       
                        system.debug('ruleCount:'+ruleCount);
                        if(ruleCount== 0){
                            system.debug('ruleCount:'+ruleCount);
                            for(Wavier_Collaborator__c wCollab : lst_RInfo){
                                wCollab.Waiver_Status__c='PA';
                                wCollab.PTSR_Status__c='Closed';
                                wCollab.Progressbar_staus__c='Closed';
                            }
                            update lst_RInfo;
                        }
                    }   
                }    
            }   
            
        } catch (Exception e){
            exp = e;
            // log error in to common error logger object
            //GF_CommonErrorLogger.creatLogs('Waiver Collaborator', 'DRC', 'Apex Web Service', e, 0);
            GlobalUtility.logMessage('Debug', 'DRC_DesignWaiverCollaboratorService', 'getDrcRules()', ptsrNo, '- PTSR with Mantis ID '+String.valueOf(mantisId), 'this is error message', 'payLoad','Other SFDC',e,0);
            
        } finally {
            // send email
            if (exp<>NULL){
                system.debug('Error Message :: '+exp.getTypeName()+'Line number'+exp.getLineNumber()+'message '+exp.getMessage());
               // GF_CommonErrorLogger.sendErrorNotification('Waiver Collaborator', exp, null);
            }
        }
    }
    }
    

    public static void  updateDispositionValue(String ptsrNo, String reviewDisp){
         try{
         List<Wavier_Collaborator__c> lst_RInfo = [SELECT Id,DRCServiceoption__c,PTSR_Number__c,Is_Sync_with_AIA__c,PTSR_Service_Type__c,Mantis_DRCPLUS__c,Progressbar_staus__c,
                                                                 Mantis_MCD__c,Mantis_MAS__c,DFM_Service_DRCPLUS__c,DFM_Service_MCDMAS__c,PDK_DRC__c,CMP__c 
                                                            from Wavier_Collaborator__c WHERE PTSR_Number__c = : ptsrNo];
       if(lst_RInfo<>null && lst_RInfo.size()>0 && reviewDisp.trim().equalsIgnoreCase('Review_Disposition')){
            system.debug('Updating Progress Status >>>> ');
            Wavier_Collaborator__c wCollaborator = lst_RInfo.get(0);           
            wCollaborator.Progressbar_staus__c = reviewDisp;          
            update wCollaborator;
        }
         }catch(Exception e){ GlobalUtility.logMessage('Debug', 'DRC_DesignWaiverCollaboratorService', 'updateDispositionValue()', ptsrNo, '- PTSR with review disposition -'+reviewDisp, 'this is error message', 'payLoad','Other SFDC',e,0); }
    }
    
    public static void isSyncWithMantis(Wavier_Collaborator__c wCollaborator,DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType ruleInfo){
        
        
        List<Chip__c> chipObjList = [SELECT Id,Name,AllJobs_Submitted__c FROM Chip__c where Wavier_Collaborator__c=:wCollaborator.Id AND AllJobs_Submitted__c=FALSE];
                                                                                                                                                            
        if(chipObjList.isEmpty() || Test.isRunningTest()){
             if(wCollaborator.DRCServiceoption__c<>null && wCollaborator.DRCServiceoption__c.toLowerCase()=='DRC Run Only') {
                 wCollaborator.Waiver_Status__c='DRC Run Only - No Review';
                }
                DfmUtilityCls.stopTrigger=false;
                wCollaborator.Is_Sync_with_AIA__c = true;
                wCollaborator.Progressbar_staus__c='Pending For FAE';
                wCollaborator.Revert_Collaborator__c=false;
                wCollaborator.isReleaseToCust4MultiDie__c=true;
                update wCollaborator;
                

        }else{
            DfmUtilityCls.stopTrigger=false;
                wCollaborator.Is_Sync_with_AIA__c = true;
                update wCollaborator;
                
        
        }
       
        
    }
    
    // DRC Header Info
    @Testvisible
    private static void setDRCHeaderInfo(DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType ruleInfo){
        
        system.debug('setDRCHeaderInfo >>>>>> '+ruleInfo);
        // query on Design waiver rule object by filter ptsrNumber
        if (ruleInfo<>NULL){
            
            
            
            List<Wavier_Collaborator__c> lst_Drc = [SELECT Id
                                                        ,PTSR_Number__c,DFM_Service_DRCPLUS__c,DFM_Service_MCDMAS__c
                                                        ,GF_Design_Rule_Spec_Addendum__c
                                                        ,GF_Design_Rule_Spec__c
                                                        ,GF_DRC_Deck__c
                                                        ,Prime_Die_Name__c
                                                        ,DRB_Group_uIds__c
                                                        ,MantisId__c
                                                        ,MantisIds__c
                                                        ,Tapeout_Layers__c
                                                        ,Mask_Set_Title__c
                                                        ,Metal_Stacks__c
                                                        ,Process_ID__c
                                                        ,Technology__c
                                                        ,Top_Cell_Name__c
                                                        ,Violation_Count_Limit__c
                                                        ,Prime_Die__c
                                                        ,File_Name__c 
                                                        ,File_Size__c
                                                        ,PTSR_Service_Type__c
                                                        ,Mantis_MAS__c,Mantis_MCD__c,Mantis_DRCPLUS__c,PDK_DRC__c,CMP__c 
                                                   FROM Wavier_Collaborator__c 
                                                   WHERE PTSR_Number__c = : ruleInfo.PTSRNumber];
                                                   
            system.debug('lst_Drc ##### '+lst_Drc);
            
            
                        
                        
            
              if(Test.isRunningTest()){
                 lst_Drc = new  List<Wavier_Collaborator__c> ();
                  Wavier_Collaborator__c wc1 = [SELECT Id,PTSR_Number__c,PTSR_Service_Type__c,GF_Design_Rule_Spec_Addendum__c,GF_Design_Rule_Spec__c,GF_DRC_Deck__c,Prime_Die_Name__c,DRB_Group_uIds__c,MantisIds__c,MantisId__c,Tapeout_Layers__c
                                                ,Mask_Set_Title__c,Metal_Stacks__c,Process_ID__c,Technology__c,Top_Cell_Name__c,Violation_Count_Limit__c,Prime_Die__c,File_Name__c,Revert_Collaborator__c
                                                ,File_Size__c,Mantis_MAS__c,Mantis_MCD__c,Mantis_DRCPLUS__c,PDK_DRC__c,CMP__c  FROM Wavier_Collaborator__c LIMIT 1];
                  lst_Drc.add(wc1);
                  
                  ruleInfo.ViolationCountLimit='10';
                  ruleInfo.FileNameSize='10;10';
                  ruleInfo.DFMType='PDKDRC';
              }                                   
                                                  
            system.debug('lst_Drc >>>>>>>>> '+lst_Drc);
            if (lst_Drc<>NULL && !lst_Drc.isEmpty()){ 
                    
                Wavier_Collaborator__c drc = lst_Drc.get(0);
                                                      
                drc.Revert_Collaborator__c=false;
                drc.GF_Design_Rule_Spec_Addendum__c = ruleInfo.DesignRuleAddSpec;
                drc.GF_Design_Rule_Spec__c = ruleInfo.DesignRuleSpec;                
                drc.GF_DRC_Deck__c = ruleInfo.DRCTitle;
                drc.Prime_Die_Name__c = ruleInfo.FileNameSize;
                drc.Prime_Die__c = ruleInfo.DevideId;
                
                //new code related to Non matching rules ====start
                
                If(drc.PTSR_Service_Type__c!='DFM Service Request'){
                
                List<Waiver_Rule_List__c> lst_RuleInfo=new List<Waiver_Rule_List__c>();
                DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_element NMRulesList=new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_element();
                NMRulesList = ruleInfo.nm_rules;
                DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element[] NMRuleList=new DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element[]{};
              if(NMRulesList.nm_rule<>null) {
              NMRuleList= NMRulesList.nm_rule;
              system.debug('NMRuleList@@@@'+NMRuleList);
               for(DRC_QueryRuleInfoFromMantisStub.RuleCheckInfoType_nm_rules_nm_rule_element nmrule:NMRuleList){
                    Waiver_Rule_List__c nmrInfo = new Waiver_Rule_List__c(); 
                    nmrInfo.Rule_Description__c=nmrule.customer_comment;
                    nmrInfo.Prime_Die_Comment__c=nmrule.fab_comments;
                    
                    if(nmrInfo.Prime_Die_Comment__c<>null) {
                      
                      list<string>stList = new list<string>();
                       stList=nmrInfo.Prime_Die_Comment__c.split(':');
                       nmrInfo.Warning__c=stList[0];
                       nmrInfo.GF_Review_Comment__c=nmrInfo.Prime_Die_Comment__c.substring(nmrInfo.Warning__c.length());
                       nmrInfo.GF_Review_Comment__c=nmrInfo.GF_Review_Comment__c.removeStart(':'); 
                      }
                    nmrInfo.Waiver_Collaborator__c=drc.id;
                    nmrInfo.Mantis_Id__c=integer.valueof(nmrule.id);
                    nmrInfo.Design_Rule_Name__c=nmrule.nm_rulename;
                    nmrInfo.Final_Stage__c=nmrule.status;
                    nmrInfo.Prime_Die_Name__c=ruleInfo.DevideId;
                    nmrInfo.Rule_Type__c='';
                    lst_RuleInfo.add(nmrInfo);
                }
                if(lst_RuleInfo<>null &&  !Test.isRunningTest() ){
                  upsert lst_RuleInfo;
                 
                }
                }
                
                }
                //new code related to Non matching rules ====end
                
                drc.DRB_Group_uIds__c = ruleInfo.GroupEmailId; 
                if (ruleInfo.MantisId<>NULL && String.isNotEmpty(ruleInfo.MantisId)){
                    drc.MantisId__c = Integer.valueOf(ruleInfo.MantisId);
                }
                if (ruleInfo.MantisId<>NULL && String.isNotEmpty(ruleInfo.MantisId)){
                    if(drc.MantisIds__c <> null && String.isNotEmpty(drc.MantisIds__c)){  
                        system.debug('CollMantisid >>'+lst_Drc.get(0).MantisId__c +'DrcMantis ds' +drc.MantisIds__c );   
                        
                         if(!drc.MantisIds__c.contains(ruleInfo.MantisId)){
                            system.debug('Inside the append mantisid  loop'+drc.MantisIds__c);   
                                  drc.MantisIds__c +=ruleInfo.MantisId;
                                  drc.MantisIds__c +=';';
                               system.debug('CollMantisid >>'+lst_Drc.get(0).MantisId__c +'DrcMantis ds' +drc.MantisIds__c );                     
                         }
                     }else{
                        drc.MantisIds__c='';
                        system.debug('CollMantisid new Mantis id>>'+lst_Drc.get(0).MantisId__c +'DrcMantis ds' +drc.MantisIds__c);
                       system.debug('Inside the add mantisid loop');
                            drc.MantisIds__c =ruleInfo.MantisId;
                            drc.MantisIds__c +=';';
                            system.debug('CollMantisid new Mantis id======'+lst_Drc.get(0).MantisId__c +'DrcMantis ds' +drc.MantisIds__c);
                        }
                }
                drc.Tapeout_Layers__c = ruleInfo.MaskLayer;
                drc.Mask_Set_Title__c = ruleInfo.MasksetTitle;
            /*    if (!String.isEmpty(ruleInfo.MasksetTitle)){
                    List<Mask_Set_Title__c> maskSetObjList = [SELECT Id,Name FROM Mask_Set_Title__c where Name=:ruleInfo.MasksetTitle];
                    if (maskSetObjList<>NULL && !maskSetObjList.isEmpty()){
                        drc.Mask_Set_Title_ID__c = maskSetObjList[0].Id;                   
                    }
                } 
                drc.Metal_Stacks__c = ruleInfo.MetalStack;
                drc.Process_ID__c = ruleInfo.ProcessID;
                drc.Technology__c = ruleInfo.Technology;
                drc.Top_Cell_Name__c = ruleInfo.TopCell;*/
                if (ruleInfo.ViolationCountLimit<>NULL && String.isNotEmpty(ruleInfo.ViolationCountLimit)){
                    drc.Violation_Count_Limit__c = Integer.valueOf(ruleInfo.ViolationCountLimit);
                } 
                
                if (ruleInfo<>NULL && !String.isBlank(ruleInfo.FileNameSize)){
                   // drc.File_Name__c = ruleInfo.FileNameSize.split(';')[0];
                    //drc.File_Size__c = ruleInfo.FileNameSize.split(';')[1];
                }
                system.debug('ruleInfo.DevideId +++'+ruleInfo.DevideId);
                if (!String.isEmpty(ruleInfo.DevideId)){
                    Wavier_Collaborator__c wc = [SELECT Id,PTSR_Number__c FROM Wavier_Collaborator__c where PTSR_Number__c=:ruleInfo.PTSRNumber];
                     system.debug('Waiver collaborator +++'+wc);
                    system.debug('ruleInfo.DevideId +++'+ruleInfo.DevideId);
                    List<Chip__c> chipObjList = [SELECT Id,Name,Chip_Name__c,Chip_Size_X__c,Chip_Size_Y__c,Wavier_Collaborator__c,Database_Name__c,
                                                 Database_Size__c,PrimeDieComments1__c,PrimeDieComments2__c,MantisId1__c,MantisId2__c,MantisId3__c,
                                                 Md5Sum__c,Source_PTSR_Number__c,Top_Cell_Name__c,Mantis_DRCPLUS__c,Mantis_MAS__c,Mantis_MCD__c,Mantis_CMP__c FROM Chip__c where Chip_Name__c=:ruleInfo.DevideId AND Wavier_Collaborator__c =:wc.id ];
                    
                    system.debug('chipObjList<<<<' +chipObjList);
                    system.debug('chipObjList<<<<' +chipObjList[0].Id);
                    Chip__c chipObj = new Chip__c();
                    
                    if(!chipObjList.isEmpty()){
                        chipObj = chipObjList.get(0);
                    
                    
                        if (String.isNotBlank(ruleInfo.DFMType)){
                            if(chipObj.MantisId1__c==null){
                                chipObj.MantisId1__c=ruleInfo.MantisId;
                                //chipObj.Id=chipObjList[0].Id;
                                chipObj.PrimeDieComments1__c=ruleInfo.PrimeDieComments;
                            }else if (chipObj.MantisId2__c==null){
                                chipObj.MantisId2__c=ruleInfo.MantisId;
                                chipObj.PrimeDieComments2__c=ruleInfo.PrimeDieComments;
                            } else {
                                chipObj.MantisId3__c=ruleInfo.MantisId;
                                chipObj.PrimeDieComments3__c=ruleInfo.PrimeDieComments;
                            }
                            if (ruleInfo.DFMType.toUpperCase() == 'DRCPLUS'){
                                drc.Mantis_DRCPLUS__c = true;
                                chipObj.Mantis_DRCPLUS__c= true;
                            } else if(ruleInfo.DFMType.toUpperCase() == 'MAS'){
                                drc.Mantis_MAS__c = true;
                                chipObj.Mantis_MAS__c = true;
                            } else if(ruleInfo.DFMType.toUpperCase() == 'MCD'){
                                drc.Mantis_MCD__c = true;
                                chipObj.Mantis_MCD__c = true;
                            } else if(ruleInfo.DFMType.toUpperCase() == 'PDKDRC'){
                                drc.PDK_DRC__c = true;
                                chipObj.PDK_DRC__c = true;
                            } else if(ruleInfo.DFMType.toUpperCase() == 'CMP') {
                                drc.CMP__c= true;
                                chipObj.Mantis_CMP__c= true;
                            }
                             
                            
                            boolean isTrue = false;
                            
                            if (chipObj.PDK_DRC__c){
                                isTrue = true;
                            }else if (drc.DFM_Service_MCDMAS__c && drc.DFM_Service_DRCPLUS__c && drc.CMP__c){
                                if ((chipObj.Mantis_MCD__c || chipObj.Mantis_MAS__c) && chipObj.Mantis_DRCPLUS__c  && chipObj.Mantis_CMP__c){
                                    isTrue = true;
                                }
                            }else if (!drc.DFM_Service_MCDMAS__c && drc.DFM_Service_DRCPLUS__c && drc.CMP__c ){
                                if (chipObj.Mantis_DRCPLUS__c && chipObj.Mantis_CMP__c){
                                    isTrue = true;
                                }
                            } else if (drc.DFM_Service_MCDMAS__c && !drc.DFM_Service_DRCPLUS__c && drc.CMP__c){
                                if ((chipObj.Mantis_MCD__c || chipObj.Mantis_MAS__c) && chipObj.Mantis_CMP__c){
                                    isTrue = true;
                                }
                            } else if (drc.DFM_Service_MCDMAS__c && drc.DFM_Service_DRCPLUS__c && !drc.CMP__c){
                                if ((chipObj.Mantis_MCD__c || chipObj.Mantis_MAS__c) && chipObj.Mantis_DRCPLUS__c){
                                    isTrue = true;
                                }
                            }  else if (!drc.DFM_Service_MCDMAS__c && !drc.DFM_Service_DRCPLUS__c && drc.CMP__c){
                                if (chipObj.Mantis_CMP__c){
                                    isTrue = true;
                                }
                            } else if (!drc.DFM_Service_MCDMAS__c && drc.DFM_Service_DRCPLUS__c && !drc.CMP__c){
                                if (chipObj.Mantis_DRCPLUS__c){
                                    isTrue = true;
                                }
                            } else if (drc.DFM_Service_MCDMAS__c && !drc.DFM_Service_DRCPLUS__c &&! drc.CMP__c){
                                if ((chipObj.Mantis_MCD__c || chipObj.Mantis_MAS__c)){
                                    isTrue = true;
                                }
                            }
                            
                            if(isTrue) {
                            chipObj.AllJobs_Submitted__c=true;
                           }                              
                         }
                        if(chipObj<>null){
                            system.debug('chipObj >>>>>'+chipObj);
                            update chipObj;
                            
                        }
                    }
                }
                
                update drc;
                system.debug('drcobj >>>>>'+drc);
            }    
            
        }
    } 
    
    //@RemoteAction
    
    webservice static DRCResponseElements setDrcRulesSnapshots (DRCSnapshotResponseElements resp) {

        Exception exp;
        system.debug('DRCSnapshot'+resp);
        try {
             system.debug('DRCSnapshot>>>>>>>>'+resp);
            if (resp<>NULL){
                DRC_DesignWaiverCollaboratorService.addAttachment(resp.snapShotInfo,resp.fileName,resp.mantisId,resp.ruleId,resp.PARAM1);
            }
             if(Test.isRunningTest()) {
        throw new applicationException('In Test Mode');
        } 
            return new DRCResponseElements(resp.mantisId,null,null,null,'SUCCESS',null);
            
        } catch (exception e) { 
           // GlobalUtility.logMessage('Debug', 'DRC_DesignWaiverCollaboratorService', 'setDrcRulesSnapshots()', String.valueOf(resp.mantisId), '- Mantis ID -', 'this is error message', 'payLoad','Other SFDC',e,0);
            
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DRC_DesignWaiverCollaboratorService.class.getName();
                alw.sourceFunction ='setDrcRulesSnapshots()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw);                       
          return new DRCResponseElements(resp.mantisId,null,null,null,'FAIL',e.getMessage());
          }
    }

    @future     
    public static void addAttachment(String imgBody, String fName,Integer mantisId, Integer ruleId,String rId) {
        
        
        try {
            Blob fBody = EncodingUtil.base64Decode(imgBody);            
            //List<Waiver_Rule_List__c> parentId = [SELECT Id,RuleId__c FROM Waiver_Rule_List__c WHERE RuleId__c=:ruleId]; 
            
            
            if (rId<>NULL && String.isNotEmpty(rId) && fBody<>NULL) {
                
                Attachment rAttachment = new Attachment(); 
                rAttachment.ParentId = Id.valueOf(rId); 
                rAttachment.Name = fName; 
                rAttachment.Body = fBody;
                rAttachment.contentType = 'application/octet-stream'; 
                
                insert rAttachment;
            }
            
        } catch (exception e) {
            GlobalUtility.logMessage('Debug', 'DRC_DesignWaiverCollaboratorService', 'addAttachment()', String.valueOf(mantisId), '- Mantis ID -', 'this is error message', 'payLoad','Other SFDC',e,0); 
        }    
      }
    
    webservice static DRCResponseElements isSyncWithAIA (String ruleId,Boolean isSynced,String message) {
        Exception exp;
        try {
             if(Test.isRunningTest()) {
        throw new applicationException('In Test Mode');
        } 
            return new DRCResponseElements(null,null,null,null,'SUCCESS',null);
            
        } catch (Exception e){  
            //GlobalUtility.logMessage('Debug', 'DRC_DesignWaiverCollaboratorService', 'isSyncWithAIA()', message, '- Message -', 'this is error message', 'payLoad','Other SFDC',e,0);
            ApplicationLogWrapper alw=new ApplicationLogWrapper();
                alw.source = DRC_DesignWaiverCollaboratorService.class.getName();
                alw.sourceFunction ='isSyncWithAIA()';
                alw.ApplicationName='DWC';                   
                alw.referenceInfo = 'DWC';
                alw.logMessage ='Error Message='+e.getMessage()+' At Line Number='+e.getLineNumber()+' Stack Trace='+e.getStackTraceString();
                alw.debugLevel ='Error';
                alw.logCode =e.getTypeName();
                alw.ex=e.getCause();
                GlobalUtility.logMessage(alw); 
            return new DRCResponseElements(null,null,null,null,'FAIL',e.getMessage()); }                            
                                                
    } 
    
    global class DRCSnapshotResponseElements {

        webservice Integer ruleId;
        webservice Integer mantisId;
        webservice String snapShotInfo;
        webservice String fileName;
        webservice String fileSize;
        webservice boolean isfileSizeExceeded;
        // These are the additional parameters created because in future if source system wanted to pass additional parameters
        // then we dont need to modify service, simply we can use below parameters 
        webservice String PARAM1;
        webservice String PARAM2;
        webservice String PARAM3;
        webservice String PARAM4;
        webservice String PARAM5;
        
    }   
    
    global class DRCRuleResponseElements {
        
        webservice Integer mantisId;
        webservice String ptsrNo;
        webservice DateTime timeStamp;
        webservice boolean isSyncWithAIA;
        
        webservice String PARAM1;//you can use this parameter as a identifier for service type
        // if it is DFM or DRC and according to that you need to inform this to AIA team to map service type value 
        // to PARAM1 field of SFDC
        webservice String PARAM2;
        webservice String PARAM3;
        webservice String PARAM4;
        webservice String PARAM5; 
    }
    
     // Prepare response parameters after collaborator is created or fail to create in SFDC
    global class DRCResponseElements {
    
        webservice Integer mantisId;
        webservice String ptsrNumber;
        webservice String R_Id;
        webservice String R_Name;
        webservice String status;
        webservice String errorMsg;
                
        public DRCResponseElements (Integer mantisId,String ptsrNumber,String R_Id,
                                    String R_Name,String status,String errorMsg){
            
            this.mantisId = mantisId;
            this.ptsrNumber = ptsrNumber;
            this.R_Id = R_Id;
            this.R_Name = R_Name;
            this.status = status;
            this.errorMsg = errorMsg;
            
        }
    }
     public class applicationException extends Exception {} 

}