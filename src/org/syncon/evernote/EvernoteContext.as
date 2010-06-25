package  org.syncon.evernote
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Context;
	import org.syncon.evernote.services.*;

/*	import org.robotlegs.popups.controller.*;
	import org.robotlegs.popups.controller.default_commands.ShowAlertMessageCommand;
	import org.robotlegs.popups.controller.default_commands.ShowAlertMessageTriggerEvent;
	import org.robotlegs.popups.controller.default_commands.ShowConfirmDialogCommand;
	import org.robotlegs.popups.controller.default_commands.ShowConfirmDialogTriggerEvent;
	import org.robotlegs.popups.model.*;
	import org.robotlegs.popups.services.*;
	import org.robotlegs.popups.view.*;
	import org.robotlegs.popups.view.popups.*;
	import org.robotlegs.popups.view.popups.default_popups.*;
	import org.robotlegs.stockchart.controller.*;
	import org.robotlegs.stockchart.model.*;
	import org.robotlegs.stockchart.services.*;
	import org.robotlegs.stockchart.view.*;
	import org.robotlegs.stockchart.view.ui.*;
	*/
	public class EvernoteContext extends Context
	{
		
		public function EvernoteContext()
		{
			super();
		}
		override public function startup():void
		{
			// Model
			injector.mapSingletonOf( EvernoteService, IEvernoteService  )			
			// Controller
			// Services
			//injector.mapSingletonOf(IAuthService, DummyAuthService);
			// View
	
			this.startupPopupSubContext()
			// Startup complete
			super.startup();
			
		}
		
		public function startupPopupSubContext()  : void
		{
			/*
			// Model
			injector.mapSingleton( PopupModel  )		
			// Controller
			//commandMap.mapEvent(StockPricePopupEvent.CREATE_POPUP, CreateStockPricePopupCommand, StockPricePopupEvent);	
			commandMap.mapEvent(CreatePopupEvent.REGISTER_AND_CREATE_POPUP, CreatePopupCommand, CreatePopupEvent);		
			commandMap.mapEvent(CreatePopupEvent.REGISTER_POPUP, CreatePopupCommand, CreatePopupEvent);			
			commandMap.mapEvent(RemovePopupEvent.REMOVE_POPUP, RemovePopupCommand, RemovePopupEvent);			
			commandMap.mapEvent(ShowPopupEvent.SHOW_POPUP, ShowPopupCommand, ShowPopupEvent);			
			commandMap.mapEvent(HidePopupEvent.HIDE_POPUP, HidePopupCommand, HidePopupEvent);			
			
			//default popups
			commandMap.mapEvent(ShowConfirmDialogTriggerEvent.SHOW_CONFIRM_DIALOG_POPUP, ShowConfirmDialogCommand, ShowConfirmDialogTriggerEvent);			
			commandMap.mapEvent(ShowAlertMessageTriggerEvent.SHOW_ALERT_POPUP, ShowAlertMessageCommand, ShowAlertMessageTriggerEvent);				
			
			commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ADD_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand, AddKeyboardShortcutToOpenPopupEvent);	
			commandMap.mapEvent(AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS, AddPopupsKeyboardShortcutsCommand);				
			
			// Services
			// View
			mediatorMap.mapView(  PopupLauncher, PopupLauncherMediator );			
			mediatorMap.mapView( stockprice_popup, StockPricePopupMediator, null, false, false );	
			mediatorMap.mapView( popup_modal_bg, PopupModalMediator, null, false, false );		
			mediatorMap.mapView( popup1, Popup1Mediator, null, false, false );		
			mediatorMap.mapView( popup2, Popup2Mediator, null, false, false );		
			mediatorMap.mapView( popup3, Popup3Mediator, null, false, false );		
			
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_AND_CREATE_POPUP,  popup_modal_bg, 'popup_modal_bg', true ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, stockprice_popup, 'stockpopup' ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup1, 'popup1' ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup2, 'popup2' ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup3, 'popup3' ) );
			
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup_message, 'popup_alert' ) );
			this.dispatchEvent( new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup_confirm, 'popup_confirm' ) );			
			
			//this.dispatchEvent( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP,  'popup_modal_bg' ) );	
			//this.dispatchEvent( new ShowPopupEvent( ShowPopupEvent.SHOW_POPUP,  'stockpopup' ) );
			
			this.dispatchEvent( new AddKeyboardShortcutToOpenPopupEvent( AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS  ) );
			this.dispatchEvent( new AddKeyboardShortcutToOpenPopupEvent( AddKeyboardShortcutToOpenPopupEvent.ADD_KEYBOARD_SHORTCUTS, 
				'popup3', 89 ) ); //ctrl+Y			
			*/
		}
		
		public function onInit()  : void
		{
		}
 
	}
}