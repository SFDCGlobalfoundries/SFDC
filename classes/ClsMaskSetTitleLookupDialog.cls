public class ClsMaskSetTitleLookupDialog {
    public list < Mask_Set_Title__c > listDisplayedMSTs {
        get;
        set;
    }
    public string searchString {
        get;
        set;
    }
    public integer startPageNum {
        get;
        set;
    }
    public integer endPageNum {
        get;
        set;
    }
    public integer totalRecords {
        get;
        set;
    }

    private list < Mask_Set_Title__c > totalMSTList;
    private SwiftPagination mstPagination;
    private integer PAGESIZE;


    public ClsMaskSetTitleLookupDialog() {
        listDisplayedMSTs = new list < Mask_Set_Title__c > ();
        searchString = '';
        string pgSize = Environment_Variable__c.getInstance('SwiftCustomLookupPageSize').Value__c;
        PAGESIZE = string.isBlank(pgSize) ? 0 : integer.valueOf(pgSize);
        startPageNum = 0;
        endPageNum = 0;
        totalRecords = 0;
        string custId, pgName, jobviewerStr;
        boolean isJobviewer = false;
        if (ApexPages.currentPage().getParameters().containsKey('aid')) {
            custId = ApexPages.currentPage().getParameters().get('aid');
            custId = string.escapeSingleQuotes(custId);
        }
        if (ApexPages.currentPage().getParameters().containsKey('pg')) {
            pgName = ApexPages.currentPage().getParameters().get('pg');
            pgName = string.escapeSingleQuotes(pgName);
        }
        if (ApexPages.currentPage().getParameters().containsKey('jv')) {
            jobviewerStr = ApexPages.currentPage().getParameters().get('jv');
        }
        isJobviewer = (jobviewerStr != null && jobviewerStr.equalsIgnoreCase('true')) ? true : false;
        totalMSTList = fetchMaskSetTitleList(custId, pgName, isJobviewer);
        totalMSTList = (totalMSTList == null) ? new list < Mask_Set_Title__c > () : totalMSTList;
        initializePagination(totalMSTList);
    }

    public void searchMSTs() {
        list < Mask_Set_Title__c > tempMSTList = new list < Mask_Set_Title__c > ();
        if (!string.isBlank(searchString)) {
            searchString = searchString.trim();
            for (Mask_Set_Title__c m: totalMSTList) {
                if (m.Name != null && m.Name.containsIgnoreCase(searchString)) {
                    tempMSTList.add(m);
                }
            }
            initializePagination(tempMSTList);
        } else {
            initializePagination(totalMSTList);
        }
    }

    private void initializePagination(list < Mask_Set_Title__c > mstList) {
        if (mstList != null) {
            mstPagination = new SwiftPagination(mstList);
            mstPagination.setPageSize(PAGESIZE);
            totalRecords = mstPagination.getResultSize();
            populatePaginationData();
        }
    }

    private void populatePaginationData() {
        listDisplayedMSTs.clear();
        listDisplayedMSTs.addAll((list < Mask_Set_Title__c > ) mstPagination.getRecords());
        startPageNum = ((mstPagination.getPageNumber() - 1) * PAGESIZE + 1);
        startPageNum = (totalRecords == 0) ? 0 : startPageNum;
        endPageNum = startPageNum + PAGESIZE - 1;
        endPageNum = (endPageNum > totalRecords) ? totalRecords : endPageNum;
    }
    public Pagereference goNext() {
        if (mstPagination != null) {
            mstPagination.next();
        }
        populatePaginationData();
        return null;
    }

    public Pagereference goPrev() {
        if (mstPagination != null) {
            mstPagination.previous();
        }
        populatePaginationData();
        return null;
    }

    public boolean getHasPrevious() {
        if (mstPagination != null) {
            return mstPagination.getHasPrevious();
        }
        return false;
    }

    public boolean getHasNext() {
        if (mstPagination != null) {
            return mstPagination.getHasNext();
        }
        return false;
    }

    /**
        This method is for fetching the Mask Set Titles for all pages. 
        @method name: fetchMaskSetTitleList
        @parameter:   1. Customer Id.
                      2. The page from where the call is made.
                      3. The flag whether the person is a jobviewer or not.
        @return :     List of Mask Set Title records.
    **/

    private static list < Mask_Set_Title__c > fetchMaskSetTitleList(string customerId, String page, Boolean isJobViewer) {
        if (page == 'SendData') {
            list < Mask_Set_Title__c > mstList = new list < Mask_Set_Title__c > ();
            set < Id > setUniqueMSTId = new set < Id > ();
            for (Mask_Set_Title__c m: [select Id, name from Mask_Set_Title__c where Id in (select Mask_Set_Title__c from MRS__c) order by Name]) {
                if (!setUniqueMSTId.contains(m.Id)) {
                    mstList.add(m);
                    setUniqueMSTId.add(m.Id);
                }
            }
            return mstList;
        }
        set < string > setValidPage = new set < string > {
            'CustomerGDSOutReview', 'FoundryGDSOutReview', 'CustomerFrameMockup', 'FoundryFrameMockup', 'HoldResume', 'LayerSummary'
        };
        if (string.isBlank(customerId) || string.isBlank(page)) {
            return new list < Mask_Set_Title__c > ();
        } else if ((!page.contains('MEBES')) && (!setValidPage.contains(page))) {
            return new list < Mask_Set_Title__c > ();
        }

        Id userId = UserInfo.getUserId();
        set < String > setLoggedInUserGroups = new set < String > ();
        setLoggedInUserGroups.addAll(MRSHandlerUtility.fetchCurrentUserGroup(userId));
        Boolean isUserMEBES = false;
        Boolean isUserGlobalShuttle = false;
        Boolean isUserTDTIMPW = false;
        Boolean isUserMDP = false;
        Boolean isUserAdmin = false;
        Boolean isTapeOutCenter = false;
        Boolean flag = true;
        String chipName = Label.SWIFT_Frame_Status;
        String PTRForDRT = 'DRT';
        set < String > setReleased = new set < String > {
            'N.A.', 'Released', 'Hold', 'Shipped'
        };
        Boolean isUserGroup = false;
        Boolean isRecordFetched = false;
        if (setLoggedInUserGroups.size() > 0) {
            for (String userGroup: setLoggedInUserGroups) {
                if (userGroup.equalsIgnoreCase('Swift_GlobalShuttle') || userGroup.equalsIgnoreCase('Swift_TDTI_MPW') || userGroup.equalsIgnoreCase('Swift_MDP') || userGroup.equalsIgnoreCase('Swift_Tapeout_Centre') || userGroup.equalsIgnoreCase('Swift_Tapeout_Application') || userGroup.equalsIgnoreCase('Swift_Tapeout_Operations') || userGroup.equalsIgnoreCase('SWIFT_Admin') || userGroup.equalsIgnoreCase('Swift_RMG') || userGroup.equalsIgnoreCase('SWIFT_Support')) {
                    isUserMEBES = true;
                    if (Environment_Variable__c.getInstance('MPW_Tech_Geo_GT_20').Value__c.containsIgnoreCase(userGroup)) {
                        isUserGlobalShuttle = true;
                        isUserGroup = true;
                        isRecordFetched = true;
                    }
                    if (Environment_Variable__c.getInstance('MPW_Tech_Geo_LT_20').Value__c.containsIgnoreCase(userGroup)) {
                        isUserTDTIMPW = true;
                        isUserGroup = true;
                        isRecordFetched = true;
                    }
                    if (Environment_Variable__c.getInstance('TECH_GEO_LT_20').Value__c.containsIgnoreCase(userGroup)) {
                        isUserMDP = true;
                        isUserGroup = true;
                        isRecordFetched = true;
                    }
                    if (Environment_Variable__c.getInstance('ALL_VIEW_ALL_APPROVAL').Value__c.containsIgnoreCase(userGroup)) {
                        isUserAdmin = true;
                        isRecordFetched = true;
                    }
                    if (Environment_Variable__c.getInstance('ALL_VIEW_NO_APPROVAL').Value__c.containsIgnoreCase(userGroup)) {
                        isTapeOutCenter = true;
                        isRecordFetched = true;
                    }
                }
            }
        }
        Set < Id > existingPtrfSt = new Set < Id > ();
        Set < Id > mrsLayerChipIdSt = new Set < Id > ();
        Set < Id > ptrfIdSt = new Set < Id > ();
        Map < Id, Id > ptrfAndChipId = new Map < Id, Id > ();
        List < String > teamRole = Environment_Variable__c.getInstance('SwiftFETeamRoles').Value__c.split(',');
        List < Account_Team_Proxy__c > accTeamProxy = [Select Id, Account__c, User__c, Team_Role__c FROM Account_Team_Proxy__c WHERE User__c = : UserInfo.getUserId() AND Account__c = : customerId AND Team_Role__c IN: teamRole AND User__r.IsActive = true];

        if (accTeamProxy != null && accTeamProxy.size() > 0) {
            isUserAdmin = true;
        }
        List < PTRF__c > mrsLayerChiplst = [SELECT Id, MaskSetTitle__c, MaskSetTitle__r.Name, Tech_Geo__c, Frame_Mockup__c, Frame_Tapeout__c, Prime_Tapeout__c, Prime_GDSOUT_Review__c FROM PTRF__c WHERE Customer__c = : customerId and MaskSetTitle__c != null and MaskSetTitle__r.Name != null ORDER BY MaskSetTitle__r.Name];
        if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
            Double mdpTechGeoCutoff = Double.valueOf(MRSHandlerUtilityExtn.loadEnvVariable('Swift_MDP_Tech_Geo_Cut_Off', '0.022'));
            for (PTRF__c obj: mrsLayerChiplst) {
                if ((isUserMDP || isUserGlobalShuttle || isUserTDTIMPW) && !isUserAdmin && !isTapeOutCenter) {
                    String startsWithMPW = 'MPW%';
                    /** Globalshuttle can only view PTRFs with Tech Geo greater than 20nm **/
                    if (isUserGlobalShuttle && !isUserTDTIMPW && !isUserMDP && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW') && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) > 0.02) {
                        mrsLayerChipIdSt.add(obj.Id);
                        existingPtrfSt.add(obj.Id);
                    } else if (isUserGlobalShuttle && isUserTDTIMPW && !isUserMDP && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW')) {
                        mrsLayerChipIdSt.add(obj.Id);
                        existingPtrfSt.add(obj.Id);
                    } else if (isUserGlobalShuttle && !isUserTDTIMPW && isUserMDP) {
                        if (isUserGlobalShuttle && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW') && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) > 0.02) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }
                        if (isUserMDP && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= mdpTechGeoCutoff) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }
                    } else if (isUserGlobalShuttle && isUserTDTIMPW && isUserMDP) {
                        if (isUserGlobalShuttle && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW') && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) > 0.02) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }

                        if ((isUserTDTIMPW) && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= 0.02) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }
                        if ((isUserMDP) && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= mdpTechGeoCutoff) {
                            mrsLayerChipIdSt.add(obj.Id);
                            existingPtrfSt.add(obj.Id);
                        }
                    } else if (!isUserGlobalShuttle && isUserTDTIMPW && !isUserMDP && obj.MaskSetTitle__r.Name != null && obj.MaskSetTitle__r.Name.startsWith('MPW') && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= 0.02) {
                        mrsLayerChipIdSt.add(obj.Id);
                        existingPtrfSt.add(obj.Id);
                    } else if (!isUserGlobalShuttle && (isUserTDTIMPW || !isUserTDTIMPW) && (isUserMDP) && obj.Tech_Geo__c != null && obj.Tech_Geo__c.toUppercase().contains('UM') && obj.Tech_Geo__c.toUppercase().substringBefore('UM') != null && Double.valueOf(obj.Tech_Geo__c.toUppercase().substringBefore('UM').trim()) <= mdpTechGeoCutoff) {
                        mrsLayerChipIdSt.add(obj.Id);
                        existingPtrfSt.add(obj.Id);
                    }
                    /** MDP and TDTI-MPW can only view PTRFs with Tech Geo lesser than 20nm **/
                } else {
                    mrsLayerChipIdSt.add(obj.Id);
                }
            }
        }
        Boolean groupApproval = false;
        if (!page.contains('HoldResume') && !page.contains('LayerSummary')) {
            String jobView = 'SELECT Jobview__c,Jobview_Type__c,PTRF__c,PTRF__r.Customer__c FROM PTRF_JobViewer_Info__c WHERE Jobview_Type__c';
            if (page.contains('FrameMockup')) {
                jobView = jobView + ' INCLUDES (\'Frame Mockup\')';
            }
            if (page == 'CustomerGDSOutReview' || page == 'FoundryGDSOutReview') {
                jobView = jobView + ' INCLUDES (\'Prime GDSOUT Review\')';
            }
            if (page.contains('MEBES')) {
                jobView = jobView + ' INCLUDES (\'MEBES Jobview\')';
                if (page.contains('Customer')) {
                    jobView = jobView + ' AND Jobview__c= \'Customer\'';
                } else if (page.contains('Foundry')) {
                    jobView = jobView + ' AND Jobview__c= \'Foundry\'';
                }

            }
            if (page == 'CustomerFrameMockup' || page == 'CustomerGDSOutReview') {
                jobView = jobView + ' AND Jobview__c= \'Customer\'';
            } else if (page == 'FoundryFrameMockup' || page == 'FoundryGDSOutReview') {
                jobView = jobView + ' AND Jobview__c= \'Foundry\'';
            }
            jobView = jobView + ' AND User__c= :userId';
            jobView = jobView + ' AND PTRF__r.Customer__c= :customerId';
            List < PTRF_JobViewer_Info__c > ptrfJobView = Database.Query(jobView);
            if (ptrfJobView != null && ptrfJobView.size() > 0) {
                for (PTRF_JobViewer_Info__c ptrfJobViewObj: ptrfJobView) {
                    ptrfIdSt.add(ptrfJobViewObj.PTRF__c);
                }
                groupApproval = true;
            }

            if (isUserGroup && groupApproval) {
                if (mrsLayerChiplst != null && mrsLayerChiplst.size() > 0) {
                    for (Id ptrfId: ptrfIdSt) {
                        if (!existingPtrfSt.contains(ptrfId)) {
                            mrsLayerChipIdSt.add(ptrfId);
                        }
                    }
                }
            }
        }
        Boolean performApproval;
        if ((page.contains('MEBES') && isUserMEBES)) {
            performApproval = false;
            isRecordFetched = true;
        } else if (isUserAdmin) {
            performApproval = false;
            isRecordFetched = true;
        } else {
            performApproval = true;
            if (!isUserMDP && !isUserGlobalShuttle && !isUserTDTIMPW && !isTapeOutCenter && ptrfIdSt.size() > 0) {
                isRecordFetched = true;
            } else {
                isRecordFetched = false;
            }
        }
        set < String > setOfLCStatus = new set < String > {
            'Cancel', 'Void', 'Hold'
        };
        set < String > setOfStatus = new set < String > {
            'N.A.', 'Released', 'Hold', 'Shipped'
        };

        String mrsLayerChip;
        set < Id > setUniqueMSTId = new set < Id > ();
        list < Mask_Set_Title__c > mstList = new list < Mask_Set_Title__c > ();
        Mask_Set_Title__c mstObj;
        for (PTRF__c mrsLayeChipObject: mrsLayerChiplst) {
            if (mrsLayerChipIdSt.contains(mrsLayeChipObject.Id)) {
                if (page.contains('FrameMockup')) {
                    if (mrsLayeChipObject.Frame_Mockup__c && mrsLayeChipObject.Frame_Tapeout__c) {
                        if (performApproval && isJobViewer) {
                            if (ptrfIdSt.contains(mrsLayeChipObject.Id)) {
                                if (!setUniqueMSTId.contains(mrsLayeChipObject.MaskSetTitle__c)) {
                                    mstObj = new Mask_Set_Title__c(Id = mrsLayeChipObject.MaskSetTitle__c, Name = mrsLayeChipObject.MaskSetTitle__r.Name);
                                    mstList.add(mstObj);
                                    setUniqueMSTId.add(mrsLayeChipObject.MaskSetTitle__c);
                                }
                            }
                        } else {
                            if (!setUniqueMSTId.contains(mrsLayeChipObject.MaskSetTitle__c)) {
                                mstObj = new Mask_Set_Title__c(Id = mrsLayeChipObject.MaskSetTitle__c, Name = mrsLayeChipObject.MaskSetTitle__r.Name);
                                mstList.add(mstObj);
                                setUniqueMSTId.add(mrsLayeChipObject.MaskSetTitle__c);
                            }
                        }
                    }
                } else if (page.containsIgnoreCase('GDSOut')) {
                    if (mrsLayeChipObject.Prime_Tapeout__c && mrsLayeChipObject.Prime_GDSOUT_Review__c) {
                        if (performApproval && isJobViewer) {
                            if (ptrfIdSt.contains(mrsLayeChipObject.Id)) {
                                if (!setUniqueMSTId.contains(mrsLayeChipObject.MaskSetTitle__c)) {
                                    mstObj = new Mask_Set_Title__c(Id = mrsLayeChipObject.MaskSetTitle__c, Name = mrsLayeChipObject.MaskSetTitle__r.Name);
                                    mstList.add(mstObj);
                                    setUniqueMSTId.add(mrsLayeChipObject.MaskSetTitle__c);
                                }
                            }
                        } else {
                            if (!setUniqueMSTId.contains(mrsLayeChipObject.MaskSetTitle__c)) {
                                mstObj = new Mask_Set_Title__c(Id = mrsLayeChipObject.MaskSetTitle__c, Name = mrsLayeChipObject.MaskSetTitle__r.Name);
                                mstList.add(mstObj);
                                setUniqueMSTId.add(mrsLayeChipObject.MaskSetTitle__c);
                            }
                        }

                    }
                } else if (page.contains('MEBES')) {
                    if (performApproval && isJobViewer) {
                        if (ptrfIdSt.contains(mrsLayeChipObject.Id)) {
                            if (!setUniqueMSTId.contains(mrsLayeChipObject.MaskSetTitle__c)) {
                                mstObj = new Mask_Set_Title__c(Id = mrsLayeChipObject.MaskSetTitle__c, Name = mrsLayeChipObject.MaskSetTitle__r.Name);
                                mstList.add(mstObj);
                                setUniqueMSTId.add(mrsLayeChipObject.MaskSetTitle__c);
                            }
                        }
                    } else {
                        if (!setUniqueMSTId.contains(mrsLayeChipObject.MaskSetTitle__c)) {
                            mstObj = new Mask_Set_Title__c(Id = mrsLayeChipObject.MaskSetTitle__c, Name = mrsLayeChipObject.MaskSetTitle__r.Name);
                            mstList.add(mstObj);
                            setUniqueMSTId.add(mrsLayeChipObject.MaskSetTitle__c);
                        }
                    }
                } else if (page.contains('HoldResume')) {
                    if (!setUniqueMSTId.contains(mrsLayeChipObject.MaskSetTitle__c)) {
                        mstObj = new Mask_Set_Title__c(Id = mrsLayeChipObject.MaskSetTitle__c, Name = mrsLayeChipObject.MaskSetTitle__r.Name);
                        mstList.add(mstObj);
                        setUniqueMSTId.add(mrsLayeChipObject.MaskSetTitle__c);
                    }
                } else if (page.contains('LayerSummary')) {
                    if (!setUniqueMSTId.contains(mrsLayeChipObject.MaskSetTitle__c)) {
                        mstObj = new Mask_Set_Title__c(Id = mrsLayeChipObject.MaskSetTitle__c, Name = mrsLayeChipObject.MaskSetTitle__r.Name);
                        mstList.add(mstObj);
                        setUniqueMSTId.add(mrsLayeChipObject.MaskSetTitle__c);
                    }
                }
            }

        }
        return mstList;
    }
}