# logging_plugin

Generic Logging Plugin to log events to a url in json format

## Getting Started

on android you must set compileSdkVersion to 31
Add the following to your "gradle.properties" file:
android.useAndroidX=true
android.enableJetifier=true

Android permissions:
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

IOS permissions:
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>

event body JSON format:
{
locationData:{
    longitude:double
    latitude:double
    timestamp:String in UTC Iso8061 format
},
deviceData:{
    platform:String
    model:String(user agent in web)
    osVersion:String
    manufacturer:String(vendor in web)
},
timeData:{
    timeIso8601:String in UTC Iso8061 format
    timeMsEpoch:Int (milliseconds since epoch)
    timezone:String
},
eventType:String (what event type: error, creation, new page),
eventDescription:String
eventParam:String (json string for event unique parameters, may be null)
}