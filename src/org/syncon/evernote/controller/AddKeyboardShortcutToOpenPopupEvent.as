package  org.robotlegs.popups.controller
{
	import flash.events.Event;
	
	public class AddKeyboardShortcutToOpenPopupEvent extends Event
	{
		/**
		 * If a popup named after this is already opened, bring it in front of the modal
		 * */
		static public var ADD_KEYBOARD_SHORTCUTS  : String = 'ADD_KEYBOARD_SHORTCUT';
		static public var ENABLE_KEYBOARD_SHORTCUTS  : String = 'ENABLE_KEYBOARD_SHORTCUTS';
			 
		
		public var class_ : Class; 
		public var name : String = ''; 
		public var popup : Object ; 
		public var keyToOpen : Number;
		public var ctrlKey : Boolean = false; 
		public var altKey : Boolean = false; 
	
		/**
		 * 
		 * @param type
		 * @param class__
		 * @param name - name to refer to this popup
		 * @param automatic
		 * 
		 */
		public function AddKeyboardShortcutToOpenPopupEvent(type:String,  name  :  String='' , keyToOpen_ : Number=0, ctrlKey_ : Boolean = true, 
												 altKey_ : Boolean=false, popup_ : Object  = null,  class__: Class=null    )
		{	
			this.class_ = class__
			this.name = name; 
			this.popup = popup_
			this.keyToOpen = keyToOpen_
			this.ctrlKey = ctrlKey_
			this.altKey = altKey_				
			super(type, true);
		}
	}
}