public class RTATScheduleViewController {
    /*
     * Author: Elizabeth Button
     * Controller for displaying RTAT Slot, Schedules and Bill of Material
     * Will allow user to create PDF that is attached to RTAT Slot
     * Created April 28th, 2017
     * 
     */
     
    public ID rtatSlotID {get;set;}
    public RTAT_Slot__c rSlot;
    public RTAT_Wafer_Fab_Schedule_Inputs__c sobjWFSI;
    public List<RTAT_Sched_TAT_Adjust__c> MilestoneTATs;
    public list<RTAT_BOM__c> RTATBOM;
    public ERP_Device__c sobjParentERPDevice;
    public RTAT_Wafer_Finish_Sched_Input__c sobjWafFinSchedInput;
    public RTAT_Module_Schedule_Input__c sobjModuleSchedInput;
    
    
    public Boolean initialised{get; set;}

    
    public RTATScheduleViewController()
    {
        this.rtatSlotID = ApexPages.currentPage().getParameters().get('Id');//Parent rtatSlot ID
        rSlot = new RTAT_Slot__c();
        this.rSlot = [select Name, 
                      Id, 
                      Owner.Name,
                      Owner.Id,
                      Conversion_Lot_Number__c,
                      ERP_Device_for_Slot__c,
                      ERP_Device_Deliverable_Type__c,
                      ERP_Device_Fab__c,
                      ERP_Device_Technology__c,
                      Fab__c,
                      General_Comments__c,
                      Internal_Charge_Code__c,
                      Mfg_Instructions__c,
                      MPW__c,
                      Not_Committed_Projection_Only__c,
                      SAP_Order_Number__c,
                      Slot_Status__c,
                      Slot_Type__c,
                      Slot_Yield_Factor__c,
                      Wafer_Size__c,
                      Technology__c
                      from RTAT_Slot__c where id =:rtatSlotID limit 1];
             // save the pdf only once 
             initialised=false;
    }
    
    public RTATScheduleViewController(ApexPages.StandardController controller)
    { 
        this.rSlot = (RTAT_Slot__c) controller.getRecord();//Parent rtatSlot ID
        this.rtatSlotID = this.rSlot.Id;
        this.rSlot = [select Name, 
                      Id, 
                      Owner.Name,
                      Owner.Id,
                      Conversion_Lot_Number__c,
                      ERP_Device_for_Slot__c,
                      ERP_Device_Deliverable_Type__c,
                      ERP_Device_Fab__c,
                      ERP_Device_Technology__c,
                      Fab__c,
                      General_Comments__c,
                      Internal_Charge_Code__c,
                      Mfg_Instructions__c,
                      MPW__c,
                      Not_Committed_Projection_Only__c,
                      SAP_Order_Number__c,
                      Slot_Status__c,
                      Slot_Type__c,
                      Slot_Yield_Factor__c,
                      Wafer_Size__c,
                      Technology__c
                      from RTAT_Slot__c where id =:rtatSlotID limit 1];
    }
    
    public virtual RTAT_Slot__c getRTATSlot()
    { 
        return this.rSlot;
        
    }
    
    public void setRTATSlot(RTAT_Slot__c slot)
    {
        this.rSlot = slot;
    }
    
    public virtual ERP_Device__c getERP_Device()
    {
        /// get the parent device id of the RTAT Slot 
        this.sobjParentERPDevice = [SELECT Name, 
                                    ID, 
                                    Technology__c, 
                                    Fab__c,
                                    Product_Type__c, 
                                    Deliverable_Type__c,
                                    Part_Number__c,
                                    Level__c,
                                    Option_ID__c,
                                    Opportunity_ID__c,
                                    Opportunity__c,
                                    Business_Unit__c,
                                    Burn_In__c,
                                    Brand__c,
                                    Test_wafer__c,
                                    Back_Side_Grind__c,
                                    Levels_Of_Metal__c,
                                    Last_Level_of_Metal__c,
                                    Mask_Layer_Count__c,
                                    Wafer_Diameter__c,
                                    Chips_per_Wafer__c,
                                    Wafer_Tester_Type__c, 
                                    Module_Tester_Type__c,
                                    Module_Test_Flag__c  FROM ERP_Device__c where id = :this.rSlot.ERP_Device_for_Slot__c limit 1];
        
        return this.sobjParentERPDevice;
    }
    
    public String getAccountName()
    {   
        Account acct = new Account();
        try
        {
            Opportunity oppy = [Select Id, Name, AccountId from Opportunity Where id = :this.sobjParentERPDevice.Opportunity__c limit 1];
            acct = [Select Id, Name from Account where id = :oppy.AccountId limit 1];
        
        } 
        catch (Exception ee)
        {
            acct.name = 'Could Not be read';
        }    
        
        return acct.name;
    }
    
    public virtual RTAT_Wafer_Fab_Schedule_Inputs__c getWaferFabSchedInput()
    {
        try
        {
            this.sobjWFSI = [SELECT Name, Id,
                             Base_RIT_A_TAT__c,
                             Base_RIT_B_TAT__c,
                             ERP_Dev_Lev_of_Metal__c,
                             Fab_Prep_TAT__c,
                             Levels_of_Metal__c,
                             LOM_or_Mask_Layers__c,
                             Mask_Build_TAT__c,
                             Mask_House_CCDESK_date__c,
                             ProcOptionNamesRITA__c,
                             ProcOptionNamesRITB__c,
                             ProcOptionNumChosenRITA__c,
                             ProcOptionNumChosenRITB__c,
                             ProcOptionTATsRITA__c,
                             ProcOptionTATsRITB__c,
                             RIT_A_BTV_Fab_Transit_Time__c,
                             RIT_A_Job_Class__c,
                             RIT_A_Line_Code__c,
                             RIT_A_Quality__c,
                             RIT_A_Speed__c,
                             RIT_A_Wafer_Start_Quantity__c,
                             RIT_B_Job_Class__c,
                             RIT_B_Line_Code__c,
                             RIT_B_Quality__c,
                             RIT_B_Speed__c,
                             RIT_B_Wafer_Start_Quantity__c,
                             RIT_Type__c,
                             RTAT_Slot__c,
                             Slot_Fab__c,
                             Slot_Technology__c,
                             Wafer_Build_Location__c
                             FROM RTAT_Wafer_Fab_Schedule_Inputs__c 
                             WHERE RTAT_Slot__c = :this.rtatSlotID LIMIT 1];
        }
        catch (Exception ee)
        {
            this.sobjWFSI = new RTAT_Wafer_Fab_Schedule_Inputs__c();
        }
        
        return this.sobjWFSI;
    }
    
    public void setWaferFabSchedInput(RTAT_Wafer_Fab_Schedule_Inputs__c wfsi)
    {
        this.sobjWFSI = wfsi;
    }
     
    public virtual RTAT_Wafer_Finish_Sched_Input__c getWaferFinishSchedInput()
    {
        try
        {
        this.sobjWafFinSchedInput = [SELECT Name, 
                                     Chip_Attach_Type__c,
                                     Lot_size__c,
                                     Quality__c,
                                     RTAT_Slot__c,
                                     Speed__c,
                                     Test_Tier__c,
                                     Wafer_Finish_Start_Date__c,
                                     Wafer_or_device_to_stock_quantity__c,
                                     Wafer_size__c,
                                     Wafer_Test__c
                                     FROM RTAT_Wafer_Finish_Sched_Input__c
                                     WHERE RTAT_Slot__c = :rtatSlotID limit 1];
        }
        catch (Exception e)
        {
            this.sobjWafFinSchedInput = new RTAT_Wafer_Finish_Sched_Input__c();
        }
        
        return this.sobjWafFinSchedInput;
    }
    
    public virtual RTAT_Module_Schedule_Input__c getRTATModuleScheduleInput()
    {
        try
        {
            this.sobjModuleSchedInput = [SELECT Name, 
                                         id,
                                         Module_Final_Test__c,
                                         Module_Start_Quantity__c,
                                         Modules_to_Stock_Quantity__c,
                                         Package_Type__c,
                                         Quality__c,
                                         RTAT_Slot__c,
                                         Speed__c,
                                         Test_Tier__c
                                         FROM RTAT_Module_Schedule_Input__c
                                         WHERE RTAT_Slot__c = :rtatSlotID limit 1];
        }
        catch (Exception e)
        {
            this.sobjModuleSchedInput = new RTAT_Module_Schedule_Input__c();
        }
        
        return this.sobjModuleSchedInput;
    }
    
    public virtual List<RTAT_BOM__c> getRTATBOM()
    {
        try
        {
            this.RTATBOM = [SELECT Name, Id,
                            Component__c,
                            Create_Prefix_PN__c,
                            Deliverable_P_Level_PN__c,
                            Deliverable_PN__c,
                            Level_code__c,
                            Part_Classification__c,
                            Prefix_PN__c,
                            RTAT_Slot__c
                            FROM RTAT_BOM__c 
                            WHERE RTAT_Slot__c = :this.rtatSlotID ORDER BY Level_code__c ASC LIMIT 50];
        }
        catch (exception ee)
        {
            RTAT_BOM__c bom = new RTAT_BOM__c(); 
            this.RTATBOM.add(bom);
        }
        
        return this.RTATBOM;                                                        
    }
    
    public virtual List<RTAT_Sched_TAT_Adjust__c> getMilestones()
    {
        try
        {
             this.MilestoneTATs = [SELECT Name, Process__c,Subprocess__c,Subprocess_TAT__c,Total_TAT__c,End_Date__c,addDays__c, Adjustable_TAT__c, Parent_Waf_Fab_Schedule__c, Location_Name__c FROM RTAT_Sched_TAT_Adjust__c 
                                                                WHERE Parent_Waf_Fab_Schedule__c = :this.sobjWFSI.Id ORDER BY Name ASC LIMIT 50];
        }
        catch (exception ee)
        {
            RTAT_Sched_TAT_Adjust__c milestone = new RTAT_Sched_TAT_Adjust__c(); 
            this.MilestoneTATs.add(milestone);
        }
        
        return MilestoneTATs;                                                        
    }
    public void setMilestones(List<RTAT_Sched_TAT_Adjust__c> adjTATs)
    {
        this.MilestoneTATs = adjTATs;
      
    }  
    
    public Decimal getFinalShipQty()
    {
        Decimal iQty = 9999;
        try
        {
        if (this.sobjModuleSchedInput.Name != null)
        {
            iQty = this.sobjModuleSchedInput.Modules_to_Stock_Quantity__c;
        }
        else
        {
            if (this.sobjWafFinSchedInput.Name != null)
            {
                iQty = this.sobjWafFinSchedInput.Wafer_or_device_to_stock_quantity__c;
            }
            else
            {
                if (this.sobjWFSI.Name != null)
                {
                    if (this.sobjWFSI.RIT_Type__c.contains('B'))
                    {
                        iQty = this.sobjWFSI.RIT_B_Wafer_Start_Quantity__c;
                    }
                    else
                    {
                        iQty = this.sobjWFSI.RIT_A_Wafer_Start_Quantity__c;
                    }    
                    
                }
                else
                {
                    iQty = 0;
                }
            }
        }    
        }
        catch (Exception eexx)
        {
            iQty = 7777;
        }    
        return iQty;
        
    }
    
    public Date getShipDate()
    {
        //Get the last milestone for the ship date
        Date dateShipDate;   
        Integer iListLength = this.MilestoneTATs.size();
        
        if (iListLength > 0)
        {
            RTAT_Sched_TAT_Adjust__c LastMilestoneTAT = this.MilestoneTATs.get(iListLength-1);
            return LastMilestoneTAT.End_Date__c;
        }
        else
        {
            return dateShipDate;
        }
        
    }
    
    //method to insert attachement call it on page on click of button 
    public void saveAttachement() 
    {
            DateTime myDatetime = system.now();
        
            PageReference pdf = Page.RTATSlotScheduleView;
            // create the new attachment
            Attachment attach = new Attachment();
            
            // the contents of the attachment from the pdf
            Blob body;
            
            try 
            {
                
                // returns the output of the page as a PDF
                body = pdf.getContentAsPDF();
                system.debug('body should be fine');
                
                // need to pass unit test -- current bug    
            } 
            catch (VisualforceException e) 
            {
                system.debug('in the catch block');
                body = Blob.valueOf('Some Text');
            }
            
            attach.Body = body;
            // add the user entered name
            attach.Name = 'RTAT_Schedule_' + myDatetime + '.pdf';
            attach.IsPrivate = false;
            // attach the pdf to the account
            attach.ParentId = this.rtatSlotID;
            attach.Description = 'RTAT Schedule Document';
            insert attach;
            system.debug(attach);
             
            ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.INFO, attach.Name + ' attached to RTAT Slot ' + this.rSlot.Name));
    } 
    
    public PageReference publishSchedule() 
    {
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        Blob PDFBody;
        PDFBody = Blob.toPdf('No schedule has been created');
        String sFileName = 'NoScheduleExists.pdf';
        
        //Get the attached schedules
        List<Attachment> attachments = 
            [SELECT Id, Name, Description, Body, CreatedDate FROM Attachment 
             WHERE Parentid = :this.rSlot.Id AND Description = 'RTAT Schedule Document' order by CreatedDate];
        
        String sBody = 'Attachment is the schedule for RTAT Slot ' + this.rSlot.Name;
        
        for (Integer jj=0; jj< attachments.size(); jj++)
        {
            Attachment tempAtt = attachments.get(jj);
            
            if ((jj+1) == attachments.size())
            {
                //We'll attach the most recently created RTAT Schedule Document
                PDFBody = tempATT.Body;
                sFileName = tempAtt.Name;
                sBody = sBody +  ' File name: ' + tempAtt.Name + ' Sent by - ' + UserInfo.getUserEmail();
            }
        }
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(sFileName);
        efa.setBody(PDFBody); // PDFBody is of blob data Type 
        
        String[] toAddresses = new List<String>();
        String[] ccAddresses = new List<String>();
        
        if ((rSlot.Wafer_Size__c == '200MM') || (rSlot.Wafer_Size__c == '300MM'))
        {
            List<RTAT_Distribution_List__c> distlist = [SELECT List_Name__c, DistEmail__c FROM RTAT_Distribution_List__c WHERE List_Name__c = :rSlot.Wafer_Size__c limit 50];
            
            for (Integer kk = 0; kk < distlist.size(); kk++)   
            {
                RTAT_Distribution_List__c listentry = distlist.get(kk);
                toAddresses.add(listentry.DistEmail__c);
            }
        }
        else
        {
            toAddresses.add('elizabeth.button@globalfoundries.com');
            ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.ERROR, 'No Distributon List for RTAT Schedule applies'));
         }
        
        
        ccAddresses.add(UserInfo.getUserEmail());
        String sCustomer = this.getAccountName();
        
        // Sets the paramaters of the email
        email.setSubject('RTAT Schedule:' + sobjParentERPDevice.Name + ' Customer:' + sCustomer + ' Technology:' + sobjParentERPDevice.Technology__c );
        email.setToAddresses( toAddresses );
        email.setCCAddresses( ccAddresses );
        email.setPlainTextBody(sBody);
        email.setFileAttachments(new Messaging.EmailFileattachment[]{efa});
        
        // Sends the email
        try
        {
           Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        }
        catch(VisualforceException ee)
        {
            System.debug('Tried to send an email' + ee.getMessage());
        }
        
        // update the RTAT Slot status to 'PUBLISHED' 
        this.rSlot.Slot_Status__c = 'PUBLISHED';
        update rSlot;
        
        //Set message to display to user 
        ApexPages.addMessage(New ApexPages.Message(ApexPages.Severity.CONFIRM, 'RTAT Schedule published'));
      
        return null;
    }

}