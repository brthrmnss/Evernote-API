package org.syncon.evernote.services
{
	
	import com.evernote.edam.notestore.*;
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.notestore.NoteStore;
	import com.evernote.edam.notestore.NoteStoreImpl;
	import com.evernote.edam.type.*;
	import com.evernote.edam.type.Notebook;
	import com.evernote.edam.type.User;
	import com.evernote.edam.userstore.AuthenticationResult;
	import com.evernote.edam.userstore.Constants;
	import com.evernote.edam.userstore.UserStore;
	import com.evernote.edam.userstore.UserStoreImpl;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.apache.thrift.protocol.TBinaryProtocol;
	import org.apache.thrift.protocol.TProtocol;
	import org.apache.thrift.transport.THttpClient;
	import org.apache.thrift.transport.TTransport;
	import org.robotlegs.mvcs.Actor;
	import org.syncon.evernote.events.EvernoteServiceEvent;

	public class EvernoteService extends Actor implements IEvernoteService
	{
		//private var service:FlickrService;
		
		protected  var API_CONSUMER_KEY : String = "brthrmnss";
		protected  var API_CONSUMER_SECRET : String = "770a8c70efe93e94";
		public static  var edamBaseUrl  : String = "https://sandbox.evernote.com";
		protected var  userStoreUrl :String= edamBaseUrl + "/edam/user";
		//protected var  noteStoreUrl :String= edamBaseUrl + "/edam/user";		
		protected static var xmlHeader  : String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		protected static var docType  : String = "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">";
		protected static var tNoteOpen  : String = "<en-note>";
		protected static var tNoteClose  : String = "</en-note>";
				
		public var userStore : UserStore; 
		public var  noteStore : NoteStore ;
		public var user : User; 
		public var  auth : AuthenticationResult;
		
		
		public var username : String = ''; 
		public var password : String = ''; 
		
		
		public function EvernoteService()
		{
			//this.service = new FlickrService(FLICKR_API_KEY);
		}
		
		/**
		 * In attempt to replicate AsyncToken functionality, 
		 * each message is given a sequence number. 
		 * this will be dispatched with the recieving event
		 * */
		public function getSequenceNumber()  : int
		{
			var noteStoreUnCast : Object =  noteStore as Object 
			var iprot_ : Object = noteStoreUnCast.iprot_
			var lastMessageSequenceNumber : int  =	iprot_.lastMessageSequenceNumber()
			trace( 'old sequence number ' + lastMessageSequenceNumber )
			return lastMessageSequenceNumber;
	}
	
		public function incrementSequence() : int
		{
			var noteStoreUnCast : Object =  noteStore as Object 
			if ( noteStoreUnCast.seqid_ > 10000 )
			{
				noteStoreUnCast.seqid = 0
			}
			else
				noteStoreUnCast.seqid_++;
			trace ( 'calling service id ' + noteStoreUnCast.seqid_ );
			return noteStoreUnCast.seqid_
		}			
		
		public function newNote(title:String, contents:String):Note
		{
			var note : Note = new Note()
			note.title = title; 
			note.content = contents
			
			return note
		}
		
		public function  getAuth(  login : String, pwrd : String ) : void//; // AuthenticationResult
		{
			
			this.username  = login;
			this.password =    pwrd; 
			var  userStoreTransport : TTransport = new THttpClient( new URLRequest(userStoreUrl), false );
			var  userStoreProtocol :  TProtocol = new TBinaryProtocol(userStoreTransport);
			userStore = new UserStoreImpl(userStoreProtocol)
				//var ee : com.evernote.edam.userstore.Constants
			userStore.checkVersion("Evernote Windows/3.0.1; Windows/XP SP3",
				com.evernote.edam.userstore.Constants.EDAM_VERSION_MAJOR,
				com.evernote.edam.userstore.Constants.EDAM_VERSION_MINOR,  this.handleCheckVersionFault, this.handleCheckVersionResult  );
			/*	if (!versionOK)
			{
			return;
			}*/
			
			
			//var  authResult :  AuthenticationResult=
			//user = authResult.User;
			//return authResult;
		}		
		
		public function  refreshAuthentication(   ) : void 
		{
			userStore.refreshAuthentication( this.auth.authenticationToken, refreshAuthenticationFaultHandler, refreshAuthenticationResultHandler )
		}			
			private function refreshAuthenticationResultHandler(result:AuthenticationResult=null):void {
				var temp : AuthenticationResult = this.auth
				this.auth = result
				result.user = temp.user; 
				this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.REFRESH_AUTHENTICATION, result, this.getSequenceNumber() )) 
			}
			private function refreshAuthenticationFaultHandler(result:Object=null):void {
				this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.REFRESH_AUTHENTICATION_FAULT, result, this.getSequenceNumber() )) 
			}
				
		
		public function handleCheckVersionResult(e:Object=null):void
		{
			userStore.authenticate(username,  password, this.API_CONSUMER_KEY, this.API_CONSUMER_SECRET,  handleAuthenticateFault, handleAuthenticateResult );

		}
		
		public function handleCheckVersionFault(e:Object=null):void
		{
			this.handleAuthenticateFault( e )
		}				
		
		public function handleAuthenticateResult(e: AuthenticationResult=null):void
		{
			this.auth = e
			var  noteStoreUrl : String = edamBaseUrl + "/edam/note/" + this.auth.user.shardId
			var noteStoreTransport :  TTransport  = new THttpClient( new URLRequest(noteStoreUrl), false);
			var  noteStoreProtocol : TProtocol = new TBinaryProtocol(noteStoreTransport);
			this.noteStore =  new NoteStoreImpl(noteStoreProtocol);			
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.AUTH_GET, e ) ) 
		}
 
		
		public function handleAuthenticateFault(e:Object=null):void
		{
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.AUTH_GET_FAULT, e ) ) 
		}
		
		
		
		public function createNoteFilter(order:int,ascending:Boolean,words:String, 
										 notebookGuid:String, timeZone:String, inactive:Boolean=false):NoteFilter
		{
			var filter:NoteFilter=new NoteFilter()
				filter.ascending = ascending
				filter.order = order
				filter.words = words
				filter.notebookGuid  = notebookGuid
				filter.inactive = inactive
			return filter
		}
	 
 
		public function getSyncState():void { 
			//this.incrementsequence()
			noteStore.getSyncState(this.auth.authenticationToken, getSyncStateFaultHandler, getSyncStateResultHandler)
		}
		private function getSyncStateResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SYNC_STATE, result, this.getSequenceNumber() )) 
		}
		private function getSyncStateFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SYNC_STATE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getSyncChunk(afterUSN:int, maxEntries:int=0, fullSyncOnly:Boolean=false):void { 
			//this.incrementsequence()
			noteStore.getSyncChunk(this.auth.authenticationToken, afterUSN, maxEntries, fullSyncOnly, getSyncChunkFaultHandler, getSyncChunkResultHandler)
		}
		private function getSyncChunkResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SYNC_CHUNK, result, this.getSequenceNumber() )) 
		}
		private function getSyncChunkFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SYNC_CHUNK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function listNotebooks():void { 
			//this.incrementsequence()
			noteStore.listNotebooks(this.auth.authenticationToken, listNotebooksFaultHandler, listNotebooksResultHandler)
		}
		private function listNotebooksResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_NOTEBOOKS, result, this.getSequenceNumber() )) 
		}
		private function listNotebooksFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_NOTEBOOKS_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getNotebook(guid:String):void { 
			//this.incrementsequence()
			noteStore.getNotebook(this.auth.authenticationToken, guid, getNotebookFaultHandler, getNotebookResultHandler)
		}
		private function getNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function getNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getDefaultNotebook():void { 
			//this.incrementsequence()
			noteStore.getDefaultNotebook(this.auth.authenticationToken, getDefaultNotebookFaultHandler, getDefaultNotebookResultHandler)
		}
		private function getDefaultNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_DEFAULT_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function getDefaultNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_DEFAULT_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function createNotebook(notebook:Notebook):void { 
			//this.incrementsequence()
			noteStore.createNotebook(this.auth.authenticationToken, notebook, createNotebookFaultHandler, createNotebookResultHandler)
		}
		private function createNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function createNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function updateNotebook(notebook:Notebook):void { 
			//this.incrementsequence()
			noteStore.updateNotebook(this.auth.authenticationToken, notebook, updateNotebookFaultHandler, updateNotebookResultHandler)
		}
		private function updateNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function updateNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function expungeNotebook(guid:String):void { 
			//this.incrementsequence()
			noteStore.expungeNotebook(this.auth.authenticationToken, guid, expungeNotebookFaultHandler, expungeNotebookResultHandler)
		}
		private function expungeNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function expungeNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function listTags():void { 
			//this.incrementsequence()
			noteStore.listTags(this.auth.authenticationToken, listTagsFaultHandler, listTagsResultHandler)
		}
		private function listTagsResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_TAGS, result, this.getSequenceNumber() )) 
		}
		private function listTagsFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_TAGS_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function listTagsByNotebook(notebookGuid:String):void { 
			//this.incrementsequence()
			noteStore.listTagsByNotebook(this.auth.authenticationToken, notebookGuid, listTagsByNotebookFaultHandler, listTagsByNotebookResultHandler)
		}
		private function listTagsByNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_TAGS_BY_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function listTagsByNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_TAGS_BY_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getTag(guid:String):void { 
			//this.incrementsequence()
			noteStore.getTag(this.auth.authenticationToken, guid, getTagFaultHandler, getTagResultHandler)
		}
		private function getTagResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_TAG, result, this.getSequenceNumber() )) 
		}
		private function getTagFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_TAG_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function createTag(tag:Tag):void { 
			//this.incrementsequence()
			noteStore.createTag(this.auth.authenticationToken, tag, createTagFaultHandler, createTagResultHandler)
		}
		private function createTagResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_TAG, result, this.getSequenceNumber() )) 
		}
		private function createTagFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_TAG_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function updateTag(tag:Tag):void { 
			//this.incrementsequence()
			noteStore.updateTag(this.auth.authenticationToken, tag, updateTagFaultHandler, updateTagResultHandler)
		}
		private function updateTagResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_TAG, result, this.getSequenceNumber() )) 
		}
		private function updateTagFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_TAG_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function untagAll(guid:String):void { 
			//this.incrementsequence()
			noteStore.untagAll(this.auth.authenticationToken, guid, untagAllFaultHandler, untagAllResultHandler)
		}
		private function untagAllResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UNTAG_ALL, result, this.getSequenceNumber() )) 
		}
		private function untagAllFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UNTAG_ALL_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function expungeTag(guid:String):void { 
			//this.incrementsequence()
			noteStore.expungeTag(this.auth.authenticationToken, guid, expungeTagFaultHandler, expungeTagResultHandler)
		}
		private function expungeTagResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_TAG, result, this.getSequenceNumber() )) 
		}
		private function expungeTagFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_TAG_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function listSearches():void { 
			//this.incrementsequence()
			noteStore.listSearches(this.auth.authenticationToken, listSearchesFaultHandler, listSearchesResultHandler)
		}
		private function listSearchesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_SEARCHES, result, this.getSequenceNumber() )) 
		}
		private function listSearchesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_SEARCHES_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getSearch(guid:String):void { 
			//this.incrementsequence()
			noteStore.getSearch(this.auth.authenticationToken, guid, getSearchFaultHandler, getSearchResultHandler)
		}
		private function getSearchResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SEARCH, result, this.getSequenceNumber() )) 
		}
		private function getSearchFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SEARCH_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function createSearch(search:SavedSearch):void { 
			//this.incrementsequence()
			noteStore.createSearch(this.auth.authenticationToken, search, createSearchFaultHandler, createSearchResultHandler)
		}
		private function createSearchResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_SEARCH, result, this.getSequenceNumber() )) 
		}
		private function createSearchFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_SEARCH_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function updateSearch(search:SavedSearch):void { 
			//this.incrementsequence()
			noteStore.updateSearch(this.auth.authenticationToken, search, updateSearchFaultHandler, updateSearchResultHandler)
		}
		private function updateSearchResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_SEARCH, result, this.getSequenceNumber() )) 
		}
		private function updateSearchFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_SEARCH_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function expungeSearch(guid:String):void { 
			//this.incrementsequence()
			noteStore.expungeSearch(this.auth.authenticationToken, guid, expungeSearchFaultHandler, expungeSearchResultHandler)
		}
		private function expungeSearchResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_SEARCH, result, this.getSequenceNumber() )) 
		}
		private function expungeSearchFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_SEARCH_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function findNotes(filter:NoteFilter=null, offset:int=0, maxNotes:int=0):void {
			if ( filter == null ) filter =  new NoteFilter()
			if ( maxNotes == 0 ) maxNotes = 1000;
			//this.incrementsequence()
			noteStore.findNotes(this.auth.authenticationToken, filter, offset, maxNotes, findNotesFaultHandler, findNotesResultHandler)
		}
		private function findNotesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.FIND_NOTES, result, this.getSequenceNumber() )) 
		}
		private function findNotesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.FIND_NOTES_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function findNoteCounts(filter:NoteFilter, withTrash:Boolean=false):void { 
			//this.incrementsequence()
			noteStore.findNoteCounts(this.auth.authenticationToken, filter, withTrash, findNoteCountsFaultHandler, findNoteCountsResultHandler)
		}
		private function findNoteCountsResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.FIND_NOTE_COUNTS, result, this.getSequenceNumber() )) 
		}
		private function findNoteCountsFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.FIND_NOTE_COUNTS_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getNote(guid:String, withContent:Boolean=false, withResourcesData:Boolean=false, withResourcesRecognition:Boolean=false, withResourcesAlternateData:Boolean=false):void { 
			//this.incrementsequence()
			noteStore.getNote(this.auth.authenticationToken, guid, withContent, withResourcesData, withResourcesRecognition, withResourcesAlternateData, getNoteFaultHandler, getNoteResultHandler)
		}
		private function getNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE, result, this.getSequenceNumber() )) 
		}
		private function getNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getNoteContent(guid:String):void { 
			//this.incrementsequence()
			noteStore.getNoteContent(this.auth.authenticationToken, guid, getNoteContentFaultHandler, getNoteContentResultHandler)
		}
		private function getNoteContentResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_CONTENT, result, this.getSequenceNumber() )) 
		}
		private function getNoteContentFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_CONTENT_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getNoteSearchText(guid:String):void { 
			//this.incrementsequence()
			noteStore.getNoteSearchText(this.auth.authenticationToken, guid, getNoteSearchTextFaultHandler, getNoteSearchTextResultHandler)
		}
		private function getNoteSearchTextResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_SEARCH_TEXT, result, this.getSequenceNumber() )) 
		}
		private function getNoteSearchTextFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_SEARCH_TEXT_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getNoteTagNames(guid:String):void { 
			//this.incrementsequence()
			noteStore.getNoteTagNames(this.auth.authenticationToken, guid, getNoteTagNamesFaultHandler, getNoteTagNamesResultHandler)
		}
		private function getNoteTagNamesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_TAG_NAMES, result, this.getSequenceNumber() )) 
		}
		private function getNoteTagNamesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_TAG_NAMES_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function createNote(note:Note):void { 
			//this.incrementsequence()
			noteStore.createNote(this.auth.authenticationToken, note, createNoteFaultHandler, createNoteResultHandler)
		}
		private function createNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_NOTE, result, this.getSequenceNumber() )) 
		}
		private function createNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_NOTE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function updateNote(note:Note):void { 
			//this.incrementsequence()
			noteStore.updateNote(this.auth.authenticationToken, note, updateNoteFaultHandler, updateNoteResultHandler)
		}
		private function updateNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_NOTE, result, this.getSequenceNumber() )) 
		}
		private function updateNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_NOTE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function deleteNote(guid:String):void { 
			//this.incrementsequence()
			noteStore.deleteNote(this.auth.authenticationToken, guid, deleteNoteFaultHandler, deleteNoteResultHandler)
		}
		private function deleteNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.DELETE_NOTE, result, this.getSequenceNumber() )) 
		}
		private function deleteNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.DELETE_NOTE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function expungeNote(guid:String):void { 
			//this.incrementsequence()
			noteStore.expungeNote(this.auth.authenticationToken, guid, expungeNoteFaultHandler, expungeNoteResultHandler)
		}
		private function expungeNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTE, result, this.getSequenceNumber() )) 
		}
		private function expungeNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function expungeNotes(noteGuids:Array):void { 
			//this.incrementsequence()
			noteStore.expungeNotes(this.auth.authenticationToken, noteGuids, expungeNotesFaultHandler, expungeNotesResultHandler)
		}
		private function expungeNotesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTES, result, this.getSequenceNumber() )) 
		}
		private function expungeNotesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTES_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function expungeInactiveNotes():void { 
			//this.incrementsequence()
			noteStore.expungeInactiveNotes(this.auth.authenticationToken, expungeInactiveNotesFaultHandler, expungeInactiveNotesResultHandler)
		}
		private function expungeInactiveNotesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_INACTIVE_NOTES, result, this.getSequenceNumber() )) 
		}
		private function expungeInactiveNotesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_INACTIVE_NOTES_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function copyNote(noteGuid:String, toNotebookGuid:String=""):void { 
			//this.incrementsequence()
			noteStore.copyNote(this.auth.authenticationToken, noteGuid, toNotebookGuid, copyNoteFaultHandler, copyNoteResultHandler)
		}
		private function copyNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.COPY_NOTE, result, this.getSequenceNumber() )) 
		}
		private function copyNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.COPY_NOTE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function listNoteVersions(noteGuid:String):void { 
			//this.incrementsequence()
			noteStore.listNoteVersions(this.auth.authenticationToken, noteGuid, listNoteVersionsFaultHandler, listNoteVersionsResultHandler)
		}
		private function listNoteVersionsResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_NOTE_VERSIONS, result, this.getSequenceNumber() )) 
		}
		private function listNoteVersionsFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_NOTE_VERSIONS_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getNoteVersion(noteGuid:String, updateSequenceNum:int=0, withResourcesData:Boolean=false, withResourcesRecognition:Boolean=false, withResourcesAlternateData:Boolean=false):void { 
			//this.incrementsequence()
			noteStore.getNoteVersion(this.auth.authenticationToken, noteGuid, updateSequenceNum, withResourcesData, withResourcesRecognition, withResourcesAlternateData, getNoteVersionFaultHandler, getNoteVersionResultHandler)
		}
		private function getNoteVersionResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_VERSION, result, this.getSequenceNumber() )) 
		}
		private function getNoteVersionFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_VERSION_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getResource(guid:String, withData:Boolean=false, withRecognition:Boolean=false, withAttributes:Boolean=false, withAlternateData:Boolean=false):void { 
			//this.incrementsequence()
			noteStore.getResource(this.auth.authenticationToken, guid, withData, withRecognition, withAttributes, withAlternateData, getResourceFaultHandler, getResourceResultHandler)
		}
		private function getResourceResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE, result, this.getSequenceNumber() )) 
		}
		private function getResourceFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function updateResource(resource:Resource):void { 
			//this.incrementsequence()
			noteStore.updateResource(this.auth.authenticationToken, resource, updateResourceFaultHandler, updateResourceResultHandler)
		}
		private function updateResourceResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_RESOURCE, result, this.getSequenceNumber() )) 
		}
		private function updateResourceFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_RESOURCE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getResourceData(guid:String):void { 
			//this.incrementsequence()
			noteStore.getResourceData(this.auth.authenticationToken, guid, getResourceDataFaultHandler, getResourceDataResultHandler)
		}
		private function getResourceDataResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_DATA, result, this.getSequenceNumber() )) 
		}
		private function getResourceDataFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_DATA_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getResourceByHash(noteGuid:String, contentHash:ByteArray=null, withData:Boolean=false, withRecognition:Boolean=false, withAlternateData:Boolean=false):void { 
			//this.incrementsequence()
			noteStore.getResourceByHash(this.auth.authenticationToken, noteGuid, contentHash, withData, withRecognition, withAlternateData, getResourceByHashFaultHandler, getResourceByHashResultHandler)
		}
		private function getResourceByHashResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_BY_HASH, result, this.getSequenceNumber() )) 
		}
		private function getResourceByHashFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_BY_HASH_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getResourceRecognition(guid:String):void { 
			//this.incrementsequence()
			noteStore.getResourceRecognition(this.auth.authenticationToken, guid, getResourceRecognitionFaultHandler, getResourceRecognitionResultHandler)
		}
		private function getResourceRecognitionResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_RECOGNITION, result, this.getSequenceNumber() )) 
		}
		private function getResourceRecognitionFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_RECOGNITION_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getResourceAlternateData(guid:String):void { 
			//this.incrementsequence()
			noteStore.getResourceAlternateData(this.auth.authenticationToken, guid, getResourceAlternateDataFaultHandler, getResourceAlternateDataResultHandler)
		}
		private function getResourceAlternateDataResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_ALTERNATE_DATA, result, this.getSequenceNumber() )) 
		}
		private function getResourceAlternateDataFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_ALTERNATE_DATA_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getResourceAttributes(guid:String):void { 
			//this.incrementsequence()
			noteStore.getResourceAttributes(this.auth.authenticationToken, guid, getResourceAttributesFaultHandler, getResourceAttributesResultHandler)
		}
		private function getResourceAttributesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_ATTRIBUTES, result, this.getSequenceNumber() )) 
		}
		private function getResourceAttributesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_ATTRIBUTES_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getAccountSize():void { 
			//this.incrementsequence()
			noteStore.getAccountSize(this.auth.authenticationToken, getAccountSizeFaultHandler, getAccountSizeResultHandler)
		}
		private function getAccountSizeResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_ACCOUNT_SIZE, result, this.getSequenceNumber() )) 
		}
		private function getAccountSizeFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_ACCOUNT_SIZE_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getAds(adParameters:AdParameters):void { 
			//this.incrementsequence()
			noteStore.getAds(this.auth.authenticationToken, adParameters, getAdsFaultHandler, getAdsResultHandler)
		}
		private function getAdsResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_ADS, result, this.getSequenceNumber() )) 
		}
		private function getAdsFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_ADS_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getRandomAd(adParameters:AdParameters):void { 
			//this.incrementsequence()
			noteStore.getRandomAd(this.auth.authenticationToken, adParameters, getRandomAdFaultHandler, getRandomAdResultHandler)
		}
		private function getRandomAdResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RANDOM_AD, result, this.getSequenceNumber() )) 
		}
		private function getRandomAdFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RANDOM_AD_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getPublicNotebook(userId:Number, publicUri:String=""):void { 
			//this.incrementsequence()
			noteStore.getPublicNotebook(userId, publicUri, getPublicNotebookFaultHandler, getPublicNotebookResultHandler)
		}
		private function getPublicNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_PUBLIC_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function getPublicNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_PUBLIC_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function createSharedNotebook(sharedNotebook:SharedNotebook):void { 
			//this.incrementsequence()
			noteStore.createSharedNotebook(this.auth.authenticationToken, sharedNotebook, createSharedNotebookFaultHandler, createSharedNotebookResultHandler)
		}
		private function createSharedNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_SHARED_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function createSharedNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_SHARED_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function listSharedNotebooks():void { 
			//this.incrementsequence()
			noteStore.listSharedNotebooks(this.auth.authenticationToken, listSharedNotebooksFaultHandler, listSharedNotebooksResultHandler)
		}
		private function listSharedNotebooksResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_SHARED_NOTEBOOKS, result, this.getSequenceNumber() )) 
		}
		private function listSharedNotebooksFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_SHARED_NOTEBOOKS_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function expungeSharedNotebooks(sharedNotebookIds:Array):void { 
			//this.incrementsequence()
			noteStore.expungeSharedNotebooks(this.auth.authenticationToken, sharedNotebookIds, expungeSharedNotebooksFaultHandler, expungeSharedNotebooksResultHandler)
		}
		private function expungeSharedNotebooksResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_SHARED_NOTEBOOKS, result, this.getSequenceNumber() )) 
		}
		private function expungeSharedNotebooksFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_SHARED_NOTEBOOKS_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function createLinkedNotebook(linkedNotebook:LinkedNotebook):void { 
			//this.incrementsequence()
			noteStore.createLinkedNotebook(this.auth.authenticationToken, linkedNotebook, createLinkedNotebookFaultHandler, createLinkedNotebookResultHandler)
		}
		private function createLinkedNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function createLinkedNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function updateLinkedNotebook(linkedNotebook:LinkedNotebook):void { 
			//this.incrementsequence()
			noteStore.updateLinkedNotebook(this.auth.authenticationToken, linkedNotebook, updateLinkedNotebookFaultHandler, updateLinkedNotebookResultHandler)
		}
		private function updateLinkedNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_LINKED_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function updateLinkedNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_LINKED_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function listLinkedNotebooks():void { 
			//this.incrementsequence()
			noteStore.listLinkedNotebooks(this.auth.authenticationToken, listLinkedNotebooksFaultHandler, listLinkedNotebooksResultHandler)
		}
		private function listLinkedNotebooksResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_LINKED_NOTEBOOKS, result, this.getSequenceNumber() )) 
		}
		private function listLinkedNotebooksFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_LINKED_NOTEBOOKS_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function expungeLinkedNotebook(linkedNotebookId:Number):void { 
			//this.incrementsequence()
			noteStore.expungeLinkedNotebook(this.auth.authenticationToken, linkedNotebookId, expungeLinkedNotebookFaultHandler, expungeLinkedNotebookResultHandler)
		}
		private function expungeLinkedNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_LINKED_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function expungeLinkedNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_LINKED_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function authenticateToSharedNotebook(shareKey:String, authenticationToken:String=""):void { 
			//this.incrementsequence()
			noteStore.authenticateToSharedNotebook(shareKey, this.auth.authenticationToken, authenticateToSharedNotebookFaultHandler, authenticateToSharedNotebookResultHandler)
		}
		private function authenticateToSharedNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK, result, this.getSequenceNumber() )) 
		}
		private function authenticateToSharedNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.AUTHENTICATE_TO_SHARED_NOTEBOOK_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function getSharedNotebookByAuth():void { 
			//this.incrementsequence()
			noteStore.getSharedNotebookByAuth(this.auth.authenticationToken, getSharedNotebookByAuthFaultHandler, getSharedNotebookByAuthResultHandler)
		}
		private function getSharedNotebookByAuthResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SHARED_NOTEBOOK_BY_AUTH, result, this.getSequenceNumber() )) 
		}
		private function getSharedNotebookByAuthFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SHARED_NOTEBOOK_BY_AUTH_FAULT, result, this.getSequenceNumber() )) 
		}
		
		
		public function emailNote(parameters:NoteEmailParameters):void { 
			//this.incrementsequence()
			noteStore.emailNote(this.auth.authenticationToken, parameters, emailNoteFaultHandler, emailNoteResultHandler)
		}
		private function emailNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EMAIL_NOTE, result, this.getSequenceNumber() )) 
		}
		private function emailNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EMAIL_NOTE_FAULT, result, this.getSequenceNumber() )) 
		}		
 
		
  
	}
}