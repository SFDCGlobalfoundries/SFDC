/*
	@Author :- Abhita Bansal
*/
@isTest
global class WebServiceCollabMockImpl implements WebServiceMock {  
   global void doInvoke(  
           Object stub,  
           Object request,  
           Map<string, Object> response,  
           String endpoint,  
           String soapAction,  
           String requestName,  
           String responseNS,  
           String responseName,  
           String responseType) {  
       
       // Code handles request/response for DFM Details
       if(request instanceof QueryPtsrServiceCls.GetDFMDetailsResponse_element){  
           QueryPtsrServiceCls.GetDFMDetailsResponse_element respElement = new QueryPtsrServiceCls.GetDFMDetailsResponse_element();               
           QueryPtsrServiceCls.GetDFMDetailsResponseDetailType dFMDetailInfo = new QueryPtsrServiceCls.GetDFMDetailsResponseDetailType();
           dFMDetailInfo.DFMDesignType = 'Test1';
           dFMDetailInfo.AccountManager = 'TestUser1';
            
           List<QueryPtsrServiceCls.GetDFMDetailsResponseDetailType> dFMDetailInfoList = new List<QueryPtsrServiceCls.GetDFMDetailsResponseDetailType>();
           dFMDetailInfoList.add(dFMDetailInfo);
            
           respElement.GetDFMDetailsResponseDetail = dFMDetailInfoList;   
           response.put('response_x',respElement);
           
       } else if(request instanceof QueryPtsrServiceCls.GetDRCDetailsResponse_element){      
           QueryPtsrServiceCls.GetDRCDetailsResponse_element respDrcElement = new QueryPtsrServiceCls.GetDRCDetailsResponse_element();        
           QueryPtsrServiceCls.GetDRCDetailsResponseDetailType  drcDetailInfo = new QueryPtsrServiceCls.GetDRCDetailsResponseDetailType();
           drcDetailInfo.LayoutType = 'Test layout type';
           drcDetailInfo.OtherLayoutType = 'Test otherlayouttype';
           drcDetailInfo.LayoutSource = 'Test layout source';
           drcDetailInfo.OtherLayoutSource = 'Test OtherLayoutSource';
                   
           List<QueryPtsrServiceCls.GetDRCDetailsResponseDetailType>  drcDetailInfoList = new List<QueryPtsrServiceCls.GetDRCDetailsResponseDetailType>();
           drcDetailInfoList.add(drcDetailInfo);       
           respDrcElement.GetDRCDetailsResponseDetail = drcDetailInfoList;       
           response.put('response_x', respDrcElement);
           
       } else if(request instanceof QueryPtsrServiceCls.GetPTSRDetailsResponse_element){       
           // Code handles request/response for PTSR Details   
           QueryPtsrServiceCls.GetPTSRDetailsResponse_element respPTSRElement = new QueryPtsrServiceCls.GetPTSRDetailsResponse_element();         
           QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType pTSRDetailInfo = new QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType();
           pTSRDetailInfo.CustomerFullName = 'TestUser1';
           pTSRDetailInfo.MaskSetTitle = 'Test1';
            
           List<QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType> pTSRDetailInfoList = new List<QueryPtsrServiceCls.GetPTSRDetailsResponseDetailType>();
           pTSRDetailInfoList.add(pTSRDetailInfo);
            
           respPTSRElement.GetPTSRDetailsResponseDetail = pTSRDetailInfoList;        
           response.put('response_x',respPTSRElement);
           
       } else if(request instanceof QueryPtsrServiceCls.GetDFMChipsDetailsResponse_element){
           // Code handles request/response for DFM Chip Details    
           QueryPtsrServiceCls.GetDFMChipsDetailsResponse_element respChipElement = new QueryPtsrServiceCls.GetDFMChipsDetailsResponse_element();  
           
           QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType chipDetailInfo = new QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType();
           chipDetailInfo.ChipName = 'Test1';
           chipDetailInfo.TopCellName = 'TestCell1';
            
           List<QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType> chipDetailInfoList = new List<QueryPtsrServiceCls.GetDFMChipsDetailsResponseDetailType>();
           chipDetailInfoList.add(chipDetailInfo);
            
           respChipElement.GetDFMChipsDetailsResponseDetail = chipDetailInfoList;  
           response.put('response_x',respChipElement);
       }    
   }  
}