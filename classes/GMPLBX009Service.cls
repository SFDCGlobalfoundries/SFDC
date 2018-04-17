/*
    Author: Anirban Roy
    Description: This is a utility class for the approval action on GMPL/BX009 .
    History: 
        ARoy           03212014    - Code creation.
        ARoy 		   06102014	   - Code modification for Override the Quantity and Revenue forecasted from different Opportunities.
                                       
*/
global class GMPLBX009Service {        
    
    public static String sysAdmin = EnvironmentVariable.get('SYS_ADMIN');
    public static String ctsDev = EnvironmentVariable.get('CTS_DEVELOPER');
    public static String gfDev = EnvironmentVariable.get('GF_DEVELOPER');
    public static String gfSysAdmin = EnvironmentVariable.get('GF_SYSTEM_ADMIN');
    public static String gfGlbAdmin = EnvironmentVariable.get('GF_GLOBAL_ADMIN');
    public static String gfInt = EnvironmentVariable.get('GF_INTEGRATION');
    public static String gfSalesUsr = EnvironmentVariable.get('GF_SALES_USER');
    public static String gfProdMrktg = EnvironmentVariable.get('GF_PROD_MARKETING');
    public static String ppmTeamGrp = EnvironmentVariable.get('PPM_TEAM_GROUP');
    public static String ceAdminGrp = EnvironmentVariable.get('CE_ADMIN_GROUP');
    
    webservice static String approvalRequest(String gmplBx009Id) {
        
        //Set<String> ppeRoleAllowed = new Set<String>{EnvironmentVariable.get('PPE_TEAM_ROLE_PLBX009'),EnvironmentVariable.get('PPE_TEAM_ROLE_AMBX009'),EnvironmentVariable.get('PPE_TEAM_ROLE_PMBX009')};        
        Boolean havePermission = false;

        Profile prof = [select    Id
                                  ,Name 
                        from      Profile
                        where     Id = :UserInfo.getProfileId()
                       ];
    
        if(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
            || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt 
            || prof.Name == gfProdMrktg || prof.Name == gfSalesUsr){
            havePermission = true;       
        }else{
            List<GroupMember> gmList = PPETeamHelper.getUserInGroup(UserInfo.getUserId(),new List<String>{ppmTeamGrp, ceAdminGrp});       
            if(gmList!=null && gmList.size()>0){
               //if the User is a PPM Team member 
               havePermission = true;           
            }else{
                List<PermissionSetAssignment> permSetAssgnmtList = [select    id
                                                                    from      PermissionSetAssignment
                                                                    where     AssigneeId = :UserInfo.getUserId()
                                                                    and       PermissionSetId in (select id from PermissionSet where Name = 'MarketingVPnPL_Permission') 
                                                                   ];
                if(permSetAssgnmtList!=null && permSetAssgnmtList.size()>0){
                    havePermission = true;
                }
            }
            
            /*else{
               // Check for the User in the PPE Team for AM/PM/PL
               List<PPE_Team__c> ptList = PPETeamHelper.getUserInPPETeam(UserInfo.getUserId(),new List<String>{gmplBx009Id});
               if(ptList!=null && ptList.size()>0 && ppeRoleAllowed.contains(ptList[0].PPE_Role__c) && ptList[0].Access_Level__c == 'Read/Write'){
                   havePermission = true;
               }
            }*/
        }
        
        String message = 'OK';
        
        if(havePermission){                        
            
            GMPL_BX009__c gmplBx009 = [select   id
                                                , ownerId
                                                , Consigned_Wafer__c
                                                , SQE_Acknowledgement__c
                                                , Product_Process__c
                                                , Process_Acknowledgement__c
                                                , Productization__c
                                                , Productization_Acknowledgement__c
                                                , Turnkey__c
                                                , Turnkey_Acknowledgement__c
                                                , Total_Quantity_Forecasted__c
                                                , Total_Revenue_Forecasted__c  
                                       from     GMPL_BX009__c 
                                       where    Id = :gmplBx009Id
                                      ];
            
            /*if(((gmplBx009.Consigned_Wafer__c && gmplBx009.Product_Process__c) 
                    || (gmplBx009.Productization__c && gmplBx009.Turnkey__c)) ||
                    ((gmplBx009.Consigned_Wafer__c && gmplBx009.Productization__c) 
                    || (gmplBx009.Product_Process__c && gmplBx009.Turnkey__c)) ||
                    ((gmplBx009.Consigned_Wafer__c && gmplBx009.Turnkey__c) 
                    || (gmplBx009.Product_Process__c && gmplBx009.Productization__c))){
                
                if((((gmplBx009.Consigned_Wafer__c && gmplBx009.SQE_Acknowledgement__c) 
                        && (gmplBx009.Product_Process__c && gmplBx009.Process_Acknowledgement__c))
                        || ((gmplBx009.Productization__c && gmplBx009.Productization_Acknowledgement__c)
                        && (gmplBx009.Turnkey__c && gmplBx009.Turnkey_Acknowledgement__c))) ||
                        (((gmplBx009.Consigned_Wafer__c && gmplBx009.SQE_Acknowledgement__c) 
                        && (gmplBx009.Productization__c && gmplBx009.Productization_Acknowledgement__c))
                        || ((gmplBx009.Product_Process__c && gmplBx009.Process_Acknowledgement__c)
                        && (gmplBx009.Turnkey__c && gmplBx009.Turnkey_Acknowledgement__c))) ||
                        (((gmplBx009.Consigned_Wafer__c && gmplBx009.SQE_Acknowledgement__c) 
                        && (gmplBx009.Turnkey__c && gmplBx009.Turnkey_Acknowledgement__c))
                        || ((gmplBx009.Product_Process__c && gmplBx009.Process_Acknowledgement__c)
                        && (gmplBx009.Productization__c && gmplBx009.Productization_Acknowledgement__c)))
                        ){*/
                                   
           if(gmplBx009.Consigned_Wafer__c || gmplBx009.Productization__c 
                    || gmplBx009.Product_Process__c || gmplBx009.Turnkey__c){
                Boolean isValidSQE = true;
                Boolean isValidProcess = true;  
                Boolean isValidProductization = true;   
                Boolean isValidTurnkey = true;                  
                
                if(gmplBx009.Consigned_Wafer__c){
                    if(!gmplBx009.SQE_Acknowledgement__c){
                        isValidSQE = false;
                    }
                }
                if(gmplBx009.Product_Process__c){
                    if(!gmplBx009.Process_Acknowledgement__c){
                        isValidProcess = false;
                    }
                }
                if(gmplBx009.Productization__c){
                    if(!gmplBx009.Productization_Acknowledgement__c){
                        isValidProductization = false;
                    }
                }
                if(gmplBx009.Turnkey__c){
                    if(!gmplBx009.Turnkey_Acknowledgement__c){
                        isValidTurnkey = false;
                    }
                }
                
                if(isValidSQE && isValidProcess && isValidProductization && isValidTurnkey){           
                    
                    String prevOwnerId = gmplBx009.ownerId;
                
                    if(gmplBx009!=null){
                        gmplBx009.ownerId = UserInfo.getUserId();
                        update gmplBx009;
                    }
                    
                    // Submit the approval process as the user got access as he is is now owner of the record.
                    try{           
                        Approval.ProcessSubmitRequest reqSubmit = new Approval.ProcessSubmitRequest();
                        reqSubmit.setObjectId(gmplBx009Id);  
                        Approval.Processresult resSubmit = Approval.process(reqSubmit);
                    }catch(Exception e){
                        system.debug('Error occurred during Approval Submission :: '+ e.getMessage());
                        if(e.getMessage().contains('MANAGER_NOT_DEFINED')){
                        	message = 'Please check whether the Account Region Head approver(s)/Marketing VP approver(s)' 
                        				+ ' are present for Customer/Market type BX009.';
                        }else{
                        	message = e.getMessage();
                        }
                    }            
                    
                    if(gmplBx009!=null){
                        gmplBx009.ownerId = prevOwnerId;
                        update gmplBx009;
                    }
                    
                }else{
                    message = 'It is essential to Acknowledge the completion of details for the Service Type(s) selected to proceed further.' 
                               +'\nHence user should select:'
                               +'\n- \'Project Leader Acknowledgement\' field, if \'Product/ Process\' has been selected'
                               +'\n- \'Productization Acknowledgement\' field, if \'Productization\' has been selected'
                               +'\n- \'Turnkey Acknowledgement\' field, if \'Turnkey\' has been selected'
                               +'\n- \'SQE Acknowledgement\' field, if \'Consigned Wafer\' has been selected';
                }
            }else{
                message = Error_Codes__c.getInstance('GMPL_BX009_APPROVAL_ERR_MSG_1').Message__c;
            }                                                
        }else{
            message = Error_Codes__c.getInstance('GMPL_BX009_APPROVAL_PERMISSION_ERR_MSG').Message__c 
            			+ ' ' + Error_Codes__c.getInstance('GMPL_BX009_APPRVL_PERM_ERR_MSG1').Message__c;
        }
        return message;   
    }
    
    // Calculate the total Total_Lifetime_Revenue__c from different Opportunities
    webservice static String calculateRevenue(String gmplBx009Id) {
            
        try{
            
            Profile prof = PPETeamHelper.getUserProfile();                          
            
	        List<GMPL_BX009__Share> gmplList = new List<GMPL_BX009__Share>();
	         
	        if(!(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt)){	            
	            gmplList =  PPETeamHelper.getGMPLBX009ShareUser(gmplBx009Id);
	        }
            if((gmplList != null && gmplList.size()>0)||(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
                || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt)){
            
	            AggregateResult[] gmplAggregateList  = [select      SUM(Total_Lifetime_Revenue__c) totalRev
	                                                    from        GMPL_Opportunity__c
	                                                    where       GMPL_BX009__c = :gmplBx009Id
	                                                   ];       
	            
	            Double totalRev = Double.valueOf(gmplAggregateList[0].get('totalRev'));         
	                
	
	            GMPL_BX009__c gmpl = [select    Id
	                                            , Lifetime_Revenue_Refresh_Timestamp__c
	                                            , Total_Lifetime_Revenue__c 
	                                  from      GMPL_BX009__c 
	                                  where     Id = :gmplBx009Id
	                                 ];
	                                 
	            gmpl.Total_Lifetime_Revenue__c = totalRev;
	            gmpl.Lifetime_Revenue_Refresh_Timestamp__c = System.now();
	            update gmpl;
	
	            return 'OK';
            }else{
            	return Error_Codes__c.getInstance('GMPL_BX009_READ_ONLY_VALIDATION').Message__c;
            }

        }catch(Exception e){
            return Error_Codes__c.getInstance('GMPL_BX009_CALC_REV_ERR_MSG').Message__c;
        }               

    }
    
    // Override the Quantity and Revenue forecasted from different Opportunities
    webservice static String overrideWithQrtlyRevFrcst(String gmplBx009Id, String revStrtYr) {
    	
    	try{
	    	Profile prof = PPETeamHelper.getUserProfile();                          
	            
	        List<GMPL_BX009__Share> gmplList = new List<GMPL_BX009__Share>();
	         
	        // Check for the user present in the GMPL/BX009 share
	        if(!(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
	            || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt)){	            
	            gmplList =  PPETeamHelper.getGMPLBX009ShareUser(gmplBx009Id);
	        }
	        
	        // Check for the admin user profiles
	        if((gmplList != null && gmplList.size()>0)||(prof.Name == sysAdmin || prof.Name == ctsDev || prof.Name == gfDev
	            || prof.Name == gfSysAdmin || prof.Name == gfGlbAdmin || prof.Name == gfInt)){
	        	
	        	List<Id> oppIds = new List<Id>();
	        	
	        	// Get the opportunities linked with the GMPL/BX009
	        	List<GMPL_Opportunity__c> oppList1 = [select	GMPL_BX009__c
	        										 			, Opportunity__c
	        										  from		GMPL_Opportunity__c
	        										  where		GMPL_BX009__c = :gmplBx009Id
	        										 ];
	        	
	        	for(GMPL_Opportunity__c gmplOpp : oppList1){
	        		oppIds.add(gmplOpp.Opportunity__c);
	        	}
	        	
	        	// Get the Quarterly Revenues attached to the Opportunities
	        	List<Opportunity> oppList2 = [select	id
	        								 			, (select 	id
	        								 						, Date__c
	        								 						, Fiscal_Quarter__c
	        								 						, ASP__c
	        								 						, Volume__c
	        								 						, Revenue__c 
	        								 			   from 	Quarterly_Revenues__r)
	        								  from		Opportunity
	        								  where		id in :oppIds
	        								 ];
	        	
	        	// Validation for the earliest year in Opportunities to the GMPL Revenue Forecast Year
	        	Integer earliestQtrYr;
	        	Integer qtrYr;
	        	Map<Integer,Integer> yrToVolumeMap = new Map<Integer,Integer>();
	        	Map<Integer,Decimal> yrToAspMap = new Map<Integer,Decimal>(); 							
	        	for(Opportunity opp : oppList2){
	        		for(Quarterly_Revenue_Object__c quarterRev : opp.Quarterly_Revenues__r){
	        			// Parsing for the Quarter Year from the Fiscal Quarter
	        			if(quarterRev.Fiscal_Quarter__c != null && quarterRev.Fiscal_Quarter__c.contains('-')){
	        				qtrYr = Integer.valueOf(quarterRev.Fiscal_Quarter__c.split('-')[0]);        				
	        			}        			
	        			if(qtrYr != null){
	        				// Get the volume from the Quarter Revenue and put it inside a map with Year as a key
	        				if(yrToVolumeMap.containsKey(qtrYr) && quarterRev.Volume__c != null){
	        					Integer tempQtrVol = yrToVolumeMap.get(qtrYr)+Integer.valueOf(quarterRev.Volume__c);
	        					yrToVolumeMap.put(qtrYr,tempQtrVol);		
	        				}else if(!(yrToVolumeMap.containsKey(qtrYr)) && quarterRev.Volume__c != null){
	        					yrToVolumeMap.put(qtrYr,Integer.valueOf(quarterRev.Volume__c));
	        				}
	        				// Get the average sales price from the Quarter Revenue and put it inside a map with Year as a key
	        				if(yrToAspMap.containsKey(qtrYr) && quarterRev.ASP__c != null
	        					&& quarterRev.Volume__c != null){
	        					Decimal tempQtrAsp = yrToAspMap.get(qtrYr)+(quarterRev.ASP__c*Integer.valueOf(quarterRev.Volume__c));
	        					yrToAspMap.put(qtrYr,tempQtrAsp);		
	        				}else if(!(yrToAspMap.containsKey(qtrYr)) && quarterRev.ASP__c != null 
	        					&& quarterRev.Volume__c != null){
	        					yrToAspMap.put(qtrYr,(quarterRev.ASP__c*Integer.valueOf(quarterRev.Volume__c)));
	        				}
	        				// Check for the earliest year of the Quarterly Revenue with the GMPL Revenue Forecast
	        				if(earliestQtrYr == null || qtrYr < earliestQtrYr){
	        					earliestQtrYr = qtrYr;
	        				}
	        			}
	        			
	        		}
	        	}
	        	
	        	// Checking for earlier year on Quarterly Revenue than GMPL Revenue Forecast
	        	if(revStrtYr != null && revStrtYr != ''){
	        		if(earliestQtrYr < Integer.valueOf(revStrtYr)){
	        			return Error_Codes__c.getInstance('OPP_QTRLY_REV_OVR_GMPL_REV_VALIDATION').Message__c;
	        		}else{        			
	        			Boolean isUpsert = false;
	        			Integer lastYr = 0;
	        			List<Revenue_Forecast__c> revForList = new List<Revenue_Forecast__c>();
	        			for(Revenue_Forecast__c revFor : [select	Id
	        														, Average_Sales_Price__c
	        										 				, Quantity__c
	        										 				, Year__c
	        										 				, GMPL_BX009__c
		        										  from		Revenue_Forecast__c
		        										  where		GMPL_BX009__c = :gmplBx009Id
		        										  order by Year__c asc]){						  	       				 
	        				
	        				revFor.Average_Sales_Price__c = 0;
	        				revFor.Quantity__c = 0;
	        				
	        				// Check for volume for the particular year
	        				if(yrToVolumeMap.containsKey(Integer.valueOf(revFor.Year__c))){
	        					revFor.Quantity__c = yrToVolumeMap.get(Integer.valueOf(revFor.Year__c));
	        					isUpsert = true;
	        				}
	        				
	        				// Check for average sales price for the particular year
	        				if(yrToAspMap.containsKey(Integer.valueOf(revFor.Year__c))
	        					&& yrToVolumeMap.containsKey(Integer.valueOf(revFor.Year__c))
	        					&& yrToVolumeMap.get(Integer.valueOf(revFor.Year__c)) != 0){
	        					revFor.Average_Sales_Price__c = (yrToAspMap.get(Integer.valueOf(revFor.Year__c)) / yrToVolumeMap.get(Integer.valueOf(revFor.Year__c))).setScale(2);
	        					isUpsert = true;
	        				}
	        				lastYr = Integer.valueOf(revFor.Year__c);	        			
	        				revForList.add(revFor);	
	        			}
	        			
	        			if(yrToVolumeMap.size()>0){
		        			for(Integer year : yrToVolumeMap.keySet()){
		        				if(lastYr < year || lastYr == 0){
		        					Revenue_Forecast__c revFor1 = new Revenue_Forecast__c();
		        					
		        					revFor1.Average_Sales_Price__c = 0;
		        					
		        					// Populate Average Sales Price for the particular year
			        				if(yrToAspMap.containsKey(year)
			        					&& yrToVolumeMap.get(year) != 0){
			        					revFor1.Average_Sales_Price__c = (yrToAspMap.get(year) / yrToVolumeMap.get(year)).setScale(2);
			        				}
		        					
		        					// Populate Volume for the particular year
			        				revFor1.Quantity__c = yrToVolumeMap.get(year);
									revFor1.Year__c = String.valueOf(year);
									revFor1.GMPL_BX009__c = gmplBx009Id;																		
									
									revForList.add(revFor1);
									isUpsert = true;
		        				}
		        			}
	        			}
	        			
	        			// Upsert the GMPL Revenue Forecast for the GMPL/BX009 record
	        			if(isUpsert){
	        				upsert revForList;
	        				// Update the GMPL/BX009 object with the latest timestamp of the Opportunity Quarterly Revenue Refresh 
	        				GMPL_BX009__c gmplObj = [select		Id
	        													, Overridden_Quarter_Rev_Fcst_Timestamp__c
	        										 from		GMPL_BX009__c
	        										 where		Id = :gmplBx009Id
	        										];
	        				gmplObj.Overridden_Quarter_Rev_Fcst_Timestamp__c = System.now();
	        				update gmplObj;
	        			}
	        		}
	        	}
	        	
	        	return 'OK';
	        }else{
	        	return Error_Codes__c.getInstance('GMPL_BX009_READ_ONLY_VALIDATION').Message__c;
	        }
    	}catch(Exception e){
            return Error_Codes__c.getInstance('OPP_QTRLY_REV_OVR_GMPL_REV_ERROR').Message__c;
        }
    }   
    
}