package  org.robotlegs.popups.controller
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.robotlegs.core.IMediatorMap;
	
	
	public class CreatePopupEvent extends Event
	{
		public static const REGISTER_AND_CREATE_POPUP:String = 'REGISTER_AND_CREATE_POPUP';
		public static const REGISTER_POPUP:String = 'REGISTER_POPUP';		
		
		
		public var contextView_  : DisplayObjectContainer
		public var mediatorMap_ :  IMediatorMap; 
		
		public var class_ : Object; 
		public var name : String = ''; 
		public var modal : Boolean = true		
		public var autoCloseOthers : Boolean = false
		public var doNotAutoclose : Boolean = false; 
		
		/**
		 * Specifies different parent context other than contextView, 
		 * */
		public var addToParent : Object;
		/**
		 * Specifies whether to add popup as child of parent, or 
		 * to the popupManager
		 * */
		public var addAsPopup : Boolean = true;
		
		/**
		 * 
		 * @param type
		 * @param class__
		 * @param name - name to refer to this popup
		 * @param automatic
		 * 
		 */
		public function CreatePopupEvent(type:String, class__ : Class,  name  :  String = '', modal_ : Boolean = true, 
										 	closeOtherPopupsWhenOpened : Boolean = false, doNotAutomaticallyCloseThisPopup : Boolean = false,
											addToParent_ : Object = null, addAsPopup_  : Boolean = true)
		{	
			this.class_ = class__
			this.name = name; 
			this.modal = modal_
			this.autoCloseOthers = closeOtherPopupsWhenOpened
			this.doNotAutoclose  = doNotAutomaticallyCloseThisPopup
			this.addToParent = addToParent_
			this.addAsPopup  = addAsPopup_				
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