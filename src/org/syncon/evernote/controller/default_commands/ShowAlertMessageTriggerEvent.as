package org.robotlegs.popups.controller.default_commands
{
	import flash.events.Event;
	
	public class ShowAlertMessageTriggerEvent extends Event
	{
		public static const SHOW_ALERT_POPUP:String = 'showAlertPopup';
		/**
		 * The default alert popup name
		 * */
		public var popupName : String = 'popup_alert'; 
		public var windowTitle : String = '';
		public var fx : String = ''; 
		public function arrayArgs()  :   Array
		{
			return [this.message, windowTitle]
		}
		
		public var message :  String; 
		
		public function ShowAlertMessageTriggerEvent(type:String, message : String , windowTitle : String = 'Alert',  popupName_ : String = '' )
		{	
			this.message = message
			this.windowTitle = windowTitle
			this.fx = 'loadAlert'
			if ( popupName_ != '' ) 
				this.popupName = popupName_
			super(type, true);
		}
	
	}
}