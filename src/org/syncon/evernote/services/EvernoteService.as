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
		protected  var edamBaseUrl  : String = "https://sandbox.evernote.com";
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
		
		public function handleCheckVersionResult(e:Object=null):void
		{
			userStore.authenticate(username,  password, this.API_CONSUMER_KEY, this.API_CONSUMER_SECRET,  handleAuthenticateFault, handleAuthenticateResult );

		}
		
		public function handleCheckVersionFault(e:Object=null):void
		{
			
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
	 
 
		
		public function getSyncChunk(afterUSN:int, maxEntries:int=0, fullSyncOnly:Boolean=false):void {
			noteStore.getSyncChunk(this.auth.authenticationToken, afterUSN, maxEntries, fullSyncOnly, getSyncChunkFaultHandler, getSyncChunkResultHandler)
		}
		private function getSyncChunkResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SYNC_CHUNK, result)) 
		}
		private function getSyncChunkFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SYNC_CHUNK_FAULT, result)) 
		}
		
		
		public function getNotebook(guid:String):void {
			noteStore.getNotebook(this.auth.authenticationToken, guid, getNotebookFaultHandler, getNotebookResultHandler)
		}
		private function getNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTEBOOK, result)) 
		}
		private function getNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function createNotebook(notebook:Notebook):void {
			noteStore.createNotebook(this.auth.authenticationToken, notebook, createNotebookFaultHandler, createNotebookResultHandler)
		}
		private function createNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_NOTEBOOK, result)) 
		}
		private function createNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function updateNotebook(notebook:Notebook):void {
			noteStore.updateNotebook(this.auth.authenticationToken, notebook, updateNotebookFaultHandler, updateNotebookResultHandler)
		}
		private function updateNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_NOTEBOOK, result)) 
		}
		private function updateNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function expungeNotebook(guid:String):void {
			noteStore.expungeNotebook(this.auth.authenticationToken, guid, expungeNotebookFaultHandler, expungeNotebookResultHandler)
		}
		private function expungeNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTEBOOK, result)) 
		}
		private function expungeNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function listTagsByNotebook(notebookGuid:String):void {
			noteStore.listTagsByNotebook(this.auth.authenticationToken, notebookGuid, listTagsByNotebookFaultHandler, listTagsByNotebookResultHandler)
		}
		private function listTagsByNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_TAGS_BY_NOTEBOOK, result)) 
		}
		private function listTagsByNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_TAGS_BY_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function getTag(guid:String):void {
			noteStore.getTag(this.auth.authenticationToken, guid, getTagFaultHandler, getTagResultHandler)
		}
		private function getTagResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_TAG, result)) 
		}
		private function getTagFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_TAG_FAULT, result)) 
		}
		
		
		public function createTag(tag:Tag):void {
			noteStore.createTag(this.auth.authenticationToken, tag, createTagFaultHandler, createTagResultHandler)
		}
		private function createTagResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_TAG, result)) 
		}
		private function createTagFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_TAG_FAULT, result)) 
		}
		
		
		public function updateTag(tag:Tag):void {
			noteStore.updateTag(this.auth.authenticationToken, tag, updateTagFaultHandler, updateTagResultHandler)
		}
		private function updateTagResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_TAG, result)) 
		}
		private function updateTagFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_TAG_FAULT, result)) 
		}
		
		
		public function untagAll(guid:String):void {
			noteStore.untagAll(this.auth.authenticationToken, guid, untagAllFaultHandler, untagAllResultHandler)
		}
		private function untagAllResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UNTAG_ALL, result)) 
		}
		private function untagAllFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UNTAG_ALL_FAULT, result)) 
		}
		
		
		public function expungeTag(guid:String):void {
			noteStore.expungeTag(this.auth.authenticationToken, guid, expungeTagFaultHandler, expungeTagResultHandler)
		}
		private function expungeTagResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_TAG, result)) 
		}
		private function expungeTagFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_TAG_FAULT, result)) 
		}
		
		
		public function getSearch(guid:String):void {
			noteStore.getSearch(this.auth.authenticationToken, guid, getSearchFaultHandler, getSearchResultHandler)
		}
		private function getSearchResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SEARCH, result)) 
		}
		private function getSearchFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_SEARCH_FAULT, result)) 
		}
		
		
		public function createSearch(search:SavedSearch):void {
			noteStore.createSearch(this.auth.authenticationToken, search, createSearchFaultHandler, createSearchResultHandler)
		}
		private function createSearchResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_SEARCH, result)) 
		}
		private function createSearchFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_SEARCH_FAULT, result)) 
		}
		
		
		public function updateSearch(search:SavedSearch):void {
			noteStore.updateSearch(this.auth.authenticationToken, search, updateSearchFaultHandler, updateSearchResultHandler)
		}
		private function updateSearchResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_SEARCH, result)) 
		}
		private function updateSearchFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_SEARCH_FAULT, result)) 
		}
		
		
		public function expungeSearch(guid:String):void {
			noteStore.expungeSearch(this.auth.authenticationToken, guid, expungeSearchFaultHandler, expungeSearchResultHandler)
		}
		private function expungeSearchResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_SEARCH, result)) 
		}
		private function expungeSearchFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_SEARCH_FAULT, result)) 
		}
		
		
		public function findNotes(filter:NoteFilter, offset:int=0, maxNotes:int=0):void {
			noteStore.findNotes(this.auth.authenticationToken, filter, offset, maxNotes, findNotesFaultHandler, findNotesResultHandler)
		}
		private function findNotesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.FIND_NOTES, result)) 
		}
		private function findNotesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.FIND_NOTES_FAULT, result)) 
		}
		
		
		public function findNoteCounts(filter:NoteFilter=null, withTrash:Boolean=false):void {
			if ( filter == null ) {filter = new NoteFilter }
			trace( 'seq ' + ( noteStore as NoteStoreImpl).seqid_ )
			noteStore.findNoteCounts(this.auth.authenticationToken, filter, withTrash, findNoteCountsFaultHandler, findNoteCountsResultHandler)
		}
		private function findNoteCountsResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.FIND_NOTE_COUNTS, result)) 
		}
		private function findNoteCountsFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.FIND_NOTE_COUNTS_FAULT, result)) 
		}
		
		
		public function getNote(guid:String, withContent:Boolean=false, withResourcesData:Boolean=false, withResourcesRecognition:Boolean=false, withResourcesAlternateData:Boolean=false):void {
			noteStore.getNote(this.auth.authenticationToken, guid, withContent, withResourcesData, withResourcesRecognition, withResourcesAlternateData, getNoteFaultHandler, getNoteResultHandler)
		}
		private function getNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE, result)) 
		}
		private function getNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_FAULT, result)) 
		}
		
		
		public function getNoteContent(guid:String):void {
			noteStore.getNoteContent(this.auth.authenticationToken, guid, getNoteContentFaultHandler, getNoteContentResultHandler)
		}
		private function getNoteContentResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_CONTENT, result)) 
		}
		private function getNoteContentFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_CONTENT_FAULT, result)) 
		}
		
		
		public function getNoteSearchText(guid:String):void {
			noteStore.getNoteSearchText(this.auth.authenticationToken, guid, getNoteSearchTextFaultHandler, getNoteSearchTextResultHandler)
		}
		private function getNoteSearchTextResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_SEARCH_TEXT, result)) 
		}
		private function getNoteSearchTextFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_SEARCH_TEXT_FAULT, result)) 
		}
		
		
		public function getNoteTagNames(guid:String):void {
			noteStore.getNoteTagNames(this.auth.authenticationToken, guid, getNoteTagNamesFaultHandler, getNoteTagNamesResultHandler)
		}
		private function getNoteTagNamesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_TAG_NAMES, result)) 
		}
		private function getNoteTagNamesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_TAG_NAMES_FAULT, result)) 
		}
		
		
		public function createNote(note:Note):void {
			noteStore.createNote(this.auth.authenticationToken, note, createNoteFaultHandler, createNoteResultHandler)
		}
		private function createNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_NOTE, result)) 
		}
		private function createNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_NOTE_FAULT, result)) 
		}
		
		
		public function updateNote(note:Note):void {
			noteStore.updateNote(this.auth.authenticationToken, note, updateNoteFaultHandler, updateNoteResultHandler)
		}
		private function updateNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_NOTE, result)) 
		}
		private function updateNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_NOTE_FAULT, result)) 
		}
		
		
		public function deleteNote(guid:String):void {
			noteStore.deleteNote(this.auth.authenticationToken, guid, deleteNoteFaultHandler, deleteNoteResultHandler)
		}
		private function deleteNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.DELETE_NOTE, result)) 
		}
		private function deleteNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.DELETE_NOTE_FAULT, result)) 
		}
		
		
		public function expungeNote(guid:String):void {
			noteStore.expungeNote(this.auth.authenticationToken, guid, expungeNoteFaultHandler, expungeNoteResultHandler)
		}
		private function expungeNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTE, result)) 
		}
		private function expungeNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTE_FAULT, result)) 
		}
		
		
		public function expungeNotes(noteGuids:Array):void {
			noteStore.expungeNotes(this.auth.authenticationToken, noteGuids, expungeNotesFaultHandler, expungeNotesResultHandler)
		}
		private function expungeNotesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTES, result)) 
		}
		private function expungeNotesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_NOTES_FAULT, result)) 
		}
		
		
		public function copyNote(noteGuid:String, toNotebookGuid:String=""):void {
			noteStore.copyNote(this.auth.authenticationToken, noteGuid, toNotebookGuid, copyNoteFaultHandler, copyNoteResultHandler)
		}
		private function copyNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.COPY_NOTE, result)) 
		}
		private function copyNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.COPY_NOTE_FAULT, result)) 
		}
		
		
		public function listNoteVersions(noteGuid:String):void {
			noteStore.listNoteVersions(this.auth.authenticationToken, noteGuid, listNoteVersionsFaultHandler, listNoteVersionsResultHandler)
		}
		private function listNoteVersionsResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_NOTE_VERSIONS, result)) 
		}
		private function listNoteVersionsFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.LIST_NOTE_VERSIONS_FAULT, result)) 
		}
		
		
		public function getNoteVersion(noteGuid:String, updateSequenceNum:int=0, withResourcesData:Boolean=false, withResourcesRecognition:Boolean=false, withResourcesAlternateData:Boolean=false):void {
			noteStore.getNoteVersion(this.auth.authenticationToken, noteGuid, updateSequenceNum, withResourcesData, withResourcesRecognition, withResourcesAlternateData, getNoteVersionFaultHandler, getNoteVersionResultHandler)
		}
		private function getNoteVersionResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_VERSION, result)) 
		}
		private function getNoteVersionFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_NOTE_VERSION_FAULT, result)) 
		}
		
		
		public function getResource(guid:String, withData:Boolean=false, withRecognition:Boolean=false, withAttributes:Boolean=false, withAlternateData:Boolean=false):void {
			noteStore.getResource(this.auth.authenticationToken, guid, withData, withRecognition, withAttributes, withAlternateData, getResourceFaultHandler, getResourceResultHandler)
		}
		private function getResourceResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE, result)) 
		}
		private function getResourceFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_FAULT, result)) 
		}
		
		
		public function updateResource(resource:Resource):void {
			noteStore.updateResource(this.auth.authenticationToken, resource, updateResourceFaultHandler, updateResourceResultHandler)
		}
		private function updateResourceResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_RESOURCE, result)) 
		}
		private function updateResourceFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_RESOURCE_FAULT, result)) 
		}
		
		
		public function getResourceData(guid:String):void {
			noteStore.getResourceData(this.auth.authenticationToken, guid, getResourceDataFaultHandler, getResourceDataResultHandler)
		}
		private function getResourceDataResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_DATA, result)) 
		}
		private function getResourceDataFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_DATA_FAULT, result)) 
		}
		
		
		public function getResourceByHash(noteGuid:String, contentHash:ByteArray=null, withData:Boolean=false, withRecognition:Boolean=false, withAlternateData:Boolean=false):void {
			noteStore.getResourceByHash(this.auth.authenticationToken, noteGuid, contentHash, withData, withRecognition, withAlternateData, getResourceByHashFaultHandler, getResourceByHashResultHandler)
		}
		private function getResourceByHashResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_BY_HASH, result)) 
		}
		private function getResourceByHashFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_BY_HASH_FAULT, result)) 
		}
		
		
		public function getResourceRecognition(guid:String):void {
			noteStore.getResourceRecognition(this.auth.authenticationToken, guid, getResourceRecognitionFaultHandler, getResourceRecognitionResultHandler)
		}
		private function getResourceRecognitionResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_RECOGNITION, result)) 
		}
		private function getResourceRecognitionFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_RECOGNITION_FAULT, result)) 
		}
		
		
		public function getResourceAlternateData(guid:String):void {
			noteStore.getResourceAlternateData(this.auth.authenticationToken, guid, getResourceAlternateDataFaultHandler, getResourceAlternateDataResultHandler)
		}
		private function getResourceAlternateDataResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_ALTERNATE_DATA, result)) 
		}
		private function getResourceAlternateDataFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_ALTERNATE_DATA_FAULT, result)) 
		}
		
		
		public function getResourceAttributes(guid:String):void {
			noteStore.getResourceAttributes(this.auth.authenticationToken, guid, getResourceAttributesFaultHandler, getResourceAttributesResultHandler)
		}
		private function getResourceAttributesResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_ATTRIBUTES, result)) 
		}
		private function getResourceAttributesFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RESOURCE_ATTRIBUTES_FAULT, result)) 
		}
		
		
		public function getAds(adParameters:AdParameters):void {
			noteStore.getAds(this.auth.authenticationToken, adParameters, getAdsFaultHandler, getAdsResultHandler)
		}
		private function getAdsResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_ADS, result)) 
		}
		private function getAdsFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_ADS_FAULT, result)) 
		}
		
		
		public function getRandomAd(adParameters:AdParameters):void {
			noteStore.getRandomAd(this.auth.authenticationToken, adParameters, getRandomAdFaultHandler, getRandomAdResultHandler)
		}
		private function getRandomAdResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RANDOM_AD, result)) 
		}
		private function getRandomAdFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_RANDOM_AD_FAULT, result)) 
		}
		
		
		public function getPublicNotebook(userId:int, publicUri:String=""):void {
			noteStore.getPublicNotebook(userId, publicUri, getPublicNotebookFaultHandler, getPublicNotebookResultHandler)
		}
		private function getPublicNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_PUBLIC_NOTEBOOK, result)) 
		}
		private function getPublicNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.GET_PUBLIC_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function createSharedNotebook(sharedNotebook:SharedNotebook):void {
			noteStore.createSharedNotebook(this.auth.authenticationToken, sharedNotebook, createSharedNotebookFaultHandler, createSharedNotebookResultHandler)
		}
		private function createSharedNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_SHARED_NOTEBOOK, result)) 
		}
		private function createSharedNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_SHARED_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function expungeSharedNotebooks(sharedNotebookIds:Array):void {
			noteStore.expungeSharedNotebooks(this.auth.authenticationToken, sharedNotebookIds, expungeSharedNotebooksFaultHandler, expungeSharedNotebooksResultHandler)
		}
		private function expungeSharedNotebooksResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_SHARED_NOTEBOOKS, result)) 
		}
		private function expungeSharedNotebooksFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_SHARED_NOTEBOOKS_FAULT, result)) 
		}
		
		
		public function createLinkedNotebook(linkedNotebook:LinkedNotebook):void {
			noteStore.createLinkedNotebook(this.auth.authenticationToken, linkedNotebook, createLinkedNotebookFaultHandler, createLinkedNotebookResultHandler)
		}
		private function createLinkedNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK, result)) 
		}
		private function createLinkedNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.CREATE_LINKED_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function updateLinkedNotebook(linkedNotebook:LinkedNotebook):void {
			noteStore.updateLinkedNotebook(this.auth.authenticationToken, linkedNotebook, updateLinkedNotebookFaultHandler, updateLinkedNotebookResultHandler)
		}
		private function updateLinkedNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_LINKED_NOTEBOOK, result)) 
		}
		private function updateLinkedNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.UPDATE_LINKED_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function expungeLinkedNotebook(linkedNotebookId:Number):void {
			noteStore.expungeLinkedNotebook(this.auth.authenticationToken, linkedNotebookId, expungeLinkedNotebookFaultHandler, expungeLinkedNotebookResultHandler)
		}
		private function expungeLinkedNotebookResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_LINKED_NOTEBOOK, result)) 
		}
		private function expungeLinkedNotebookFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EXPUNGE_LINKED_NOTEBOOK_FAULT, result)) 
		}
		
		
		public function string(shareKey:String, authenticationToken:String=""):void {
			//noteStore.string(shareKey, this.auth.authenticationToken, stringFaultHandler, stringResultHandler)
		}
		private function stringResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.STRING, result)) 
		}
		private function stringFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.STRING_FAULT, result)) 
		}
		
		
		public function emailNote(parameters:NoteEmailParameters):void {
			noteStore.emailNote(this.auth.authenticationToken, parameters, emailNoteFaultHandler, emailNoteResultHandler)
		}
		private function emailNoteResultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EMAIL_NOTE, result)) 
		}
		private function emailNoteFaultHandler(result:Object=null):void {
			this.dispatch( new EvernoteServiceEvent( EvernoteServiceEvent.EMAIL_NOTE_FAULT, result)) 
		}		
		
		
  
	}
}