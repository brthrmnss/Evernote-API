package org.robotlegs.popups.view
{
	import flash.events.Event;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.popups.view.popups.popup2;
	
	public class Popup2Mediator extends Mediator
	{
		[Inject] public var popup:popup2;
		
		public function Popup2Mediator()
		{
		} 
		
		override public function onRegister():void
		{
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.SHOW_POPUP, onShowPopup );
			eventMap.mapListener(eventDispatcher, StockPricePopupEvent.HIDE_POPUP, onHidePopup);
		}
 
		private function onShowPopup(e:Event):void
		{
			this.popup.show()
		}			
		
		private function onHidePopup(e:Event):void
		{
			this.popup.hide()
		}					
		
		
	}
}