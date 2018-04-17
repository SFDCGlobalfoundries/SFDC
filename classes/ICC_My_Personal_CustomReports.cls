public class ICC_My_Personal_CustomReports
{
    public List<Report> lstMyPersonalCustomReports {get;set;}
    
    public ICC_My_Personal_CustomReports()
    {
        lstMyPersonalCustomReports  = new List<Report>();
        lstMyPersonalCustomReports = [SELECT Id, Name FROM Report USING SCOPE allPrivate WHERE OwnerId=:UserInfo.getUserId()];
    }
}