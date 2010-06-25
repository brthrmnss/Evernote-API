package org.robotlegs.popups.view
{
	import flash.events.Event;
	
	public class StockPricePopupEvent extends Event
	{
		public static const CREATE_POPUP:String = 'createstockPopup';
		public static const SHOW_POPUP:String = 'showpopup_stock';
		public static const HIDE_POPUP:String = 'hidepopup_stock';		
		
		public var data : Object; 
		
		public function StockPricePopupEvent(type:String, data_ : Object = null, target :  Object = null, automatic : Boolean = false )
		{	
			this.data = data_
			super(type, true);
		}
		
		private var x : int = 0
			private var y : int = 0; 
			private var lbl : String = ''; 
		
		static public function StockPricePopupEvent2(type:String, lbl :  String, x : int, y : int ) :  Event 
		{	
			var e : StockPricePopupEvent = new StockPricePopupEvent( type ) 
			e.lbl = lbl
			e.x = x
			e.y = y
			return e
		}		
	
	}
}