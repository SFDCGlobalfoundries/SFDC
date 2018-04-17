/**********************************************************************************************************************************
    Class:         CPQConfigurationapprovalController 
    -----------------------------------------------------------------------------------------------------------------------------------
    Author:         Monalisa Mohapatra
    Description:    It will display the error message for Entry Criteria in Approval Process
    History:
                    Monalisa        02102015    - Code Creation
                    Arun            02192015    - Added Device & Device Fab Validation For portal users & Back button functionality.
                    ARoy            09242015    - Added new validations on submission.
                    ARoy            12152015    - Added IP Status validations on submission.
                    Karna Shiva     Sprint II   - Added Justification for Retrofit for FAE USer(Apr-01-2016).
                    Shivam Sharma   04262016    - Added Device purpose validation for 0.014UM Geometries for Wirebond
                    Karna Shiva     08232016    - Added code to stop device validation for external customers
                    Aagarwala       00057087    - Added functionality to bypass the validation checks for Design Win
                    Ram Rai                     - Added code inside the Catch Block to show proper error Message

***********************************************************************************************************************************/
public class CPQConfigurationapprovalController {


    public Id configId{get;set;}
    public Apttus_Proposal__Proposal__c configuration {get;set;}
    public transient List<Account_Team_Proxy__c> RecordOwner {get;set;}
    public transient String ErrorMessage{get;set;}     
    
    public transient Boolean entryFlag{get;set;}
    public transient Boolean errorFlag{get;set;}
    public transient Boolean acntFlag{get;set;} 
    public transient Boolean ptFlag{get;set;}
    public transient Boolean posFlag{get;set;}
    public transient Boolean devFlag{get;set;}
    public transient Boolean devFabFlag{get;set;}
    public transient Boolean ddDisableFlag{get;set;}
    
    public transient Boolean pocFlag{get;set;}
    public transient Boolean ptnFlag{get;set;}
    public transient Boolean deviceFlag{get;set;}
    public transient Boolean conIpStatus{get;set;}
    public transient Boolean metalOptionFlag{get;set;}
    public transient Boolean JustRetrofit{get;set;}
    public transient Boolean packagingDetailsFor14nmCompleted {get; set;}
    public transient String userType,FAEProfile;
    public Boolean initialised{get;set;}
    public String GF_FAE_FTS = EnvironmentVariable.get('GF_FAE_FTS');
    public String GF_SALES_USER = EnvironmentVariable.get('GF_SALES_USER');
    public String SYSTEM_ADMIN = EnvironmentVariable.get('SYS_ADMIN');
    public String profileName;
    public CPQConfigurationApprovalController ( ApexPages.StandardController controller )
    {
		NPCCopyConfigurationController.InsideNPCCopyConfig = true;
        configId =  ApexPages.CurrentPage().getparameters().get('id');
        
        RecordOwner = new List<Account_Team_Proxy__c>();
        try{

        configuration = [select id ,
                                name, 
                                OwnerId, 
                                Apttus_Proposal__Approval_Stage__c ,
                                Multi_Source_Tapeout_Approval_Stage__c,
                                Apttus_Proposal__Account__c, 
                                Process_Technology_Lookup__c, 
                                Poly_Orientation_Status_1__c, 
                                Device__c,
                                Fab_Name__c,
                                Purpose_of_the_Configuration__c,
                                Process_Technology_Name__c,
                                Devices__c,
                                IPs__c,
                                /* changed reference of Mask_Set__c to Mask_Set_Long__c for the Case#00051463*/
                                Mask_Set_Long__c,
                                APTPS_Metal_Options__c ,
                                Process_Technology__c,
                                Consolidated_IP_Status_Check__c,
                                Metal_Option_Not_Listed__c,
                                Additional_Info_on_Metal_Stack__c,
                                No_of_Metal_Layers__c,
                                Device__r.Tapeout_Type__c ,
                                Justification_of_Retrofit__c,
                                Packaging_Disclaimer_Message__c,
                                Process_Technology_Geometry__c,
                                RecordType.DeveloperName
                                FROM Apttus_Proposal__Proposal__c 
                                WHERE id =: configId ];
        initialised = false;
        errorFlag = false;                      
        ErrorMessage = '';                        
        userType = null;                     
        entryFlag = false;
        acntFlag = false;
        ptFlag = false;
        posFlag = false;
        devFlag = false;
        JustRetrofit = false;
        devFabFlag = false;
        ddDisableFlag = false; 
        pocFlag = false;
        ptnFlag = false;
        deviceFlag = false;
        conIpStatus = false;
        metalOptionFlag = false;
        packagingDetailsFor14nmCompleted = true;
        profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;

        checkUser();  
        }catch(Exception e){
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ErrorMessage));
         
        }  
             
    }
    public void checkUser()
    {
        User u =[SELECT      Id
                            , AccountId
                            , profile.name
                            FROM        User
                            WHERE       Id = :UserInfo.getUserId()
                ];
        if (u.AccountId != null || u.profile.name == SYSTEM_ADMIN || u.profile.name.contains('Admin')) {
            userType=u.profile.name;
             if(configuration != null && configuration.Purpose_of_the_Configuration__c !='For Design Win'){
                validateConfiguration();
            }

        }else if (u.profile.name == GF_FAE_FTS || u.profile.name == GF_SALES_USER){
              FAEProfile = u.profile.name;
            validateFAEuser();
        }else{
            errorFlag = true;
            ErrorMessage = 'Only Customer, FAE users and Administrator can submit for approval.';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ErrorMessage));

        }

    }
    
    public void validateSubmitterComm(){
    
   
            if(configuration.Process_Technology__c == null)
            {
                //ErrorMessage+=' Process Technology have to configured.' ;
                ptFlag = true;
            }
                
            if(configuration.Apttus_Proposal__Account__c == null)
            {
                //ErrorMessage+=' Account have to be populated.' ;
                acntFlag = true;                
            }
            
            //=================ARoy  09242015  - Start: Added news validation on submission.=========================//
            if(configuration.Purpose_of_the_Configuration__c == null)
            {
                //ErrorMessage+=' Purpose of the Configuration have to be populated.' ;
                pocFlag = true;                
            }
            
            if(configuration.Process_Technology_Name__c == null)
            {
                //ErrorMessage+=' Process Technology Name have to be populated.' ;
                ptnFlag = true;                
            }
            
            if(configuration.Devices__c == null)
            {
                //ErrorMessage+=' Devices have to be populated.' ;
                deviceFlag = true;                
            }
            
            //===============ARoy  09242015  - End: Added news validation on submission.==========================//
            
            if(!configuration.Poly_Orientation_Status_1__c)
            {
                //ErrorMessage+=' Poly Orientation Status have to be green.' ;
                posFlag = true;
            }
          // Sprint II Enhancement - start 
            if(configuration.Device__r.Tapeout_Type__c == 'Retrofit' && configuration.Justification_of_Retrofit__c == null)
            {
                //ErrorMessage+=' Justification of Retrofit to be populated.' ;
                JustRetrofit = true;                
            }
          // Sprint II Enhancement - end
         
          // 06052016 SSharma - Start : For 14nm, Wirebond is not allowed if the Purpose of the device of the configurator is Product ( Wirebond is allowed for MPW or Test Vehicle)
          if(configuration.Process_Technology_Geometry__c == '0.014UM' && String.isBlank(configuration.Packaging_Disclaimer_Message__c)){
                packagingDetailsFor14nmCompleted = false;
                //ErrorMessage+=' For this 0.014UM Process Technology Configuration, Packaging details have not been completed.';
          }// 06052016 SSharma - End
           
         }      
    public void validateFAEuser()
    {
        
        RecordOwner = [SELECT Id, name, User__c, Team_Role__c 
                           FROM Account_Team_Proxy__c 
                           WHERE User__c =: UserInfo.getUserId() 
                               AND (  Team_Role__c='Field Application Engineer' 
                                   OR Team_Role__c='Primary Field Technical Support' 
                                   OR Team_Role__c='Primary Field Application Engineer' 
                                   OR ( Team_Role__c = 'Account Manager' AND Is_FAE__c = TRUE)
                                   OR ( Team_Role__c = 'Primary Account Manager' AND Is_FAE__c = TRUE) ) ];
        if(RecordOwner!=Null){
         
         entryFlag = true;
            
         validateSubmitterComm();
         
            if(configuration.Device__c == null )
            {
                //ErrorMessage+=' Device have to be configured.' ;
                devFlag = true;
            }  
            if(configuration.Fab_Name__c==null) 
            {
                //ErrorMessage+=' Device FAB have to be configured.' ;
                devFabFlag = true;
            }
            //12152015 ARoy : Validation on IP Consolidated Status 
            //*******************************************************//
            if(configuration.Consolidated_IP_Status_Check__c=='No') 
            {
                //ErrorMessage+=' Consolidated IP Status should be approved.' ;
                conIpStatus = true;
            }
            //*******************************************************//
            
            
            if(configuration.Metal_Option_Not_Listed__c 
                && (configuration.No_of_Metal_Layers__c==null||configuration.Additional_Info_on_Metal_Stack__c==null)){
                //ErrorMessage+=' Please specify the No of Metal Layers and Additional Information on Metal Stack. These fields cannot be left blank when Metal Option is not Listed.' ;
                metalOptionFlag = true;
            }
            ddDisableFlag = true;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ErrorMessage));
        }else{
            errorFlag = true;
            ErrorMessage = 'No record found in AccountTeamProxy Record as FAE/PFTS.';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ErrorMessage));
            }
            
    }
    public void validateConfiguration( )
    {
        entryFlag = true;   
       
        validateSubmitterComm();
        
        if(userType==SYSTEM_ADMIN || userType.contains('admin') || userType.contains('Admin'))
        {           
       
            if(configuration.Device__c == null )
            {
                //ErrorMessage+=' Device have to be configured.' ;
                devFlag = true;
            }  
            if(configuration.Fab_Name__c==null) 
            {
                //ErrorMessage+=' Device FAB have to be configured.' ;
                devFabFlag = true;
            }
            //12152015 ARoy : Validation on IP Consolidated Status 
            //*******************************************************//
            if(configuration.Consolidated_IP_Status_Check__c=='No') 
            {
                //ErrorMessage+=' Consolidated IP Status should be approved.' ;
                conIpStatus = true;
            }
            //*******************************************************//
            
        }     
             
                
        if(configuration.Metal_Option_Not_Listed__c 
            && (configuration.No_of_Metal_Layers__c==null||configuration.Additional_Info_on_Metal_Stack__c==null)){
            //ErrorMessage+=' Please specify the No of Metal Layers and Additional Information on Metal Stack. These fields cannot be left blank when Metal Option is not Listed.' ;
            metalOptionFlag = true;
        }
        ddDisableFlag = true;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ErrorMessage));
        
    }
    
    public pagereference Back()
    {
        Pagereference pr;
        if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
            pr = new PageReference('/GlobalfoundryView/'+ configuration.Id);
        }else{
            pr = new PageReference('/'+ configuration.Id);
        }
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference init(){
     try{  
          User u =[SELECT  profile.name FROM User
                            WHERE Id = :UserInfo.getUserId()];
          Map<String,ConfigApprovalStages__c> apprlStage = ConfigApprovalStages__c.getall();
          // Added by Shiva Karna for skipping validation for external customers - Start
          if (u.profile.name.contains('Customer') || u.profile.name.contains('Enablement') 
          || u.profile.name.contains('Overage') || u.profile.name.contains('Reseller') 
          || u.profile.name.contains('Supplier')){
                
            devFabFlag = false;
            deviceFlag = false;
            devFlag = false;
         }
         // Added by Shiva Karna for skipping validation for external customers - End    
        
          //Aagarwala code starts
          if(configuration != null && configuration.Purpose_of_the_Configuration__c =='For Design Win'){

                //configuration.Apttus_Proposal__Approval_Stage__c = 'Process Flow Accepted';
                //Added by Ravi Teja.B 21072017
                if(configuration.Purpose_of_the_Configuration__c == 'Final'){
                    configuration.Apttus_Proposal__Approval_Stage__c = 'Process Flow Accepted';
                }
                if(apprlStage.containsKey('Process Flow Accepted DW') && apprlStage.containsKey('Process Flow Accepted for Prelim')){
                    if(configuration.Purpose_of_the_Configuration__c == 'For Design Win'){
                        configuration.Apttus_Proposal__Approval_Stage__c = apprlStage.get('Process Flow Accepted DW').Value__c;
                    }
                    else if(configuration.Purpose_of_the_Configuration__c == 'Preliminary'){
                        configuration.Apttus_Proposal__Approval_Stage__c = apprlStage.get('Process Flow Accepted for Prelim').Value__c;
                    }
                }
                configuration.Multi_Source_Tapeout_Approval_Stage__c = 'Process Flow Accepted';
        
                update configuration;
                PageReference pr;
                if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
                        pr = new PageReference('/GlobalfoundryView/'+ configuration.Id);
                }else{
                        pr = new PageReference('/'+ configuration.Id);
                }
                return pr;//Aagarwala code ends
          }
        else if(configuration != null && !errorFlag && entryFlag  
            && !acntFlag && !ptFlag && !posFlag && !initialised
            && !devFlag && !devFabFlag && !pocFlag && !ptnFlag
            && !deviceFlag 
            && !conIpStatus && !metalOptionFlag && !JustRetrofit){
            CPQConfigurationApprovalHelper cpqConAppHelper = new CPQConfigurationApprovalHelper();
            cpqConAppHelper.submitForApproval(configuration);
            initialised = true;
            PageReference pr;
            if(Apexpages.currentPage().getHeaders().get('Referer').contains('GlobalfoundryView')){
                pr = new PageReference('/GlobalfoundryView/'+ configuration.Id);
            }else{
                pr = new PageReference('/'+ configuration.Id);
            }
            return pr;
        }
     }catch(Exception e){
        handleException(e.getMessage(), e) ;    
   
        
        }
      return null;
    
    }
    
    public void handleException(String str,Exception E){
    
       
        if(str.contains('ALREADY_IN_PROCESS')){
        errorFlag = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Record is already in approval process. Please donot re-submit'));        
        }else if(str.contains('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY')){
             errorFlag = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot backtrack record for approval process, You donot have access to backtrack the record'));  
            CPConfigAppBckTrckController.postExceptionToCPQTeam(configuration, e);            
        }else if(str.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
             errorFlag = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Custom validation error. Please contact Adminstrator'));  
            CPConfigAppBckTrckController.postExceptionToCPQTeam(configuration, e);            
        }else{
        errorFlag = true;
        ErrorMessage = 'Configuration Error. A case has been created and CPQ Team has been notified.';
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ErrorMessage));
        CPConfigAppBckTrckController.postExceptionToCPQTeam(configuration, e);     
        } 
    
    
    
    
    
      }
}