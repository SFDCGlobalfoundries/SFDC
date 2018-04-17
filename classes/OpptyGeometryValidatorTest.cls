/*Test class for ConfigurationValidator helper apex class*/

@isTest
public class OpptyGeometryValidatorTest
{
public static Id acc;
public static Id opp;
public static string processId;
public static Device__c dev=new Device__c();


@testSetup static void testdata() 
    {
        DataUtilTest.loadEnvironmentVariables();
        acc=DeviceUtilTest.createAccount();
        opp=DeviceUtilTest.createOpp(acc,'0.014UM');
        test.startTest();
        dev=createDevice(acc,opp,'0.014UM','On Hold');
        
        createConfig(dev.id);
        test.stopTest();
    }
    
    
    public static Device__c createDevice(string acctId,string opptyId,string geometry,string status) 
    {
         
        string opptyProgramId = DeviceUtilTest.createOppProg(acctId, opptyId);
        string mpwId = DeviceUtilTest.createMPWTrainMnt();
        processId = DeviceUtilTest.createProcess('0.014UM');
        //string processTechnologyId = DeviceUtilTest.createProcessTechnology();
        String MSTId = DeviceUtilTest.createMaskSetTtitle();
        string MSTAccId = DeviceUtilTest.createMSTAccount(acctId,MSTId);
        Map<String,Object> fieldValueMap = new Map<String,Object>();
        fieldValueMap.put('Account__c',acctId); 
        fieldValueMap.put('Name','TESTDEVICE');
        fieldValueMap.put('Opportunity2__c',opptyId);
        fieldValueMap.put('Opportunity_Program__c',opptyProgramId);
        fieldValueMap.put('Fab__c','FAB 2');
        fieldValueMap.put('Internal_Device_Geometry__c','0.014UM');
        fieldValueMap.put('Internal_Device_Process_Family__c','Generic / Nominal');
        fieldValueMap.put('GSOP_Assignment_Tapeout_Plan__c','No');
        fieldValueMap.put('Market_Segment__c','Automotive');
        fieldValueMap.put('Semiconductor_Device__c','Analog Amplifier');
        fieldValueMap.put('End_Customer__c','Test Customer');
        fieldValueMap.put('Device_Sourcing__c','1st Source');
        fieldValueMap.put('Stage__c','Design In');
        fieldValueMap.put('Status__c',status);
        fieldValueMap.put('Siebel_Device_ID__c','1234567890');
        fieldValueMap.put('Tapeout_Type__c','Customer MPW'); 
        fieldValueMap.put('PLM_Device_ID__c','ANBQP60ACO8CH-U01');
        fieldValueMap.put('Device_Mask_Set_Title__c','MSTTRT1');
        fieldValueMap.put('CRMDID__c','CDID0000001.00');
        fieldValueMap.put('Original_Forecasted_Tapeout_Date__c',date.newInstance(2013,5,20));
        fieldValueMap.put('Device_Type__c','Base');
        fieldValueMap.put('End_Application__c','Body');
        fieldValueMap.put('Reason_For_Status_On_Hold__c','Test');
        fieldValueMap.put('Confidence_Level_Tapeout__c','50');
        return DeviceDataFactory.createDevice(fieldValueMap);
        
    }
   
    
  
    
    public static void createConfig(String devid)
    {
        
        
        
       Apttus_Proposal__Proposal__c testcon=new Apttus_Proposal__Proposal__c();
       testcon.Apttus_Proposal__Proposal_Name__c='TestConfig';
       testcon.Apttus_Proposal__Primary__c=true;
       testcon.Apttus_Proposal__Approval_Stage__c='Draft';
       testcon.Apttus_Proposal__Account__c=acc;
       testcon.Apttus_Proposal__Opportunity__c=opp;
       testcon.Device__c=devid;
       testcon.Assigned_Process_ID__c=DeviceUtilTest.createProcess('0.014UM'); 
       
       insert testcon;
        
    }
    
    
      
    
    
     static testmethod void Testfunc()
     {   
        
        
        
        
        test.startTest();
        
        Apttus_Proposal__Proposal__c testvar=[Select id,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c limit 1];
        testvar.Apttus_Proposal__Approval_Stage__c='Process Flow Accepted';
        try{      
            update testvar;
         }catch(Exception ex){}   
        
        
        testvar=[Select id,Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Opportunity__c  from Apttus_Proposal__Proposal__c where id=:testvar.id];
        Opportunity testvar1=[Select id ,Apttus_Configuration_Score__c from Opportunity];
        
        
        testvar.Apttus_Proposal__Approval_Stage__c='Draft';
           
        update testvar;
        
        testvar=[Select id,Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Opportunity__c  from Apttus_Proposal__Proposal__c where id=:testvar.id];
        Opportunity testvar2=[Select id ,Apttus_Configuration_Score__c from Opportunity where id =: testvar.Apttus_Proposal__Opportunity__c ];
        
        
        testvar.Device__c=NULL;
        
        
        update testvar;
        
        testvar=[Select id,Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Opportunity__c  from Apttus_Proposal__Proposal__c where id=:testvar.id];
        Opportunity testvar3=[Select id ,Apttus_Configuration_Score__c from Opportunity where id =: testvar.Apttus_Proposal__Opportunity__c ];
        
        
        
        testvar.Device__c=dev.id;
        testvar.Apttus_Proposal__Opportunity__c =NULL;
        
        
        update testvar;
        
        testvar=[Select id,Apttus_Proposal__Approval_Stage__c,Apttus_Proposal__Opportunity__c  from Apttus_Proposal__Proposal__c where id=:testvar.id];
        Opportunity testvar4=[Select id ,Apttus_Configuration_Score__c from Opportunity where id =: testvar3.id ];
        
        
        test.stopTest();
        
        
        //System.assertEquals(5,testvar2.Apttus_Configuration_Score__c);
       // System.assertEquals(5,testvar3.Apttus_Configuration_Score__c);
        
      //  System.assertEquals(5,testvar4.Apttus_Configuration_Score__c);
        
        
    
   }
    

 }