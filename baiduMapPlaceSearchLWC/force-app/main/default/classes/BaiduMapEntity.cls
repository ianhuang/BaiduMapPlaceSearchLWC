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