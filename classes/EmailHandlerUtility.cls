public class EmailHandlerUtility {

    //---------------------------------------------All PTRF Mail function------------------------------------------------------
    public static void ptrfEmailMethod(map < string, map < string, string >> PerPtrfDetailMap) {

        try {
            Map < String, String > ptrfEcsNameMap = new Map < String, String > ();
            map < string, string > DetailMap = new map < string, string > ();
            map < string, string > ptrfTemplateMap = new map < string, string > ();
            map < string, string > ptrfBodyMap = new map < string, string > ();
            map < string, string > ptrfSubjectMap = new map < string, string > ();
            map < string, string > ptrfGatingMap = new map < string, string > ();
            map < string, List < Email_Config_Settings__c >> ptrfECSListMap = new map < string, List < Email_Config_Settings__c >> ();
            List < Email_Config_Settings__c > ecsList = new List < Email_Config_Settings__c > ();

            Id ptrfRecordTypeId = Schema.SObjectType.Email_Config_Settings__c.getRecordTypeInfosByName().get('PTRF').getRecordTypeId();

            map < string, string > ptrfIdToMap = new map < string, string > ();
            map < string, string > ptrfIdCCMap = new map < string, string > ();
            map < string, string > ptrfIdBCCMap = new map < string, string > ();
            List < string > ToJobviewerList = new List < string > ();
            List < string > CCJobviewerList = new List < string > ();
            List < string > BCCJobviewerList = new List < string > ();
            string htmlBody = null;
            string subject = null;

            Map < string, string > ptrfJVEmailMapTO = new Map < string, string > ();
            Map < string, string > ptrfJVEmailMapCC = new Map < string, string > ();
            Map < string, string > ptrfJVEmailMapBCC = new Map < string, string > ();
            string CustomerFoundryJobview;
            Map < String, string > AccountPtrfMap = new Map < String, String > ();
            Map < String, string > TechGeoPtrfMap = new Map < String, String > ();
            Map < String, string > MSTPtrfMap = new Map < String, String > ();
            Map < String, string > fabPtrfMap = new Map < String, String > ();

            //-------------------Loop to create template map---------------------------------------------   
            for (String ptrfId: PerPtrfDetailMap.keySet()) {
                DetailMap = PerPtrfDetailMap.get(ptrfID);
                string TemplateNameString;
                TemplateNameString = DetailMap.get(System.Label.EmailKeysetForTemplate);
                ptrfTemplateMap.put(ptrfId, TemplateNameString);
            }
            //-------------------------------Populate ptrfECSListMap-------------------------------------------

            List < Email_Config_Settings__c > AllEcsList = [SELECT BCC__c, CC__c, Id,
                Customer_Jobviewer_Type__c, Gating_Jobview__c, Email_Template_Name__c,
                Foundry_Jobviewer_Type__c, Name,
                MPW_PTRF__c, Tech_Geo_Value__c,
                TO__c FROM Email_Config_Settings__c where
                Email_Template_Name__c IN: ptrfTemplateMap.values() and Available_For_Use__c = True
                and RecordTypeId = : ptrfRecordTypeId
            ];
            
            if (AllEcsList.size() > 0) {
                
                Messaging.SingleEmailMessage[] allMail = new Messaging.SingleEmailMessage[] {};

                for (String ptrfId: ptrfTemplateMap.keyset()) {
                    string TemplateName = ptrfTemplateMap.get(ptrfId);
                    for (Email_Config_Settings__c eachECS: AllEcsList) {
                        if (eachECS.Email_Template_Name__c == TemplateName) {
                            ecslist.add(eachECS);
                        }
                    }
                    ptrfECSListMap.put(ptrfId, ecslist);
                }

                //------------------------------populate AccountPtrfMap,TechGeoPtrfMap,MSTPtrfMap----------------------------------
                //selecting fab in SOQL query
                List < PTRF__c > ListPtrfRecords = [select Customer__c, Tech_Geo_Value__c, Tech_Geo__c, MaskSetTitle__r.name, Fab__c from PTRF__c
                    where id in : PerPtrfDetailMap.keyset()
                ];
                
                for (PTRF__c eachPTRF: ListPtrfRecords) {

                    string ptrfID18 = eachPTRF.id;

                    AccountPtrfMap.put(ptrfID18, eachPTRF.Customer__c);
                    string subTechGeo = eachPTRF.Tech_Geo__c.ToUppercase().substringbefore('UM');


                    TechGeoPtrfMap.put(ptrfID18, subTechGeo);

                    MSTPtrfMap.put(ptrfID18, eachPTRF.MaskSetTitle__r.name);

                    //populating fab data in fabPtrfMap
                    fabPtrfMap.put(ptrfID18, eachPTRF.Fab__c);
                }

                //---------------------------------------------form body and send mail----------------------------------------------
                for (String ptrfId: PerPtrfDetailMap.keySet()) {

                    DetailMap = PerPtrfDetailMap.get(ptrfID);
                    string gating;
                    gating = DetailMap.get(System.Label.EmailKeysetForGatingNotGating);
                    htmlBody = DetailMap.get(System.Label.EmailKeysetForBody);
                    subject = DetailMap.get(System.Label.EmailKeysetForSubject);

                    string[] ToUserEmailList = new List < string > ();
                    string[] ccListString = new List < string > ();
                    string[] bccListString = new List < string > ();
                    List < string > FoundryJV = new List < String > ();
                    List < string > CustJVList = new List < String > ();

                    for (Email_Config_Settings__c ecs: ecsList) {

                        Boolean TechGeoBool = False;
                        Boolean Starts_With_MPW_Bool = false;
                        string PTRFtechgeo;
                        string PTRFmst;
                        Boolean GatingCheck = False;

                        if (MSTPtrfMap <> null) { PTRFmst = MSTPtrfMap.get(ptrfid); }
                        
                        if (TechGeoPtrfMap <> null) { PTRFtechgeo = TechGeoPtrfMap.get(ptrfid); }

                        if (ecs.Tech_Geo_value__c <> Null) {
                            
                            List < string > techGeoList = new List < string > ();
                            
                            if (ecs.Tech_Geo_value__c.contains(';')) {
                                techGeoList = (ecs.Tech_Geo_value__c.split(';'));
                            } else {
                                techGeoList.add(ecs.Tech_Geo_value__c);
                            }

                            for (string t: techGeoList) {
                                Decimal ecsDecimalTG = Decimal.valueof(t);
                                if (ecsDecimalTG == Decimal.valueof(PTRFtechgeo)) {
                                    TechGeoBool = True;

                                    Break;
                                }
                            }
                        }

                        if (PTRFmst != null) {
                            if (ecs.MPW_PTRF__c == PTRFmst.toUpperCase().startswith('MPW')) {
                                Starts_With_MPW_Bool = True;
                            }
                        }

                        if (ecs.Gating_Jobview__c == gating) { GatingCheck = True; } 
                        else { GatingCheck = False; }

                        if (TechGeoBool == True) {
                            
                            if (Starts_With_MPW_Bool == True) {
                                
                                if (GatingCheck == true) {

                                    ptrfEcsNameMap.put(ptrfId, ecs.Name);
                                    
                                    if (ecs.TO__c <> null) { ptrfIdToMap.put(ptrfId, ecs.TO__c); }
                                    
                                    if (ecs.CC__c <> null) { ptrfIdCCMap.put(ptrfId, ecs.CC__c); }
                                    
                                    if (ecs.BCC__c <> null) { ptrfIdBCCMap.put(ptrfId, ecs.BCC__c); }

                                    if (ecs.Foundry_Jobviewer_Type__c <> Null || ecs.Customer_Jobviewer_Type__c <> Null) {
                                        
                                        if (ecs.Customer_Jobviewer_Type__c <> Null) {
                                            CustomerFoundryJobview = 'Customer' + ecs.Customer_Jobviewer_Type__c;
                                        }
                                        
                                        if (ecs.Foundry_Jobviewer_Type__c <> Null) {
                                            CustomerFoundryJobview = CustomerFoundryJobview + '$Foundry' + ecs.Foundry_Jobviewer_Type__c;
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if (CustomerFoundryJobview == null) {
                        ptrfJVEmailMapTO = null;
                    } else {
                        ptrfJVEmailMapTO.put(ptrfid, CustomerFoundryJobview);
                        ptrfJVEmailMapCC.put(ptrfid, CustomerFoundryJobview);
                        ptrfJVEmailMapBCC.put(ptrfid, CustomerFoundryJobview);
                    }
                    //------------------------------------------------------------------------------------------------------------------         
                }
                string[] ToList = new List < string > ();
                string[] ccList = new List < string > ();
                string[] bccList = new List < string > ();

                map < String, List < string >> ptrfIdtoList = new map < String, List < string >> ();
                map < String, List < string >> ptrfIdccList = new map < String, List < string >> ();
                map < String, List < string >> ptrfIdbccList = new map < String, List < string >> ();

                if (ptrfIdToMap.size() > 0) {
                    ptrfIdtoList = buildRecipientList(ptrfIdToMap, ptrfJVEmailMapTO, AccountPtrfMap, true, fabPtrfMap);
                }
                
                if (ptrfIdCCMap.size() > 0) {
                    ptrfIdccList = buildRecipientList(ptrfIdCCMap, ptrfJVEmailMapCC, AccountPtrfMap, true, fabPtrfMap);
                }
                
                if (ptrfIdBCCMap.size() > 0) {
                    ptrfIdbccList = buildRecipientList(ptrfIdBCCMap, ptrfJVEmailMapBCC, AccountPtrfMap, true, fabPtrfMap);
                }
                
                Set < String > allRecipientSt = new Set < String > ();
                
                for (String toString: ptrfIdToMap.values()) {
                    allRecipientSt.addAll(toString.toUpperCase().split('#'));
                }
                
                for (String ccString: ptrfIdCCMap.values()) {
                    allRecipientSt.addAll(ccString.toUpperCase().split('#'));
                }
                
                for (String bccString: ptrfIdBCCMap.values()) {
                    allRecipientSt.addAll(bccString.toUpperCase().split('#'));
                }
                
                Set < String > trimmedAllRecipient = new Set < String > ();
                
                for (String allRec: allRecipientSt) {
                    trimmedAllRecipient.add(allRec.trim());
                }

                Map < String, List < String >> fabEmailIds = new Map < String, List < String >> ();

                if (trimmedAllRecipient.contains('FAB')) { fabEmailIds = getFABUsersEmail(fabPtrfMap); }
                
                Map < String, List < String >> atpEmailIds = new Map < String, List < String >> ();

                if (trimmedAllRecipient.contains('ATP')) { atpEmailIds = getATPUserEmail(AccountPtrfMap); }

                //including FAB,ATP in email TO list
                for (String ptrfId: ptrfIdToMap.keySet()) {
                    
                    String recipientString = ptrfIdToMap.get(ptrfId);
                    List < String > recipientStringSt = recipientString.split('#');
                    
                    if (recipientStringSt.size() > 1) {
                        
                        for (Integer counter = 1; counter < recipientStringSt.size(); counter++) {
                            if (recipientStringSt[counter] != null && recipientStringSt[counter].trim().equalsIgnoreCase('fab')) {
                                if (ptrfIdtoList.containsKey(ptrfId) && fabEmailIds.containsKey(ptrfId)) {
                                    ptrfIdtoList.get(ptrfId).addAll(fabEmailIds.get(ptrfId));
                                }
                            }
                            if (recipientStringSt[counter] != null && recipientStringSt[counter].trim().equalsIgnoreCase('atp')) {
                                if (ptrfIdtoList.containsKey(ptrfId) && atpEmailIds.containsKey(ptrfId)) {
                                    ptrfIdtoList.get(ptrfId).addAll(atpEmailIds.get(ptrfId));
                                }
                            }
                        }
                    }

                }

                //including FAB,ATP in email CC list
                for (String ptrfId: ptrfIdCCMap.keySet()) {
                    
                    String recipientString = ptrfIdCCMap.get(ptrfId);
                    List < String > recipientStringSt = recipientString.split('#');
                    
                    if (recipientStringSt.size() > 1) {
                        
                        for (Integer counter = 1; counter < recipientStringSt.size(); counter++) {
                            
                            if (recipientStringSt[counter] != null && recipientStringSt[counter].trim().equalsIgnoreCase('fab')) {
                                if (ptrfIdccList.containsKey(ptrfId) && fabEmailIds.containsKey(ptrfId)) {
                                    ptrfIdccList.get(ptrfId).addAll(fabEmailIds.get(ptrfId));
                                }
                            }
                            
                            if (recipientStringSt[counter] != null && recipientStringSt[counter].trim().equalsIgnoreCase('atp')) {
                                if (ptrfIdccList.containsKey(ptrfId) && atpEmailIds.containsKey(ptrfId)) {
                                    ptrfIdccList.get(ptrfId).addAll(atpEmailIds.get(ptrfId));
                                }
                            }
                        }
                    }
                }

                //including FAB,ATP in email BCC list
                for (String ptrfId: ptrfIdBCCMap.keySet()) {
                    
                    String recipientString = ptrfIdBCCMap.get(ptrfId);
                    List < String > recipientStringSt = recipientString.split('#');
                    
                    if (recipientStringSt.size() > 1) {
                        
                        for (Integer counter = 1; counter < recipientStringSt.size(); counter++) {
                            
                            if (recipientStringSt[counter] != null && recipientStringSt[counter].trim().equalsIgnoreCase('fab')) {
                                if (ptrfIdbccList.containsKey(ptrfId) && fabEmailIds.containsKey(ptrfId)) {
                                    ptrfIdbccList.get(ptrfId).addAll(fabEmailIds.get(ptrfId));
                                }
                            }
                            if (recipientStringSt[counter] != null && recipientStringSt[counter].trim().equalsIgnoreCase('atp')) {
                                if (ptrfIdbccList.containsKey(ptrfId) && atpEmailIds.containsKey(ptrfId)) {
                                    ptrfIdbccList.get(ptrfId).addAll(atpEmailIds.get(ptrfId));
                                }
                            }
                        }
                    }

                }

                for (String ptrfName: PerPtrfDetailMap.keySet()) {
                    
                    DetailMap = PerPtrfDetailMap.get(ptrfName);
                    
                    if (DetailMap <> null) {
                        
                        if (DetailMap.values().size() > 0) {
                            
                            htmlBody = DetailMap.get(System.Label.EmailKeysetForBody);
                            subject = DetailMap.get(System.Label.EmailKeysetForSubject);
                            if (ptrfEcsNameMap.containsKey(ptrfName)) {
                                htmlBody = htmlBody.replace('#ECS', 'ECS : ' + ptrfEcsNameMap.get(ptrfName));
                            }
                        }
                    }
                    
                    if (htmlBody != null) {

                        Boolean flag = true;
                        
                        if (ptrfTemplateMap.get(ptrfName) == 'MRS_Void_Chip_Template') {
                            flag = true;
                            if (ptrfIdccList.containsKey(ptrfName)) {
                                ptrfIdccList.get(ptrfName).add(UserInfo.getUserEmail());
                            }
                        }

                        List < String > tempccList;

                        if (ptrfIdccList.get(ptrfName) == null) {
                            tempccList = new List < String > ();
                        } else {
                            if (ptrfIdccList.containsKey(ptrfName)) {
                                tempccList = ptrfIdccList.get(ptrfName);
                            }
                        }
                        
                        List < String > tempbccList;
                        
                        if (ptrfIdbccList.get(ptrfName) == null) {
                            tempbccList = new List < String > ();
                        } else {
                            if (ptrfIdbccList.containsKey(ptrfName)) {
                                tempbccList = ptrfIdbccList.get(ptrfName);
                            }
                        }
                        
                        if (ptrfIdtoList.get(ptrfName) != null) {
                            Messaging.SingleEmailMessage[] mail = MRSHandlerUtility.partingToCCBccAddress(ptrfIdtoList.get(ptrfName), tempccList, tempbccList, MRSHandlerUtility.orgWideAddr, flag, subject, htmlBody);
                            allMail.addAll(mail);
                        }
                    }
                }

                if (allMail != null && allMail.size() > 0) {
                    Messaging.SendEmailResult[] r = Messaging.sendEmail(allMail);
                }
            } else {
                //to-do
            }
        } catch (Exception e) {
            saveEmailExceptionErrorLog(e, '', '', 'EmailHandlerUtility', 'ptrfEmailMethod');
        } finally {
            //to-do
        }
    } //end of method

    public static MAP < String, LIST < String >> buildRecipientList(map < string, string > ptrfIdRecipientString, map < string, string > JobViewerListMap, Map < String, string > PtrfAccountMap, Boolean isPerPTRF, Map < String, string > fabPtrfMap) {
        
        try {
            MAP < String, LIST < String >> ReturnList = new MAP < String, LIST < String >> ();
            map < string, List < string >> ptrfJVEmailMap = new map < string, List < string >> ();
            //--------------------------------------------------------------------------------------------------       
            string[] ListString = new List < string > ();
            string[] eachRecipientList = new List < string > ();
            List < string > ToList = null;
            string UserString = null;
            string EmailString = null;
            string GroupString = null;
            string atpString = null;
            string cjvString = null;
            string fjvString = null;
            boolean atpCheck = false;
            //--------------------------- RETRIEVING USER LIST------------------------------           
            string[] ToUserEmailList = new List < string > ();

            Map < String, String > userStringMap = new Map < String, String > ();
            
            for (String ptrfName: ptrfIdRecipientString.keySet()) {
                
                UserString = '';
                EmailString = '';
                GroupString = '';
                atpString = '';
                cjvString = '';
                fjvString = '';
                atpCheck = false;
                ToList = new List < string > ();
                string Recipient = null;
                string trimmedRecipient = null;
                
                if (ptrfIdRecipientString <> null) {
                    
                    Recipient = ptrfIdRecipientString.get(ptrfName);
                    
                    if (Recipient <> null) {
                        
                        trimmedRecipient = Recipient.trim();
                        String str = trimmedRecipient.trim();
                        trimmedRecipient = str.replaceAll('(\\s+)', '');

                        List < string > trimmedRecipientList = null;
                        
                        if (trimmedRecipient <> null) { trimmedRecipientList = trimmedRecipient.split('#'); }
                        
                        Set < string > trimmedRecipientSet = new Set < String > ();
                        
                        if (trimmedRecipientList <> null) { trimmedRecipientSet.addall(trimmedRecipientList); }

                        if (trimmedRecipientList.size() > 0) {
                            
                            for (integer i = 1; i < trimmedRecipientList.size(); i++) {

                                if (trimmedRecipientList[i].containsignorecase(':')) {
                                    
                                    string substringBeforeColon = trimmedRecipientList[i].substringbefore(':');

                                    if (substringBeforeColon.trim().equalsignorecase('User')) {
                                        UserString = trimmedRecipientList[i].trim();
                                        userStringMap.put(ptrfName, UserString);
                                    } else if (substringBeforeColon.trim().equalsignorecase('Email')) {
                                        EmailString = trimmedRecipientList[i].trim();
                                    } else if (substringBeforeColon.trim().equalsignorecase('Group')) {
                                        GroupString = trimmedRecipientList[i].trim();
                                    }
                                }
                                
                                //===========
                                if (trimmedRecipientList[i].trim().equalsignorecase('cjv')) {
                                    cjvString = trimmedRecipientList[i].trim();
                                } else if (trimmedRecipientList[i].trim().equalsignorecase('fjv')) {
                                    fjvString = trimmedRecipientList[i].trim();
                                } else if (trimmedRecipientList[i].trim().equalsignorecase('atp')) {
                                    atpCheck = true;
                                }
                            }
                        }
                    } else {
                        //to-do
                    }
                }
                //----------------------------For recipient type user------------------------------------

                //---------------------------- For recipient type group -------------------------------------------------------------
                if (GroupString <> null && GroupString.trim() <> '') {

                    String trimmedGroupSub = null;
                    trimmedGroupSub = GroupString.trim().substringafter(':');

                    if (trimmedGroupSub.trim() <> null || trimmedGroupSub.trim() <> '') {
                        
                        List < string > eachGroupList = trimmedGroupSub.split(',');

                        if (eachGroupList.size() > 0) {
                            
                            for (integer i = 0; i < eachGroupList.size(); i++) {

                                string CSName = eachGroupList[i].trim() + '_Email';
                                CSName = CSName.toUpperCase();

                                //In order to handle the error System.InvalidParameterValueException: Custom Setting Name too long:
                                if (CSName <> null && CSName.trim().length() <= 38) {
                                    
                                    if (Environment_Variable__c.getInstance(CSName.trim()) <> null) {
                                        
                                        if (Environment_Variable__c.getInstance(CSName.trim()).Value__c.contains(';')) {
                                            ToList.addAll(Environment_Variable__c.getInstance(CSName.trim()).Value__c.split(';'));
                                        } else {
                                            ToList.add(Environment_Variable__c.getInstance(CSName.trim()).Value__c);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if (EmailString <> null && EmailString.trim() <> '') {

                    String trimmedEmailSub = NULL;
                    trimmedEmailSub = EmailString.trim().substringafter(':');

                    List < string > EmailList = new List < string > ();

                    if (trimmedEmailSub <> null && trimmedEmailSub.trim() != '') {
                        
                        EmailList = trimmedEmailSub.trim().split(',');
                        Set < String > emailSt = new Set < String > ();
                        emailSt.addAll(EmailList);
                        Set < String > emailRet = EmailValidation.parseValidEmails(emailSt);

                        if (emailRet != null && emailRet.size() > 0) ToList.addAll(emailRet);
                    }
                }
                
                returnlist.put(ptrfname, ToList);
            } //end of for 
            //--------------------------------------Jobviewer--------------------------------------------------------------

            if (JobViewerListMap != null) {
                
                if (JobViewerListMap.keySet().size() > 0) {
                    
                    List < PTRF_JobViewer_Info__c > pjiList;
                    
                    //SWGP-942: exclude inactive user from email recipient: add in user__r.isactive = true
                    pjiList = [
                        SELECT name, Email_Address__c, User__c, User__r.email, Jobview_Type__c, Jobview__c, User__r.Portal_Email__c, PTRF__c 
                        FROM PTRF_JobViewer_Info__c
                        WHERE PTRF__c IN: JobViewerListMap.keySet() 
                            and user__r.isActive = true//swgp-942
                    ];
                    //END-swgp-942
                    
                    List < String > ToJobviewerList;

                    for (PTRF_JobViewer_Info__c eachJV: pjiList) {

                        string eachJVptrfid = eachJV.PTRF__c;
                        
                        if (JobViewerListMap.containsKey(eachJVptrfid)) {

                            String CustomerFoundryJobview;
                            List < string > JVValue = JobViewerListMap.values();

                            if (JobViewerListMap.values().size() > 0) {
                                CustomerFoundryJobview = JobViewerListMap.get(eachJVptrfid).trim();
                            }
                            
                            string CustString = null;
                            string FoundString = null;
                            
                            if (CustomerFoundryJobview <> null) {
                                
                                CustString = CustomerFoundryJobview.substringbefore('$');
                                FoundString = CustomerFoundryJobview.substringafter('$');
                                
                                if (CustString.containsignorecase('Customer')) {
                                    
                                    string CustJVString = CustString.substringafter('Customer');
                                    List < string > CustJVList = new List < string > ();
                                    integer JVCustCounter = 0;
                                    
                                    if (CustJVString <> null) {
                                        if (CustJVString.contains(';')) {
                                            CustJVList = CustJVString.split(';');
                                        } else {
                                            CustJVList.add(CustJVString);
                                        }
                                        
                                        for (string CustJV: CustJVList) {
                                            if (eachJV.Jobview_Type__c.contains(CustJV)) {
                                                ++JVCustCounter;
                                            }
                                        }
                                    }
                                    
                                    if (JVCustCounter > 0) {

                                        if (cjvString <> null && cjvString.equalsignorecase('cjv')) {
                                            
                                            if (eachJV.User__c <> null) {

                                                for (string CustJV: CustJVList) {
                                                    
                                                    if (eachJV.Jobview_Type__c.contains(CustJV) && eachJV.Jobview__c == 'Customer') {
                                                        if (ptrfJVEmailMap.containsKey(eachJVptrfid)) {
                                                            ptrfJVEmailMap.get(eachJVptrfid).add(eachJV.User__r.Portal_Email__c);
                                                        } else {
                                                            ToJobviewerList = new List < String > ();
                                                            ToJobviewerList.add(eachJV.User__r.Portal_Email__c);
                                                            ptrfJVEmailMap.put(eachJVptrfid, ToJobviewerList);
                                                        }
                                                    }
                                                }
                                            } else if (eachJV.Email_Address__c <> null) {
                                                
                                                for (string CustJV: CustJVList) {
                                                    
                                                    if (eachJV.Jobview_Type__c.contains(CustJV) && eachJV.Jobview__c == 'Customer') {
                                                        if (ptrfJVEmailMap.containsKey(eachJVptrfid)) {
                                                            ptrfJVEmailMap.get(eachJVptrfid).add(eachJV.Email_Address__c);
                                                        } else {
                                                            ToJobviewerList = new List < String > ();
                                                            ToJobviewerList.add(eachJV.Email_Address__c);
                                                            ptrfJVEmailMap.put(eachJVptrfid, ToJobviewerList);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                if (FoundString.containsignorecase('Foundry')) {
                                    
                                    string FoundJVString = FoundString.substringafter('Foundry');
                                    List < string > FoundryJVList = new List < string > ();
                                    integer JVFoundCounter = 0;
                                    
                                    if (FoundJVString <> null) {
                                        
                                        if (FoundJVString.contains(';')) {
                                            FoundryJVList = FoundJVString.split(';');
                                        } else {
                                            FoundryJVList.add(FoundJVString);
                                        }

                                        for (string FounJV: FoundryJVList) {
                                            if (eachJV.Jobview_Type__c.containsignorecase(FounJV)) {
                                                ++JVFoundCounter;
                                            }
                                        }
                                    }
                                    
                                    if (JVFoundCounter > 0) {

                                        if (fjvString <> null && fjvString.equalsignorecase('fjv')) {

                                            if (eachJV.User__c <> null) {

                                                for (string FounJV: FoundryJVList) {
                                                    if (eachJV.Jobview_Type__c.containsignorecase(FounJV) && eachJV.Jobview__c == 'Foundry') {
                                                        if (ptrfJVEmailMap.containsKey(eachJVptrfid)) {
                                                            ptrfJVEmailMap.get(eachJVptrfid).add(eachJV.User__r.Portal_Email__c);
                                                        } else {
                                                            ToJobviewerList = new List < String > ();
                                                            ToJobviewerList.add(eachJV.User__r.Portal_Email__c);
                                                            ptrfJVEmailMap.put(eachJVptrfid, ToJobviewerList);
                                                        }
                                                    }
                                                }
                                            } else if (eachJV.Email_Address__c <> null) {
                                                for (string FounJV: FoundryJVList) {
                                                    if (eachJV.Jobview_Type__c.containsignorecase(FounJV) && eachJV.Jobview__c == 'Foundry') {
                                                        if (ptrfJVEmailMap.containsKey(eachJVptrfid)) {
                                                            ptrfJVEmailMap.get(eachJVptrfid).add(eachJV.Email_Address__c);
                                                        } else {
                                                            ToJobviewerList = new List < String > ();
                                                            ToJobviewerList.add(eachJV.Email_Address__c);
                                                            ptrfJVEmailMap.put(eachJVptrfid, ToJobviewerList);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            if (isPerPTRF) {

                for (String ptrfName: returnlist.keySet()) {
                    if (ptrfJVEmailMap.containsKey(ptrfName)) {
                        returnlist.get(ptrfName).addAll(ptrfJVEmailMap.get(ptrfName));
                    }
                }
            }
            //--------------------------------------Account Team Proxy ----------------------------------------------------------------------

            //--------------------------------------------Email-----------------------------------------------------------------
            if (userStringMap <> null && userStringMap.size() > 0) {
                
                String trimmedUserSub = null;
                List < string > eachUserList = new List < String > ();
                Map < String, List < String >> userNamePTRFMap = new Map < String, List < String >> ();
                
                for (String ptrf: userStringMap.keySet()) {
                    String fullUserName = userStringMap.get(ptrf);
                    userNamePTRFMap.put(ptrf, fullUserName.trim().substringafter(':').split(','));
                }
                
                for (String userCounter: userStringMap.values()) {
                    for (String usrName: userCounter.trim().substringafter(':').split(',')) {
                        eachUserList.add(usrName.trim().toLowerCase());
                    }
                }
                
                List < User > UserList = [select email, name, Username FROM User where Username IN: eachUserList and IsActive = True];

                for (String ptrfName: userNamePTRFMap.keySet()) {
                    
                    Set < String > userSt = new Set < String > ();
                    
                    for (String userName: userNamePTRFMap.get(ptrfName)) {
                        userSt.add(userName.trim().toLowerCase());
                    }
                    
                    for (User usrObject: UserList) {
                        if (userSt.contains(usrObject.Username) && returnlist.containsKey(ptrfName)) {
                            returnlist.get(ptrfName).add(usrObject.email);
                        }
                    }
                }
            }

            return ReturnList;
        } //end of try
        catch (Exception e) {
            saveEmailExceptionErrorLog(e, '', '', 'EmailHandlerUtility', 'buildRecipientList');
            return null;
        } finally {
            //to-do
        }
    } //end of method   

    public static Map < String, List < String >> getATPUserEmail(Map < String, string > PtrfAccountMap) {
        
        Map < String, List < String >> AccTeamMemberAccId = new Map < String, List < String >> ();

        try {
            if (PtrfAccountMap <> null) {
                
                List < String > lstTeamRoles = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');

                List < Account_Team_Proxy__c > accTeamProxylst = [Select User__r.Portal_Email__C, Team_Role__c, Account__c from
                    Account_Team_Proxy__c where Account__c in : PtrfAccountMap.values()
                    and Team_Role__c IN: lstTeamRoles and User__r.IsActive = True
                ];

                for (Account_Team_Proxy__c eachAccTeam: accTeamProxylst) {
                    
                    for (String ptrfId: PtrfAccountMap.keySet()) {

                        if (PtrfAccountMap.get(ptrfId) == eachAccTeam.Account__c) {
                            if (AccTeamMemberAccId.containsKey(ptrfId)) {
                                AccTeamMemberAccId.get(ptrfId).add(eachAccTeam.User__r.Portal_Email__C);
                            } else {
                                List < string > TeamMemberEmail = new List < string > ();
                                TeamMemberEmail.add(eachAccTeam.User__r.Portal_Email__C);
                                AccTeamMemberAccId.put(ptrfId, TeamMemberEmail);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            saveEmailExceptionErrorLog(e, '', '', 'EmailHandlerUtility', 'getATPUserEmail');
        }
        
        return AccTeamMemberAccId;
    }

    public static Map < String, List < String >> getFABUsersEmail(Map < String, string > fabPtrfMap) {

        Map < String, List < String >> fabEmailMap = new Map < String, List < String >> ();
        
        try {
            if (null != fabPtrfMap && !fabPtrfMap.isEmpty()) {

                //fetch all the distribution list
                List < String > fabList = fabPtrfMap.values();
                List < Fab_Distribution_Table__c > fabDistributionList = [select id, Fab_No__c, Distribution_List__c from Fab_Distribution_Table__c where Fab_No__c in : fabList];

                Map < String, String > fabDistributionMap = new Map < String, String > ();
                
                if (null != fabDistributionList && !fabDistributionList.isEmpty()) {
                    
                    for (Fab_Distribution_Table__c fabDL: fabDistributionList) {
                        fabDistributionMap.put(fabDL.Fab_No__c, fabDL.Distribution_List__c);
                    }
                    
                    Map < String, String > ptrfDLMap = new Map < String, String > ();
                    
                    for (String ptrfId: fabPtrfMap.keySet()) {
                        
                        String fabNo = fabPtrfMap.get(ptrfId);

                        if (fabDistributionMap.containsKey(fabNo)) {
                            if (fabEmailMap.containsKey(ptrfId)) {
                                if (fabDistributionMap.get(fabNo).contains(';')) {
                                    fabEmailMap.get(ptrfId).addAll(fabDistributionMap.get(fabNo).split(';'));
                                } else {
                                    fabEmailMap.get(ptrfId).addAll(new List < String > {
                                        fabDistributionMap.get(fabNo)
                                    });
                                }
                            } else {
                                List < string > fabEmailList = new List < string > ();
                                if (fabDistributionMap.get(fabNo).contains(';')) {
                                    fabEmailList.addAll(fabDistributionMap.get(fabNo).split(';'));
                                } else {
                                    fabEmailList.addAll(new List < String > {
                                        fabDistributionMap.get(fabNo)
                                    });
                                }
                                fabEmailMap.put(ptrfId, fabEmailList);
                            }
                        }
                    }
                }

            }
        } catch (Exception e) {
            saveEmailExceptionErrorLog(e, '', '', 'EmailHandlerUtility', 'getFABUsersEmail');
        }
        return fabEmailMap;
    }

    /**
         This method is for logging errors caught in exception during Email activity 
         @method name: saveEmailExceptionErrorLog
         @parameter:   1. Exception object.
                       2. Name of Object which created the exception.
                       3. MessageId of the log.
               4. Name of Component where exception occured
               5. Name of methid where exception occured.            
         @return :     Nothing
      **/
    public static void saveEmailExceptionErrorLog(Exception e, string objectName, string messageId, string componentName, string methodName) {
        SWIFT_Application_Log__c tempLog = new SWIFT_Application_Log__c();
        tempLog.Debug_Level__c = 'ERROR';
        tempLog.Apex_Component_Name__c = componentName;
        tempLog.Apex_Component_Id__c = [select id from apexclass where name = : componentName].id;
        tempLog.Error_Message__c = e.getmessage();
        tempLog.Stack_Trace__c = e.getstacktracestring();
        tempLog.Message_ID__c = messageId;
        tempLog.Method__c = methodName;
        tempLog.Trigger_Exception_Email__c = true;
        insert tempLog;
    }
}