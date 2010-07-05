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
		
		private var service2:EvernoteService;
		private var serviceDispatcher2:EventDispatcher ;		
		
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
			
			serviceDispatcher2 = new EventDispatcher();
			service2 = new EvernoteService();
			service2.eventDispatcher = serviceDispatcher2;
			
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
			this.serviceDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTE_COUNTS, 
				Async.asyncHandler(this, handleNotesCounted, 8000, null, 
					null), false, 0, true);
			this.service.findNoteCounts()
			/*	
			this.note = new Note()
			this.note.guid = '40b5d392-7fa4-4120-8cc3-980b733faf13'
			this.testGetNote()
			*/	
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
			this.serviceDispatcher.addEventListener( EvernoteServiceEvent.CREATE_NOTE, 
				Async.asyncHandler(this, handleNoteCreated, 8000, null, 
					null), false, 0, true);
			var contents : String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
				"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">" +
				"<en-note>Here's the Evernote logo:<br/>" +
			/*	"<en-media type=\"image/png\" hash=\"" + hashHex + "\"/>" +*/
				"</en-note>";

			var note :  Note = this.service.newNote( 'title', contents) 
			note.notebookGuid = this.notebooks[0].guid ; 
			note.active = true; 
			//note.active = false; 
			note.title= 'ss'
			note.created = new Date().getTime()
			note.updated = note.created
			//note.notebookGuid = "3"
			//note.deleted = 0
				
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
					
				import flash.utils.setTimeout; 
				setTimeout( this.testGetNote, 3000 )
					
			}				
			
		
			
			
			//[Test(async)]
			public function testDeleteNote():void
			{
				this.serviceDispatcher.addEventListener( EvernoteServiceEvent.DELETE_NOTE, 
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
					this.serviceDispatcher.addEventListener( EvernoteServiceEvent.EXPUNGE_NOTE, 
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
					try 
					{
						this.serviceDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE, 
							Async.asyncHandler(this, handleGetNote, 4000, null, 
								null), false, 0, true);
						this.serviceDispatcher2.addEventListener( EvernoteServiceEvent.GET_NOTE, 
							Async.asyncHandler(this, handleGetNote, 4000, null, 
								null), false, 0, true);	
					}
					catch(e:Error)
					{
						
					}
					//this.service.getNote(   this.note.guid ) 					
					
					if ( this.service != null )	
					this.service2.handleAuthenticateResult(   this.service.auth )
					this.service2.getNote(   this.note.guid ) 
						
				}
					protected function handleGetNote( event:EvernoteServiceEvent, o:Object ):void
					{
						trace();
					}					
										
					
				
				//[Test(async)]
				public function testUpdateNote():void
				{
					this.serviceDispatcher.addEventListener( EvernoteServiceEvent.UPDATE_NOTE, 
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