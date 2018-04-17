public class GFCalActivityType
{
    private String typeCode = null;
    private String typeLabel = null;
    private String backgroundColor = null;
    private String typeKey = null;
    private String typeValue = null;
    
    
    public GFCalActivityType(){}
    public GFCalActivityType(String typeCode,String typeKey,String typeValue,String typeLabel,String backgroundColor)
    {
        this.typeCode = typeCode;
        this.typeKey = typeKey;
        this.typeValue = typeValue;
        this.typeLabel = typeLabel;
        this.backgroundColor = backgroundColor;
    }
    
    public String getTypeCode(){return typeCode;}
    public String getTypeKey(){return typeKey;}
    public String getTypeValue(){return typeValue;}
    public String getTypeLabel(){return typeLabel;}
    public String getBackgroundColor(){return backgroundColor;}
    public void setTypeCode(String tc){this.typeCode = tc;}
    public void setTypeKey(String tk){this.typeKey = tk;}
    public void setTypeValue(String tv){this.typeValue = tv;}
    public void setTypeLabel(String tl){this.typeLabel = tl;}
    public void setBackgroundColor(String bc){this.backgroundColor = bc;}
}