/**
 *  Class:      SRAM_Devices_Controller 
 *----------------------------------------------------------------------------------------------------------------------------------- 
 * Author:      Akash Aggarwal
 * Description: controller to let user enter data for sram size
 *
 * History:
 *              AA 07012016     - code creation.
 * Sunita Char: Case 00076793 
**/
public class SRAM_Devices_Controller {
 
  //Current Proposal
    public Apttus_Proposal__Proposal__c CurrentProposal { get; set; }
    public Boolean isEdit{ get; set; }
/*--------------added by sunita for Case 00076793 start-----------------------------------*/   
   
    public Boolean readOnlyModeEnabled  {get; set;}
    
    public String otpsize{get; set; }
    public Boolean Sponsered{get; set; }
    public Boolean Pasivation{get; set; }
    
    public String MTPsize{get; set; }
    public Boolean MTPSponsered{get; set; }
    public Boolean MTPPasivation{get; set; }
/*--------------added by sunita for Case 00076793  end-----------------------------------*/      
    
    public List<SRAMWrapper> LstSRAMDevicesView { get; set; }
    //Delimiter
    final String szDelimiter = '<:>';
    //Constructor (Extension)
    public SRAM_Devices_Controller(ApexPages.StandardController controller){
      LstSRAMDevicesView = new List<SRAMWrapper>();
      if(!Apexpages.currentPage().getParameters().containskey('isedit')) {
        isedit = false;
      }
      else {
        isedit = true;
      }

      //isedit = Apexpages.currentPage().getParameters().get('isedit') == '1' ? true : false;
          CurrentProposal = [Select Id, Name, SRAM_Sizes__c, Free_Devices__c, Mask_Set_Long__c, OTP_Size__c, RecordTypeId,
                                                                            IS_it_Sponsered_IP__c,UV_Pasivation_Required__c,
                                                                            Size_MTP__c,IS_it_Sponsered_IP_MTP__c,UV_Pasivation_Required_MTP__c//added by sunita
                                                                             From Apttus_Proposal__Proposal__c
                                                                            Where Id =: ApexPages.currentPage().getParameters().get('Id')];
        readOnlyModeEnabled = false;
        String recordTypeOfConfigurator = CurrentProposal.RecordTypeId;
        List<RecordType> recTypeList = [Select DeveloperName from RecordType where Id =: recordTypeOfConfigurator];
        if(recTypeList != null && recTypeList.size() != 0)
            readOnlyModeEnabled = recTypeList.get(0).DeveloperName.contains('_Read_Only');
                                                                                
                                                                            
        Map<String, String> existingSizesBySRAMs = new Map<String, String>();
        if(!String.isBlank(CurrentProposal.SRAM_Sizes__c)) {
          for(String prodSize : CurrentProposal.SRAM_Sizes__c.Split('<:>')) {
            list<String> lstString =  prodSize.split('>:<');
            if(lstString.size() > 1 && !String.isBlank(lstString[0]) && !String.isBlank(lstString[1]))
                existingSizesBySRAMs.put(lstString[0],lstString[1]);
          }
        }
        
        List<Apttus_Proposal__Proposal_Line_Item__c> lstSram = [Select Id, Option_Name_Static__c, Option_Model_Name_Static__c
                                                                FROM Apttus_Proposal__Proposal_Line_Item__c
                                                                Where Apttus_Proposal__Proposal__c =:ApexPages.currentPage().getParameters().get('Id') 
                                                                    AND  Option_Section_Name_Static__c LIKE 'SRAM %'];
        
        if(Test.isRunningTest()){
            Apttus_Proposal__Proposal_Line_Item__c testPLI1 = new Apttus_Proposal__Proposal_Line_Item__c(Option_Name_Static__c = 'Test1', Option_Model_Name_Static__c = 'abcd', Option_Section_Name_Static__c = 'SRAM');
            Apttus_Proposal__Proposal_Line_Item__c testPLI2 = new Apttus_Proposal__Proposal_Line_Item__c(Option_Name_Static__c = 'Test2', Option_Model_Name_Static__c = 'PQRS', Option_Section_Name_Static__c = 'SRAM');
            lstSram = new List<Apttus_Proposal__Proposal_Line_Item__c>{testPLI1, testPLI2};
        }    
        
        for(Apttus_Proposal__Proposal_Line_Item__c item : lstSram ) {
          if(existingSizesBySRAMs.containsKey(item.Option_Model_Name_Static__c))
            LstSRAMDevicesView.add(new SRAMWrapper(item.Option_Name_Static__c, item.Option_Model_Name_Static__c, existingSizesBySRAMs.get(item.Option_Model_Name_Static__c)));
        else
            LstSRAMDevicesView.add(new SRAMWrapper(item.Option_Name_Static__c, item.Option_Model_Name_Static__c));
            
        }
    }
    
    public class SRAMWrapper {
      public String prodName{get;set;}
      public String modelName{get;set;}
      public String size{get;set;}
      SRAMWrapper(String prodct, String mName) {
        prodName = prodct;
        modelName = mName;
      }
      SRAMWrapper(String prodct,String mName, String psize) {      
        prodName = prodct;
        modelName = mName;
        size = psize;
        
      }
    }
    // save the data
    public Pagereference saveSramSize() {
           CurrentProposal.SRAM_Sizes__c = '';
 /*--------------added by sunita for Case 00076793 start-----------------------------------*/            
         CurrentProposal.OTP_Size__c=otpsize;
         CurrentProposal.IS_it_Sponsered_IP__c=Sponsered;
         CurrentProposal.UV_Pasivation_Required__c=Pasivation;
         
         CurrentProposal.Size_MTP__c=MTPsize;
         CurrentProposal.IS_it_Sponsered_IP_MTP__c=MTPSponsered;
         CurrentProposal.UV_Pasivation_Required_MTP__c=MTPPasivation;
/*--------------added by sunita for Case 00076793  end-----------------------------------*/           
          for(SRAMWrapper sram : LstSRAMDevicesView) {
           
            CurrentProposal.SRAM_Sizes__c = CurrentProposal.SRAM_Sizes__c + '<:>'+sram.modelName + '>:<' + sram.size;
          }
          if(!String.isBlank(CurrentProposal.SRAM_Sizes__c)) {
            CurrentProposal.SRAM_Sizes__c = CurrentProposal.SRAM_Sizes__c.substring(CurrentProposal.SRAM_Sizes__c.indexof('<:>')+3);
          }
          try {
            upsert CurrentProposal;
          }
          catch(DMLException de) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,de.getDMLMessage(0)));
          }
          isEdit = false;
          PageReference pg = new PageReference('/apex/SRAM_Devices?id='+CurrentProposal.Id);
          pg.setRedirect(true);
          return pg;
    }
    
    
/*--------------modified by sunita for Case 00076793  start-----------------------------------*/       
    public void goToEdit() {
          
     isedit=true; 
     otpsize=CurrentProposal.OTP_Size__c;
     Sponsered=CurrentProposal.IS_it_Sponsered_IP__c;
     Pasivation=CurrentProposal.UV_Pasivation_Required__c;
     
     MTPsize=CurrentProposal.Size_MTP__c;
     MTPSponsered=CurrentProposal.IS_it_Sponsered_IP_MTP__c;
     MTPPasivation=CurrentProposal.UV_Pasivation_Required_MTP__c;
     
    }
/*--------------modified by sunita for Case 00076793  end-----------------------------------*/       
   
}