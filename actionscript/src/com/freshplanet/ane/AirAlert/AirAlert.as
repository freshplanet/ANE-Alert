/*
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.freshplanet.ane.AirAlert {
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	public class AirAlert extends EventDispatcher {
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		/** AirAlert is supported on iOS and Android devices. */
		public static function get isSupported() : Boolean {
			return isAndroid || isIOS;
		}

		/**
		 * AirAlert instance
		 * @return AirAlert instance
		 */
		public static function get instance() : AirAlert {
			return _instance ? _instance : new AirAlert();
		}

		/**
		 * Show alert
		 * @param title Alert title
		 * @param message Alert message
		 * @param button1 First button title
		 * @param callback1 First button callback
		 * @param button2 Second button title (optional)
		 * @param callback2 Second button callback (optional)
		 */
		public function showAlert( title : String, message : String, button1 : String = "OK", callback1 : Function = null, button2 : String = null, callback2 : Function = null ) : void {
			if (!isSupported) return;
			
			_callback1 = callback1;
			_callback2 = callback2;
			
			if (button2 == null) _context.call("showAlert", title, message, button1);
			else _context.call("showAlert", title, message, button1, button2);
		}
		
		
		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//
		
		private static const EXTENSION_ID : String = "com.freshplanet.ane.AirAlert";
		
		private static var _instance : AirAlert = null;
		private var _context : ExtensionContext = null;
		
		private var _callback1 : Function = null;
		private var _callback2 : Function = null;

		/**
		 * "private" singleton constructor
		 */
		public function AirAlert() {
			if (!_instance) {
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				if (!_context) {
					throw Error("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
					return;
				}
				_context.addEventListener(StatusEvent.STATUS, onStatus);

				_instance = this;
			}
			else {
				throw Error("This is a singleton, use getInstance(), do not call the constructor directly.");
			}
		}
		
		private function onStatus( event : StatusEvent ) : void {
			if (event.code == "CLICK") {
				var callback:Function = null;
				
				if (event.level == "0") callback = _callback1;
				else if (event.level == "1") callback = _callback2;
				
				_callback1 = null;
				_callback2 = null;
				
				if (callback != null) callback();
			}
		}

		private static function get isIOS():Boolean {
			return Capabilities.manufacturer.indexOf("iOS") > -1 && Capabilities.os.indexOf("x86_64") < 0 && Capabilities.os.indexOf("i386") < 0;
		}

		private static function get isAndroid():Boolean {
			return Capabilities.manufacturer.indexOf("Android") > -1;
		}
	}


}