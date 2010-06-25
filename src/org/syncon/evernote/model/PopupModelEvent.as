package  org.robotlegs.popups.model
{
	import flash.events.Event;
	
	public class PopupModelEvent extends Event
	{
		/**
		 * Seperate: send a string or class and returns result ...
		 * actually a command
		 * */
		public static const FOUND_POPUP:String = 'FOUND_POPUP';
		public static const MODAL_SHOW : String = 'MODAL_SHOW';
		public static const MODAL_CLOSED : String = 'MODAL_CLOSED'		;
		
		
		public var data: Object;
		
		public function PopupModelEvent(type:String, _data:Object = null)
		{
			super(type);
			data = _data;
		}
		
/*		public function get message():String
		{
			return _message;
		}*/
	
	}
}