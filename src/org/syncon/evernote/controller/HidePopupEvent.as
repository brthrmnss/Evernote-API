package  org.robotlegs.popups.controller
{
	import flash.events.Event;
	
	public class HidePopupEvent extends Event
	{
		public static const HIDE_POPUP:String = 'hidePopup';
		
		public var class_ : Class; 
		public var name : String; 
		public var popup : Object; 
		public var args : Object; 
		
		public function HidePopupEvent(type:String, name_ : String = '',  args_ : Object = null, class__ : Class = null , popup_ :  Object = null )
		{	
			this.class_ = class__
			this.name = name_
			this.popup = popup_
			this.args = args_
			super(type, true);
		}
		
	}
}