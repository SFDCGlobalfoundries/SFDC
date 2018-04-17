public with sharing class TaskEditExtension 
{
    Task tsk= null;
    
    public TaskEditExtension(ApexPages.StandardController controller) 
    {
        this.tsk=(Task)controller.getRecord();
        String strWhatId=ApexPages.CurrentPage().getParameters().get('what_id');
        this.tsk.WhatId=strWhatId;
       //  // Here if i give System.CurrentPage().getParameters().get('id') gives me compilation error.
       // String strOwnerId=ApexPages.CurrentPage().getParameters().get('OwnerId');
      //  tsk.WhatId=strWhatId;
       // tsk.OwnerId=strOwnerId;
    }

}