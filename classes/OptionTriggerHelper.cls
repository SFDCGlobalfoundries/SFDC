/**
@Author < Meghna Ganguly >
@name < OptionTriggerHelper>
@CreateDate < 12/16/2016 >
@Description < Helper class for Optiontrigger>
@Version <1.0>
@ Change history: 28.06.2017 / Poulami Saha / Modified to populate 'Opportunity Program ' from device.
*/
public class OptionTriggerHelper {
    
    // method invoked on before insert event
    // method to set device on Option
    public void setDeviceonInsert() {
    
     List <Id> listDevIds = new List <Id>();
     
     for(Customer_Requirement__c custReq: (List<Customer_Requirement__c>)Trigger.new) 
       {
     
           listDevIds.add(custReq.Device__c);
           if(custReq.Brand_and_Sub_brand__c != '' && custReq.Brand_and_Sub_brand__c != null){
                String brandSub = custReq.Brand_and_Sub_brand__c;
                String brand = brandSub.substringBefore('-').trim();
                String subBrand = brandSub.substringAfter('-').trim();
                if(brand != '' && brand != null){
                    custReq.Brand__c = brand;
                }
                if(subBrand != '' && subBrand != null){
                    custReq.Sub_Brand__c = subBrand;
                }
           }
       }
      
      if(!listDevIds.isEmpty()) 
           {
              setOpportunity(listDevIds);
           }
      }
   // method invoked on before update event
   // method to set device on Option   
    public void setDeviceonUpdate() 
    {  
        List <Id> listDevIds = new List <Id>();
        Map<Id,Customer_Requirement__c> triggerOldMap = ((Map<Id,Customer_Requirement__c>)Trigger.oldMap);
        for(Customer_Requirement__c custReq: (List<Customer_Requirement__c>)Trigger.new)
        {
            Customer_Requirement__c Cr = triggerOldMap.get(custReq.Id);
            if(custReq.Opportunity__c != Cr.Opportunity__c) 
            {
                listDevIds.add(custReq.Device__c);
            } 
            else if(custReq.Opportunity__c == null) 
            {  
                listDevIds.add(custReq.Device__c);
            }
            //Store the old value related to ITAR : SP4 (Changes)
            if(custReq.ITAR__c != Cr.ITAR__c || custReq.Is_this_product_associated_with_SME__c != Cr.Is_this_product_associated_with_SME__c ||
                custReq.Is_this_product_associated_with_MTCR__c != Cr.Is_this_product_associated_with_MTCR__c ||
                custReq.If_ITAR_is_Yes_Applicable_Suffixes__c != Cr.If_ITAR_is_Yes_Applicable_Suffixes__c ||
                custReq.If_ITAR_is_Yes_ITAR_Category__c != Cr.If_ITAR_is_Yes_ITAR_Category__c || 
                custReq.Design_Export_Control_Classification_Num__c != Cr.Design_Export_Control_Classification_Num__c ||
                custReq.Functional_ECCN__c != Cr.Functional_ECCN__c)
            {
                custReq.ITAR_Old_Value__c = Cr.ITAR__c;
                custReq.SME_Old_Value__c = Cr.Is_this_product_associated_with_SME__c;
                custReq.MTCR_Old_Value__c = Cr.Is_this_product_associated_with_MTCR__c;
                custReq.Applicable_Suffixes_Old_Value__c = Cr.If_ITAR_is_Yes_Applicable_Suffixes__c;
                custReq.ITAR_Category_old_Value__c = Cr.If_ITAR_is_Yes_ITAR_Category__c;
                custReq.Old_Design_ECCN_Value__c = Cr.Design_Export_Control_Classification_Num__c;
                custReq.Old_Functional_ECCN__c = Cr.Functional_ECCN__c;
            }
            
            if(custReq.Brand_and_Sub_brand__c != '' && custReq.Brand_and_Sub_brand__c != null && custReq.Brand_and_Sub_brand__c != Cr.Brand_and_Sub_brand__c){
                String brandSub = custReq.Brand_and_Sub_brand__c;
                String brand = brandSub.substringBefore('-').trim();
                String subBrand = brandSub.substringAfter('-').trim();
                if(brand != '' && brand != null){
                    custReq.Brand__c = brand;
                }
                if(subBrand != '' && subBrand != null){
                    custReq.Sub_Brand__c = subBrand;
                }
            }
        }

        if(!listDevIds.isEmpty()) 
        {
            setOpportunity(listDevIds);
        }   
    }   
   
   // method to set Opportunity and Account on Option
   public static void setOpportunity(List<Id> devIds)
   {  
        List <Device__c> parentDevObjList = new List <Device__c>();
        parentDevObjList = [SELECT id, Opportunity2__c, Account__c, Opportunity_Program__c FROM Device__c WHERE ID IN: devIds];
        for(Device__c dev: parentDevObjList) 
        {
            for(Customer_Requirement__c optInfo: (List<Customer_Requirement__c>)Trigger.new) 
            {
                if (dev.id == optInfo.Device__c) 
                {
                    optInfo.Opportunity__c = dev.Opportunity2__c;
                    optInfo.Opportunity_Program__c = dev.Opportunity_Program__c;
                    optInfo.Account__c = dev.Account__c;
                }
            }
        }
    }   
    
    // method invoked on after insert event
   // method to create RFQ records from option creation
    public void createRFQ() {
      
    Set <Id> trSet = new Set <Id> ();
    Id rfqRecTypeId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Request_Information__c'AND DeveloperName = 'RFQ'].Id;
    for(Customer_Requirement__c custReq: (List<Customer_Requirement__c>)Trigger.new) 
     {
       trSet.add(custReq.Id);
     }
    if(trSet.size()> 0) 
    {
      BnPTRtriggerHelper.createRFQrecords(trSet);
    }
      
      } 
    
    // method to insert option share records when option record is created  
    public void insertoptionShare(){ 
    
     Map<Id,Customer_Requirement__c> triggerNewMap = ((Map<Id,Customer_Requirement__c>)Trigger.newMap);
     OptionShareHelper.insertoptionShare(triggerNewMap.keySet());
    }  
      
    //method to create ERP Device records when option record is created or updated with option stage is Reconciliation
    // and Deliverable Part Number is Null  
      
      public void createERP_DEVICE(){
        List<Customer_Requirement__c> optList = new List<Customer_Requirement__c>();
        for(Customer_Requirement__c opt : (List<Customer_Requirement__c>)Trigger.new){
            if(opt.Option_Stage__c != 'Try for Fit' && opt.Option_Stage__c != 'Customer Engagement' && opt.Option_Stage__c != 'Bid and Quote' && opt.Deliverable_Part_Number_DPN_Formula__c != null){
                optList.add(opt);
            }
        }
        if(!optList.isEmpty()){
            UtilOptionsTrigger.create_ERP_DEVICE(optList);
        }
      }
      
      //method to set ITAR and ECCN value on Device from Primary Option until Export Control Form is not Approved
      public void updateDevice(){ 
          Map<Id,Device__c> deviceMap = new Map<Id,Device__c>();
          List<Device__c> deviceToUpdate = new List<Device__c>();
          List<Id> optId = new List<Id>();
          
          try{                 
              for(Device__c dev : [Select id,ITAR_Flag__c,Device_ID__c,ECCN_Technology__c,Stage__c,Primary_Option__c,(Select id,Status__c,Device__c from Device_Export_Control_Junctions__r) from Device__c where Primary_Option__c in : (List<Customer_Requirement__c>)Trigger.new]){
                  deviceMap.put(dev.id,dev);
              }
              
              if(!deviceMap.isEmpty()){
                  for(Customer_Requirement__c opt: (List<Customer_Requirement__c>)Trigger.new){
                      if(opt.Device__c != null && deviceMap.get(opt.Device__c).Primary_Option__c == opt.id 
                          && (opt.ITAR__c != deviceMap.get(opt.Device__c).ITAR_Flag__c || (opt.Design_ECCN__c != null && opt.Functional_ECCN__c != null && (opt.Design_ECCN__c+'/'+opt.Functional_ECCN__c) != deviceMap.get(opt.Device__c).ECCN_Technology__c)
                          || (opt.Design_ECCN__c != null && opt.Functional_ECCN__c == null && opt.Design_ECCN__c != deviceMap.get(opt.Device__c).ECCN_Technology__c)
                          || (opt.Design_ECCN__c == null && opt.Functional_ECCN__c == null && deviceMap.get(opt.Device__c).ECCN_Technology__c != null))
                          && ((deviceMap.get(opt.Device__c).Device_Export_Control_Junctions__r.size()>0 && deviceMap.get(opt.Device__c).Device_Export_Control_Junctions__r[0].Status__c != 'Approved')
                           || deviceMap.get(opt.Device__c).Device_Export_Control_Junctions__r.size() <= 0)){
                          
                          deviceMap.get(opt.Device__c).ITAR_Flag__c = opt.ITAR__c;
                          deviceMap.get(opt.Device__c).ECCN_Technology__c = (opt.Functional_ECCN__c != null?opt.Design_ECCN__c+'/'+opt.Functional_ECCN__c:opt.Design_ECCN__c);
                          deviceToUpdate.add(deviceMap.get(opt.Device__c));
                      }
                      if(opt.Device__c != null && deviceMap.get(opt.Device__c).Primary_Option__c == opt.id){   
                          if(opt.Option_Stage__c == 'Prototype Fulfillment' && deviceMap.get(opt.Device__c).Stage__c != 'RTR' && deviceMap.get(opt.Device__c).Stage__c != 'Production' && deviceMap.get(opt.Device__c).Stage__c != 'EOL'){
                            deviceMap.get(opt.Device__c).Stage__c = 'Prototype';        
                          }
                          else if (opt.Option_Stage__c == 'Customer Decision' && deviceMap.get(opt.Device__c).Stage__c != 'Production' && deviceMap.get(opt.Device__c).Stage__c != 'EOL'){  
                            deviceMap.get(opt.Device__c).Stage__c = 'RTR';      
                          }
                          else if(opt.Option_Stage__c == 'Production' && deviceMap.get(opt.Device__c).Stage__c != 'EOL'){
                            deviceMap.get(opt.Device__c).Stage__c = 'Production';                       
                          }
                          deviceToUpdate.add(deviceMap.get(opt.Device__c));
                          system.debug('deviceToUpdate ::::'+deviceToUpdate);
                      }
                  }
              }
                        
              if(!deviceToUpdate.isEmpty()){
                  database.update(deviceToUpdate);
              }
          }
          catch(Exception e){
               GlobalUtility.logMessage('Error','OptionTriggerHelper ','updateDevice','','Exception : ',String.valueof(e.getMessage()),'','BnP',e,0);
          }
      }
        public void creatupdtOptBefore(){
        Map<Id,Device__c> mapDevice = new Map<Id,Device__c>();
        Set<Id> optId = new Set<Id>();
        try{
            for(Customer_Requirement__c opt: (List<Customer_Requirement__c>)Trigger.new){
                optId.add(opt.Device__c);
            }
            if(!optId.IsEmpty()){       
                for (Device__c dev : [SELECT Id, Automotive_Device__c,Market_Segment__c from Device__c Where Id IN : optId]){
                    mapDevice.put(dev.Id,dev);    
                }
            }
            if(!mapDevice.IsEmpty()){
                for(Customer_Requirement__c opt: (List<Customer_Requirement__c>)Trigger.new){
                    if(mapDevice.get(opt.Device__c).Automotive_Device__c != null){
                        opt.Does_the_contract_or_accepted_quote__c = mapDevice.get(opt.Device__c).Automotive_Device__c;
                    }
    
                    if(mapDevice.get(opt.Device__c).Automotive_Device__c == null && mapDevice.get(opt.Device__c).Market_Segment__c == 'Automotive' && opt.Does_the_contract_or_accepted_quote__c == null){
                        opt.addError('Does the Device contain Automotive Rqmnt is required');  
                    }                           
                }
            }        
        } catch(Exception e){
            GlobalUtility.logMessage('Error','OptionTriggerHelper ','creatupdtOptBefore','','Exception : ',String.valueof(e.getMessage()),'','BnP',e,0);        
        }        
    }  
     public void updtChipOptionStageAfter(){
        Map<Id,Set<ID>> mapOption = new Map<Id,Set<ID>>();
        Set<Id> optId = new Set<Id>();
        List<Customer_Requirement__c> OptionsToBeUpdated = new List<Customer_Requirement__c>();
        List<Customer_Requirement__c> lstOptions = new List<Customer_Requirement__c>();
        try{
           for(Customer_Requirement__c opt: (List<Customer_Requirement__c>)Trigger.new){
            //Customer_Requirement__c oldOpt = Trigger.oldMap.get(opt.Id);
                optId.add(opt.ID);
                lstOptions.add(opt);
            }
            if(!optId.IsEmpty() ){   //&& (oldOpt.Option_Stage__c != opt.Option_Stage__c)    
                for (Module_Data__c  mod : [SELECT Id,Technical_Requirement__r.Option_Stage__c,Technical_Requirement__c,Chip_1__r.Technical_Requirement__c,Chip_2__r.Technical_Requirement__c,Chip_3__r.Technical_Requirement__c,Chip_4__r.Technical_Requirement__c,Chip_5__r.Technical_Requirement__c,Chip_6__r.Technical_Requirement__c from Module_Data__c Where Technical_Requirement__c IN : optId]){
                    Set<Id> optionIds = new Set<Id>();
                    if(mod.Technical_Requirement__r.Option_Stage__c != 'Customer Engagement' && mod.Technical_Requirement__r.Option_Stage__c != 'Try for Fit' && mod.Technical_Requirement__r.Option_Stage__c != 'Bid and Quote'){                                           
                        if(mod.Chip_1__r.Technical_Requirement__c!=null){
                           optionIds.add(mod.Chip_1__r.Technical_Requirement__c);
                        }
                        if(mod.Chip_2__r.Technical_Requirement__c!=null){
                           optionIds.add(mod.Chip_2__r.Technical_Requirement__c);
                        }
                        if(mod.Chip_3__r.Technical_Requirement__c!=null){
                           optionIds.add(mod.Chip_3__r.Technical_Requirement__c);
                        }
                        if(mod.Chip_4__r.Technical_Requirement__c!=null){
                           optionIds.add(mod.Chip_4__r.Technical_Requirement__c);
                        }
                        if(mod.Chip_5__r.Technical_Requirement__c!=null){
                           optionIds.add(mod.Chip_5__r.Technical_Requirement__c);
                        }
                        if(mod.Chip_6__r.Technical_Requirement__c!=null){
                           optionIds.add(mod.Chip_6__r.Technical_Requirement__c);
                        }
                        mapOption.put(mod.Technical_Requirement__c,optionIds);
                    }       
                }   
                For(Customer_Requirement__c  Option : [SELECT Id,Option_Stage__c from Customer_Requirement__c Where ID IN : mapOption.get(lstOptions[0].id)]){
                    Option.Option_Stage__c = lstOptions[0].Option_Stage__c;
                        OptionsToBeUpdated.add(Option);  
                }                   
            }           
            Update OptionsToBeUpdated;  
        } catch(Exception e){
            GlobalUtility.logMessage('Error','OptionTriggerHelper ','creatupdtOptBefore','','Exception : ',String.valueof(e.getMessage()),'','BnP',e,0);        
        }        
    }                   
}