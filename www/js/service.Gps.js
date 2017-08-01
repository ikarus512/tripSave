/* file: Gps.js */
/*!
 * Copyright 2017 ikarus512
 * https://github.com/ikarus512/tripSave.git
 *
 * DESCRIPTION: Gps Service
 * AUTHOR: ikarus512
 * CREATED: 2017/07/20
 *
 * MODIFICATION HISTORY
 *  2017/07/20, ikarus512. Initial version.
 *
 */

(function() {
    'use strict';

    angular.module('app.services')

    .factory('Gps', [

        'File', // '$cordovaGeolocation',

        function gpsFactory(File) {

            var watchId;

            function startup() {
try{
                var positionOptions = {
                    // enableHighAccuracy: false,
                    // timeout: 5*1000, // callback timeout (ms)
                    // maximumAge: 0
                };
                if (watchId) navigator.geolocation.clearWatch(watchId);
                watchId = navigator.geolocation.watchPosition(function gpsSuccess(position) {
                    // navigator.geolocation.clearWatch(watchId);
                }, function gpsError(err) {
                    console.log('Gps.startup() --> gpsError(): ', err);
                    // alert(err.message);
                }, positionOptions);
}catch(err){console.log(err);}
            } // function startup(...)

            function finish() {
try{
                navigator.geolocation.clearWatch(watchId);
                watchId = undefined;
}catch(err){console.log(err);}
            } // function finish(...)

            function takePosition(subDirName, photoFileName, callback) {
try{
                var positionOptions = {
                    // enableHighAccuracy: false,
                    timeout: 3000, // callback timeout (ms)
                    // maximumAge: 0
                };
                navigator.geolocation.getCurrentPosition(function gpsSuccess(position) {
try{
                    var pos = {
                        lat: Math.floor(position.coords.latitude*10000000)/10000000,
                        lng: Math.floor(position.coords.longitude*10000000)/10000000,
                        str: '' +
                            'alt:' + Math.floor(position.coords.altitude*100)/100 + // m
                            ',acc:' + Math.floor(position.coords.accuracy*100)/100 + // m
                            // ',altAcc:' + position.coords.altitudeAccuracy + // m
                            ',heading:' + Math.floor(position.coords.heading) + // deg
                            ',speed:' + Math.floor(position.coords.speed*3.6), // kph
                        photoUrl: subDirName + '/' + photoFileName,
                        subDirName: subDirName,
                        photoFileName: photoFileName
                    };
                    pos.htm = '<p> lng=' + pos.lng + ' lat=' + pos.lat + ' ' + pos.str +
                        '<br/><img src="' + pos.photoUrl + '"  width="400px">';
                    pos.kml = pos.lng + ',' + pos.lat + ',0 ';

                    if (callback) {
                        callback(pos);
                    }

                    File.savePosition(pos);
}catch(err){console.log(err);}
                }, function gpsError(err) {
                    console.log('Gps.takePosition() --> gpsError(): ', err);
                    // alert(err.message);
                }, positionOptions);
}catch(err){console.log(err);}
            } // function takePosition(...)

            return {
                startup: startup,
                finish: finish,
                takePosition: takePosition
            };

        } // function gpsFactory(...)

    ]); // .factory('Gps', ...

}());
