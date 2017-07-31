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

    .factory('DateStr',

      function () {

        function yyyymmdd() {
try{
            var
                date = new Date(),
                d = date.getDate(),
                m = date.getMonth() + 1, // getMonth() is zero-based
                y = date.getFullYear(),
                n = y*100*100 + m*100 + d,
                s = n.toString();

            return s;
}catch(err){console.log(err);}
        } // function yyyymmdd(...)

        function yyyymmddHhmmssMms() {
try{
            var
                date = new Date(),
                d = date.getDate(),
                m = date.getMonth() + 1, // getMonth() is zero-based
                y = date.getFullYear(),
                n1 = y*100*100 + m*100 + d,
                s1 = n1.toString(),

                h = date.getHours(),
                min = date.getMinutes(),
                sec = date.getSeconds(),
                n2 = 100*100*100 + h*100*100 + min*100 + sec,
                s2 = n2.toString().substr(1, 6),

                ms = date.getMilliseconds(),
                n3 = 1000 + ms,
                s3 = n3.toString().substr(1, 3),

                res = s1 + '-' + s2 + '-' + s3;

            return res;
}catch(err){console.log(err);}
        } // function yyyymmddHhmmssMms(...)

        return {
            yyyymmdd: yyyymmdd,
            yyyymmddHhmmssMms: yyyymmddHhmmssMms
        };

    }

    ); // .factory('DateStr', ...

}());
