trigger SFDCProjectBeforeDelete on SFDC_Project__c (before delete) 
{
    List<SFDC_Project_Stage__c> dlist = new List<SFDC_Project_Stage__c>();
    List<SFDC_Project_Stage__c> tlist = null;
    List<SFDC_Project_Status__c> dslist = new List<SFDC_Project_Status__c>();
    List<SFDC_Project_Status__c> tslist = null;
    List<SFDC_Project_Issue__c> dilist = new List<SFDC_Project_Issue__c>();
    List<SFDC_Project_Issue__c> tilist = null;
    List<SFDC_Project_Member__c> dmlist = new List<SFDC_Project_Member__c>();
    List<SFDC_Project_Member__c> tmlist = null;
   // List<Change_Request__c> dcrlist = new List<Change_Request__c>();
   // List<Change_Request__c> tcrlist = null;
    
     
    for(SFDC_Project__c proj:Trigger.OLD)
    {
       tlist = [SELECT id from SFDC_Project_Stage__c where SFDC_Project__c = :proj.id];
       tslist = [SELECT id from SFDC_Project_Status__c where Project__c = :proj.id];
       tilist = [SELECT id from SFDC_Project_Issue__c where SFDC_Project__c = :proj.id];
       tmlist = [SELECT id from SFDC_Project_Member__c where SFDC_Project__c = :proj.id];
      // tcrlist = [SELECT id from Change_Request__c where SFDC_Project__c = :proj.id];
       for(SFDC_Project_Stage__c s:tlist)
       {
          dlist.add(s);
       }
       for(SFDC_Project_Status__c r:tslist)
       {
          dslist.add(r);
       }
       for(SFDC_Project_Issue__c r:tilist)
       {
          dilist.add(r);
       }
       for(SFDC_Project_Member__c r:tmlist)
       {
          dmlist.add(r);
       }
      // for(Change_Request__c r:tcrlist)
      // {
     //     dcrlist.add(r);
    //   }
       
    }
    
    delete dlist;
    delete dslist;
    delete dilist;
    delete dmlist;
  //  delete dcrlist;
}