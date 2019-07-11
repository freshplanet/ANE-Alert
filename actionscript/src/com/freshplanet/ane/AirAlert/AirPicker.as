package com.freshplanet.ane.AirAlert {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.geom.Rectangle;

	public class AirPicker extends EventDispatcher {


		private var _context:ExtensionContext = null;
		private var _frame:Rectangle = null;
		private var _items:Array = null;
		private var _doneLabel:String = null;
		private var _cancelLabel:String = null;
		private var _selectedCallback:Function;

		public function AirPicker(context:ExtensionContext, frame:Rectangle, items:Array, doneLabel:String, cancelLabel:String, selectedCallback:Function) {
			super();
			_context = context;
			_frame = frame;
			_items = items;
			_doneLabel = doneLabel;
			_cancelLabel = cancelLabel;
			_selectedCallback = selectedCallback;
			_context.addEventListener(StatusEvent.STATUS, handleStatusEvent);
		}

		public function dispose():void {

			this._context.removeEventListener(StatusEvent.STATUS, handleStatusEvent);
			_context.dispose();
			_context = null;
			_frame = null;
			_selectedCallback = null;
			_doneLabel = null;
			_cancelLabel = null;
			_items = null;
		}

		public function show():void {
			var ret:Object = _context.call("picker_show");
			if (ret is Error)
				throw ret;
		}

		public function hide():void {
			var ret:Object = _context.call("picker_hide");
			if (ret is Error)
				throw ret;
		}


		private function handleStatusEvent(event:StatusEvent):void {

			if (event.code == "PICKER_SELECTED") {
				if(_selectedCallback)
					_selectedCallback(event.level);
			}
		}

	}
}
