package org.robotlegs.popups.controller
{
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.IPopup;
	
	import sss.Shelpers.Shelpers.ui.PopupCode;
	
	public class HidePopupCommand extends Command
	{
		[Inject] public var event:HidePopupEvent;
		[Inject] public var popupModel:PopupModel;
		
		override public function execute():void
		{
			var popup  : IPopup   = this.popupModel.locatePopup( event.name, event.class_, event.popup )
		 	if ( event.args == null    ) 
				popup.hide()
			else
			{
				if ( event.args is Array )
				{
					var fx : Function = (popup as Object).close
					fx.apply( popup, event.args )
				}
				if ( event.args is Object )
				{
					//unless there is an easier way, such as knowing names of parameters? 
					(popup as Object).close2( event.args ) 
				}				
			}
		}
	}
}