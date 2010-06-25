package org.robotlegs.popups.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.events.CollectionEvent;
	
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.popups.controller.HidePopupEvent;
	import org.robotlegs.popups.controller.ShowPopupEvent;
	import org.robotlegs.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	import org.robotlegs.popups.controller.default_commands.ShowConfirmDialogTriggerEvent;
	import org.robotlegs.stockchart.view.ui.popup_launcher;
	
	public class PopupLauncherMediator extends Mediator
	{
		[Inject] public var ui:PopupLauncher;
		
		public function PopupLauncherMediator()
		{
		}
		
		override public function onRegister():void
		{
			this.ui.btnStock.addEventListener( MouseEvent.CLICK, this.onStockPopup, false, 0, true )
			this.ui.btnPopup1.addEventListener( MouseEvent.CLICK, this.onBtnPopup1, false, 0, true )
			this.ui.btnPopup2.addEventListener( MouseEvent.CLICK, this.onBtnPopup2, false, 0, true )
			this.ui.btnPopup3.addEventListener( MouseEvent.CLICK, this.onBtnPopup3, false, 0, true )
			this.ui.btnAlert.addEventListener( MouseEvent.CLICK, this.onAlert, false, 0, true )
			this.ui.btnConfirm.addEventListener( MouseEvent.CLICK, this.onConfirm, false, 0, true )						
		}
		
		private function onStockPopup(e:MouseEvent):void
		{
			this.dispatch( new  ShowPopupEvent ( ShowPopupEvent.SHOW_POPUP,  'stockpopup' ) ) 
		}
		
		private function onBtnPopup1(e:MouseEvent):void
		{
			this.dispatch( new  ShowPopupEvent (ShowPopupEvent.SHOW_POPUP,  'popup1' ) ) 
		}
		
		private function onBtnPopup2(e:MouseEvent):void
		{
			this.dispatch( new  ShowPopupEvent ( ShowPopupEvent.SHOW_POPUP, 'popup2' ) ) 
		}
		
		private function onBtnPopup3(e:MouseEvent):void
		{
			this.dispatch( new  ShowPopupEvent ( ShowPopupEvent.SHOW_POPUP, 'popup3' ) ) 			
			//this.dispatch( new  ShowPopupEvent ( ShowPopupEvent.SHOW_POPUP, 's' ) ) 
		}	
		
		private function onAlert(e:MouseEvent):void
		{
			this.dispatch( new  ShowAlertMessageTriggerEvent ( ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, 'This is an alert' , 'This is the message') ) 
		}
		
		private function onConfirm(e:MouseEvent):void
		{
			this.dispatch( new  ShowConfirmDialogTriggerEvent ( ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, 'Are you sure?', this.onYes, this.onNo ) ) 
		}
		
		public function onYes(  ) : void
		{
			this.dispatch( new  HidePopupEvent ( HidePopupEvent.HIDE_POPUP, 'popup_confirm' ) ) 
		}
		public function onNo() : void
		{
			this.onAlert(null)
		}		
		
		
	}
}