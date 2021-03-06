/*
Copyright (c) 2020, Ian Huang

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
global class BaiduMapHttpCalloutMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        System.assertEquals('GET', request.getMethod(), 'Unexpected https request method');

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody('{"status":0,"message":"ok","results":[{"name":"复旦大学附属华山医院","location":{"lat":31.222788,"lng":121.449963},"address":"上海市静安区乌鲁木齐中路12号","province":"上海市","city":"上海市","area":"静安区","street_id":"6c2d4dc75197d2255a3ac889","telephone":"(021)52889999","detail":1,"uid":"5db9b2c7f3ed4d96c71b7555"},{"name":"复旦大学附属华山医院(西院)","location":{"lat":31.214032,"lng":121.280538},"address":"上海市闵行区金光路958号","province":"上海市","city":"上海市","area":"闵行区","street_id":"b062b6a3ad3dc7cdf7eafc36","detail":1,"uid":"b062b6a3ad3dc7cdf7eafc36"},{"name":"复旦大学附属华山医院北院","location":{"lat":31.351999,"lng":121.379857},"address":"上海市宝山区陆翔路108号","province":"上海市","city":"上海市","area":"宝山区","street_id":"2708f1414fc6b928cf06a457","telephone":"(021)66895999","detail":1,"uid":"2708f1414fc6b928cf06a457"},{"name":"复旦大学附属华山医院东院","location":{"lat":31.246063,"lng":121.602905},"address":"上海市浦东新区红枫路525号","province":"上海市","city":"上海市","area":"浦东新区","street_id":"50fb64ff37d1235ce8f853b0","telephone":"(021)50301999","detail":1,"uid":"50fb64ff37d1235ce8f853b0"},{"name":"上海市静安区中心医院","location":{"lat":31.237041,"lng":121.456124},"address":"上海市静安区西康路259号","province":"上海市","city":"上海市","area":"静安区","street_id":"5211d219434602417dc8765c","telephone":"(021)61578000","detail":1,"uid":"5211d219434602417dc8765c"},{"name":"复旦大学附属华山医院(伽马分院)","location":{"lat":31.19645,"lng":121.428518},"address":"上海市徐汇区吴中东路518号","province":"上海市","city":"上海市","area":"徐汇区","street_id":"50925c06f45e014db34c499d","detail":1,"uid":"50925c06f45e014db34c499d"},{"name":"复旦大学附属华山医院(江苏路分部)","location":{"lat":31.218477,"lng":121.43949},"address":"上海市长宁区江苏路796号","province":"上海市","city":"上海市","area":"长宁区","street_id":"3810c8798d5cd3929c09f75f","telephone":"(021)52889999","detail":1,"uid":"3810c8798d5cd3929c09f75f"},{"name":"复旦大学附属华山医院-急诊","location":{"lat":31.223123,"lng":121.449305},"address":"上海市静安区乌鲁木齐中路12号","province":"上海市","city":"上海市","area":"静安区","street_id":"f3c2373c165c572fd32dd690","telephone":"(021)52889999","detail":1,"uid":"f3c2373c165c572fd32dd690"},{"name":"复旦大学附属华山医院-0号楼","location":{"lat":31.222392,"lng":121.450415},"address":"上海市静安区乌鲁木齐中路12号复旦大学附属华山医院0号楼","province":"上海市","city":"上海市","area":"静安区","street_id":"9d78b453906628999cf779b0","telephone":"(021)52889999","detail":1,"uid":"9d78b453906628999cf779b0"},{"name":"复旦大学附属华山医院东院门诊","location":{"lat":31.245856,"lng":121.602887},"address":"上海市浦东新区红枫路525号","province":"上海市","city":"上海市","area":"浦东新区","street_id":"c52bc5f76aad05665e17c3ce","telephone":"(021)52889999","detail":1,"uid":"c52bc5f76aad05665e17c3ce"}]}');
        response.setStatusCode(200);
        return response;
    }

}
