/* 
 Type Name: MDD_LoginController
 Author: JKTechnosoft
 Created Date: 13-July-2016
 Reason: MDD Part Search Login Page Controller.
 
 */
public without sharing class MDD_LoginController{
    public transient String PartNumber {get; set;}
    public transient Boolean isWafer {get; set;}
    public transient Boolean isModule {get; set;}
    public transient String packageType {get; set;}
    public transient Boolean showSerach {get; set;}
    public transient Boolean showSerachResult {get; set;}
    public transient List<Part__c> lstPart {get; set;}
    public transient String getPackageType {get; set;}
    public transient Boolean isInternalUser {get; set;}
    public User loginUser;
    public String gfView {get; set;}
    public MDD_LoginController(){
        showSerach = true;
        showSerachResult = false;
        isInternalUser = true;
        gfView = '';
        String str = URL.getSalesforceBaseUrl().getHost();
        if(str.contains('globalfoundryview')){
            isInternalUser = false;
            gfView = '/GlobalfoundryView';
        }
        loginUser = [Select Id,Name,contactId from User Where Id=: Userinfo.getUserid()];
    }
    public void search(){
        try{
            Set<String> stPart = new Set<String>();
            Set<Id> stPartId = new Set<Id>();
            Set<Id> acessId = new Set<Id>();
            Set<Id> userIds = new Set<Id>();
            MDDPartSearchSharing__c ms = MDDPartSearchSharing__c.getInstance('MDD Application');
            if(loginUser.contactId == null || !ms.Is_Active__c ){
                if(loginUser.contactId == null)
                isInternalUser = true;
                showSerach = false;
                showSerachResult = true;
                isInternalUser = true;
                String str1 = URL.getSalesforceBaseUrl().getHost();
                if(str1.contains('globalfoundryview') )
                    isInternalUser = false;
                String strPart = PartNumber+'%';
                String queryString = 'Select Id ,Name , Part_Number__c, Part_Family__c,Part_Type__c,Package_Type__c,MDPart_Family__c,LastModifiedDate from Part__c where  ';
                if(PartNumber != null && PartNumber != '' && PartNumber.contains(',')){
                    String[] arrval = PartNumber.split(',');
                    string Values = '';
                    for(string s : arrval){
                        if(Values == '')
                        Values = '\''+s+'\'';
                        else
                        Values += ','+'\''+s+'\'';
                    }
                    queryString += ' Part_Number__c IN ('+Values+')   AND';
                }else{
                    queryString += ' Part_Number__c Like \''+strPart+'\'   AND';
                }
                if(isWafer == true && isModule == false)
                queryString += ' Part_Type__c =\'Wafer\'     AND';
                if(isModule == true && isWafer == false)
                queryString += ' Part_Type__c =\'Module\'     AND';
                if(getPackageType != null && getPackageType != '')
                queryString += ' Package_Type__c =\''+getPackageType+'\'        ';
                queryString = queryString.substring(0,queryString.length()-5);
                queryString += ' ORDER BY LastModifiedDate DESC NULLS LAST';
                queryString += ' LIMIT 100';
                system.debug('query 1==>'+queryString);
                lstPart = Database.query(queryString);
            }
            else{
                Id contactId = [Select contactid from User where id =: Userinfo.getUserid()].contactId;
                Id AccID = [Select AccountID from Contact where id =: contactId].AccountId;
                List<Account_Part_Map__c> lstAccPart = [Select Id,Name,Account__c,Part__c from Account_Part_Map__c where Account__c =: AccID];
                for(Account_Part_Map__c acc : lstAccPart){
                   stPartId.add(acc.Part__c);
                }
                showSerach = false;
                showSerachResult = true;
                isInternalUser = true;
                String str2 = URL.getSalesforceBaseUrl().getHost();
                if(str2.contains('globalfoundryview'))
                    isInternalUser = false;
                String strPart = PartNumber+'%';
                String queryString = 'Select Id ,Name , Part_Number__c, Part_Family__c,Part_Type__c,Package_Type__c,MDPart_Family__c,LastModifiedDate from Part__c where Id IN: stPartId AND  ';//Id IN: acessId AND
                if(PartNumber != null && PartNumber != '' && PartNumber.contains(',')){
                    String[] arrval = PartNumber.split(',');
                    string Values = '';
                    for(string s : arrval){
                        if(Values == '')
                        Values = '\''+s+'\'';
                        else
                        Values += ','+'\''+s+'\'';
                    }
                    queryString += ' Part_Number__c IN ('+Values+')   AND';
                }else{
                    queryString += ' Part_Number__c Like \''+strPart+'\'   AND';
                }
                if(isWafer == true && isModule == false)
                queryString += ' Part_Type__c =\'Wafer\'     AND';
                if(isModule == true && isWafer == false)
                queryString += ' Part_Type__c =\'Module\'     AND';
                if(getPackageType != null && getPackageType != '')
                queryString += ' Package_Type__c =\''+getPackageType+'\'        ';
                queryString = queryString.substring(0,queryString.length()-5);
                queryString += ' ORDER BY LastModifiedDate DESC NULLS LAST';
                queryString += ' LIMIT 100';
                lstPart = Database.query(queryString);
            }
        }
        catch(Exception e){
            ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.FATAL, 'You do not have access to any MDDPart for your account!!'));

        }
    }
    public List<selectOption> getPackage(){ 
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('', 'Select a package Type'));
        options.add(new selectOption('', ''));
        options.add(new selectOption('', 'Flip Chip Ceramic'));
        options.add(new selectOption('CBGA', 'CBGA'));
        options.add(new selectOption('CCGA', 'CCGA'));
        options.add(new selectOption('CLGA', 'CLGA'));
        options.add(new selectOption('', ''));
        options.add(new selectOption('', 'Flip Chip Organic'));
        options.add(new selectOption('FC PBGA', 'FC PBGA'));
        options.add(new selectOption('FC PLGA', 'FC PLGA'));
        options.add(new selectOption('FCPBGA HP', 'FCPBGA HP'));
        return options;
    }
}