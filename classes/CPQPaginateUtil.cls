/*
  Author: Anirban Roy
  Description: This is the utility class for pagination for Multi Source Tapeout.
  History:
    ARoy        09222014    - code creation.              
*/
public class CPQPaginateUtil {
    
    // List of variables
    public Integer index {get;set;}
    public Integer pageNum {get;set;}
    public Integer pageSize {get;set;}
    public Integer totalPage {get;set;}
    public Integer totalResults {get;set;}
    public List<Pager> pageList {get;set;}
    public Boolean showPrevious {get;set;}
    public Boolean showNext {get;set;}
    public Boolean isAll {get;set;}
         
    // Constructor
    public CPQPaginateUtil(Integer pageSize,Integer totalCount){
        Integer listSize = totalCount;
        this.totalResults = listSize;
        this.pageSize = (pageSize > 0)?pageSize:10;
        this.totalPage = (Integer)Math.ceil((Double)listSize / (Double)pageSize);
        this.pageNum = 1;
        this.index = 0;
        this.isAll = (listSize == pageSize)?true:false;
        updateNumbers();
    }
     
    // Method to update the page number, next and previous links
    public void updateNumbers(){
        this.pageList = new List<Pager>();
        for(Integer i = 1; i < (this.totalPage + 1); i++){
            Boolean b = (i == pageNum)?true:false;
            this.pageList.add(new Pager(i, b));
        }
        this.showPrevious = (this.pageNum == 1)?false:true;
        this.showNext = (this.pageNum == this.totalPage)?false:true;
        this.index = this.pageNum - 1;
    }
         
    // Method to decrement the page number counter
    public void decrement(){
        this.pageNum = this.pageNum - 1;
        updateNumbers();
    }
     
    // Method to increment the page number counter
    public void increment(){
        this.pageNum++;
        updateNumbers();
    }        
 
    // Wrapper class for page number and active link
    public class Pager{
        public Integer pageNum {get;set;}
        public Boolean isActive {get;set;}
         
        public Pager(Integer num, Boolean active){
            this.pageNum = num;
            this.isActive = active;
        }
    }
}