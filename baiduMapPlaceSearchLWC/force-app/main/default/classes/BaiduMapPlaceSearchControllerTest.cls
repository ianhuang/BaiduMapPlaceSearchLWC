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