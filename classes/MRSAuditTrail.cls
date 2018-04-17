/*
Type Name: MRSAuditTrail
Author: Cognizant 
Created Date: 03-May-2014
Reason: This is a controller class for VFMRSAuditTrail page
Change History:
Author: 
Modified Date: 23-08-2014
Reason: Code changed for fetching information related to email approver.
Author: Cognizant Technology Solutions
Modified Date: 08-Sep-2014 ( For fixing prod issue related to showing layer chip status )
 */
 
global class MRSAuditTrail
{
    public static String sortBy {get; set;} 
    public string recordid {get; set;} 
    public string PageName {get; set;}
    public Integer  notessize {get; set;}
    public string CustomerName {get; set;}
    public string MaskSetTitle {get; set;}
    public string MaskLayer{get; set;}
    public string ChipName {get;set;}
    public Boolean internalView {get;set;}      
    public boolean showLayerAssociation {get; set;}
    public boolean backflag{get; set;}
    public boolean ismanulaupdate{get; set;}
    public string customerid {get;set;}
    public Boolean isBreadcrumbActive {get;set;}
    public string layerid{get;set;}
    public List<MRS_Layer_Association__History > lstLayerAssoHistory {get; set;}
    public List<MRS_Layer_Chip_Association__History > lstLayerChipAssoHistory {get; set;}
    public List<Notes__c> lstLayerAssoNotes {get;set;}
    public List<AuditTrail> lstAuditTrailObj {get ;set;}
    public  List<AuditTrail> lstAuditTrailObjSorted {get;set;}
    public list<AuditTrail> lstAuditTrailObjcreated {get;set;}
    public string oldvalue {get; set;}
    public string newvalue {get;set;}
    public String ListOfDateTimeFields {get;set;}
    public MRSAuditTrail()
    {
       ListOfDateTimeFields ='';
       internalView = false;
       oldvalue='';
       newvalue= '';
       String hostName = ApexPages.currentPage().getHeaders().get('Host');
       if(!String.isBlank(System.Label.Internal_URL) && System.Label.Internal_URL.containsIgnoreCase(hostName)) {
           internalView = true;
       }
       else {
           internalView = false;
       }
        
        if(hostName.contains(System.Label.Swift_Host_URL))
        {
            isBreadcrumbActive = true;
        }
        else
        {
            isBreadcrumbActive =false;
        }
                 
       recordid  = ApexPages.currentPage().getParameters().get('id');
       layerid = ApexPages.currentPage().getParameters().get('LayerId');
       PageName  = ApexPages.currentPage().getParameters().get('PageName');
       CustomerName  = ApexPages.currentPage().getParameters().get('customerName');
       MaskSetTitle = ApexPages.currentPage().getParameters().get('MSTName');
       MaskLayer = ApexPages.currentPage().getParameters().get('LayerNumber');
       
       customerid  = ApexPages.currentPage().getParameters().get('customerid');
       
       if(ApexPages.currentPage().getParameters().get('ChipName')!= null ||  ApexPages.currentPage().getParameters().get('ChipName') != '')
       {
           ChipName = ApexPages.currentPage().getParameters().get('ChipName');
       }
       
       if(PageName!='' || PageName!=null)
       {
         if(PageName=='Layersummary' )
         {
             
             lstLayerAssoHistory = [SELECT CreatedById,CreatedDate, CreatedBy.Name , Field,Id,NewValue,OldValue,ParentId FROM MRS_Layer_Association__History where ParentId=:recordid ORDER BY CreatedDate desc,Field desc];  
             lstLayerAssoNotes = [SELECT CreatedDate,CreatedById,Body__c from Notes__c where MRS_Layer_Association__c=:recordid and ParentId__c=null ORDER BY CreatedDate desc];
              showLayerAssociation = true; 
             PopulateAuditHistoryLayerAssociation(lstLayerAssoHistory);
             backflag= true;
         }
         if(PageName=='ManualUpdate')
         {
            ismanulaupdate= true;
            backflag= false;
            if(recordid==layerid)
              { 
                lstLayerAssoHistory = [SELECT CreatedById,CreatedDate, CreatedBy.Name , Field,Id,NewValue,OldValue,ParentId FROM MRS_Layer_Association__History where ParentId=:recordid ORDER BY CreatedDate desc,Field desc];   
                showLayerAssociation = true; 
                PopulateAuditHistoryLayerAssociation(lstLayerAssoHistory);              }
              else
              {
              showLayerAssociation = false; 
              lstLayerChipAssoHistory = [SELECT CreatedById, CreatedBy.Name , CreatedDate,Field,Id,NewValue,OldValue,ParentId FROM MRS_Layer_Chip_Association__History where ParentId=:recordid   ORDER BY CreatedDate desc,Field desc];  
              PopulateAuditHistoryLayerChipAssociation(lstLayerChipAssoHistory );
             }
             
         }
         else if (PageName=='LayerChipSummary')
         {
             if(recordid==layerid)
              {
                lstLayerAssoHistory = [SELECT CreatedById,CreatedDate, CreatedBy.Name , Field,Id,NewValue,OldValue,ParentId FROM MRS_Layer_Association__History where ParentId=:recordid ORDER BY CreatedDate desc,Field desc];
                lstLayerAssoNotes = [SELECT CreatedDate,CreatedById,Body__c from Notes__c where MRS_Layer_Association__c=:recordid and ParentId__c=null ORDER BY CreatedDate desc];
                showLayerAssociation = true; 
                PopulateAuditHistoryLayerAssociation(lstLayerAssoHistory);
                backflag= false;
              }
              else
              {
              showLayerAssociation = false; 
              lstLayerChipAssoHistory = [SELECT CreatedById, CreatedBy.Name , CreatedDate,Field,Id,NewValue,OldValue,ParentId FROM MRS_Layer_Chip_Association__History where ParentId=:recordid   ORDER BY CreatedDate desc,Field desc];
              lstLayerAssoNotes = [SELECT CreatedDate,CreatedById,Body__c from Notes__c where ParentId__c=:recordid and MRS_Layer_Association__c=null and Category__c='Hold Chip' ORDER BY CreatedDate desc];  
              PopulateAuditHistoryLayerChipAssociation(lstLayerChipAssoHistory );
              backflag= false;
             }
         }    
       }
      
    }
    global class AuditTrail { 
       public String createdDate {get ;set ;}
       public String userName {get ;set ;}
       public String description {get;set;}
       public String fieldChange {get ;set ;}
       public String oldValue {get ;set ;}
       public String newValue {get ;set ;}
       public String ShowComment {get;set;}
       public String NotesComment {get;set;}
       public AuditTrail(String  createdDate , String userName, String description, String fieldChange, String oldValue ,String newValue,String showComment,String notesComment) {
           this.createdDate = createdDate; 
           this.userName = userName;
           this.description = description;
           this.fieldChange = fieldChange;
           this.oldValue  = oldValue ;
           this.newValue  = newValue ;
           this.ShowComment = showComment;
           this.NotesComment = notesComment;
        }  
    } 
     
   /**
        This method will populate layer association objects history data. 
        @method name: PopulateAuditHistoryLayerAssociation
        @parameter:   List of MRS_Layer_Association__History object.
        @return :     Nothing
    **/  
    public void PopulateAuditHistoryLayerAssociation(List<MRS_Layer_Association__History > objLAHistory)
    {
       
       lstAuditTrailObj = new list<AuditTrail>();
       lstAuditTrailObjcreated = new list<AuditTrail>();
       Integer counter = 0;
       AuditTrail objAuditTrail;           
              
       Map<String, Schema.SObjectField> mapMRSLayerSObjectField = Schema.SObjectType.MRS_Layer_Association__c.fields.getMap();
      
       Map<String,String> mapMRSLayerAssocFieldAPINameAndLabel = new Map<String,String>();
       
        
        for (String s : mapMRSLayerSObjectField.keySet()) {
            if(String.valueOf(mapMRSLayerSObjectField.get(s).getDescribe().getType()) == 'DATETIME'){
            ListOfDateTimeFields +=String.valueOf(mapMRSLayerSObjectField.get(s).getDescribe().getName())+',';
         }
        }
               
       string createdbyname = ''; 
       string showComment = ''; 
       string notesComment = ''; 
           
              for(MRS_Layer_Association__History objHistory : objLAHistory)
              {
               
               
               if(ListOfDateTimeFields!=null || ListOfDateTimeFields!='')
               {
                  
                       if(ListOfDateTimeFields.contains(objHistory.Field))
                       {
                            
                                if(objHistory.NewValue!= null)
                                {
                                    newvalue = DateTime.valueOf(objHistory.NewValue).format();
                                }                        
                                if(objHistory.OldValue!=null)
                                {
                                    oldvalue = DateTime.valueOf(objHistory.OldValue).format();
                                }            
                        }
                        
                        else
                        {                         
                            oldvalue   = string.valueof(objHistory.OldValue);
                            newvalue  =  string.valueof(objHistory.NewValue);
                        }
                 
                }
                
                                              
                  String description;
                   if('created'.equalsIgnoreCase(objHistory.Field))
                    {    showComment = '';
                         notesComment = '';
                         description ='Created';
                         /* if (!Test.isRunningTest()){*/
                         objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format('MM/dd/yyyy HH:mm:ss'),'System User',description ,null,null,null,showComment,notesComment);
                         //objAuditTrail = new AuditTrail(String.valueof(objHistory.CreatedDate),'System User',description ,null,null,null,showComment,notesComment);
                         lstAuditTrailObjcreated .add(objAuditTrail);
                         /*}
                         
                         else
                         {
                             objAuditTrail = new MRSAuditTrail.AuditTrail ('29/08/2014 10:10:10','System User','Test description','','','','','');
                             //objAuditTrail = new AuditTrail(String.valueof(objHistory.CreatedDate),'System User',description ,null,null,null,showComment,notesComment);
                             lstAuditTrailObjcreated .add(objAuditTrail);
                         }*/
                         
                    }
                    
                    else
                    {
                       
                           

                           
                        if('Layer_Status__c'.equalsIgnoreCase(objHistory.Field) )
                        {
                            
                             if(string.valueof(objHistory.NewValue) == 'Hold')
                             {
                                List<MRS_Layer_Chip_Association__c> objlayerchipassoc = [SELECT Layer_Chip_Status__c, Layer__c FROM MRS_Layer_Chip_Association__c where Layer__c= :objHistory.ParentId  and Layer_Chip_Status__c='Hold'];
                            
                                if(objlayerchipassoc.size()>0)
                                {
                                    createdbyname = 'System user';
                                }
                                
                                else 
                                {
                                      createdbyname = objHistory.CreatedBy.Name; 
                                }
                             }
                             
                             
                        }
                        
                        else
                        {
                            createdbyname = 'System user';
                        }
                        
                         if('Hold_Warning__c'.equalsIgnoreCase(objHistory.Field)){
                             showComment = 'Show Comment';
                             if(lstLayerAssoNotes!= null && lstLayerAssoNotes.size()>0)
                             {
                               notesComment = lstLayerAssoNotes[counter].Body__c;
                             }
                             counter++;
                             createdbyname = objHistory.CreatedBy.Name; 
                             
                           }
                         else{
                          showComment = '';
                          createdbyname = 'System user';
                           }         
                        
                        description ='Modified ';
                        if(!mapMRSLayerAssocFieldAPINameAndLabel.containsKey(objHistory.Field) && mapMRSLayerSObjectField.containsKey(objHistory.Field)) {
                          mapMRSLayerAssocFieldAPINameAndLabel.put(objHistory.Field, mapMRSLayerSObjectField.get(objHistory.Field).getDescribe().getLabel());
                        }
                        String fieldLabel = mapMRSLayerAssocFieldAPINameAndLabel.get(objHistory.Field);
                         /*if (!Test.isRunningTest()){*/
                        
                        objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format('MM/dd/yyyy HH:mm:ss'),createdbyname,description + ' from '+ ' ' +   oldvalue + ' ' +  'to' + '  ' + newvalue,
                                                        fieldLabel,oldvalue,newvalue,showComment,notesComment);
                                                        
                        
                        /*
                        objAuditTrail = new AuditTrail(String.valueOf(objHistory.CreatedDate),createdbyname,description + ' from '+ ' ' +   String.valueOf(objHistory.OldValue) + ' ' +  'to' + '  ' + String.valueOf(objHistory.NewValue),
                                                        fieldLabel,String.valueOf(objHistory.OldValue),String.valueOf(objHistory.NewValue),showComment,notesComment);
                        
                        */
                        
                                                        
                        lstAuditTrailObj.add(objAuditTrail);
                       
                        /*}
                        
                        else
                          {
                              objAuditTrail =new MRSAuditTrail.AuditTrail ('29/08/2014 10:10:10','System User','Test description','Layer_Status__c','Hold','Release','Show Comment','test');
                          }*/
                              
                                                          
                   }
                   
                                  
                }
                
                lstAuditTrailObj.addall(lstAuditTrailObjcreated ); 

               
    }
   

   /**
        This method will populate layer chip association objects history data. 
        @method name: PopulateAuditHistoryLayerChipAssociation
        @parameter:   List of MRS_Layer_Chip_Association__History object.
        @return :     Nothing
      **/ 
      

    public void PopulateAuditHistoryLayerChipAssociation( List<MRS_Layer_Chip_Association__History > objLCAHistory )
    {
       
        lstAuditTrailObj = new list<AuditTrail>();
        AuditTrail objAuditTrail;
        lstAuditTrailObjcreated = new list<AuditTrail>();
        lstAuditTrailObj.clear();        
        Map<String, Schema.SObjectField> mapMRSLayerChipSObjectField = Schema.SObjectType.MRS_Layer_Chip_Association__c.fields.getMap();
        Map<String,String> mapMRSLayerChipAssocFieldAPINameAndLabel = new Map<String,String>();
        
        //String ListOfDateTimeFields = '';
        for (String s : mapMRSLayerChipSObjectField.keySet()) {
            if(String.valueOf(mapMRSLayerChipSObjectField.get(s).getDescribe().getType()) == 'DATETIME'){
            ListOfDateTimeFields +=String.valueOf(mapMRSLayerChipSObjectField.get(s).getDescribe().getName())+',';
         }
        }


         string createdbyname = ''; 
         string showComment = ''; 
         string notesComment = ''; 
         Integer Counter=0;   
        for(MRS_Layer_Chip_Association__History objHistory : objLCAHistory )
              {
                  String description;
                  if(!mapMRSLayerChipAssocFieldAPINameAndLabel.containsKey(objHistory.Field) && mapMRSLayerChipSObjectField.containsKey(objHistory.Field)) {
                          mapMRSLayerChipAssocFieldAPINameAndLabel.put(objHistory.Field, mapMRSLayerChipSObjectField.get(objHistory.Field).getDescribe().getLabel());
                        }
                        String fieldLabel = mapMRSLayerChipAssocFieldAPINameAndLabel.get(objHistory.Field);
                        if(ListOfDateTimeFields.contains(objHistory.Field))
                        {
                            if(objHistory.NewValue!=null)
                            {                        
                                newvalue = DateTime.valueOf(objHistory.NewValue).format();
                                
        }
                                     if(objHistory.OldValue!=null)
                                     
{                                    oldvalue = DateTime.valueOf(objHistory.OldValue).format();}
                        }
                        
                        
                   if('created'.equalsIgnoreCase(objHistory.Field))
                    {
                         description ='Created';
                         /* if (!Test.isRunningTest()){*/
                          objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format('MM/dd/yyyy HH:mm:ss'),objHistory.CreatedBy.Name,description ,null,null,null,showComment,notesComment);
                         
                         //objAuditTrail = new AuditTrail(String.valueOf(objHistory.CreatedDate),objHistory.CreatedBy.Name,description ,null,null,null,showComment,notesComment);
                          lstAuditTrailObjcreated.add(objAuditTrail); 
                         //}
                         
                         /*else
                         {
                            //objAuditTrail = AuditTrail('29/08/2014 10:10:10','System User','Test description','Layer_Status__c','Hold','Release','Show Comment','test');
                            objAuditTrail =new MRSAuditTrail.AuditTrail ('29/08/2014 10:10:10','System User','Test description','Tapeout_Centre_MEBES_Jobview__c','Not Ready','Redady','Show Comment','test');
                            
                         }*/
                    }
                    else
                    {
                        if('Layer_Chip_Status__c'.equalsIgnoreCase(objHistory.Field) || 'Synced_with_Oracle_DB__c'.equalsIgnoreCase(objHistory.Field)||'Send_Frame_Data__c'.equalsIgnoreCase(objHistory.Field) || 'Send_Prime_Data__c'.equalsIgnoreCase(objHistory.Field)||'Chip_Hold_Warning__c'.equalsIgnoreCase(objHistory.Field)||'Customer_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field)||'Foundry_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field)||'Tapeout_Centre_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field)||'Tapeout_Applications_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field)||'GlobalShuttle_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field)||'MDP_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field)||'TDTI_MPW_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field)||'Customer_Frame_Mockup__c'.equalsIgnoreCase(objHistory.Field)||'Foundry_Frame_Mockup__c'.equalsIgnoreCase(objHistory.Field)||'Customer_GDSOUT_Review__c'.equalsIgnoreCase(objHistory.Field)||'Foundry_GDSOUT_Review__c'.equalsIgnoreCase(objHistory.Field)||'ORC__c'.equalsIgnoreCase(objHistory.Field)||'DRW__c'.equalsIgnoreCase(objHistory.Field)||'Customer_Prime_Remote_Jobview_Setup__c'.equalsIgnoreCase(objHistory.Field)||'Customer_Frame_Remote_Jobview_Setup__c'.equalsIgnoreCase(objHistory.Field)||'Foundry_Prime_Remote_Jobview_Setup__c'.equalsIgnoreCase(objHistory.Field)||'Foundry_Frame_Remote_Jobview_Setup__c'.equalsIgnoreCase(objHistory.Field)||'Prime_MEBES_Received__c'.equalsIgnoreCase(objHistory.Field)||'Frame_MEBES_Received__c'.equalsIgnoreCase(objHistory.Field))
                        {   
                        if('Layer_Chip_Status__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            //if (!Test.isRunningTest()){
                                
                                if((objHistory.NewValue == 'Void') || (objHistory.NewValue == 'Hold')){
                                    
                                    createdbyname = objHistory.CreatedBy.Name; 
                                }
                                else{
                                      
                                      createdbyname = 'System User';
                                 }
                            //}
                            
                           /* else
                            {
                                 createdbyname = 'System User';
                            }*/
                            
                        
                        }
                        
                        if('Synced_with_Oracle_DB__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            {*/
                        
                                if(string.valueof(objHistory.OldValue) == 'false')
                                {
                                    oldvalue  = 'Ready'; 
                                }
                                else 
                                {
                                    oldvalue  = 'Done'; 
                                }
                                if(string.valueof(objHistory.NewValue) == 'true')
                                {
                                    newvalue = 'Done'; 
                                }
                                
                                else
                                {
                                     newvalue = 'Ready'; 
                                }
                            
                                createdbyname = objHistory.CreatedBy.Name; 
                          /*}
                          else
                          {
                              oldvalue = 'Ready';
                              newvalue = 'Ready'; 
                              createdbyname = objHistory.CreatedBy.Name;  
                          } */
                                                     
                       }
                       
                       else
                        {  
                          oldvalue   = string.valueof(objHistory.OldValue);
                          newvalue  =  string.valueof(objHistory.NewValue);
                            //createdbyname = 'System User';
                        }
                       if('Send_Frame_Data__c'.equalsIgnoreCase(objHistory.Field) || 'Send_Prime_Data__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */       
                                if(string.valueof(objHistory.NewValue) == 'Ready')
                                {
                                    createdbyname = 'System User';
                                }
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                          /*} 
                          
                          else
                          {
                             createdbyname = objHistory.CreatedBy.Name; 
                          }*/
                          
                                                     
                       }  
                       MRS_Layer_Chip_Association__c  objMRSLCA = [select CustomerFrameMockupApprover__r.Name,
                                  CustomerGDSOUTReviewApprover__r.Name,
                                  CustomerMebesJobViewApprover__r.Name,
                                  FoundryFrameMockupApprover__r.Name,
                                  FoundryGDSOUTReviewApprover__r.Name,
                                  FoundryMebesJobViewApprover__r.Name,
                                  GlobalShuttleMebesJobviewApprover__r.Name,
                                  MDPMebesJobviewApprover__r.Name,
                                  TapeoutApplicationsMebesJobviewApprover__r.Name,
                                  TapeoutCentreMebesJobViewApprover__r.Name,
                                    TDTIMPWMebesJobviewApprover__r.Name from MRS_Layer_Chip_Association__c  where Id=:recordid ];
                       
            
                         
                         
                         if('Chip_Hold_Warning__c'.equalsIgnoreCase(objHistory.Field)){
                           
                            if(lstLayerAssoNotes!= null && lstLayerAssoNotes.size()>0)
                             {
                               notessize = lstLayerAssoNotes.size();
                              if(counter<notessize)
                              {
                                  showComment = 'Show Comment';
                                 notesComment = lstLayerAssoNotes[counter].Body__c;
                              }
                              counter++;
                              createdbyname = objHistory.CreatedBy.Name;
                            }
                            else{
                              showComment = '';
                              createdbyname = 'System User';
                             }
                            
                         }
                            
                       if('Customer_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if(string.valueof(objHistory.NewValue) == 'Released' && objMRSLCA.CustomerMebesJobViewApprover__c!=null)
                                {
                                    createdbyname = objMRSLCA.CustomerMebesJobViewApprover__r.Name; 
                                }
                                
                                else if( string.valueof(objHistory.OldValue) == 'Not Ready' && string.valueof(objHistory.NewValue) == 'Ready' )
                                {
                                    createdbyname = 'System user';
                                }
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                            /*}
                            
                            else
                            {
                              createdbyname = 'System user';
                            }*/
                        }    
                        
                       if('Foundry_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if(string.valueof(objHistory.NewValue) == 'Released' && objMRSLCA.FoundryMebesJobViewApprover__c!=null)
                                {
                                    createdbyname = objMRSLCA.FoundryMebesJobViewApprover__r.Name; 
                                }
                                
                                 else if( string.valueof(objHistory.OldValue) == 'Not Ready' && string.valueof(objHistory.NewValue) == 'Ready' )
                                {
                                    createdbyname = 'System user';
                                }
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                            /*}
                            else
                            {
                              createdbyname = 'System user';
                            }*/
                            
                       }
                         
                       if('Tapeout_Centre_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field))
                        {
                           /* if (!Test.isRunningTest())
                            {*/ 
                                if(string.valueof(objHistory.NewValue) == 'Released' &&  objMRSLCA.TapeoutCentreMebesJobViewApprover__c!=null)
                                {
                                    createdbyname = objMRSLCA.TapeoutCentreMebesJobViewApprover__r.Name; 
                                }
                                
                                 else if( string.valueof(objHistory.OldValue) == 'Not Ready' && string.valueof(objHistory.NewValue) == 'Ready' )
                                {
                                    createdbyname = 'System user';
                                }
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                           /*}
                           else
                            {
                              createdbyname = 'System user';
                            }*/
                            
                            
                        }    
                        
                        if('Tapeout_Applications_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if(string.valueof(objHistory.NewValue) == 'Released' && objMRSLCA.TapeoutApplicationsMebesJobviewApprover__c!=null)
                                {
                                    createdbyname = objMRSLCA.TapeoutApplicationsMebesJobviewApprover__r.Name; 
                                }
                                
                                 else if( string.valueof(objHistory.OldValue) == 'Not Ready' && string.valueof(objHistory.NewValue) == 'Ready' )
                                {
                                    createdbyname = 'System user';
                                }
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                            /*}
                            
                            else
                            {
                              createdbyname = 'System user';
                            }*/
                        }    
                        
                        if('GlobalShuttle_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if(string.valueof(objHistory.NewValue) == 'Released' && objMRSLCA.GlobalShuttleMebesJobviewApprover__c!=null )
                                {
                                    createdbyname = objMRSLCA.GlobalShuttleMebesJobviewApprover__r.Name; 
                                }
                                
                                else if( string.valueof(objHistory.OldValue) == 'Not Ready' && string.valueof(objHistory.NewValue) == 'Ready' )
                                {
                                    createdbyname = 'System user';
                                }
                                
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                           /*}
                           
                           else
                            {
                              createdbyname = 'System user';
                            }*/
                            
                       }
                       if('MDP_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if(string.valueof(objHistory.NewValue) == 'Released' && objMRSLCA.MDPMebesJobviewApprover__c!= null)
                                {
                                    createdbyname = objMRSLCA.MDPMebesJobviewApprover__r.Name; 
                                }
                                
                                 else if( string.valueof(objHistory.OldValue) == 'Not Ready' && string.valueof(objHistory.NewValue) == 'Ready' )
                                {
                                    createdbyname = 'System user';
                                }
                                
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                           /*}
                           
                           else
                            {
                              createdbyname = 'System user';
                            }*/
                        }    
                        
                        if('TDTI_MPW_MEBES_Jobview__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if(string.valueof(objHistory.NewValue) == 'Released' &&  objMRSLCA.TDTIMPWMebesJobviewApprover__c!=null)
                                {
                                    createdbyname = objMRSLCA.TDTIMPWMebesJobviewApprover__r.Name; 
                                }
                                
                                 else if( string.valueof(objHistory.OldValue) == 'Not Ready' && string.valueof(objHistory.NewValue) == 'Ready' )
                                {
                                    createdbyname = 'System user';
                                }
                                
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                           /*}
                           
                           else
                            {
                              createdbyname = 'System user';
                            }*/
                            
                        }   
                        
                       if('Customer_Frame_Mockup__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if((string.valueof(objHistory.NewValue) == 'Approve' || string.valueof(objHistory.NewValue) == 'Disapprove') && objMRSLCA.CustomerFrameMockupApprover__c!=null )
                                {
                                    createdbyname = objMRSLCA.CustomerFrameMockupApprover__r.Name; 
                                }
                                
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                           /*}
                           else
                            {
                              createdbyname = 'System user';
                            }*/
                        }    
            
                        if('Foundry_Frame_Mockup__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if((string.valueof(objHistory.NewValue) == 'Approve' || string.valueof(objHistory.NewValue) == 'Disapprove') && objMRSLCA.FoundryFrameMockupApprover__c!=null )
                                {
                                    createdbyname = objMRSLCA.FoundryFrameMockupApprover__r.Name; 
                                }
                                
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                            /*}
                            else
                            {
                              createdbyname = 'System user';
                            }*/
                        }    
                         
                        if('Customer_GDSOUT_Review__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if(string.valueof(objHistory.NewValue) == 'Approve' && objMRSLCA.CustomerGDSOUTReviewApprover__c!= null )
                                {
                                    createdbyname = objMRSLCA.CustomerGDSOUTReviewApprover__r.Name; 
                                }
                                
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                           /*}
                           
                           else
                            {
                              createdbyname = 'System user';
                            }*/
                        }   
                        
                        if('Foundry_GDSOUT_Review__c'.equalsIgnoreCase(objHistory.Field))
                        {
                            /*if (!Test.isRunningTest())
                            { */
                                if(string.valueof(objHistory.NewValue) == 'Approve' && objMRSLCA.FoundryGDSOUTReviewApprover__c!= null)
                                {
                                    createdbyname = objMRSLCA.FoundryGDSOUTReviewApprover__r.Name; 
                                }
                                
                                else
                                {
                                     createdbyname = objHistory.CreatedBy.Name; 
                                }
                           /* }
                            
                            else
                            {
                              createdbyname = 'System user';
                            }*/
                        
                        }
                         if('Synced_with_Oracle_DB__c'.equalsIgnoreCase(objHistory.Field))
                         {
                             createdbyname = 'System User'; 
                         }
                         
                         
                         if('ORC__c'.equalsIgnoreCase(objHistory.Field)||'DRW__c'.equalsIgnoreCase(objHistory.Field)||'Customer_Prime_Remote_Jobview_Setup__c'.equalsIgnoreCase(objHistory.Field)||'Customer_Frame_Remote_Jobview_Setup__c'.equalsIgnoreCase(objHistory.Field)||'Foundry_Prime_Remote_Jobview_Setup__c'.equalsIgnoreCase(objHistory.Field)||'Foundry_Frame_Remote_Jobview_Setup__c'.equalsIgnoreCase(objHistory.Field)||'Prime_MEBES_Received__c'.equalsIgnoreCase(objHistory.Field)||'Frame_MEBES_Received__c'.equalsIgnoreCase(objHistory.Field))
                         {
                              createdbyname = objHistory.CreatedBy.Name; 
                         }
                        
                      }  
                   
                    else
                    {
                       createdbyname = 'System User';    
                    }
                      description ='Modified  ';
                        
                        
                        /*if (!Test.isRunningTest()){*/  
                           objAuditTrail = new AuditTrail(DateTime.valueOf(objHistory.CreatedDate).format('MM/dd/yyyy HH:mm:ss'),createdbyname,description + ' from '+ ' '+ oldvalue     + ' ' +  'to' + ' ' +  newvalue     ,
                                                        fieldLabel,oldvalue   ,newvalue,showComment,notesComment);
                           /*                             
                           objAuditTrail = new AuditTrail(String.valueOf(objHistory.CreatedDate),createdbyname,description + ' from '+ ' '+ oldvalue     + ' ' +  'to' + ' ' +  newvalue     ,
                                                        fieldLabel,oldvalue   ,newvalue,showComment,notesComment  );*/
                            lstAuditTrailObj.add(objAuditTrail); 
                          /*} 
                        else
                        {
                            objAuditTrail =new MRSAuditTrail.AuditTrail ('29/08/2014 10:10:10','System User','Test description','Tapeout_Centre_MEBES_Jobview__c','Not Ready','Redady','Show Comment','test');     
                        }   */
                                           
                          
                    }         
     }  
        lstAuditTrailObj.addall(lstAuditTrailObjcreated );   
          
        }        
}