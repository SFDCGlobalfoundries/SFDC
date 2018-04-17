/*  
Type Name: DesignSpecTrigger Trigger
Author: Cognizant 
Created Date: 20-June-2013
Reason: 
Change History:Restricting Auto Provisioning in SFDC:Case-4363
Author: Cognizant FV Team
Modified Date: Last-day-2013
Reason: Auto Provisioning is done at OopenText end.
……...
Change History: Changing Spec Owner field in document provisioning record for change of owner for parent specification record
Author: Cognizant
Modified Date:22/01/2014 
Reason: Case#00004561:  Subject: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
Author: Cognizant 
Modified Date:28/03/2014
Reason: Field change corresponding to CR # 4562
 */

trigger DesignSpecTrigger on Design_Spec__c (before insert, before update, after insert,after update) {

    Set<Id>  setDesignSpecIds = new Set<Id>();
    Set<Id>  setDesignSpecIdsToObsolete = new Set<Id>();
    Set<Id>  setDesignSpecIdsToReleased = new Set<Id>();
    Set<Id>  setDesignSpecIdsToInternal = new Set<Id>();
    Set<Id>  setDesignSpecIdsToInternal1 = new Set<Id>();
    Set<Id> setOfSARdSpecs = new Set<Id>();
    Set<Id> setOfSARdSpecs1 = new Set<Id>();
    Set<Id>  setDesignSpecIdsToWhitelist = new Set<Id>();//added for PLM change in spec
    Set<Id>  setDesignSpecIdsToWhitelist1 = new Set<Id>();//added for PLM change in spec
    Set<Id>  setDesignSpecIdsRevisionChanged = new Set<Id>();
    Set<Id>  specChangeSet= new Set<Id>(); // Collection to hold the specification records whose owner have changed for Case#00004561
    Integer maxRecLimitVal=(Label.DML_Max_Rec_For_Exec_Limit!=null)?Integer.valueOf(Label.DML_Max_Rec_For_Exec_Limit):1000;  // Variable to hold max records allowed for bulk DML operation for Case#00004561
    List<Design_Spec__c>  lstDesignSpecsSTF = new List<Design_Spec__c>();
    List<Design_Spec__c>  lstDesignSpecsSTFToDML = new List<Design_Spec__c>();
    //Case-4363:Removing autoProvisioning related flow:Change-001
    //List<Design_Spec__c>  lstDesignSpecAutoProv = new List<Design_Spec__c>();
    List<Design_Spec__c>  lstDesignSpecToObsolete = new List<Design_Spec__c>();
    List<Design_Spec__c>  lstDesignSpecToReleased = new List<Design_Spec__c>();
    List<Design_Spec__c>  lstDesignSpecRevisionChanged = new List<Design_Spec__c>();
    Map<Decimal, String> mapRevisionIdsToIds = new Map<Decimal, String>();
     set<ID> setDesignSpecsWLbefore=new set<Id>();//plm
     Set<Id>  setWLDesignSpecIds= new Set<Id>();//design spec status change
     Set<Id> setOfGrDesignSpecIds = new Set<Id>();
    for(Design_Spec__c objDS: trigger.new){
        if(trigger.isUpdate){
            if(trigger.isAfter){
                if(objDS.Release_Status__c!=null && !objDS.Release_Status__c.contains('Release to White list') && Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('Release to White list')){
                    system.debug('entr setDesignSpecIds###'+setDesignSpecIds);
                    setDesignSpecIds.add(objDS.Id);
                }
               //if(objDS.Release_Status__c!=null && objDS.Release_Status__c.contains('Release to White list') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('Release to White list')){
                  
               if(objDS.Release_Status__c!=null && objDS.Release_Status__c.contains('Release to White list') && (!Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('Release to White list') || Trigger.oldMap.get(objDS.ID).Specification_Release_List_long__c != objDS.Specification_Release_List_long__c) && !Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('Internal Use Only')){
                    system.debug('entr setDesignSpecIds###'+setDesignSpecIds);
                    setWLDesignSpecIds.add(objDS.Id);
                } 
                system.debug('setDesignSpecIds###'+setDesignSpecIds);
                if(objDS.Revision__c!=Trigger.oldMap.get(objDS.ID).Revision__c){
                    lstDesignSpecRevisionChanged.add(objDS);
                    setDesignSpecIdsRevisionChanged.add(objDS.ID);
                    mapRevisionIdsToIds.put(objDS.Old_Revision_Id__c,objDS.ID);     
                }
                
                if(objDS.Release_Status__c!=null && objDS.Release_Status__c.toLowercase().contains('general release') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.toLowercase().contains('general release')){ 
                    setOfGrDesignSpecIds.add(objDS.Id);     
                }
                //Case#00004561: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
                /*Code block to update new owner on child document provisioning records for the specification record with updated owner starts*/
                System.Debug('Inside is update is after block ---');
                System.Debug('Old Val---'+Trigger.oldMap.get(objDS.ID).ownerId);                
                System.Debug('New Val---'+Trigger.NewMap.get(objDS.ID).ownerId);
                if(Trigger.oldMap.get(objDS.ID).ownerId!=Trigger.NewMap.get(objDS.ID).ownerId){
                    specChangeSet.add(objDS.ID);
                }
                System.Debug('Set val---'+specChangeSet);
               
                /*Code block to update new owner on child document provisioning records for the specification record with updated owner ends*/

            }
            if(trigger.isBefore){
                system.debug('InBefore lstDesignSpecToObsolete');
                if(objDS.Lifecycle_Phase__c!=null && objDS.Lifecycle_Phase__c.equalsIgnoreCase('obsolete')
                        && !Trigger.oldMap.get(objDS.ID).Lifecycle_Phase__c.equalsIgnoreCase('obsolete')){
                    lstDesignSpecToObsolete.add(objDS);
                    setDesignSpecIdsToObsolete.add(objDS.Id);       
                }
                if(objDS.Lifecycle_Phase__c!=null && !objDS.Lifecycle_Phase__c.equalsIgnoreCase('obsolete')
                        && Trigger.oldMap.get(objDS.ID).Lifecycle_Phase__c.equalsIgnoreCase('obsolete')){
                    lstDesignSpecToReleased.add(objDS);
                    setDesignSpecIdsToReleased.add(objDS.Id);       
                }
            }
        }
        if(trigger.isInsert||trigger.isUpdate){
            if(trigger.isBefore){
                if((objDS.Specification_Type__c!=null) &&((objDS.Specification_Type__c=='Stepper Tooling Forms') || (objDS.Specification_Type__c.contains('Reticle Grade Table'))
                        || (objDS.Specification_Type__c=='Material Specifications') || (objDS.Specification_Type__c=='Technical Specifications') 
                        || (objDS.Specification_Type__c=='Other Specifications')) 
                        && (objDS.Specification_Release_List_Long__c!=null)){ // CR # 4562 – Field replaced
                    //objDS.Accounts_Provisioned_To__c = objDS.Specification_Release_List_Long__c; // CR # 4562 – Field replaced
                    lstDesignSpecsSTF.add(objDS); 
                    system.debug('  lstDesignSpecsSTF$$$'+lstDesignSpecsSTF);                
                }
            }
            if(trigger.isAfter){
                //Case-4363:Removing autoProvisioning related flow:Change-002:Start
                /**
                if((objDS.Specification_Type__c!=null) &&((objDS.Specification_Type__c=='Stepper Tooling Forms') || (objDS.Specification_Type__c.contains('Reticle Grade Table'))
                 || (objDS.Specification_Type__c=='Material Specifications') || (objDS.Specification_Type__c=='Technical Specifications') 
                 || (objDS.Specification_Type__c=='Other Specifications')) 
                && (objDS.Specification_Release_List_Long__c!=null)){    // CR # 4562 – Field replaced
                    lstDesignSpecAutoProv.add(objDS);
                }
                 **/
                //Case-4363:Removing autoProvisioning related flow:Change-002:End
                
                
                if((trigger.isUpdate && objDS.Release_Status__c!=null && objDS.Release_Status__c.toLowercase().contains('internal use only') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.toLowercase().contains('internal use only') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.toLowercase().contains('general release'))
                        || (trigger.isInsert && objDS.Release_Status__c!=null && objDS.Release_Status__c.toLowercase().contains('internal use only'))){
                    setDesignSpecIdsToInternal.add(objDS.Id);
                }
                
                if((trigger.isUpdate && objDS.Release_Status__c!=null && objDS.Release_Status__c.toLowercase().contains('general release') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.toLowercase().contains('general release') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.toLowercase().contains('internal use only'))
                        || (trigger.isInsert && objDS.Release_Status__c!=null && objDS.Release_Status__c.toLowercase().contains('general release'))){
                    setDesignSpecIdsToInternal.add(objDS.Id);
                }
                if((trigger.isUpdate && objDS.Release_Status__c!=null && objDS.Release_Status__c.toLowercase().contains('internal use only') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.toLowercase().contains('internal use only') )
                        || (trigger.isInsert && objDS.Release_Status__c!=null && objDS.Release_Status__c.toLowercase().contains('internal use only'))){
                    setDesignSpecIdsToInternal1.add(objDS.Id);
                }
                
                system.debug('setDesignSpecIdsToInternal>>>>>>>>>'+setDesignSpecIdsToInternal); 
/*------------------------added for PLM spec change start------------------------------------------------------*/                
                if(trigger.isUpdate && objDS.Release_Status__c!=null && objDS.Release_Status__c.contains('Release to White list') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('Release to White list') 
                     && (Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('Internal Use Only') || Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('General Release') ))
                        
                   {     
                       
                    setDesignSpecIdsToWhitelist.add(objDS.Id);
                    system.debug('setDesignSpecIdsToWhitelist>>>>>>>>>'+setDesignSpecIdsToWhitelist); 
                }
                
                 if(trigger.isUpdate && objDS.Release_Status__c!=null && objDS.Release_Status__c.contains('Release to White list') 
                     && (!Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('General Release') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('Internal Use Only') && !Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('Release to White list')))
                      {     
                    
                    setDesignSpecIdsToWhitelist1.add(objDS.Id);
                    system.debug('setDesignSpecIdsToWhitelist>>>>>>>>>'+setDesignSpecIdsToWhitelist1);    
                    }
                    
                if(trigger.isUpdate && objDS.Release_Status__c!=null && objDS.Release_Status__c.contains('Release to White list' ) && Trigger.oldMap.get(objDS.ID).Release_Status__c.contains('Release to White list')
                     && Trigger.oldMap.get(objDS.ID).Specification_Release_List_long__c != objDS.Specification_Release_List_long__c)
                        {     
                    
                    setDesignSpecIdsToWhitelist1.add(objDS.Id);
                    system.debug('setDesignSpecIdsToWhitelist>>>>>>>>>'+setDesignSpecIdsToWhitelist1);    
                    }
                system.debug('setDesignSpecIdsToWhitelist>>>>>>>>>'+setDesignSpecIdsToWhitelist);    
/*------------------------added for PLM spec change end------------------------------------------------------*/                    
                 // Added to supprot New PDK Design 
               
                
              if(trigger.isUpdate && objDS.Release_Status__c!=null 
                                    && objDS.Release_Status__c.contains('Specific Account Release') && objDS.Release_Status__c!= Trigger.oldMap.get(objDS.ID).Release_Status__c){//designspec status change
                    
                    system.debug('Meet The conditio n >>>>>>>>>>>>>>>>'+setOfSARdSpecs);    
                    setOfSARdSpecs.add(objDS.Id);
                }
                if(trigger.isUpdate && objDS.Release_Status__c!=null 
                                    && objDS.Release_Status__c.contains('Specific Account Release') && objDS.Release_Status__c!= Trigger.oldMap.get(objDS.ID).Release_Status__c && Trigger.oldMap.get(objDS.ID).Release_Status__c!='Internal use Only'){//designspec status change
                    
                    system.debug('Meet The conditio n >>>>>>>>>>>>>>>>'+setOfSARdSpecs);    
                    setOfSARdSpecs1.add(objDS.Id);
                }
                   
            }
        }           
    }
/*------------------------------optimise start-----------------------------------------------*/
                if (setOfSARdSpecs<>NULL && !setOfSARdSpecs.isEmpty()){
                                    system.debug('Inside Not Null >>>>>>>>>>>>>'+setOfSARdSpecs);
                                    DesignSpecTriggerHandler.provOnStatusChageToSAR(setOfSARdSpecs);
                                    //DesignSpecTriggerHandler.mergeInternalReleaseRecords(setOfSARdSpecs);//designspec status change
                                }
                                
                if (setOfSARdSpecs1<>NULL && !setOfSARdSpecs1.isEmpty()){
                                    system.debug('Inside Not Null >>>>>>>>>>>>>'+setOfSARdSpecs1);
                                   
                                    DesignSpecTriggerHandler.mergeInternalReleaseRecords(setOfSARdSpecs1);//designspec status change
                                } 
                                
                                
                if (setWLDesignSpecIds<>NULL && !setWLDesignSpecIds.isEmpty()){
                                    system.debug('Inside Not Null >>>>>>>>>>>>>'+setWLDesignSpecIds);
                                   
                                    DesignSpecTriggerHandler.mergeInternalReleaseRecords(setWLDesignSpecIds);//designspec status change
                                }                  
                                               
/*------------------------added for PLM spec change start------------------------------------------------------*/   

               system.debug('setDesignSpecIdsToWhitelist$$$'+setDesignSpecIdsToWhitelist); 
                system.debug('setDesignSpecIdsToWhitelist$$'+setDesignSpecIdsToWhitelist1);                        
                 if (setDesignSpecIdsToWhitelist<>NULL && !setDesignSpecIdsToWhitelist.isEmpty()){
                    system.debug('Inside Not Null WL>>>>>>>>>>>>>');
                    DesignSpecTriggerHandler.provOnStatusChageToWLfromInternal(setDesignSpecIdsToWhitelist);
                }
                
                if (setDesignSpecIdsToWhitelist1<>NULL && !setDesignSpecIdsToWhitelist1.isEmpty()){
                    system.debug('Inside Not Null WL>>>>>>>>>>>>>');
                    DesignSpecTriggerHandler.provOnStatusChageToWL(setDesignSpecIdsToWhitelist1);
                }
                if(setOfGrDesignSpecIds<>NULL && !setOfGrDesignSpecIds.isEmpty()){
                    DesignSpecTriggerHandler.deleteDPRecordsOfGrDesignSpec(setOfGrDesignSpecIds);    
                }
/*------------------------added for PLM spec change end------------------------------------------------------*/ 

/*---------------------------optimise end------------------------------------*/    

    if(lstDesignSpecsSTF!=null && lstDesignSpecsSTF.size()>0){
      system.debug('enter if lstDesignSpecsSTF');
        lstDesignSpecsSTFToDML.addAll(DesignSpecTriggerHandler.addAccProvToSTF(lstDesignSpecsSTF));     
        
    }
    if(setDesignSpecIds!=null && setDesignSpecIds.size()>0){
    
       system.debug('Meetif >>>>>>>>>>>>>>>>');   
        DesignSpecTriggerHandler.mergeInternalReleaseRecords(setDesignSpecIds);     
    }
    //Case-4363:Removing autoProvisioning related flow:Change-003:Start
    /**
    if(lstDesignSpecAutoProv!=null && lstDesignSpecAutoProv.size()>0){
        DesignSpecTriggerHandler.shareSpectoPLMlist(lstDesignSpecAutoProv);     
    }
     **/
    //Case-4363:Removing autoProvisioning related flow:Change-003:End
    system.debug('**lstDesignSpecToObsolete**'+lstDesignSpecToObsolete);
    if(lstDesignSpecToObsolete!=null && lstDesignSpecToObsolete.size()>0){
        DesignSpecTriggerHandler.deProvisionObsoleteSpec(lstDesignSpecToObsolete,setDesignSpecIdsToObsolete);
        // added by Prajnith 31-12-2015
        DesignSpecTriggerHandler.deProvisionPDKSpecObsolete(lstDesignSpecToObsolete,setDesignSpecIdsToObsolete);
               
    }
    if(lstDesignSpecToReleased!=null && lstDesignSpecToReleased.size()>0){
        DesignSpecTriggerHandler.provisionReleasedSpec(lstDesignSpecToReleased,setDesignSpecIdsToReleased);     
    }
    if(setDesignSpecIdsToInternal!=null && setDesignSpecIdsToInternal.size()>0){
        DesignSpecTriggerHandler.deProvisionInternalSpecs(setDesignSpecIdsToInternal);      
    }
    if(setDesignSpecIdsToInternal1!=null && setDesignSpecIdsToInternal1.size()>0){
        DesignSpecTriggerHandler.deProvisionInternalSpecs(setDesignSpecIdsToInternal1);      
    }
    if(lstDesignSpecRevisionChanged!=null && lstDesignSpecRevisionChanged.size()>0){
        DesignSpecTriggerHandler.assignOldSpecToLockedPackage(lstDesignSpecRevisionChanged,setDesignSpecIdsRevisionChanged,mapRevisionIdsToIds);        
    }

    //Case#00004561: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
    /*Code to update new owner on child doument provisioning records starts*/

    if(Trigger.isAfter && Trigger.IsUpdate){
        System.debug('Inside my code---');

        if(!specChangeSet.isEmpty())
        {   
            System.debug('Inside if---');
            Integer docProvRecCount = [select count() from Document_Provisioning__c where Design_Spec__c in :Trigger.NewMap.keySet()]; // Variable to get count of child Doc provisioning records for changed spec for Case#00004561
            Integer iterCount=0; // variable to contain max iterations required over batch of Doc provisioning records for Case#00004561
            if(docProvRecCount!=0)
                iterCount=(docProvRecCount >=maxRecLimitVal)?Integer.valueOf(Math.ceil(docProvRecCount/maxRecLimitVal)):1;

            Set<Id> docProvApprvlRecSet; // Collection to hold Ids of Doc provisioning records which require approval from new spec owner for Case#00004561
            List<Approval.ProcessSubmitRequest> docProvApprvlList; // List contains Doc provisioning records that require approval for Case#00004561
            SYstem.Debug('Cont---'+iterCount);

            //Case#00004561: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
            /*Code block to handle Document provisioning records in batches configured to avoid DML exception starts*/

            for(Integer loopVar=0;loopVar<iterCount;loopVar++)
            {
                System.debug('Inside for---');
                docProvApprvlList= new List<Approval.ProcessSubmitRequest >(); 
                Map<Id,Document_Provisioning__c > docProvMap=new Map<Id,Document_Provisioning__c >([select Id,Spec_Owner__c,Design_Spec__c,Status__c,(Select Id, IsPending, ProcessInstanceId, TargetObjectId, OriginalActorId, ActorId, Comments From ProcessSteps) from Document_Provisioning__c where Design_Spec__c in :specChangeSet limit :maxRecLimitVal]); // Map contains Doc provisioning records whose owners have changed for Case#00004561
                docProvApprvlRecSet=new Set<Id>();
                for(Document_Provisioning__c docProvInst : docProvMap.values())
                {
                    if(Trigger.NewMap.get(docProvInst.Design_Spec__c).Release_status__c!=null  && docProvInst.status__c!=null && Trigger.NewMap.get(docProvInst.Design_Spec__c).Release_status__c.equalsIgnoreCase('Specific Account Release with Spec owner Approval') && (docProvInst.status__c.equalsIgnoreCase('Sent For Approval') || docProvInst.status__c.equalsIgnoreCase('Submitted')))
                        docProvApprvlRecSet.add(docProvInst.Id);
                }

                SYstem.Debug('Doc approval set size---'+docProvApprvlRecSet.size());
                SYstem.Debug('Doc approval set---'+docProvApprvlRecSet);
                
                //Case#00004561: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
                /*Code block to set new Spec owners on child Doc Prov records starts*/
                
                for(Document_Provisioning__c docProvRec : docProvMap.values())            
                    docProvRec.Spec_Owner__c =Trigger.NewMap.get(docProvRec.Design_Spec__c).ownerId;
                    
                /*Code block to set new Spec owners on child Doc Prov records ends*/   
            

                try{
                    update docProvMap.values();
                    
                    //Case#00004561: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
                    /*Code block to recall approval process for Document provisioning records whose Specification owners have changed starts*/

                    if(docProvApprvlRecSet!=null && !docProvApprvlRecSet.isEmpty())
                    {
                        Set<Id> procInstIdSet=new Set<Id>(); // Set to contain Ids of Doc provisioning records with pending approval requests for Case#00004561
                        List<ProcessInstance> procInstList = new List<ProcessInstance>([select Id from ProcessInstance where Status = 'Pending' and TargetObjectId in :docProvApprvlRecSet]); // List to contain Doc provisioning records with pending approval requests for Case#00004561
                        for(ProcessInstance procInst : procInstList )
                            procInstIdSet.add(procInst.Id);
                        List<ProcessInstanceWorkitem>  workItemList = new List<ProcessInstanceWorkitem>([select Id from ProcessInstanceWorkitem where ProcessInstanceId in :procInstIdSet]); // List to contain pending Doc provisioning workItems for Case#00004561
                        List<Approval.ProcessWorkitemRequest> procWrkItemList= new List<Approval.ProcessWorkitemRequest>(); // List to contain work items whose action has been recalled for Case#00004561

                        
                        //Case#00004561: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
                        /*Code block to recall approval processes of pending Doc provisioning records starts*/
                        
                        for(ProcessInstanceWorkitem procWrkItem : workItemList)
                        {
                            Approval.ProcessWorkitemRequest pwrReq = new Approval.ProcessWorkitemRequest();
                            pwrReq.setComments('Owner Changed');
                            pwrReq.setAction('Removed');
                            pwrReq.setWorkitemId(procWrkItem.Id);
                            procWrkItemList.add(pwrReq);
                        }

                        Approval.ProcessResult[] procWrkItemresult =  Approval.process(procWrkItemList);
                        
                        /*Code block to recall approval processes of pending Doc provisioning records ends*/

                    }  

                    /*Code block to recall approval process for Document provisioning records whose Specification owners have changed ends*/   


                    //Case#00004561: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
                    /*Code block to reroute  pending approval requests for Document provisioning records whose Specification owners have changed starts*/   

                    if(docProvApprvlRecSet!=null && !docProvApprvlRecSet.isEmpty())
                    {
                        
                        //Case#00004561: GFV Issue: Owner in Specs and Document Provisioning not auto sync.
                        /*Code block to assign approval process of pending Doc provisioning records to new spec owners starts*/
                        
                        
                        for(Id docProvId: docProvApprvlRecSet)
                        {
                            Approval.ProcessSubmitRequest apprProc=new Approval.ProcessSubmitRequest();      
                            apprProc.setComments('Submitting record for approval.');
                            apprProc.setObjectId(docProvId);
                            docProvApprvlList.add(apprProc);


                        }
                        System.debug('List val ---'+docProvApprvlList);
                    }        
                    Approval.ProcessResult[] docProvApprvlresult =  Approval.process(docProvApprvlList);
                    
                    /*Code block to assign approval process of pending Doc provisioning records to new spec owners ends*/
                    
                    /*Code block to reroute  pending approval requests for Document provisioning records whose Specification owners have changed ends*/

                }catch(DMLException e){

                    for (Design_Spec__c desgSpecRec : Trigger.New) {
                        desgSpecRec.addError('There was a problem updating the Specification record/records.');
                    }    

                }catch (Exception e) {

                }
            }

            /*Code block to handle Document provisioning records in batches configured to avoid DML exception ends*/




        }
    }
    /*Code to update new owner on child document provisioning records ends*/
}