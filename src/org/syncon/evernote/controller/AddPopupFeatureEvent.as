package  org.robotlegs.popups.controller
{
	import flash.events.Event;
	
	public class AddPopupFeatureEvent extends Event
	{
		/**
		 * If a popup named after this is already opened, bring it in front of the modal
		 * */
		public static const REGISTER_FORWARING_RULE:String = 'REGISTER_FORWARING_RULE';
		/**
		 * If this popup is ever open, always put it in front of the background
		 * */
		public static const ALWAYS_BRING_TO_FRONT:String = 'ALWAYS_BRING_TO_FRONT';		
		
		public var class_ : Object; 
		public var name : String = ''; 
		public var modal : Boolean = true		
		public var autoCloseOthers : Boolean = false
		public var doNotAutoclose : Boolean = false; 
		/**
		 * 
		 * @param type
		 * @param class__
		 * @param name - name to refer to this popup
		 * @param automatic
		 * 
		 */
		public function AddPopupFeatureEvent(type:String, class__ : Class,  name  :  String = '', modal_ : Boolean = true, 
										 	closeOtherPopupsWhenOpened : Boolean = false, doNotAutomaticallyCloseThisPopup : Boolean = false  )
		{	
			this.class_ = class__
			this.name = name; 
			this.modal = modal_
			this.autoCloseOthers = closeOtherPopupsWhenOpened
			this.doNotAutoclose  = doNotAutomaticallyCloseThisPopup
			super(type, true);
		}
		
		private var x : int = 0
			private var y : int = 0; 
			private var lbl : String = ''; 
		
	/*	static public function CreatePopupEvent2(type:String, lbl :  String, x : int, y : int ) :  Event 
		{	
			var e : StockPricePopupEvent = new StockPricePopupEvent( type ) 
			e.lbl = lbl
			e.x = x
			e.y = y
			return e
		}		*/
	
	}
}