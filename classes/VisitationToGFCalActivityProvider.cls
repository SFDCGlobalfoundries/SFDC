public class VisitationToGFCalActivityProvider implements GFCalActivityProvider
{
   
   final static String CUSTOMER_LOCATION_TYPE = 'cl';
   final static String PUBLIC_EVENT_TYPE = 'pe';
   final static String NON_PUBLIC_EVENT_TYPE = 'npe';
   final static String PARTNER_LOCATION_TYPE = 'pl';
   final static String SUPPLIER_LOCATION_TYPE = 'sl';
   final static String VENDOR_LOCATION_TYPE = 'vl';
   
   final static String CUSTOMER_LOCATION_COLOR = '#58FA82';
   final static String PUBLIC_EVENT_COLOR = '#F5DA81';
   final static String NON_PUBLIC_EVENT_COLOR = '#A9D0F5';
   final static String PARTNER_LOCATION_COLOR = '#F3F781';
   final static String SUPPLIER_LOCATION_COLOR = '#D8D8D8';
   final static String VENDOR_LOCATION_COLOR = '#F5A9BC';
   
   
   
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
       from Visitation_Record__c where visit_type__c = 'Visit to Customer' 
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
               if(rec.Visit_Location__c == 'Customer Location')
               {
                 a.setBackgroundColor(CUSTOMER_LOCATION_COLOR);
                 typeName = CUSTOMER_LOCATION_TYPE;
               }else if(rec.Visit_Location__c == 'Public Event')
               {
                 a.setBackgroundColor(PUBLIC_EVENT_COLOR);
                 typeName = PUBLIC_EVENT_TYPE;
               }else if(rec.Visit_Location__c == 'Non-public Event (Offsite)')
               {
                 a.setBackgroundColor(NON_PUBLIC_EVENT_COLOR);
                 typeName = NON_PUBLIC_EVENT_TYPE;
               }else if(rec.Visit_Location__c == 'Partner Location')
               {
                 a.setBackgroundColor(PARTNER_LOCATION_COLOR);
                 typeName = PARTNER_LOCATION_TYPE;
               }else if(rec.Visit_Location__c == 'Supplier Location')
               {
                 a.setBackgroundColor(SUPPLIER_LOCATION_COLOR);
                 typeName = SUPPLIER_LOCATION_TYPE;
               }else if(rec.Visit_Location__c == 'Vendor Location')
               {
                 a.setBackgroundColor(VENDOR_LOCATION_COLOR);
                 typeName = VENDOR_LOCATION_TYPE;
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
       tl.add(new GFCalActivityType(CUSTOMER_LOCATION_TYPE,'visitLocation','Customer Location','Customer Location',CUSTOMER_LOCATION_COLOR));
       tl.add(new GFCalActivityType(PUBLIC_EVENT_TYPE,'visitLocation','Public Event','Public Event',PUBLIC_EVENT_COLOR));
       tl.add(new GFCalActivityType(NON_PUBLIC_EVENT_TYPE,'visitLocation','Non-public Event (Offsite)','Non-public Event (Offsite)',NON_PUBLIC_EVENT_COLOR));
       tl.add(new GFCalActivityType(PARTNER_LOCATION_TYPE,'visitLocation','Partner Location','Partner Location',PARTNER_LOCATION_COLOR));
       tl.add(new GFCalActivityType(SUPPLIER_LOCATION_TYPE,'visitLocation','Supplier Location','Supplier Location',SUPPLIER_LOCATION_COLOR));
       tl.add(new GFCalActivityType(VENDOR_LOCATION_TYPE,'visitLocation','Vendor Location','Vendor Location',VENDOR_LOCATION_COLOR));
       return tl;   
          
    }

}