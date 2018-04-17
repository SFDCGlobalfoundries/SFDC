/*
Type Name: ClsCheckAccountValidation
Author: IBM
Created Date: 14-Aug-2013
Reason: This class is used for validate account
Change History:Supplier Changes to bypass the adress validation for supplier account only.
Author: Mahendra
Modified Date: 12/17/2013
Reason: Supplier Changes to bypass the adress validation for supplier account only.
Change History:
Author: 
Modified Date: 
Reason: 
……..
……..
*/

public class ClsCheckAccountValidation{

public static boolean Flag=false;

//public static  void checkUpdateAccountValidation
    public static  void checkUpdateAccountValidation(Map<Id,Account> accountsMap,boolean insertFlag,boolean updateflag)
    {
        //Supplier Change001-Start
        //Bypassing Account Address Validation for Supplier Accounts
        string accType;
        list<Recordtype> accRecType=new list<recordtype>([select id from recordtype where sobjecttype='Account' and developername='Suppliers']);
        if(accRecType!=null && accRecType.size()>0)
            accType=accRecType[0].id;
        //Supplier Change001-End
        List<Account> accountList = new List<Account>();   
        accountList=accountsMap.values();
        
        
        for(Account objAccount :  accountList)
        {
            //Supplier Change002-Start
           if(objAccount.recordtypeid!=accType){
           //Supplier Change002-End
           system.debug('AAAAAAAAAAAAAAAAAA'+insertFlag+updateflag); 
           if((objAccount.Bill_To_Address_1__c ==null || objAccount.Bill_To_City__c==null || objAccount.Bill_To_Country__c==null ) && ( objAccount.Is_Lead_Source__c) && (objAccount.Copy_Address__c==false)&& (insertFlag))
           {
               system.debug('AAAAAAAAAAAAAAAAAA'); 
               Error_Codes__c Bill_To_Address_Required= Error_Codes__c.getInstance('Bill_To_Address_Required');
             
              //objAccount.addError(Bill_To_Address_Required.message__c);
               
               
           }
           else if((objAccount.Bill_To_Address_1__c ==null || objAccount.Bill_To_City__c==null || objAccount.Bill_To_Country__c==null )  && (objAccount.Copy_Address__c==false)&&(updateflag))
           {
               
               Error_Codes__c Bill_To_Address_Required= Error_Codes__c.getInstance('Bill_To_Address_Required');
              // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Bill_To_Address_Required.message__c));
              objAccount.addError(Bill_To_Address_Required.message__c);
               
               
           }
           }
        }
    
    }


}