public class DateUtil
{
   private static Map<String,Integer> weekdayMap = new Map<String,Integer>();
   static
   {
         weekdayMap.put('MONDAY',0);
         weekdayMap.put('TUESDAY',1);
         weekdayMap.put('WEDNESDAY',2);
         weekdayMap.put('THURSDAY',3);
         weekdayMap.put('FRIDAY',4);
         weekdayMap.put('SATURDAY',5);
         weekdayMap.put('SUNDAY',6);
   }
   

   public static Datetime getCurrentTimeLocal()
   {
      return Datetime.now();
   }
      
   public static Datetime getCurrentTimeSGP()
   {
      return Datetime.now().addHours(8);
   }
   

   public static Date getCurrentWeekFridayLocalDate()
   {
     Datetime currDT = getCurrentWeekFridayLocal();
     Date myDate =  date.newinstance(currDT.year(),currDT.month(),currDT.day());     
     return myDate;
    }
   public static Datetime getCurrentWeekFridayLocal()
   {
      Datetime currDT = getCurrentTimeLocal();
      String dayOfWeek = currDT.format('EEEE');
      Integer dayOfWeekInt = dayOfWeek(dayOfWeek);
      dayOfWeekInt = dayOfWeekInt * -1;
      currDT = currDT.addDays(dayOfWeekInt);
      currDT = currDT.addDays(5);      
      currDT = Datetime.newInstanceGMT(currDT.year(),currDT.month(),currDT.day(),0,0,0);
      return currDT;
   }
  
   public static Datetime getWeekMondaySGP(Date argDT)
   {
      Datetime gmtDT = Datetime.newInstanceGMT(argDT.year(),argDT.month(),argDT.day(),0,0,0);
       String dayOfWeek = gmtDT.format('EEEE');
      Integer dayOfWeekInt = dayOfWeek(dayOfWeek);
      dayOfWeekInt++;      
      dayOfWeekInt = dayOfWeekInt * -1;
      gmtDT = gmtDT.addDays(dayOfWeekInt);
      return gmtDT;
   }
   
   public static Datetime getCurrentWeekMondaySGP()
   {
      Datetime currDT = getCurrentTimeSGP();
      String dayOfWeek = currDT.format('EEEE');
      Integer dayOfWeekInt = dayOfWeek(dayOfWeek);
      dayOfWeekInt = dayOfWeekInt * -1;
      currDT = currDT.addDays(dayOfWeekInt);
      currDT = Datetime.newInstanceGMT(currDT.year(),currDT.month(),currDT.day(),0,0,0);
      return currDT;
   }
   
   public static Integer dayOfWeek(String day)
   {
      
      Integer value = weekdayMap.get(day.toUpperCase());
      if(value != null)
       return value;
       return 0;
   }
    

}