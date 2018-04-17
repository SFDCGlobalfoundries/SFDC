({
	getSettings : function(component) {
		var action = component.get("c.getSettings");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.settings", response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
    },saveSetting : function(component, setting, callback) {
        var settingJson = $A.util.json.encode(setting);
        var action = component.get("c.saveSetting");
        action.setParams({
            "settingJson": settingJson
        });
        
        if(callback) {
            action.setCallback(this, callback);
        }
        $A.enqueueAction(action);
    }
})