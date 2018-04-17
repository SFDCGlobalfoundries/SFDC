/*    
  Author:  Cognizant Technology Solutions
  Description: This trigger is created to address case#00004487. This is used for deactivating all the Community_TC__c 
  records when a particular Community_TC__c record gets activated.  
  Create Date : 20/02/2014             
  Change History:
  Author: Sunita Char
  Modified Date:17th Oct 2014
  Reason: Case 35076 -This Class is created to resolve the soql limit issue while creating community terms and condition record
*/



trigger UpdateActiveFlagOnCommunityInsert on Community_TC__c (after insert,before update) {
    
    
    boolean deActFlag=false; //Variable to indicate deactivation of active TnC records
    
    boolean deActFlagduringupdate=false; //addfor Case 35076
   
    
   if(Trigger.IsInsert){//addfor Case 35076
   //commented for Case 35076
   // Map<Id,Contact> contactMap=new Map<Id,Contact>([select id,Accepted_TC_Version__c,Is_Comm_TC_Accepted__c from Contact where Is_Portal_User_Active__c=true LIMIT 50000]); // Map to store portal user contacts
    
    List<Contact> contactUpdateList = new List<Contact>();//Added for Case 35076
    
    //Added for Case 35076
     Map<Id,Contact> contactMap=new Map<Id,Contact>([select id,Accepted_TC_Version__c,Is_Comm_TC_Accepted__c from Contact where Is_Portal_User_Active__c=true and Is_Comm_TC_Accepted__c =true LIMIT 50000]); // Map to store portal user contacts
    
    /*** Fetching all Community_TC__c records those are active. Start ********/
        
    Map<Id,Community_TC__c> commntyTnCMap=new Map<Id,Community_TC__c>([SELECT id,Name,isActive__c
                                                                       FROM Community_TC__c 
                                                                       WHERE isActive__c=true and
                                                                       id not in :Trigger.newMap.keySet()
                                                                       LIMIT 50000]
                                                                      );
    
    /*********************************** End ***********************************/
        
        

       /*Code to check for any active TnC record and mark flag starts */ 
       
        for(Community_TC__c commntyTnCObj : Trigger.New)
        { 
             if(commntyTnCObj.isActive__c)
             {  
                 deActFlag=true;
                 break;
             }
        }
        
       /*Code to check for any active TnC record and mark flag ends*/ 
       
       
       /* Insert event begins*/

        // if(Trigger.IsInsert){//commented for Case 35076
         
                  
            // Code to deactivate all active Tnc records 
            system.debug('enter deActFlag'+deActFlag);
            
            if(deActFlag)
            {
                    for(Community_TC__c commntyTnCObj : commntyTnCMap.values()){
                        commntyTnCObj.isActive__c = false;
                } 
            }
            // Code to uncheck contact's latest TnC acceptance on creation of new TnC 
/*------------------commented for case 35076 start---------------------------------------*/            
           /* for(Contact cntObj : contactMap.values())
                    cntObj.Is_Comm_TC_Accepted__c =false;*/
/*------------------commented for case 35076 end---------------------------------------*/    
                                     
               try{
               
               // Update active TnC records
               
                       if(deActFlag)
                       {
                           CommunitiesLandingController.IsInsertEvent=true;
                           update commntyTnCMap.values();
                       }
                               
                  }catch(Exception e){
        
                       for(Community_TC__c commntyTnCObj : Trigger.New){
                           commntyTnCObj.addError('Error occurred while inserting Community record'+e);
                
                       }
                  }

/*--------------commented for Case 35076 start--------------------------------------------------*/      
                 /*   try{
                       
                        // Update Contact records
                        
                        update contactMap.values();
                        
                    }catch(Exception e){
                    
                        for(Contact cntObj : contactMap.values()){
                            cntObj.addError('Error occurred while updating Contact record'+e);
                        }
                    }*/
/*--------------commented for Case 35076 end--------------------------------------------------*/ 

                  
/*------------------added for case 35076 start---------------------------------------*/    
      
               if(deActFlag==true)
               {
                  if(contactMap!=null && !contactMap.isEmpty())
                  {
                    clsCommunityTCAcceptedUpdateOnContact.updateCheckbox(contactMap.keyset());
                  } 
                }  
                
/*------------------added for case 35076 end---------------------------------------*/                           
          
       }  
         /* Insert event ends*/
    
        /**Update event starts**/

        if(Trigger.IsUpdate){
/*--------------------------added on Case 35076 start---------------------------------------------------*/
     
    List<Contact> contactUpdateList = new List<Contact>();
     Map<Id,Contact> contactMap=new Map<Id,Contact>([select id,Accepted_TC_Version__c,Is_Comm_TC_Accepted__c from Contact where Is_Portal_User_Active__c=true and Is_Comm_TC_Accepted__c =true LIMIT 50000]); // Map to store portal user contacts

    /*** Fetching all Community_TC__c records those are active. Start ********/
        
   
   /*Code to check for any active TnC record and mark flag starts */ 
       
        for(Community_TC__c commntyTnCObj : Trigger.New)
        { 
             if(commntyTnCObj.isActive__c)
             {  
                 deActFlagduringupdate=true;
                 break;
             }
        }
        
       /*Code to check for any active TnC record and mark flag ends*/   
       if(deActFlagduringupdate==true)
       {
          if(contactMap!=null && !contactMap.isEmpty())
          {
            
            clsCommunityTCAcceptedUpdateOnContact.updateCheckbox(contactMap.keyset());
          } 
        }          
  
/*-------------------------added on Case 35076 end---------------------------------------------------*/        

        
            // Check for recursive condition in update event
            
            if(!CommunitiesLandingController.IsInsertEvent && CommunitiesLandingController.runOnce()){
                 
                List<Community_TC__c >   latestComTnCList   =[SELECT id,Name,isActive__c
                                                               FROM Community_TC__c 
                                                               ORDER BY CreatedDate DESC
                                                               LIMIT 50000]; // List to contain all TnC reocrds sorted by creation date
                List<Community_TC__c >   comTCchangeList = new List<Community_TC__c >(); // List to contain active TnC records
                Id currentVersionId; // Variable to hold current TnC record Id
                
                                            
                // Fetch current TnC version Id
                                                       
                for(Community_TC__c comObj : Trigger.New)
                {   
                    currentVersionId=comObj.Id;
                    break;    
                }
            
               /*Code to check for any active TnC record and mark flag starts */ 

            
                for(Community_TC__c  comObj : latestComTnCList)
                {
                    if (comObj.Id!=currentVersionId && comObj.isActive__c)
                    {   comTCchangeList.add(comObj);
                        deActFlag=true;
                        
                    }
                }
               
               /*Code to check for any active TnC record and mark flag ends*/ 


                if(!latestComTnCList.isEmpty())
                {
                    // Check if updated TnC record is the last created record
                    
                    if(latestComTnCList.get(0).Id!=currentVersionId)
                    {
                        for(Community_TC__c commntyTnCObj : Trigger.New)
                            commntyTnCObj.addError('You cannot activate previous TNC');
                    }
                    else
                    {   
                        if(deActFlag)
                        {   
                            // Code to deactivate all active Tnc records 
 
                            for(Community_TC__c commntyTnCObj : comTCchangeList)
                                commntyTnCObj.isActive__c = false;
                                
                            try{
                                  // Update TnC records
                                   
                                   update comTCchangeList;
                                       
                               }catch(Exception e){
        
                                    for(Community_TC__c commntyTnCObj : Trigger.New){
                                        commntyTnCObj.addError('Error occurred while updating Community record'+e);
                                    }
                               }
                        }     
                          
                     }
                  
                  }
   
 
            
           
        }
        
        }
        
        /**Update event ends**/
        
   
    }