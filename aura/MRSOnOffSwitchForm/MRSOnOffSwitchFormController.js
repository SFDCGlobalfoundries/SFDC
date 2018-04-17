({
	doInit : function(component, event, helper) {
		helper.getSettings(component);
	},
    updateValue : function(component, event, helper) {
        helper.saveSetting(component, event.getParam("setting"));
    },
})