/**
   @Author <Cognizant Technology Solutions>
   @name <SelectAndCreateDeliveryPartNumber>
   @CreateDate <28/10/2016>
   @Description <The Purpose of Apex Class To Select and Create new Deliverable Part Number 
               and Design Assay Part Number>
   @Version <>
   @reference <>
  */
public with sharing Class  BnP_SelectAndCreateDeliveryPartNumber
{   
    public List<WrapperAllDPN> waAllDPNList {get; set;}
    public Integer size{get;set;}     
    public List<SelectOption> paginationSizeOptions{get;set;}
    Public boolean IsDPNType {get; set;}
    Public string SelectValue {get;set;}
    public string labelSelectPN {get; set;}
    public string labelAddPN {get; set;}
    public string PageTitleName {get; set;}
    public boolean isEnableTypeSelection {get; set;}
    public string validationMessage {get;set;}
    public boolean IsDisabled {get;set;}
        
    public ApexPages.StandardSetController setCon 
    {
        get 
        {
            if(setCon == null) 
            {
                string opportunityId = ApexPages.currentPage().getParameters().get('oppId');
                string strQuery = 'Select Name, Deliverable_Part_Number_DPN__c, Design_Assay_PN__c From Customer_Requirement__c ';
                strQuery = strQuery + 'where Opportunity__c =' +'\''+ opportunityId +'\'' + ' order by Deliverable_Part_Number_DPN__c';                 
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(strQuery));                
                setCon.setPageSize(size);
            }            
            return setCon;
        }
        set;
    }
    
    /**
    *  Constructor of this Controller 
    *  @name <SelectAndCreateDeliveryPartNumber>
    *  @param <ApexPages.StandardController> 
    *  @return <NA> - <>
    *  @throws exception-<exception description>
    */
    public BnP_SelectAndCreateDeliveryPartNumber(ApexPages.StandardController controller)
    {       
        size=20;       
        paginationSizeOptions = new List<SelectOption>();        
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('40','40'));
        paginationSizeOptions.add(new SelectOption('60','60'));
        IsDPNType = false;        
    }
    
    /**
    *  Wrapper Class to Populate data in PageBlock Table 
    *  @name <WrapperAllDPN>
    *  @param <NA> 
    *  @return <NA> - <>
    *  @throws exception-<NA>
    */
    public class WrapperAllDPN
    {
        public Delivery_Part_Number__c AllDPN {get;set;}
        
        public Boolean selected {get;set;}
        public string optionControlNumber {get; set;}
        public string selectedPN {get;set;}

        
        public WrapperAllDPN()
        {

            AllDPN = new Delivery_Part_Number__c();
            
            selected = false;
            optionControlNumber = '';
        }   
        
        public WrapperAllDPN(Delivery_Part_Number__c DPN, string inUseOCN) 
        {

            AllDPN = DPN;
            selected = false;
            selectedPN = '';
            optionControlNumber = inUseOCN;
        }
    }
    
    /**
    *  The Purpose of this method is to Populate data in PageBlock Table 
    *  @name <getAllDPN>
    *  @param <NA> 
    *  @return <Pagereference> - <>
    *  @throws exception-<NA>
    */
    @TestVisible
    private Pagereference getAllDPN()
    {
        waAllDPNList = new List<WrapperAllDPN>();
        waAllDPNList.clear();
        
        Set<string> setDPN = new Set<string>();
        Map<string, Customer_Requirement__c> mapDPN = new Map<string, Customer_Requirement__c>();                  
        for (Customer_Requirement__c category : (List<Customer_Requirement__c>)setCon.getRecords())
        {
            Delivery_Part_Number__c DPN = new Delivery_Part_Number__c();            
            if(SelectValue == 'DPN' && category.Deliverable_Part_Number_DPN__c != null)
            {
                DPN.Name = category.Deliverable_Part_Number_DPN__c;
                
                setDPN.add(category.Deliverable_Part_Number_DPN__c);
                mapDPN.put(category.Name, category);                
            }
            else if (SelectValue == 'DAPN' && category.Design_Assay_PN__c!= null)
            {
                DPN.Name = category.Design_Assay_PN__c;
                
                setDPN.add(category.Design_Assay_PN__c);
                mapDPN.put(category.Name, category); 
            }            
        }
        
        String ControlOptionNumber = '';
        String tempvalue = '';
        if(SelectValue == 'DPN')
        {            
            for(string DPN : setDPN)
            {
                tempvalue = '';
                Delivery_Part_Number__c objDPN = new Delivery_Part_Number__c();
                objDPN.Name = DPN;
                for(Customer_Requirement__c mapvalue : mapDPN.values())
                {                   
                   if(mapvalue.Deliverable_Part_Number_DPN__c == DPN)
                   {
                       ControlOptionNumber = mapvalue.Name;
                       tempvalue = tempvalue + ControlOptionNumber;
                       tempvalue = tempvalue + ',';                                         
                   }
                }               
                waAllDPNList.add(new WrapperAllDPN(objDPN, tempvalue.substring(0,tempvalue.length()-1)));
            }            
        }
        else
        {
            for(string DPN : setDPN)
            {
                tempvalue = '';
                Delivery_Part_Number__c objDPN = new Delivery_Part_Number__c();
                objDPN.Name = DPN;
                for(Customer_Requirement__c mapvalue : mapDPN.values())
                {                   
                   if(mapvalue.Design_Assay_PN__c == DPN)
                   {
                       ControlOptionNumber = mapvalue.Name;
                       tempvalue = tempvalue + ControlOptionNumber;
                       tempvalue = tempvalue + ',';                                         
                   }
                } 
                waAllDPNList.add(new WrapperAllDPN(objDPN, tempvalue.substring(0,tempvalue.length()-1)));
            }
        }
             
        return null;
    }
                 
    /**
    *  The Purpose of this method is add DPN/DAPN to option object 
    *  @name <AddDPNtoOption>
    *  @param <NA> 
    *  @return <Pagereference> - <>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */    
    public Pagereference AddDPNtoOption()
    {        
        try
        {
            String DPNValue = '';
            validationMessage = '';
            integer Count = 0;
            
            for (WrapperAllDPN cw : waAllDPNList) 
            {                           
                if (cw.selected)
                {
                    Count++;
                                                                                    
                    DPNValue = cw.AllDPN.Name;                    
                }
            }       
            /*if(Count > 1)
            {                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Select only one Part Number'));
                return null;
            }*/
            if(Count == 0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Select atleast one Part Number'));
                return null;
            }        
            else
            {                                         
                Customer_Requirement__c CR = new Customer_Requirement__c();
                
                CR.Id = ApexPages.currentPage().getParameters().get('TRID');
                if(SelectValue == 'DPN')
                {            
                    CR.Deliverable_Part_Number_DPN__c = DPNValue;
                }
                else
                {
                    CR.Design_Assay_PN__c = DPNValue;
                }          
                Update CR;
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.info, SelectValue + ' : ' + DPNValue + ' Added Successfully'));                                                
                return null;
             }             
             return null;
        }
        catch(Exception excp)
        {           
            GlobalUtility.logMessage('Error','SelectAndCreateDeliveryPartNumber','AddDPNtoOption','','Exception while assigning Part Number to Option',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
          
         return null;       
    }
    
    /**
    *  The Purpose of this method is create a new DPN/DAPN and associate this with option object 
    *  @name <CreateandAddDPNtoOption>
    *  @param <NA> 
    *  @return <Pagereference> - <>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */ 
    public Pagereference CreateandAddDPNtoOption()
    {
        try
        {
            ////AggregateResult[] groupedResults = [Select Max(Count__c)MaxDPN, Max(MaxDAPNCount__c)MaxDAPN From Delivery_Part_Number__c ];
            AggregateResult[] groupedResults = [Select Max(Count__c)MaxDPN, Max(DAPNCount__c)MaxDAPN, Max(NewSeriesCount__c)MaxNextDPN From Delivery_Part_Number__c ];
            Decimal MaxDPNCount = (decimal)groupedResults[0].get('MaxDPN');
            Decimal MaxDAPNCount = (decimal)groupedResults[0].get('MaxDAPN');
            Decimal MaxNextDPNCount = (decimal)groupedResults[0].get('MaxNextDPN');
            //Create a New DPN
            Delivery_Part_Number__c objDPN = new Delivery_Part_Number__c();
            
            Customer_Requirement__c CR = new Customer_Requirement__c();       
            CR.Id = ApexPages.currentPage().getParameters().get('TRID');
            
            String StrDPN = '';
            string StrDAPN = '';
            String NewDPN = '';
            boolean DPNLNSeries = true;
            if(SelectValue == 'DPN')
            {
                if(MaxDPNCount == null)
                {
                    MaxDPNCount = 1;
                }
                else if(MaxDPNCount == 999) //SP 4 Changes :  Assign the other series to DPN (0000001LP000-0000001LP999 )
                {
                    DPNLNSeries = false;
                    if(MaxNextDPNCount == null)
                        MaxNextDPNCount = 1;
                    else
                        MaxNextDPNCount = MaxNextDPNCount + 1;
                }
                else 
                {
                    MaxDPNCount = MaxDPNCount + 1;
                }

                if(DPNLNSeries)
                {
                    StrDPN = String.valueOf(MaxDPNCount);       
                    StrDPN = StrDPN.leftPad(3).replace(' ', '0');
                                    
                    NewDPN = BnP_Part_Number_String__c.getInstance('STRATING_STRING').Format_String__c + StrDPN;
                    objDPN.Count__c = MaxDPNCount;
                }
                else //SP 4 Changes :  Assign the other series to DPN (0000001LP000-0000001LP999 )
                {
                    StrDPN = String.valueOf(MaxNextDPNCount);       
                    StrDPN = StrDPN.leftPad(3).replace(' ', '0');
                                    
                    NewDPN = BnP_Part_Number_String__c.getInstance('NEXT_DPN').Format_String__c + StrDPN;
                    objDPN.NewSeriesCount__c = MaxNextDPNCount;         
                }
                
                objDPN.DPN_Type__c = 'DPN';                 
                CR.Deliverable_Part_Number_DPN__c = NewDPN;
            }
            else if(SelectValue == 'DAPN')
            {               
                if(MaxDAPNCount == null)
                {                    
                    MaxDAPNCount = Decimal.valueOf(BnP_Part_Number_String__c.getInstance('STARTING_DAPN').Format_String__c);
                }
                else
                {
                    MaxDAPNCount = MaxDAPNCount + 1;                    
                }
                StrDAPN = String.valueOf(MaxDAPNCount);       
                StrDAPN = StrDAPN.leftPad(3).replace(' ', '0');  
                
                ////NewDPN = BnP_Part_Number_String__c.getInstance('STRATING_STRING').Format_String__c + MaxDAPNCount; 
                //New DAPN format : SP4 changes
                NewDPN = BnP_Part_Number_String__c.getInstance('START_DAPN_SERIES').Format_String__c + StrDAPN;
                ////objDPN.MaxDAPNCount__c = MaxDAPNCount;
                objDPN.DAPNCount__c = MaxDAPNCount;
                objDPN.DPN_Type__c = 'DAPN';
                
                CR.Design_Assay_PN__c = NewDPN;
            }
            objDPN.Name = NewDPN;
           
            Insert objDPN;
            //Assign DPN to Option                                                          
            Update CR;
        }
        catch(Exception excp)
        {
            GlobalUtility.logMessage('Error','SelectAndCreateDeliveryPartNumber','CreateandAddDPNtoOption','','Exception while creating new Part Number',String.valueof(excp.getMessage()),'','BnP',excp,0);
        }
        
        return null;
    }
    /**
    *  The Purpose of this method is to select DPN type 
    *  @name <SelectDPNType>
    *  @param <NA> 
    *  @return <Pagereference> - <>
    *  @throws exception-<NA>
    */ 
    public Pagereference SelectDPNType()
    {           
        if(SelectValue == null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Select a DPN Type!!'));
            return null;
        }
        if(SelectValue == 'DAPN')
        {
            //Find the Opportunity Product Line for this Option
            //SP 4 Changes: Design Assay PN is ONLY for Product Line = ASIC if someone tries to do it for  Product Line = RF. 
            Customer_Requirement__c objOption = [Select Opportunity__r.Product_Line__c from Customer_Requirement__c where id=: ApexPages.currentPage().getParameters().get('TRID')];
            if(objOption.Opportunity__r.Product_Line__c == 'RF')
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Design Assay PN is ONLY for Product Line = ASIC!!'));
                return null;
            }
            labelSelectPN = 'Assign Existing Part Number';
            labelAddPN = 'Add New Part Number';
            IsDPNType = true;
            PageTitleName = 'Design Assay Part Number';
        }
        else
        {
            labelSelectPN = 'Assign Existing Part Number';
            labelAddPN = 'Add New Part Number';
            IsDPNType = true;
            PageTitleName = 'Deliverable Part Number';
        }
        IsDisabled = true;
        getAllDPN();
        isEnableTypeSelection = true;
        return null;
    }
    
    /**
    *  The Purpose of this method is to change the page size 
    *  @name <refreshPageSize>
    *  @param <NA> 
    *  @return <Pagereference> - <>
    *  @throws exception-<NA>
    */ 
    Public PageReference refreshPageSize() 
    {
        setCon.setPageSize(size);        
        getAllDPN();
        return null;
    }
    
    public PageReference getSelected()
    {
        IsDisabled = false;
        return null;
    }    
}