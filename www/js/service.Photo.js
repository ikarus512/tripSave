/* file: DateStr.js */
/*!
 * Copyright 2017 ikarus512
 * https://github.com/ikarus512/tripSave.git
 *
 * DESCRIPTION: DateStr Service
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

    .factory('Photo', ['File', function(File) {
try{
        // The width and height of the captured photo. We will set the
        // width to the value defined here, but the height will be
        // calculated based on the aspect ratio of the input stream.

//1080p: 1920 x 1080 (2Mpx)
//4Mpx?: 2560 x 1440 (3686400Mpx)
//       3840 x 2160 (8Mpx)
//       2880 x 3000
//5Mpx?:
//1600 * 1200 = 1 920 000
//2400 * 1600 = 3 840 000
        var width = 1440;//1920;//320;    // We will scale the photo width to this
        var height = 2560;     // This will be computed based on the input stream
        var imageQuality = 0.8;//0.5;

        // |streaming| indicates whether or not we're currently streaming
        // video from the camera. Obviously, we start at false.

        var streaming = false;

        // The various HTML elements we need to configure or control. These
        // will be set by the startup() function.

        // newImg = document.createElement('img');
        var video = null;
        var canvas = null;
        var photo = null;

        function startup() {
try{
            if (!streaming) {
                video = document.getElementById('video');
                canvas = document.getElementById('canvas');
                photo = document.getElementById('photo');

                navigator.mediaDevices.enumerateDevices()
                .then(function(deviceInfoArray) {
try{
                    // Get id of rear camera (on my phone it is last videoinput device)
                    var deviceId;
                    deviceInfoArray.forEach(function(deviceInfo) {
                        if (deviceInfo.kind === 'videoinput') {
                            deviceId = deviceInfo.deviceId;
                        }
                    });
                    return deviceId;
}catch(err){console.log(err);}
                })
                .then(function(deviceId){
try{
                    return navigator.mediaDevices.getUserMedia({
                        // video: true,
                        // video: { facingMode: "user" }, // front camera
                        // video: { facingMode: { exact: "environment" } }, // rear camera
                        // video: { facingMode: "environment" }, // rear camera
                        video: { deviceId: deviceId },
                        // audio: false
                    });
}catch(err){console.log(err);}
                })
                .then(function(mediaStream) {
try{
                    // var track = mediaStream.getTracks()[0];
                    // var constraints = track.getConstraints();
                    video.srcObject = mediaStream;
                    video.onloadedmetadata = function(e) {
                        video.play();
                    };
}catch(err){console.log(err);}
                })
                .catch(function(err) {
                    var msg = 'Error in getUserMedia(). ' + err.name + ':' + err.message;
                    console.log(msg);
                    alert(msg);
                });

                video.addEventListener('canplay', function(ev){
try{
                    if (!streaming) {
                        if (!height) height = video.videoHeight / (video.videoWidth/width);

                        // // Firefox currently has a bug where the height can't be read from
                        // // the video, so we will make assumptions if this happens.
                        // if (isNaN(height)) { height = width / (4/3); }

                        video.setAttribute('width', width);
                        video.setAttribute('height', height);
                        canvas.setAttribute('width', width);
                        canvas.setAttribute('height', height);
                        streaming = true;
                    }
}catch(err){console.log(err);}
                }, false);
            }
            clearphoto();
}catch(err){console.log(err);}
        } // function startup(...)

        // Fill the photo with an indication that none has been
        // captured.

        function clearphoto() {
try{
            var context = canvas.getContext('2d');
            context.fillStyle = "#AAA";
            context.fillRect(0, 0, canvas.width, canvas.height);

            var data = canvas.toDataURL('image/jpeg', imageQuality);
            photo.setAttribute('src', data);
}catch(err){console.log(err);}
        } // function clearphoto(...)

        // Capture a photo by fetching the current contents of the video
        // and drawing it into a canvas, then converting that to a PNG
        // format data URL. By drawing it on an offscreen canvas and then
        // drawing that to the screen, we can change its size and/or apply
        // other changes before drawing it.

        function takePicture(subDirName, fileName) {
try{
            var context = canvas.getContext('2d');
            if (width && height) {
                canvas.width = width;
                canvas.height = height;
                context.drawImage(video, 0, 0, width, height);

                var data = canvas.toDataURL('image/jpeg', imageQuality);
                photo.setAttribute('src', data);

                File.savePicture(subDirName, fileName, canvas, 'image/jpeg', imageQuality);

            } else {
                clearphoto();
            }
}catch(err){console.log(err);}
        } // function takePicture(...)

        return {
            startup: startup,
            clearphoto: clearphoto,
            takePicture: takePicture
        };
}catch(err){console.log(err);}
    }]); // .factory('Photo', ...

}());
