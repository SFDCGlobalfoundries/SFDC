public class SearchablePicklistController{
    public list<SelectOption> options{get; set;}
    public string pickval{get; set;}
    public SearchablePicklistController(){
        options = new list<SelectOption>();
        options.add(new SelectOption('test','test'));
        options.add(new SelectOption('test1','test1'));
        options.add(new SelectOption('test2','test2'));
    }
}