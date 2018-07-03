Public Class DRPageMessageContrl{

public String urlDR{get;set;}
public String msgDRPage{get;set;}


    public DRPageMessageContrl(ApexPages.StandardController controller) {
    
        List<GFSDR__DR_Knowledge_Article__mdt> drKnowlgeLst = new List<GFSDR__DR_Knowledge_Article__mdt>();
        
        List<GFSDR__DR_FeedMessage__mdt> drFedMssgLst = new List<GFSDR__DR_FeedMessage__mdt>();
        
         drKnowlgeLst  = [select label,GFSDR__KnwlgeURL__c from GFSDR__DR_Knowledge_Article__mdt where label =:'DRPageMessageURL'];
         
         drFedMssgLst = [SELECT DeveloperName,GFSDR__FeedMessage__c,Id,Label FROM GFSDR__DR_FeedMessage__mdt where label =:'DRBannerPageMssg'];
         urlDR =  drKnowlgeLst[0].GFSDR__KnwlgeURL__c; 
         msgDRPage = drFedMssgLst[0].GFSDR__FeedMessage__c ; 
         
         system.debug('-urlDR-'+urlDR);


    }
    
    public DRPageMessageContrl(){
        

    }

}