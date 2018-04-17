/******************************************************************************************

Change History:
           Modified By/On: Ravi Teja.B 21072017 
           Reason: As Approval Stage of Configurator has been added with new Process Flow Accepted Values changes are made accordingly.
*******************************************************************************************/
public class OpptyGeometryValidator{
    
    private static Set<String> ConfigList=new Set<String>{'0.014UM','0.028UM','0.040UM','0.045UM'};
    private static Set<Id> ToUpdOpptyList=new Set<Id>();

        
         
         
      public static void DeviceProcessor(Map<Id,Device__c> oldmap,Map<Id,Device__c> newmap)  //for updates
       {
         
         ToUpdOpptyList.clear();    
          if(!newmap.isEmpty() && !oldmap.isEmpty())
          {
         
            // it means that the event is an update event
            
            for (Device__c new_device : newmap.values())
                {
                    
                    Device__c old_device=oldmap.get(new_device.Id);
                    
                    if((old_device.Opportunity2__c!=new_device.Opportunity2__c) && (old_device.Opportunity2__c!=NULL && new_device.Opportunity2__c!=NULL))
                    {
                        ToUpdOpptyList.add((Id)old_device.Opportunity2__c);
                        ToUpdOpptyList.add((Id)new_device.Opportunity2__c);
                        
                    }
                    if(old_device.Opportunity2__c==NULL && new_device.Opportunity2__c!=NULL)
                    
                        ToUpdOpptyList.add((Id)new_device.Opportunity2__c);
                    if(old_device.Opportunity2__c!=NULL && new_device.Opportunity2__c==NULL)
                    
                        ToUpdOpptyList.add((Id)old_device.Opportunity2__c);
                        
    
                }
        

        OpptyProcessor();
        }
    
    
    }
        
        
        
    
        
    public  static void ConfigProcessor(Map<Id,Apttus_Proposal__Proposal__c> oldmap,Map<Id,Apttus_Proposal__Proposal__c> newmap) // for updates
    { 
    
        List<Id> Li=new List<Id>();
        List<Id> tmplist=new List<Id>();
        ToUpdOpptyList.clear();
        if(!newmap.isEmpty() && !oldmap.isEmpty())
         {
         
            // it means that the event is an update event
            for (Apttus_Proposal__Proposal__c new_config: newmap.values())
                {
                    Apttus_Proposal__Proposal__c old_config=oldmap.get(new_config.Id);
                    
                    
                    //for Opportunity Change on Configuration
                    if((old_config.Apttus_Proposal__Opportunity__c!=new_config.Apttus_Proposal__Opportunity__c) && (old_config.Apttus_Proposal__Opportunity__c!=NULL && new_config.Apttus_Proposal__Opportunity__c!=NULL))
                    
                    
                    {
                        ToUpdOpptyList.add((Id)old_config.Apttus_Proposal__Opportunity__c);
                        ToUpdOpptyList.add((Id)new_config.Apttus_Proposal__Opportunity__c);
                        
                    }
                    

                    if(old_config.Apttus_Proposal__Opportunity__c==NULL && new_config.Apttus_Proposal__Opportunity__c!=NULL)
                    
                        ToUpdOpptyList.add((Id)new_config.Apttus_Proposal__Opportunity__c);
                        
                    if(old_config.Apttus_Proposal__Opportunity__c!=NULL && new_config.Apttus_Proposal__Opportunity__c==NULL)
                    
                        ToUpdOpptyList.add((Id)old_config.Apttus_Proposal__Opportunity__c);
                }
                        
                    //for Device Change on Configuration
                for (Apttus_Proposal__Proposal__c new_config: newmap.values())
                {
                    Apttus_Proposal__Proposal__c old_config=oldmap.get(new_config.Id);
                    if((old_config.Device__c!=new_config.Device__c) && (old_config.Device__c!=NULL && new_config.Device__c!=NULL))
                    {
                        Li.add((Id)old_config.Device__c);
                        Li.add((Id)new_config.Device__c);
                        
                    }
                    if(old_config.Device__c==NULL && new_config.Device__c!=NULL)
                        Li.add((Id)new_config.Device__c);
                    if(old_config.Device__c!=NULL && new_config.Device__c==NULL)
                        Li.add((Id)old_config.Device__c);   
                }
                    
                    for(Device__c d:[SELECT Id, Name,Opportunity2__c FROM Device__c  where id in : Li])
                        tmplist.add(d.Opportunity2__c);
                        
            
            for(Opportunity oppty:[SELECT Id, Name,Process_Geometry__c, (SELECT id FROM Devices__r) FROM Opportunity  where id in : tmplist])
                if(oppty.Devices__r.size()>=0)
                    if(ConfigList.contains(oppty.Process_Geometry__c))
                        ToUpdOpptyList.add(oppty.Id);
                        
                        
                //for Stage change on Configuration
                
                for (Apttus_Proposal__Proposal__c new_config: newmap.values())
                {
                    Apttus_Proposal__Proposal__c old_config=oldmap.get(new_config.Id);
                    if(old_config.Apttus_Proposal__Approval_Stage__c != null && !old_config.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted') && new_config.Apttus_Proposal__Approval_Stage__c != null && new_config.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted'))//Modified By Ravi Teja.B 21072017
                    {
                        
                        ToUpdOpptyList.add((Id)new_config.Apttus_Proposal__Opportunity__c);
                        
                    }
                    if(old_config.Apttus_Proposal__Approval_Stage__c != null && old_config.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted') && new_config.Apttus_Proposal__Approval_Stage__c != null && !new_config.Apttus_Proposal__Approval_Stage__c.contains('Process Flow Accepted'))
                    {
                        
                        ToUpdOpptyList.add((Id)new_config.Apttus_Proposal__Opportunity__c);
                        
                    }
                    
                }   
                                        
        
                    
    
    OpptyProcessor();
    }
    
    
    }
    
    public static void OpptyReceiver(Map<id,Opportunity> oldmap,Map<id,Opportunity>newmap)
    {
        ToUpdOpptyList.clear();
        for (Opportunity newoppty: newmap.values())
                {
                    Opportunity old_oppty=oldmap.get(newoppty.Id);
                    
                        ToUpdOpptyList.add((Id)newoppty.Id);
                        
                
                }   
                                        
        
                    
    
    OpptyProcessor();
    }
    
    
    
    public  static void OpptyProcessor()
    {
    
    if(ToUpdOpptyList.size()>0){
    List<Opportunity> ToUpdOpptyFinalList=new List<Opportunity>();
    List<Apttus_Proposal__Proposal__c> lstApttus= new List<Apttus_Proposal__Proposal__c>();
    Set<ID> SetOppty= new Set<ID>();
    
    lstApttus=[Select id,Apttus_Proposal__Opportunity__c,Device__c from Apttus_Proposal__Proposal__c where Apttus_Proposal__Opportunity__c in:ToUpdOpptyList and 
    Device__c in (select id from Device__c where Opportunity2__c in :ToUpdOpptyList) and APTPS_Primary__c=true and Apttus_Proposal__Approval_Stage__c LIKE 'Process Flow Accepted%']; //Modified By Ravi Teja.B 21072017  LIKE 'Process Flow Accepted%'
    
    for(Apttus_Proposal__Proposal__c a :lstApttus)
           SetOppty.add(a.Apttus_Proposal__Opportunity__c);
    
                
    for(Opportunity oppty: [Select Id,Name,Process_Geometry__c,Apttus_Configuration_Score__c,DW_Progress__c,(SELECT id FROM Devices__r),(select id from R00N70000001yUfDEAU__r) from Opportunity where id in :ToUpdOpptyList])
    {
        if(oppty.Apttus_Configuration_Score__c==NULL)oppty.Apttus_Configuration_Score__c=0; 
        if(oppty.DW_Progress__c==NULL)oppty.DW_Progress__c=0;
        
         oppty.DW_Progress__c=oppty.DW_Progress__c- (oppty.Apttus_Configuration_Score__c); 
         if(ConfigList.contains(oppty.Process_Geometry__c))
         {
                                   
                 if(SetOppty.contains(oppty.id))
                        oppty.Apttus_Configuration_Score__c=5;
                 else 
                        oppty.Apttus_Configuration_Score__c=0;       
         }
           
         else      
            oppty.Apttus_Configuration_Score__c=   5;
      
     oppty.DW_Progress__c=oppty.DW_Progress__c+ (oppty.Apttus_Configuration_Score__c);   
     ToUpdOpptyFinalList.add(oppty);    
        
    }
    
    if(!RecursionPrevent.isAlreadyModified())   // prevent Opportunity triggers from firing
    {
        RecursionPrevent.setAlreadyModified();
        update ToUpdOpptyFinalList;
        RecursionPrevent.resetAlreadyModified();
    }
    
    
    }   
}
}