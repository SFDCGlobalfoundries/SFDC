/*
  Author: Anirban Roy
  Description: This is the controller for the DeviceExpToCustomerVF component.
  History:
    ARoy        06062013    - code creation.                       
*/

public class DeviceExpToCustomerController {
    
    public Id oppProgId {get;set;}
    public Id deviceId {get; set;}
    public String objectType {get; set;}
    public String emailType {get; set;}
    
    public DeviceExpToCustomerController() {}
    
    public String getFaeDetail(){ 
        String result = '';   
        try{
                  
            String noOppProgFAEInfo = EnvironmentVariable.get('NO_OPP_PROG_FAE_INFO');
            set<String> sOppProgTeamRole = new set<string> {EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FAE'),
                                                           EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_FTS'),
                                                           EnvironmentVariable.get('OPPTY_PROG_TM_ROLE_PFTS')};
            
            sOppProgTeamRole.remove(null);
            //Get the User information for the Opportunity_Program__c and Team Role = 'Field Application Engineer'
            List<Opportunity_Program_Team_Member__c> oppProgTeamMember = [SELECT User__r.Name,User__r.Email
                                                                            FROM Opportunity_Program_Team_Member__c
                                                                            WHERE Opportunity_Program__c = :oppProgId
                                                                            AND (    Team_Role__c in :sOppProgTeamRole 
                                                                                OR (Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                                                                OR (Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) )];
        
            for(Opportunity_Program_Team_Member__c oppTM : oppProgTeamMember){
                result = result + oppTM.User__r.Name + ': ' + oppTM.User__r.Email+ ', ';
            }
                        
            if(result.length() > 0){
                result = result.removeEnd(', ');
            }else {
                result = noOppProgFAEInfo;
            }
            
        }catch (Exception e) {
            result = 'Error: ' + e.getMessage();
            
        }
        
        return result;
    }
    
    public string getTargetId(){
        String result = '';
        if(!String.isBlank(objectType)){
            if(objectType == 'ECF'){
                //soql = 'Select Export_Control_Form__c from  Device_Export_Control_Junction__c  where Device__c = \'' + deviceId + '\' limit 1';
                result = EnvironmentVariable.get('EXPOSE_DEVICE_ECF_PATH').replace('{0}',deviceId);
            }
                
            else if(objectType == 'IDF'){
                String soql = 'Select id from  IP_Declaration_Form__c  where Device__c = \'' + deviceId + '\' limit 1';
                list<Sobject> queryResult = database.query(soql);
                if(queryResult.size() > 0) {
                    String idfId = (string)queryResult[0].get('id');
                    result = EnvironmentVariable.get('EXPOSE_DEVICE_IPD_PATH').replace('{0}',idfId);
                }
            }
            
            String portalUrl = EnvironmentVariable.get('SFDC_CUSTOMER_PORTAL');
            if(result != ''){
                result = portalUrl + result;
            }else{
                result = portalUrl + '/' + deviceId;
            }
        }
        system.debug(result);
        return result;
    }
    
   
}