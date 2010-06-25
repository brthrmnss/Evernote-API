package   org.robotlegs.popups.controller.default_commands
{
	import flash.events.Event;
	
	public class ShowConfirmDialogTriggerEvent extends Event
	{
		public static const SHOW_CONFIRM_DIALOG_POPUP:String = 'showConfirmDialogPopup';
		
		/**
		 * The default confirm popup name
		 * */
		public var popupName : String = 'popup_confirm'; 
		
		public function arrayArgs()  :   Array
		{
			return [this.message, this.yesFx, this.noFx, this.titleLbl, this.yesMessage, this.noMessage, this.args]
		}		
		
		public var noFx :  Function; 
		public var yesFx : Function;
		
		public var titleLbl : String = 'Alert';	  
		
		public var noMessage : String = 'Cancel';
		public var yesMessage : String = 'Continue';
		public var message : String = 'Are you sure you wish to proceed?';
		public var args :  Array; 
		
		public function ShowConfirmDialogTriggerEvent(type:String,
													  msg :  String, yesFx : Function, noFx : Function = null,
													  titleLbl : String = 'Alert', yesBtn : String =' Ok', noBtn : String = 'Cancel', args : Array = null , 
													  popupName_ : String = '' )
		{	
			this.message = msg
			//this.yesConfirmMode = true
			this.yesFx = yesFx
			this.noFx = noFx
			this.args = args
			this.titleLbl = ''
			this.yesMessage = yesBtn		
				
			if ( popupName_ != '' ) 
				this.popupName = popupName_				
				
			super(type, true);
		}
	
	}
}