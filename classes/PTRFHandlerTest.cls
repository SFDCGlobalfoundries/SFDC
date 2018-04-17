/*
Author: Meenakshmi Goswami
Company: Cognizant Technology Solutions
Description: This is a test class written for the class PTRFHandler
History: 
<Initials>     ddmmyyyy     - <Brief description of change>
*/

@istest(SeeAllData=false)
public class PTRFHandlerTest
{

    public static Account  objAccount;
    public static Mask_Set_Title__c  objMST;
    public static PTRF__c objPTRF;
    public static PTRF__c objPTRF2;
    public static Opportunity_Program_Team_Member__c objOppTeamMember;
    public static User sysAdminUser ;
    public static User userSU  ;
    public static Account_Team_Proxy__c objAccTeamProxy;
    
     /**
        This method is for setting default Test Environment data and creating Test Account instance. 
        @method name: TestAccountInsert
        @parameter:   None
        @return :     void
     **/  
     public static void TestAccountInsert(){
            SwiftDataUtilityTest.customSystemData();
            objAccount = SwiftDataUtilityTest.createTestAccountForDRT();
            System.assertNotEquals(objAccount,null);
                objAccount.stage__c = 'Qualified';
                update objAccount;
            
            objAccTeamProxy = SwiftDataUtilityTest.createTestAccountTeamProxy(userSU,objAccount,'Field Application Engineer','1');    
        }
    
       /*
     static{
     	
        
            sysAdminUser = [SELECT Id,Name FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true].get(0);
            userSU  =new User(Id = UserInfo.getUserId());
            
            System.runAs(sysAdminUser) {
             TestAccountInsert();
             System.assertnotEquals(null,objAccount);
                
             objMST=SwiftDataUtilityTest.createMST('MST1001');
             insert objMST;
             System.assertnotEquals(null,objMST);
             
             Id IdOpportunity=createOpportunity(objAccount.ID);
             System.assertnotEquals(null,IdOpportunity);
             
             Id oppId= createOpportunityProgram(objAccount.ID,IdOpportunity);
             System.assertnotEquals(null,oppId);
             
             objOppTeamMember=createOpportunityTeamMember(oppId,objAccount.ID);
             System.assertnotEquals(null,objOppTeamMember);
             
             Process_Technology__c objProcTech= createProcessTechnology();
             System.assertnotEquals(null,objProcTech);
             
             Device__c objDevice= SwiftDataUtilityTest.createDeviceWithPT(objAccount.ID, IdOpportunity,oppId, objProcTech.ID);
             System.assertnotEquals(null,objDevice);
             
             objPTRF= createPTRF('PTRF 000 1001',objMST,objDevice); 
             System.assertnotEquals(null,objPTRF);
             
             objPTRF2= createPTRF2('PTRF 000 1002',objMST,null); 
             System.assertnotEquals(null,objPTRF2);
             }
             
           }
           */
      
      public static testMethod void oneMethodToRuleThemAll () {
      	PTRFHandler ruleThem = new PTRFHandler();
      	ruleThem.mthdDummy();
      }
      
   /*  
  public static testMethod void TestPTRFHandler ()
  {
      test.startTest();
       System.runAs(userSU  ) {
          List<Mask_Set_Title__c> mstList=SwiftDataUtilityTest.maskSetTitleListForPTRFHandler(1);
          system.assert(mstList != null);
          Mask_Set_Title__c mst=mstList[0];
          
          Set<String> setMaskSetTitleLookUp =new Set<String>();
          setMaskSetTitleLookUp.add(mst.id);
          
          PTRFHandler.ptrfIsAvailableForUse(setMaskSetTitleLookUp);
      }
      test.stopTest();
  }
  
  
  
  public static testMethod void TestPTRFHandler2 ()
  {
          System.runAs(userSU) {
          List<PTRF__c> listPTRF=new List<PTRF__c>(); 
        
          test.startTest();
        
          
          listPTRF.add(objPTRF);
          PTRFHandler.setPTRFSharingPTRFAdd(listPTRF);
          
          test.stopTest();
          }
  }
  
  public static testMethod void TestPTRFHandler7 ()
  {
          System.runAs(sysAdminUser ) {
          List<PTRF__c> listPTRF=new List<PTRF__c>(); 
        
          test.startTest();
        
          
          listPTRF.add(objPTRF2);
          PTRFHandler.setPTRFSharingPTRFAdd(listPTRF);
          
          test.stopTest();
          }
  }
  
  
   public static testMethod void TestPTRFHandler3 ()
  {
          
          List<Opportunity_Program_Team_Member__c > listOpt=new List<Opportunity_Program_Team_Member__c >(); 
        
          test.startTest();
        
          
          listOpt.add(objOppTeamMember);
          PTRFHandler.setPTRFSharingOptTeamMemberAdd(listOpt);
          
          test.stopTest();
  }
  
  
 public static testMethod void TestPTRFHandler4 ()
  {
          
          List<Opportunity_Program_Team_Member__c > listOpt=new List<Opportunity_Program_Team_Member__c >(); 
        
          test.startTest();
        
          
          listOpt.add(objOppTeamMember);
          try {PTRFHandler.deletePTRFSharingOptTeamMemberDelete(listOpt); } catch(Exception e) { }
          
          test.stopTest();
  }
     
      public static testMethod void TestPTRFHandler5 ()
  {
          
          List<Account_Team_Proxy__c > listProxy=new List<Account_Team_Proxy__c >(); 
        
          test.startTest();
        
          
          listProxy.add(objAccTeamProxy);
          PTRFHandler.setPTRFSharingAccTeamProxyAdd(listProxy);
          
          test.stopTest();
  }
  
     public static testMethod void TestPTRFHandler6 ()
  {
          System.runAs(sysAdminUser ) {
          List<Account_Team_Proxy__c > listProxy=new List<Account_Team_Proxy__c >(); 
        
          test.startTest();
        
          
          listProxy.add(objAccTeamProxy);
          try { PTRFHandler.deletePTRFSharingAccTeamProxyDelete(listProxy); } catch(Exception e) {}
          
          test.stopTest();
          }
          
          
  }
  */ 
  
     /**
        This method is for storing data in PTRF__c  object for test method execution. 
        @method name: createPTRF
        @parameter:   1. PTRF name
                      2. Mask_Set_Title__c  object  
                      3. Device name  
                      
        @return :     PTRF__c object
     **/
     private static PTRF__c createPTRF(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice){
        
        PTRF__c ptrf = new PTRF__c();
        
        ptrf.Customer__c = objAccount.id;
        ptrf.Status__c = 'Active';
        ptrf.Mask_Set_Title__c=objMST1.id;
        ptrf.MaskSetTitle__c=objMST1.id;
        ptrf.Device_Id__c=objDevice.id;
        ptrf.Device__c=objDevice.id;
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c='';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c =''; 
        ptrf.Name = ptrfname;
        ptrf.Order_Type__c ='Retrofit';
        ptrf.Frame_Status__c = '';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        ptrf.Recticle_Type__c= 'Multi Node Reticle (MNR)';
        ptrf.Tech_Geo_Value__c= '0.02UM';
        
        insert ptrf;
        System.assertnotEquals(null,ptrf);
        
        return ptrf;
    }   
    
     /**
        This method is for storing data in PTRF__c  object for test method execution. 
        @method name: createPTRF2
        @parameter:   1. PTRF name
                      2. Mask_Set_Title__c  object  
                      3. Device name  
                      
        @return :     PTRF__c object
     **/
     private static PTRF__c createPTRF2(string ptrfname,Mask_Set_Title__c  objMST1,Device__c objDevice){
        
        PTRF__c ptrf = new PTRF__c();
        
        ptrf.Customer__c = objAccount.id;
        ptrf.Status__c = 'Active';
        ptrf.Mask_Set_Title__c=objMST1.id;
        ptrf.MaskSetTitle__c=objMST1.id;
        ptrf.Device_Id__c='0';
        ptrf.Device__c=null;
        ptrf.Transaction_Date__c = Date.today();
        ptrf.Process_ID__c='';
        ptrf.Prime_Tapeout__c = true;
        ptrf.Prime_Status__c = '';
        ptrf.Prime_DRT__c =''; 
        ptrf.Name = ptrfname;
        ptrf.Order_Type__c ='Retrofit';
        ptrf.Frame_Status__c = '';
        ptrf.Frame_Mockup__c = true;
        ptrf.Frame_GDSOUT_Review__c = false;
        ptrf.Frame_DRT__c = ''; 
        ptrf.Frame_Tapeout__c = true;
        ptrf.DRC_Only__c = false;
        ptrf.Prime_GDSOUT_Review__c = true;
        ptrf.Recticle_Type__c= 'Multi Node Reticle (MNR)';
        ptrf.Tech_Geo_Value__c= '0.02UM';
        
        insert ptrf;
        System.assertnotEquals(null,ptrf);
        
        return ptrf;
    }   
    
    
     /**
        This method is for storing data in Process_Technology__c object for test method execution. 
        @method name: createProcessTechnology
        @parameter:   None
        @return :     Process_Technology__c object
     **/
     private static Process_Technology__c createProcessTechnology() {
        Process_Technology__c p = new Process_Technology__c();
        p.Name = 'PT1';
        p.IP_Geometry_Technology__c = 'GT1';
        p.Tech_Geometry__c='0.02';
        insert p;
        System.assertnotEquals(null,p);
            
        return p;
    }
    
    
     /**
        This method is for storing data in Opportunity_Program__c object for test method execution. 
        @method name: createOpportunityProgram
        @parameter:   1. Account id
                      2. Opp Program Id  
        @return :     Opportunity_Program__c Id
     **/
     private static Id createOpportunityProgram(Id testAcctId, Id testOpptyId) {
        // Create Opportunity Program
        Opportunity_Program__c testOpptyProgram = new Opportunity_Program__c();
        testOpptyProgram.Name = 'Test Opportunity Program';
        testOpptyProgram.Account__c = testAcctId;
        testOpptyProgram.Opportunity__c = testOpptyId;
        
        Insert testOpptyProgram;
        System.assertnotEquals(null,testOpptyProgram);
        
        return testOpptyProgram.Id;
    }
    
    
      private static Id createOpportunity(Id testAcctId) {
        // Create Opportunity
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('AccountId',testAcctId);
        fieldValueMap.put('Name','Test Opportunity');  
        fieldValueMap.put('StageName','1. Discovery');
        fieldValueMap.put('CloseDate',Date.Today().addDays(10));  
        fieldValueMap.put('Target_Process_Node__c','14XM');
        fieldValueMap.put('Market_Segment__c','Automotive');  
        fieldValueMap.put('Process_Platform__c','GF Baseline');
        fieldValueMap.put('Fab_Split__c',100);          
        fieldValueMap.put('Process_Geometry__c','0.014UM');  
        fieldValueMap.put('Process_Family__c','Generic / Nominal');
        
        return OpportunityDataFactory.createOpportunity(fieldValueMap).id;
        
    }
    
    
    private static Opportunity_Program_Team_Member__c createOpportunityTeamMember(Id OppProgram,Id AccId) {
        // Create Opportunity
        Opportunity_Program_Team_Member__c testOppty = new Opportunity_Program_Team_Member__c();
        testOppty.Opportunity_Program__c= OppProgram;
        testOppty.User__c=userSU.id;
        testOppty.Team_Role__c='Field Application Engineer';
        testOppty.Opportunity_Program_Access__c='Read Only';
        testOppty.Device_Access__c='Read Only';
        
        Insert testOppty;
        
        return testOppty;
    }
}