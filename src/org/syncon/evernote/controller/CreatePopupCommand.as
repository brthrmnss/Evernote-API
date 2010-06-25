package org.robotlegs.popups.controller
{
	import flash.display.DisplayObjectContainer;
	
	import mx.core.UIComponent;
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.IPopup;
	
	import sss.Shelpers.Shelpers.ui.PopupCode;
	/**
	 * Creates popups
	 * if event type is for reigstration, popup is registered, and when user requests popup, it is created
	 * if event type is registration and creation, willd o both in one step
	 * */
	public class CreatePopupCommand extends Command
	{
		[Inject] public var event:CreatePopupEvent;
		[Inject] public var popupModel:PopupModel;
		/**
		 * Storage for Popup if created later
		 * */
		public var popup : IPopup; 
		/**
		 * Called by model, not by event
		 * */
		public var external : Boolean = false

 
		override public function execute():void
		{
			if ( event.type == CreatePopupEvent.REGISTER_POPUP && external == false  )
			{
				this.event.contextView_ = this.contextView;
				this.event.mediatorMap_ = this.mediatorMap;
				this.popupModel.registerPopup( event.name, popup, event.modal,   event.autoCloseOthers, event.doNotAutoclose, event) 
			}
			else
			{
				if ( external )
				{
					this.contextView = event.contextView_
					this.mediatorMap = event.mediatorMap_
				}
					
				var popup  : IPopup   = new  event.class_()
				if (  event.addToParent == null ) 
					popup.popupCode =  PopupCode.Create(popup, contextView  )
				else
					popup.popupCode =  PopupCode.Create(popup, event.addToParent, event.addAsPopup  )
				
				if ( mediatorMap != null ) 
					mediatorMap.createMediator(popup);
				//popup.popupCode.popupName = event.name; 
				this.popupModel.registerPopup( event.name, popup, event.modal,   event.autoCloseOthers, event.doNotAutoclose )
				//contextView.addChild(IPopup as UIComponent);
				this.popup = popup
			}

		}
	}
}