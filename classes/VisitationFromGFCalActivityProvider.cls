/*Author: 
    Description: This is for Calendar view in Customer Visitation
    History: Edited by Mallika Seth & Vijay Vemuru for adding Santa Clara and Fab 9/10 Locations
    Created     -     Vijay Vemuru-    05/06/2016      - code creation.
*/
public class VisitationFromGFCalActivityProvider implements GFCalActivityProvider
{
   
   final static String DRESDEN_TYPE = 'drs';
   final static String MALTA_TYPE = 'mlt';
   final static String EAST_FISHKILL_TYPE = 'fsk';
   final static String BURLINGTON_TYPE = 'btv';
   final static String WILLISTON_TYPE = 'wil';
   final static String SANTA_CLARA_TYPE = 'sc';
   final static String SINGAPORE_TYPE = 'sgp';
   final static String GF_OTHER_TYPE = 'oth';
      
   
   final static String DRESDEN_COLOR = '#58FA82';
   final static String MALTA_COLOR = '#F5DA81';
   final static String EAST_FISHKILL_COLOR = '#9933ff';
   final static String BURLINGTON_COLOR = '#A9D0F5';
   final static String WILLISTON_COLOR = '#00FFFF';
   final static String SANTA_CLARA_COLOR = '#cc99ff';
   final static String SINGAPORE_COLOR = '#F3F781';
   final static String GF_OTHER_COLOR = '#D8D8D8';
   
   String backgroundColor = '#FFFFFF';
     public List<GFCalActivity> findActivities(String id)
     {
       String typeName = null;
       List<GFCalActivity> al = new List<GFCalActivity>();
       GFCalActivity a = null;
       List<String> exclude = new List<String>();
       exclude.add('5. Closed - Cancelled');
       exclude.add('5. Closed - Rejected');
       List<Visitation_Record__c> qlist = [SELECT Id, Account__r.Name, Start_Date__c, End_Date__c, Visit_Type__c, Visit_Location__c, Customer_Status__c 
       from Visitation_Record__c where visit_type__c = 'Visit from Customer' 
       and Customer_Status__c not in :exclude
       order by Start_Date__c desc LIMIT 1000];
       for(Visitation_Record__c rec:qlist)
       {
           a = new GFCalActivity();
           a.setId(rec.Id);
           typeName = '';
           a.setSubject(rec.Account__r.Name);
           a.setBackgroundColor(backgroundColor);
           a.setStartDate(rec.Start_Date__c);
           a.setEndDate(rec.End_Date__c);
           
           if(rec.Visit_Location__c != null)
           {
               if(rec.Visit_Location__c == 'Dresden')
               {
                 a.setBackgroundColor(DRESDEN_COLOR);
                 typeName = DRESDEN_TYPE;
               }else if(rec.Visit_Location__c == 'Malta')
               {
                 a.setBackgroundColor(MALTA_COLOR);
                 typeName = MALTA_TYPE;
               }else if(rec.Visit_Location__c == 'East Fishkill')
               {
                 a.setBackgroundColor(EAST_FISHKILL_COLOR);
                 typeName = EAST_FISHKILL_TYPE;
               }else if(rec.Visit_Location__c == 'Burlington')
               {
                 a.setBackgroundColor(BURLINGTON_COLOR);
                 typeName = BURLINGTON_TYPE;
               }else if(rec.Visit_Location__c == 'Williston')
               {
                 a.setBackgroundColor(WILLISTON_COLOR);
                 typeName = WILLISTON_TYPE;
               }else if(rec.Visit_Location__c == 'Santa Clara')
               {
                 a.setBackgroundColor(SANTA_CLARA_COLOR);
                 typeName = SANTA_CLARA_TYPE;
               }
               else if(rec.Visit_Location__c == 'Singapore')
               {
                 a.setBackgroundColor(SINGAPORE_COLOR);
                 typeName = SINGAPORE_TYPE;
               }else if(rec.Visit_Location__c == 'GLOBALFOUNDRIES Other Site')
               {
                 a.setBackgroundColor(GF_OTHER_COLOR);
                 typeName = GF_OTHER_TYPE;
               }
                if(rec.Visit_Location__c == 'test location')
               {
                 a.setBackgroundColor(DRESDEN_COLOR);
                 typeName = DRESDEN_TYPE;
               }
               a.put('visitLocation',rec.Visit_Location__c);
           }
           a.setType(typeName);
           al.add(a);
       }
       return al;  
     }
     
    public List<GFCalActivityType> getActivityTypes()
    {
       List<GFCalActivityType> tl = new List<GFCalActivityType>();
       GFCalActivityType type = new GFCalActivityType();
       tl.add(new GFCalActivityType(DRESDEN_TYPE,'visitLocation','Dresden','Dresden',DRESDEN_COLOR));
       tl.add(new GFCalActivityType(MALTA_TYPE,'visitLocation','Malta','Malta',MALTA_COLOR));
       tl.add(new GFCalActivityType(EAST_FISHKILL_TYPE,'visitLocation','East Fishkill','East Fishkill',EAST_FISHKILL_COLOR));
       tl.add(new GFCalActivityType(BURLINGTON_TYPE,'visitLocation','Burlington','Burlington',BURLINGTON_COLOR));
       tl.add(new GFCalActivityType(WILLISTON_TYPE,'visitLocation','Williston','Williston',WILLISTON_COLOR));
       tl.add(new GFCalActivityType(WILLISTON_TYPE,'visitLocation','Santa Clara','Santa Clara',SANTA_CLARA_COLOR));
       tl.add(new GFCalActivityType(SINGAPORE_TYPE,'visitLocation','Singapore','Singapore',SINGAPORE_COLOR));
       tl.add(new GFCalActivityType(GF_OTHER_TYPE,'visitLocation','GLOBALFOUNDRIES Other Site','GLOBALFOUNDRIES Other Site',GF_OTHER_COLOR));
       return tl;   
    }
}