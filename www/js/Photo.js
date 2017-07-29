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

        // The width and height of the captured photo. We will set the
        // width to the value defined here, but the height will be
        // calculated based on the aspect ratio of the input stream.

        var width = 320;    // We will scale the photo width to this
        var height = 0;     // This will be computed based on the input stream
        var imageQuality = 0.5;

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
            video = document.getElementById('video');
            canvas = document.getElementById('canvas');
            photo = document.getElementById('photo');

            navigator.getMedia = ( navigator.getUserMedia ||
                       navigator.webkitGetUserMedia ||
                       navigator.mozGetUserMedia ||
                       navigator.msGetUserMedia);

            // Deprecated in MDN:
            // https://developer.mozilla.org/en/docs/Web/API/Navigator/getUserMedia
            // New version (does not work with crosswalk plugin):
            // https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia
            navigator.getMedia(
                {
                    video: true,
                    // video: { facingMode: "user" }, // front camera
                    // video: { facingMode: { exact: "environment" } }, // rear camera
                    audio: false
                },
                function(stream) {
                    if (navigator.mozGetUserMedia) {
                        video.mozSrcObject = stream;
                    } else {
                        var vendorURL = window.URL || window.webkitURL;
                        video.src = vendorURL.createObjectURL(stream);
                    }
                    video.play();
                },
                function(err) {
                    var msg = 'Error in getUserMedia(). ' +
                            err.name + ':' + err.message;
                    console.log(msg);
                    alert(msg);
                }
            );

            video.addEventListener('canplay', function(ev){
                if (!streaming) {
                    height = video.videoHeight / (video.videoWidth/width);

                    // Firefox currently has a bug where the height can't be read from
                    // the video, so we will make assumptions if this happens.

                    if (isNaN(height)) {
                        height = width / (4/3);
                    }

                    video.setAttribute('width', width);
                    video.setAttribute('height', height);
                    canvas.setAttribute('width', width);
                    canvas.setAttribute('height', height);
                    streaming = true;
                }
            }, false);

            clearphoto();
        }

        // Fill the photo with an indication that none has been
        // captured.

        function clearphoto() {
            var context = canvas.getContext('2d');
            context.fillStyle = "#AAA";
            context.fillRect(0, 0, canvas.width, canvas.height);

            var data = canvas.toDataURL('image/jpeg', imageQuality);
            photo.setAttribute('src', data);
        }

        // Capture a photo by fetching the current contents of the video
        // and drawing it into a canvas, then converting that to a PNG
        // format data URL. By drawing it on an offscreen canvas and then
        // drawing that to the screen, we can change its size and/or apply
        // other changes before drawing it.

        function takepicture(subDirName, fileName) {
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
        }

        return {
            startup: startup,
            clearphoto: clearphoto,
            takepicture: takepicture
        };

    }]); // .factory('Photo', ...

}());
