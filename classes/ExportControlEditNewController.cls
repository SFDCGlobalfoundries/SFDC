/*
    Author: Yash Kumar
    Description: Override standerd page functionality.
    History: 
    Yash kumar      23/09/2014    - Apex code created
    
*/
public class ExportControlEditNewController{
public Export_Control_Form__c ExportControl{ get; set; }
public Device_Export_Control_Junction__c devExpConJunc {get;set;}
public Boolean initialised {get;set;}
Id id = ApexPages.currentPage().getParameters().get('id');
private ApexPages.StandardController controller;
 Id profId = UserInfo.getProfileId();
                List<Profile> profNameList = [select name, UserType from Profile where Id = :profId limit 1];
 //init method
    public PageReference getdata(){
        PageReference pr = null;
        if (!initialised){              
                String custPortalUsrTyp = EnvironmentVariable.get('USER_TYPE_CUST_PORTAL');            
                String usrType = '';           
                devExpConJunc =  [select  Export_Control_Form__c,
                                                                    CRM_Device_ID__c,
                                                                    Customer_Name__c,
                                                                    Device_Name__c,
                                                                    Export_Control_Template__c,
                                                                    Fab__c,Device__c,
                                                                    LastModifiedBy__c,
                                                                    Project_Name__c 
                                                            from Device_Export_Control_Junction__c
                                                            where Export_Control_Form__c= :id limit 1];
               
                
                if(profNameList.size()>0){
                        usrType = profNameList[0].UserType;
                }
                if(usrType==custPortalUsrTyp){                                                
                    //pr = new PageReference('/'+ExportControl.Id+'?nooverride=1');
                    pr = new PageReference('/apex/ExportControlEdit?deviceid='+devExpConJunc.Device__c);
                    
                    pr.setRedirect(true);
                }
                else
                {
                    pr = new PageReference('/'+devExpConJunc.Id+'?nooverride=1');
                    pr.setRedirect(true);
                }
                initialised=true;
        }
        return pr;
    }
     public ExportControlEditNewController(ApexPages.StandardController controller) {
        this.controller = controller;         
        Id id = ApexPages.currentPage().getParameters().get('id');
        initialised = false;
         
                
       
        }
}