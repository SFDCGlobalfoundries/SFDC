public class CPQRedirectFieldCreateCls {

    public CPQRedirectFieldCreateCls(ApexPages.StandardController controller) {

    }

    public pagereference createAttributeField(){
        return (new pagereference('/p/setup/field/NewCustomFieldStageManager?entity='+ System.Label.Product_Attribute_Value_ObjectID+'&setupid=CustomObjects'));
    }
    public pagereference createFieldDependency(){
        return (new pagereference('/setup/ui/dependencyList.jsp?tableEnumOrId='+ System.Label.Product_Attribute_Value_ObjectID));
    }
}