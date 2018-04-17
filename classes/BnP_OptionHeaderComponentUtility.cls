/**
   @Author <Cognizant Technology Solutions>
   @name <BnP_OptionHeaderComponentUtility>
   @CreateDate <10/9/2016>
   @Description <This is common class to display the values using wrapperclass>
   @Version <>
   @reference <>
  */
Public with sharing class BnP_OptionHeaderComponentUtility
{
    Public ID RecId{Set;Get;}
    Public Opportunity Opp{private Set;Get;}
    Public String DTType {Set;Get;}
    public Boolean isDAPNVisible  {get;set;}
    
    Public BnP_OptionHeaderComponentUtility()
    {
        isDAPNVisible = false;
    }
    /**
    *  The getter method used in the page to display Opportunity,customer requiremnet and Option information
    *  @name <getDetails>
    *  @param <> <>
    *  @return <WrapperCls> - <Returns the Opportunity,customer requiremnet and Option>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    Public WrapperCls getDetails()
    {
        WrapperCls wCls=new WrapperCls();
            if(RecId != null) {
                String ObjName = RecId.getSObjectType().getDescribe().getName();  
                if(ObjName ==Schema.SobjectType.Customer_Requirement__c.Name)
                {   
                    Opportunity opp=new Opportunity();
                    Customer_Requirement__c TechRequ = [Select Id,Name,
                    Deliverable_Type_Formula__c,
                    Device__c,
                    Device__r.Id,
                    Device__r.Name,
                    MD_part_name__c,
                    Deliverable_Part_Number_DPN__c,
                    Design_Assay_PN__c,
                    Option_Status__c,
                    Option_Stage_GUI__c,
                    Opportunity__r.AccountID,
                    Opportunity__r.stageName,
                    Opportunity__r.Name,
                    Opportunity__r.ID,
                    Opportunity__r.Design_Export_Control_Classification_Num__c,
                    Opportunity__r.Issue_Status__c,
                    Opportunity__r.Product_Line__c,
                    Opportunity__r.Account.Name, Opportunity__r.Account.Id from Customer_Requirement__c where id=:RecId];
                    Account ac=new Account(Name =TechRequ.Opportunity__r.Account.Name, Id = TechRequ.Opportunity__r.Account.Id);
                    opp.Account = ac;
                    
                    DTType = '/apex/BnP_OptionDeliverableType?DT=' + TechRequ.Deliverable_Type_Formula__c +'&scontrolCaching=1&id=' +TechRequ.id;
                    
                    wCls.Opp = [Select Id,Name,StageName,Account.Name,AccountId,Issue_Status__c,Worst_Issue_Status__c,Product_Line__c from Opportunity where Id=:TechRequ.Opportunity__r.ID];
                    wCls.TechReq = TechRequ;
                    
                    if(TechRequ.Opportunity__r.Product_Line__c <> 'RF')
                    {
                        isDAPNVisible = true;
                    }                                
               }
                else if(ObjName ==Schema.SobjectType.Request_Information__c.Name)
              {
                    Opportunity opp=new Opportunity();
                    Request_Information__c  RI =  New Request_Information__c();
                    RI = [Select id,Name, Device__c, Device__r.id, Device__r.Name,Customer_Requirement__c,
                    Customer_Requirement__r.MD_part_name__c,
                    Customer_Requirement__r.Option_Status__c,
                    Customer_Requirement__r.Deliverable_Part_Number_DPN__c,
                    Customer_Requirement__r.Deliverable_Type_Formula__c,
                    Customer_Requirement__r.Id,
                    Customer_Requirement__r.Name,
                    Customer_Requirement__r.Design_Assay_PN__c,
                    Customer_Requirement__r.Option_Stage_GUI__c,
                    Opportunity__r.stageName,
                    Opportunity__r.Name,
                    Opportunity__r.ID,
                    Opportunity__r.Issue_Status__c,
                    Opportunity__r.Product_Line__c,
                    Opportunity__r.Account.Name from Request_Information__c where Id=:RecId];
                    Account ac=new Account(Name=RI.Opportunity__r.Account.Name);
                    opp.Account = ac;
                    
                    DTType = '/apex/BnP_OptionDeliverableType?DT=' + RI.Customer_Requirement__r.Deliverable_Type_Formula__c +'&scontrolCaching=1&id=' +RI.Customer_Requirement__c;
                    
                    wCls.Opp = [Select Id,Name,StageName,Account.Name,AccountId,Issue_Status__c,Worst_Issue_Status__c,Product_Line__c from Opportunity where Id=:RI.Opportunity__r.ID];
                    wCls.RIfo= RI;
                    
                    if(RI.Opportunity__r.Product_Line__c <> 'RF')
                    {
                        isDAPNVisible = true;
                    }
               } 
           }     
        return WCls;
    }
    /**
   @name <WrapperCls>
   @Description <This class is handle mutliple object instances>
   @Version <>
   @reference <>
  */
    Public class WrapperCls
    {
        public Opportunity opp{private set;get;}
        public Customer_Requirement__c TechReq{private set;get;}
        public Request_Information__c RIfo{private set;get;}
    }
}