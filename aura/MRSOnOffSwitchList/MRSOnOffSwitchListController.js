({
	update : function(component, event, helper) {		
        
        var setting = component.get("v.setting");
        var updateEvent = component.getEvent("updateSetting");//updateSetting event matchs name of event registered in MRSOnOffSwitchList
        updateEvent.setParams({"setting":setting}).fire();
	}
})