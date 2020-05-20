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
@isTest
private class BaiduMapPlaceSearchControllerTest {
    
    @isTest static void testCityOptions() {
        List<BaiduMapPlaceSearchController.SelectOption> cities = BaiduMapPlaceSearchController.getCityOptions('上海市');
        System.assertEquals(1, cities.size(), 'Unexpected number of cities for Shanghai');
        cities = BaiduMapPlaceSearchController.getCityOptions('江苏省');
        System.assertEquals(13, cities.size(), 'Unexpected number of cities for Jiangsu');
    }

    @isTest static void testSearchPlaceCallout() {
        Test.setMock(HttpCalloutMock.class, new BaiduMapHttpCalloutMock());
        
        BaiduMapEntity.MapSearchResult searchResult = BaiduMapPlaceSearchController.searchPlace('上海市', '华山医院');
        
        System.debug(searchResult);
        
        System.assertEquals(0, searchResult.status, 'Unexpected status');
        System.assertEquals('ok', searchResult.message, 'Unexpected message');
        System.assert(searchResult.results.size() > 0, 'Unexpected results');

        System.assertEquals('上海市', searchResult.results[0].province, 'Unexpected provicne');
        System.assertEquals('上海市', searchResult.results[0].city, 'Unexpected city');
        System.assert(searchResult.results[0].location.lat != null, 'Unexpected location');
        System.assert(searchResult.results[0].location.lng != null, 'Unexpected location');

        System.assert(searchResult.results[0].recordId == null);
        System.assert(searchResult.results[0].objectName == null);
        System.assert(searchResult.results[0].uid != null);
        System.assert(searchResult.results[0].street_id != null);
        System.assert(searchResult.results[0].name != null);
        System.assert(searchResult.results[0].country == null);
        System.assert(searchResult.results[0].area != null);
        System.assert(searchResult.results[0].address != null);
        System.assert(searchResult.results[0].telephone != null);

    }
    
}