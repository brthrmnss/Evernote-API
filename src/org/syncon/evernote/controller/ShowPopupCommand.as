package org.robotlegs.popups.controller
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.IPopup;
	
	public class ShowPopupCommand extends Command
	{
		[Inject] public var event:ShowPopupEvent;
		[Inject] public var popupModel:PopupModel;
		
		/**
		 * Used by test, provides reference to intended popup
		 * */
		public var loadedPopup : IPopup;
		
		/**
		 * if popup has not been created, wait for it then call open function
		 * call open function, with specified arguments
		 * */
		override public function execute():void
		{
			var popup  : IPopup   = this.popupModel.locatePopup( event.name, event.class_, event.popup )
			this.loadedPopup = popup
			if ( popup.popupCode.creationComplete == false ) 
			{
				var p : UIComponent = (popup as UIComponent)
				//p.addEventListener(FlexEvent.CREATION_COMPLETE, this.onCreatedComponent, false, 0, true )
				p.addEventListener(FlexEvent.CREATION_COMPLETE, this.onCreatedComponent ); //, false, 0, true ) 
				return; 
			}				
			if ( popup ==  null ) 
			{
				throw 'Could not locate popup for '  + [ event.name, event.class_, event.popup ].join(' or ') 
			}
			if ( event.args == null    ) 
				popup.show()
			else
			{
				if ( event.args is Array )
				{
					var fx : Function = (popup as Object)[event.fx]
					fx.apply( popup, event.args )
				}
				else if ( event.args is Object )
				{
					//unless there is an easier way, such as knowing names of parameters? 
					(popup as Object).open2( event.args ) 
				}				
			}
		}
		
		public function onCreatedComponent(e:FlexEvent)  : void
		{
			(e.currentTarget as UIComponent).removeEventListener(FlexEvent.CREATION_COMPLETE, this.onCreatedComponent )
			//this.dispatch( event.clone() )
			this.dispatch( new  ShowPopupEvent ( ShowPopupEvent.SHOW_POPUP, event.name, event.args, event.fx, event.class_, event.popup ) ) 	
		}
		
	}
}