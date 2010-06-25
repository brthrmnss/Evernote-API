package  org.robotlegs.popups.controller
{
	import flash.events.Event;
	
	public class RemovePopupEvent extends Event
	{
		public static const REMOVE_POPUP:String = 'removePopup';
		
		public var class_ : Class; 
		public var name : String; 
		public var popup : Object; 
		
		public function RemovePopupEvent(type:String, name_ : String = '',  class__ : Class = null , popup_ :  Object = null )
		{	
			this.class_ = class__
			this.name = name_
			this.popup = popup_
			super(type, true);
		}
		
	}
}