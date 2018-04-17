/*
  Author: Anirban Roy
  Description: This is the controller class for the Summary page for Configurator.
  History:
    ARoy        10102014    - code creation.   
    Asolito     1126/2014   - added logic to set the record type of the proposal to Multi Source Tapeout from Teamroom
                              if creatd by customer
    Karna Shiva  11/30/2016 - Added FMS record update logic.  
    Ravi Teja.B 05022017    - Added logic for updatinig PDK version for Case#00067893
    Ravi Teja.B 13072017    - Duplicates on Configuration Yield Case#00073895
    Ravi Teja.B 01082017    - 101 SOQL Limits Update call on proposal moved from init method to finalize method  Case#00076594
    Ravi Teja.B 08012017    - Case#00078616 Refresh the page after finalizing.                           
	//Karna Shiva 02012018 - Added MPW record update and redirection to MPW reservation form after finalize  case#00079337	
*/
public class ProposalSummary {
    
    //Variable declaration
    public Apttus_Proposal__Proposal__c proposal {get; set;}
    public Apttus_Config2__ProductAttributeValue__c prodAttVal {get; set;}
    public id lineItemId {get;set;}
    public id lineItemPTId;
    public id prodConfigId;
    public Id proposalId{get;set;}
    public Id configReqId;
    public Id oldprodConfigId;
    
    public Map<String,String> deviceMap{get;set;} 
    public Map<String,String> deviceProductCodeMap{get;set;} //Added for Case #00049590
    public List<Apttus_Proposal__Proposal_Line_Item__c> ipList{get;set;}
    public List<String> refList{get;set;}
    public List<String> addInfoList{get;set;}
    public Boolean isMultiSourceTapeout{get;set;}
    public Boolean isDevRecPresent{get;set;}
    public Boolean ismultipleProduct{get;set;}
    
    //Added by Ravi Teja.B on 050217 for Case#00067893
    private Boolean isUpdateProposal = false;
    PCM_Administration__c pcmAdminSetting = PCM_Administration__c.getInstance('CURRENT_SETTING');     
    
    // Constructor to check for url parameter and check for duplicate bundle product in the line item (if found throw error) 
    public ProposalSummary(){ 
        try{  
            ipList = new List<Apttus_Proposal__Proposal_Line_Item__c>();            
            oldprodConfigId = ApexPages.currentPage().getParameters().get('businessObjectId');      
            prodConfigId = ApexPages.currentPage().getParameters().get('Id');            
            proposalId = ApexPages.currentPage().getParameters().get('retId');
            configReqId = ApexPages.currentPage().getParameters().get('configRequestId');
            lineItemId = ApexPages.currentPage().getParameters().get('lineItemId');
            addInfoList = new List<String>();  
            refList = new List<String>();    
            
            isMultiSourceTapeout = false;
            isDevRecPresent = false;
            ismultipleProduct = false;
            List<Apttus_Config2__LineItem__c> lineItemList =    [select id 
                                                                   from    Apttus_Config2__LineItem__c
                                                                   where   Apttus_Config2__ConfigurationId__c=:prodConfigId 
                                                                   and     Apttus_Config2__LineType__c = 'Product/Service'
                                                                   order by createddate desc
                                                                ];
                                                                          
            if(lineItemList!=null && lineItemList.size()>1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You can configure only one Process Technology. Kindly remove extra entry from your cart.'));
                ismultipleProduct = true;
            }
            lineItemPTId = (lineItemList!=null && lineItemList.size()>0)?lineItemList[0].Id:null;
        }catch(Exception e){
             GlobalUtility.logMessage('Error', 'ProposalSummary', 'Constructor', null, null, e.getMessage(), null,null,e, null);
        }               
    }    
    
    // Method to get the fields from the Proposal object
    private void populateProposal(id proposalId){
        String propQuery = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal__c.FieldSets.SummaryPageSec1.getFields()) {
            propQuery += f.getFieldPath() + ', ';
        }
        
        for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal__c.FieldSets.SummaryPageSec2.getFields()) {
            propQuery += f.getFieldPath() + ', ';
        }
        
        for(Schema.FieldSetMember f : SObjectType.Apttus_Proposal__Proposal__c.FieldSets.SummaryPageSec4.getFields()) {
            propQuery += f.getFieldPath() + ', ';
        }
        
        propQuery += ' id, Product_Name__c, Actual_Tapeout_Date_FAB_9_and_FAB_10__c, PDK_Version__c,Product_Revision__c,recordType.name,recordTypeId,FMS_Proposal__c,FMS_Technology__c FROM Apttus_Proposal__Proposal__c Where id = \'' + proposalId  + '\'';
        
        proposal = (Apttus_Proposal__Proposal__c)Database.query(propQuery);                
    }
    
    // Method to get records from the Proposal Line Item to populate the IPs, Device, Reference Flow and EDA Tool Selection
    private void populateProposalLineItemMap(){        
        deviceMap = new Map<String,String>();
        deviceProductCodeMap = new Map<String,String>(); //Added for Case #00049590
        ipList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        refList = new List<String>();
        addInfoList = new List<String>();        
        
        Integer i=0;
        String productFamily = '';
        
        //fetch the proposal line items in scope and prepare the maps    
        for(Apttus_Proposal__Proposal_Line_Item__c lineItem : [select   Apttus_QPConfig__ProductOptionId__c
                                                                        , Apttus_QPConfig__PrimaryLineNumber__c
                                                                        , Id
                                                                        , Apttus_QPConfig__OptionId__c
                                                                        , Apttus_Proposal__Product__r.ProductCode
                                                                        , Apttus_Proposal__Product__r.Name
                                                                        , Apttus_QPConfig__OptionId__r.Family
                                                                        , Apttus_QPConfig__OptionId__r.Name
                                                                        , Apttus_QPConfig__OptionId__r.APTPS_IP_Lifecycle__c
                                                                        , Apttus_QPConfig__OptionId__r.APTPS_IP_Type__c
                                                                        , Apttus_QPConfig__OptionId__r.APTPS_IP_Vendors__c
                                                                        , Apttus_QPConfig__OptionId__r.IP_Device_List__c
                                                                        , Apttus_QPConfig__OptionId__r.ProductCode
                                                                        , Apttus_QPConfig__OptionId__r.Mask_Sets__c
                                                                        , Apttus_Proposal__Product__r.PT_Number__c 
                                                                        , Apttus_QPConfig__OptionId__r.Description //Added for Case #00049590
                                                                        , Apttus_Proposal__Product__r.PDK_Version__c //Added by Ravi Teja.B on 050217 for Case#00067893
                                                                        , Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c //Added by Ravi Teja.B on 050217 for Case#00067893
                                                                from    Apttus_Proposal__Proposal_Line_Item__c 
                                                                where   Apttus_QPConfig__ConfigurationId__r.Apttus_QPConfig__Proposald__c = :proposal.id 
                                                                order by Apttus_QPConfig__PrimaryLineNumber__c
                                                               ]){
            productFamily = lineItem.Apttus_QPConfig__OptionId__r.Family;
            //Added by Ravi Teja.B on 050217 for Case#00067893
            if(lineItem.Apttus_Proposal__Product__r.Apttus_Config2__ConfigurationType__c == 'Bundle' && lineItem.Apttus_Proposal__Product__r.PDK_Version__c != null){
                if(proposal.PDK_Version__c != lineItem.Apttus_Proposal__Product__r.PDK_Version__c){
                    proposal.PDK_Version__c = lineItem.Apttus_Proposal__Product__r.PDK_Version__c;
                    isUpdateProposal = true;
                }    
            }
            if(productFamily == 'Devices' || productFamily == 'IPs' || productFamily == 'Additional Questions' || productFamily == 'RF'){                
                if(productFamily == 'Additional Questions'){
                   //productFamily = 'EDA Tool Selection';
                   addInfoList.add(lineItem.Apttus_QPConfig__OptionId__r.Name);
                }else if(productFamily == 'RF'){
                   //productFamily = 'Reference Flows / White Papers';
                   refList.add(lineItem.Apttus_QPConfig__OptionId__r.Name);
                }else if(productFamily == 'IPs'){                   
                   //productFamily = 'Reference Flows / White Papers';
                   ipList.add(lineItem);
                }else if(productFamily == 'Devices'){
                   //productFamily = 'Reference Flows / White Papers';
                   String tempmsk = lineItem.Apttus_QPConfig__OptionId__r.Mask_Sets__c!=null?lineItem.Apttus_QPConfig__OptionId__r.Mask_Sets__c:'';
                   String msk = deviceMap.containskey(lineItem.Apttus_QPConfig__OptionId__r.Name)?deviceMap.get(lineItem.Apttus_QPConfig__OptionId__r.Name):null;
                   if(msk!=null){
                        msk +=  ', ' +  tempmsk;
                        
                   }else{
                        msk = tempmsk;
                   }
                   deviceMap.put(lineItem.Apttus_QPConfig__OptionId__r.Name,msk);
                    deviceProductCodeMap.put(lineItem.Apttus_QPConfig__OptionId__r.Name,lineItem.Apttus_QPConfig__OptionId__r.Description);  //Added for Case #00049590
                }             
            }
            if(lineItem.Apttus_QPConfig__OptionId__c == null && i==0){
                isMultiSourceTapeout = (lineItem.Apttus_Proposal__Product__r.Name).contains('Multi Source Tapeout')?true:false;
                //lineItemId = lineItem.Id;
                i++;
            }          
        }
        
        //Asolito 11262014
        //update the record type to multi source from team room if customer created the proposal
        for(RecordType r: [SELECT id FROM RecordType WHERE name = 'Multi Source Proposal from Teamroom']){
            if(this.isMultiSourceTapeout){
                proposal.recordTypeID = r.id;
                isUpdateProposal = true; //Added by Ravi Teja.B on 050217 for Case#00067893
            }
        }
        
        if(deviceMap.size()!=0){
           isDevRecPresent = true; 
        }       
        //Added by Ravi Teja.B on 050217 for Case#00067893. shifted from record type update.
        //if(isUpdateProposal) Commented and Moved to Finalise Method as there is 101 SOQl Limits exception encountered. By Ravi Teja - 01082017
            //Database.update(proposal);
    }
       
    private void populateProductAttributeValueMap(){
        String prodAttrValQuery = 'Select ';
        
        for(Schema.FieldSetMember f : SObjectType.Apttus_Config2__ProductAttributeValue__c.FieldSets.SummaryPageSec2.getFields()) {
            prodAttrValQuery += f.getFieldPath() + ', ';
        }        
        
        prodAttrValQuery += 'Id, Apttus_Config2__LineItemId__c FROM Apttus_Config2__ProductAttributeValue__c Where Apttus_Config2__LineItemId__c = \'' + lineItemPTId  + '\'';
        
        prodAttVal = (!Test.isRunningTest())?(Apttus_Config2__ProductAttributeValue__c)Database.query(prodAttrValQuery):null;
    }
    
    // This method is called as an action to the page to call the finalize api upon page loading and 
    // prepare the data set for the summary page
    public PageReference init(){
        try{
            if(proposalId != null)     
                populateProposal(proposalId);
            if(!ismultipleProduct){
                Apttus_CPQApi.CPQ.FinalizeCartResponseDO result;            
                //Added for Apttus Case #00152835
                List<Apttus_Config2__LineItem__c> liSOList = [select
                        Apttus_Config2__ProductID__c,
                        Apttus_Config2__IsPrimaryLine__c,
                        Apttus_Config2__LineNumber__c from Apttus_Config2__LineItem__c where
                        Apttus_Config2__ConfigurationId__c = :prodConfigId];
    
                List<Integer> primaryLines = new List<Integer>();
                for(Apttus_Config2__LineItem__c liSO: liSOList){               
                    if(liSO.Apttus_Config2__IsPrimaryLine__c){
                        primaryLines.Add(liSO.Apttus_Config2__LineNumber__c.intValue());
                    }
                }
                
                List<Apttus_CPQApi.CPQ.AppliedActionDO> appliedActionDOList = new List<Apttus_CPQApi.CPQ.AppliedActionDO>();        
                
                if(!Test.isRunningTest()){      
                    Apttus_CPQApi.CPQWebService.associateConstraintRules(prodConfigId, primaryLines);       
                        
                    Apttus_CPQApi.CPQWebService.applyConstraintRules(prodConfigId,true);                        
            
                            
                    Apttus_CPQApi.CPQ.ConstraintResultDO constraintResult = Apttus_CPQApi.CPQWebService.getConstraintRuleResult(prodConfigId);      
                    appliedActionDOList = constraintResult.ConstraintRuleActions;       
                }       
                Integer numErrors = 0;      
                        
                for(Apttus_CPQApi.CPQ.AppliedActionDO appliedActDO:appliedActionDOList){                        
                    if(appliedActDO.MessageType.equals('Error') && appliedActDO.IsPending){     
                        numErrors++;        
                    }       
                }
                if(numErrors > 0){                          
                    PageReference pr;
                    if(proposalId != null)  //Added by Ravi Teja 08012017 Case#00078616
                        populateProposal(proposalId);
                               
                    if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){ 
                        if(proposal.FMS_Proposal__c <> null){
                            pr = new PageReference('/GlobalfoundryView/apex/Cart?callerPage=cart&configRequestId='+configReqId+'&id='+prodConfigId+'&flow=FMSFlow#/configure/10002');
                        }else{
                            pr = new PageReference('/GlobalfoundryView/apex/Cart?callerPage=cart&configRequestId='+configReqId+'&id='+prodConfigId+'&flow=GFFlow#/configure/10002');
                        }                                         
                                
                            
                            
                    }else{                          
                        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm().replace('--c','--apttus-config2'); 
                        if(proposal.FMS_Proposal__c <> null){                                                     
                            pr = new PageReference(baseUrl+'/apex/Cart?callerPage=cart&configRequestId='+configReqId+'&id='+prodConfigId+'&flow=FMSFlow#/configure/10002'); 
                        }else{
                            pr = new PageReference(baseUrl+'/apex/Cart?callerPage=cart&configRequestId='+configReqId+'&id='+prodConfigId+'&flow=GFFlow#/configure/10002');    
                        }                                                         
                    }       
                    return pr;                          
                } else {                            
                    Apttus_CPQApi.CPQ.FinalizeCartRequestDO request = new Apttus_CPQApi.CPQ.FinalizeCartRequestDO();        
                    request.CartId= prodConfigId;                       
                    if(!Test.isRunningTest()){      
                        result = Apttus_CPQApi.CPQWebService.finalizeCart(request);         
                    }       
                            
                    if(Test.isRunningTest() || result.IsSuccess){       
                        if(proposalId != null){     
                            populateProposal(proposalId); //Uncommented by Ravi Teja 08012017 Case#00078616      
                            populateProposalLineItemMap();      
                            populateProductAttributeValueMap();
                                                             
                        }else{      
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Proposal.'));       
                        }       
                    }else{                  
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please contact support team.' ));       
                    }       
                }
            }
            //Added by Ravi Teja.B - 13/07/2017 for case#00073895
            if(proposalId != null && proposal != null && UtilsString.isNotBlank(proposal.process_technology__c) && 
               proposal.apttus_proposal__account__c <> null &&
               proposal.device__c <> null &&
               proposal.apttus_proposal__opportunity__c <> null && 
               proposal.Actual_Tapeout_Date_FAB_9_and_FAB_10__c != NULL && !GenerateYieldAndCost.hasRun){
                    GenerateYieldAndCost.hasRun = true;
                    GenerateYieldAndCost.generate(proposal.id);                           
            }
        }catch(Exception e){
             GlobalUtility.logMessage('Error', 'ProposalSummary', 'init', null, null, e.getMessage(), null,null,e, null);
        }
        return null;
    }
    
    // Finalize method called to redirect the user to the detail page
    public PageReference finalize(){
        PageReference pr;
        try{
            Apttus_Proposal__Proposal__c MPWProposal = [select Id,Process_Technology__c,FMS_Proposal__c from Apttus_Proposal__Proposal__c where Id = :proposal.Id];        
            Boolean isChanged = false;
            if(proposal != null){
              CPQ_SwapProcessTechnology__c swap = CPQ_SwapProcessTechnology__c.getInstance(proposal.Process_Technology__c);
              if(swap!= NULL && swap.Replace_with_PT__c != NULL) {
                Map<String,String> ptNumProcessTechMap = new Map<String,String>(); 
                for(Process_Technology__c pt : [select    Id , PT_Number__c from   Process_Technology__c  where     PT_Number__c =:swap.Replace_with_PT__c]){ 
                  ptNumProcessTechMap.put(pt.PT_Number__c, pt.id); 
                } 
                proposal.Process_Technology__c = swap.Replace_with_PT__c;
                proposal.Process_Technology_Lookup__c = ptNumProcessTechMap.get(swap.Replace_with_PT__c);
                isChanged = true;
              } 
            }
            if(isUpdateProposal || isChanged) {
              update proposal; 
            }
         // Added by shiva - When the configuration related to MPW then the below code updating die size x and y in MPW Reservation form - start
/*		if(MPWProposal.MPW_Reservation_Form__c <> null){
		Set<id> lineitemid = New Set<id>();
				List<Apttus_Config2__LineItem__c> lstLineItems =[Select Apttus_Config2__AttributeValueId__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c =:Proposal.Id];
		for(Apttus_Config2__LineItem__c lineitems : lstLineItems)
		{
			lineitemid.add(lineitems.Apttus_Config2__AttributeValueId__c);
		}
				List<Apttus_Config2__ProductAttributeValue__c> ApttusProdAttributeValue = [Select id,Name,Die_Size_X_mm__c,Die_Size_Y_mm__c from Apttus_Config2__ProductAttributeValue__c where id IN:lineitemid and Die_Size_X_mm__c!=null order by createdDate desc limit 1];
	
				List<MPW_Prime_Die__c> MPWPrimeDieList =[Select Drawn_Die_Size_X_um__c,Drawn_Die_Size_Y_um__c,id from MPW_Prime_Die__c where MPW_Form__c=:MPWProposal.MPW_Reservation_Form__c];
            
				if(ApttusProdAttributeValue[0].Die_Size_X_mm__c!=null)MPWPrimeDieList[0].Drawn_Die_Size_X_um__c =String.ValueOf(ApttusProdAttributeValue[0].Die_Size_X_mm__c);
				if(ApttusProdAttributeValue[0].Die_Size_Y_mm__c!=null)MPWPrimeDieList[0].Drawn_Die_Size_Y_um__c =String.ValueOf(ApttusProdAttributeValue[0].Die_Size_Y_mm__c);

				Update MPWPrimeDieList;	
		}
*/		
		 // Added by shiva - When the configuration related to MPW then the below code updating die size x and y in MPW Reservation form - end
		 
        // Added by shiva for updating technical features in FMS Object and redirecting FMS user to FMS record detail page - start
      
        if(proposal.FMS_Proposal__c <> null){
     
            List<Apttus_Config2__LineItem__c> apttusConfigLineitems = [select id,name,Apttus_Config2__OptionGroupLabel__c,Apttus_Config2__OptionId__r.Name, Apttus_Config2__OptionId__r.Description 
                             from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__r.Apttus_Config2__BusinessObjectId__c =:proposal.id 
                             and Apttus_Config2__OptionGroupLabel__c<>null and Apttus_Config2__OptionId__r.Name <> null and Apttus_Config2__ConfigurationId__r.Apttus_Config2__Status__c = 'Finalized' 
                             order by Apttus_Config2__OptionGroupLabel__c,Apttus_Config2__OptionId__r.Name];
                             
            List<Apttus_Proposal__Proposal_Line_Item__c>  apttusConfigPropLineitems =[Select Apttus_Proposal__Product__r.Name,Apttus_Proposal__Description__c,id,Name,Apttus_Proposal__Proposal__c  
                             from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c = :proposal.id];
            
            Form_Management_System__c FMSMainformData = [select id,transistor_Options__c, Resistor_Options__c,RfFetOpts__c,MiscFeatures__c,MimOption__c
                             ,CapacitorOpts__c,GateOxideOpt__c,NFETOpts__c,PFETOpts__c,NFETVTOpt__c ,PFETVTOpt__c,edsNFETOpt__c,edsTransistorOpt__c,
                             MetallizationOpts__c,AclvGateOrientation__c,DramOpts__c,SramOpts__c,FetOpts__c,WellOpts__c,EsdOpts__c,Technology_Features__c  
                             from Form_Management_System__c where id=:proposal.FMS_Proposal__c];

            String duplicateTechFeature ;
            String techFeatures='';
            
            for( Apttus_Config2__LineItem__c apttusLineItem : apttusConfigLineitems)
            {
                if(duplicateTechFeature <> apttusLineItem.Apttus_Config2__OptionId__r.Name){

                  techFeatures += (apttusLineItem.Apttus_Config2__OptionGroupLabel__c!=null && apttusLineItem.Apttus_Config2__OptionGroupLabel__c!='Mask Sets')?apttusLineItem.Apttus_Config2__OptionId__r.Name+((apttusLineItem.Apttus_Config2__OptionId__r.Description!=null && apttusLineItem.Apttus_Config2__OptionId__r.Description!='')?'(Part No.: '+apttusLineItem.Apttus_Config2__OptionId__r.Description+')':'')+'; ':'';
                  duplicateTechFeature = apttusLineItem.Apttus_Config2__OptionId__r.Name;
                }
            }
            
            techFeatures = (techFeatures!=null)?techFeatures.removeEnd('; '):''; 
         
            String redirectocatalog = ApexPages.currentPage().getHeaders().get('Host');
           
            for( Apttus_Proposal__Proposal_Line_Item__c apttusLineItem : apttusConfigPropLineitems){

                if(proposal.FMS_Technology__c != apttusLineItem.Apttus_Proposal__Product__r.Name){
                  ApexPages.Message errMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Please select correct technology because you have selected different technology in Configurator  '+'\n \n'+'( FMS Foundary Technology = '+ Proposal.FMS_Technology__c+'\n \n'+'  and Configurator Technology = '+apttusLineItem.Apttus_Proposal__Product__r.Name+')'+ 'Please click this link to change technology <a href="/apex/Apttus_QPConfig__ProposalConfiguration?flow=FMSFlow&id='+proposal.id+'">'+proposal.Name+'</a>');
                  ApexPages.addMessage(errMsg);
                  return null;
             
                }  
                                                     
            }
            
            FMSMainformData.Technology_Features__c = techFeatures;
            Update FMSMainformData;          
        
        }
      // Added by shiva for updating technical features in FMS Object and redirecting FMS user to FMS record detail page - start
	  // Added by shiva - 02012018 - MPW Reservation for page redirection
      if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView') && proposal.FMS_Proposal__c<>null){
                pr = new PageReference('/GlobalfoundryView/FMSmainFormCreationPg2?id='+ proposal.FMS_Proposal__c+'&pageN=2');
            }else  if(proposal.FMS_Proposal__c<>null){
                pr = new PageReference('/apex/FMSmainFormCreationPg2?id='+ proposal.FMS_Proposal__c+'&pageN=2');
			} /* else if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView') && MPWProposal.MPW_Reservation_Form__c<>null){
				pr = new PageReference('/GlobalfoundryView/MPWReservationFormVF?id='+ MPWProposal.MPW_Reservation_Form__c);
			}else if(MPWProposal.MPW_Reservation_Form__c<>null){
				pr = new PageReference('/apex/MPWReservationFormVF?id='+ MPWProposal.MPW_Reservation_Form__c);
			} */ else if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
                pr = new PageReference('/GlobalfoundryView/'+ proposal.Id);
            }else{
                pr = new PageReference('/'+ proposal.Id);
            }
          // Added by shiva for updating technical features in FMS Object and redirecting FMS user to FMS record detail page - end
           
        }catch(Exception e){
             GlobalUtility.logMessage('Error', 'ProposalSummary', 'finalize', null, null, e.getMessage(), null,null,e, null);
        }
        
        return pr;
    }            
    
    // UploadGDS method called to take the user to the GDS Upload page
    public pagereference uploadGDS(){
        PageReference pr;
        try{
            String otherParam = '&id2=' +Apexpages.currentPage().getParameters().get('id') +
                                '&id3=' +Apexpages.currentPage().getParameters().get('businessObjectId') +
                                '&id4=' +Apexpages.currentPage().getParameters().get('configRequestId');
                                
            if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
                pr = new PageReference('/GlobalfoundryView/apex/GDSUPLOAD?id='+ proposalId + otherParam);
            }else{
                pr = new PageReference('/apex/GDSUPLOAD?id='+ proposalId + otherParam);
            }
        }catch(Exception e){
             GlobalUtility.logMessage('Error', 'ProposalSummary', 'uploadGDS', null, null, e.getMessage(), null,null,e, null);
        }
        return pr;
    }
    
    // This method takes the user to the option page for modification in the configuration.
    public pagereference redirectToCatalog(){   
        PageReference pr;
        try{           
            String fab = proposal.Fab_Name__c != NULL ? proposal.Fab_Name__c.toLowercase() : proposal.Fab_Name__c;
            String fabs = pcmAdminSetting.PCM_Fabs__c != NULL ? pcmAdminSetting.PCM_Fabs__c.toLowercase() : pcmAdminSetting.PCM_Fabs__c;
            
            Set<string> stFabs = new set<string>();            
            if(fabs != NULL) {
              stFabs.addAll(fabs.split(','));
            }
                
            if(fab == NULL || fabs == NULL || !stFabs.contains(fab)) {                          
                if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){                      
                    pr = new PageReference('/GlobalfoundryView/apex/Cart?configRequestId='+configReqId+'&id='+lineItemId+'&flow=GFFlow&launchState=options');
        
                }else{            
                     pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm().replace('--c','--apttus-config2')+'/apex/Cart?configRequestId='+configReqId+'&id='+lineItemId+'&flow=GFFlow&launchState=options');                    
                }
            } else {
                if(proposal.product_type__c == 'Wafer'){                  
                    pr = new PageReference(Apexpages.currentPage().getHeaders().get('Referer').replace(
                                           '/apex/ProposalSummary','/apex/ConfigQuarterlyVolume'));
                      
                } else {
                    pr = new PageReference(Apexpages.currentPage().getHeaders().get('Referer').replace(
                                      '/apex/ProposalSummary','/apex/CPQConfigPostFabServices'));    
                }    
            }
        }catch(Exception e){
             GlobalUtility.logMessage('Error', 'ProposalSummary', 'redirectToCatalog', null, null, e.getMessage(), null,null,e, null);
        }  
         
        return pr;
    }          
    
}