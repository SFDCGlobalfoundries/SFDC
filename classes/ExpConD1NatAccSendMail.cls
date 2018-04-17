/*
    Author: Anirban Roy
    Description: This is for the email to be sent on update of D1 National Access of Export Control Form after its approval.
    History: 
        ARoy	  10292013    - Code creation.
*/

public class ExpConD1NatAccSendMail {
	
	public Id paramId {get;set;}
	private List<DeviceWrapper> listDevices {get;set;}
	public String deviceCurrExpConD1NatAccIsAllowed {get;set;}
	public String devicePrevExpConD1NatAccIsAllowed {get;set;}
	
	public ExpConD1NatAccSendMail(){}
	
	public List<DeviceWrapper> getListDevices(){
		
		this.listDevices = new List<DeviceWrapper>();
		List<Id> devIds = new List<Id>();
		Integer i=0;
		for (Device_Export_Control_Junction__c j : [SELECT		Device__c
																, Device__r.CRMDID__c
																, Device__r.PTRF_ID__c
																, Export_Control_Form__r.D1_National_Access_is_Allowed__c
																, Export_Control_Form__r.Prev_D1_National_Access_is_Allowed__c
													FROM		Device_Export_Control_Junction__c
													WHERE		Export_Control_Form__c = :this.paramId]) {
			DeviceWrapper dw = new DeviceWrapper();
			dw.deviceId = j.Device__c;
			dw.deviceCRMDId = j.Device__r.CRMDID__c;
			if(i==0){
				deviceCurrExpConD1NatAccIsAllowed = j.Export_Control_Form__r.D1_National_Access_is_Allowed__c;
				devicePrevExpConD1NatAccIsAllowed = j.Export_Control_Form__r.Prev_D1_National_Access_is_Allowed__c;
				i++;
			}
			devIds.add(j.Device__c);			
			this.listDevices.add(dw);
		}
		
		if(devIds.size()>0){
			List<PTRF__c> ptrfList = [SELECT	Name,
												Device__c
									  FROM 		PTRF__c
									  WHERE		Device__c IN :devIds];
									  
			for(DeviceWrapper dw : this.listDevices){				
				dw.devicePTRFId='';
				for(PTRF__c ptrf : ptrfList){
					if(dw.deviceId == ptrf.Device__c){
						dw.devicePTRFId += ptrf.Name + ', ';
					}
				}
				if(dw.devicePTRFId <> null){
					dw.devicePTRFId = dw.devicePTRFId.removeEnd(', ');
				}
			}									  
		}
	
		return this.listDevices;
	}
	
	public class DeviceWrapper {
		public String deviceId {get;set;}
		public String deviceCRMDId {get;set;}
		public String devicePTRFId {get;set;}
	}
}