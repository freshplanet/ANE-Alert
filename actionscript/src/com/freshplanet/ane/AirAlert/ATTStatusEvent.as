package com.freshplanet.ane.AirAlert {
	import flash.events.Event;

	public class ATTStatusEvent extends Event {

		public static const ATT_STATUS_RECEIVED:String = "ATTStatus";

		public static const STATUS_AUTHORIZED:String = "ATTrackingManagerAuthorizationStatusAuthorized";
		public static const STATUS_DENIED:String = "ATTrackingManagerAuthorizationStatusDenied";
		public static const STATUS_RESTRICTED:String = "ATTrackingManagerAuthorizationStatusRestricted";
		public static const STATUS_NOT_DETERMINED:String = "ATTrackingManagerAuthorizationStatusNotDetermined";
		public static const STATUS_NOT_SUPPORTED:String = "ATTrackingManagerAuthorizationStatusNotSupported";

		private var _status:String;

		public function ATTStatusEvent(type:String, status:String) {
			super(type);
			_status = status;
		}

		public function get status():String {
			return _status;
		}
	}
}
