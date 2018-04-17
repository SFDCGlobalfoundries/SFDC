/*
Type Name: BNPTaskAssigneeLookupCtrl
Author: Poulami Saha
Project Name: DIW Step Down Track 2 (BnP) 
Created Date: 18/08/2016
Description: This class serves controller for BNPTaskAssigneeLookup page.
Test Class: 
Change History:
*/
public with sharing class BNPTaskAssigneeLookupCtrl 
{
    public String query {get; set;}
    public List<User> userList {get; set;}
    public List<Group> grpList {get; set;}
    
    /**
    *  Constructor of this Controller 
    *  @name <BNPTaskAssigneeLookupCtrl>
    *  @param <NA> 
    *  @return <NA> - <>
    *  @throws exception-<exception description>
    */
    public BNPTaskAssigneeLookupCtrl()
    {
        //List<List<Account>> searchResults=[FIND :query IN ALL FIELDS RETURNING Account (id, name, billingstreet, billingcity, billingpostalcode)];
        //accounts=searchResults[0];
        //return null;
        
        String getParName = ApexPages.currentPage().getParameters().get('queryfield');
        /*if(getParName == 'User'){
            userList = [Select id, firstName from user WHERE IsActive = true];
        
        }*/
    }
    
    /**
    *  The Purpose of this method is to search user/group 
    *  @name <runQuery>
    *  @param <NA> 
    *  @return <pageReference>
    *  @throws exception-<GlobalUtility.logMessage was called to capture the exception>
    */
    public PageReference runQuery()
    {
        String getParName = ApexPages.currentPage().getParameters().get('queryfield');
        if(getParName == 'User'){
            //if(query.length() > 1){
                try{
                    List<List<User>> searchResults=[FIND :query IN ALL FIELDS RETURNING User (id, Name)];
                    userList=searchResults[0];
                    return null;
                }catch(Exception excp){
                    ApexPages.addMessages(excp) ; 
                    GlobalUtility.logMessage('Error','BNPTaskAssigneeLookupCtrl','runQuery','','Exception while fetching User',String.valueof(excp.getMessage()),'','BnP',excp,0);
                }
                

        }else if(getParName == 'Group'){
            //if(query.length() > 1){
                try{
                    List<List<Group>> searchResults=[FIND :query IN ALL FIELDS RETURNING Group (id, Name)];
                    grpList=searchResults[0];
                    return null;
                }catch(Exception excp){
                    ApexPages.addMessages(excp) ; 
                    GlobalUtility.logMessage('Error','BNPTaskAssigneeLookupCtrl','runQuery','','Exception while fetching Group',String.valueof(excp.getMessage()),'','BnP',excp,0);
                }
            
        }
        return null;
        
    }
    
}