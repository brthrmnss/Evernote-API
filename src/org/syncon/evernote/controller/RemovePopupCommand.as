package org.robotlegs.popups.controller
{
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.IPopup;
	
	import sss.Shelpers.Shelpers.ui.PopupCode;
	
	public class RemovePopupCommand extends Command
	{
		[Inject] public var event:RemovePopupEvent;
		[Inject] public var popupModel:PopupModel;
		
		override public function execute():void
		{
			var popup : IPopup = this.popupModel.removePopup( event.name, event.class_, event.popup ) 
			popup.popupCode.destroy()
		}
	}
}