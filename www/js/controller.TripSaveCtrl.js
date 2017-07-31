/* file: TripSaveCtrl.js */
/*!
 * Copyright 2017 ikarus512
 * https://github.com/ikarus512/tripSave.git
 *
 * DESCRIPTION: TripSaveCtrl
 * AUTHOR: ikarus512
 * CREATED: 2017/07/20
 *
 * MODIFICATION HISTORY
 *  2017/07/20, ikarus512. Initial version.
 *
 */

(function() {
    'use strict';

    angular.module('app.controllers')

    .controller('TripSaveCtrl', [
        '$scope', 'DateStr', 'Photo', 'File', 'Gps',
        function TripSaveCtrl($scope, DateStr, Photo, File, Gps) {

try{
            $scope.points = [];
            $scope.numPoints = 0;
            $scope.trackStart = trackStart;
            $scope.trackFinish = trackFinish;

            var
                subDirName = DateStr.yyyymmdd(),
                // kmlFileName = DateStr.yyyymmddHhmmssMms(),
                photoFileName,
                trackStarted = false;

            function trackStart() {
try{
                if (trackStarted) { return; }
                trackStarted = true;
                Photo.startup();
                Gps.startup();
                (function poll() {
try{
                    takePhoto();
                    if (trackStarted) { setTimeout(poll, 5000); }
}catch(err){console.log(err);}
                })();
}catch(err){console.log(err);}
            } // function trackStart(...)

            function trackFinish() {
                trackStarted = false;
                Gps.finish();
            } // function trackFinish(...)

            function takePhoto() {
try{
                if (trackStarted) {

                    photoFileName = DateStr.yyyymmddHhmmssMms() + '.jpg';

                    Gps.takePosition(subDirName, photoFileName, function(pos) {
try{
                        Photo.takePicture(subDirName, photoFileName); // take picture and save to file
                        $scope.points.push(pos);
                        if ($scope.points.length > 5) { $scope.points.shift(); }
                        $scope.numPoints++;
                        $scope.$digest();
                        // $scope.$apply(); // calls $rootScope.$digest()
                        // $scope.$apply(func); // calls $rootScope.$digest() and handles exc. to $exceptionHandler
                        // $timeout(...) does all
}catch(err){console.log(err);}
                    });

                }
}catch(err){console.log(err);}
            } // function takePhoto(...)
}catch(err){console.log(err);}

        } // function TripSaveCtrl(...)
    ]); // .controller('TripSaveCtrl', ...

}());

// Short kml file example:
//  <kml xmlns="http://earth.google.com/kml/2.0"><Placemark><name>Track 6</name><coordinates>
//  43.9197366,56.2932416,0 43.9197366,56.29325,0 43.9197616,56.2932016,0 43.9197533,56.2933,0
//  </coordinates></Placemark></kml>
