package org.robotlegs.popups.controller
{
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.stockprice_popup;
	
	import sss.Shelpers.Shelpers.ui.PopupCode;
	
	public class CreateStockPricePopupCommand extends Command
	{
		//[Inject] public var event:SystemEvent;
		
		[Inject] public var popupModel:PopupModel;
		
		override public function execute():void
		{
			//contextView.addChild(new LoginPage());
			/*var eee  :    stockprice_popup = new stockprice_popup()
			eee.popupCode =     PopupCode.Create(eee, contextView  ) 
			mediatorMap.createMediator(stockprice_popup);*/
			//return eee			
		}
	}
}