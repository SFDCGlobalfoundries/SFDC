({
	getDetails : function(cmp, wid) {
		var action = cmp.get('c.getWorkDetails');
		action.setParams({ workId : wid });
		action.setCallback(cmp,
	        function(response) {
	            var state = response.getState();
	            if (state === 'SUCCESS'){
	            	cmp.set("v.work", response.getReturnValue());
	            } else {
	                 //do something
	            }
	        }
	    );
	    $A.enqueueAction(action);
	},
	setApproval : function(cmp, wid, approval, approvalStatus) {
		var action = cmp.get('c.approve');
		action.setParams({ workId : wid, field : approval, value : approvalStatus});
		//console.log(action.getParams());
		action.setCallback(cmp,
	        function(response) {
	            var state = response.getState();
	            if (state === 'SUCCESS'){
	            	//cmp.set("v.work", response.getReturnValue());
	            	cmp.helper.getDetails(cmp, wid);
	            } else {
	                 //do something
	                 alert('3'+ JSON.stringify(response.error));
	            }
	        }
	    );
	    $A.enqueueAction(action);
	}
})