package org.robotlegs.popups.controller
{
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.IPopup;
	
	import sss.Shelpers.Shelpers.ui.PopupCode;
	
	public class AddPopupFeatureCommand extends Command
	{
		[Inject] public var event:CreatePopupEvent;
		[Inject] public var popupModel:PopupModel;
		
		override public function execute():void
		{
			var popup  : IPopup   = new  event.class_()
			popup.popupCode =     PopupCode.Create(popup, contextView  ) 
			mediatorMap.createMediator(popup);
			this.popupModel.registerPopup( event.name, popup, event.modal,   event.autoCloseOthers, event.doNotAutoclose) 
			//contextView.addChild(IPopup as UIComponent);
		}
	}
}