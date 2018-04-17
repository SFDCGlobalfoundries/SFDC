public with sharing class SFDCProjectStagesController 
{
    private Map<String,String> hintMap = null;
    public List<SFDC_Project_Stage__c> Stages{get;set;}
    public String LastStageName{get;set;}
    public String FirstStageName{get;set;}
    public SFDC_Project__c Project{get;set;}
    private Map<String,SFDC_Project_Stage__c> origStages = null;
    
     public SFDCProjectStagesController()
    {
        SFDC_Project_Stage__c pstg = null;
        List<SFDC_Project_Stage__c> rlist = new List<SFDC_Project_Stage__c>();
        String id = ApexPages.currentPage().getParameters().get('id');
        Map<String,SFDC_Project_Stage__c> smap = new Map<String,SFDC_Project_Stage__c>();
        //QUERY FOR PROJECT
        List<SFDC_Project__c> plist = [Select id, Name, Start_Date__c, End_Date__c, Current_Stage__c, Current_Milestone__c from SFDC_Project__c where id = :id];
        if(plist.size() == 1)
        {
           Project = plist.get(0);
        }
        //QUERY FOR STAGES
        List<SFDC_Project_Stage__c> slist = [SELECT id, Name,Name__c,SFDC_Project__c,Start_Date__c, End_Date__c,Completed__c,Completed_Date__c,Skip__c,Skip_Justification__c, Hint_Time__c 
                                             from SFDC_Project_Stage__c where SFDC_Project__c = :id];
                                             
        //POPULATE STAGE NAME TO STAGE MAP FOR LATER                                    
       // system.debug('@@@@@@slist >>>>>>>>'+slist .size()+slist );
        for(SFDC_Project_Stage__c stg:slist)
        {
            smap.put(stg.Name__c,stg);
        }
        
        
        //GRAB PICKLIST VALUES FROM STAGE NAME PICKLIST
        Schema.DescribeFieldResult f = Schema.SObjectType.SFDC_Project_Stage__c.fields.Name__c;
        List <Schema.PicklistEntry> plentries = f.getPicklistValues();
        Map<String,SFDC_Project_Stage__c> clones = new Map<String,SFDC_Project_Stage__c>();
        SFDC_Project_Stage__c clone = null;
        //system.debug('>>>>>plentries >>>'+plentries );
        //LOOP THROUGH STAGE NAME PICK LIST ENTRIES
        for(Schema.PicklistEntry ple:plentries)
        {
           //LOOKUP STAGE IN LOCAL MAP
           pstg = smap.get(ple.getValue());
           // system.debug('>>>>>pstg >>>'+pstg );
           
           //CREATE CLONE FOR DIFF COMPARING DURING SAVE OPERATION
           clone = new SFDC_Project_Stage__c();
           
           //CHECK IF STAGE FOUND IN MAP
           if(pstg == null)
           {
              //NOT FOUND SO CREATE STAGE OBJECT 
              pstg = new SFDC_Project_Stage__c();
              pstg.SFDC_Project__c = id;
              pstg.Name__c = ple.getValue();
              pstg.Name = pstg.Name__c;
              //ADD HINT LABEL
              pstg.Hint_Time__c = getHint(pstg.Name);
           }else
           {
             //ADD HINT LABEL
             pstg.Hint_Time__c = getHint(pstg.Name);
             clone.id = pstg.id;
           }
           
           //SET CLONE PROPS, CLONE USED LATER FOR DIFF
           clone.Name = pstg.Name;
           clone.Name__c = pstg.Name__c;
           clone.SFDC_Project__c = pstg.SFDC_Project__c;
           clone.Start_Date__c = pstg.Start_Date__c; 
           clone.End_Date__c = pstg.End_Date__c;
           clone.Completed__c = pstg.Completed__c;
           clone.Completed_Date__c = pstg.Completed_Date__c;
           clone.Skip__c = pstg.Skip__c;
           clone.Skip_Justification__c = pstg.Skip_Justification__c;
           clones.put(clone.Name,clone);
           rlist.add(pstg);
           LastStageName = pstg.Name;
        }
        
        Stages = rlist;
        if(Stages.size() > 0)
        {
           FirstStageName = Stages.get(0).Name;
        }
        origStages = clones;
    }
    
    /**
    *  Cancel action, navigates user back to parent project.
    **/
    public PageReference Cancel() {
    
        String url = '/';
        if(Project != null)
        {
           url += Project.id;
        }
    
        return new PageReference(url);
    }

    /**
    *  Converts stage to html for diff recording in change history.
    **/
    String stageToString(SFDC_Project_Stage__c stg)
    {
       return '<tr><td>' + stg.Name + '</td><td>' + stg.Start_Date__c + '</td><td>' + stg.End_Date__c + '</td><td>' + stg.Completed__c + '</td><td>' + stg.Completed_Date__c + '</td><td>' + stg.Skip__c + '</td><td>' + stg.Skip_Justification__c + '</td></tr>';
    }

    /**
    *  Check for difference between stage objects.
    **/
    void diff(List<String> dlist,SFDC_Project_Stage__c bstg, SFDC_Project_Stage__c astg)
    {
               
        if((bstg.Start_Date__c == null)&&(astg.Start_Date__c != null)){ dlist.add('Stage: ' + bstg.Name + ' start date changed from null to ' + astg.Start_Date__c); }
        if((bstg.Start_Date__c != null)&&(astg.Start_Date__c == null)){ dlist.add('Stage: ' + bstg.Name + ' start date changed from ' + bstg.Start_Date__c + ' to null'); }
        if((bstg.Start_Date__c != null)&&(astg.Start_Date__c != null)&&(bstg.Start_Date__c != astg.Start_Date__c)){ dlist.add('Stage: ' + bstg.Name + ' start date changed from ' + bstg.Start_Date__c + ' to ' + astg.Start_Date__c); }
        
        if((bstg.End_Date__c == null)&&(astg.End_Date__c != null)){ dlist.add('Stage: ' + bstg.Name + ' end date changed from null to ' + astg.End_Date__c); }
        if((bstg.End_Date__c != null)&&(astg.End_Date__c == null)){ dlist.add('Stage: ' + bstg.Name + ' end date changed from ' + bstg.End_Date__c + ' to null'); }
        if((bstg.End_Date__c != null)&&(astg.End_Date__c != null)&&(bstg.End_Date__c != astg.End_Date__c)){ dlist.add('Stage: ' + bstg.Name + ' end date changed from ' + bstg.End_Date__c + ' to ' + astg.End_Date__c); }
      
        if((bstg.Completed__c == null)&&(astg.Completed__c != null)){ dlist.add('Stage: ' + bstg.Name + ' complete flag from null to ' + astg.Completed__c); }
        if((bstg.Completed__c != null)&&(astg.Completed__c == null)){ dlist.add('Stage: ' + bstg.Name + ' complete flag from ' + bstg.Completed__c + ' to null'); }
        if((bstg.Completed__c != null)&&(astg.Completed__c != null)&&(bstg.Completed__c != astg.Completed__c)){ dlist.add('Stage: ' + bstg.Name + ' complete flag changed from ' + bstg.Completed__c + ' to ' + astg.Completed__c); }
      
        if((bstg.Completed_Date__c == null)&&(astg.Completed_Date__c != null)){ dlist.add('Stage: ' + bstg.Name + ' completed date changed from null to ' + astg.Completed_Date__c); }
        if((bstg.Completed_Date__c != null)&&(astg.Completed_Date__c == null)){ dlist.add('Stage: ' + bstg.Name + ' completed date changed from ' + bstg.Completed_Date__c + ' to null'); }
        if((bstg.Completed_Date__c != null)&&(astg.Completed_Date__c != null)&&(bstg.Completed_Date__c != astg.Completed_Date__c)){ dlist.add('Stage: ' + bstg.Name + ' completed date changed from ' + bstg.Completed_Date__c + ' to ' + astg.Completed_Date__c); }
      
      
        if((bstg.Skip__c == null)&&(astg.Skip__c != null)){ dlist.add('Stage: ' + bstg.Name + ' skip flag from null to ' + astg.Skip__c); }
        if((bstg.Skip__c != null)&&(astg.Skip__c == null)){ dlist.add('Stage: ' + bstg.Name + ' skip flag from ' + bstg.Skip__c + ' to null'); }
        if((bstg.Skip__c != null)&&(astg.Skip__c != null)&&(bstg.Skip__c != astg.Skip__c)){ dlist.add('Stage: ' + bstg.Name + ' skip flag changed from ' + bstg.Skip__c + ' to ' + astg.Skip__c); }
      
        if((bstg.Skip_Justification__c == null)&&(astg.Skip_Justification__c != null)){ dlist.add('Stage: ' + bstg.Name + ' skip justification from null to ' + astg.Skip_Justification__c); }
        if((bstg.Skip_Justification__c != null)&&(astg.Skip_Justification__c == null)){ dlist.add('Stage: ' + bstg.Name + ' skip justification from ' + bstg.Skip_Justification__c + ' to null'); }
        if((bstg.Skip_Justification__c != null)&&(astg.Skip_Justification__c != null)&&(bstg.Skip_Justification__c != astg.Skip_Justification__c)){ dlist.add('Stage: ' + bstg.Name + ' skip justification changed from ' + bstg.Skip_Justification__c + ' to ' + astg.Skip_Justification__c); }
          
        
    }


    /**
    *  Saves all changes and navigates user back to parent project.
    **/
    public PageReference Save() 
    {
        String currentStageId = null;
        SFDC_Project_Milestone__c currentMilestone = null;
        PageReference pr = null;
        Date projectStartDate = null;
        Date projectEndDate = null;
        SFDC_Project_Stage__c origStage = null;
        String surl = '/';
        List<String> dlist = new List<String>();
        if(Project != null){  surl += Project.id; }
        pr = new PageReference(surl);
        if(Stages == null){  return pr;}
        
        
        try{
             Boolean errored = false;
             
             List<SFDC_Project_Stage__c> ustages = new List<SFDC_Project_Stage__c>();
             SFDC_Project_Stage__c stg = null;
             SFDC_Project_Stage__c prevStg = null;
             SFDC_Project_Stage__c nextStg = null;
             List<String> newList = new List<String>();
             List<String> oldList = new List<String>();
             
            // system.debug('@@@@@@Stages'+Stages);
             
             for(Integer i = 0; i < Stages.size() ;++i)
             {
                stg = Stages.get(i);
              //  system.debug('@@@@@@Stagesstg '+stg );
                
                if( (i+1) < Stages.size())
                {
                  nextStg = Stages.get(i+1);
                  nextStg.Start_Date__c = stg.End_Date__c;
                }
                
                if(stg.End_Date__c == null)
                {
                   errored = true;
                   stg.addError('Stage \"' + stg.Name + '\" cannot have a blank end date ');
                }
                
                if(stg.Start_Date__c == null)
                {
                   errored = true;
                   stg.addError('Stage \"' + stg.Name + '\" cannot have a blank start date ');
                }
                
                //VALIDATE JUSTIFICATION ENTERED FOR SKIPPED STAGE
                if((stg.Skip__c)&&( stg.Skip_Justification__c == null))
                {
                   stg.addError('Please enter justification for skipping stage: ' + stg.Name);
                   errored = true;
                }
                
                if((stg.Completed__c)&&( stg.Completed_Date__c == null))
                {
                   stg.addError('Completed Date for stage: ' + stg.Name + ' is required if completed checkbox is checked');
                   errored = true;
                }
                
                 if(( stg.Completed_Date__c != null)&&(!stg.Completed__c))
                {
                   stg.Completed__c = true;
                }
                if((stg.Completed__c)&&( stg.Skip__c))
                {
                   stg.addError('Both completed and skip checkboxes cannot be selected for stage: ' + stg.Name + ', please select one or the other');
                   errored = true;
                }
                
             }//END FOR
             
             if(errored){  return null; }
             
             
             for(Integer i = 0; i < Stages.size() ;++i)
             {
                stg = Stages.get(i);
                if((stg.Start_Date__c != null)&&(stg.End_Date__c != null))
                {
                   if(stg.End_Date__c < stg.Start_Date__c)
                   {
                       stg.addError('Stage \"' + stg.Name + '\" cannot have an end date of ' + stg.End_Date__c + ' which is less than start date of ' + stg.Start_Date__c);
                       return null;
                   }
                }
               
               newList.add(stageToString(stg));
                
                //VALIDATE THAT IF STAGE COMPLETED, ALL PREVIOUS STAGES ARE ALSO FLAGGED AS COMPLETED OR SKIPPED
                if(stg.Completed__c)
                {
                  //CHECK THAT ALL PREVIOUS STAGES ALSO FLAGGED AS COMPLETED
                  for(Integer j = i-1; j >= 0; --j)
                  {
                      prevStg = Stages.get(j);
                      if(prevStg.Skip__c)
                      {
                           continue;
                      }
                      if(!prevStg.Completed__c)
                      {
                         stg.addError('Stage \"' + stg.Name + '\" cannot be flagged as completed until all previous stages are also flagged as completed');
                         return null;
                      }
                     
                  }//END FOR
                  
                  
                   
                }//END IF COMPLETED
                
                
                //VALIDATE THAT STAGE DATE RANGES DO NOT OVERLAP
                for(Integer j = i-1; j >= 0; --j)
                {
                    prevStg = Stages.get(j);
                    
                     
                   if((prevStg.End_Date__c != null)&&(stg.Start_Date__c != null))
                   {
                     if(stg.Start_Date__c < prevStg.End_Date__c)
                     {
                       stg.addError('Stage \"' + stg.Name + '\" start date of ' + stg.Start_Date__c + ' cannot overlap with preceding Stage \"' + prevStg.Name__c + '\" end date of ' + prevStg.End_Date__c);
                       return null;
                     }
                   }
                   
                   if((prevStg.Start_Date__c != null)&&(stg.Start_Date__c != null))
                   {
                     if(stg.Start_Date__c < prevStg.Start_Date__c)
                     {
                       stg.addError('Stage \"' + stg.Name + '\" start date of ' + stg.Start_Date__c + ' cannot come before preceding Stage \"' + prevStg.Name__c + '\" start date of ' + prevStg.Start_Date__c);
                       return null;
                     }
                   }
                   
                   //CHECK IF DIRECTLY PRECEDING STAGE HAS A BLANK END DATE BUT YET THEY ENTERED A START DATE, AUTO POPULATE THE END DATE WITH NEXT STAGE START DATE
                   if((prevStg.End_Date__c == null)&&(stg.Start_Date__c != null)&&(prevStg.Start_Date__c != null)&&(j == (i-1)))
                   {
                      prevStg.End_Date__c = stg.Start_Date__c;
                   }
                   
                }//END FOR
                
                
                
                
                //PROPAGATE NAME
                stg.Name = stg.Name__c;
                
                
                
                //SET PROJECT START DATE TO EARLIEST START DATE FOUND
                if(projectStartDate == null)
                {
                   projectStartDate = stg.Start_Date__c;
                }else
                {
                    if((stg.Start_Date__c != null)&&(stg.Start_Date__c < ProjectStartDate))
                    {
                      projectStartDate = stg.Start_Date__c;
                    }
                }
                 
                //SET PROJECT END DATE TO LATEST END DATE FOUND 
                if(projectEndDate == null)
                {
                   projectEndDate = stg.End_Date__c;
                }else
                {
                    if((stg.End_Date__c != null)&&(stg.End_Date__c > projectEndDate))
                    {
                      projectEndDate = stg.End_Date__c;
                    }
                 }
                
                //ADD STAGE TO UPDATE LIST                       
                ustages.add(stg); 
                
                origStage = origStages.get(stg.Name);
                if(origStage != null)
                {
                   //CHECK FOR DIFFS
                   diff(dlist,origStage,stg);
                   oldList.add(stageToString(origStage));
                }
                      
            }//END FOR LOOP(STAGES)
            
            //CHECK IF ERRORED FLAG WAS SET
            if(errored)
            {
               return null;
            }
            
            //system.debug('>>>>>>>>>>>>>>>>>Stages>>'+Stages.size()+Stages);
            for(Integer i = 0; i < Stages.size() ;++i)
             {
                stg = Stages.get(i); 
               // system.debug('>>>>>>>>>>>>>>>>>stg>>'+stg);
                if((!stg.Completed__c)&&(!stg.Skip__c))
                {
                  // system.debug('>>>>>>>>>>>>>>>>>stg.Id>>'+stg.Id + Stages.size() );
                   currentStageId = stg.Id;
                   break; 
                }
             }
            
             if(currentStageId == null)
             {
                if(Stages.size() > 0)
                {
                  stg = Stages.get(Stages.size()-1);
                  //system.debug('>>>>>>>>>>>>>>>>>stg.Id>>'+Stages.size()+(Stages.size()-1)+stg+stg.Id);
                  currentStageId = stg.Id;
                }
             }
             // system.debug('@@@@@@@@@ustages@@@@@'+ustages.size()+ustages); 
            
            //UPDATE STAGE INFO IN DATABASE
            upsert ustages;
            //17/may/2013  yash
            for(Integer i = 0; i < ustages.size() ;++i)
             {
                if((!ustages[0].Completed__c)&&(!ustages[0].Skip__c))
                {
                 currentStageId=ustages[0].id;
                 break; 
                }
             } 
            
           
            
               
            // system.debug('@@@@@@@@@Projectold@@@@@'+Project);   
           //   system.debug('@@@@@@@@@projectStartDate@@@@@'+projectStartDate + projectEndDate + currentStageId  );    
            if(Project != null)
            {
                Project.Start_Date__c = projectStartDate;
                Project.End_Date__c = projectEndDate;
                if(currentStageId != null)
                {
                    Project.Current_Stage__c = currentStageId;
                    //system.debug('@@@@@@@@@currentStageId@@@@@'+currentStageId);
                    currentMilestone = SFDCUtil.findCurrentMilestone(currentStageId);
                    if(currentMilestone != null)
                    {
                       Project.Current_Milestone__c = currentMilestone.Id;
                    }else
                    {
                       Project.Current_Milestone__c = null;
                    }
                }else
                {
                 Project.Current_Stage__c = null;
                }
                 //system.debug('@@@@@@@@@Project@@@@@'+Project);
                update Project;
                
                
                if(dlist.size() > 0)
                {
                   SFDC_Change_History__c history = new SFDC_Change_History__c();
                   history.SFDC_Project__c = Project.Id;
                   String subject = 'Project ' + Project.Name + ' - Stages Modified';
                   String tmsg = '';
                   String htm = 'Stages were modified for Project <b>' + Project.Name + '</b><br/>';
                   htm += 'Following changes were made: ';
                   htm += '<ul>';
                   for(String d:dlist)
                   {
                     tmsg += d + '\r\n';
                     htm += '<li>' + d + '</li>';
                   }
                   
                   htm += '</ul>';
                   history.diff__c = htm;
                   htm += 'To view project <a href='+ URL.getSalesforceBaseUrl().toExternalForm() +'/' + Project.Id+'>click here.</a>';
                   
                   
                   
                   String newData = '<table><tr><th>Name</th><th>Start Date</th><th>End Date</th><th>Completed</th><th>Completed Date</th><th>Skip</th><th>Skip Justification</th></tr>';
                   String oldData = '<table><tr><th>Name</th><th>Start Date</th><th>End Date</th><th>Completed</th><th>Completed Date</th><th>Skip</th><th>Skip Justification</th></tr>';
                   
                   
   
                   for(String n: newList)
                   {
                     
                      newData += n;
                     
                   }
                   
                   for(String o: oldList)
                   {
                     
                     oldData += o;
                     
                   }
                   newData += '</table>';
                   oldData += '</table>';
                   history.old__c = oldData;
                   history.new__c = newData;
                   insert history;

                   SFDCUtil.notifyProjectStakeHolders(Project.Id, new String[]{'IT Owner', 'IT Project Manager', 'Business Owner', 'WWMS System & Solution Owner'},subject, tmsg, htm);
                }
            }            

            

       }catch(Exception e)
       {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getDMLMessage(0));  
          ApexPages.addMessage(myMsg);
          return null;
       }
       
    
        return pr;
    }

    public String getHint(String stg)
    {
       if(hintMap == null)
       {
         hintMap = new Map<String,String>();
         hintMap.put('User Request','(1 week to 3 months)');
         hintMap.put('Approved for Assessment','(1 week to 2 months)');
         hintMap.put('Assessment & Vendor Evaluation','(1 week to 3 months)');
         hintMap.put('Recommendation','(1 week to 3 months)');
         hintMap.put('Approved for Implementation','(1 week to 2 months)');
         hintMap.put('Implementation Planning','(1 week to 2 months)');
         hintMap.put('Implementation','(1 week to 11 months)');
         hintMap.put('Build & Deploy','(1 week to 2 months)');
         hintMap.put('Post-Deployment Review','(1 week to 1 month)');
         hintMap.put('Complete','( 1-2 weeks)');
       }
       
       String h = hintMap.get(stg);
       if(h != null)
         return h;

       return '';
    }
    
   

}