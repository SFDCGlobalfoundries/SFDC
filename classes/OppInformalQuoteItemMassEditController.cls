/*
    Author: Yash Kumar
    Description: class for OppInformalQuoteItemMassEditController
    History:
        Yash 15062013    - Code Creation.
            
*/
public class OppInformalQuoteItemMassEditController
{
    ApexPages.StandardSetController stdSetController;
    public Boolean EditMode{get;set;}
    public Boolean ReadMode{get;set;}
    public Boolean PricingMode{get;set;}
    public Boolean SalesMode{get;set;}
    public Boolean FinanceMode{get;set;}
    public boolean MarketingMode{get;set;}
    public Boolean CanEdit{get;set;}
    public Boolean NoRecordsSelected{get;set;}
    Map<String,ProfileName__c> ProfilePermission = new Map<String,ProfileName__c>();
    public Id userId = Userinfo.getUserId();
    public String OpportunityId{get;set;}
    public String Competitor{get;set;}
    public String Competitor2{get;set;}
    public String Competitor1Complexity{get;set;}
    public String Competitor2Complexity{get;set;}
    public decimal Competitor1Price{get;set;}
    public decimal Competitor2Price{get;set;}
    public String Competitor1EffectivePriceQuarter{get;set;}
    public String Competitor2EffectivePriceQuarter{get;set;}
    public String OpportunityName{get;set;}
    public String AccountName{get;set;}
    public String ChkprofilePermission{get;set;}
    Id qtrId = (Id)ApexPages.currentPage().getParameters().get('id');
    User u = [Select u.Name, u.Profile.Name From User u where id=:userId limit 1];
     List<Budgetary_Quote_Item__c> slist = new List<Budgetary_Quote_Item__c>();
    //public Budgetary_Quote_Item__c InformalItemObj {get;set;}
    
    public OppInformalQuoteItemMassEditController(ApexPages.StandardSetController stdSetController) 
    {
        this.stdSetController = stdSetController;
        
        //this.InformalItemObj= (Budgetary_Quote_Item__c)stdSetController.getRecord(); 
        
        this.stdSetController.setSelected(getSelectedSorted());
        ProfilePermission =ProfileName__c.getall();
        ReadMode=true;
        EditMode=false;
        PricingMode=false;
        SalesMode=false;
        FinanceMode=false;
        MarketingMode=false;
        if(ProfilePermission.containsKey(u.Profile.Name))
        {
            checkVisibility(u.Profile.Name);
        }
        
       /*  ReadMode=true;
            EditMode=false;
            PricingMode=false;
            SalesMode=false;
            FinanceMode=false; */
    }
    
 /* public boolean getAlldata()
 {
     List<Budgetary_Quote_Item__c> chklist;  
     boolean chkvalid=false;
    // system.debug('@@@@@@FirstqtrId@@@@@@@'+qtrId);
     if(qtrId!=null)
     {
         chklist = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , 
         CreatedDate,Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c,
          name, Sales_Requested_Price__c, Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c,
           Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c,
           Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,
           Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,
           Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,
           Budgetary_Quote__r.Competitor_2_Quarter__c from Budgetary_Quote_Item__c where Budgetary_Quote__c=:qtrId];
     }
    // system.debug('@@@@@@SecondqtrId@@@@@@@'+chklist.size() + slist.size());
     if((chklist.size()>0) && (slist.size()>0))
     {
         if( chklist.size() != slist.size() )
         {
             for(integer i=0;i< slist.size();i++)
             {
                  for(integer j=0;j< chklist.size();j++)
                  {
                     // system.debug('@@@@@@thirdqtrId@@@@@@@'+slist[0].Quarter__c);
                      if(chklist[j].Quarter__c< slist[0].Quarter__c)
                      {
                          chkvalid=false;
                          break;
                      }
                      else
                      {
                           chkvalid=true;
                      }
                  }
             }
         }
         else
         {
             chkvalid=true;
         }
         
         
     }
     
    return chkvalid;  
 } */
 
 public List<Budgetary_Quote_Item__c> getSelectedSorted()
    {
       List<Budgetary_Quote_Item__c> ulist = (List<Budgetary_Quote_Item__c>)stdSetController.getSelected();
        
       
       
       
           List<Budgetary_Quote_Item__c> qlist;       

       if (ulist!=null && !(ulist.isEmpty()))
       { 
                qlist = [SELECT id, Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c ,CreatedDate,
                Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c, name,
                 Sales_Requested_Price__c, Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c,
                  Quarter__c, Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,
                  Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c,
                  Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,
                  Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,
                  Budgetary_Quote__r.Competitor_2_Quarter__c from Budgetary_Quote_Item__c where id in :ulist]; //Budgetary_Quote__r.id =:qtrId
                   //system.debug('@@@@@@@@@111111111'+qlist );
       }else
       { 
                qlist = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , CreatedDate,
                Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c, name,
                 Sales_Requested_Price__c, Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c,
                  Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,
                  Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c,
                  Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,
                  Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,
                  Budgetary_Quote__r.Competitor_2_Quarter__c from Budgetary_Quote_Item__c where id =:qtrId]; // Budgetary_Quote__r.id=:qtrId
                //system.debug('@@@@@@@@@22222222222'+qlist );
       }     
         
       NoRecordsSelected = (qList.size() == 0);
       CanEdit = true;

        List< QRWrapper> tlist = new List< QRWrapper>();
      
       
       for(Budgetary_Quote_Item__c qr:qlist)
       {
          Competitor=qr.Budgetary_Quote__r.Competitor1__c;
          Competitor2=qr.Budgetary_Quote__r.Competitor_2__c;
          Competitor1Complexity=qr.Budgetary_Quote__r.Competitor_1_Complexity__c;
          Competitor2Complexity=qr.Budgetary_Quote__r.Competitor_2_Complexity__c;
          Competitor1Price=qr.Budgetary_Quote__r.Competitor_1_Price_US__c;
          Competitor2Price=qr.Budgetary_Quote__r.Competitor_2_Price_US__c;
          Competitor1EffectivePriceQuarter=qr.Budgetary_Quote__r.Competitor_1_Quarter__c;
          Competitor2EffectivePriceQuarter=qr.Budgetary_Quote__r.Competitor_2_Quarter__c;
          
          tlist.add(new QRWrapper(qr));
       }
       
       
       tlist.sort();
       for(QRWrapper qrw: tlist)
       {
          slist.add(qrw.getQuarterlyRevenue());
       }
       
       //slist.sort();Sales_Requested_Price__c
       
       return slist;
    }
    public Pagereference  Save()
    {
      //  if(checkValidation()==true)
       // {
            try
            {
                update slist;
                if(!noRecordsSelected)
                {
                pagereference pgref = new pagereference('/'+getSelectedSorted()[0].Budgetary_Quote__r.id);
                pgref.setredirect(true);
                return pgref; 
                }
                else
                {
                     pagereference pgref = new pagereference('/'+qtrId );
                    pgref.setredirect(true);
                    return pgref; 
                }
            }
            catch (Exception e) 
            {
              
               ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.Error, 'An Error Occured while processing the record. Please contact your Administrator' ));
               return null;
                    
            }
        // }
        // else
       //  {
       //      return null;
       //  }
        
        
        
    }
 /*   public static  void checkInformalQuoteValidation(string informalid)
    {
        List<Budgetary_Quote_Item__c> chkinfo;
        system.debug('@@@@@@@@@informalid@@@@@@@@@@'+informalid);
        chkinfo = [SELECT id,Competitors_1__c,Competitors_2__c,Competitors_1_Volume__c ,Competitors_2_Volume__c , CreatedDate,
                Competitor_1_Complexity__c,Competitor_2_Complexity__c,Competitor_1_Price_US__c,Competitor_2_Price_US__c, name,
                 Sales_Requested_Price__c, Pricing_Approved_Price__c,Box_Score__c,Cost__c, List_Price__c, Start_Date__c, Quarter__c,
                  Quantity__c,Margin__c, Budgetary_Quote__r.Name,Budgetary_Quote__r.id,Budgetary_Quote__r.Competitor1__c,
                  Budgetary_Quote__r.Competitor_2__c,Budgetary_Quote__r.Competitor_1_Complexity__c,Yield_Commit_information_for_customer__c,Yield_Commit_information_for_TE__c,Yield_Commit_information_for_Pricing__c,
                  Budgetary_Quote__r.Competitor_2_Complexity__c,Budgetary_Quote__r.Competitor_1_Price_US__c,
                  Budgetary_Quote__r.Competitor_2_Price_US__c,Budgetary_Quote__r.Competitor_1_Quarter__c,
                  Budgetary_Quote__r.Competitor_2_Quarter__c from Budgetary_Quote_Item__c where Budgetary_Quote__c =:informalid];
         system.debug('@@@@@@@@@chkinfo@@@@@@@@@@'+chkinfo.size());
         if(chkinfo.size()>0)
         {
             for(integer i=0; i<chkinfo.size();i++)
             {
                 if(chkinfo[0].Yield_Commit_information_for_TE__c==null )
                 {
                      system.debug('@@@@@@@@@chkinfo[0].Yield_Commit_information_for_TE__c@@@@@@@@@@'+chkinfo[0].Yield_Commit_information_for_TE__c);
                      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Yield Commit information cannot be blank'));
                      break;
                 }
             }
         }         
                
    } */
  /* public boolean checkValidation()
    {
        boolean ChkValidation=true;     
        try
        {
            if(slist.size()>0 && getAlldata())
            {
                for(integer i=0; i<slist.size();i++)
                {
                    if(slist[0].Sales_Requested_Price__c ==null && (ChkprofilePermission=='E'|| ChkprofilePermission=='S'))
                    {
                         
                         Error_Codes__c Sales_Requested_Price= Error_Codes__c.getInstance('Sales_Requested_Price');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Sales_Requested_Price.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Competitor_1_Complexity__c==null  && (ChkprofilePermission=='E' || ChkprofilePermission=='P' || ChkprofilePermission=='S' || ChkprofilePermission=='F' ))
                    {
                       
                         Error_Codes__c Competitor_1_Complexity= Error_Codes__c.getInstance('Competitor_1_Complexity');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Competitor_1_Complexity.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Competitor_1_Price_US__c==null && ( ChkprofilePermission=='E' || ChkprofilePermission=='P' || ChkprofilePermission=='S' || ChkprofilePermission=='F' ))
                    {
                         Error_Codes__c Competitor_1_Price= Error_Codes__c.getInstance('Competitor_1_Price');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Competitor_1_Price.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Competitors_1_Volume__c==null && ( ChkprofilePermission=='E' || ChkprofilePermission=='P' || ChkprofilePermission=='S' || ChkprofilePermission=='F' ))
                    {
                         Error_Codes__c Competitors_1_Volume= Error_Codes__c.getInstance('Competitors_1_Volume');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Competitors_1_Volume.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Competitor_2_Complexity__c==null  && ( ChkprofilePermission=='E' || ChkprofilePermission=='P' || ChkprofilePermission=='S' || ChkprofilePermission=='F' ))
                    {
                         Error_Codes__c Competitor_2_Complexity= Error_Codes__c.getInstance('Competitor_2_Complexity');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Competitor_2_Complexity.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Competitor_2_Price_US__c==null  && ( ChkprofilePermission=='E' || ChkprofilePermission=='P' || ChkprofilePermission=='S' || ChkprofilePermission=='F' ))
                    {
                         Error_Codes__c Competitor_2_Price= Error_Codes__c.getInstance('Competitor_2_Price');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Competitor_2_Price.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Competitors_2_Volume__c==null && ( ChkprofilePermission=='E' || ChkprofilePermission=='P' || ChkprofilePermission=='S' || ChkprofilePermission=='F' ))
                    {
                         Error_Codes__c Competitors_2_Volume= Error_Codes__c.getInstance('Competitors_2_Volume');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Competitors_2_Volume.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Pricing_Approved_Price__c==null && ( ChkprofilePermission=='E' || ChkprofilePermission=='P' ))
                    {
                         Error_Codes__c Pricing_Approved_Price= Error_Codes__c.getInstance('Pricing_Approved_Price');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Pricing_Approved_Price.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].List_Price__c==null  && ( ChkprofilePermission=='E' || ChkprofilePermission=='P' ))
                    {
                         Error_Codes__c List_Price= Error_Codes__c.getInstance('List_Price');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, List_Price.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Box_Score__c==null  && (ChkprofilePermission=='E' || ChkprofilePermission=='F' || ChkprofilePermission=='P' ))
                    {
                         Error_Codes__c Box_Score= Error_Codes__c.getInstance('Box_Score');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Box_Score.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Cost__c==null  && (ChkprofilePermission=='E'|| ChkprofilePermission=='P' || ChkprofilePermission=='F'))
                    {
                         Error_Codes__c Cost= Error_Codes__c.getInstance('Cost');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Cost.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else if(slist[0].Quantity__c==null  && (ChkprofilePermission=='E'|| ChkprofilePermission=='P' || ChkprofilePermission=='S' || ChkprofilePermission=='F'))
                    {
                         Error_Codes__c Quantity_Per_Quater= Error_Codes__c.getInstance('Quantity_Per_Quater');
                         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Quantity_Per_Quater.message__c));
                         ChkValidation=false;
                         break;
                    }
                    else
                    {
                        ChkValidation=true; 
                    }
                    
                }
                
               
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message (ApexPages.Severity.Error, 'An Error Occured while processing the record. Please contact your Administrator' ));
        }
        return ChkValidation;
    } */
    public void checkVisibility(string ProfileName)
    {
        //System.debug('@@@@>>>>>>>>>@@@@@@@@'+ProfilePermission.get(ProfileName).ProfileAccess__c+'>>>>>>>>'+ProfileName);
        if(ProfilePermission.get(ProfileName).ProfileAccess__c=='E')
        {
            ReadMode=false;
            EditMode=true;
            PricingMode=false;
            SalesMode=false;
            FinanceMode=false;
            MarketingMode=false;
            ChkprofilePermission='E';
        }
        else if(ProfilePermission.get(ProfileName).ProfileAccess__c=='S')
        {
            ReadMode=false;
            EditMode=false;
            PricingMode=false;
            SalesMode=true;
            FinanceMode=false;
            MarketingMode=false;
            ChkprofilePermission='S';
        }
        else if(ProfilePermission.get(ProfileName).ProfileAccess__c=='P')
        {
            ReadMode=false;
            EditMode=false;
            PricingMode=true;
            SalesMode=false;
            FinanceMode=false;
            MarketingMode=false;
            ChkprofilePermission='P';
        }
        else if(ProfilePermission.get(ProfileName).ProfileAccess__c=='F')
        {
            ReadMode=false;
            EditMode=false;
            PricingMode=false;
            SalesMode=false;
            FinanceMode=true;
            MarketingMode=false;
            ChkprofilePermission='F';
        }
        else if(ProfilePermission.get(ProfileName).ProfileAccess__c=='H')
        {
             ReadMode=false;
            EditMode=false;
            PricingMode=false;
            SalesMode=false;
            FinanceMode=false;
            MarketingMode=true;
            ChkprofilePermission='H';
        
        }
        else
        {
            ReadMode=true;
            EditMode=false;
            PricingMode=false;
            SalesMode=false;
            FinanceMode=false;
            MarketingMode=false;
            ChkprofilePermission='R';
        }
    }
    public Pagereference cancel()
    {
        if(!noRecordsSelected)
        {
        pagereference pgref = new pagereference('/'+getSelectedSorted()[0].Budgetary_Quote__r.id);
        pgref.setredirect(true);
        return pgref; 
        }
        else
        {
             pagereference pgref = new pagereference('/'+qtrId );
            pgref.setredirect(true);
            return pgref; 
        }
    }
    
    public class QRWrapper implements Comparable
    {
        Budgetary_Quote_Item__c qr = null;
        QRWrapper(Budgetary_Quote_Item__c qr)
        {
            this.qr = qr;
        }
        
        public Budgetary_Quote_Item__c getQuarterlyRevenue()
        {
           return this.qr;
        }

        public Integer compareTo(Object compareTo) {
           QRWrapper otherWrapper = (QRWrapper)compareTo;       
           Budgetary_Quote_Item__c other = otherWrapper.getQuarterlyRevenue();
           system.debug('@@@@@@@@@@@@@@@@@@other@@@@@@'+ other);
           system.debug('@@@@@@@@@@@@@@@@@@qr@@@@@@'+ qr);
           Integer returnValue = 0;
        /*   if((qr.Start_Date__c!=null)&&(other.Start_Date__c!=null)&&(qr.Start_Date__c > other.Start_Date__c)) Quarter__c
           
           {
               return 1;
             
           }
           
         
     
           return -1; */
           
            if (qr.Quarter__c> other.Quarter__c) {
            // Set return value to a positive value.
            returnValue = 1;
            } else if (qr.Quarter__c< other.Quarter__c) {
                // Set return value to a negative value.
                returnValue = -1;
            }
           return returnValue;
        }
    }
    
}