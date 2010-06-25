package org.robotlegs.popups.controller
{
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.IPopup;
	
	public class FindPopupCommand extends Command
	{
		[Inject] public var event:RemovePopupEvent;
		[Inject] public var popupModel:PopupModel;
		
		override public function execute():void
		{
			this.popupModel.findPopup( event.name, event.class_  ) 
		}
	}
}