/**
* @author       :   
* Company       :   Cognizant Technologies PTE Ltd.
* Description   :   Functionality to prevent duplicate fab reticles for same reticle.               
* History       :

        Initials        Date                Description
-----------------------------------------------------------------------------------------
        Onkar Kumar     12/27/2013          Created the Class
        Sameer Matale   2/26/2014           Modified to fix bug - Exception 'Fab reticle already exists'
**/

trigger ROS_Preventduplicatefabreticle on Fab_Reticle__c (before insert,after delete,after insert,after update) {

 if((ROS_Triggers_Bypass__c.getInstance('ROS_Preventduplicatefabreticle').Username__c==null)||(UserInfo.getUserName()!=ROS_Triggers_Bypass__c.getInstance('ROS_Preventduplicatefabreticle').Username__c)){ 


        if(Trigger.isbefore && Trigger.IsInsert){
            Set<Id> SReticlesId=new Set<Id>();
            Set<Id> SFabId=new Set<Id>();
            
            for(Fab_Reticle__c fr:Trigger.new){
                SReticlesId.add(fr.Reticle__c);
                SFabId.add(fr.Fab__c);
            }
            
            Map<Id,Reticle__c> MReticleIdRecord=new Map<Id,Reticle__c>([Select Id,fabstr__c from reticle__c where id in :SReticlesId]);
            Map<Id,Fab__c> MFabIdRecord=new Map<Id,Fab__c>([Select id,name from fab__c where id in :SFabId]);
            Map<Id,fab_reticle__c> MExistFR=new map<Id,fab_reticle__c>();

            for(Fab_Reticle__c temp:Trigger.new) {
                if((MReticleIdRecord.get(temp.Reticle__c).fabstr__c)!=null && ((MReticleIdRecord.get(temp.Reticle__c).fabstr__c).contains(MFabIdRecord.get(temp.fab__c).name))){
                    temp.adderror('Fab Reticle already exists.');
                }
            }
                
    }

    if(trigger.isafter && Trigger.IsDelete ) {
        List<Reticle__c> Lupdateret=new List<Reticle__c>();
        Set<Id> SReticlesId=new Set<Id>();
        Set<Id> SFabId=new Set<Id>();
        
        for(Fab_Reticle__c fr:Trigger.old) {
            SReticlesId.add(fr.Reticle__c);
            SFabId.add(fr.Fab__c);
        }
                
        Map<Id,Reticle__c> MReticleIdRecord=new Map<Id,Reticle__c>([Select Id,fabstr__c,(Select Id,Name,Fab__r.name from Fab_Reticle__r) from reticle__c where id in :SReticlesId]);
        Map<Id,Fab__c> MFabIdRecord=new Map<Id,Fab__c>([Select id,name from fab__c where id in :SFabId]);

        if(Trigger.Isdelete){
            for(Fab_Reticle__c temp:Trigger.old){
                    
                if((MReticleIdRecord.get(temp.Reticle__c).fabstr__c)!=null && ((MReticleIdRecord.get(temp.Reticle__c).fabstr__c).contains(MFabIdRecord.get(temp.fab__c).name)))
                MReticleIdRecord.get(temp.Reticle__c).fabstr__c=MReticleIdRecord.get(temp.Reticle__c).fabstr__c.replace(MFabIdRecord.get(temp.fab__c).name,'').replace(',,',',');
                
                if(MReticleIdRecord.get(temp.Reticle__c).fabstr__c.endswith(','))
                MReticleIdRecord.get(temp.Reticle__c).fabstr__c=MReticleIdRecord.get(temp.Reticle__c).fabstr__c.substring(0,MReticleIdRecord.get(temp.Reticle__c).fabstr__c.length()-1);
                
                if(MReticleIdRecord.get(temp.Reticle__c).fabstr__c.startswith(','))
                MReticleIdRecord.get(temp.Reticle__c).fabstr__c=MReticleIdRecord.get(temp.Reticle__c).fabstr__c.substring(1,MReticleIdRecord.get(temp.Reticle__c).fabstr__c.length());
                
                Lupdateret.add(MReticleIdRecord.get(temp.Reticle__c));
            }
            update Lupdateret;
        
        }
        }
        
        If(Trigger.IsAfter && (Trigger.IsUpdate || Trigger.IsInsert)){
        List<Reticle__c> Lupdateret=new List<Reticle__c>();
        Set<Id> SReticlesId=new Set<Id>();
        Set<Id> SFabId=new Set<Id>();
        
        for(Fab_Reticle__c fr : Trigger.new) {
            SReticlesId.add(fr.Reticle__c);
            SFabId.add(fr.Fab__c);
        }
                
        List<Reticle__c> LReticles=new List<Reticle__c>([Select Id,fabstr__c,(Select Id,Name,Fab__r.name from Fab_Reticle__r) from reticle__c where id in :SReticlesId]);
        Map<Id,Fab__c> MFabIdRecord=new Map<Id,Fab__c>([Select id,name from fab__c where id in :SFabId]);
        
        
        for(Reticle__c eachreticle : LReticles){
        
        Set<String> Fabs=new Set<String>();
        String ConcatenatedFabs='';
        
            for(Fab_reticle__c TempFab : eachreticle.Fab_Reticle__r){
                Fabs.add(TempFab.Fab__r.Name);
            
            }
        
        for(String eachFabString : Fabs)
            ConcatenatedFabs=ConcatenatedFabs+','+eachFabString;
            
        if(ConcatenatedFabs.startswith(',')){ 
                    ConcatenatedFabs=ConcatenatedFabs.substring(1,ConcatenatedFabs.length());
                    }
        eachreticle.FabStr__c=ConcatenatedFabs;            
        Lupdateret.add(eachreticle);
        }
            
          update LUpdateRet;         
                
                
                
                }
            
            
            
            
            
            
            
            }
        
        
        
        
        
        
        
        
        }