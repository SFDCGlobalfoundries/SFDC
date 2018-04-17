/*Author: Vijay Vemuru
    Description: Controller for Visitation_Tabs VF Page
    
    History:
    Created     -     Mallika Seth   -    02/15/2016      - code creation.
                 -    Vijay Vemuru   -    07/21/2016      - added VREG URL for workspaces
                 -    Vijay Vemuru   -    09/14/2016      - added method which makes region head as output and can be selectible by users using pick list from RH mapping
*/

 public class VisitationExtension {
 public string vCustomerAttendeeExisting;
 public string vGFAttendeeExisting;
 public Boolean flagAddHost;
 public Boolean flagAddRequestor;
 public Boolean flagAddEscort;
 private  Visitation_Record__c visitation;
 private ApexPages.StandardController standardController;
 public Boolean editModeQlty { get; set; }
 public Boolean editModeLogistic { get; set; }
 public Boolean editModeMisc { get; set; }
 public Boolean editModeDetail { get; set; }
 public Boolean editModeAttendees { get; set; }
 public Boolean chatterFlag { get; set; }
 public Boolean showTask { get; set; }
 public String tabOpt { get; set; }
 public task newTask { get; set; }
 public id notificationId { get; set; }
 public List<Visitation_Logistics__c> logisticList{get;set;}
 public Map < String, Visitation_Attendee__c > mapGFAttendees { get; set; }
 public Map < String, Visitation_Attendee__c > mapCustomerAttendees { get; set; }
 public Map < String, Visitation_Attendee__c > mapPartnerAttendees { get; set; }
 public Map < String, Visitation_Attendee__c > mapAttendees { get; set; }
 public boolean customerErr{get;set;}
 public boolean globalErr{get;set;}
 public boolean StartDateErr{get;set;}
 public boolean EndDateErr{get;set;}
 list < Logistic_Admin__C > logisticAdmin = Logistic_Admin__c.getall().values();
 public List < Visitation_Attendee__c > lstVR = new List < Visitation_Attendee__c > ();
 public List < Visitation_Attendee__c > DellstVR = new List < Visitation_Attendee__c > ();
 public List < Visitation_Attendee__c > AddlstVR = new List < Visitation_Attendee__c > ();
 Date prevStartDate;
 Date PrevEndDate;
 
 public set < string > mapAttendeesSet {
  get {
   set < string > tempSet = new set < string > ();
   if (mapAttendees != null && mapAttendees.size() > 0) {
    for (String each: mapAttendees.keyset()) {
     if (mapAttendees.get(each).Attendee__c != null) {
      tempSet.add(each);
     }
    }
   }
   return tempSet;
  }
  set;
 }
 public set < string > mapGFAttendeesSet {
  get {
   set < string > tempSet = new set < string > ();
   if (mapGFAttendees != null && mapGFAttendees.size() > 0) {
    for (String each: mapGFAttendees.keyset()) {
     if (mapGFAttendees.get(each).Attendee__c != null) {
      tempSet.add(each);
     }
    }
   }
   return tempSet;
  }
  set;
 }
 public set < string > mapCustomerAttendeesSet {
  get {
   set < string > tempSet = new set < string > ();
   if (mapCustomerAttendees != null && mapCustomerAttendees.size() > 0) {
    for (String each: mapCustomerAttendees.keyset()) {
     if (mapCustomerAttendees.get(each).Attendee__c != null) {
      tempSet.add(each);
     }
    }
   }
   return tempSet;
  }
  set;
 }
 
 public List<Visitation_Record__History> getStageHistory() {
    return [SELECT CreatedDate,NewValue,OldValue,Field,CreatedBy.Username FROM Visitation_Record__History WHERE  parentid=:visitation.id ORDER BY field];
 }
 
 public VisitationExtension(ApexPages.StandardController standardController) {
  mapGFAttendees = new Map < String, Visitation_Attendee__c > ();
  mapCustomerAttendees = new Map < String, Visitation_Attendee__c > ();
  mapPartnerAttendees = new Map < String, Visitation_Attendee__c > ();
  mapAttendees = new map < String, Visitation_Attendee__c > ();
  logisticList =  new List<Visitation_Logistics__c>();
  String type = apexpages.currentPage().getParameters().get('type');
  this.standardController = standardController;
  Id VisitationID = standardController.getId();
  editModeQlty = false;
  editModeMisc = false;
  editModeLogistic = false;
  editModeDetail = false;
  editModeAttendees = false;
  showTask = false;
  customerErr = false;
  globalErr   = false;
  EndDateErr  = false;
  StartDateErr = false;
  
  If(VisitationID == null) {
   editModeQlty = true;
   editModeMisc = true;
   editModeLogistic = true;
   editModeDetail = true;
   editModeAttendees = true;
  }
  flagAddHost = true;
  flagAddRequestor = true;
  flagAddEscort = true;
  if (Visitation_Setting__c.getInstance('SHOW CHATTER TAB') != null) {
   chatterFlag = Visitation_Setting__c.getInstance('SHOW CHATTER TAB').value_boolean__c;
  } else {
   chatterFlag = false;
  }
  this.Visitation = (Visitation_Record__c) standardController.getRecord();
 }
 public PageReference onLoadVisitation() {
  //IF Visitation is created before Vistation 2.0 is deployed, We should take it to Page Layout, otherwise take to Visualforce page      
  if (visitation.Id != null && Visitation_Setting__c.getInstance('VISITATION CUTOFF DATE') != null) {
   DateTime cutoffDate = Visitation_Setting__c.getInstance('VISITATION CUTOFF DATE').Value_DateTime__c;
   Visitation_Record__c tempVistation = [select Id, CreatedDate,GLOBALFOUNDRIES_Attendees__c,Customer_Attendees__c from Visitation_Record__c where Id = : visitation.Id];
   vCustomerAttendeeExisting = tempVistation.Customer_Attendees__c;
   vGFAttendeeExisting = tempVistation.GLOBALFOUNDRIES_Attendees__c;
   String returnUrl = ApexPages.currentPage().getParameters().get('retURL');
   if (tempVistation.CreatedDate <= cutoffDate) {
    if (returnUrl != null) {
     return new PageReference('/' + visitation.Id + '/e?nooverride=1&retURL=' + returnUrl);
    } else {
     return new PageReference('/' + visitation.Id + '?nooverride=1');
    }
   }
  }
  set < string > typeAttendeeSet = new set < string > ();
  typeAttendeeSet.add('GF Attendee');
  typeAttendeeSet.add('Customer Attendee');
  typeAttendeeSet.add('Partner Attendee');
  typeAttendeeSet.add('GF Executive');
  try{
      for (Visitation_Attendee__c visit: [SELECT Account_Id__c, Title__C, Email__c, Add_Executive_Attendee__c, WiFi_Details__c, Account__c,Account__r.name, Attendee__r.name, Attendee__c, Visitation__c,
    Citizenship__c, Id, Name, Badging_Completed__c, Type_of_attendee__c, User__c, Travel_Required__c,
    Travel_from_location__c, Travel_Type__c, Send_Notification__c, Request_Status__c, Nationality__c
    FROM Visitation_Attendee__c
    WHERE Visitation__c = : Visitation.Id AND Type_of_attendee__c IN: typeAttendeeSet
   ]) {
   if (visit.Type_of_attendee__c == 'GF Attendee') {
    string size = string.valueOf(mapGFAttendees.size());
    mapGFAttendees.put(size, visit);
   } else if (visit.Type_of_attendee__c == 'Customer Attendee') {
    string size = string.valueOf(mapCustomerAttendees.size());
    mapCustomerAttendees.put(size, visit);
   } else if (visit.Type_of_attendee__c == 'Partner Attendee') {
    string size = string.valueOf(mapPartnerAttendees.size());
    mapPartnerAttendees.put(size, visit);
   } else if (visit.Type_of_attendee__c == 'GF Executive') {
   
    string executiveSize = string.valueOf(mapAttendees.size());
    mapAttendees.put(executiveSize, visit);
   }
  }
  }catch(Exception excp){GlobalUtility.logMessage('Error','VisitationExtension','OnloadVisitation','','Exception while getting the Visistation Attendee data',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);}
  prevStartDate  = visitation.start_date__c;
  PrevEndDate    = visitation.End_date__c;
  
  // Meals for multiple days in Logistics section 
  try{
  logisticList = [SELECT AM_Beverage__c,Breakfast__c,Delivery_Time_for_AM__c,Delivery_Time_for_Lunch__c,Delivery_Time_for_PM__c,
                          Delivery_Time__c,Details_BF__c,Details_for_AM__c,Details_for_Lunch__c,Details_for_PM__c,Id,IsDeleted,Lunch__c,
                          Name,No_of_meals_BF__c,No_of_meals_for_AM__c,No_of_meals_for_Lunch__c,No_of_meals_for_PM__c,
                          OwnerId,PM_Beverage__c,Special_Diet_AM__c,Special_Diet_BreakFast__c,Special_Diet_for_Lunch__c,
                          Special_Diet_for_PM__c,Visitation__c FROM Visitation_Logistics__c 
                          WHERE Visitation__c =:visitation.id];
  }catch(Exception excp){GlobalUtility.logMessage('Error','VisitationExtension','OnloadVisitation','','Exception while getting the Logistics data',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);}
  
    if(logisticList == null || logisticList.size() == 0) {
        if( Visitation.start_Date__c != null &&  Visitation.End_Date__c != null) {
            Integer numDays = Visitation.start_Date__c.daysBetween(Visitation.End_Date__c)+1;
            if(numDays > 5) {
                numDays = 5;
            }
            for(Integer i=0; i<numDays; i++) {
                Visitation_Logistics__c log = new Visitation_Logistics__c(Visitation__c= Visitation.id,name='Day'+(i+1));
                        logisticList.add(log); 
            }
        }
        
    }
    
  
  return null;
 }
 public PageReference generatePDF() {
  // Apex code for handling record from a Detail page goes here
  Visitation_Record__c Visitation = (Visitation_Record__c) standardController.getRecord();
  String PDFURL = '/apex/VisitationPDF?id=' + Visitation.Id;
  PageReference VisitationPDF = new PageReference(PDFURL);
  VisitationPDF.setRedirect(true);
  return VisitationPDF;
 }
 public pagereference helpDocument() {
   // Help Document for Visitation      
  string docUrl = 'https://docs.google.com/presentation/d/18bYQ9v-B27xOqqVdt5J6zWuvFtazLXVWuAWxYLYHYtg/edit#slide=id.p4';
  PageReference helpDoc = new PageReference(docurl);
  helpDoc.setRedirect(true);
  return helpDoc;
 }
 
 // Added VREG workspace links for the four locations- 07212016
 
 public pagereference VREGApplication() {
  string urlStr = 'https://'+System.Label.VREG_Fab_9_10;
  PageReference pgRef = new PageReference(urlStr);
  pgRef.setRedirect(true);
  return pgRef;
 }
 
 public pagereference Link_to_GUI_US() {
      
  string urlStr = 'https://'+System.Label.Link_to_GUI_US;
  PageReference pgRef = new PageReference(urlStr);
  pgRef.setRedirect(true);
  return pgRef;
 }
 
 public pagereference Link_to_GUI_Europe() {

     string urlStr = 'https://'+System.Label.Link_to_GUI_Europe;
  PageReference pgRef = new PageReference(urlStr);
  pgRef.setRedirect(true);
  return pgRef;
 }
 
 public pagereference Link_to_GUI_Singapore() {

     string urlStr = 'https://'+System.Label.Link_to_GUI_Singapore;
  PageReference pgRef = new PageReference(urlStr);
  pgRef.setRedirect(true);
  return pgRef;
 }
 
 public void LogisticAdmin() {
 // Logistics admin is selected for each location
  Visitation_Record__c Visit = (Visitation_Record__c) standardController.getRecord();
  string userName = '';
  for (Logistic_Admin__c LA: logisticAdmin) {
   if (LA.Visit_Location__c == Visit.Visit_Location__c) {
    userName = LA.Admin_ID__c;
    break;
   }
  }
  User adminUser;
  try {
   adminUser = [SELECT id FROM User where username = : userName AND isactive = true LIMIT 1];
   if (adminUser != null) {
    Visit.Logistics_Admin__c = adminUser.id;
   }
  }catch(Exception excp){GlobalUtility.logMessage('Error','VisitationExtension','OnloadVisitation','','Exception while getting the Visistation Attendee data',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);}
   
 }
 
 public VisitationExtension(){}
 public void insertAttendees(List<Visitation_Record__c> VisitList){
    mapGFAttendees = new map<string,Visitation_Attendee__c>();
    for(Visitation_Record__c visit : VisitList) {
        Visitation = visit;
        onLoadVisitation();
        addAttendee();
    }
    if(mapGFAttendees != null && mapGFAttendees.size() > 0) {
        try{
        upsert mapGFAttendees.values();
        }catch(Exception excp){GlobalUtility.logMessage('Error','VisitationExtension','OnloadVisitation','','Exception while getting the Visistation Attendee data',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);}
  
    }
 }

 public void addAttendee() {
   // Converting user into contact by referencing email and this function is used when check add as attendees     
  map < String, Visitation_Attendee__c > tempMap = new map < String, Visitation_Attendee__c > ();
  map < id, Visitation_Attendee__c > delMap = new map < id, Visitation_Attendee__c > ();
  set < id > removeAttendees = new set < id > ();
  set < id > existedAttendees = new Set < id > ();
  string mapSize = '';
  set < id > userIds = new set < id > ();
  if (Visitation.Visitation_Host__c != null) {
   userIds.add(Visitation.Visitation_Host__c);
  }
  if (Visitation.Requestor__c != null) {
   userIds.add(Visitation.Requestor__c);
  }
  if (Visitation.Escort__c != null) {
   userIds.add(Visitation.Escort__c);
  }
  map < id, string > userMap = new map < id, string > ();
  map < string, Contact > contactMap = new map < string, Contact > ();
  for (user each: [SELECT id, email FROM user WHERE id IN: userIds]) {
   userMap.put(each.id, each.email);
  }
  for (Contact con: [SELECT id, name, email FROM Contact WHERE email IN: userMap.values()]) {
   contactMap.put(con.email, con);
  }
  contact escort = new contact();
  contact requestor = new contact();
  contact host = new contact();
  if (userMap.containsKey(Visitation.Visitation_Host__c) && userMap.get(Visitation.Visitation_Host__c) != null && contactMap != null &&
   contactMap.containsKey(userMap.get(Visitation.Visitation_Host__c)) && contactMap.get(userMap.get(Visitation.Visitation_Host__c)) != null) {
   host = contactMap.get(userMap.get(Visitation.Visitation_Host__c));
  }
  if (userMap.containsKey(Visitation.Requestor__c) && userMap.get(Visitation.Requestor__c) != null && contactMap != null &&
   contactMap.containsKey(userMap.get(Visitation.Requestor__c)) && contactMap.get(userMap.get(Visitation.Requestor__c)) != null) {
   requestor = contactMap.get(userMap.get(Visitation.Requestor__c));
  }
  if (userMap.containsKey(Visitation.Escort__c) && userMap.get(Visitation.Escort__c) != null && contactMap != null &&
   contactMap.containsKey(userMap.get(Visitation.Escort__c)) && contactMap.get(userMap.get(Visitation.Escort__c)) != null) {
   escort = contactMap.get(userMap.get(Visitation.Escort__c));
  }
  for (Visitation_Attendee__c VA: mapGFAttendees.values()) {
   if (VA.attendee__c != null) {
    existedAttendees.add(VA.attendee__c);
   } else {
    existedAttendees.add(VA.user__c);
   }
  }
  if (!Visitation.Add_as_attendee_Host__c) {
  // Adding host,escort and requestor as attendees
    if(host.id != null) {
        removeAttendees.add(host.id);
    }else {
        removeAttendees.add(Visitation.Visitation_Host__c);
    }
  }
  if (!Visitation.Add_as_attendee_Requestor__c) {
      if(requestor.id != null) {
        removeAttendees.add(requestor.id);  
      } else {
        removeAttendees.add(Visitation.Requestor__c);
      }
  }
  if (!Visitation.Add_as_attendee_Escort__c ) {
    if(escort.id != null) {
        removeAttendees.add(escort.id);
    } else {
        removeAttendees.add(Visitation.escort__c);
    }
  }
  List < Visitation_Attendee__c > tempList = new List < Visitation_Attendee__c > ();
  tempList = mapGFAttendees.values();
  mapGFAttendees.clear();
  for (Visitation_Attendee__c VA: tempList) {
       if ((!removeAttendees.contains(VA.attendee__c) && !(VA.attendee__c == NULL && removeAttendees.contains(VA.User__c))) || VA.id != null) {
        String attSize = string.valueOf(mapGFAttendees.size());
        mapGFAttendees.put(attSize, VA);
       }
  }
  
  if (Visitation.Add_as_attendee_Host__c && Visitation.Visitation_Host__c != null && !existedAttendees.contains(host.id) && !existedAttendees.contains(Visitation.Visitation_Host__c)  ) {
   Visitation_Attendee__c VisitationAtendee = new Visitation_Attendee__c();
   VisitationAtendee.Name = Visitation.Visitation_Host__c;
   VisitationAtendee.User__c = Visitation.Visitation_Host__c;
   VisitationAtendee.Visitation__c = Visitation.id;
   VisitationAtendee.Type_of_attendee__c = 'GF Attendee';
   VisitationAtendee.attendee__c = host.id;
   VisitationAtendee.Name = host.name;
   mapSize = string.valueOf(mapGFAttendees.size());
   mapGFAttendees.put(mapSize, VisitationAtendee);
   existedAttendees.add(VisitationAtendee.attendee__c);
  }
  
  if (Visitation.Add_as_attendee_Requestor__c && Visitation.Requestor__c != null && !existedAttendees.contains(requestor.id) && !existedAttendees.contains(Visitation.Requestor__c)) {
   Visitation_Attendee__c VisitationAtendee1 = new Visitation_Attendee__c();
   VisitationAtendee1.Name = Visitation.Requestor__c;
   VisitationAtendee1.User__c = Visitation.Requestor__c;
   VisitationAtendee1.Visitation__c = Visitation.id;
   VisitationAtendee1.Type_of_attendee__c = 'GF Attendee';
   VisitationAtendee1.attendee__c = requestor.id;
   VisitationAtendee1.Name = requestor.name;
   mapSize = string.valueOf(mapGFAttendees.size());
   mapGFAttendees.put(mapSize, VisitationAtendee1);
   existedAttendees.add(VisitationAtendee1.attendee__c);
  }
  if (Visitation.Add_as_attendee_Escort__c && Visitation.Escort__c != null && !existedAttendees.contains(escort.id) && !existedAttendees.contains(Visitation.Escort__c)) {
   Visitation_Attendee__c VisitationAtendee2 = new Visitation_Attendee__c();
   VisitationAtendee2.Name = Visitation.Escort__c;
   VisitationAtendee2.User__c = Visitation.Escort__c;
   VisitationAtendee2.Visitation__c = Visitation.id;
   VisitationAtendee2.Type_of_attendee__c = 'GF Attendee';
   VisitationAtendee2.attendee__c = escort.id;
   VisitationAtendee2.Name = escort.name;
   mapSize = string.valueOf(mapGFAttendees.size());
   mapGFAttendees.put(mapSize, VisitationAtendee2);
   existedAttendees.add(VisitationAtendee2.attendee__c);
  }
 }
 Public Void EditButton() {
  tabOpt = 'Logistics';
  editModeLogistic = True;
 }
 public void editButtonQuality() {
  tabOpt = 'Quality';
  editModeQlty = True;
 }
 Public Void EditButtonMisc() {
  tabOpt = 'Misc';
  editModeMisc = True;
 }
 Public Void EditButtonDetail() {
  tabOpt = 'Detail';
  editModeDetail = True;
 }
 public void editButtonAttendees() {
  tabOpt = 'Attendees';
  editModeAttendees = True;
 }
 Public pagereference SaveButtonDetail() {
     StartDateErr   = false;
     EndDateErr     = false;
     if(visitation.id == null) {
         if(visitation.start_date__c < System.today()) {
             StartDateErr = True;
             return null;
         }
         
         if(visitation.start_date__c > visitation.End_date__c) {
             EndDateErr  = True;
             return null;
         }
     }
    LogisticAdmin();
	Try {
      if(prevStartDate  != visitation.start_date__c || PrevEndDate    != visitation.End_date__c){
          
            Integer numDays = Visitation.start_Date__c.daysBetween(Visitation.End_Date__c)+1 ;
            integer rcordsToAdd = numDays -logisticList.size();
            integer logSize = logisticList.size();   
            if(rcordsToAdd < 0) { 
                 for(integer i = logSize  -numDays; i>0;i--) {
                    logSize = logSize-1;
                    logisticList.remove(logSize);
                }
            
            }
            if(rcordsToAdd +logSize > 5) {
                rcordsToAdd = 5-logsize;
            }
            for(Integer i=0; i<rcordsToAdd  ; i++) {
                    Visitation_Logistics__c log = new Visitation_Logistics__c(Visitation__c= Visitation.id,name='Day'+(i+1));
                            logisticList.add(log); 
            }
      
      }
	}catch (Exception excp) {
   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR'));
   ApexPages.addMessages(excp);
   GlobalUtility.logMessage('Error','VisitationExtension','SaveButtonDetail','','Exception while inserting the Visistation record',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);
   return null;
  }
  Try {
   if (Visitation.Requestor__c == null) {
    if (Visitation.ownerid != null) {
     Visitation.Requestor__c = Visitation.ownerid;
    } else {
     Visitation.Requestor__c = userinfo.getUserId();
    }
   }
   if(Visitation.Meeting_Room__c != null){
        Visitation.Meeting_Room_Requested__c = true;        
   }
   if( Visitation.id != null && Visitation.Territory_Head_for_Approval__c == NULL){
        ApexPages.Message qualityUserMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Reagion Head Required For Approval');
        ApexPages.addMessage(qualityUserMessage);
        return null;
   }
   
   upsert Visitation;
   
  } catch (Exception excp) {
   //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot select two fabs.'));
   ApexPages.addMessages(excp);
   GlobalUtility.logMessage('Error','VisitationExtension','SaveButtonDetail','','Exception while inserting the Visistation record',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);
   return null;
  }
  
  tabOpt = 'Detail';
  editModeDetail = False;
  if (DellstVR.size() > 0) {
   try{
   delete DellstVR;
   DellstVR.clear();
   }catch(Exception excp){GlobalUtility.logMessage('Error','VisitationExtension','SaveButtonDetail','','Exception while deleting the Visistation Attendee record',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);}
  }
  if(logisticList.size() > 0) {
      try{
        Upsert logisticList;
      }catch(Exception excp){GlobalUtility.logMessage('Error','VisitationExtension','SaveButtonDetail','','Exception while inserting the Logisitcs record',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);}
  
  }
  if (mapGFAttendees != null && mapGFAttendees.size() > 0) {
    try{
        upsert mapGFAttendees.values();
    }catch(Exception excp){GlobalUtility.logMessage('Error','VisitationExtension','SaveButtonDetail','','Exception while inserting the Visitation Attendee record',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);}
  
  }
  //AddAttendee();
  
  string urlStr = '/apex/Visitation_Tabs?id=' + visitation.id + '&sfdc.override=1&type=save';
  PageReference pageref = new PageReference(urlStr);
  pageref.setRedirect(true);
  return pageref;
 }
 Public Void SaveButton() {
 if(logisticList.size() > 0) {
    for(Visitation_Logistics__c log : logisticList){
        Visitation.Meal_Required__c = (log.Breakfast__c || log.AM_Beverage__c || log.Lunch__c||log.PM_Beverage__c)?true:false;
    }
    upsert logisticList;    
    }
 // using multiple tabs
 try{
    upsert Visitation;
 } catch(Exception excp) {
    Apexpages.addMessages(Excp);
    GlobalUtility.logMessage('Error','VisitationExtension','SaveButton','','Exception while inserting the Visitation record',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);
    return;
 }
  //tabOpt = 'Logistics';
  editModeLogistic = False;
 }
 Public Void SaveButtonQlty() {
  upsert Visitation;
  tabOpt = 'Quality';
  editModeQlty = False;

 }
 Public Void SaveButtonMisc() {
  upsert Visitation;
  tabOpt = 'Misc';
  editModeMisc = False;
 }
 public PageReference addTask() {
   //Adding task to quality users in the audit section    
  if (visitation.Primary_Quality_User__c != null || visitation.Backup_Quality_User__c != null) {
   newTask = new task(whatid = Visitation.id, ownerid = userinfo.getUserId(), ActivityDate = visitation.Start_Date__c);
   showTask = true;
  } else {
   ApexPages.Message qualityUserMessage = new ApexPages.Message(ApexPages.Severity.WARNING, 'Need Primary AND/OR Backup Quality User. Please add users before you create a task.');
   ApexPages.addMessage(qualityUserMessage);
  }
  return null;
 }

 public void saveTask() {
  if (newTask != null) {
   List < task > tskList = new List < Task > ();
   if (Visitation.Primary_Quality_User__c != null) {
    task tsk = new task();
    tsk.Whatid = newTask.Whatid;
    tsk.ownerid = Visitation.Primary_Quality_User__c;
    tsk.subject = newTask.subject;
    tsk.whoid = newTask.whoid;
    tsk.activitydate = newTask.activitydate;
    tsk.status = newTask.status;
    tsk.priority = newTask.priority;
    tskList.add(tsk);
   }
   if (Visitation.Backup_Quality_User__c != null) {
    task tsk = new task();
    tsk.Whatid = newTask.Whatid;
    tsk.ownerid = Visitation.Backup_Quality_User__c;
    tsk.subject = newTask.subject;
    tsk.whoid = newTask.whoid;
    tsk.activitydate = newTask.activitydate;
    tsk.status = newTask.status;
    tsk.priority = newTask.priority;
    tskList.add(tsk);
   }
   if (!tskList.isEmpty()) {
    try{
        upsert tskList;
    }catch(Exception excp){GlobalUtility.logMessage('Error','VisitationExtension','SaveTask','','Exception while inserting the Task record',String.valueof(excp.getMessage()),'','Customer Visitation',excp,0);}
  
   }

  }
  showTask = false;
 }
 public void cancelTask() {
  showTask = false;
 }

 //init GF Attendees 
 public String removeKey { get; set; }
 public List < SelectOption > ExecNames {
  get {
   Map < String, Visitation_Executive__c > mapVE = Visitation_Executive__c.getAll();
   set < String > executiveEmails = new set < string > ();
   ExecNames = New List < SelectOption > {
    New selectOption('', '-None-')
   };
   for (Visitation_Executive__c exec: mapVE.values()) {
    executiveEmails.add(exec.email__c);
   }
   if (mapVE != Null && mapVE.size() > 0) {
    for (Contact c: [Select id, FirstName, LastName, Name From Contact Where Account.Name = : Label.Visitation_Internal_Account_Name and email in : executiveEmails ORDER BY Name ASC]) {
     ExecNames.add(New selectOption(c.Id, c.Name));
    }
   }
   return ExecNames;
  }
  set;
 }

 public List < SelectOption > ExecStatus { get; set; }
 public void addExcutivetoMap() {
  String key;
  if (mapAttendees != Null) {
   key = String.valueof(mapAttendees.size());
  }
  mapAttendees.put(key, new Visitation_Attendee__c(Type_of_attendee__c = 'GF Executive', Request_Status__c = 'Requested', Visitation__c = Visitation.Id));
 }
 public void addGFtoMap() {
  String key;
  if (mapGFAttendees != Null) {
   key = String.valueof(mapGFAttendees.size());
  }
  mapGFAttendees.put(key, new Visitation_Attendee__c(Type_of_attendee__c = 'GF Attendee', Account__c = gfAccount.Id, Visitation__c = Visitation.Id));
 }
 public void addPAtoMap() {
  String key;
  if (mapPartnerAttendees != Null) {
   key = String.valueof(mapPartnerAttendees.size());
  }
  mapPartnerAttendees.put(key, new Visitation_Attendee__c(Type_of_attendee__c = 'Partner Attendee', Visitation__c = Visitation.Id));
 }
 public void addCAtoMap() {
    String key;
    if(mapCustomerAttendees != Null) {
        key = String.valueof(mapCustomerAttendees.size());
    }
    mapCustomerAttendees.put(key, new Visitation_Attendee__c(Account__c = Visitation.Account__c, Type_of_attendee__c = 'Customer Attendee', Visitation__c = Visitation.Id));
 }

 public void removeExecutivefromMap() {
   //To remove Attendees from the user interface when we select remove option     
  if (removeKey != Null && mapAttendees.keySet().contains(removeKey)) {
   if (mapAttendees.get(removekey) != null && mapAttendees.get(removekey).id != null) {
    DellstVR.add(mapAttendees.get(removekey));
   }
   List < Visitation_Attendee__c > tempList = New List < Visitation_Attendee__c > ();
   for (string key: mapAttendees.keyset()) {
    if (key != removekey) {
     tempList.add(mapAttendees.get(key));
    }
   }
   mapAttendees.clear();
   if (tempList.size() > 0) {
    for (Visitation_Attendee__c v: tempList) {
     String tempKey = String.Valueof(mapAttendees.size());
     mapAttendees.put(tempKey, v);
    }
   }
  }
 }
 public void removegfAttendeefromMap() {
  System.debug('RemoveKey' + mapGFAttendees + '' + RemoveKey);
  if (removeKey != Null && mapGFAttendees.keySet().contains(removeKey)) {
   if (mapGFAttendees.get(removekey) != null && mapGFAttendees.get(removekey).id != null) {
    DellstVR.add(mapGFAttendees.get(removekey));
   }
   List < Visitation_Attendee__c > tempList = New List < Visitation_Attendee__c > ();
   for (string key: mapGFAttendees.keyset()) {
    if (key != removekey) {
     tempList.add(mapGFAttendees.get(key));
    }
   }
   mapGFAttendees.clear();
   if (tempList.size() > 0) {

    for (Visitation_Attendee__c v: tempList) {
     String tempKey = String.Valueof(mapGFAttendees.size());
     mapGFAttendees.put(tempKey, v);
    }
   }
  }
 }
 public void removecustomerAttendeefromMap() {
  if (removeKey != Null && mapCustomerAttendees.keySet().contains(removeKey)) {
   if (mapCustomerAttendees.get(removekey) != null && mapCustomerAttendees.get(removekey).id != null) {
    DellstVR.add(mapCustomerAttendees.get(removekey));
   }
   mapCustomerAttendees.remove(removekey);
   if (mapCustomerAttendees.size() > 0) {
    List < Visitation_Attendee__c > tempList = mapCustomerAttendees.values();
    mapCustomerAttendees.clear();
    for (Visitation_Attendee__c v: tempList) {
     String tempKey = String.Valueof(mapCustomerAttendees.size());
     mapCustomerAttendees.put(tempKey, v);
    }
   }
  }
 }
 public void removePartnerAttendeefromMap() {
  if (removeKey != Null && mapPartnerAttendees.keySet().contains(removeKey)) {
   if (mapPartnerAttendees.get(removekey) != null && mapPartnerAttendees.get(removekey).id != null) {
    DellstVR.add(mapPartnerAttendees.get(removekey));
   }
   mapPartnerAttendees.remove(removekey);
   if (mapPartnerAttendees.size() > 0) {
    List < Visitation_Attendee__c > tempList = mapPartnerAttendees.values();
    mapPartnerAttendees.clear();
    for (Visitation_Attendee__c v: tempList) {
     String tempKey = String.Valueof(mapPartnerAttendees.size());
     mapPartnerAttendees.put(tempKey, v);
    }
   }
  }
 }
 public PageReference addExcutive() {
  gfExecutives.add(new Visitation_Attendee__c(Type_of_attendee__c = 'GF Executive', Request_Status__c = 'Requested', Visitation__c = Visitation.Id));
  return null;
 }
 public Account gfAccount {
  get {
   if (gfAccount == null) {
    gfAccount = [SELECT Id, Name from Account where Name = : Label.Visitation_Internal_Account_Name Limit 1];
   }
   return gfAccount;
  }
  set;
 }
     
     public List < Visitation_Record__c > VisitationAttendee {
         get {
              if (VisitationAttendee == null) {
    VisitationAttendee = [SELECT Purpose__c FROM Visitation_Record__c
    ];
   }
   return VisitationAttendee;
  }
  set;
 }
             
 public List < Visitation_Attendee__c > gfExecutives {
  get {
   if (gfExecutives == null) {
    gfExecutives = [SELECT Account_Id__c, Title__C, Email__c, WiFi_Details__c, Account__c, Attendee__c, Citizenship__c, Id, Name, Travel_from_location__c,
     Travel_Required__c, Travel_Type__c, Type_of_attendee__c, Visitation__c, Badging_Completed__c, Send_Notification__c, Request_Status__c FROM Visitation_Attendee__c
     WHERE Visitation__c = : Visitation.Id AND Type_of_attendee__c = 'GF Executive'
    ];
   }
   return gfExecutives;
  }
  set;
 }

 public List < Visitation_Attendee__c > customerAttendees {
  get {
   if (customerAttendees == null) {
    
     customerAttendees = [SELECT Account_Id__c, Title__C, Email__c, WiFi_Details__c, Account__c,Account__r.name, Attendee__r.name, Attendee__c, Citizenship__c, Id, Name, Travel_from_location__c,
      Travel_Required__c, Travel_Type__c, Type_of_attendee__c, Visitation__c,Visitation__r.purpose__c, Badging_Completed__c, Send_Notification__c, Password__c, Begin_Date__c, End_Date__c, GMT_value__c, Phone_number__c, Reason_for_Visit__c, GF_sponsor__c, Request_Status__c FROM Visitation_Attendee__c
      WHERE Visitation__c = : Visitation.Id AND Type_of_attendee__c = 'Customer Attendee'
     ];
    
   }
   return customerAttendees;
  }
  set;
 }
 public List < Visitation_Attendee__c > partnerAttendees {
  get {
   if (partnerAttendees == null) {
    
     partnerAttendees = [SELECT Account_Id__c, Title__C, Email__c, WiFi_Details__c, Account__c, Attendee__c, Citizenship__c, Id, Name, Travel_from_location__c,
      Travel_Required__c, Travel_Type__c, Type_of_attendee__c, Visitation__c, Badging_Completed__c, Request_Status__c FROM Visitation_Attendee__c
      WHERE Visitation__c = : Visitation.Id AND Type_of_attendee__c = 'Partner Attendee'
     ];
    
   }
   return partnerAttendees;
  }
  set;
 }
 public void saveAttendees() {
 // Not showing empty tables when we go to detail page in attendees tab
  set <id> executiveIDS             =   new set < id > ();
  set<id>  existGlobalAttendees     =   new set<id>();
  set<id>  existCustomerAttendees   =   new set<id>();
  globalErr= false;
  customerErr = false;
  for (Visitation_Attendee__c exec: mapAttendees.values()) {
   executiveIDS.add(exec.attendee__c);
  }
  for (Visitation_Attendee__c exec: mapGFAttendees.values()) {
   if(exec.attendee__c != null) {
        if(existGlobalAttendees.contains(exec.attendee__c)) {
            globalErr   = true;
            return;
        }
        existGlobalAttendees.add(exec.attendee__c);
   }
   if (exec.name == null || exec.name == '') {
    executiveIDS.add(exec.attendee__c);
   }
  }
  for (Visitation_Attendee__c exec: mapCustomerAttendees.values()) {
    if(exec.attendee__c != null) {
        if(existCustomerAttendees.contains(exec.attendee__c)) {
            customerErr = true;
            return;
        }
        existCustomerAttendees.add(exec.attendee__c);
   }
    
   if (exec.name == null || exec.name == '') {
    executiveIDS.add(exec.attendee__c);
   }
  }
  if (!executiveIDS.isEmpty()) {
   Map < id, contact > contactmap = new map < id, contact > ([SELECT Id, name,email FROM Contact where id in : executiveIDS]);
   for (Visitation_Attendee__c exec: mapAttendees.values()) {
    exec.name = 'GLOBALFOUNDRIES Executive';
    if (contactmap.get(exec.attendee__c) != null) {
     exec.name = contactmap.get(exec.attendee__c).name;
    }
   }
   for (Visitation_Attendee__c exec: mapGFAttendees.values()) {
    if (exec.name == null || exec.name == '') {
        exec.name = 'GLOBALFOUNDRIES Attendee';
     if (contactmap.get(exec.attendee__c) != null) {
      exec.name = contactmap.get(exec.attendee__c).name;
     }
    }
   }
   for (Visitation_Attendee__c exec: mapCustomerAttendees.values()) {
    if (exec.name == null || exec.name == '') {
        exec.name   =   'Customer Attendee';
     if (contactmap.get(exec.attendee__c) != null) {
      exec.name = contactmap.get(exec.attendee__c).name;
      
     }
    }
    if(exec.email__c == null || exec.email__c == '') {
        if (contactmap.get(exec.attendee__c) != null) {
            exec.email__c = contactmap.get(exec.attendee__c).email;
        }
    }
   }
  }
  upsert mapAttendees.values();
  upsert mapGFAttendees.values();
  upsert mapCustomerAttendees.values();
  upsert mapPartnerAttendees.values();
  if (DellstVR != null && !DellstVR.isEmpty()) {
   map < id, Visitation_Attendee__c > deleteMap = new map < id, Visitation_Attendee__c > ();
   for (Visitation_Attendee__c att: DellstVR) {
    deleteMap.put(att.id, att);
   }
   delete deleteMap.values();
   DellstVR.clear();
  }
  if(visitation.Id!=null){
     updateVistation_GF_Customer_Attendee(visitation.Id, vCustomerAttendeeExisting, vGFAttendeeExisting);
  }
  
  editModeAttendees = False;
 }
 //Contact instance to be used on the Component to capture the Contact Fields mainly to utilize phone number formatting to be used in the contact duplication search. 
 public Contact contactInstance {
  get {
   if (contactInstance == Null) {
    contactInstance = new Contact();
   }
   Return contactInstance;
  }
  set;
 }
 public void createContact() {
  //Validate none of the fields are missing. 
  Boolean validateError = false;
  if (contactInstance.FirstName == Null || contactInstance.FirstName == '') {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contact First Name missing.'));
   validateError = true;
  }
  if (contactInstance.LastName == Null || contactInstance.LastName == '') {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contact Last Name missing.'));
   validateError = true;
  }
  if (contactInstance.Email == Null || contactInstance.Email == '') {
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contact Email missing.'));
   validateError = true;
  }
  contactInstance.AccountID = Visitation.account__c;
  if (!validateError) {
   List < Contact > tempContactList = new List < Contact > ();
   String soql = 'Select id, FirstName, LastName  From Contact Where  email = \'' + contactInstance.email + '\' Limit 100';
   tempContactList = database.query(soql);
   if (tempContactList.size() > 0) {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contact Already exists.'));
    return;
   } else {
    insert contactInstance;
    Visitation_Attendee__c visitAtt = new Visitation_Attendee__c();
    visitAtt.Account__c = Visitation.Account__c;
    visitAtt.Type_of_attendee__c = 'Customer Attendee';
    visitAtt.Attendee__c = contactInstance.id;
    visitAtt.Visitation__c = Visitation.Id;
    Insert visitAtt;
    if (mapCustomerAttendees != null) {
     String tempKey = String.Valueof(mapCustomerAttendees.size());
     mapCustomerAttendees.put(tempKey, visitAtt);
    }
    contactInstance = new Contact();
   }
  }
 }
 public PageReference Export() {
 //Exporting as excel document for concur purposes
  String ExportURL = '/apex/VisitationCSV?id=' + Visitation.Id;
  PageReference VisitationCSV = new PageReference(ExportURL);
  //VisitationCSV.setRedirect(true);
  return VisitationCSV;
 }
 public void ITARconfidential() {
 }
 public void addExecutive() {
   // Adding executives in Attendees section by referencing contact    
  set < id > existAttendees = new set < id > ();
  set < id > removeExecutives = new set < id > ();
  map < string, id > userMap = new map < string, id > ();
  Map < id, string > contactNameMap = new map < id, string > ();
  if (mapAttendees != null && mapAttendees.size() > 0) {
   set < id > executiveIds = new set < id > ();
   for (Visitation_Attendee__c exec: mapAttendees.values()) {
    if (exec.Attendee__c != null) {
     executiveIds.add(exec.Attendee__c);
    }
   }
   for (contact con: [select name, id, email from contact where id In: executiveIds]) {
    contactNameMap.put(con.id, con.email);
   }
   for (user usr: [Select id, name, email from user where email In: contactNameMap.values()]) {
    userMap.put(usr.email, usr.id);
   }
  }
  List < Visitation_Attendee__c > tempList = new List < Visitation_Attendee__c > ();
  if (mapGFAttendees != null) {
   for (Visitation_Attendee__c VA: mapGFAttendees.values()) {
    if (VA.Attendee__c != null) {
     existAttendees.add(VA.Attendee__c);
    }
   }
  }
  for (Visitation_Attendee__c exec: mapAttendees.values()) {
   id executive = userMap.get(contactNameMap.get(exec.Attendee__c));
   if (exec.Add_Executive_Attendee__c) {
    if (!existAttendees.contains(exec.Attendee__c)) {
     Visitation_Attendee__c Temp = new Visitation_Attendee__c(Type_of_attendee__c = 'GF Attendee', Account__c = exec.Account__c, Visitation__c = exec.Visitation__c);
     Temp.attendee__c = exec.attendee__c;
     Temp.user__c = executive;
     string mapSize = string.valueOf(mapGFAttendees.size());
     mapGFAttendees.put(mapSize, Temp);
    }
    
   } else {
    if (exec.id == null) {
     removeExecutives.add(exec.attendee__c);
    }
   }
  }
  tempList = mapGFAttendees.values();
  mapGFAttendees.clear();
  for (Visitation_Attendee__c VA: tempList) {
   if (!removeExecutives.contains(VA.Attendee__c)) {
    String execSize = string.valueOf(mapGFAttendees.size());
    mapGFAttendees.put(execSize, VA);
   }
  }

 }
 public void sendNotification() {
    //Sending Executive Reports from Attendees Section     
  List<EmailTemplate> templates = [SELECT id FROM EmailTemplate where DeveloperName = : 'VisitationExecutiveReport' LIMIT 1];
  Id templateId = null;
  if(!templates.isEmpty()){
      templateId = templates[0].id;
  }else{
      throw new VisitationException('Please check VisitationExecutiveReport Email Template is available.');
  }
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  mail.setTargetObjectId(notificationId);
  if (!test.isRunningTest()) {
   mail.setTemplateId(templateId);
  } else {
   mail.setHtmlBody('<html><body></body></html>');
  }
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setSenderDisplayName('GLOBALFOUNDRIES');
  mail.setSaveAsActivity(false);
  mail.setWhatId(visitation.id);
  Messaging.sendEmail(new List < Messaging.SingleEmailMessage > {mail});
 }
 public void checkExecutives() {
   //Checking if there are duplicate executives and validating     
  set < id > attendeeSet = new set < id > ();
  id existedExecutive;
  for (Visitation_Attendee__c exec: mapAttendees.values()) {
   if (!attendeeSet.contains(exec.attendee__c)) {
    attendeeSet.add(exec.attendee__c);
   } else {
    existedExecutive = exec.attendee__c;
    exec.attendee__c = null;
   }
  }
  if (existedExecutive != null) {
   for (selectoption each: execNames) {
    if (String.valueOf(each.getValue()) == String.valueOf(existedExecutive)) {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Duplicate executives: ' + String.valueOf(each.getLabel())));
     return;
    }
   }
  }
 }
 public boolean getExportVisible() {
    return ((mapCustomerAttendees.size()>0) ? true:false);
 }
 public pagereference cloneRecord(){
    Savepoint spt = Database.setSavepoint();
    try{
        set<id> userIds = new set<id>();
        Visitation_Record__c cloneVisitation = Visitation.clone(false,true,false,false);
                cloneVisitation.Customer_Status__c              =   '';
                cloneVisitation.Actual_Meeting_Room__c          =   '';
                cloneVisitation.Wifi_Information_Completed__c   =   false;
                cloneVisitation.WIFI_Information__c             =   false;
                cloneVisitation.Tour_Information__c             =   false;
                cloneVisitation.Tour_Information_Completed__c   =   false;  
                cloneVisitation.Fab_Tour_Requested__c           =   '';
                cloneVisitation.Reason_for_Fab_Tour__c          =   null;
                cloneVisitation.Meeting_Room_Confirmed__c       =   false;
                
                cloneVisitation.Meeting_Room_Requested__c       =   false;
                cloneVisitation.Dinner_Time_new__c              =   null;
                cloneVisitation.Restaurant__c                   =   '';
                cloneVisitation.Comment_Dinner_new__c           =   null;
                cloneVisitation.No_of_People_Dinner__c          =   '0';
                
                cloneVisitation.Logistic_requirements_details_new__c            =   null;
                cloneVisitation.Special_Diet_new__c             =       null;
                cloneVisitation.Meal_Required__c                =       false;
                cloneVisitation.Meal_Information_Completed__c   =       false;
                cloneVisitation.Dinner_Reservations__c          =       false;
                cloneVisitation.Dinner_Information_Completed__c =       false;
                cloneVisitation.Customer_Status__c          =       '0. Draft';
                
            insert cloneVisitation;
        if(Visitation.Add_as_attendee_Host__c && Visitation.Visitation_Host__c != null) {
            userIds.add(Visitation.Visitation_Host__c);
        }
        if(Visitation.Add_as_attendee_Requestor__c && Visitation.Requestor__c != null) {
            userIds.add(Visitation.Requestor__c);
        }
        if(Visitation.Add_as_attendee_Escort__c && Visitation.Escort__c != null) {
            userIds.add(Visitation.Escort__c);
        }        
        List<Visitation_Attendee__c> clonedAttendees =  new List<Visitation_Attendee__c>(); 
        for(Visitation_Attendee__c attendee:mapAttendees.values()){
            Visitation_Attendee__c clonerec = attendee.clone(false,true,false,false);
                clonerec.Visitation__c = cloneVisitation.id;
            clonedAttendees.add(clonerec);
        }
        for(Visitation_Attendee__c attendee:mapGFAttendees.values()){
            if(!userIds.contains(attendee.user__c)) {
                Visitation_Attendee__c clonerec = attendee.clone(false,true,false,false);
                    clonerec.Visitation__c = cloneVisitation.id;
                clonedAttendees.add(clonerec);
            }
            
        }
              
        for(Visitation_Attendee__c attendee:mapCustomerAttendees.values()){
            Visitation_Attendee__c clonerec = attendee.clone(false,true,false,false);
                clonerec.Visitation__c = cloneVisitation.id;
            clonedAttendees.add(clonerec);
        }
        for(Visitation_Attendee__c attendee:mapPartnerAttendees.values()){
            Visitation_Attendee__c clonerec = attendee.clone(false,true,false,false);
                clonerec.Visitation__c = cloneVisitation.id;
            clonedAttendees.add(clonerec);
        }
        if(clonedAttendees.size() > 0) {
            insert clonedAttendees;
        }
    
        pagereference pgr = new pagereference('/apex/Visitation_Tabs?id='+cloneVisitation.id);
            pgr.setRedirect(true);
        
        return pgr; 
    } catch(Exception excp) {
        Database.rollback(spt);
        apexpages.addmessages(excp);
    }
    
    return null;
 }
 
 // Region Head populating from Account Region Head Object
 public string selectedRegion{get;set;}
 map<string,id> regionMap;
 public List<SelectOption> getregionalHeads(){
    List<SelectOption> temp   =     new List<SelectOption>();
    temp.add(new SelectOption('','--None--'));
    
        List<Account_Region_Head_Mapping__c> accRegions = new List<Account_Region_Head_Mapping__c>();
        accRegions  =   [SELECT id,Region_Head_LK__r.name,Region_Head_LK__c FROM Account_Region_Head_Mapping__c ];
        set<id> regionHeadIds = new set<id>();
        for(Account_Region_Head_Mapping__c AccHead : accRegions) {
            if(!regionHeadIds.contains(AccHead.Region_Head_LK__c)){
                temp.add(new SelectOption(AccHead.Region_Head_LK__c,AccHead.Region_Head_LK__r.name));
                regionHeadIds.add(AccHead.Region_Head_LK__c);
            }
        }
        return temp;
 }
 
 public void assignRegionHead(){
    if(selectedRegion != null && selectedRegion != '') {
        Visitation.Territory_Head_for_Approval__c   =   selectedRegion; 
    } else {
        Visitation.Territory_Head_for_Approval__c   =   null;
    }
 }
 
 // If Account changes the respective region head of the new account will be populated
 
 public void accountChange(){
    if(Visitation.account__c != null){
        Account VisitAcc    =   new account();
        VisitAcc            =   [SELECT id,Region_Head_lk__c FROM Account WHERE id=:Visitation.account__c LIMIT 1]; 
        if(VisitAcc.Region_Head_lk__c != null){
            Visitation.Territory_Head_for_Approval__c   =   VisitAcc.Region_Head_lk__c;
        } else{
            Visitation.Territory_Head_for_Approval__c   =   null;
        }
    }
 }
 public boolean getDateDifference() {
        if(Visitation.Start_Date__c != null && Visitation.End_Date__c != null) {
            integer diff = Visitation.Start_Date__c.daysBetween(Visitation.End_Date__c);
            return (diff>5 ? true:false);
        }
        
        return false;
        
 }
 
 
 
 public void updateMealRequired(){
   boolean mealRequired = false;
    for(Visitation_Logistics__c log : logisticList){
      if((log.Breakfast__c || log.AM_Beverage__c || log.Lunch__c||log.PM_Beverage__c)){
        mealRequired = true;
        break;
      } 
        
    }
    Visitation.Meal_Required__c = mealRequired;
    
    
 }
 
 @future
 public static void updateVistation_GF_Customer_Attendee (Id vistitationId , string vCustomerAttendeeExisting , string vGFAttendeeExisting){
        system.debug('$$$Existing attendee'+vCustomerAttendeeExisting +' GFexistingattendee' +vGFAttendeeExisting) ;
        string vistitationCustomerAttendee;
        string vistiatationGFAttendee;
        boolean isUpdate= false; 
    try{
            for (Visitation_Attendee__c ObjVA : [select id , Visitation__c , Type_of_attendee__c , Attendee__c , Attendee__r.name  from Visitation_Attendee__c where Type_of_attendee__c in ('GF Attendee','Customer Attendee') and Visitation__c = :vistitationId  and Attendee__c !=null]){
                if(ObjVA.Attendee__r.name!=null && ObjVA.Attendee__r.name !=''){
                    if(ObjVA.Type_of_attendee__c == 'GF Attendee'){
                        if(vistiatationGFAttendee == null){
                                vistiatationGFAttendee = ObjVA.Attendee__r.name;
                          }
                            else{
                                    vistiatationGFAttendee = vistiatationGFAttendee +', '+ObjVA.Attendee__r.name;
                                }
                    }else if(ObjVA.Type_of_attendee__c == 'Customer Attendee'){
                        if(vistitationCustomerAttendee == null){
                            vistitationCustomerAttendee = ObjVA.Attendee__r.name;
                        }
                        else
                        {
                            vistitationCustomerAttendee = vistitationCustomerAttendee+', '+ObjVA.Attendee__r.name;
                        }
                    }
                }
            }
            //update
            system.debug('$$$new attendee'+vistitationCustomerAttendee + vistiatationGFAttendee ) ;
            Visitation_Record__c oVisitation = new Visitation_Record__c(Id = vistitationId);
            if(vCustomerAttendeeExisting!= vistitationCustomerAttendee){
                oVisitation.Customer_Attendees__c = vistitationCustomerAttendee;
                isUpdate = true;
                
            }if(vCustomerAttendeeExisting == '<FirstName> <Lastname> , <job title/role>'){
                oVisitation.Customer_Attendees__c = '';
                isUpdate = true;
            }
            if(vGFAttendeeExisting != vistiatationGFAttendee){
                oVisitation.GLOBALFOUNDRIES_Attendees__c =  vistiatationGFAttendee;
                isUpdate = true;
            }
            if(vGFAttendeeExisting == '<FirstName> <Lastname> , <job title/role>'){
                oVisitation.GLOBALFOUNDRIES_Attendees__c = '';
                isUpdate = true;
            }
            if(isUpdate){
               update oVisitation;
            }
      
       
    }catch(Exception ex){
        System.debug('$$$Exception' + ex);
    }

    }
 public class VisitationException extends Exception{}
}