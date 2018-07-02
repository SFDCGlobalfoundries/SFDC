Public Class DRPageMessageContrl{

public String urlDR{get;set;}

    public DRPageMessageContrl(ApexPages.StandardController controller) {
    
                 List<GFSDR__DR_Knowledge_Article__mdt> drKnowlgeLst = new List<GFSDR__DR_Knowledge_Article__mdt>();
        
         drKnowlgeLst  = [select label,GFSDR__KnwlgeURL__c from GFSDR__DR_Knowledge_Article__mdt where label =:'DRPageMessageURL'];
         
         urlDR =  drKnowlgeLst[0].GFSDR__KnwlgeURL__c; 
         
         system.debug('-urlDR-'+urlDR);


    }
    
    public DRPageMessageContrl(){
        
         /*   
         List<GFSDR__DR_Knowledge_Article__mdt> drKnowlgeLst = new List<GFSDR__DR_Knowledge_Article__mdt>();
        
         drKnowlgeLst  = [select label,GFSDR__KnwlgeURL__c from GFSDR__DR_Knowledge_Article__mdt where label =:'DRPageMessageURL'];
         
         urlDR =  drKnowlgeLst[0].GFSDR__KnwlgeURL__c; 
         
         system.debug('-urlDR-'+urlDR);
         */
    }

}