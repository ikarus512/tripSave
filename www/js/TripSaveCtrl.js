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
        '$scope', 'DateStr', 'Photo',
        function($scope, DateStr, Photo) {
        $scope.photos = [{url:'dummy item'}];
        $scope.takePhoto = takePhoto;

        var subDirName = DateStr.yyyymmdd();
        var fileName = DateStr.yyyymmddHhmmssMms() + '.jpg';

        function takePhoto() { Photo.takepicture(subDirName, fileName); }

        Photo.startup();

    }]);

}());
