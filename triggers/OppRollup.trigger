/*
    Author: 
    Description: This is the trigger for Manufacturing Lot object. 
    History:
        Ykumar 2002014    - Created.
        Ykumar 07042014    - Modify below sales order number condition
*/ 
trigger OppRollup on Manufacturing_Lot__c (before insert, before update) 
{
    if(trigger.isbefore) 
    {
        
        Map<string,string> mapRisk = new Map<string,string>();
        for(Risk_Start_System__c Risk : [select id,name  from Risk_Start_System__c ])
        {
            mapRisk.put(Risk.name,Risk.ID);
            System.debug('====mapRisk:'+mapRisk);
        }
        
        for(Manufacturing_Lot__c omanu: trigger.new)
        {
           if(omanu.Active_Flag__c == true && omanu.Step_ID__c !=null)
           {
                if(omanu.Sales_Order_Number__c !=null)
                {
                    string salesordernum=omanu.Sales_Order_Number__c;
                    salesordernum=salesordernum.toUpperCase();
                    String spcial = '~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|:|::|RSF|RSF-';
                    for(integer i=0; i<spcial.split('|').size(); i++){
                        salesordernum= salesordernum.replace(spcial.split('|')[i],'');
                        System.debug('=======salesordernum1:'+salesordernum);  
                    }
                   
                    if(salesordernum.contains('RSF-') && salesordernum.length()>=16  )
                    {
                           salesordernum=salesordernum.SubString(0,16); 
                          // trigger.new[0].addError(salesordernum);
                          
                          System.debug('=======salesordernum2:'+salesordernum); 
                           
                    }
                    else
                    {
                        salesordernum='RSF-'+salesordernum;
                       // trigger.new[0].addError(salesordernum);
                        if(salesordernum.length()>=16)
                        {
                            salesordernum=salesordernum.SubString(0,16); 
                            
                        }
                    
                    }
                    
                    
                    
                    if(mapRisk.containskey(salesordernum))
                    {             
                        
                        omanu.Risk_Start__c=mapRisk.get(salesordernum);
                      
                    }else
                    {
                        omanu.Risk_Start__c=null;
                    }
                    
                }
             }
        }
    }
}