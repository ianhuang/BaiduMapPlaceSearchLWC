global with sharing class BaiduMapEntity {
    
    global class MapSearchResult {
        @AuraEnabled public Integer status      { get; set; }
        @AuraEnabled public String message      { get; set; }
        @AuraEnabled public List<Place> results { get; set; }

        global MapSearchResult() {
            this.status = -1;
            this.message = 'ok';
            results = new List<Place>();
        }

        global MapSearchResult(String message) {
            this.status = -1;
            this.message = message;
            results = new List<Place>();
        }
    }

    global class Location {
        @AuraEnabled public Double lat  { get; set; }
        @AuraEnabled public Double lng  { get; set; }
    }

    global class Place {
        @AuraEnabled public String recordId   { get; set; }
        @AuraEnabled public String objectName { get; set; }
        @AuraEnabled public String uid        { get; set; }
        @AuraEnabled public String street_id  { get; set; }
        @AuraEnabled public String name       { get; set; }
        @AuraEnabled public String country    { get; set; }
        @AuraEnabled public String province   { get; set; }
        @AuraEnabled public String city       { get; set; }
        @AuraEnabled public String area       { get; set; }
        @AuraEnabled public String address    { get; set; }
        @AuraEnabled public String telephone  { get; set; }
        @AuraEnabled public Location location { get; set; }
    }
}