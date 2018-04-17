({
	getBuildDetails : function(cmp, bid) {
		var action = cmp.get('c.getBuildDetails');
		action.setParams({ buildId : bid });
		action.setCallback(cmp,
	        function(response) {
	            var state = response.getState();
	            if (state === 'SUCCESS'){
	            	var build = response.getReturnValue();
	            	cmp.set("v.build", build);
	            	if(build !== null && typeof build !== "undefined"){
	            		if(build.agf__Scheduled_Build__r != null && typeof build.agf__Scheduled_Build__r != "undefined"){
	            			var workitemsIds = [];
	            			for(var index= 0; index < build.agf__Scheduled_Build__r.length; index++ ){
	            				workitemsIds.push(build.agf__Scheduled_Build__r[index].Id );
	            			}
	            			cmp.set("v.workItems", workitemsIds);
	            			cmp.set("v.showListOfBuilds", false);
	            		}
	            	}
	            } else {
	                 cmp.set("v.showListOfBuilds", true);
	                 alert('Build is not found');
	            }
	        }
	    );
	    $A.enqueueAction(action);
	},
	getBuilds : function(cmp) {
		var action = cmp.get('c.getBuilds');
		action.setCallback(cmp,
	        function(response) {
	            var state = response.getState();
	            if (state === 'SUCCESS'){
	            	var builds = response.getReturnValue();
	            	cmp.set("v.allBuild", builds);
	            } else {
	                 cmp.set("v.showListOfBuilds", true);
	                 alert('Build is not found');
	            }
	        }
	    );
	    $A.enqueueAction(action);
	},
	getUserType: function(cmp) {
		var action = cmp.get('c.getUserType');
		action.setCallback(cmp,
	        function(response) {
	            var state = response.getState();
	            if (state === 'SUCCESS'){
	            	var userType = response.getReturnValue();
	            	cmp.set("v.userType", userType);
	            	//alert(JSON.stringify(userType));
	            } else {
	                 alert(JSON.stringify(response.error));
	            }
	        }
	    );
	    $A.enqueueAction(action);
	}
})