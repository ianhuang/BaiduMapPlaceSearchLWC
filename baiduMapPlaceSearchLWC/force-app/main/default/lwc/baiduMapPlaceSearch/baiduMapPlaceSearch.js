import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import LEAD_OBJECT from '@salesforce/schema/Lead';

import getCities from '@salesforce/apex/BaiduMapPlaceSearchController.getCityOptions';
import searchPlace from '@salesforce/apex/BaiduMapPlaceSearchController.searchPlace';

//custom labels
import title from '@salesforce/label/c.Component_Label';
import country from '@salesforce/label/c.Country_Label';
import postcode from '@salesforce/label/c.Postcode_Label';
import province from '@salesforce/label/c.Province_Label';
import city from '@salesforce/label/c.City_Label';
import district from '@salesforce/label/c.District_Country_Label';
import street from '@salesforce/label/c.Street_Label';
import phone from '@salesforce/label/c.Phone_Label';
import place from '@salesforce/label/c.Business_Name_Label';
import searchPlaceholder from '@salesforce/label/c.Search_Placeholder_Text';


const MINIMAL_SEARCH_TERM_LENGTH = 2;
const SEARCH_DELAY = 300;

export default class BaiduMapPlaceSearch extends LightningElement {

  label = {
    title,
    country,
    postcode,
    province,
    city,
    district,
    street,
    phone,
    place,
    searchPlaceholder
  }

  @api recordId;
  @api objectApiName;
  @api defaultCountry;
  @api defaultProvince;
  @api showMapLink;
  
  @api error;
  @track showInputBlock = false;
  @track loading = false;
  @track searchResults = [];
  @track placeFields = [];
  
  @track place;
  @track cities;
  
  @track selectedProvince = '';
  @track selectedCity = '';

  searchRegion = undefined;
  searchText = undefined;

  connectedCallback() {
    if(this.objectApiName==='Account') {
      this.placeFields = ['Account.Name', 'Account.Phone','Account.BillingCountry', 'Account.BillingState','Account.BillingCity','Account.BillingStreet','Account.BillingLatitude','Account.BillingLongitude'];
    }
    if(this.objectApiName==='Lead') {
      this.placeFields = ['Lead.Company', 'Lead.Phone','Lead.Country', 'Lead.State','Lead.City','Lead.Street','Lead.Latitude','Lead.Longitude'];
    }
  }

 @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
 acccountObjectInfo; 

 @wire(getObjectInfo, { objectApiName: LEAD_OBJECT })
 leadObjectInfo; 

 @wire(getRecord, {recordId: '$recordId',fields: '$placeFields'})
    wireRecord({error, data}) {
        if (data) {
            this.loadPlaceRecord(data);
            this.selectedProvince = this.place.province;
            this.selectedCity = this.place.city;
        } else {
            this.error = error;
        }
    }

  @wire(getCities, {province: '$selectedProvince' })
    wireGetCities({error, data}) {
      if (error) {
        this.error = error;
      } else if (data) {
        this.cities = data;
        if(this.selectedCity=='') {
          this.place.city= this.cities[0].value;
        }  
      }
  }  

  @wire(searchPlace, {region: '$searchRegion', query: '$searchText'})
    wireSearchPlace ({error, data}) {
      if(error) {
        this.error = error;
        this.showError(error);
      } else if(data) {
        if(data.status != 0) {
          this.showError(data.message);
        } else {  
          this.searchResults = data.results;
          if(this.searchResults.length==0) {
              this.showInfo('No results found for - ' + this.searchRegion + this.searchText);
          }
        }
      }
      this.loading = false;
    }

  get provinces() {
    return [
      { label:'北京市', value:'北京市' },
      { label:'上海市', value:'上海市' },
      { label:'天津市', value:'天津市' },
      { label:'重庆市', value:'重庆市' },
      { label:'广东省', value:'广东省' },
      { label:'江苏省', value:'江苏省' },
      { label:'浙江省', value:'浙江省' },
      { label:'河北省', value:'河北省' },
      { label:'山西省', value:'山西省' },
      { label:'内蒙古自治区', value:'内蒙古自治区' },
      { label:'宁夏自治区', value:'宁夏回族自治区' },
      { label:'陕西省', value:'陕西省' },
      { label:'甘肃省', value:'甘肃省' },
      { label:'青海省', value:'青海省' },
      { label:'新疆自治区', value:'新疆维吾尔自治区' },
      { label:'辽宁省', value:'辽宁省' },
      { label:'吉林省', value:'吉林省' },
      { label:'黑龙江省', value:'黑龙江省' },
      { label:'河南省', value:'河南省' },
      { label:'山东省', value:'山东省' },
      { label:'安徽省', value:'安徽省' },
      { label:'福建省', value:'福建省' },
      { label:'江西省', value:'江西省' },
      { label:'湖南省', value:'湖南省' },
      { label:'湖北省', value:'湖北省' },
      { label:'广西自治区', value:'广西壮族自治区' },
      { label:'海南省', value:'海南省' },
      { label:'四川省', value:'四川省' },
      { label:'贵州省', value:'贵州省' },
      { label:'云南省', value:'云南省' },
      { label:'西藏自治区', value:'西藏自治区' },
      { label:'香港', value:'香港特别行政区' },
      { label:'澳门', value:'澳门特别行政区' },
      { label:'台湾', value:'台湾省' },
    ];
  }

  get getIconName() {
    if(this.objectApiName=='Account') {
      return 'standard:account';
    } 
    if(this.objectApiName=='Lead') {
      return 'standard:lead';
    }
    return 'standard:default';
  }

  get showSearchResults() {
    return this.searchResults.length > 0;
  }

  get showNoResultsFound() {
    return this.searchResults.length == 0 && this.searchText != undefined && this.loading == false;
  }

  get disbaleRecordUpdate() {
    let result = true;

    if(this.objectApiName=='Account') {
      result = !(this.acccountObjectInfo.data.fields.BillingCountry.updateable &&
                 this.acccountObjectInfo.data.fields.Phone.updateable);
    }
    if(this.objectApiName=='Lead') {
      result = !(this.leadObjectInfo.data.fields.Company.updateable && 
                 this.leadObjectInfo.data.fields.Country.updateable &&
                 this.leadObjectInfo.data.fields.Phone.updateable);
    }
    return result;
  }

  get markerUrl() {
    return encodeURI('https://api.map.baidu.com/marker?location=' + 
                     this.place.location.lat + ',' + 
                     this.place.location.lng + '&title=百度地图地址&content=' + 
                     this.place.name + '&output=html&src=webapp.salesforcelabs.baidumapplacesearch');
  }                        
  
  get geocoderUrl() {
    return encodeURI('https://api.map.baidu.com/geocoder?address=' + 
                     this.place.fullAddress + '&output=html&src=webapp.salesforcelabs.baidumapplacesearch');
  }

  onChange(event) {
    const field = event.target.name;

    if (field === 'name') {
      this.place.name = event.target.value;
    }
    if (field === 'country') {
      this.place.country = event.target.value;
    }
    if (field === 'province') {
      this.place.province = event.target.value;
      this.selectedProvince = this.place.province;
      this.selectedCity = '';
    }
    if (field === 'city') {
      this.place.city = event.target.value;
      this.selectedCity = this.place.city;
    }
    if (field === 'postcode') {
      this.place.postcode = event.target.value;
    }
    if (field === 'address') {
      this.place.address = event.target.value;
    }
    if (field === 'phone') {
      this.place.phone = event.target.value;
    }
  }

  toggleInputBlock(){
    this.showInputBlock = !this.showInputBlock;
  }

  nameKeyPress(event){
    //Enter key is pressed, this is to reduce number of callouts
    if(event.which === 13) {
       this.loading = true;

       window.clearTimeout(this.delayTimeout);
       const searchText = event.target.value;
       if(searchText.length < MINIMAL_SEARCH_TERM_LENGTH) return;

       this.delayTimeout = setTimeout(() => {
         this.searchRegion = this.place.province + this.place.city;
         this.searchText = searchText;

       }, SEARCH_DELAY);
    }
  }

  onResultSelect(event) {
    event.preventDefault();

    let selectedItem = event.currentTarget.dataset;
    if(selectedItem) {
        let address  = selectedItem.address;
        address = address.replace(selectedItem.province.replace('特别行政区', ''), '');
        address = address.replace(selectedItem.city.replace('特别行政区', ''), '');
        if(selectedItem.area) {
          address = selectedItem.area + address;
        }

        this.place = {
          recordId:   this.recordId,
          objectName: this.objectApiName,
          name:       selectedItem.name,
          country :   this.defaultCountry,
          province:   selectedItem.province,
          city:       selectedItem.city.replace('特别行政区', ''),
          address:    address,
          telephone:  selectedItem.telephone,
          location: {
            lat: selectedItem.lat,
            lng: selectedItem.lng
          },
          fullAddress: selectedItem.province != selectedItem.city ? 
                       selectedItem.province + selectedItem.city + address :
                       selectedItem.province + address
        }

        //hide seatrch result
        this.searchText    = undefined;
        this.searchResults = [];
    }

  }

  closeSearchResult() {
    this.searchText    = undefined;    
    this.searchResults = [];
  }

  hideInputBlock() {
    this.showInputBlock = false;
  }

  saveChanges() {
    let record = this.getRecord();
    
    updateRecord(record)
        .then(() => {
            this.showSuccess(this.objectApiName + ' updated.');
            this.showInputBlock = false;
            eval("$A.get('e.force:refreshView').fire();");
        })
        .catch(error => {
            this.showError(error.message.body);
        });
  }

  loadPlaceRecord(record) {
    if(this.objectApiName==='Account') {
      this.loadAccountRecord(record);
    }
    if(this.objectApiName==='Lead') {
      this.loadLeadRecord(record);
    }
  }

  loadAccountRecord(record) {
    this.place = {recordId:   this.recordId,
                  objectName: this.objectApiName,
                  name:       record.fields.Name.value,
                  country :   record.fields.BillingCountry.value != null ? record.fields.BillingCountry.value : this.defaultCountry,
                  province:   record.fields.BillingState.value != null ? record.fields.BillingState.value : this.defaultProvince,
                  city:       record.fields.BillingCity.value,
                  address:    record.fields.BillingStreet.value,
                  telephone:  record.fields.Phone.value,
                  location: {
                    lat: record.fields.BillingLatitude.value,
                    lng: record.fields.BillingLongitude.value,
                  },
                  fullAddress: record.fields.BillingState.value + record.fields.BillingCity.value + record.fields.BillingStreet.value
                };
  }

  loadLeadRecord(record) {
    this.place = {recordId:   this.recordId,
                  objectName: this.objectApiName,
                  name:       record.fields.Company.value,
                  country :   record.fields.Country.value != null ? record.fields.Country.value : this.defaultCountry,
                  province:   record.fields.State.value != null ? record.fields.State.value : this.defaultProvince,
                  city:       record.fields.City.value,
                  address:    record.fields.Street.value,
                  telephone:  record.fields.Phone.value,
                  location: {
                    lat: record.fields.Latitude.value,
                    lng: record.fields.Longitude.value,
                  },
                  fullAddress: record.fields.State.value + record.fields.City.value + record.fields.Street.value
                };
  }

  getRecord() {
    if(this.objectApiName=='Lead') {
      return {fields: {Id:         this.recordId,
                       Company:    this.place.name,
                       State:      this.place.province,
                       City:       this.place.city,
                       Street:     this.place.address,
                       Latitude:   this.place.location.lat,
                       Longitude:  this.place.location.lng,
                       Phone:      this.place.telephone,
                       PostalCode: this.place.postcode,
                       Country:    this.place.country}};
    };
    if(this.objectApiName=='Account') {
      return  {fields: {Id:                this.recordId, 
                        Name:              this.place.name,
                        Phone:             this.place.telephone,
                        BillingState:      this.place.province,
                        BillingCity:       this.place.city,
                        BillingStreet:     this.place.address,
                        BillingLatitude:   this.place.location.lat,
                        BillingLongitude:  this.place.location.lng,
                        BillingPostalCode: this.place.postcode,
                        BillingCountry:    this.place.country}};
    }
  }

  showSuccess(message) {
    const evt = new ShowToastEvent({
        title: 'Success',
        message: message,
        variant: 'success',
    });
    this.dispatchEvent(evt);
  }

  showError(message) {
    const evt = new ShowToastEvent({
        title: 'Error',
        message: message,
        variant: 'error',
    });
    this.dispatchEvent(evt);
  }

  showInfo(message) {
    const evt = new ShowToastEvent({
        title: 'Info',
        message: message,
        variant: 'info',
    });
    this.dispatchEvent(evt);
  }

}