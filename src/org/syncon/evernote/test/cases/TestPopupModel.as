package org.syncon.evernote.test.cases
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	
	import mx.events.FlexEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.robotlegs.base.MediatorMap;
	import org.robotlegs.popups.controller.CreatePopupCommand;
	import org.robotlegs.popups.controller.CreatePopupEvent;
	import org.robotlegs.popups.controller.RemovePopupCommand;
	import org.robotlegs.popups.controller.RemovePopupEvent;
	import org.robotlegs.popups.controller.ShowPopupCommand;
	import org.robotlegs.popups.controller.ShowPopupEvent;
	import org.robotlegs.popups.model.PopupModel;
	import org.robotlegs.popups.view.popups.IPopup;
	import org.robotlegs.popups.view.popups.popup1;
	import org.robotlegs.popups.view.popups.test_popup;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;
	
	import sss.Shelpers.Shelpers.ui.PopupCode;

	public class TestPopupModel
	{
		private var popupModel:PopupModel;
		
		[Before]
		public function setUp():void
		{
			this.popupModel = new PopupModel()
		}
		
		[After]
		public function tearDown():void
		{
			this.popupModel = null;
		}
		[Test (description="manually creates a popup")]
		public function createAndRemovePopupManually():void
		{
			this.popupModel.registerPopup( 'popup1', new   popup1  , true, false, false  )
			Assert.assertEquals("popupModel should have 1 popup", 
				this.popupModel.popups.length == 1, true );			
 
			this.popupModel.removePopup( 'popup1'  )
			Assert.assertEquals("popupModel should have 0 popup", 
				this.popupModel.popups.length == 0, true );	
		}		
		
		
		[Test (description="create defered popup  popup")]
		public function createAndRemovePopupFromCommand_Deffered():void
		{
			var event : CreatePopupEvent = new CreatePopupEvent( CreatePopupEvent.REGISTER_POPUP, popup1, 'popup1', true ) ; 
			var command:CreatePopupCommand = new CreatePopupCommand();
			command.eventDispatcher = new EventDispatcher();
			command.event = event
			command.popupModel = this.popupModel; 
			command.execute();			
			Assert.assertEquals("popupModel should have 0 popups", 
				this.popupModel.popups.length == 0, true );					
 			Assert.assertEquals("popupModel should have 1 registered popup", 
				this.popupModel.popupsRegisteredLength == 1, true ); 
		}
		public function removePopupFromCommand_Deffered():void
		{			
			var event :RemovePopupEvent = new RemovePopupEvent(RemovePopupEvent.REMOVE_POPUP, 'popup1' ) ; 
			var command:RemovePopupCommand = new RemovePopupCommand();
			command.eventDispatcher = new EventDispatcher();
			command.event = event
			command.popupModel = this.popupModel; 
			command.execute();						
			Assert.assertEquals("popupModel should have 0 popups", 
				this.popupModel.popups.length == 0, true );	
			Assert.assertEquals("popupModel should have 0 registered popup", 
				this.popupModel.popupsRegisteredLength == 0, true ); 			
		}		
		
		
		[Test (ui,description="manually creates a popup")]
		public function createAndRemovePopupFromCommand():void
		{
			var event : CreatePopupEvent = new CreatePopupEvent(  CreatePopupEvent.REGISTER_AND_CREATE_POPUP,
				test_popup, 'popup1',true, false, false, UIImpersonator, false  ) ; 
			var command:CreatePopupCommand = new CreatePopupCommand();
			command.eventDispatcher = new EventDispatcher();
			command.event = event
			command.popupModel = this.popupModel; 
			//command.mediatorMap = new MediatorMap(UIImpersonator, new Injector(), new Reflector())
			command.execute();			
			Assert.assertEquals("popupModel should have 1 popup", 
			this.popupModel.popups.length == 1, true );		
			
			var removeEvent :RemovePopupEvent = new RemovePopupEvent( RemovePopupEvent.REMOVE_POPUP,  'popup1' ) ; 
			var removeCommand:RemovePopupCommand = new RemovePopupCommand();
			removeCommand.eventDispatcher = new EventDispatcher();
			removeCommand.event = removeEvent
			removeCommand.popupModel = this.popupModel; 
			removeCommand.execute();						
			Assert.assertEquals("popupModel should have 0 popups", 
				this.popupModel.popups.length == 0, true );					
			Assert.assertEquals("popupModel should have 0 popups", 
			this.popupModel.popups.length == 0, true );	
		}			
		

		
		[Test(async,ui)] 
		public function createOpenAndRemovePopupFromCommands():void
		{
			var event : CreatePopupEvent = new CreatePopupEvent(  CreatePopupEvent.REGISTER_AND_CREATE_POPUP,
				test_popup, 'popup1',true, false, false, UIImpersonator, false  ) ; 
			var command:CreatePopupCommand = new CreatePopupCommand();
			command.eventDispatcher = new EventDispatcher();
			command.event = event
			command.popupModel = this.popupModel; 
			command.execute();			
			
			var openEvent:ShowPopupEvent = new ShowPopupEvent(  ShowPopupEvent.SHOW_POPUP,
				  'popup1'   ) ; 
			var openCommand:ShowPopupCommand = new ShowPopupCommand();
			openCommand.eventDispatcher = new EventDispatcher();
			openCommand.event = openEvent
			openCommand.popupModel = this.popupModel; 
			openCommand.execute();					
			//wait for it ....
			//timer.delay = 1000;
			var eventDispatcher : EventDispatcher =  openCommand.loadedPopup as EventDispatcher
			Async.handleEvent( this, eventDispatcher, PopupCode.POPUP_OPENED, createOpenAndRemovePopupFromCommands_Pt2, 2000 )
			//var asyncHandler:Function = Async.asyncHandler( this, openCommand.loadedPopup, 500, null, null );
			//timer.addEventListener(TimerEvent.TIMER_COMPLETE, asyncHandler, false, 0, true );
			//timer.start();		
			eventDispatcher.addEventListener( FlexEvent.CREATION_COMPLETE, onCreatedPopup )
		}
			private function onCreatedPopup(e:Event):void
			{
				var openEvent:ShowPopupEvent = new ShowPopupEvent(  ShowPopupEvent.SHOW_POPUP,
					'popup1'   ) ; 
				var openCommand:ShowPopupCommand = new ShowPopupCommand();
				openCommand.eventDispatcher = new EventDispatcher();
				openCommand.event = openEvent
				openCommand.popupModel = this.popupModel; 
				openCommand.execute();						
			}
		public function createOpenAndRemovePopupFromCommands_Pt2(e:Event,o:Object=null):void
		{			
			var removeEvent :RemovePopupEvent = new RemovePopupEvent( RemovePopupEvent.REMOVE_POPUP, 'popup1' ) ; 
			var removeCommand:RemovePopupCommand = new RemovePopupCommand();
			removeCommand.eventDispatcher = new EventDispatcher();
			removeCommand.event = removeEvent
			removeCommand.popupModel = this.popupModel; 
			try {
				removeCommand.execute();
			}
			catch (e:Error)
			{
				
			}
			Assert.assertEquals("popupModel should have 0 popups", 
				this.popupModel.popups.length == 0, true );	
		}			
		
				
		
		
		
		
/*		
		[Test]
		public function testSetSelectedImage():void
		{
			var image1:GalleryImage = new GalleryImage()
			var image2:GalleryImage = new GalleryImage()
			var gallery:Gallery = new Gallery()
			this.popupModel.gallery = gallery;
			gallery.photos.addItem(image1);
			gallery.photos.addItem(image2);
			image1.selected = false;
			image2.selected = true;
			this.popupModel.setSelectedImage(image1);
			Assert.assertEquals("Image1 should be selected", image1.selected, true);
			Assert.assertEquals("Image 2 should NOT be selected", image2.selected, false);
		}*/
	}
}