/* 
  @Author <Cognizant>
   @name <CDSListForOppExtension >
   @CreateDate <07/09/2016>
   @Description <List all the CDS record of the opportunity.
   Validates ECCN value for CDS creation> 
   @Version <1.0>
*/
public class CDSListForOppExtension {
    
    public List<Custom_Design__c> custDesignList{get;set;}
    public List<Custom_Design__c> custDesignListRedZone{get;set;}
    public List<Custom_Design__c> custDesignListNonRedZone{get;set;}
    //  public String decId{get; set;}   
    private String oppId;
    public String optId{get; set;}
    public String deviceId{get; set;}
    public boolean isValidEccn{get;set;}
    public Boolean RedZone {get;set;}
    public String itarFlag {get;set;}
    public Map<String,CDS_Color_zone__c> allColorCodes;

    private ApexPages.StandardController sController;
    
   /*
   *************************************    
   @ Name -  Constructor 
   @ Description -
   @ Parameter - None
   @ Return Type - 
   @ Created By - Niharika Modi
   ****************************************
   */ 
    public CDSListForOppExtension(ApexPages.StandardController controller) {
        
        sController = controller;
        
        //decId = ApexPages.currentPage().getParameters().get('DecId'); 
        
        oppId = ApexPages.currentPage().getParameters().get('oppId'); 
        optId =  ApexPages.currentPage().getParameters().get('optId');
        
        //optId='a1ap0000000418e';
        
        deviceId = ApexPages.currentPage().getParameters().get('devId'); 
        system.debug('-deviceId-'+deviceId);
        isValidEccn = true;
        checkECCNValue();
        
        //if device has parent then get cds of parent else get list of cds from opportunity
        
        if(isValidEccn){
            custDesignList = [Select id, Name,Deliverable_Part_Type__c,Device__r.ITAR_Flag__c,Device__r.ECCN_Technology__c,DIW_Option_Control_Number__c,DIW_Opp_Control_Number__c,Deliverable_Part_Number__c,GlobalFoundries_Product__c from Custom_Design__c where DIW_Opp_Control_Number__c =: oppId];
            Device__c devInfo = [SELECT Primary_Option__c,Opportunity_Program__c,ITAR_Flag__c,ECCN_Technology__c FROM Device__c WHERE Id = :deviceId ]; 
                   itarFlag = devInfo.ITAR_Flag__c;
                   System.debug('@@if cust design' + devInfo);
                   String ECCNTech = devInfo.ECCN_Technology__c;
                   Map<String,CDS_Color_zone__c> allColorCodes = CDS_Color_zone__c.getAll();
                    if(ECCNTech!=Null ||ECCNTech!=''){
                    if(allColorCodes.containsKey(ECCNTech)){
                    String color = String.valueof(CDS_Color_zone__c.getValues(ECCNTech).Color__c);
                    String Red = 'Red';
                    if(color.equalsIgnoreCase(Red)){
                        RedZone=True;
                    }Else{
                        RedZone=False;
                    }
                    }Else{
                        RedZone=False;
                    }
                    }
            custDesignListRedZone = new List<Custom_Design__c>();
            custDesignListNonRedZone = new List<Custom_Design__c>();
            for(Custom_Design__c CD :custDesignList){
            String ECCNTechCD = CD.Device__r.ECCN_Technology__c;
            Boolean RedFlag;
             if(ECCNTechCD!=Null ||ECCNTechCD!=''){
                    if(allColorCodes.containsKey(ECCNTechCD)){
                    String color = String.valueof(CDS_Color_zone__c.getValues(ECCNTechCD).Color__c);
                    String Red = 'Red';
                    if(color.equalsIgnoreCase(Red)){
                        RedFlag=True;
                    }Else{
                        RedFlag=False;
                    }
                    }Else{
                        RedFlag=False;
                    }
             }
            if(itarFlag =='Yes' || RedZone){
                if(CD.Device__r.ITAR_Flag__c=='Yes' || RedFlag){
                    custDesignListRedZone.add(CD);
                }
            }Else if(itarFlag=='No'&&!RedZone){
                if(CD.Device__r.ITAR_Flag__c=='No' && !RedFlag){
                    custDesignListNonRedZone.add(CD);
                }
                
            }
            }
        
        }  
        /*  // Customer_Requirement__c option = [Select OptionParentControlNumber__c, name,(select name,id from Customer_Design_Specifications__r ) from Customer_Requirement__c where id =:optId];
List<Customer_Requirement__c> option = new List<Customer_Requirement__c>();
option = [Select OptionParentControlNumber__c, name from Customer_Requirement__c where id =:optId];
custDesignList = new List<Custom_Design__c>();
System.debug('custDesignList' + custDesignList);

if(option.size()>0 && option.get(0).OptionParentControlNumber__c != null){

custDesignList = [Select id, Name,Deliverable_Part_Type__c,Deliverable_Part_Number__c,Is_this_an_ITAR_design__c,Device__r.ECCN_Technology__c,GlobalFoundries_Product__c from Custom_Design__c where DIW_Option_Control_Number__c =:option.get(0).OptionParentControlNumber__c];
//  custDesignList.add(customerDesign);
System.debug('if cust design' + custDesignList);
}else{
custDesignList = [Select id, Name,Deliverable_Part_Type__c,Deliverable_Part_Number__c,Is_this_an_ITAR_design__c,Device__r.ECCN_Technology__c,GlobalFoundries_Product__c from Custom_Design__c where DIW_Opp_Control_Number__c =: oppId];
System.debug('@@@else' + custDesignList);
    for(Custom_Design__c CD :custDesignList){
        if(itarFlag =='Yes' || RedZone){
            custDesignListRedZone.add(CD);
        }Else if(itarFlag=='No'&&!RedZone){
            custDesignListNonRedZone.add(CD);
        
        }
    }
    System.debug('@@@if cust designelse' + custDesignListRedZone);
System.debug('@@@@if cust designelse' + custDesignListNonRedZone);
} */
    }
   /*
    public PageReference checkECCNValue(){
        Device__c device = new Device__c();
      /*  option = [Select Design_Export_Control_Classification_Num__c from Customer_Requirement__c where id =:optId];
        String designECCN = option.Design_Export_Control_Classification_Num__c;    */
     /*   device = [Select ECCN_Wafer__c,Assumed_Design_ECCN__c from Device__c where id =:deviceId];
        String designECCN  = device.ECCN_Wafer__c==null?device.Assumed_Design_ECCN__c:device.ECCN_Wafer__c;   
        CDS_Color_zone__c color = new CDS_Color_zone__c();
        if(designECCN != null){
            System.debug('designECCN' + designECCN);
            color = CDS_Color_zone__c.getInstance(designECCN);
           // System.debug('color' + color.color__c);
            if(color <> null && color.color__c.equals(Label.Red)){
                ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'CDS cannot be created for ECCN value:' + designECCN));
                return null;
            }
            
        }
        PageReference p=new PageReference('/apex/CDSPageFrame?devId=' + deviceId );
        p.setRedirect(true);      
        return p; 
        
    }
    */
    
   /*
   *************************************    
   @ Name -  checkECCNValue
   @ Description - Check ECCN Value.
   @ Parameter - None
   @ Return Type - 
   @ Created By - Niharika Modi
   ****************************************
   */
    @TestVisible
    private void checkECCNValue(){
        Device__c device = new Device__c();
      /*  option = [Select Design_Export_Control_Classification_Num__c from Customer_Requirement__c where id =:optId];
        String designECCN = option.Design_Export_Control_Classification_Num__c;    */
            system.debug('-deviceId-'+deviceId);
          //  device = [Select ECCN_Wafer__c,Assumed_Design_ECCN__c from Device__c where id =:deviceId];
 //       String designECCN  = device.ECCN_Wafer__c==null?device.Assumed_Design_ECCN__c:device.ECCN_Wafer__c;   
 
        device = [Select ECCN_Technology__c,Assumed_Design_ECCN__c from Device__c where id =:deviceId];
    //commented by Naman: color zone is only dependent on ECCN_Technology        
    //String designECCN  = device.ECCN_Technology__c==null?device.Assumed_Design_ECCN__c:device.ECCN_Technology__c;   
    String designECCN  = device.ECCN_Technology__c!=null?device.ECCN_Technology__c:''; 
        
        CDS_Color_zone__c color = new CDS_Color_zone__c();
        
        if(designECCN != null){
            
            color = CDS_Color_zone__c.getInstance(designECCN);
          
            if(color <> null && color.color__c.equals(Label.CDSRed)){
                isValidEccn = false;
                ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR, 'CDS cannot be created for ECCN value:' + designECCN));
            }            
        }    
    }
}