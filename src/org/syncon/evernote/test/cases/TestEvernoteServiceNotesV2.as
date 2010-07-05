package org.syncon.evernote.test.cases
{
	import com.evernote.edam.notestore.NoteCollectionCounts;
	import com.evernote.edam.type.Note;
	import com.evernote.edam.type.Notebook;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.syncon.evernote.events.EvernoteServiceEvent;
	import org.syncon.evernote.services.EvernoteService;

	public class TestEvernoteServiceNotesV2
	{
		static private var service:EvernoteService;
		static private var serviceDispatcher:EventDispatcher ;
 
		private var noteCount : int = 0; 
		private var notebooks : Array  = []
		static private var note : Note; 
		private function get note()  : Note { return TestEvernoteServiceNotesV2.note} 
		[BeforeClass(async, order=1)]
		static public function login():void
		{
			serviceDispatcher = new EventDispatcher();
			service = new EvernoteService();
			service.eventDispatcher = serviceDispatcher;
			service.getAuth( 'brthrmnss', '12121212' )
			Async.proceedOnEvent( TestEvernoteServiceNotesV2, serviceDispatcher, EvernoteServiceEvent.AUTH_GET, 5000 );
 
			trace('before')
		}
		
		[BeforeClass(async,  order=2)]
		static public function createInitNote():void
		{
			 
			Async.proceedOnEvent( TestEvernoteServiceNotesV2, serviceDispatcher, EvernoteServiceEvent.CREATE_NOTE, 5000 );
 
			trace('before2 ' + TestEvernoteServiceNotesV2.service.auth.authenticationToken  )
 
			serviceDispatcher.addEventListener( EvernoteServiceEvent.CREATE_NOTE, 
				Async.asyncHandler(TestEvernoteServiceNotesV2, handleNoteCreated, 8000, null, 
					null), false, 0, true);
			var contents : String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
				"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">" +
				"<en-note>Here's the Evernote logo:<br/>" +
				/*	"<en-media type=\"image/png\" hash=\"" + hashHex + "\"/>" +*/
				"</en-note>";
			
			var note :  Note =  service.newNote( 'title', contents) 
			//note.notebookGuid = this.notebooks[0].guid ; 
			note.active = true; 
			//note.active = false; 
			note.title= 'ss'
			note.created = new Date().getTime()
			note.updated = note.created
			//note.notebookGuid = "3"
			//note.deleted = 0
			
			service.createNote( note ) 
			
		}
		static protected function handleNoteCreated( event:EvernoteServiceEvent, o:Object ):void
		{
			trace('parse note')
			//trace();
			 note = event.data as Note
			//testDeleteNote()
			//this.testUpdateNote()
			//this.textExpungeNote()
			//this.testGetNote()
			//import flash.utils.setTimeout; 
			//setTimeout( this.testGetNote, 3000 )
		}				
		/*		
		[BeforeClass(async, order=3)]
		static public function wait():void
		{
			
			Async.proceedOnEvent( TestEvernoteServiceNotesV2, serviceDispatcher,'continue', 5000 );
			setTimeout(  waitFinish, 3000 )
			import flash.utils.setTimeout
			trace('before3')
		}		
		
		
		static public function waitFinish() : void
			
		{
			serviceDispatcher.dispatchEvent( new Event('continue') ) 
		}
		*/
		[AfterClass]
		static public function tearDown():void
		{
			serviceDispatcher = null;
			service = null;
		}
		
		

				
		
		
		
		[Test(async)]
		public function testCountNotes():void
		{
			trace('test1')
			serviceDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTE_COUNTS, 
				Async.asyncHandler(this, handleNotesCounted, 8000, null, 
					null), false, 0, true);
			service.findNoteCounts()
 
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
			
		}		
	 
		
		
		[Test(async)]
		public function testCountNotesb():void
		{
			trace('test2')
			serviceDispatcher.addEventListener( EvernoteServiceEvent.FIND_NOTE_COUNTS, 
				Async.asyncHandler(this, handleNotesCounted, 8000, null, 
					null), false, 0, true);
			service.findNoteCounts()
 
		}		
		
		
		
		[Test(async, order=4)]
		public function testDeleteNote():void
		{
			trace('testDeleteNote:')
			serviceDispatcher.addEventListener( EvernoteServiceEvent.DELETE_NOTE, 
				Async.asyncHandler(this, handleDeleteNote, 4000, null, 
					null), false, 0, true);
			
			service.deleteNote(    note.guid ) 
		}
		protected function handleDeleteNote( event:EvernoteServiceEvent, o:Object ):void
		{
			trace('Note Deleted');
		}					
				
 
		
		[Test(async, order=3)]
		public function testGetNote():void
		{
			trace('test3')
			serviceDispatcher.addEventListener( EvernoteServiceEvent.GET_NOTE, 
				Async.asyncHandler(this, handleGetNote, 4000, null, 
					null), false, 0, true);
			
			service.getNote(    note.guid ) 
		}
		protected function handleGetNote( event:EvernoteServiceEvent, o:Object ):void
		{
			trace('Note Got');
		}					
				
		
		
	}
}