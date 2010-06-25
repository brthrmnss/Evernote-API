package org.robotlegs.popups.controller
{
	
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.IPopup;
	
	public class AddPopupsKeyboardShortcutsCommand extends Command
	{
	/*	static public var ENABLE_KEYBOARD_SHORTCUTS  : String = 'ENABLE_KEYBOARD_SHORTCUTS';
		static public var ADD_KEYBOARD_SHORTCUTS  : String = 'ADD_KEYBOARD_SHORTCUT';	
		*/
		[Inject] public var event:AddKeyboardShortcutToOpenPopupEvent;
		[Inject] public var popupModel:PopupModel;
		
		override public function execute():void
		{
			if ( event.type == AddKeyboardShortcutToOpenPopupEvent.ENABLE_KEYBOARD_SHORTCUTS )
			{
				this.popupModel.registerKeyboardEvent( this.mediatorMap )
			}
			if ( event.type == AddKeyboardShortcutToOpenPopupEvent.ADD_KEYBOARD_SHORTCUTS )
			{
				//add to model list
				this.popupModel.registerPopupShortcut( event.name, event.class_, event.popup, event.keyToOpen, event.ctrlKey, event.altKey )
			}
		}
		
	 
	}
}