({
	doInit : function(component, event, helper) {
		helper.getUserType(component);
		if(location.hash !== ''){
			var buildId = location.hash.substring(1, 16);
			helper.getBuildDetails(component, buildId);
		}else{
			component.set("v.showListOfBuilds", true);
			helper.getBuilds(component);
		}
	},
	selectedBuild: function(component, event, helper){
		if(event.target.getAttribute("data-build-id")){
			location.hash = '#'+ event.target.getAttribute("data-build-id");
			helper.getBuildDetails(component, event.target.getAttribute("data-build-id"));
		}
	}
})