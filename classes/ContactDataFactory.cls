/**
* Author: Dilip Jha
* Project: Test Class Automation  
* Description: This utility class will be used to create Contact data in different Test classes
**/

@isTest
public class ContactDataFactory
{

    public static List<Contact> createContacts(List<Map<String,Object>> ContactfieldValueMaps,Integer numContacts)    
    {
        // Validate parameters
        if (ContactfieldValueMaps != null && ContactfieldValueMaps.size() != numContacts)
        {
            throw new DataFactoryException ('FieldValueMap Size must be equal to number of accounts you want to create.');
        }
        
        List<Contact> contactList=new List<Contact>();
        
        for(Integer i=0;i<numContacts;i++)                    
        {
            
                Contact con = new Contact();
                con.FirstName='TestFname' + i+1;
                con.LastName='TestLname';
                con.email='test@test.com';
             
            if (ContactfieldValueMaps != null)
            {      
                Map<String,Object> ContactfieldValueMap = ContactfieldValueMaps.get(i);
                if (ContactfieldValueMap.get('AccountId') != null)
                {
                    for(String ContactfieldName: ContactfieldValueMap.keySet())
                    {
                        con.put(ContactfieldName, ContactfieldValueMap.get(ContactfieldName));        
                    }
                }
                else
                {
                    throw new DataFactoryException ('AccountId must be passed in as a field to be updated in the parameter passed to the method');    
                }
            }
            ContactList.add(con);    
        }
        
        insert ContactList;
        
        return ContactList;
    }
          
    /* Method to create one Contact Test Data record Dynamically*/
    public static Contact createContact(Map<String,Object> ContactfieldValueMap)
    {
        // Create Contact with default data that is required, this will handle cases where required fields are not set
        // Check whether AccountID was passed in as a parameter
        
        Contact con = new Contact();
        
        if (ContactfieldValueMap != null && ContactfieldValueMap.get('AccountId') != null)
        { 
            con.FirstName='TestFname';
            con.LastName='TestLname';
            con.email='test@test.com';
                      
            for(String ContactfieldName: ContactfieldValueMap.keySet())
            {
                con.put(ContactfieldName, ContactfieldValueMap.get(ContactfieldName));        
            }

            insert con;
        }
        else
        {
            throw new DataFactoryException ('AccountId must be passed in as a field to be updated in the parameter passed to the method');    
        }
        
        return con;            
   }              
}