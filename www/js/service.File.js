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

            var rootDirName = 'tripSave';

            function savePicture(subDirName, fileName, canvas, mimeType, imageQuality) {
try{
                $window.requestFileSystem($window.LocalFileSystem.PERSISTENT, 0, function(fs){
try{
                    // alert('file system open: ' + fs.name);
                    fs.root.getDirectory(rootDirName, { create: true }, function (dirEntry) {
try{
                        dirEntry.getDirectory(subDirName, { create: true }, function (dirEntry) {
try{
                            dirEntry.getFile(fileName, { create: true, exclusive: false }, function (fileEntry) {
try{
                                canvas.toBlob(function(blob) {
try{
                                    writePictireFile(fileEntry, blob);
}catch(err){console.log(err);}
                                }, mimeType, imageQuality);
}catch(err){console.log(err);}
                            }, onFsError('getFile'));
}catch(err){console.log(err);}
                        }, onFsError('dirEntry.getDirectory'));
}catch(err){console.log(err);}
                    }, onFsError('fs.root.getDirectory'));
}catch(err){console.log(err);}
                }, onFsError('requestFileSystem'));
}catch(err){console.log(err);}

                function writePictireFile(fileEntry, dataObj) {
try{
                    fileEntry.createWriter(function (fileWriter) {
try{
                        fileWriter.onerror = function (err) {
                            console.log('File.savePicture() --> writePictireFile(): ', err);
                            // alert("Failed file write: " + err.toString());
                        };
                        // If data object is not passed in,
                        // create a new Blob instead.
                        if (!dataObj) {
                            dataObj = new Blob(['some file data'], { type: 'text/plain' });
                        }
                        fileWriter.write(dataObj);
}catch(err){console.log(err);}
                    });
}catch(err){console.log(err);}
                } // function writePictireFile(...)

            } // function savePicture(...)


            // TODO: save gps coords + photo ref to htm file and kml
            function savePosition(pos) {
try{
                var htmFileName = pos.subDirName + '.htm',
                    kmlFileName = pos.subDirName + '.kml',
                    isAppend = true;

                // 1) save to htm file
                $window.requestFileSystem($window.LocalFileSystem.PERSISTENT, 0, function(fs){
try{
                    // alert('file system open: ' + fs.name);
                    fs.root.getDirectory(rootDirName, { create: true }, function (dirEntry) {
try{
                        dirEntry.getFile(htmFileName, { create: true, exclusive: false }, function (fileEntry) {
try{
                            writePositionFile(fileEntry, pos.htm, isAppend);
}catch(err){console.log(err);}
                        }, onFsError('getFile'));
}catch(err){console.log(err);}
                    }, onFsError('fs.root.getDirectory'));
}catch(err){console.log(err);}
                }, onFsError('requestFileSystem'));

                // 2) save to kml file
                $window.requestFileSystem($window.LocalFileSystem.PERSISTENT, 0, function(fs){
try{
                    // alert('file system open: ' + fs.name);
                    fs.root.getDirectory(rootDirName, { create: true }, function (dirEntry) {
try{
                        dirEntry.getFile(kmlFileName, { create: true, exclusive: false }, function (fileEntry) {
try{
                            writePositionFile(fileEntry, pos.kml, isAppend);
}catch(err){console.log(err);}
                        }, onFsError('getFile'));
}catch(err){console.log(err);}
                    }, onFsError('fs.root.getDirectory'));
}catch(err){console.log(err);}
                }, onFsError('requestFileSystem'));
}catch(err){console.log(err);}

                function writePositionFile(fileEntry, text, isAppend) {
try{
                    fileEntry.createWriter(function (fileWriter) {
try{
                        fileWriter.onerror = function (err) {
                            console.log('File.savePosition() --> writePositionFile(): ', err);
                            // alert("Failed file write: " + err.toString());
                        };
                        var dataObj = new Blob([text], { type: 'text/plain' });
                        if (isAppend) {
                            try {
                                fileWriter.seek(fileWriter.length);
                            }
                            catch (err) {
                                console.log(err);
                                console.log('File.savePosition() --> writePositionFile(',fileEntry, text, isAppend,'): file doesn\'t exist!', err);
                            }
                        }
                        fileWriter.write(dataObj);
}catch(err){console.log(err);}
                    });
}catch(err){console.log(err);}
                } // function writePositionFile(...)

            } // function savePosition(...)

            function onFsError(errTitle) {
                return function(err){
                    console.log('File --> onFsError('+errTitle+'): ', err);
                    // alert(errTitle + ' '+err.name+': '+err.message);
                }
            } // function onFsError(...)

            return {
                savePicture: savePicture,
                savePosition: savePosition
            };

        }

    ]); // .factory('File', ...

}());
