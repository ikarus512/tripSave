/* file: File.js */
/*!
 * Copyright 2017 ikarus512
 * https://github.com/ikarus512/tripSave.git
 *
 * DESCRIPTION: File Service
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

    .factory('File', [

        '$window',
        function($window) {

            var dirName = 'tripSave';

            function savePicture(subDirName, fileName, canvas, mimeType, imageQuality) {
                $window.requestFileSystem($window.LocalFileSystem.PERSISTENT,0,function(fs){
                    // alert('file system open: ' + fs.name);
                    fs.root.getDirectory(dirName, { create: true }, function (dirEntry) {
                        dirEntry.getDirectory(subDirName, { create: true }, function (dirEntry) {
                            dirEntry.getFile(fileName, { create: true, exclusive: false }, function (fileEntry) {
                                // alert("fileEntry is file?" + fileEntry.isFile.toString());
                                // alert("fileEntry.name=" + fileEntry.name);
                                // alert("fileEntry.fullPath=" + fileEntry.fullPath);
                                canvas.toBlob(function(blob) {writeFile(fileEntry, blob)}, mimeType, imageQuality);
                                // writeFile(fileEntry, null);
                            }, onFsError('getFile'));
                        }, onFsError('dirEntry.getDirectory'));
                    }, onFsError('fs.root.getDirectory'));
                }, onFsError('requestFileSystem'));

                function writeFile(fileEntry, dataObj) {
                    // Create a FileWriter object for our FileEntry (log.txt).
                    fileEntry.createWriter(function (fileWriter) {
                        fileWriter.onwriteend = function() {
                            // alert("Successful file write...");
                            // readFile(fileEntry);
                        };
                        fileWriter.onerror = function (e) {
                            alert("Failed file write: " + e.toString());
                        };
                        // If data object is not passed in,
                        // create a new Blob instead.
                        if (!dataObj) {
                            dataObj = new Blob(['some file data'], { type: 'text/plain' });
                        }
                        fileWriter.write(dataObj);
                    });
                } // function writeFile(...)
                function onFsError(errTitle) {
                    return function(err){
                        alert(errTitle + ' '+err.name+': '+err.message);
                    }
                } // function onFsError(...)
            } // function savePicture(...)

            return {
                savePicture: savePicture
            };

        }

    ]); // .factory('File', ...

}());
