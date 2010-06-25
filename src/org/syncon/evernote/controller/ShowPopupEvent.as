package  org.robotlegs.popups.controller
{
	import flash.events.Event;
	
	public class ShowPopupEvent extends Event
	{
		public static const SHOW_POPUP:String = 'showPopup';
		
		public var class_ : Class; 
		public var name : String; 
		public var popup : Object; 
		public var args : Object; 
		public var fx : String = 'open';
		
		public function ShowPopupEvent(type:String, name_ : String = '',  args_ : Object = null, fx : String = 'open', class__ : Class = null , popup_ :  Object = null )
		{	
			this.class_ = class__
			this.name = name_
			this.popup = popup_
			this.fx = fx
			this.args = args_
			super(type, true);
		}
	
	}
}