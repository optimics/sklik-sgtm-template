___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Seznam.cz Sklik Conversion \u0026 Retargeting",
  "categories": [
    "CONVERSIONS",
    "REMARKETING"
  ],
  "brand": {
    "id": "github.com_optimics",
    "displayName": "optimics"
  },
  "description": "This sGTM template instructs browser to fire Sklik conversion or remarketing pixel.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "tagType",
    "displayName": "",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "conversion",
        "displayValue": "Conversion"
      },
      {
        "value": "retargeting",
        "displayValue": "Retargeting"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "conversionId",
    "displayName": "Conversion ID (required)",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "POSITIVE_NUMBER"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "conversion",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "conversionValue",
    "displayName": "Conversion Value",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "conversion",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "conversionOrderId",
    "displayName": "Conversion Order ID",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "conversion",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "conversionZboziType",
    "displayName": "Conversion Zboží Type",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "conversionZbozi",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "conversionZboziId",
    "displayName": "Conversion Zboží ID",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "conversionZbozi",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "retargetingId",
    "displayName": "Retargeting ID (required)",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "retargeting",
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "POSITIVE_NUMBER"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "retargetingItemId",
    "displayName": "Item ID",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "retargeting",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "retargetingPageType",
    "displayName": "Page Type",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "retargeting",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "retargetingCategory",
    "displayName": "Category",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "retargeting",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "tagConsent",
    "displayName": "Marketing Consent (granted or denied)",
    "macrosInSelect": true,
    "selectItems": [
      {
        "value": "inherit",
        "displayValue": "Inherit from Consent Mode"
      },
      {
        "value": "granted",
        "displayValue": "True"
      },
      {
        "value": "denied",
        "displayValue": "False"
      }
    ],
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "(inherit|granted|denied)"
        ],
        "errorMessage": "Value must be granted or denied."
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "retargetingUrl",
    "displayName": "Retargeting URL",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "tagType",
        "paramValue": "retargeting",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

/*
  Server-Side GTM Template for Seznam.cz Sklik
  Written by Jakub Kriz and Viet An Chu
  https://optimics.cz
*/

// template APIs
const log = require('logToConsole');
const getRequestHeader = require('getRequestHeader');
const getEventData = require('getEventData');
const sendPixelFromBrowser = require('sendPixelFromBrowser');

// get event data
const pageReferrer = getEventData('page_referrer');
const consentState = getEventData('x-ga-gcs');

// template inputs for conversion
const conversionId = data.conversionId;
const conversionValue = data.conversionValue;
const conversionOrderId = data.conversionOrderId;
const conversionZboziId = data.conversionZboziId;
const conversionZboziType = data.conversionZboziType;

// template inputs for retargeting
const retargetingId = data.retargetingId;
const retargetingItemId = data.retargetingItemId;
const retargetingPageType = data.retargetingPageType;
const retargetingCategory = data.retargetingCategory;
const retargetingUrl = data.retargetingUrl;

// template inputs for tag
const tagType = data.tagType;
const tagConsent = data.tagConsent;

// start logging
log('Sklik template start');
log('tagType: ' + tagType);

// prepare destination array
let destinationUrlArr = [];

if(tagType==='conversion'){
  // log debugging info
  log('conversionId: ' + conversionId);
  log('conversionValue: ' + conversionValue);
  log('conversionOrderId: ' + conversionOrderId);
  // log('conversionZboziId: ' + conversionZboziId);
  // log('conversionZboziType: ' + conversionZboziType);
  // set base url and required conversion id
  destinationUrlArr.push('https://c.seznam.cz/conv?id=' + conversionId);
  // add optional conversion value
  if(conversionValue) {destinationUrlArr.push('value='+conversionValue);}
  // add optional orderId 
  if(conversionOrderId) {destinationUrlArr.push('orderId='+conversionOrderId);}
  // add optional zboziId
  // if(conversionZboziId) {destinationUrlArr.push('zboziId='+conversionZboziId);}
  // add optional zboziType
  // if(conversionZboziType) {destinationUrlArr.push('zboziType='+conversionZboziType);}
  
} else if(tagType==='retargeting'){
  // log debugging info
  log('retargetingId: ' + retargetingId);
  log('retargetingItemId: ' + retargetingItemId);
  log('retargetingPageType: ' + retargetingPageType);
  log('retargetingCategory: ' + retargetingCategory);
  log('retargetingUrl: ' + retargetingUrl);
  // set base url and required retargeting id
  destinationUrlArr.push('https://c.seznam.cz/retargeting?id=' + retargetingId);
  // add optional retargeting itemId
  if(retargetingItemId) {destinationUrlArr.push('itemId='+retargetingItemId);}
  // add optional ratergeting pageType
  if(retargetingPageType) {destinationUrlArr.push('pageType='+retargetingPageType);}
  // add optional ratergeting category
  if(retargetingCategory) {destinationUrlArr.push('category='+retargetingCategory);}
  // add optional ratergeting url
  if(retargetingUrl) {destinationUrlArr.push('rtgUrl='+retargetingUrl);}
}

// add required source URL
destinationUrlArr.push('url=' + pageReferrer);

// add required consent flag
let consentSklikValue = '-1';
if(tagConsent==='inherit') {
  if(consentState) {
    if(consentState.charAt(2) === '1') {
     consentSklikValue = '1';
    }
    else if(consentState.charAt(2) === '0') {
     consentSklikValue = '0';
    }
  }
} else if(tagConsent==='granted') {
  consentSklikValue = '1';
} else if(tagConsent==='denied') {
  consentSklikValue = '0';
}

log('tagConsent: ' + tagConsent + ' - set to value:' + consentSklikValue);

destinationUrlArr.push('consent='+consentSklikValue);

// log final message to seznam.cz server
log(destinationUrlArr.join('&'));

// send pixel back to browser to sustain 3rd party cookies and IP address
sendPixelFromBrowser(destinationUrlArr.join('&'));

log('Sklik template end');
// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "referer"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "host"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_pixel_from_browser",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://c.seznam.cz/"
              }
            ]
          }
        },
        {
          "key": "allowGoogleDomains",
          "value": {
            "type": 8,
            "boolean": true
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 12/9/2024, 5:40:03 PM


