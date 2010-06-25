/**
* Main Model for Application 
*/
package org.robotlegs.popups.model
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.core.UIComponent;
	
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.mvcs.Actor;
	import org.robotlegs.popups.controller.CreatePopupCommand;
	import org.robotlegs.popups.controller.CreatePopupEvent;
	import org.robotlegs.popups.view.popups.IPopup;
	import org.robotlegs.stockchart.model.vo.StockPriceVO;
	import org.robotlegs.stockchart.view.ChartPageEvent;
	
	import sss.Shelpers.Shelpers.ui.PopupCode;

	/**
	 * Dispatched when chart has been changed 
	 */
	[Event(name="tickerUpdated", type="org.robotlegs.stockchart.model.TickerModelEvent")]
	/**
	* keeps track of all popups cleans up
	 * ensures stacking order respected
	*/
	public class   PopupModel   extends Actor 
	{
		private var _popups : ArrayCollection ; // [];
		public function get popups ()  : ArrayCollection { return this._popups } 
		/**
		 * Counts number of popups that have been added
		 * */
		private var addCount : int = 0; 
		private var index :  Dictionary ;	
		private var registeredPopups : Dictionary; 
		public function get popupsRegistered ()  : Dictionary { return this.registeredPopups } 
		public function get popupsRegisteredLength ()  : int 
		{ 
			return getKeys(this.registeredPopups ).length
		} 		
		
		public static function getKeys(d:Dictionary):Array
		{
			var a:Array = new Array();
			
			for (var key:Object in d)
			{
				a.push(key);
			}
			
			return a;
		}		
		
		public function PopupModel()
		{
			_popups = new ArrayCollection();
			this.index = new Dictionary(true)
			popupsThatAutoCloseOthers = new ArrayCollection();
			popupsThatAreNeverAutoclosed = new ArrayCollection();		
			this.popupsModal = new ArrayCollection();
			this.openedPopups = new ArrayCollection();
			this.modalOpenBecauseOfUIComponents =   new ArrayCollection()
			this.registeredPopups = new Dictionary(true);
			this.keyboardShortcuts = new ArrayCollection()
		}		
 
		private var popupsThatAutoCloseOthers :  ArrayCollection 
		private var popupsThatAreNeverAutoclosed: ArrayCollection 
		private var popupsModal : ArrayCollection; 
		/**
		 * possiblly?
		 * add v
		 * */
		public function registerPopup( name : String, popup :  IPopup, modal : Boolean,
									   autoCloseOthers : Boolean, doNotAutoClose : Boolean, 
									   eventForDeferredCreation : CreatePopupEvent = null )  : void
		{

			if ( name == null || name == '' )
			{
				name = this.addCount.toString()
			}
			else
			{
				if ( this.index[name] != null ) 
				{
					throw 'Index '+name+'is already being used' 
				}
			}
			
			if ( eventForDeferredCreation != null   ) 
			{
				this.registeredPopups[name] =eventForDeferredCreation 
				return;
			}

			this.addCount++
			this.popups.addItem( popup )			
			this.index[name] = popup
			if ( autoCloseOthers ) this.popupsThatAutoCloseOthers.addItem( popup ) 
			if ( doNotAutoClose ) this.popupsThatAreNeverAutoclosed.addItem( popup ) 		
			if ( modal ) this.popupsModal.addItem( popup ) 
			var popupUi : UIComponent = popup as UIComponent
			popupUi.addEventListener( PopupCode.POPUP_OPENED, this.openedPopup )
			popupUi.addEventListener( PopupCode.POPUP_CLOSED, this.closedPopup )
			//this._tickerData.source = dp; 
			//this.dispatch( new TickerModelEvent( TickerModelEvent.TICKER_UPDATED , this._tickerData.source ) ) 
		}
 
		
		/**
		 * Loads new set of data
		 * */
		public function removePopup( name : String = '', class_ : Class=null, popup_ : Object =  null  )  :  IPopup
		{
			if ( name == '' && popup_ == null && class_ == null )
			{
				trace( 'could not located popup to be removed' )
				//throw?
				return null;
			}
 
			var popup : IPopup = this.locatePopup( name, class_, popup_, false  )
			//may have been registered, delete registry
			if ( popup == null ) 
				return null; 
			var name : String = getPopupName( popup ) 
			this.popups.removeItemAt( this.popups.getItemIndex( popup ) ) 
			if ( this.popupsThatAreNeverAutoclosed.getItemIndex( popup ) != -1 ) 				
				this.popupsThatAutoCloseOthers.removeItemAt( this.popupsThatAutoCloseOthers.getItemIndex( popup ) ) 
			if ( this.popupsThatAreNeverAutoclosed.getItemIndex( popup ) != -1 ) 
				this.popupsThatAreNeverAutoclosed.removeItemAt( this.popupsThatAreNeverAutoclosed.getItemIndex( popup ) ) 
			if ( this.popupsModal.getItemIndex( popup ) != -1 ) 
				this.popupsModal.removeItemAt( this.popupsModal.getItemIndex( popup ) ) 					
			this.index[name] = null
			delete this.index[name] 	
			var popupUi : UIComponent = popup as UIComponent
			popupUi.removeEventListener( PopupCode.POPUP_OPENED, this.openedPopup )
			popupUi.removeEventListener( PopupCode.POPUP_CLOSED, this.closedPopup )			
			return popup
		}
		  
		public function getPopupName(popup : IPopup )  : String
		{
			for  ( var indexName :   Object in this.index )
			{
				var popup_ : IPopup = this.index[indexName] 
				if ( popup == popup_ )
				{
					return    indexName.toString()
				}
			}				
			return null
		}
		public function locatePopup( name : String = '', class_ : Class=null, popup : Object =  null, createIfRegistered : Boolean = true  )  :  IPopup
		{
			if ( name == '' && popup == null && class_ == null )
			{
				trace( 'could not located popup to be removed' )
				//throw?
				return null;
			}
			if ( name != '' ) 
			{
				if ( this.registeredPopups[name] != null && createIfRegistered )
				{
					var event :  CreatePopupEvent = this.registeredPopups[name]  
					var create : CreatePopupCommand = new CreatePopupCommand()
					create.event =   this.registeredPopups[name]  
					create.external = true
					create.popupModel = this
					//create.event.type = CreatePopupEvent.REGISTER_AND_CREATE_POPUP
					create.execute()
					this.registeredPopups[name] = null;
					delete registeredPopups[name];
					return create.popup; 
					/*
					return this.registerPopup.apply( this ,   args  ) as IPopup*/
				}
				return this.index[name] as IPopup
			}
			//find name from class
			if ( class_ != null ) 
			{
				for ( var  indexName : String  in this.index )
				{
					var popup_ : IPopup  = this.index[indexName] 
					if ( popup_  is   class_  )
					{
						return popup_
					}
				}
			}
			
			if ( popup != null ) 
			{
				return popup_
			}
			
			
			return null
		}
				
		
		public function describeModel( vert : Boolean = true) : void
		{
			trace( 'registered popups' ) 
			for  ( var prop : String  in this.index ) 
			{
				trace( prop + ': ' + this.index[prop] ) 
			}
			for each  ( var obj :  IPopup in this.popups ) 
			{
				trace( obj ) 
			}	
			for each  ( obj  in this.popupsThatAreNeverAutoclosed ) 
			{
				trace( obj ) 
			}				
			for each  ( obj in this.popupsThatAutoCloseOthers ) 
			{
				trace( obj ) 
			}		
			for each  ( obj  in this.popupsModal ) 
			{
				trace( obj ) 
			}					
		}
 		public var modalPopup : IPopup; 
		/**
		 * Updates modal bg depth
		 * */
		public function modalPopupOpened ()  : void
		{
			if ( this.modalPopup == null ) 
					throw 'Modal Popup Not Defined' 
			
					//adjust layers

					//auto close
					//put everything open top of me
						//skipping those that shouldn't be ...
					//handle popup sets (put in front if host is open )
					//put globals in front
				
				this.dispatch( new PopupModelEvent( PopupModelEvent.MODAL_SHOW ) ) 
		}
		
		public function modalPopupClosed ()  : void
		{
			if ( this.modalPopup == null ) 
				throw 'Modal Popup Not Defined' 
			
			//auto close
			//skipping those that shouldn't be ...
			//handle popup sets (put in front if host is open )
			//put globals in front
			
			this.dispatch( new PopupModelEvent( PopupModelEvent.MODAL_CLOSED ) ) 
		}		
		
		/**
		 * Uses popupcode opened event to keep track of current popups
		 * uses list to quickly open and close popups
		 * not the best idea from mvc persepctive 
		 * also cocerns of looping issues 
		 * */
		public var openedPopups : ArrayCollection; 
		public function openedPopup(e:Event) : void
		{
			var popup : IPopup = e.currentTarget as IPopup
			this.openedPopups.addItem( popup ) 
			this.showPopup_ModalMode( popup ) 
		}
		public function closedPopup(e:Event) : void
		{
			var popup : IPopup = e.currentTarget as IPopup
			this.openedPopups.removeItemAt( this.openedPopups.getItemIndex( popup ) ) 		
			this.modalClose( popup ) 
		}
		
		public function registerModalPopup( popup : IPopup )  : void
		{
			
		}
		
	
		/**
		 * Go through rules and ensure all components are visible
		 * */
		public function modal_AdjustLayers() : void
		{
		}
		
		public function showPopup_ModalMode( popup : IPopup )  : void
		{
			if ( this.modalPopup == null || popup == modalPopup) return; 
			//if this popup autocloses, close any popups that can be autoclosed
			if ( this.popupsThatAutoCloseOthers.getItemIndex( popup )  != -1 )
			{
				for each ( var p : IPopup  in this.openedPopups )
				{
					if ( this.popupsThatAreNeverAutoclosed.getItemIndex( p ) == -1 ) 
						popup.hide()
				}
			}
			
			
			
			//if requires modal open modal bg
			if ( this.popupsModal.getItemIndex( popup )  != -1 )
			{
				this.modalOpen( popup ) 
			}
						
			 	
		}
		
		public function get modal () : Boolean
		{
			return this.modalPopup.popupCode.showing
		}
		
		public function modalOpen( o:Object ): void
		{
			this.modalPopup.show()
			var index : int = this.modalOpenBecauseOfUIComponents.getItemIndex(o) 
			if (   index == -1 ) 
			{
				this.modalOpenBecauseOfUIComponents.addItem(o)
			}            
		}
		/**
		 * Contains Currently open popups
		 * */
		public var modalOpenBecauseOfUIComponents:  ArrayCollection 
		public function modalClose( popup: IPopup  ): void
		{
			if ( this.modalPopup == null || popup == modalPopup ) return; 
			var index : int = this.modalOpenBecauseOfUIComponents.getItemIndex(popup) 
			if (   index != -1 ) 
			{
				this.modalOpenBecauseOfUIComponents.removeItemAt(index)
			}
			//this.model.popupModal.adjustLayer()
			
			if ( this.modalOpenBecauseOfUIComponents.length == 0 )
			{
				//this.modal = false
				this.modalPopup.hide()
			}
		}
		
		/**
		 * Breaks convention of model listening for events
		 * */
		public function registerKeyboardEvent( listenOn : IMediatorMap )  : void
		{
			/*
			listenOn.contextView.addEventListener( KeyboardEvent.KEY_DOWN, this.keyDownHandler , false, 0 , true )
			listenOn.contextView.addEventListener( KeyboardEvent.KEY_UP, this.keyUpHandler,  false, 0 , true )   		
				*/
			listenOn.contextView.stage.addEventListener( KeyboardEvent.KEY_DOWN, this.keyDownHandler , false, 0 , true )
			listenOn.contextView.stage.addEventListener( KeyboardEvent.KEY_UP, this.keyUpHandler,  false, 0 , true )   							
		}
		
		public var keyboardShortcuts : ArrayCollection
		
		public function registerPopupShortcut( name_  :  String='' , class__: Class=null , popup_ : Object  = null,   
											   keyToOpen_ : Number=0, ctrlKey_ : Boolean = true, 
											   altKey_ : Boolean=false )  : void
		{
			//check if identifier is valid is real, or exists in deffered dictionaries
			this.keyboardShortcuts.addItem( {name:name_, class_:class__, popup:popup_, keyToOpen:keyToOpen_, 
				ctrlKey:ctrlKey_, altKey:altKey_ } )
			
		}
		
		private function keyDownHandler( e:KeyboardEvent ):void 
		{
			if (e.charCode == 27 && e.ctrlKey == false  )  //. && e.shiftKey &&  e.keyCode == 66 ) //B
			{
				this.closePopups()
				/*	if ( this.model._popupHelpModal != null ) 
				this.model.popupHelpModal.close()*/
			}				
			var relevant : Array = []; 
			for each ( var shortcut  : Object  in this.keyboardShortcuts ) 
			{
				if ( e.keyCode == shortcut.keyToOpen && e.altKey == shortcut.altKey && e.ctrlKey == shortcut.ctrlKey )
				{
					relevant.push( shortcut ) 
				}
			}
			
			if ( relevant.length == 0 ) 
				return; 
			
			for each (  shortcut  in relevant ) 
			{
					var popup_ : IPopup = this.locatePopup( shortcut.name, shortcut.class_, shortcut.popup, true  )
					if ( popup_ == null ) continue ; 
					popup_.show()
			}
/*			if ( e.ctrlKey && e.keyCode == 90 )// Z )
			{
			}
			if ( e.ctrlKey && e.keyCode == 89 ) //Y
			{
			}		
			if ( e.ctrlKey && e.keyCode == 17 ) //s
			{
				//save teh current entry
				//keep track of the curren entry 
				//this.model.saveEntry( 
				//this.redo()	
			}		
			if ( e.ctrlKey && e.altKey &&  e.keyCode == 74 ) //J
			{
				//this.model.popupJrlModeEntry.open();
			}				
			if ( e.ctrlKey && e.shiftKey &&  e.keyCode == 66 ) //B, buttom search
			{
				this.model.popupBottomClothingSearch.open()
			}		
			if ( e.ctrlKey && e.shiftKey &&  e.keyCode == 76 ) //L, search left
			{
				this.model.popupClothingSearchLeft.open()
			}					
			if ( e.ctrlKey && e.shiftKey &&  e.keyCode == 79 ) //O, bottom outfit
			{
				this.model.popupOutfitMaker.open()
			}  
			if ( e.ctrlKey && e.shiftKey &&  e.keyCode == 67 ) //C, cart
			{
				this.model.popupClothingCart.open()
			}		
			if (   e.altKey &&  ( e.keyCode == 81 || e.charCode == 113 )  ) //Q, commmand
			{
				this.model.popupCommand.open()
			}					
			if ( e.ctrlKey && e.shiftKey &&  e.keyCode == 77 ) //M, mannqeuin
			{
				this.model.popupMannqeuinn.open()
			}		*/							
			//var dbg : Array = [e.keyCode, Keyboard.ESCAPE  ]			
														
		}
		private function keyUpHandler( e: KeyboardEvent ):void 
		{
			
		}		
		
		public function closePopups()  : void
		{
			for each ( var popup : IPopup in this.openedPopups )
			{
				popup.hide(); 
			}
		}
		
		
		/**
		 * su..
		 * */
		
	}
}