/*
  Author: Ariz Solito
  Description: Test class for controller class TrainingSubCategoryCntrlr
  History:
    ASolito         03032015    - code creation.
*/
@isTest(SeeAllData=true)
public class TrainingSubCategoryCntrlrTest  {

    static testMethod void testClass(){
        Employee_Training__kav emp = new Employee_Training__kav(
            title = 'Test emp',
            urlName = 'Test-emp',
            objective__c = 'test'
        );
        insert emp;
        
        Employee_Training__DataCategorySelection empGroup = new Employee_Training__DataCategorySelection (
            dataCategoryGroupName = 'New_Employee_Training',
            dataCategoryName = 'CSR',
            parentId = emp.id
        );
        insert empGroup;
        
        Training_Video__kav vid = new Training_Video__kav(
            title = 'Test vid',
            urlName = 'Test-vid',
            video__c = 'test'    
        );
        insert vid;
        
        Training_Video__DataCategorySelection vidGroup = new Training_Video__DataCategorySelection(
            dataCategoryGroupName = 'Products_and_Services',
            dataCategoryName = 'Training_Videos',
            parentId = vid.id
        );
        insert vidGroup;
    
        //Call non video training articles
        PageReference pageRef = Page.TrainingSubCategory;
        pageRef.getParameters().put('category','CSR');       
        Test.setCurrentPageReference(pageRef);
        
        TrainingSubCategoryCntrlr ctrl = new TrainingSubCategoryCntrlr();
        
        //call the instance methods        
        ctrl.redirectToTileMenu();
        ctrl.openArticle();
        
        //go to selected page
        ctrl.currPage = 1;
        ctrl.getPage();
        
        //go to selected category
        ctrl.mainCategory = 'FAE';
        ctrl.selectCategory(); 
        
        //Call video training articles
        pageRef = Page.TrainingSubCategory;
        pageRef.getParameters().put('category','Training Videos');       
        Test.setCurrentPageReference(pageRef);
        
        TrainingSubCategoryCntrlr ctrl2 = new TrainingSubCategoryCntrlr();
        
        //call the instance methods        
        ctrl2.redirectToTileMenu();
        
        //go to selected page
        ctrl2.currPage = 1;
        ctrl2.getPage();
        ctrl2.openArticle();
        
        //go to selected category
        ctrl2.mainCategory = 'Training Videos';
        ctrl2.selectCategory();                
    }    
}