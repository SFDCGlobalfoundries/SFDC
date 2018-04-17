/*
    Class Name:    NPCCopyConfigurationController
    Author:        Anirban Roy and Akash Aggarwal
    Description:   This class copies Configurator Plus record and its related record on  NPC generated retrofit Device/Copy Device/Retrofit Device
    History: 
      ARoy        05042016    - Code creation.  
      Ravi Teja.B 21072017    - As Approval Stage of Configurator has been added with new Process Flow Accepted Values changes are made accordingly.    
*/

public class NPCCopyConfigurationController{
  
  public static Boolean PopulateFieldBeforeUpdate = false;
  public static Boolean PopulateFieldAfterUpdate = false;
  public static Boolean ShareProposalAfterUpdate = false;
  public static Boolean InsideNPCCopyConfig = false;

  
  public String oldDeviceId{get;set;}
  public String newDeviceId{get;set;}
  public String mode{get;set;}
  public String reasonForRetrofit{get;set;}
  //public String withPage{get;set;}
  public NPCCopyConfigurationController() {
    //if(ApexPages.currentPage() != NULL && ApexPages.currentPage().getparameters().containsKey('withPage')) {
     // withPage = ApexPages.currentPage().getParameters().get('withPage');
    //}     
    if(ApexPages.currentPage() != NULL) {
      oldDeviceId = ApexPages.currentPage().getParameters().get('oldDeviceId');
      newDeviceId = ApexPages.currentPage().getParameters().get('newDeviceId');
      mode = ApexPages.currentPage().getParameters().get('mode');
      reasonForRetrofit = ApexPages.currentPage().getParameters().get('reasonForRetrofit');
    }
    system.debug('===> ' + oldDeviceId);
  }  
  //@future
  public void prepareDataForClone() {
    NPCCopyConfigurationController.InsideNPCCopyConfig = true;
    List<Apttus_Proposal__Proposal__c> lstProposal = [Select Id,Apttus_Proposal__Approval_Stage__c
                                                          From Apttus_Proposal__Proposal__c where APTPS_Primary__c = TRUE AND Device__c =:oldDeviceId];
        if(lstProposal.isEmpty()) {
          return;
        }
        string configStatus = NULL;
        boolean approvalCheck = false;
        boolean npcRetrofitApprovalStatus = false;
        if(mode == 'NPC') {
          configStatus = 'Draft';          
          if(reasonForRetrofit != 'Fab to Fab Transfer' && reasonForRetrofit != 'Change in PID' && lstProposal[0].Apttus_Proposal__Approval_Stage__c != null && lstProposal[0].Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted')) { configStatus = lstProposal[0].Apttus_Proposal__Approval_Stage__c;approvalCheck = true;npcRetrofitApprovalStatus = true;// Modified by Ravi Teja.B Procee Flow Accepted to lstProposal[0].Apttus_Proposal__Approval_Stage__c
          }
        }
        if(mode == 'COPY') {
          configStatus = 'Draft';
        }
        if(mode == 'REVISE') {
          configStatus = 'Draft';         
          if(lstProposal[0].Apttus_Proposal__Approval_Stage__c != null && lstProposal[0].Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted')) {configStatus = lstProposal[0].Apttus_Proposal__Approval_Stage__c;approvalCheck = true; // Modified by Ravi Teja.B Procee Flow Accepted to lstProposal[0].Apttus_Proposal__Approval_Stage__c
          }
        }
        Apttus_Proposal__Proposal__c newProposal = ConfigCloneMethod(lstProposal[0].Id,configStatus,newDeviceId,npcRetrofitApprovalStatus,approvalCheck);
        
        Map<String,String> oldnewPliMap = updateProposalLineItem(lstProposal[0].Id,newProposal.Id);
        chidlObjAPIName_FieldAPIName.put('Configurator_Plus_Response__c','Configurator_Plus__c');
        list<string> lstChilds = new list<string>();
        lstChilds.addAll( chidlObjAPIName_FieldAPIName.keySet());
        String fieldsNames = 'Configurator_Plus_Response__c';
        Map<String, list<String>> objFields = New Map<String, list<String>>{};
        for(String objAPIName:fieldsNames.split(',')) {
          objFields.put(objAPIName,getCreatableFields(objAPIName));
        }
        for(String childObjAPIName:objFields.keySet()) {
            cloneChildRecords(childObjAPIName, objFields.get(childObjAPIName), newProposal.Id,lstProposal[0].Id,oldnewPliMap);
        } 
        
        /*
         //Update device
        //changes made for copy configurator        
        Device__c newDevice = new Device__c(Id = newDeviceId); 
        newDevice.Configuration_Status__c = configStatus;
        newDevice.Configuration__c = [select name from Apttus_Proposal__Proposal__c where id = :newProposal.Id][0].Name;
        if(configStatus == 'Process Flow Accepted' && newProposal.Purpose_of_the_Configuration__c == 'Final'){
            newDevice.Assigned_Process_ID__c = newProposal.Assigned_Process_ID__c;
        }
        newDevice.CDRS_approval_User__c = newProposal.Config_PIYE_Approver__c;
        update newDevice;
        */
        updateDevice(newDeviceId,configStatus,newProposal.Id,newProposal.Purpose_of_the_Configuration__c,newProposal.Assigned_Process_ID__c,newProposal.Config_PIYE_Approver__c,oldDeviceId);
        //create proposal pdf
        createProposalPDF(newProposal.Id);
  }
  
  @future
  public static void updateDevice(String devId,String configStatus,String newProposalId,String purpose,String Assigned_Process_ID,String Config_PIYE_Approver, string oldDeviceId) { 
        
        Device__c newDevice = new Device__c(Id = devId); 
        newDevice.Configuration_Status__c = configStatus;
        newDevice.Configuration__c = [select name from Apttus_Proposal__Proposal__c where id = :newProposalId][0].Name;
        if(configStatus != null && configStatus.contains('Process Flow Accepted') && purpose == 'Final'){ newDevice.Assigned_Process_ID__c = Assigned_Process_ID; // Modified by Ravi Teja.B 
        }
        if(Config_PIYE_Approver != null && Config_PIYE_Approver == ''){
            newDevice.CDRS_approval_User__c = Config_PIYE_Approver;
        }
        else if(oldDeviceId != null){
            Device__c oldDevice = [Select Id, CDRS_approval_User__c from Device__c where Id =: oldDeviceId];
            newDevice.CDRS_approval_User__c = oldDevice.CDRS_approval_User__c;
        }
        update newDevice;
  }
  
  //Get all creatable fields for a given object
    public static list<String> getCreatableFields(String objAPIName){
        Map<string,string> childFieldsName = new Map<string,string>{};
        Map<String, Schema.SObjectType> gd = Schema.getglobalDescribe();
        SObjectType sot = gd.get(objAPIName);
      
        //Get all non-creatable fields name except
        //Get the field tokens map
        Map<String, SObjectField> fields = new Map<String, SObjectField>{};
        if(sot.getDescribe().fields.getMap().keyset().size()>0) {
          fields = sot.getDescribe().fields.getMap();
        }
        //And drop those tokens in a List
        List<SObjectField> fieldtokens = fields.values();
        List<string> objectFields = new List<String>();
        for(SObjectField fieldtoken:fieldtokens) {
            DescribeFieldResult dfr = fieldtoken.getDescribe();
            if(dfr.isCreateable()) {
              objectFields.add(dfr.getLocalName());
            }                           
        }
        return objectFields;
    }
  public static void createProposalPDF(String newProposalId){
     list<EmailServicesAddress> lstEmailAddress = [select id, EmailDomainName,LocalPart from EmailServicesAddress WHERE LocalPart = 'createproposalpdfnpc'];
        if(!lstEmailAddress.isEmpty()) {
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();mail.setSubject('==>'+newProposalId);
          mail.setHtmlBody('test');mail.setToAddresses(new list<string>{lstEmailAddress[0].LocalPart + '@'+ lstEmailAddress[0].EmailDomainName});
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
  }
  public static Map<String,String> chidlObjAPIName_FieldAPIName = new Map<String,String>{};
   public static void cloneChildRecords(String objAPIName, list<String> createableFields, string newParentRecordID, string oldParentRecordID, Map<String,String> oldnewPliIdMap){
        String fields = '';
        for(string s:createableFields) {
            fields = fields + s + ',';
        }
        fields=fields.substring(0, fields.lastIndexOf(','));
        String queryString = 'select ' + String.escapeSingleQuotes(fields) + ' from ' + String.escapeSingleQuotes(objAPIName) + ' where ' + String.escapeSingleQuotes(chidlObjAPIName_FieldAPIName.get(objAPIName)) + '=\'' + String.escapeSingleQuotes(oldParentRecordID) + '\'';
        list<SObject> result = Database.query(queryString);  
        list<SObject> copy = result.deepclone(false);  
             
        for(SObject obj :copy) {
          obj.put(chidlObjAPIName_FieldAPIName.get(objAPIName), newParentRecordID);
          if(objAPIName == 'Configurator_Plus_Response__c') { String key = newParentRecordID +'-'+obj.get('Configurator_Plus_Question__c');
            obj.put('Question_ID__c',key);
            if(!oldnewPliIdMap.isEmpty() && obj.get('Proposal_Line_Item__c')!=null  && oldnewPliIdMap.containsKey((String)obj.get('Proposal_Line_Item__c'))){
                obj.put('Proposal_Line_Item__c',(String)oldnewPliIdMap.get((String)obj.get('Proposal_Line_Item__c')));
            }
          }
        }   
        insert copy;
    }
  
  public static Apttus_Proposal__Proposal__c ConfigCloneMethod( String configurationId,String status,String newDeviceId,boolean npcRetrofitApprovalStatus,boolean approvalCheck){
        Apttus_Proposal__Proposal__c ClonedConfiguration = new Apttus_Proposal__Proposal__c ();
        
        List<Apttus_Proposal__Proposal__c> configList ;
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal__c').getDescribe().fields.getMap();

        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
           query += ' ' + s + ', ';
        }
        query = query.trim();
        // Strip off the last comma if it exists.
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }       

        // Add FROM statement
        query += ' from Apttus_Proposal__Proposal__c where id=\''+configurationId +'\'';

        configList = database.query(query);
        
        ClonedConfiguration  = configList[0].clone(false,true);
        ClonedConfiguration.Cloned_From__c = configList[0].id;
        ClonedConfiguration.Apttus_Proposal__Approval_Stage__c = status;
        ClonedConfiguration.Device__c = newDeviceId;
        ClonedConfiguration.APTPS_Primary__c = true;
        ClonedConfiguration.NPC_Retrofit_Approval_Check__c = npcRetrofitApprovalStatus;
        ClonedConfiguration.Approval_Check__c = approvalCheck;
        ClonedConfiguration.Configurator_Lookup__c = NULL;
        
        insert ClonedConfiguration  ;
        String ConfigCart ;
        List<Apttus_Config2__ProductConfiguration__c> prodConfigList;
        prodConfigList = [select id,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c = :configList[0].id and  Apttus_Config2__Status__c = 'Finalized' Order by createdDate desc ];
        
        if(prodConfigList.size()>0){
            ConfigCart = prodConfigList[0].id;
        }else{
            prodConfigList = [select id,Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c = :configList[0].id Order by createdDate desc ];
            ConfigCart = (prodConfigList.size()>0)?prodConfigList[0].id:null;
        }                
        
        String BundleProductID = (Test.isRunningTest())?([select id from Product2 where name = 'Test Process Technology'][0].id):null;
        List<String> OptionProducts = (Test.isRunningTest())?(new List<String>{[select id from Product2 where name = 'Test Mask 1'][0].id}):(new List<String>());
        if(ConfigCart != null){
            for(Apttus_Config2__LineItem__c lineItems : [select id, name, Apttus_Config2__LineType__c,Apttus_Config2__OptionId__c,Apttus_Config2__ProductId__c from  Apttus_Config2__LineItem__c  where Apttus_Config2__ConfigurationId__c = :ConfigCart ]){
                if(lineItems.Apttus_Config2__LineType__c == 'Product/Service'){
                    BundleProductID = ( lineItems.Apttus_Config2__ProductId__c != null)? lineItems.Apttus_Config2__ProductId__c : BundleProductID ; 
                }
                if(lineItems.Apttus_Config2__LineType__c == 'Option' && lineItems.Apttus_Config2__OptionId__c != null){
                    OptionProducts.add(lineItems.Apttus_Config2__OptionId__c);
                }
            }
            String ClonedCartID = createCart(ClonedConfiguration);
            addBundle(BundleProductID,OptionProducts,ClonedCartID);          
            finalizeCart(ClonedCartID);
            
        }
        return ClonedConfiguration;
    }
    
    public static string createCart(Apttus_Proposal__Proposal__c  clonedconfig )
    {
        Apttus_CPQApi.CPQ.CreateCartRequestDO request = new Apttus_CPQApi.CPQ.CreateCartRequestDO();
        string cartID = null; 
        List<Apttus_Proposal__Proposal__c> listQuote = [Select Id from Apttus_Proposal__Proposal__c where id=:clonedconfig.id LIMIT 1];
        //If the query above returns a value based on the quote number i.e > 0 a request for creating a cart is initiated.
        if(listQuote.size() > 0)
        {
            request.QuoteId = listQuote[0].Id;
            Apttus_CPQApi.CPQ.CreateCartResponseDO response;
            if(!Test.isRunningTest()){ response = Apttus_CPQApi.CPQWebService.createCart(request);cartId = response.CartId;
            }            
            return cartID ; 
        }
       
        return null;
    }
    
    //The line below fetches the selected products from the product list. This fetches the productID and Quantity of the selected product.
    public static void addBundle(String BundleProductID, List<String> OptionProducts , String ClonedCartID) {
    
        Map<String,String> optionComponentMap = new Map<String,String>();
        for(Apttus_Config2__ProductOptionComponent__c  component :  [select id,Apttus_Config2__ComponentProductId__c,Apttus_Config2__ParentProductId__c from Apttus_Config2__ProductOptionComponent__c where Apttus_Config2__ParentProductId__c  = :BundleProductID]){
            optionComponentMap.put(component.Apttus_Config2__ComponentProductId__c,component.ID);
        
        }
        string productID = '';
        Integer Quantity = 1;       
        productID = BundleProductID ;
                
        //The line below indicates that if the product ID is empty or no product is selected, an error message is to be shown to the user.
      
        // This line comprises the request that includes the selected productID and quantity to be added to the cart. The cart it is to be added to is recognized by the cartID.
        if(productID != '')
        {
            Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
            request.CartId = ClonedCartID ;
            request.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
            request.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
            request.SelectedBundle.SelectedProduct.ProductId = productID;
            request.SelectedBundle.SelectedProduct.Quantity = Quantity;
            List<Apttus_CPQApi.CPQ.SelectedOptionDO> options = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
            if(OptionProducts !=null)
            {
                for(String OptionProdID : OptionProducts )
                { 
                  if(optionComponentMap.get(OptionProdID)!=null){		                   
                    Apttus_CPQApi.CPQ.SelectedOptionDO objSelectedOptionDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();
                    objSelectedOptionDO.ComponentId = optionComponentMap.get(OptionProdID);
                    objSelectedOptionDO.ComponentProductId = OptionProdID ;
                    objSelectedOptionDO.Quantity = 1;
                    options.Add(objSelectedOptionDO);
                   }      
                    
                }
                //All the options associated with the bundle are also added with the bundled products to the cart that are selected.
                if(options.size()>0)
                {
                    request.SelectedBundle.SelectedOptions = options ;
                }
            }
            
            List<Decimal> lineNumber ;
            if(lineNumber == null)
            {
                lineNumber = new List<Decimal>();
            }
            Apttus_CPQApi.CPQ.AddBundleResponseDO response;
            if(!Test.isRunningTest()){ response = Apttus_CPQApi.CPQWebService.addBundle(request); lineNumber.Add(response.LineNumber);
            }          
        }
    }
    
    public static void finalizeCart(String CartId)
    {
        // create the finalize cart request
        Apttus_CpqApi.CPQ.FinalizeCartRequestDO request = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
        // add request parameters
        request.CartId = CartId;
        // finalize the cart
        Apttus_CpqApi.CPQ.FinalizeCartResponseDO response;
        if(!Test.isRunningTest()){ response = Apttus_CpqApi.CPQWebService.finalizeCart(request);
        }
    } 
    
    public static Map<String,String> updateProposalLineItem(Id oldConfigId, Id newConfigId)
    {
        Map<String,Apttus_Proposal__Proposal_Line_Item__c> oldPliMap = new Map<String,Apttus_Proposal__Proposal_Line_Item__c>();
        Map<String,String> oldnewPliIdMap = new Map<String,String>();
        List<Apttus_Proposal__Proposal_Line_Item__c> pliList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        
        for(Apttus_Proposal__Proposal_Line_Item__c pli : [select    Apttus_QPConfig__OptionId__c
                                                                    , Customized_IP_Flag__c
                                                                    , IP_Approval_Status__c                                                                             
                                                                    , IP_Design_Kit__c
                                                                    , Prev_IP_Design_Kit__c
                                                          from      Apttus_Proposal__Proposal_Line_Item__c
                                                          where     Product_Family__c = 'IPs'
                                                          and       Apttus_Proposal__Proposal__c = :oldConfigId
                                                         ]){oldPliMap.put(pli.Apttus_QPConfig__OptionId__c,pli);        
        }
        
        
        for(Apttus_Proposal__Proposal_Line_Item__c pli : [select    id
                                                                    , Apttus_QPConfig__OptionId__c
                                                                    , Customized_IP_Flag__c
                                                                    , IP_Approval_Status__c                                                                             
                                                                    , IP_Design_Kit__c
                                                                    , Prev_IP_Design_Kit__c
                                                          from      Apttus_Proposal__Proposal_Line_Item__c
                                                          where     Product_Family__c = 'IPs'
                                                          and       Apttus_Proposal__Proposal__c = :newConfigId
                                                         ]){
            
            if(!oldPliMap.isEmpty() && oldPliMap.containsKey(pli.Apttus_QPConfig__OptionId__c)){
                Apttus_Proposal__Proposal_Line_Item__c tempPli = oldPliMap.get(pli.Apttus_QPConfig__OptionId__c);
                oldnewPliIdMap.put(tempPli.Id,pli.Id);
                if(pli.Customized_IP_Flag__c != tempPli.Customized_IP_Flag__c
                   || pli.IP_Approval_Status__c != tempPli.IP_Approval_Status__c || pli.IP_Design_Kit__c != tempPli.IP_Design_Kit__c || pli.Prev_IP_Design_Kit__c != tempPli.Prev_IP_Design_Kit__c
                  ){
                    pli.Customized_IP_Flag__c = tempPli.Customized_IP_Flag__c;pli.IP_Approval_Status__c = tempPli.IP_Approval_Status__c;
                    pli.IP_Design_Kit__c = tempPli.IP_Design_Kit__c;pli.Prev_IP_Design_Kit__c = tempPli.Prev_IP_Design_Kit__c;pliList.add(pli);
                }
            }
                    
        }
        
        if(pliList.size()>0){update pliList;
        }
        return oldnewPliIdMap;                                                          
    }   
   @future(callout=true) 
   public static void getNPCPageContent(String oldDeviceId,String newDeviceId, String mode,String reasonForRetrofit) {
     Pagereference pg = new Pagereference('/apex/NPCCopyConfiguration?oldDeviceId='+oldDeviceId+'&newDeviceId='+newDeviceId+'&mode='+mode+'&reasonForRetrofit='+reasonForRetrofit); 
     if(!Test.isRunningTest()) {pg.getContent();}
   }
    

}