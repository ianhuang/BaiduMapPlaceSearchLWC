global with sharing class BaiduMapPlaceSearchController {

    private static final String URL_PARAMS = '/place/v2/search/?region={0}&query={1}&output=json&ak={2}';
    private static final bdmap__Baidu_Map_Search_Setting__mdt SETTING = [SELECT bdmap__Authorization_Key__c, bdmap__Security_Key__c
                                                                         FROM   bdmap__Baidu_Map_Search_Setting__mdt LIMIT 1];
    
    global class SelectOption {
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String value {get; set;}
        public SelectOption(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
    @AuraEnabled(cacheable=true)
    global static List<SelectOption> getCityOptions(String province) {
        List<SelectOption> result = new List<SelectOption>();
        for(City__mdt city : [SELECT   Label, DeveloperName, bdmap__Sequence__c
                              FROM     bdmap__City__mdt
                              WHERE    bdmap__Province__c = :province
                              ORDER BY bdmap__Sequence__c]) {
            result.add(new SelectOption(city.Label, city.Label));                   
        }
        return result;
    }    

    @AuraEnabled(cacheable=true)
    global static BaiduMapEntity.MapSearchResult searchPlace(String region, String query) {
        String responseText = '';

        if(!Test.isRunningTest() &&
           (String.isBlank(SETTING.bdmap__Authorization_Key__c) || SETTING.bdmap__Authorization_Key__c.contains(' '))) {
            return new BaiduMapEntity.MapSearchResult('Invalid Baidu Map app API key');
        }
        if(!Test.isRunningTest() &&
           (String.isBlank(SETTING.bdmap__Security_Key__c) || SETTING.bdmap__Security_Key__c.contains(' '))) {
            return new BaiduMapEntity.MapSearchResult('Invalid Baidu Map app security key');
        }
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        try {
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setMethod('GET');

            String params = String.format(URL_PARAMS, 
                                          new List<Object>{EncodingUtil.urlEncode(region, 'UTF-8'),
                                                           EncodingUtil.urlEncode(query, 'UTF-8'),
                                                           SETTING.bdmap__Authorization_Key__c});
            String securityNumber = getMD5Hash(EncodingUtil.urlEncode(params + SETTING.bdmap__Security_Key__c, 'UTF-8')); 
            req.setEndPoint('callout:bdmap__Baidu_Map_Place_Search_API' + params + '&sn=' + securityNumber);

            HttpResponse res = http.send(req);
            responseText = res.getBody();
            
            //System.debug('responseText: ' + responseText);
            
        } catch(CalloutException ex) {
            System.debug('Callout error: ' + ex.getMessage());
            return new BaiduMapEntity.MapSearchResult(ex.getMessage());
        }
            
        BaiduMapEntity.MapSearchResult result = (BaiduMapEntity.MapSearchResult)JSON.deserialize(responseText, BaiduMapEntity.MapSearchResult.class);
        if(result.results.size() > 0) {
            if(result.results[0].province==null) {
                result.results = new List< BaiduMapEntity.Place>();
            }
        }

        return result;
    }

    private static String getMD5Hash(String inputString) {
		Blob requestBlob = Blob.valueOf(inputString);
		Blob hash = Crypto.generateDigest('MD5', requestBlob);
		return EncodingUtil.convertToHex(hash); 
	}

}