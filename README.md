Air Native Extension for Native Alerts (iOS + Android)
======================================

This is an [Air native extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) for displaying native alerts on iOS and Android. It has been developed by [FreshPlanet](http://freshplanet.com).


Installation
---------

The ANE binary (AirAlert.ane) is located in the *bin* folder. You should add it to your application project's Build Path and make sure to package it with your app (more information [here](http://help.adobe.com/en_US/air/build/WS597e5dadb9cc1e0253f7d2fc1311b491071-8000.html)).


Usage
-----

This ANE currently supports displaying an alert popup with:
* a title
* a message
* one or two buttons
    
    ```actionscript
    // Defining your callbacks
    var myCallback1:Function = function():void { trace("Callback 1"); };
    var myCallback2:Function = function():void { trace("Callback 2"); };

    // Display a one-button alert popup
    AirAlert.instance.showAlert("My title", "My message", "OK", myCallback1);

    // Display a two-button alert popup
    AirAlert.instance.showAlert("My title", "My message", "YES", myCallback1, "NO", myCallback2);
    ```

Notes:
* the theme used on Android is *AlertDialog.THEME_DEVICE_DEFAULT_DARK* on Android 4.x, *AlertDialog.THEME_HOLO_DARK* on Android 3.x and no theme on Android 2.x (cf. http://developer.android.com/reference/android/app/AlertDialog.html)
* included binary has been compiled for 64-bit iOS support


Build script
---------

Should you need to edit the extension source code and/or recompile it, you will find an ant build script (build.xml) in the *build* folder:

    cd /path/to/the/ane/build
    mv example.build.config build.config
    #edit the build.config file to provide your machine-specific paths
    ant


Authors
------

This ANE has been written by [Alexis Taugeron](http://alexistaugeron.com) and [Mateo Kozomara](mateo.kozomara@gmail.com). It belongs to [FreshPlanet Inc.](http://freshplanet.com) and is distributed under the [Apache Licence, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).


Join the FreshPlanet team - GAME DEVELOPMENT in NYC
------

We are expanding our mobile engineering teams.

FreshPlanet is a NYC based mobile game development firm and we are looking for senior engineers to lead the development initiatives for one or more of our games/apps. We work in small teams (6-9) who have total product control.  These teams consist of mobile engineers, UI/UX designers and product experts.


Please contact Tom Cassidy (tcassidy@freshplanet.com) or apply at http://freshplanet.com/jobs/
