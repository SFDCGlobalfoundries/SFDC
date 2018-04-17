@isTest
public class RecursionPreventTest
{

    static testmethod void testfunction()
    {
    
    
  
   RecursionPrevent.setAlreadyModified();
   
   System.AssertEquals(true,RecursionPrevent.isAlreadyModified());
   RecursionPrevent.resetAlreadyModified();
   System.AssertEquals(false,RecursionPrevent.isAlreadyModified());
   
   }
   }