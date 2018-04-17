trigger RollUpEffort on User_Stories__c (after delete, after insert, after update, after undelete) {
	set<ID> Sprints = new set<ID>();
	
	  //When adding new User Stories or updating existing userStories
	if(trigger.isInsert || trigger.isUpdate || trigger.isUndelete){
		for(User_Stories__c u : trigger.new){
			Sprints.add(u.Sprint__c);
			}
		}
		
	//If user stories are deleted
	if(trigger.isDelete){
		for(User_Stories__c u : trigger.old){
			Sprints.add(u.Sprint__c);
			}
		}
		
  //Map will contain one Sprint Id to one sum value
  map<ID, Double> SprintMap = new map<ID, Double> ();
  
  //Produce a sum of Effort__c and add them to the map
  //use group by to have a single Sprint Id with a single sum value
  for(AggregateResult q : [select Sprint__c,sum(Effort__c)
      from User_Stories__c where Sprint__c IN :Sprints group by Sprint__c]){
      	SprintMap.put((Id)q.get('Sprint__c'),(Double)q.get('expr0'));
      	}

  List<Sprint__c> SprintsToUpdate = new List<Sprint__c>();

  //Run the for loop on Sprint using the non-duplicate set of Sprint Ids
  //Get the sum value from the map and create a list of Sprints to update
  for(Sprint__c s : [Select Id, Total_Effort__c from Sprint__c where Id IN :Sprints]){
  	Double EffortSum = SprintMap.get(s.Id);
  	s.Total_Effort__c = EffortSum;
  	SprintsToUpdate.add(s);
  	}
  	
  update SprintsToUpdate;
  
	
}