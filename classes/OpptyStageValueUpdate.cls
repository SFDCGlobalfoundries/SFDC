public class OpptyStageValueUpdate
{
        @TestVisible
        private static List<OpportunityStage> OpptyStageList;
        
        public static void ProcessOpptyUpdate(Map<Id,Opportunity> OldMap,Map<Id,Opportunity> NewMap)
        {
            if(OldMap<>NULL && NewMap<>NULL)
            {
        
        
        if(OpptyStageList==NULL)
            OpptyStageList=[SELECT APiName,DefaultProbability,MasterLabel FROM OpportunityStage where IsActive=True and (DefaultProbability<>0 AND ForecastCategoryName<>'Omitted')];
           
        Map<String,Decimal> StageProbabilityMap=new Map<String,Decimal>();
        for(OpportunityStage x: OpptyStageList)
            StageProbabilityMap.put(x.APiName,x.DefaultProbability);
        
        
                
        Set<Decimal> SetOfProbabilities=new Set<Decimal>();
        SetOfProbabilities.addAll(StageProbabilityMap.values());
        
        for(Opportunity oppty:NewMap.values())
            {
                 if(oppty.StageName<>OldMap.get(oppty.id).StageName) // indicates a change in Stage
                 {
                     if(oppty.Probability<>Oldmap.get(oppty.id).Probability && oppty.Probability==StageProbabilityMap.get(oppty.StageName) && !SetOfProbabilities.contains(Oldmap.get(oppty.id).Probability))
                           {
                            oppty.Probability=Oldmap.get(oppty.id).Probability;
                           }
                     
                 }

                  if (oppty.Probability >= 75){
                  oppty.DWIN_Outlook1__c ='High'; 
                  } else If (oppty.Probability >= 50 && oppty.Probability <= 74 ){
                   oppty.DWIN_Outlook1__c ='Medium'; 
                  } else If (oppty.Probability <= 49 ){
                  oppty.DWIN_Outlook1__c ='Low';   
                  }   
               
            }    
         }   
    }
 }