({
	doInit :function(component, event, helper) {
		helper.getDetails(component, component.get('v.workId'));
	},
	approveTFA: function(component, event, helper){
		var userType = component.get("v.userType");
		if(userType.TFA__c){
			if(event.target.getAttribute("data-work-id")){
				if(event.target.getAttribute("data-work-status")){
					var workId = event.target.getAttribute("data-work-id");
					workId = workId.substring(0, 15);
					var TFAStatus = event.target.getAttribute("data-work-status") === "true"? false: true;
					helper.setApproval(component, workId, 'TFA_Approved__c', TFAStatus);
				}
			}
		}else{
			alert("Only TFA can change the flag");
		}
		
	},
	approveTA: function(component, event, helper){
		var userType = component.get("v.userType");
		if(userType.TA__c){
			if(event.target.getAttribute("data-work-id")){
				if(event.target.getAttribute("data-work-status")){
					var workId = event.target.getAttribute("data-work-id");
					workId = workId.substring(0, 15);
					var TFAStatus = event.target.getAttribute("data-work-status") === "true"? false: true;
					helper.setApproval(component, workId, 'TA_Approved__c', TFAStatus);
				}
			}
		}else{
			alert("Only TA can change the flag");
		}
	}
})