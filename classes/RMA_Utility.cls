/**
 * Author: Surendranadh Nune
 * Company: GlobalFoundries,India
 * Project: Return Material Authorization
 * Description: This class acts as a utility class for RMA.
 * History:
 *    SurendranadhNune 18112015  -   Created.
 *    Psamal           28072017  -   Changes for adding fab ALTIS.
 *                           
 **/
public without sharing class RMA_Utility {
    
    /**
     * Author: Surendranadh Nune
     * Description: This method is used to get the Tab name from shortname  
     */ 
    public static String getTabFromShortName(String shortName){
        if(String.isNotBlank(shortName)){
            if(shortName.equals(RMA_Constants.tabName_DISPOSITION_OF_WAFER)){
                return RMA_Constants.DISPOSITION_OF_WAFER;
            }else if(shortName.equals(RMA_Constants.tabName_FAB_VALIDATION)){
                return RMA_Constants.TECHNICAL_VALIDATION;
            }else if(shortName.equals(RMA_Constants.tabName_RMA_INFORMATION)){
                return RMA_Constants.RMA_INFORMATION;
            }else{
                return RMA_Constants.RMA_ALL;
            }
        }
        return null;
    }
    
    /**
     * Author: Surendranadh Nune
     * Description: This method is used to get the recordtype id from Sobject name & record
     *              type developer name.
     */ 
    public static Id getRecordTypeId(String sObjName, String recordTypeName){
        Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{sObjName});
        Map<String,Schema.RecordTypeInfo> rtMapByName = descResult[0].getRecordTypeInfosByName();
        return rtMapByName.get(recordTypeName).getrecordtypeid();
    }
        
    //retrieve RMA Email Service Mail Address
    public static String retrieveRMAEmailServiceAddress(String rmaServiceName){
        //Id rmaServId = [SELECT Id, IsActive,FunctionName FROM EmailServicesFunction where FunctionName =: rmaServiceName and IsActive = true].Id;
        EmailServicesAddress rmaServAddr = [SELECT IsActive, Id, LocalPart, EmailDomainName, FunctionId, function.FunctionName 
                                            FROM EmailServicesAddress where Function.FunctionName  =: rmaServiceName and isActive=true ];
        return rmaServAddr.LocalPart+'@'+rmaServAddr.EmailDomainName;
    }
    
    //Nikhil - 28Nov16 - Method to check if user is added in the amount view permission set
    public static boolean checkAmountPermissionSet(){
        List<PermissionSetAssignment> lstPermissionSetUser = [SELECT Id 
                                                              FROM PermissionSetAssignment
                                                              WHERE PermissionSet.Name='RMA_Amount_View'
                                                                AND AssigneeId = :UserInfo.getUserId()];
        if(!lstPermissionSetUser.isEmpty()){
            return True;
        }
        return false;
    }
    
    //Method to check if user is among the Current Approver or Originator
    public static Boolean checkApprover(Id targetObjectId){
        List<String> lstGroupId = new List<String>();
        List<String> lstPublicGroups = new List<String>();
                        
        //check if the logged-in user as added as a User in the approval process
        for(ProcessInstanceWorkitem workItem: [SELECT p.Id,p.ActorID,p.Actor.Type from ProcessInstanceWorkitem p
                                                WHERE p.ProcessInstance.TargetObjectId =: targetObjectId
                                                  AND p.ProcessInstance.Status = 'Pending'])
        {
            
            if(workItem.Actor.Type == 'User' && workItem.ActorID == UserInfo.getUserId()){
                return True;
            }else if(workItem.Actor.Type == 'Queue'){ //Prepare list of queue to fetch the users from.
                lstGroupId.add(workItem.ActorID);
            }
        }
        //Fetching the users from the Group added in the Approval Queue
        if(lstGroupId != NULL && !lstGroupId.isEmpty()){
            for(GroupMember gm: [select UserOrGroupId from GroupMember where Group.Id in :lstGroupId and Group.Type = 'Queue']){
                if(String.valueOf(gm.UserOrGroupId).startsWith(RMA_Constants.GROUP_KEYPREFIX)){ 
                    lstPublicGroups.add(gm.UserOrGroupId);
                }
            }
            for(GroupMember gm: [select UserOrGroupId from GroupMember where Group.Id in :lstPublicGroups]){
                if(gm.UserOrGroupId == UserInfo.getUserId()){
                    return true;
                }
            }
        }        
        return false;
    }
    
    public static RMAwrapper getRMAtotalSystemMode(Id rmaId){
        RMA__c rmaRec = [SELECT Grand_Total_Price__c, Grand_Total_FAB_Validation__c, Grand_Total_Final__c 
                         FROM RMA__c WHERE Id = :rmaId LIMIT 1];
        RMAwrapper rmWrap = new RMAwrapper(rmaRec.Grand_Total_Price__c,rmaRec.Grand_Total_FAB_Validation__c,rmaRec.Grand_Total_Final__c);
        return rmWrap;
    }
    
    public static List<RMA_Return_Invoice__c> QueryLineItemsSystemMode(Id rmaId){
        return [SELECT Id,RMA__c,Wafer_Die_Unit_Price__c,Wafer_Id_CSR_Submission__c,Wafer_Id_Fab_Validated__c,Purchase_Order_Number__c,
                 Adjusted_Unit_Price__c,Total_Price__c,Wafer_Quantity__c,Wafer_Id_Regional_Personnel_Recommended__c,Process__c,Fab_Group__c,
                 Invoice_Number__c,Lot_Number__c,Name,Scrap_Limit__c,Wafer_Yield__c,RMA__r.Name,Total_Price_FAB_Validation__c,CreatedById ,
                 Wafer_Id_Fab_In_Validated__c,Total_Wfr_Qty_after_validation__c,Total_Price_Final__c,RMA__r.OwnerId,Invoice_Date__c,
                 Wafer_Id_Regional_Personnel_Not_Rec__c,Final_RMA_Wfr_Qty_To_Issue_CN_SO__c,Die_Quantity__c,GDPW__c,Device__c,
                 Die_Selling_Price__c,Die_Quantity_Fab_Validated__c,Die_Quantity_Regional_Validated__c,RMA_By__c,RMA__r.Workflow_Stage__c,
                 Invoice_Lot_Combination__c,Current_Die_Quantity__c,Invoice__r.Item_Type__c,Invoice__r.Ship_from_Address__c,Wafer_Id_Fab_9_10_CSR_Submission__c,
                 Wafer_Id_Fab_9_10_Fab_Validated__c,Wafer_Id_Fab_9_10_Fab_Invalidated__c,Wafer_Id_Fab_9_10_Regional_Validated__c,
                 Wafer_Id_Fab_9_10_Regional_Invalidated__c,Module_Quantity__c,Module_Quantity_Fab_Validated__c,Module_Quantity_Regional_Validated__c,
                 Current_Module_Quantity__c,Existing_Form_Factor_Quantity__c,Existing_Form_Factor__c,Bill_Quantity__c                
                FROM RMA_Return_Invoice__c 
                WHERE RMA__c= :rmaId
                ORDER BY Name
                LIMIT 2000];
    }
    
    public static List<String> getPickListValues(String ObjectName, String fieldAPIName){
        Map<String, Schema.sObjectField> field_map = Schema.describeSObjects(new String[]{ObjectName})[0].fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldAPIName).getDescribe().getPickListValues();
        List<String> pickListValues = new List<String>(); 
        for (Schema.PicklistEntry a : pick_list_values){ 
                pickListValues.add(a.getValue());
        }
        return pickListValues;
    }
    
    public static void moveToLibrary(id contentDocumentid){
        List<ContentWorkspace> LibraryId = [select id from ContentWorkspace where Name=:RMA_CONSTANTS.RMA_CONTENT_LIBRARY_NAME limit 1];
        ContentWorkspaceDoc cwd=new ContentWorkspaceDoc();
        cwd.ContentDocumentId=contentDocumentid;
        if(LibraryId.size()>0){
            cwd.ContentWorkspaceId=LibraryId[0].id;
            insert cwd;
        }        
    }
    
    public static boolean checkFab9or10(String Fab){
        return (Fab == 'FAB 9' || Fab == 'FAB 10' || Fab == 'ALTIS')?true:false;
    }
    
    public class RMAwrapper{
        public Decimal grandTotalCSR{get;set;}
        public Decimal grandTotalTec{get;set;}
        public Decimal grandTotalReg{get;set;}
        public RMAwrapper(Decimal CSR,Decimal Tec, Decimal Reg){
            grandTotalCSR = CSR;
            grandTotalTec = Tec;
            grandTotalReg = Reg;
        }
    }
    
    //NJain - 24Oct16 - Wrapper for amounts and unit price (For Customer Proforma and Scrap Certificate)
    public class LineItemWrapper{
        public Decimal UnitPrice{get;set;}
        public Decimal ItemValue{get;set;}
        public RMA_Return_Invoice__c invoice{get;set;}
        public LineItemWrapper(Decimal unitPrc,Decimal itmVal,RMA_Return_Invoice__c ri){
            UnitPrice = unitPrc;
            ItemValue = itmVal;
            invoice   = ri;
        }
    }
    
    //NJain - 24Oct16 - Prepare line item wrapper records for amounts and unit price (For Customer Proforma and Scrap Certificate)
    public static List<LineItemWrapper> prepareLineItemWrapper(String rmaId){
        List<LineItemWrapper> lstLineItemWrapper = new List<LineItemWrapper>();
        for(RMA_Return_Invoice__c  ri: [SELECT Invoice__r.Part_Number__c,Invoice__r.Sales_Order_Number__c,Invoice__r.Origin__c,
                                            Invoice_Date__c,Lot_Number__c,Purchase_Order_Number__c,Device__c,RMA__r.Compensation_Type__c,
                                            Wafer_Die_Unit_Price__c,Wafer_Quantity__c,Total_Price__c, Existing_Form_Factor_Quantity__c,
                                            Existing_Form_Factor__c,Invoice_Number__c,Adjusted_Unit_Price__c,RMA__r.Lot_Device_To_Return__c,
                                            RMA__r.Lot_Device_Requires_Scrap_Certificate__c,Wafer_Id_CSR_Submission__c,
                                            Wafer_Id_Fab_9_10_CSR_Submission__c,RMA__r.ReasonCode__c,Cust_Part_Num__c
                                          FROM RMA_Return_Invoice__c WHERE RMA__c =: rmaId]){
            LineItemWrapper liWrapper;
            if(ri.RMA__r.ReasonCode__c != 'R81'){
                if(ri.Adjusted_Unit_Price__c != NULL){
                    liWrapper = new LineItemWrapper(ri.Adjusted_Unit_Price__c,ri.Total_Price__c,ri);                    
                }else{
                    liWrapper = new LineItemWrapper(ri.Wafer_Die_Unit_Price__c,ri.Total_Price__c,ri);
                }
            }else{
                liWrapper = new LineItemWrapper(ri.Adjusted_Unit_Price__c,ri.Total_Price__c,ri);
            }
            lstLineItemWrapper.add(liWrapper);
        }
        return lstLineItemWrapper;
    }
    
}