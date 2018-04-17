({
	doInit : function(component, event, helper) {
		var did = component.get("v.designId");
		//console.log(component.get("v.designId")+ '  +++ ');
		helper.getDesignDetails(component, did);
	}
})