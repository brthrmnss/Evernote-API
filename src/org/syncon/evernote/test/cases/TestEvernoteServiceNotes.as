package org.syncon.evernote.test.cases
{
	import com.evernote.edam.notestore.NoteCollectionCounts;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.services.EvernoteService;

	public class TestEvernoteServiceNotes
	{
		private var service:EvernoteService;
		private var serviceDispatcher:EventDispatcher ;
		private var noteCount : int = 0; 
		private var notebooks : Array  = []
		private var note : Note; 
		
		[Before(async)]
		public function setUp():void
		{
			serviceDispatcher = new EventDispatcher();
			service = new EvernoteService();
			service.eventDispatcher = serviceDispatcher;
			service.getAuth( 'brthrmnss', '12121212' )
			Async.proceedOnEvent( this, serviceDispatcher, EvernoteServiceEvent.AUTH_GET, 5000 );
		}
		
		[After]
		public function tearDown():void
		{
			this.serviceDispatcher = null;
			this.service = null;
		}
		
		
		
		
		
		[Test(async)]
		public function testCountNotes():void
		{
			this.serviceDispatcher.addEventListener( EvernoteServiceEvent.NOTES_COUNTED, 
				Async.asyncHandler(this, handleNotesCounted, 8000, null, 
					null), false, 0, true);
			this.service.findNoteCounts()
		}
		
		protected function handleNotesCounted( event:EvernoteServiceEvent, o:Object ):void
		{
			var notebooks : Dictionary =( event.data as  NoteCollectionCounts).notebookCounts
			for ( var guid : String in notebooks ) 
			{
				this.noteCount =  notebooks[guid]
					var nb : Notebook = new Notebook()
						nb.guid =    guid
					this.notebooks.push( nb ) 
				//return; 
				continue
			}
			
			this.createNote();
		}		
		
		
		
	//	 [Test(async)]
		public function createNote():void
		{
			this.serviceDispatcher.addEventListener( EvernoteServiceEvent.NOTE_CREATED, 
				Async.asyncHandler(this, handleNoteCreated, 8000, null, 
					null), false, 0, true);
			var contents : String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
				"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">" +
				"<en-note>Here's the Evernote logo:<br/>" +
			/*	"<en-media type=\"image/png\" hash=\"" + hashHex + "\"/>" +*/
				"</en-note>";

			var note :  Note = this.service.newNote( 'title', contents) 
			note.notebookGuid = this.notebooks[0].guid ; 
			note.notebookGuid = "3"
			note.deleted = 0
				
			this.service.createNote( note ) 
			
		}
			protected function handleNoteCreated( event:EvernoteServiceEvent, o:Object ):void
			{
				//trace();
			 	this.note = event.data as Note
				//testDeleteNote()
				//this.testUpdateNote()
				//this.textExpungeNote()
				this.testGetNote()
			}				
			
		
			
			
			//[Test(async)]
			public function testDeleteNote():void
			{
				this.serviceDispatcher.addEventListener( EvernoteServiceEvent.NOTE_DELETED, 
					 Async.asyncHandler(this, handleDeleteNote, 4000, null, 
						null), false, 0, true);
				 
			 this.service.deleteNote(   this.note.guid ) 
			}
				protected function handleDeleteNote( event:EvernoteServiceEvent, o:Object ):void
				{
					trace();
				}					
				
				public function textExpungeNote():void
				{
					this.serviceDispatcher.addEventListener( EvernoteServiceEvent.NOTE_EXPUNGED, 
						Async.asyncHandler(this, handleExpungeNote, 4000, null, 
							null), false, 0, true);
					
					this.service.expungeNote(   this.note.guid ) 
				}
					protected function handleExpungeNote( event:EvernoteServiceEvent, o:Object ):void
					{
						trace();
					}					
									
					
				public function testGetNote():void
				{
					this.serviceDispatcher.addEventListener( EvernoteServiceEvent.NOTE_GET, 
						Async.asyncHandler(this, handleGetNote, 4000, null, 
							null), false, 0, true);
					
					this.service.getNote(   this.note.guid ) 
				}
					protected function handleGetNote( event:EvernoteServiceEvent, o:Object ):void
					{
						trace();
					}					
										
					
				
				//[Test(async)]
				public function testUpdateNote():void
				{
					this.serviceDispatcher.addEventListener( EvernoteServiceEvent.NOTE_UPDATED, 
						Async.asyncHandler(this, handleUpdateNote, 8000, null, 
							null), false, 0, true);
					var contents : String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
						"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">" +
						"<en-note>Here's the Evernote logo:<br/>" +'x'+
						/*	"<en-media type=\"image/png\" hash=\"" + hashHex + "\"/>" +*/
						"</en-note>";
					
					this.note.content = contents
					this.service.updateNote( note ) 
				}
				protected function handleUpdateNote( event:EvernoteServiceEvent, o:Object ):void
				{
					trace();
				}					
				
				
		/*
		[Test(async)]
		public function testRetreiveImages():void
		{
			this.serviceDispatcher.addEventListener( GalleryEvent.GALLERY_LOADED, 
				Async.asyncHandler(this, handleImagesReceived, 8000, null, 
				handleServiceTimeout), false, 0, true);
			this.service.loadGallery();
		}

		[Test(async)]
		public function testSearchImages():void
		{
			this.serviceDispatcher.addEventListener( GalleryEvent.GALLERY_LOADED, 
				Async.asyncHandler(this, handleImagesReceived, 8000, null, 
				handleServiceTimeout), false, 0, true);
			this.service.search("robotlegs");
		}
					 
		protected function handleServiceTimeout( object:Object ):void
		{
	    	Assert.fail('Pending Event Never Occurred');
		}
		
		protected function handleImagesReceived(event:GalleryEvent, object:Object):void
		{
			Assert.assertEquals("The gallery should have some photos: ", 
				event.gallery.photos.length > 0, true)	
		}
		*/
		
	}
}