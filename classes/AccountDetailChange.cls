/*
    Author: Ariz Solito
    Description: Apex class for integration AIA when certain Account, Account Team Proxy or Contact fields are changed
    History: 
    Asolito      17/04/2013    - Apex code created
    Asolito      23/05/2013    - Added integration user check
    Nbustillos   27/06/2013    - Added limit on setPrimaryAddress() method when retrieving default primary contact. 
*/
public without sharing class AccountDetailChange { 
    public static Boolean hasRun = false;
    
    //Method will update the primary contact of an account if its null
    public static void setPrimaryAddress(List<String> accountIds){
        List<Account> updateAccounts = new List<Account>();
        
        for(Account currRec: [SELECT primary_contact__c,
                                     (SELECT id FROM Contacts ORDER BY createdDate limit 1)
                                FROM Account WHERE id IN: accountIds]){
            for(Contact c: currRec.contacts){
                if(currRec.primary_contact__c == null){
                    currRec.primary_contact__c = c.id;
                    updateAccounts.add(currRec);
                    break;
                }
            }                           
        }       
        
        System.debug(updateAccounts);
        
        update updateAccounts;
    }   
    
    //Method will send Account to ERP
    //this will call a real-time callout and suitable for VF    
    public static String send2(sObject rec){
        Account currRec = getDetails(rec);
        if(currRec <> null){
            if(((currRec.stage__c == 'Authorized' || currRec.stage__c == 'Inactive')  && 
                getERPSendStatus('AIA_TO_ERP_ENDPOINT_FLAG') == 'ON' && !isIntegrationUser(userInfo.getUserId())) ||
                Test.isRunningTest()){ 
                //Only send if Contact record is primary contact of the account                                 
                if(rec instanceOf Contact){
                    if(currRec.primary_contact__c == rec.id){                                                                               
                        return AIAConnector.sendAccount(buildXML(currRec));
                    }
                } else {
                    return AIAConnector.sendAccount(buildXML(currRec));
                }
            }
        }   
        return null;
    }
    
    //Method will send Account to ERP 
    //this will call a future callout and suitable for triggers
    public static void send(sObject rec){
        Account currRec = getDetails(rec);
        if(currRec <> null){
            if(((currRec.stage__c == 'Authorized' || currRec.stage__c == 'Inactive') && 
                getERPSendStatus('AIA_TO_ERP_ENDPOINT_FLAG') == 'ON' && !isIntegrationUser(userInfo.getUserId())) ||
                Test.isRunningTest()){ 
                //Only send if Contact record is primary contact of the account                                 
                if(rec instanceOf Contact){
                    if(currRec.primary_contact__c == rec.id){                                                                               
                        AIAConnector.sendAccount(currRec.id,buildXML(currRec));
                    }
                } else {
                    AIAConnector.sendAccount(currRec.id,buildXML(currRec));
                }
                
                //flag will stop the trigger from calling the callout again
                AccountDetailChange.hasRun = true;
            }
        }       
    }
            
    //Method will send the account details to AIA
    public static Account getDetails(sObject rec){
        String accountId;
        
        if(rec instanceOf Account){
            accountId = ((Account)rec).id;
        } else if(rec instanceOf Contact){
            accountId = ((Contact)rec).accountid;
        } else if(rec instanceOf Account_Team_Proxy__c){
            accountId = ((Account_Team_Proxy__c)rec).account__c;
        }                   
        
        for(Account currRec: [SELECT id,name,primary_contact_first_name__c,primary_contact_last_name__c,primary_contact_phone__c,
                                     primary_contact_email__c,primary_contact__r.name,customer_number__c,duns__c,sales_territory__c,
                                     financial_territory__c,short_name__c,region__c,early_ship_days__c,hard_peg_flag__c,Merged_SAP_Sold_To_s__c,
                                     bill_to_city__c,bill_to_state__c,bill_to_address_1__c,bill_to_address_2__c,
                                     bill_to_address_3__c,bill_to_address_4__c,bill_to_country__c,bill_to_postal_zip_code__c,
                                     organization_unit__c,numberOfEmployees,stage__c,overshipment_percent__c,erp_status_message__c,
                                     bill_to_location__c,primary_contact__c,tax_number__c,tax_type__c,Distributor__c,SAP_Account_Number__c,Authorized_for_ASIC_business__c,
                                    (SELECT user__r.name,user__r.hcm_employee_id__c,siebel_role__c,siebel_sequence__c
                                       FROM Account_Team_Proxy__r),
                                    (SELECT Address_1__c,Address_2__c,Address_3__c,Address_4__c,Bill_To_Address_Number__c,City__c,Country__c,
                                        Location__c,Is_Primary_Address__c,Postal_Zip_Code__c,State__c,Status__c,Type__c FROM Account_Addresses__r
                                        WHERE Type__c = 'Bill To Address' and Status__c in ('Approved','Inactive'))
                                FROM Account 
                                WHERE id = :accountId]){
            return currRec;         
        }       
        return null;
    }
    
    //Method will build the XML of the HTTP request
    private static String buildXML(Account a){
        String result;      
        Xmlstreamwriter xmlW = new Xmlstreamwriter();
        
        xmlW.writeStartDocument('utf-8','1.0');
            xmlW.writeStartElement('soap','Envelope', 'http://schemas.xmlsoap.org/soap/envelope/');
                xmlW.writeNamespace('soap','http://schemas.xmlsoap.org/soap/envelope/');                                                
                xmlW.writeStartElement('soap','Body', 'http://www.siebel.com/xml/GF ERP Account Rq');
                xmlW.writeNamespace('ns1','http://www.siebel.com/xml/GF%20ERP%20Account%20Rq');                                                             
                    xmlW.writeStartElement('ns1','ListOfGfErpAccountRq', '');
                        xmlW.writeStartElement('ns1','Account','');
                            xmlW.writeStartElement('ns1','AccountStatus','');
                                if(a.stage__c == 'Inactive'){
                                    xmlW.writeCharacters('Inactive');   
                                } else {
                                    xmlW.writeCharacters('Active');
                                }                               
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','CSN','');                             
                                xmlW.writeCharacters(getVal(a.customer_number__c));                                                     
                            xmlW.writeEndElement();                                                 
                            xmlW.writeStartElement('ns1','DUNSNumber','');
                                xmlW.writeCharacters(getVal(a.duns__c));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','GFAccountTerritory','');
                                xmlW.writeCharacters(getVal(a.sales_territory__c));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','GFFinancialTerritory','');
                                xmlW.writeCharacters(getVal(a.financial_territory__c));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','GFShortName','');
                                xmlW.writeCharacters(getVal(a.short_name__c));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','Name','');
                                xmlW.writeCharacters(getVal(a.name));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','Region','');
                                xmlW.writeCharacters(getVal(a.region__c));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','GFEarlyShipDays','');                                                         
                                xmlW.writeCharacters(getVal(a.early_ship_days__c));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','GFHardPegFlag','');
                                xmlW.writeCharacters(getVal(
                                    a.hard_peg_flag__c == 'Hard Peg' ? 'Y' : 'N'
                                ));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','GFOvershipmentPercent','');
                                xmlW.writeCharacters(getVal(a.overshipment_percent__c));
                            xmlW.writeEndElement();
                            /*xmlW.writeStartElement('ns1','GFBillToLocationName','');
                                xmlW.writeCharacters(getVal(a.bill_to_location__c));
                            xmlW.writeEndElement();*/
                            //Added  by Naman : To support multiple bill to address
                            xmlW.writeStartElement('ns1','SAPAccountId','');
                            if(a.Merged_SAP_Sold_To_s__c != null)
                                xmlW.writeCharacters(getVal(a.SAP_Account_Number__c+';'+getVal(a.Merged_SAP_Sold_To_s__c)));
                            else
                                xmlW.writeCharacters(getVal(a.SAP_Account_Number__c));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','IsDistributor','');
                                xmlW.writeCharacters(getVal(a.Distributor__c));
                            xmlW.writeEndElement();
                            xmlW.writeStartElement('ns1','AuthorizedForASIC','');
                                xmlW.writeCharacters(getVal(a.Authorized_for_ASIC_business__c));
                            xmlW.writeEndElement();
                            
                            //Address Information
                            xmlW.writeStartElement('ns1','ListOfAccount_BusinessAddress','');
                                for(Account_Address__c addr: a.Account_Addresses__r){
                                xmlW.writeStartElement('ns1','Account_BusinessAddress','');
                                        xmlW.writeStartElement('ns1','GFBillToLocationName','');
                                            xmlW.writeCharacters(getVal(addr.Location__c));
                                        xmlW.writeEndElement();
                                        xmlW.writeStartElement('ns1','BillToAddressNumber','');
                                            xmlW.writeCharacters(getVal(addr.Bill_To_Address_Number__c));
                                        xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','City','');
                                            xmlW.writeCharacters(getVal(addr.City__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','PostalCode','');
                                            xmlW.writeCharacters(getVal(addr.Postal_Zip_Code__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','State','');
                                            xmlW.writeCharacters(getVal(addr.State__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','StreetAddress','');
                                            xmlW.writeCharacters(getVal(addr.Address_1__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','StreetAddress2','');
                                            xmlW.writeCharacters(getVal(addr.Address_2__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','GFAddressLine3','');
                                            xmlW.writeCharacters(getVal(addr.Address_3__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','GFAddressLine4','');
                                            xmlW.writeCharacters(getVal(addr.Address_4__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','GFAddressType','');
                                        xmlW.writeCharacters(getVal('Bill To'));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','GFPprovince','');
                                        xmlW.writeCharacters(getVal('TBD'));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','Country','');
                                            xmlW.writeCharacters(getTransformedCountryName(getVal(addr.Country__c)));
                                        xmlW.writeEndElement();
                                        xmlW.writeStartElement('ns1','IsPrimary','');
                                            xmlW.writeCharacters(getTransformedCountryName(getVal(addr.Is_Primary_Address__c)));
                                        xmlW.writeEndElement();
                                        xmlW.writeStartElement('ns1','AddresssStatus','');
                                            xmlW.writeCharacters(getTransformedCountryName(getVal(addr.status__c)));
                                        xmlW.writeEndElement();
                                    xmlW.writeEndElement();
                                }
                            xmlW.writeEndElement();
                            //End of Address Information Part
                            
                            xmlW.writeStartElement('ns1','ListOfAccount_GFAccountTaxNumber','');
                                xmlW.writeStartElement('ns1','Account_GFAccountTaxNumber','');
                                    xmlW.writeStartElement('ns1','GFAccountTaxNumber','');
                                        xmlW.writeCharacters(getVal(a.tax_number__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','GFAccountTaxNumberType','');
                                        xmlW.writeCharacters(getVal(a.tax_type__c));
                                    xmlW.writeEndElement();     
                                xmlW.writeEndElement(); 
                            xmlW.writeEndElement();
                            
                            //Organization Units 
                           /* if(UtilsString.isNotBlank(a.Organization_Unit__c)){                                                                
                                String afterRemoval = a.Organization_Unit__c.remove('GF Burlington OU');                                
                                afterRemoval = afterRemoval.remove('GF East Fishkill OU');                                
                                afterRemoval = afterRemoval.trim();                                                               
                                if(afterRemoval != ''){
                                    String[] OU = afterRemoval.split('\\;');                                                                
                                    if(OU.size() > 0){
                                        xmlW.writeStartElement('ns1','ListOfAccount_GFOrganizationUnit','');
                                        for(String o: OU){
                                                xmlW.writeStartElement('ns1','Account_GFOrganizationUnit','');
                                                    xmlW.writeStartElement('ns1','GFOrganizationUnit','');
                                                        xmlW.writeCharacters(getTransformedOU(getVal(o)));
                                                    xmlW.writeEndElement();
                                                xmlW.writeEndElement();
                                       }
                                       xmlW.writeEndElement();
                                   }  
                               }                            
                            }      */                                                                            
                            xmlW.writeStartElement('ns1','ListOfAccount_GFOrganizationUnit','');
                                if(UtilsString.isNotBlank(a.Organization_Unit__c)){ 
                                    String[] OU = a.Organization_Unit__c.split('\\;');
                                    for(String o: OU){
                                        xmlW.writeStartElement('ns1','Account_GFOrganizationUnit','');
                                            xmlW.writeStartElement('ns1','GFOrganizationUnit','');
                                                xmlW.writeCharacters(getTransformedOU(getVal(o)));
                                            xmlW.writeEndElement();
                                        xmlW.writeEndElement();
                                    }
                                } 
                            xmlW.writeEndElement();
                            //End of Organization Unit Part
                            
                            //Primary Contact
                            xmlW.writeStartElement('ns1','ListOfAccount_PrimaryContact','');
                                xmlW.writeStartElement('ns1','Account_PrimaryContact','');
                                    xmlW.writeAttribute(null,null,'IsPrimaryMVG','Y');
                                    xmlW.writeStartElement('ns1','GFPrimaryContactEmail','');
                                        xmlW.writeCharacters(getVal(a.primary_contact_email__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','PrimaryContactFirstName','');
                                        xmlW.writeCharacters(getVal(a.primary_contact_first_name__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','PrimaryContactLastName','');
                                        xmlW.writeCharacters(getVal(a.primary_contact_last_name__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','PrimaryContactName','');
                                        xmlW.writeCharacters(getVal(a.primary_contact__r.name));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','PrimaryContactWorkPhone','');
                                        xmlW.writeCharacters(getVal(a.primary_contact_phone__c));
                                    xmlW.writeEndElement();
                                xmlW.writeEndElement();
                            xmlW.writeEndElement();
                            //End of Primary Contact Part
                            
                            //Account Team Members
                            xmlW.writeStartElement('ns1','ListOfPosition','');
                                for(Account_Team_Proxy__c p: a.Account_Team_Proxy__r){
                                xmlW.writeStartElement('ns1','Position','');
                                    xmlW.writeStartElement('ns1','ActiveEmployeeNumber','');
                                        xmlW.writeCharacters(getVal(p.user__r.hcm_employee_id__c));
                                    xmlW.writeEndElement();
                                    xmlW.writeStartElement('ns1','ListOfGfAccountPositionRole','');
                                        xmlW.writeStartElement('ns1','GfAccountPositionRole','');
                                            xmlW.writeStartElement('ns1','Role','');
                                                xmlW.writeCharacters(getVal(p.siebel_role__c));
                                            xmlW.writeEndElement();
                                            xmlW.writeStartElement('ns1','SequenceNo','');
                                                xmlW.writeCharacters(getVal(p.siebel_sequence__c));
                                            xmlW.writeEndElement();
                                        xmlW.writeEndElement();                                     
                                    xmlW.writeEndElement();
                                xmlW.writeEndElement();
                                }
                            xmlW.writeEndElement();
                            //End Account Team Members  
                                                    
                        xmlW.writeEndElement();
                    xmlW.writeEndElement();
                xmlW.writeEndElement();
            xmlW.writeEndElement();             
        xmlW.writeEndDocument();
        
        result = xmlW.getXmlString();
        xmlW.close();
        system.debug('result--->'+result);        
        return result;
    }
    
    //Method will check if context user is bypassed or not
    private static Boolean isIntegrationUser(String userId){        
        IntegrationUsers__c setting = IntegrationUsers__c.getInstance(userId);      
        //we need to check for a null value on the field, the setting object is always not null.
        if(setting <> null){
            return setting.is_integration_user__c;
        }  
        return false;     
    }
    
    //Method will get the transformed value of the country
    private static String getTransformedCountryName(String key){
        //custom setting name limit is 35 characters
        if(UtilsString.isNotBlank(key) && key.length() < 35){       
            Account_Corporate_Country_Transformation__c setting = Account_Corporate_Country_Transformation__c.getInstance(key);
            //we need to check for a null value on the field, the setting object is always not null.
            if(setting <> null){
                if(setting.value__c <> null){
                    return setting.value__c;
                }
            } 
        } 
        return key;     
    }    
    
    //Method will get the transformed value of the organization unit
    private static String getTransformedOU(String key){
        //custom setting name limit is 35 characters
        if(UtilsString.isNotBlank(key) && key.length() < 35){
            Account_Organization_Unit_Transformation__c setting = Account_Organization_Unit_Transformation__c.getInstance(key);
            //we need to check for a null value on the field, the setting object is always not null.
            if(setting <> null){
                if(setting.value__c <> null){
                    return setting.value__c;
                }
            }  
        }
        return key;     
    }
    
    //Method will get the ERP Flag Status
    private static String getERPSendStatus(String key){
        Environment_Variable__c setting = Environment_Variable__c.getInstance(key);
        //we need to check for a null value on the field, the setting object is always not null.
        if(setting <> null){
            if(setting.value__c <> null){
                return setting.value__c.toUpperCase();
            }
        }  
        return key;     
    }
    
    //Method will set the value of the field to blank if its null
    private static String getVal(Object val){
        if(UtilsString.isNotBlank(val)){                    
            return String.valueOf(val);
        }                               
        return '';
    }
}