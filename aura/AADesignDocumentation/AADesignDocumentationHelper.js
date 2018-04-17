({
	getDesignDetails : function(cmp, did) {
		var action = cmp.get('c.getDesign');
		action.setParams({ designId : did });
		action.setCallback(cmp,
	        function(response) {
	            var state = response.getState();
	            if (state === 'SUCCESS'){
	            	var design = response.getReturnValue();
	            	cmp.set("v.design", design);
	            	//console.log(design);
	            } else {
	                 //do something
	                 //alert("Design Documentation is not found");
	                 alert('2'+ JSON.stringify(response.error));
	            }
	        }
	    );
	    $A.enqueueAction(action);
	}
})