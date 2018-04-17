/*
  Author: Anirban Roy
  Description: Opportunity Program Team Member controller class.
  History:
    ARoy  02182013  - code creation.
    VBharadwaj 06122013
*/

public class OppTeamMemberController {

        public List<OppProgramTeamMemberModel> OppProgramTMModelList{get;set;}
        public string contentIds{get;set;}
        public string OppProgramName{get;set;}
        public boolean editPer{get;set;}
        public final string Key;        
        Map<String, Opportunity_Program_Team_Member__c> opMap = new Map<String, Opportunity_Program_Team_Member__c>();
        public class OppProgramTeamMemberModel{
          public Opportunity_Program_Team_Member__c OPTM {get;set;}
        }
        
        public OppTeamMemberController(){
                
                
                OppProgramTMModelList=new List<OppProgramTeamMemberModel>();
                opMap = new Map<String, Opportunity_Program_Team_Member__c>();
                contentIds=apexpages.currentpage().getparameters().get('id');
            if(contentIds !=null)
            {
                Opportunity_Program__c oppPrg = [select name, Account__c from Opportunity_Program__c where id=:contentIds];
                OppProgramName = oppPrg.Name;
                key = oppPrg.Account__c;                
                for(Opportunity_Program_Team_Member__c oppPrgmTM : [SELECT Core_Team_Member__c,Device_Access__c,Id,Name,
                                        Opportunity_Program_Access__c,Opportunity_Program__c,SystemModstamp,Team_Role__c,
                                        User__c,User__r.Name,Flag_for_Delete__c,Is_FAE__c
                                        FROM Opportunity_Program_Team_Member__c 
                                        WHERE Opportunity_Program__c =:contentIds 
                                        ORDER BY Core_Team_Member__c desc])
                {
                 OppProgramTeamMemberModel optmMod = new OppProgramTeamMemberModel();
                 optmMod.OPTM=oppPrgmTM;
                 OppProgramTMModelList.add(optmMod);
                }
            }
            
            isEdit();
            if(editPer){
                addNewRow();
            }
                
        }
        
        public PageReference addNewRow(){
            Opportunity_Program_Team_Member__c optmTemp = new Opportunity_Program_Team_Member__c();
            OppProgramTeamMemberModel optmMod = new OppProgramTeamMemberModel();
            optmMod.OPTM=optmTemp;
            OppProgramTMModelList.add(optmMod);
            return null;
        }
        
        public void isEdit(){
            editPer = false;
            Id profileId = UserInfo.getProfileId();
            Profile prof = [select id,name from Profile where id = :profileId limit 1];
            /*Vixit to add the additional Profile as per Case No. 3229 */
            if(prof.Name=='System Administrator' || prof.Name=='GF System Admin' || prof.Name=='GF Global Admin' ){
                editPer = true;
            }
            else{               
                for(Opportunity_Program__Share oppPrgmSh : [select AccessLevel,Id,ParentId,RowCause,UserOrGroupId 
                                            from Opportunity_Program__Share
                                             where ParentId =:contentIds
                                                and UserOrGroupId= :UserInfo.getUserId()]){
                    if(oppPrgmSh!=null){
                        if(oppPrgmSh.AccessLevel=='Read'){
                            editPer=false;
                        }
                        else if(oppPrgmSh.AccessLevel=='Edit' || oppPrgmSh.AccessLevel=='All'){
                            editPer=true;
                        }
                    }
                    else{
                        editPer=false;
                    }
                                                
                }
            }
        }
    
    public PageReference Save(){
        
       try{
            opMap = new Map<String, Opportunity_Program_Team_Member__c>();
            PageReference opPage = new PageReference('/'+ contentIds);
            List<Opportunity_Program_Team_Member__c> optm = new List<Opportunity_Program_Team_Member__c>();
            List<Opportunity_Program_Team_Member__c> optmDel = new List<Opportunity_Program_Team_Member__c>();
            for(OppProgramTeamMemberModel optml :OppProgramTMModelList)
            {
                if(optml.OPTM.User__c !=null)
                {
                            if (optml.OPTM.Opportunity_Program_Access__c==null )
                            {
                                optml.OPTM.addError('Please specify Opportunity Program Access');
                            }
                        
                            if (optml.OPTM.Device_Access__c==null )
                            {
                                optml.OPTM.addError('Please specify Device Access');
                            }
                         
                            if (optml.OPTM.Team_Role__c==null )
                            {
                                optml.OPTM.addError('Please specify Team Role');
                                return null;                                
                            }                           
                        
                        if(optml.OPTM.Opportunity_Program__c ==null){
                                optml.OPTM.Opportunity_Program__c=contentIds;
                        }
            
                        optml.OPTM.ExternalUserKeyField__c = key  + '_' + optml.OPTM.User__c ;
                                    
                        if( optml.OPTM.Team_Role__c == 'Primary Account Manager' || 
                            optml.OPTM.Team_Role__c == 'Primary Customer Service Rep' || 
                            optml.OPTM.Team_Role__c == 'Backup Customer Service Rep' || 
                            optml.OPTM.Team_Role__c == 'Primary Field Engineer'){
                            if (opMap.containsKey(optml.OPTM.Team_Role__c+optml.OPTM.Opportunity_Program__c))
                            {
                                optml.OPTM.addError('Role and Seq duplicates.');
                                return null;
                            } 
                            else
                            {
                                opMap.put(optml.OPTM.Team_Role__c+optml.OPTM.Opportunity_Program__c, optml.OPTM);
                            }
                        }
                        
                        //------Start of duplicate check of user for same opportunity program----//
                        if(opMap.containsKey(optml.OPTM.User__c)){
                            optml.OPTM.addError('Duplicate User for same Opportunity Program');
                            return null;
                        }
                        else{
                            opMap.put(optml.OPTM.User__c,optml.OPTM);
                        }
                        //----End of duplicate check of user for same opportunity program----//
                                  
                        //Njain: reset the is FAE flag if the Role is changed from Account Manager
                        if( optml.OPTM != NULL && optml.OPTM.Id != NULL && 
                            optml.OPTM.Team_Role__c != 'Account Manager' && 
                            optml.OPTM.Team_Role__c != 'Primary Account Manager'){
                                optml.OPTM.Is_FAE__c = false;
                        }
                        
                        if(optml.OPTM.Flag_for_Delete__c){
                            optmDel.add(optml.OPTM);
                        }                                      
                        else{
                            optm.add(optml.OPTM);
                        }
                }    
            }
            if(optm!=null && optm.size()>0){
                upsert optm;
            }
            if(optmDel!=null && optmDel.size()>0){
                delete optmDel;
            }          
            return opPage;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());  
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
}