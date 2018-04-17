/*
*	@ Author		: Navneet Rajput
*	@ Description	: Factory of Order/Shipping/Production objects.
*	@ Company		: Cognizant Technology LTD
**/

public with sharing class GF_DynamicQueryObjectFactory {

	
	/*
	* @ Description	:- method decide which object to return at run time it differs on the basis of instanceName pass in to method as parameter.
	* @ Param		:- Class Name : String
	* @ Return		:- Type of instance
	**/
	
	public static Type getDynamicQueryObjectInstance(String instanceName){
		
		return Type.forName(instanceName);
	}
	
}