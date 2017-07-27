angular.module('starter.controllers', [])

.controller('AppCtrl', function($scope, $ionicModal, $timeout) {

  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:
  //$scope.$on('$ionicView.enter', function(e) {
  //});

  // Form data for the login modal
  $scope.loginData = {};

  // Create the login modal that we will use later
  $ionicModal.fromTemplateUrl('templates/login.html', {
    scope: $scope
  }).then(function(modal) {
    $scope.modal = modal;
  });

  // Triggered in the login modal to close it
  $scope.closeLogin = function() {
    $scope.modal.hide();
  };

  // Open the login modal
  $scope.login = function() {
    $scope.modal.show();
  };

  // Perform the login action when the user submits the login form
  $scope.doLogin = function() {
    console.log('Doing login', $scope.loginData);

    // Simulate a login delay. Remove this and replace with your login
    // code if using a login system
    $timeout(function() {
      $scope.closeLogin();
    }, 1000);
  };
})

.controller('PlaylistsCtrl', function($scope) {
  $scope.playlists = [
    { title: 'Reggae', id: 1 },
    { title: 'Chill', id: 2 },
    { title: 'Dubstep', id: 3 },
    { title: 'Indie', id: 4 },
    { title: 'Rap', id: 5 },
    { title: 'Cowbell', id: 6 }
  ];
})

.controller('PlaylistCtrl', function($scope, $stateParams) {
})

.controller('TripSaveCtrl', function($scope) {
    $scope.photos = [{url:'dummy item'}];
    $scope.takePhoto = takePhoto;

    function takePhoto() {

        openCamera();

        function setOptions(srcType) {
            var options = {
                // Some common settings are 20, 50, and 100
                quality: 50,
                destinationType: Camera.DestinationType.FILE_URI,
                // In this app, dynamically set the picture source, Camera or photo gallery
                sourceType: srcType,
                encodingType: Camera.EncodingType.JPEG,
                mediaType: Camera.MediaType.PICTURE,
                allowEdit: true,
                correctOrientation: true  //Corrects Android orientation quirks
            }
            return options;
        }

        function openCamera(selection) {

            var srcType = Camera.PictureSourceType.CAMERA;
            var options = setOptions(srcType);

            navigator.camera.getPicture(function cameraSuccess(imageUri) {

                displayImage(imageUri);

                // You may choose to copy the picture, save it somewhere, or upload.
                // createNewFileEntry(imageUri);

            }, function cameraError(error) {
                console.debug("Unable to obtain picture: " + error, "app");
                alert("Unable to obtain picture: " + error, "app")

            }, options);
        }

        function displayImage(imgUri) {
            $scope.photos.push({url:imgUri});
        }

        // function createNewFileEntry(imgUri) {
        //     window.resolveLocalFileSystemURL(cordova.file.cacheDirectory, function success(dirEntry) {

        //         // JPEG file
        //         dirEntry.getFile("tempFile.jpeg", { create: true, exclusive: false }, function (fileEntry) {

        //             // Do something with it, like write to it, upload it, etc.
        //             // writeFile(fileEntry, imgUri);
        //             console.log("got file: " + fileEntry.fullPath);
        //             // displayFileData(fileEntry.fullPath, "File copied to");

        //         }, onErrorCreateFile);

        //     }, onErrorResolveUrl);
        // }

    }
});
