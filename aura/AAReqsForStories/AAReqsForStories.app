<aura:application controller="AARequirementDocument">
<ltng:require styles="/resource/slds/slds/styles/salesforce-lightning-design-system.css"/>
	<aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
	<aura:renderIf isTrue="{!v.showListOfBuilds}">
		<div class="centered">
			<div class='heading1'>Active Builds</div>
		</div>
		<table class="slds-table slds-table--bordered slds-max-medium-table--stacked">
		  <thead>
		    <tr class="slds-text-heading--label">
		      <th scope="col">
		        <span class="slds-truncate">Build Name</span>
		      </th>
		      <th scope="col">
		        <span class="slds-truncate">Created By</span>
		      </th>
		      <th scope="col">
		        <span class="slds-truncate">Release Date</span>
		      </th>
		      <th scope="col">
		        <span class="slds-truncate">Release Freeze</span>
		      </th>
		    </tr>
		  </thead>
		  <tbody>
		  	<aura:iteration items="{!v.allBuild}" var="onebuild">
			    <tr class="slds-hint-parent" data-build-id="{!onebuild.Id}" onclick="{!c.selectedBuild}">
			      <td data-label="Build Name" role="row" data-build-id="{!onebuild.Id}" >
			      	<a class="slds-truncate" data-build-id="{!onebuild.Id}" >{!onebuild.Name}</a>
			      </td>
			      <td data-label="Created By" data-build-id="{!onebuild.Id}" ><a href="#" class="slds-truncate" data-build-id="{!onebuild.Id}" >{!onebuild.CreatedBy.Name}</a></td>
			      <td data-label="activity" data-build-id="{!onebuild.Id}" >
			        <span class="slds-truncate" data-build-id="{!onebuild.Id}" >{!onebuild.Release_Date__c}</span>
			      </td>
			      <td data-label="stage" data-build-id="{!onebuild.Id}" >
			        <span class="slds-truncate" data-build-id="{!onebuild.Id}" >{!onebuild.agf__Release_Freeze__c}</span>
			      </td>
			    </tr>
		    </aura:iteration>
		  </tbody>
		</table>
	</aura:renderIf>
	<aura:renderIf isTrue="{!!v.showListOfBuilds}">
		<div>
			<div class="centered">
				<div class='heading1'>{!v.build.Name}</div>
			</div>
			<aura:iteration items="{!v.workItems}" var="workItem">
				<c:AAWorkDisplay workId='{!workItem}' userType="{!v.userType}"/>
			</aura:iteration>
		</div>	
	</aura:renderIf>
	
</aura:application>