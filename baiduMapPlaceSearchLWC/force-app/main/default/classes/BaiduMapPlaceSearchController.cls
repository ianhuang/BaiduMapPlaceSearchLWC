/*
Copyright (c) 2020, Salesforce Labs

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of BaiduMapPlaceSearchLWC nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
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