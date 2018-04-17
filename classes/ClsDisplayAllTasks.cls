/*
Type Name: ClsDisplayAllTasks 
Author: Cognizant
Created Date: 2-Dec-2013
Reason: This class is used to display Standard and Gf task in Home page
Change History:
Author: Cognizant
Modified Date: 
Reason: 
……..
……..
*/

public with sharing class ClsDisplayAllTasks {

  
     public List<SelectOption> filtervalues
    {
        get {
            filtervalues=new List<Selectoption>();
            filtervalues.add(new Selectoption('All','All')); 
            filtervalues.add(new Selectoption('Overdue','Overdue'));
            filtervalues.add(new Selectoption('Today','Today'));
            filtervalues.add(new Selectoption('Today+Overdue','Today+Overdue'));  
            filtervalues.add(new Selectoption('Tomorrow','Tomorrow'));   
            filtervalues.add(new Selectoption('Next 7 Days','Next 7 Days'));   
            filtervalues.add(new Selectoption('Next 7 Days+Overdue','Next 7 Days+Overdue'));  
            filtervalues.add(new Selectoption('This Month','This Month'));   
            filtervalues.add(new Selectoption('All Completed','All Completed')); 
            return filtervalues;
        }
        
        set;
    }
    
    
    public String SelectedValue { 
    
        get
        {
            if(SelectedValue==null)  SelectedValue = 'All' ;
         
            return SelectedValue ;  
        } 
    
        set; 
    }
    
    public boolean externaluser{get;set;}
    public boolean tasklistexist{get;set;}
    public String RecordsNotPresentMsg { get ; set ;}
    public boolean SelectedValueIsOverdue { get; set; }
   
    
    private String pageId;
    public boolean noNewbutton{ get; set; }
    public String y{get;set;}
  
    
    public List<GF_task__c> GFTaskList{get;set;}
    public List<Task> StdTaskList{get;set;}
    user objUser=new user();
    
    public with sharing class clsGFTask
    {   
       
        public Id TaskId{get;set;}
        public Id GFTaskId{get;set;}
        public String TaskSubject{get;set;}
        public String GFTaskSubject{get;set;}
        public Datetime GFTaskDate{get;set;}  
        public String GFTaskDateformat{get;set;}  
        public Datetime TaskDate{get;set;}
        public String TaskDateformat{get;set;}  
        public String GFTaskName{get;set;}  
        public Id TaskName{get;set;} 
        public String GFTaskRelatedTo{get;set;} 
        public String TaskRelatedTo{get;set;} 
        public boolean SelectedValueIsOverdue{get;set;}
        public String TaskStatus {get;set;} // Added by Krishanu on 3-Jan-2014 
        public String GFTaskStatus {get;set;} // Added By sunita on 03-Jan-2014
    }
    
    public List<clsGFTask> clsGFTaskList{get;set;} 
    
    public ClsDisplayAllTasks ()
    {
       externaluser=false;
        
       noNewbutton=false; 
       y=null;
       tasklistexist=false;
       RecordsNotPresentMsg =null;
       
       SelectedValue='All'; 
       
       objuser=[Select id,Name,ContactId from User where id=:UserInfo.getUserId()];
         if(objuser.ContactId!=null)
          {
          externaluser=true;
          }
      
        
     /*-----------------------added by cognizant 20/12/2013 ----------------------------------------------*/
         y=URL.getCurrentRequestUrl().toExternalForm();
         system.debug('y****'+y);
         if(y.Contains('globalfoundryview'))
         {
         system.debug('y****enter if');
         noNewbutton=True;
         }
         
         system.debug('noNewbutton***'+noNewbutton);
         
    /*------------------------------------------------------------------------------------------------------*/     
         totaltasklist();
       
    }  
    
   public PageReference totaltasklist() {
     pageId=apexpages.currentpage().getparameters().get('id');
     tasklistexist=false;
     
     RecordsNotPresentMsg =null;
     objuser=[Select id,Name,ContactId from User where id=:UserInfo.getUserId()];
     
      
     clsGFTaskList =new List<clsGFTask>();
      
     
   
       if(SelectedValue=='Overdue')
        {
          
              GFtaskList=[Select id,Name,Status__c,Subject__c,Due_Date__c,assignTo__c,Team_Room__c,Team_Room__r.Name from GF_Task__c where assignTo__c=:objuser.Id and Status__c!='Completed' and Due_Date__c<TODAY];
              if(objuser.ContactId==null)
              {
                  StdTaskList=[Select Id,Subject,Status,ActivityDate,WhoId,WhatId,What.Name from task where ownerid=:objuser.Id and Status!='Completed' and ActivityDate<TODAY];
                  }
        }
        else if(SelectedValue=='Today')
        {
              
              GFtaskList=[Select id,Name,Status__c,Subject__c,Due_Date__c,assignTo__c,Team_Room__c,Team_Room__r.Name from GF_Task__c where assignTo__c=:objuser.Id and Status__c!='Completed' and Due_Date__c=TODAY];
              
              system.debug('GFtaskList@@'+GFtaskList); 
              if(objuser.ContactId==null)
              {
                  
                  StdTaskList=[Select Id,Subject,Status,ActivityDate,WhoId,WhatId,What.Name from task where ownerid=:objuser.Id and Status!='Completed' and ActivityDate=TODAY];
                  
              }
        }
        else if(SelectedValue=='Today+Overdue')
        {
          
              GFtaskList=[Select id,Name,Subject__c,Status__c,Due_Date__c,assignTo__c,Team_Room__c,Team_Room__r.Name from GF_Task__c where assignTo__c=:objuser.Id and Status__c!='Completed' and Due_Date__c<=TODAY];
              if(objuser.ContactId==null)
              {
                  StdTaskList=[Select Id,Subject,Status,ActivityDate,WhoId,WhatId,What.Name from task where ownerid=:objuser.Id and Status!='Completed' and ActivityDate<=TODAY];
              }
        }
        else if(SelectedValue=='Tomorrow')
        {
          
              GFtaskList=[Select id,Name,Subject__c,Status__c,Due_Date__c,assignTo__c,Team_Room__c,Team_Room__r.Name from GF_Task__c where assignTo__c=:objuser.Id and Status__c!='Completed' and Due_Date__c=TOMORROW];
              if(objuser.ContactId==null)
              {
              StdTaskList=[Select Id,Subject,Status,ActivityDate,WhoId,WhatId,What.Name from task where ownerid=:objuser.Id and Status!='Completed' and ActivityDate=TOMORROW];
              }
        }
       else if(SelectedValue=='Next 7 Days')
        {
          
              GFtaskList=[Select id,Name,Subject__c,Status__c,Due_Date__c,assignTo__c,Team_Room__c,Team_Room__r.Name from GF_Task__c where assignTo__c=:objuser.Id and Status__c!='Completed' and Due_Date__c=NEXT_N_DAYS:7];
              if(objuser.ContactId==null)
              {
              StdTaskList=[Select Id,Subject,ActivityDate,Status,WhoId,WhatId,What.Name from task where ownerid=:objuser.Id  and Status!='Completed' and ActivityDate=NEXT_N_DAYS:7];
              }
        }
       else if(SelectedValue=='Next 7 Days+Overdue')
        {
          
              GFtaskList=[Select id,Name,Subject__c,Due_Date__c,assignTo__c,Status__c,Team_Room__c,Team_Room__r.Name from GF_Task__c where assignTo__c=:objuser.Id and Status__c!='Completed' and (Due_Date__c=NEXT_N_DAYS:7  or Due_Date__c<TODAY)];
              system.debug('GFtaskList####'+GFtaskList);
              if(objuser.ContactId==null)
              {
                  StdTaskList=[Select Id,Subject,Status,ActivityDate,WhoId,WhatId,What.Name from task where ownerid=:objuser.Id  and Status!='Completed' and (ActivityDate=NEXT_N_DAYS:7 or ActivityDate<TODAY)];
              }
              
              system.debug('StdTaskList####'+StdTaskList);
        }
        else if(SelectedValue=='This Month')
        {
          
              GFtaskList=[Select id,Name,Subject__c,Status__c,Due_Date__c,assignTo__c,Team_Room__c,Team_Room__r.Name from GF_Task__c where assignTo__c=:objuser.Id and Status__c!='Completed' and Due_Date__c=THIS_MONTH];
              if(objuser.ContactId==null)
              {
              StdTaskList=[Select Id,Subject,Status,ActivityDate,WhoId,WhatId,What.Name from task where ownerid=:objuser.Id and Status!='Completed' and ActivityDate=THIS_MONTH];
              }
        }
         else if(SelectedValue=='All')
        {
          
              GFtaskList=[Select id,Name,Subject__c,Status__c,Due_Date__c,assignTo__c,Team_Room__c,Team_Room__r.Name from GF_Task__c where assignTo__c=:objuser.Id];
              if(objuser.ContactId==null)
              {
                  StdTaskList=[Select Id,Subject,Status,ActivityDate,WhoId,WhatId,What.Name from task where ownerid=:objuser.Id];
              }
        }
        else if(SelectedValue=='All Completed')
        {
              GFtaskList=[Select id,Name,Subject__c,Status__c,Due_Date__c,assignTo__c,Team_Room__c,Team_Room__r.Name from GF_Task__c where assignTo__c=:objuser.Id and Status__c='Completed'];
              if(objuser.ContactId==null)
              {
                  StdTaskList=[Select Id,Subject,Status,ActivityDate,WhoId,WhatId,What.Name from task where ownerid=:objuser.Id and Status='Completed'];
              }
        }
   
    if(GFtaskList!=null)
      {
        
              for(GF_Task__c objGFtask:GFtaskList)
              {
                   clsGFTask objtask=new clsGFTask();
                   objtask.GFTaskSubject=objGFtask.Subject__c;
                   objtask.GFTaskDate=objGFtask.Due_Date__c;
                   if(objtask.GFTaskDate!=null)
                   {
                       objtask.GFTaskDateformat=objtask.GFTaskDate.format('MM/d/yyyy');
                   }
                   objtask.GFTaskName=objGFtask.Name;
                   objtask.GFTaskRelatedTo=objGFtask.Team_Room__r.Name;
                   objtask.GFTaskId=objGFtask.Id; 
                   objtask.GFTaskStatus =objGFtask.Status__c ;  // Added By Krishanu on 03-Jan-2014
                   clsGFTaskList.add(objtask);
                   
              }
      }
      
      if(StdTaskList!=null)
      {
        
          for(Task objStdtask:StdTaskList)
          {
               clsGFTask objtask=new clsGFTask();
               objtask.TaskSubject=objStdtask.Subject;
               objtask.TaskDate=objStdtask.ActivityDate;
               if(objtask.TaskDate!=null)
               {
                   objtask.TaskDateformat=objtask.TaskDate.format('MM/d/yyyy');
               }
               objtask.TaskName=objStdtask.WhoId;
               objtask.TaskStatus =objStdtask.Status ; // Added By Krishanu on 03-Jan-2014
               objtask.TaskRelatedTo=objStdtask.What.Name; 
                    
               objtask.TaskId=objStdtask.Id;
               clsGFTaskList.add(objtask);
               system.debug('clsGFTaskList$$$$1'+clsGFTaskList);
          }
      }
      
      
      for(clsGFTask clsGFTaskobj:clsGFTaskList)
      {
           if(clsGFTaskobj.TaskDate<System.Today() || clsGFTaskobj.GFTaskDate<System.Today() )
           {
               clsGFTaskobj.SelectedValueIsOverdue=true;
           }
           else
           {
               clsGFTaskobj.SelectedValueIsOverdue=false;
           }
      }
      
      system.debug('clsGFTaskList$$$$'+clsGFTaskList);
      if(clsGFTaskList.size()>0)
      {
          tasklistexist=true;
      }
      else
      {
          RecordsNotPresentMsg= 'You have no open tasks scheduled for this period.';
      }
      
      
        return null;
    }
   
    public PageReference NewTask() {
        //PageReference newPage = new PageReference(System.Label.Salesforce_Org_URL+'00T/e?retURL=%2Fhome%2Fhome.jsp');
        PageReference newPage = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/00T/e?retURL=%2Fhome%2Fhome.jsp');
        return newPage ;
    }

 

}