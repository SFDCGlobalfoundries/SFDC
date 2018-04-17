/*
* @ Author :- 
* @ Description :- 
* @ Date :- 20/06/2017

Change History:
    DATE            NAME                    Comments

    28-Jun-2017     Ram Rai                 Removed Hard Coding.

**/
public class FMS_CopyForm_DeviceCreation_Ctrl {
    public String selectedDevice {get;set;}
    public Id parentFormId; 
    public String formTypeVal;
    public final String FMS_SELECT_VAL = EnvironmentVariable.get('FMS_SELECT_VALUE');
    public FMS_CopyForm_DeviceCreation_Ctrl(){
        //Actual form or parent form(to be copied) id 
        parentFormId = ApexPages.currentPage().getParameters().get('id');
        //parameter to be passed to this page allowed values are 'Main' / 'IMC'
        formTypeVal = ApexPages.currentPage().getParameters().get('formType');
    }
    public List < SelectOption > getAvailableDeviceList() {
        List < SelectOption > deviceList = new List < SelectOption > ();
         deviceList.add(new SelectOption('' , FMS_SELECT_VAL ));
        for(Device__c dev : [SELECT Id, Name FROM Device__c WHERE Id NOT IN (SELECT Device__c FROM Form_Management_System__c) and Account__r.Fab_9_10__c = 'Yes' order by CreatedDate desc]){
            deviceList.add(new SelectOption(dev.id , dev.Name));
           
        }
        return deviceList;
    }
    
    public pageReference ContinueNext(){
        
        if(selectedDevice != null && selectedDevice!=''){
            PageReference pageref = new Pagereference('/apex/FMSCopyForms');
            pageref.getParameters().put('id',parentFormId);
            pageref.getParameters().put('device',selectedDevice);
            
            return pageref;
        }
        return null;
    }
    public pageReference createDevice(){
        if(formTypeVal=='IMC'){
            List<Form_Management_System__c> lstForm = [Select device__c from Form_Management_System__c where id=:parentFormId];
            if(!lstForm.isEmpty()){
            	Device__c retrofitDeviceCreate = createRetrofitDevice(lstForm.get(0).device__c);  
                if(retrofitDeviceCreate.id != null){
                    PageReference pageref = new Pagereference('/apex/FMSCopyForms');
                    pageref.getParameters().put('id',parentFormId);
                    pageref.getParameters().put('device',retrofitDeviceCreate.id);
                    
                    return pageref;
                }
            } 
        }
        else if(formTypeVal=='Main'){
        }
        return null;
    }
    
    //Method handles retrofit device creation on creation of IMC from adendum.
    public device__c createRetrofitDevice(Id parDeviceId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.Device__c.FieldSets.FMS_DeviceFields.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id  FROM Device__c WHERE Id =:parDeviceId';
        
        Device__c  retrofitDevice = UtilityCls.createRetrofitDevice(Database.query(query),null);   
        try{
            Id accoutnid = retrofitDevice.Account__c;
            retrofitDevice.FMS_ID__c = 'FMS';
           
            insert retrofitDevice;
            
            //update account id in device back on choosen .
            if(retrofitDevice.id != null){
                Device__c retroupdate = new Device__c(Id = retrofitDevice.id , account__c = accoutnid);
                update retroupdate;                
            }
            return retrofitDevice;
        }
        catch(Exception E){
              UtilityCls.saveExceptionLog(FMSTriggerHandler.class.getName(), 'createRetrofitDevice()', '', 'Bug', '', '', 'Error', e.getTypeName(), 'FMS', e, 0);
        }     
        return null;
    }
}