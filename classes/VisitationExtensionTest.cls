/*
    Author: Mallika Seth
    Description: This is the util class is for the Device Creation.  
    History:
        MSETH    03062016    - code creation.  
        Vvemuru  07212016    - added method for VREG workspace links
*/

@isTest(SeeAllData=false)
public class VisitationExtensionTest {
 
    public static Id createCVA(id accid){
        Visitation_Record__c CVA = new Visitation_Record__c();
        CVA.Account__c = accid;
        CVA.Visit_Name__c = 'Test';
        CVA.Visit_Type__c = 'Visit from Customer';
        CVA.Start_Date__c = System.Today().addDays(1);
        CVA.End_Date__c = System.Today().addDays(3);
        CVA.Purpose__c = 'QBR';
        CVA.Visit_Location__c = 'Singapore';
        insert CVA;
        return CVA.Id;
    }  
    
    
    
    
    
    @testSetup static void testdata(){
        DataUtilTest.loadEnvironmentVariables();
        
        Map<String,Object> fieldValueMap = new Map<String,Object>();       
        fieldValueMap.put('Name', (Label.Visitation_Internal_Account_Name != null) ? Label.Visitation_Internal_Account_Name:'GLOBALFOUNDRIES INTERNAL');
        fieldValueMap.put('Stage__c', 'Unqualified');
        fieldValueMap.put('Short_Name__c', 'test725');
        fieldValueMap.put('Site_Department__c', 'cts.com');
        fieldValueMap.put('Account_Type__c', 'Customer');
        fieldValueMap.put('Organization_Unit__c', 'sg;us');
        fieldValueMap.put('Copy_Address__c', true);
        fieldValueMap.put('Corporate_Address_1__c', 'test');
        fieldValueMap.put('Corporate_City__c', 'sg');
        fieldValueMap.put('Corporate_Country__c', 'sg');        
        fieldValueMap.put('Financial_Territory__c', 'Greater China');
        fieldValueMap.put('Region__c', 'APJ');
        fieldValueMap.put('Sub_Type__c', 'Direct');
        fieldValueMap.put('Transaction_Type__c', 'Transactional');
        fieldValueMap.put('recordtypeid', EnvironmentVariable.get('ACCT_RT_ID_RESELLER'));
        fieldValueMap.put('Account_Profile__c', 'Fabless - Emerging');
        fieldValueMap.put('Corporate_Postal_Zip_Code__c', '700007');
        fieldValueMap.put('Fab_9_10__c', 'No');
                
        AccountDataFactory.createAccount(fieldValueMap);
        }
    
    static testmethod void TestVisitation(){
    test.startTest();
    String AccId = [SELECT id from Account LIMIT 1].id;
    
    String CVAId = VisitationExtensionTest.createCVA(AccId);
    Test.stoptest();
        Visitation_Record__c CVA = new Visitation_Record__c();
        CVA.Account__c = AccId;
        CVA.Visit_Name__c = 'Test';
        CVA.Visit_Type__c = 'Visit from Customer';
        CVA.Add_as_attendee_Escort__c = TRUE;
        CVA.Add_as_attendee_Requestor__c =TRUE;
        CVA.Add_as_attendee_Host__c = TRUE;
        CVA.Start_Date__c = System.Today().addDays(1);
        CVA.End_Date__c = System.Today().addDays(3);
        CVA.Purpose__c = 'QBR';
        CVA.Visit_Location__c = 'Singapore';
        insert CVA;
        Visitation_Attendee__c VA = new Visitation_Attendee__c();
        VA.Name ='Test';
        VA.Visitation__c = CVA.Id;
        VA.Type_of_attendee__c = 'Partner Attendee';
        insert VA;
        
    VisitationExtension Visitation11= new VisitationExtension( new ApexPages.StandardController(new Visitation_Record__c())); 
    ApexPages.StandardController sc = new ApexPages.StandardController(CVA);
    VisitationExtension Visitation= new VisitationExtension(sc); 
    PageReference pageRef = Page.Visitation_Tabs;
    pageRef.getParameters().put('id', String.valueOf(CVA.Id));
    Test.setCurrentPage(pageRef);
    
    Visitation.GeneratePDF();
    Visitation.LogisticAdmin();
    Visitation.EditButton();
    Visitation.EditButtonMisc();
    Visitation.EditButtonDetail();
    Visitation.SaveButtonDetail();
    Visitation.SaveButton();
    Visitation.SaveButtonMisc();
    visitation.checkExecutives();
    ApexPages.StandardController sc1 = new ApexPages.StandardController(CVA);
    apexpages.currentPage().getparameters().put('id',CVA.id);
    VisitationExtension Visitation1= new VisitationExtension(sc1);
    
    Visitation1.VREGApplication();
    Visitation1.Link_to_GUI_US();
    Visitation1.Link_to_GUI_Europe();
    Visitation1.Link_to_GUI_Singapore();
    }
    
    static testmethod void TestVisitation2(){
     String AccId = [SELECT id from Account LIMIT 1].id;
      User U = [SELECT Id FROM User WHERE Name='Magnus Lindqvist'];
        contact con  = new contact(firstname='first',lastname='last',accountid=AccId,phone='9876543210',email='testmail@test.com');
        insert con;
        Visitation_Record__c CVA = new Visitation_Record__c();
        CVA.Account__c = AccId;
        CVA.Visit_Name__c = 'Test';
        CVA.Visit_Type__c = 'Visit from Customer';
        CVA.Visitation_Host__c = U.Id;
        CVA.Requestor__c = Userinfo.getuserId();
        CVA.Escort__c =  U.Id;
        CVA.Add_as_attendee_Escort__c = TRUE;
        CVA.Add_as_attendee_Requestor__c =TRUE;
        CVA.Add_as_attendee_Host__c = TRUE;
        CVA.Start_Date__c = System.Today().addDays(1);
        CVA.End_Date__c = System.Today().addDays(3);
        CVA.Purpose__c = 'QBR';
        CVA.Visit_Location__c = 'Singapore';
        insert CVA;
        List<Visitation_Attendee__c> attList = new List<Visitation_Attendee__c>();
        Visitation_Attendee__c VA = new Visitation_Attendee__c();
        VA.Name ='Test';
        VA.Visitation__c = CVA.Id;
        VA.User__c = u.id;
        VA.Type_of_attendee__c = 'Partner Attendee';
        attList.add(VA);
        
       
        Visitation_Attendee__c VA11 = new Visitation_Attendee__c();
        VA11.Name ='Test';
        VA11.Visitation__c = CVA.Id;
        VA11.User__c = u.id;
        VA11.Type_of_attendee__c = 'Partner Attendee';
        attList.add(VA11);
        
        Visitation_Attendee__c VA2 = new Visitation_Attendee__c();
        VA2.Name ='Test';
        VA2.Visitation__c = CVA.Id;
        VA2.User__c = u.id;
        VA2.Type_of_attendee__c = 'GF Attendee';
        attList.add(VA2);
        
        Visitation_Attendee__c VA3 = new Visitation_Attendee__c();
        VA3.Name ='Test';
        VA3.Visitation__c = CVA.Id;
        VA3.User__c = u.id;
        VA3.Type_of_attendee__c = 'Customer Attendee';
        attList.add(VA3);
        
         Visitation_Attendee__c VA31 = new Visitation_Attendee__c();
        VA31.Name ='Test';
        VA31.Visitation__c = CVA.Id;
        VA31.User__c = u.id;
        VA31.Type_of_attendee__c = 'Customer Attendee';
        attList.add(VA31);
        
        Visitation_Attendee__c VA4 = new Visitation_Attendee__c();
        VA4.Name ='Test';
        VA4.Visitation__c = CVA.Id;
        VA4.User__c = u.id;
        VA4.attendee__c = con.id;
        VA4.Type_of_attendee__c = 'GF Executive';
        attList.add(VA4);
        Visitation_Attendee__c VA5 = new Visitation_Attendee__c();
        VA5.Name ='Test';
        VA5.Visitation__c = CVA.Id;
        VA5.User__c = u.id;
        VA5.attendee__c = con.id;
        VA5.Type_of_attendee__c = 'GF Executive';
        attList.add(VA5);
        
        insert attList;
       // insert new Logistic_Admin__c(Name ='Singapore',Visit_Location__c ='Singapore');
    
    ApexPages.StandardController sc = new ApexPages.StandardController(CVA);
    VisitationExtension Visitation= new VisitationExtension(sc); 
    Visitation.FlagAddHost = True;
    Visitation.FlagAddRequestor = True;
    Visitation.FlagAddEscort = True;
    PageReference pageRef = Page.Visitation_Tabs;
    pageRef.getParameters().put('id', String.valueOf(CVA.Id));
    Test.setCurrentPage(pageRef);
    Visitation= new VisitationExtension(sc); 
    visitation.gfAccount = new account();
    visitation.removeKey ='0';
    Visitation.AddAttendee();
    visitation.onLoadVisitation();
    Visitation.AddAttendee();
    visitation.editButtonAttendees();
    visitation.addGFtoMap();
    visitation.addPAtoMap();
    visitation.addCAtoMap();
    visitation.addExcutivetoMap();
    visitation.removeExecutivefromMap();
    visitation.removegfAttendeefromMap();
    visitation.removecustomerAttendeefromMap();
    visitation.removePartnerAttendeefromMap();
    visitation.addExcutive();
    
    account acc = visitation.gfAccount;
    List<Visitation_Attendee__c> gfExecutives = visitation.gfExecutives;
    List<Visitation_Attendee__c> customerAttendees  = visitation.customerAttendees;
    List<Visitation_Attendee__c> partnerAttendees  = visitation.partnerAttendees;
    visitation.contactInstance = new contact(firstname='first',lastname='last',phone='9876543210',email='a@test.com');
    visitation.createContact();
    visitation.contactInstance = new contact();
    visitation.createContact();
    visitation.export();
    visitation.ITARConfidential();
    visitation.mapAttendees = new  Map<String, Visitation_Attendee__c>();
    visitation.mapAttendees.put('0',VA);
    visitation.mapAttendees.put('1',VA2);
    visitation.mapAttendees.put('2',VA3);
    visitation.AddExecutive();
    visitation.saveAttendees();
    set<string> temp1 = visitation.mapAttendeesSet;    
    set<string> temp2 = visitation.mapGFAttendeesSet;    
    set<string> temp3 = visitation.mapCustomerAttendeesSet;
    Contact contactInstance  = visitation.contactInstance;
    visitation.mapAttendees = new map<string,visitation_attendee__c>();
    list<selectoption> ExecNames = visitation.ExecNames;
    list<selectoption> ExecStatus = visitation.ExecStatus;
    
        CVA.Add_as_attendee_Escort__c = False;
        CVA.Add_as_attendee_Requestor__c =False;
        CVA.Add_as_attendee_Host__c = False;
        
        update CVA;
        Visitation.AddAttendee();
        visitation.saveButtonDetail();
        Visitation.generatePDF();
        Visitation.helpDocument();
        Visitation.EditButton();
        Visitation.editButtonQuality();
        Visitation.editButtonMisc();
        Visitation.editButtonDetail();
        Visitation.SaveButton();
        Visitation.SaveButtonQlty();
        
        CVA.Visitation_Host__c = U.Id;
        CVA.Requestor__c = u.id;
        CVA.Escort__c =  Userinfo.getuserId();
        CVA.Add_as_attendee_Escort__c = True;
        CVA.Primary_Quality_User__c = u.id;
        CVA.Backup_Quality_User__c = userinfo.getUserId();
       Update CVA;
       Test.startTest();
       Visitation.AddAttendee();
       visitation.cloneRecord();
       Visitation.addTask();
       Visitation.newtask.subject='test subject';
       Visitation.newtask.status='Not Started';
       Visitation.newtask.priority='Medium';
       Visitation.savetask();
       Visitation.canceltask();
       visitation.getStageHistory();
       contact con1= new contact(firstname='first',lastname='last',phone='9876543210',email='abcdef@test.com');
       insert con1;
       Visitation.notificationId = con.id;
       Visitation.sendNotification();
       Visitation= new VisitationExtension(sc);
       string executiveSize = string.valueOf(Visitation.mapAttendees.size());
       VA4.Add_Executive_Attendee__c = true;
       Visitation.mapAttendees.put(executiveSize, VA4);
       Visitation.mapAttendees.put(executiveSize, VA5);
       visitation.addExecutive();
       visitation.checkExecutives();
       
       visitation.DellstVR= new List<Visitation_Attendee__c>();
       visitation.DellstVR.add(VA5);
       visitation.saveAttendees();
       visitation.DellstVR= new List<Visitation_Attendee__c>();
       visitation.DellstVR.add([SELECT id from Visitation_attendee__c LIMIT 1]); 
       visitation.SaveButtonDetail();
       
       Visitation_record__C clonevisit = CVA.clone(false,true,false,false);
       cloneVisit.start_date__c = system.today().addDays(-1);
       cloneVisit.End_date__c = system.today().addDays(-1);
       ApexPages.StandardController scr = new ApexPages.StandardController(clonevisit);
       VisitationExtension Visitation1= new VisitationExtension(sc); 
       Visitation1.saveButtonDetail();
       Visitation1.getExportVisible();
       visitation1.getDateDifference();
	          visitation1.getregionalHeads();
       visitation1.assignRegionHead();
       visitation1.accountChange();
       Test.stopTest(); 
    }
    
}