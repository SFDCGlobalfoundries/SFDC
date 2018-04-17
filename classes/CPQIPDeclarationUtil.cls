/**********************************************************************************************************************************
Class:         CPQIPDeclarationUtil
-----------------------------------------------------------------------------------------------------------------------------------
Author:        Prosenjit Saha
Created Date:  18/11/2014
Reason:        Utility class for PopulateAndUpdateFields: all IP Declaration related functions
Change History: 1. Arun 4th Dec,2014
                Reason: added a Method to populate a value of configuration in the object - IP Declaration Form
                2.Arun 15th Dec,2014
                Reason: Logic has added in the method to populate a value for Revision Required. 
                3. PS 12232014
                Reason: Send email to external users   
                4. PS 01122014
                Reason: IPDeclarationLinkConfiguration method added to handle the IP Declaration and configuration link 
                        on before insert event.    
***********************************************************************************************************************************/

public class CPQIPDeclarationUtil{
    
    public static Map<string,Boolean>  MapIPIDvsReqfromConfig = new Map<String,boolean>();
    
    /* Method to populate a value of configuration & Revision Required in the object - IP Declaration Form.   
    Method will be called by a trigger PopulateAndUpdateFields on after insert & after update */
    
    public void PopulateConfiguration(  Map<Id, Apttus_Proposal__Proposal__c> ProposalNew,
                                        Map<Id, Apttus_Proposal__Proposal__c> ProposalOld,
                                        Boolean isInsert,
                                        Boolean isUpdate )
    {
   
        //The list 'lstIpconfig' holds the records of IpDeclarationForm which related to the devices.
        List<IP_Declaration_Form__c >  lstIpconfig = [SELECT    id 
                                                                , name
                                                                , Configuration__c
                                                                , Is_Config_Used__c
                                                                , Revision_Required__c
                                                                , Device__c
                                                                , Status__c
                                                                , Device__r.IP_Declaration_User_Ids__c 
                                                                , Configuration__r.name
                                                      FROM      IP_Declaration_Form__c 
                                                      WHERE     Device__c 
                                                      IN        : ProposalNew.keyset()];                       
        
        //This List 'setIpDec1' holds the record of IpDeclarationForm which needs to be updated.
        List<IP_Declaration_Form__c> setIpDec1=new List<IP_Declaration_Form__c>();

               
        for(IP_Declaration_Form__c IpDecConfig : lstIpconfig )
        {
            setIpDec1 = new list<IP_Declaration_Form__c>();
                  
                if((ProposalNew.get(IpDecConfig.device__c).APTPS_Primary__c == TRUE )) 
                {                 
                    IpDecConfig.Configuration__c=ProposalNew.get(IpDecConfig .Device__c).id;
                } 
                
                //This loop will be executed when the IPs__c field value get changed in the configuration record && Is_Config_Used__c = True in IpDeclarationForm.
                if (isUpdate 
                    && ProposalNew.get(IpDecConfig.Device__c).IPs__c !=  ProposalOld.get(IpDecConfig .Device__c).IPs__c  
                    && IpDecConfig.Is_Config_Used__c == True
                    ||
                    isUpdate
                    && ProposalNew.get(IpDecConfig.Device__c). APTPS_Primary__c 
                    && ProposalNew.get(IpDecConfig.Device__c). APTPS_Primary__c != ProposalOld.get(IpDecConfig.Device__c). APTPS_Primary__c
                    && IpDecConfig.Is_Config_Used__c
                    )
                {
                    IpDecConfig.Revision_Required__c = 'TRUE';
                    IpDecConfig.Status__c = 'Pending Resubmission';
                    
                    //PS 12232014: if mail is already sent to external users then resend mails on update. 
                    //IP_Declaration_User_Ids__c contains all the userId of external users.  
                    if(IpDecConfig.Device__r.IP_Declaration_User_Ids__c != NULL){
                        //calling sendEmailIPDecUpdate method. parameter: all the external user IDs
                        sendEmailIPDecUpdate(   IpDecConfig.Device__r.IP_Declaration_User_Ids__c
                                                , IpDecConfig
                                                , ProposalNew.get(IpDecConfig.device__c).LastModifiedById);
                    }
                } 
                  
            setIpDec1.add(IpDecConfig);     
            
        }
        
        //Dml operation execution.
        try
        {
            update setIpDec1;
        }
        catch(exception ex)
        {
            system.debug('Error::'+ex);
        }   
    }
    
    /*
        Method Name: sendEmailIPDecUpdate
        Parameter:   String
                     ";" Separated userIds 
        Reason:      This method handles email trigger functionality for updated IPs. 
    */
    public void sendEmailIPDecUpdate (String ExtUserContactIDs 
                                      , IP_Declaration_Form__c IpDecConfig
                                      , ID lastModifiedbyUserID ){
        Set<String> IPDecExtUserIDs = new Set<String>();    
        List<String> extuseremail = new List<String>();
        List<String> ccemail = new List<String> ();
        Integer recipientNum = 0;
        list<Messaging.SingleEmailMessage> msgList = new list<Messaging.SingleEmailMessage>();
        Map<String,String> MergeFieldMap = new Map<String,String>();
        
        
        IPDecExtUserIDs.addAll(ExtUserContactIDs.split(';'));
        IPDecExtUserIDs.add(lastModifiedbyUserID);
        // MergeFieldMap.put( '&&&IPDeclaration&&&', IpDecConfig.name );
        MergeFieldMap.put('###ConfigName###', IpDecConfig.Configuration__r.name);
        MergeFieldMap.put( '###IPDEC###',  Label.CPQ_Customer_Domain_URL + IpDecConfig.id  );
        
        //send email block
        if(IPDecExtUserIDs.size() > 0){  
            EmailTemplate IPDecTemplate = [SELECT id from EmailTemplate where name = 'Configuration: IP Declaration form modification request'];   
            for(User extUser: [SELECT   id
                                        ,ContactId
                                        ,email 
                               FROM     User
                               where    ID
                               IN       :IPDecExtUserIDs    ]){
                if  (extUser.id != lastModifiedbyUserID)    {
                    extuseremail.add(extUser.email);
                }       
                else{
                    ccemail.add(extUser.email);
                }
            }  
            //ExposeDeviceToCustomer exposedevice = new ExposeDeviceToCustomer();  
            if(!Test.isRunningTest()){                       
                Messaging.SingleEmailMessage message1 = EmailUtil.generateEmailTemplate(IPDecTemplate.id,
                                                                                        IpDecConfig.ID,
                                                                                        null,
                                                                                        extuseremail,
                                                                                        ccemail,
                                                                                        MergeFieldMap);
                message1.saveAsActivity = false;
                 
                msgList.add(message1);
                
                recipientNum = extuseremail.size() ;
             
                Messaging.reserveSingleEmailCapacity(recipientNum);    
                system.debug(msgList);             
                Messaging.sendEmail(msgList);
            }
        }
    }
    
    /*
        Method Name: IPDeclarationLinkConfiguration
        Parameter:   1st Parameter - List of the IP Declaration records. Newly triggered IP dec records at Before insert event
                     2nd Parameter - Boolean isInsert - trigger.isInsert.
                     3rd Parameter - Boolean isBefore - trigger.isBefore
        Reason:      This method Links configuration with the newly created IP declaration form. 
    */
    public static Map<id,id> IPDeclarationLinkConfiguration ( List<IP_Declaration_Form__c> IPDeclarationNew
                                                              , Boolean isInsert
                                                              , Boolean isBefore ){
        
        system.debug('[IP Debug]::-- '+IPDeclarationNew);
        if( isInsert 
            && isBefore
            && IPDeclarationNew.size()> 0 ){
            List<id> DeviceID2IPDecList = new List<id>();
            Map<id,id> FinalDevice2ConfigMap = new Map<id,id>();
            
            for(IP_Declaration_Form__c ipDec: IPDeclarationNew){
                DeviceID2IPDecList.add( ipDec.device__c);
            }
            
            for(Apttus_Proposal__Proposal__c config : [SELECT   Id
                                                                , Device__c 
                                                                , APTPS_Primary__c
                                                                , Device__r.Requested_from_Configuration__c
                                                       FROM     Apttus_Proposal__Proposal__c
                                                       WHERE    APTPS_Primary__c = true
                                                                AND
                                                                Device__c IN :DeviceID2IPDecList])  {
                FinalDevice2ConfigMap.put(  config.device__c
                                            , config.id);   
                MapIPIDvsReqfromConfig.put( config.device__c
                                            , config.Device__r.Requested_from_Configuration__c);
            }     
            return  FinalDevice2ConfigMap  ;    
        }   
        else{
            return null;
        }
    }
}