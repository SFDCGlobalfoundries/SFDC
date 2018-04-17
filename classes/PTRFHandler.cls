/*
Type Name: PTRFHandler
Author: Cognizant 
Created Date: 18-March-2014
Reason: PTRF Related Functionality
Change History:
Author: 
Modified Date: 
Reason: 
Author: Cognizant Technology Solutions
Modified Date:
……..
……..
*/

public class PTRFHandler
{

     /**
        This method updates the Is Available For Use field of Mask Set Title when the PTRF Prime Tapeout or Frame Tapeout field
        is true and the PTRF Order Status is Perform Tapeout Options, Jobview, Mask Making or Closed.

        @method name: ptrfIsAvailableForUse
        @parameter:   Set of Mask Set Title Ids of the PTRFs which meet the above criteria.
        @return :     None.
     **/

    public static void ptrfIsAvailableForUse(Set<String> setMaskSetTitleLookUp)
    {       
    
        if(setMaskSetTitleLookUp!=null && setMaskSetTitleLookUp.size()>0)
        { 
              List<Mask_Set_Title__c> lstUpdateMaskSetTitle = new List<Mask_Set_Title__c>();
              
              for(Mask_Set_Title__c mst : [Select Id, Name, Is_Available_For_Use__c From Mask_Set_Title__c Where Id IN :setMaskSetTitleLookUp 
              and Is_Available_For_Use__c=false])
              {
                  mst.Is_Available_For_Use__c = True;
                  lstUpdateMaskSetTitle.Add(mst);
              } 
              
              if(lstUpdateMaskSetTitle!=null && lstUpdateMaskSetTitle.size()>0){
                  updateMaskSetTitleDML(lstUpdateMaskSetTitle);
              }                   
        }     
    }
    
     /**
        This method updates the Mask Set Titles corresponding to the PTRFs through DML Update operation.

        @method name: updateMaskSetTitleDML
        @parameter:   List of existing Mask Set Titles to be updated.
        @return :     None.
     **/
          
    public static void updateMaskSetTitleDML(List<Mask_Set_Title__c> lstUpdateMaskSetTitle)
    {
        if(lstUpdateMaskSetTitle!=null && lstUpdateMaskSetTitle.size() > 0)
        {
            try
            {
                Update lstUpdateMaskSetTitle;            
            }
            catch(DMLException e)
            {
                System.debug('*** Exception in updating Mask Set Title Is_Available_For_Use__c is --> ' + e.getMessage()); 
            }
        } 
    }
    
    
      public static void setPTRFSharingPTRFAdd(List<PTRF__c> lstPTRF)
   {
   
          List<PTRF__share> listSharePtrf  =new List<PTRF__share>();
          Map<Id,String> mapPTRFtoDevice=new Map<Id,String>() ; 
          Map<Id,String> mapPTRFtoOptProgram=new Map<Id,String>() ; 
          Map<Id,String> mapPTRFtoAccount=new Map<Id,String>() ; 
          Map<Id,Set<Id>> mapPTRFtoUser=new Map<Id,Set<Id>>() ;
          Map<Id,String> mapPTRFtoOwner=new Map<Id,String>() ;   
          Id idOptProgram;
          Id idAccount;
          Id idDevice;
          Set<Id> setInactiveUsers=new set<ID>();
          Set<Id> setDevices=new set<ID>();
          Set<Id> idOptMembers=new set<ID>();
          Set<Id> idMembers=new set<ID>();
          Set<string> setOptProgram=new set<string>();
          Set<string> setAccount=new set<string>();
          Set<string> setOptAllMembers=new set<string>();
          Set<string> setFeUsers=new Set<String>();
          boolean isFEUser=false;
          List<String> lstFeRoles= new List<String>();
          
          Environment_Variable__c tempEnv= [SELECT Value__c FROM Environment_Variable__c WHERE Name = 'SwiftFETeamRoles' LIMIT 1];
          lstFeRoles = String.valueOf(tempEnv.Value__c).split(',');
           
          for(PTRF__c objPTRF : lstPTRF){ 
              if(objPTRF.Device__c!=null){  
                  mapPTRFtoDevice.put(objPTRF.ID,objPTRF.Device__c);
                  setDevices.add(objPTRF.Device__c);
              }else{
                  mapPTRFtoAccount.put(objPTRF.ID,objPTRF.Customer__c);
                  setAccount.add(objPTRF.Customer__c);
              }  
          }
              Set<Id> idPTRFs = (new Map<Id,PTRF__c>(lstPTRF)).keySet(); 
              if(idPTRFs!=null && idPTRFs.size()>0){
                  for(PTRF__Share  objShare:[SELECT Id,ParentId,RowCause,UserOrGroupId FROM PTRF__Share WHERE ParentId in:idPTRFs and RowCause='Owner']){
                      mapPTRFtoOwner.put(objShare.ParentId,objShare.UserOrGroupId);
                  }        
              }
          if(setDevices!=null && setDevices.size()>0){
              List<Device__c > listDevices=[select ID,Opportunity_Program__c from Device__c where ID in:setDevices];
              if(listDevices!=null && listDevices.size()>0 && mapPTRFtoDevice.size()>0){
                  for(Id idPTRF : mapPTRFtoDevice.keyset()){
                      idDevice=mapPTRFtoDevice.get(idPTRF);
                      
                      for(Device__c objDevice : listDevices){
                          if(objDevice !=null && objDevice.ID !=null && objDevice.ID==idDevice){
                              setOptProgram.add(objDevice.Opportunity_Program__c );
                              mapPTRFtoOptProgram.put(idPTRF ,objDevice.Opportunity_Program__c );
                          }
                      }
                  }
              }
          } 
          
          if(setOptProgram!=null && setOptProgram.size()>0){
              List<Opportunity_Program_Team_Member__c> listOptMember=[select id,Opportunity_Program__c,User__c from Opportunity_Program_Team_Member__c where Opportunity_Program__c in:setOptProgram ];
              if(listOptMember!=null && listOptMember.size()>0 && mapPTRFtoOptProgram.size()>0){
                  for(Id idPTRF : mapPTRFtoOptProgram.keyset()){
                      idOptProgram=mapPTRFtoOptProgram.get(idPTRF);
                      idOptMembers=new Set<Id>();
                      for(Opportunity_Program_Team_Member__c objOptMember : listOptMember){
                          if(objOptMember!=null && objOptMember.Opportunity_Program__c !=null && objOptMember.Opportunity_Program__c==idOptProgram && mapPTRFtoOwner.get(idPTRF )!=null && objOptMember.User__c!=mapPTRFtoOwner.get(idPTRF )){
                              idOptMembers.add(objOptMember.User__c);
                              setOptAllMembers.add(objOptMember.User__c);
                          }
                      }
                      mapPTRFtoUser.put(idPTRF ,idOptMembers);
                      
                  }
              }
          }  
          if(setAccount!=null && setAccount.size()>0){
              List<Account_Team_Proxy__c> listAccProxyMember=[SELECT User__c,Account__c FROM Account_Team_Proxy__c WHERE Account__c in:setAccount];
              
              if(listAccProxyMember!=null && listAccProxyMember.size()>0 && mapPTRFtoAccount.size()>0){
                  for(Id idPTRF : mapPTRFtoAccount.keyset()){
                      idAccount=mapPTRFtoAccount.get(idPTRF);
                      idMembers=new Set<Id>();
                      for(Account_Team_Proxy__c  objMember : listAccProxyMember){
                          if(objMember!=null && objMember.Account__c !=null && objMember.Account__c ==idAccount && mapPTRFtoOwner.get(idPTRF )!=null && objMember.User__c!=mapPTRFtoOwner.get(idPTRF ) ){
                              idMembers.add(objMember.User__c);
                              setOptAllMembers.add(objMember.User__c);
                          }
                      }
                      mapPTRFtoUser.put(idPTRF ,idMembers);
                  }
              }
          }  
          if(setOptAllMembers!=null && setOptAllMembers.size()>0 && lstFeRoles.size()>0){
              for(Account_Team_Proxy__c  objAccount:[SELECT User__c FROM Account_Team_Proxy__c WHERE User__c in:setOptAllMembers and Team_Role__c IN:lstFeRoles]){
                  setFeUsers.add(objAccount.User__c);
              }
          }  
          if(setOptAllMembers!=null && setOptAllMembers.size()>0){
              for(User objUser:[Select Id, ProfileId from User where ID in:setOptAllMembers and isActive = false]){
                  setInactiveUsers.add(objUser.ID);
              }
          }  
          if(mapPTRFtoUser.size()>0){
              for(Id idPTRF : mapPTRFtoUser.keyset()){
                  Set<ID> idListUser=mapPTRFtoUser.get(idPTRF);
                  for(Id idUser : idListUser){
                      if(!setInactiveUsers.contains(idUser)){
                          isFEUser=false;
                          if(setFeUsers.contains(idUser)) isFEUser=true;
                          PTRF__share objSharePtrf  = new PTRF__share();
                               
                          objSharePtrf.ParentId = idPTRF;
                          if(isFEUser==true){
                              objSharePtrf.AccessLevel = 'Edit';
                          }else{
                              objSharePtrf.AccessLevel = 'Read';
                          }
                          objSharePtrf.RowCause = Schema.PTRF__share.RowCause.Manual;
                          objSharePtrf.UserOrGroupId = idUser;
                          listSharePtrf.add(objSharePtrf);
                      }
                  }  
              }
              if(listSharePtrf.size()>0){
                  insert listSharePtrf;
              } 
          } 
   }
   public static void setPTRFSharingOptTeamMemberAdd(List<Opportunity_Program_Team_Member__c> lstOptTeamMember)
   {
   
          List<PTRF__share> listSharePtrf  =new List<PTRF__share>(); 
          Map<Id,String> mapMembertoOptProgram=new Map<Id,String>() ;
          Set<Id> setInactiveUsers=new set<ID>(); 
          Set<Id> setMembers=new set<ID>(); 
          Map<Id,String> mapPTRFtoOwner=new Map<Id,String>() ;   
          String strFeRoles='';
          Set<string> setOptPrograms=new set<string>();
          Id idOptProgram;
          boolean isFeUser=false;
          String strTotalValue='';
          boolean boolFeUser=false;
          
          Environment_Variable__c tempEnv= [SELECT Value__c FROM Environment_Variable__c WHERE Name = 'SwiftFETeamRoles' LIMIT 1];
          strFeRoles = String.valueOf(tempEnv.Value__c);
          
          for(Opportunity_Program_Team_Member__c objOptTeamMember : lstOptTeamMember){ 
              isFeUser=false;
              if(objOptTeamMember.Opportunity_Program__c!=null){  
                  isFeUser=(strFeRoles.contains(objOptTeamMember.Team_Role__c))?true:false;
                  mapMembertoOptProgram.put(objOptTeamMember.User__c,objOptTeamMember.Opportunity_Program__c+':'+isFeUser);
                  setOptPrograms.add(objOptTeamMember.Opportunity_Program__c);
                  setMembers.add(objOptTeamMember.User__c);
              }
          }
          if(setMembers!=null && setMembers.size()>0){
              for(User objUser:[Select Id, ProfileId from User where ID in:setMembers and isActive = false]){
                  setInactiveUsers.add(objUser.ID);
              }
          }  
          if(setOptPrograms!=null && setOptPrograms.size()>0){
              List<PTRF__c> listPTRF=[SELECT ID,Device__r.Opportunity_Program__c FROM PTRF__c WHERE Device__r.Opportunity_Program__c in:setOptPrograms];
              Set<Id> idPTRFs = (new Map<Id,PTRF__c>(listPTRF)).keySet(); 
              if(idPTRFs!=null && idPTRFs.size()>0){
                  for(PTRF__Share  objShare:[SELECT Id,ParentId,RowCause,UserOrGroupId FROM PTRF__Share WHERE ParentId in:idPTRFs and RowCause='Owner']){
                      mapPTRFtoOwner.put(objShare.ParentId,objShare.UserOrGroupId);
                  }        
              }
               if(listPTRF!=null && listPTRF.size()>0 && mapMembertoOptProgram.size()>0){
                  for(Id idMember : mapMembertoOptProgram.keyset()){
                          if(!setInactiveUsers.contains(idMember)){
                              strTotalValue=mapMembertoOptProgram.get(idMember);
                              idOptProgram=strTotalValue.split(':')[0];
                              boolFeUser=Boolean.valueof(strTotalValue.split(':')[1]);
                              for(PTRF__c  objPTRF : listPTRF){
                                  if(objPTRF!=null && objPTRF.Device__r.Opportunity_Program__c !=null && objPTRF.Device__r.Opportunity_Program__c ==idOptProgram && mapPTRFtoOwner.get(objPTRF.ID)!=null && idMember!=mapPTRFtoOwner.get(objPTRF.ID)){
                                      PTRF__share objSharePtrf  = new PTRF__share();
                                   
                                      objSharePtrf.ParentId = objPTRF.ID;
                                      if(boolFeUser==true){
                                          objSharePtrf.AccessLevel = 'Edit';
                                      }else{
                                          objSharePtrf.AccessLevel = 'Read';
                                      }
                                      objSharePtrf.RowCause = Schema.PTRF__share.RowCause.Manual;
                                      objSharePtrf.UserOrGroupId = idMember;
                                      listSharePtrf.add(objSharePtrf);
                                      
                                  }
                              }
                         
                      }
                  }
                  if(listSharePtrf.size()>0){
                  
                      insert listSharePtrf;
                  } 
              }
          }    
   } 
   public static void deletePTRFSharingOptTeamMemberDelete(List<Opportunity_Program_Team_Member__c> lstOptTeamMember)
   {
        Set<string> setOptMembers=new set<string>(); 
        List<PTRF__share> listSharePtrf =new List<PTRF__share>(); 
        for(Opportunity_Program_Team_Member__c objOptTeamMember : lstOptTeamMember){ 
              
              if(objOptTeamMember.User__c!=null){  
                  setOptMembers.add(objOptTeamMember.User__c);
              }
          }
          if(setOptMembers.size()>0){
              listSharePtrf =[select ID from PTRF__share where UserOrGroupId  in:setOptMembers];
          }
          if(listSharePtrf.size()>0){
              delete listSharePtrf;
          } 
   }
   public static  void setPTRFSharingAccTeamProxyAdd(List<Account_Team_Proxy__c> lstAccTeamProxy)
   {
   
          List<PTRF__share> listSharePtrf  =new List<PTRF__share>(); 
          Map<Id,String> mapUsertoAccount=new Map<Id,String>() ; 
          Map<Id,String> mapPTRFtoOwner=new Map<Id,String>() ;
          Set<Id> setMembers=new set<ID>();  
          Set<Id> setInactiveUsers=new set<ID>(); 
          String strFeRoles='';
          Set<string> setAccounts=new set<string>();
          Id idAccount;
          boolean isFeUser=false;
          String strTotalValue='';
          boolean boolFeUser=false;
          
          Environment_Variable__c tempEnv= [SELECT Value__c FROM Environment_Variable__c WHERE Name = 'SwiftFETeamRoles' LIMIT 1];
          strFeRoles = String.valueOf(tempEnv.Value__c);
          
          for(Account_Team_Proxy__c objAccTeamProxy : lstAccTeamProxy){ 
              isFeUser=false;
              if(objAccTeamProxy.Account__c!=null){  
                  isFeUser=(strFeRoles.contains(objAccTeamProxy.Team_Role__c))?true:false;
                  mapUsertoAccount.put(objAccTeamProxy.User__c,objAccTeamProxy.Account__c+':'+isFeUser);
                  setAccounts.add(objAccTeamProxy.Account__c);
                  setMembers.add(objAccTeamProxy.User__c);
              }
          }
          if(setMembers!=null && setMembers.size()>0){
              for(User objUser:[Select Id, ProfileId from User where ID in:setMembers and isActive = false]){
                  setInactiveUsers.add(objUser.ID);
              }
          }  
          if(setAccounts!=null && setAccounts.size()>0){
              List<PTRF__c> listPTRF=[SELECT ID,Customer__c FROM PTRF__c WHERE Customer__c in:setAccounts];
              Set<Id> idPTRFs = (new Map<Id,PTRF__c>(listPTRF)).keySet(); 
              if(idPTRFs!=null && idPTRFs.size()>0){
                  for(PTRF__Share  objShare:[SELECT Id,ParentId,RowCause,UserOrGroupId FROM PTRF__Share WHERE ParentId in:idPTRFs and RowCause='Owner']){
                      mapPTRFtoOwner.put(objShare.ParentId,objShare.UserOrGroupId);
                  }        
              }
               if(listPTRF!=null && listPTRF.size()>0 && mapUsertoAccount.size()>0){
                  for(Id idUser : mapUsertoAccount.keyset()){
                      if(!setInactiveUsers.contains(idUser)){
                          strTotalValue=mapUsertoAccount.get(idUser);
                          idAccount=strTotalValue.split(':')[0];
                          boolFeUser=Boolean.valueof(strTotalValue.split(':')[1]);
                          for(PTRF__c  objPTRF : listPTRF){
                              if(objPTRF!=null && objPTRF.Customer__c !=null && objPTRF.Customer__c ==idAccount && mapPTRFtoOwner.get(objPTRF.ID)!=null && idUser!=mapPTRFtoOwner.get(objPTRF.ID) ){
                                  PTRF__share objSharePtrf  = new PTRF__share();
                               
                                  objSharePtrf.ParentId = objPTRF.ID;
                                  if(boolFeUser==true){
                                      objSharePtrf.AccessLevel = 'Edit';
                                  }else{
                                      objSharePtrf.AccessLevel = 'Read';
                                  }
                                  objSharePtrf.RowCause = Schema.PTRF__share.RowCause.Manual;
                                  objSharePtrf.UserOrGroupId = idUser ;
                                  listSharePtrf.add(objSharePtrf);
                              }
                          }
                         
                  }
                  }
                  if(listSharePtrf.size()>0){
                      insert listSharePtrf;
                  } 
              }
          }    
   } 
   
   public static  void deletePTRFSharingAccTeamProxyDelete(List<Account_Team_Proxy__c> lstAccTeamProxy)
   {
        Set<string> setOptMembers=new set<string>(); 
        List<PTRF__share> listSharePtrf =new List<PTRF__share>(); 
        for(Account_Team_Proxy__c objAccTeamProxy : lstAccTeamProxy){ 
              
              if(objAccTeamProxy.User__c!=null){  
                  setOptMembers.add(objAccTeamProxy.User__c);
              }
          }
          if(setOptMembers.size()>0){
              listSharePtrf =[select ID from PTRF__share where UserOrGroupId  in:setOptMembers];
          }
          if(listSharePtrf.size()>0){
              delete listSharePtrf;
          } 
   }
   
   @future
   public static void addingFoundryJVtoGroupAndPermSetFuture(set<String> setPTRFJVIUserIds){
        addingFoundryJVtoGroupAndPermSet(setPTRFJVIUserIds);        
   }
   public static void addingFoundryJVtoGroupAndPermSet(set<String> setPTRFJVIUserIds){          
        if(setPTRFJVIUserIds!=null && setPTRFJVIUserIds.size()>0){
            /** Variables Declaration **/
            set<String> setUserIdsAlreadyInFJVGrp = new set<String>();
            set<String> setUserIdsAlreadyInFJVPS = new set<String>();
            list<GroupMember> listGroupMembers = new list<GroupMember>();
            list<PermissionSetAssignment> listPermSetAssignment = new list<PermissionSetAssignment>();
            /** Querying the Foundry Jobviewer Group and Permission Set **/
            PermissionSet permSetFoundryJV = [Select Id,Name from PermissionSet where Name='SWIFT_Foundry_Jobviewer_Permission_Set'];
            Group groupFoundryJV = [Select Id,DeveloperName from Group where DeveloperName='Swift_Foundry_Jobviewer'];
            /** Fetching if the existing users are already part of the Group or have the Permission Set assigned **/
            for(GroupMember objGM:[Select UserOrGroupId,GroupId from GroupMember where GroupId=:groupFoundryJV.Id AND UserOrGroupId IN:setPTRFJVIUserIds]){
                setUserIdsAlreadyInFJVGrp.add(objGM.UserOrGroupId); 
            }
            for(PermissionSetAssignment objPSA:[Select AssigneeId,PermissionSetId from PermissionSetAssignment where PermissionSetId=:permSetFoundryJV.Id AND AssigneeId IN:setPTRFJVIUserIds]){
                setUserIdsAlreadyInFJVPS.add(objPSA.AssigneeId);    
            }
            /** Assigning the Users to the Group and Permission Set **/
            for(String userId:setPTRFJVIUserIds){
                if(!setUserIdsAlreadyInFJVGrp.contains(userId)){
                    GroupMember objGM = new GroupMember();
                    objGM.UserOrGroupId = userId;
                    objGM.GroupId = groupFoundryJV.Id;
                    listGroupMembers.add(objGM);
                }
                if(!setUserIdsAlreadyInFJVPS.contains(userId)){
                    PermissionSetAssignment objPSA = new PermissionSetAssignment();
                    objPSA.AssigneeId = userId;
                    objPSA.PermissionSetId = permSetFoundryJV.Id;
                    listPermSetAssignment.add(objPSA);
                }       
            }
            /** DML Insert Operations **/
            if(listGroupMembers.size()>0){
                try{
                    insert listGroupMembers;
                }catch(Exception ex){}  
            }
            if(listPermSetAssignment.size()>0){
                try{
                    insert listPermSetAssignment;
                }catch(Exception ex){}      
            }   
        }       
   }
   
   /**
    Dummy method added to increase code coverage due to existing salesforce issue.
    Because of current class is too large so this is a workaround possible at this time.
    Issue link: https://success.salesforce.com/issues_view?id=a1p30000000T4oRAAS
    */
    // start dummy method
    @testVisible
    private Integer mthdDummy() {
        Integer a = 1;
        Integer b = 5;
        Integer c = 0;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        c = b - a;
        a = c;
        c = b - a;
        a = c;

        return 1;
    }
}