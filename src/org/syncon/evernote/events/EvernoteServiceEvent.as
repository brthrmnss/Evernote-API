package  org.syncon.evernote.events
{
	/*
	import com.evernote.edam.notestore.AdImpressions;
	import com.evernote.edam.notestore.AdParameters;
	import com.evernote.edam.notestore.NoteCollectionCounts;
	import com.evernote.edam.notestore.NoteEmailParameters;
	import com.evernote.edam.notestore.NoteFilter;
	import com.evernote.edam.userstore.AuthenticationResult;
	*/
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class EvernoteServiceEvent extends Event
	{
		/**
		 * Noun + Verb
		 * smallest noun that is meaningful
		 * */
		public static const AUTH_GET:String = "authGet";
 
		public static const GET_SYNC_CHUNK:String = "getSyncChunkResult";		
		public static const GET_SYNC_CHUNK_FAULT:String = "getSyncChunkFault";
		
		public static const GET_NOTEBOOK:String = "getNotebookResult";		
		public static const GET_NOTEBOOK_FAULT:String = "getNotebookFault";
		
		public static const CREATE_NOTEBOOK:String = "createNotebookResult";		
		public static const CREATE_NOTEBOOK_FAULT:String = "createNotebookFault";
		
		public static const UPDATE_NOTEBOOK:String = "updateNotebookResult";		
		public static const UPDATE_NOTEBOOK_FAULT:String = "updateNotebookFault";
		
		public static const EXPUNGE_NOTEBOOK:String = "expungeNotebookResult";		
		public static const EXPUNGE_NOTEBOOK_FAULT:String = "expungeNotebookFault";
		
		public static const LIST_TAGS_BY_NOTEBOOK:String = "listTagsByNotebookResult";		
		public static const LIST_TAGS_BY_NOTEBOOK_FAULT:String = "listTagsByNotebookFault";
		
		public static const GET_TAG:String = "getTagResult";		
		public static const GET_TAG_FAULT:String = "getTagFault";
		
		public static const CREATE_TAG:String = "createTagResult";		
		public static const CREATE_TAG_FAULT:String = "createTagFault";
		
		public static const UPDATE_TAG:String = "updateTagResult";		
		public static const UPDATE_TAG_FAULT:String = "updateTagFault";
		
		public static const UNTAG_ALL:String = "untagAllResult";		
		public static const UNTAG_ALL_FAULT:String = "untagAllFault";
		
		public static const EXPUNGE_TAG:String = "expungeTagResult";		
		public static const EXPUNGE_TAG_FAULT:String = "expungeTagFault";
		
		public static const GET_SEARCH:String = "getSearchResult";		
		public static const GET_SEARCH_FAULT:String = "getSearchFault";
		
		public static const CREATE_SEARCH:String = "createSearchResult";		
		public static const CREATE_SEARCH_FAULT:String = "createSearchFault";
		
		public static const UPDATE_SEARCH:String = "updateSearchResult";		
		public static const UPDATE_SEARCH_FAULT:String = "updateSearchFault";
		
		public static const EXPUNGE_SEARCH:String = "expungeSearchResult";		
		public static const EXPUNGE_SEARCH_FAULT:String = "expungeSearchFault";
		
		public static const FIND_NOTES:String = "findNotesResult";		
		public static const FIND_NOTES_FAULT:String = "findNotesFault";
		
		public static const FIND_NOTE_COUNTS:String = "findNoteCountsResult";		
		public static const FIND_NOTE_COUNTS_FAULT:String = "findNoteCountsFault";
		
		public static const GET_NOTE:String = "getNoteResult";		
		public static const GET_NOTE_FAULT:String = "getNoteFault";
		
		public static const GET_NOTE_CONTENT:String = "getNoteContentResult";		
		public static const GET_NOTE_CONTENT_FAULT:String = "getNoteContentFault";
		
		public static const GET_NOTE_SEARCH_TEXT:String = "getNoteSearchTextResult";		
		public static const GET_NOTE_SEARCH_TEXT_FAULT:String = "getNoteSearchTextFault";
		
		public static const GET_NOTE_TAG_NAMES:String = "getNoteTagNamesResult";		
		public static const GET_NOTE_TAG_NAMES_FAULT:String = "getNoteTagNamesFault";
		
		public static const CREATE_NOTE:String = "createNoteResult";		
		public static const CREATE_NOTE_FAULT:String = "createNoteFault";
		
		public static const UPDATE_NOTE:String = "updateNoteResult";		
		public static const UPDATE_NOTE_FAULT:String = "updateNoteFault";
		
		public static const DELETE_NOTE:String = "deleteNoteResult";		
		public static const DELETE_NOTE_FAULT:String = "deleteNoteFault";
		
		public static const EXPUNGE_NOTE:String = "expungeNoteResult";		
		public static const EXPUNGE_NOTE_FAULT:String = "expungeNoteFault";
		
		public static const EXPUNGE_NOTES:String = "expungeNotesResult";		
		public static const EXPUNGE_NOTES_FAULT:String = "expungeNotesFault";
		
		public static const COPY_NOTE:String = "copyNoteResult";		
		public static const COPY_NOTE_FAULT:String = "copyNoteFault";
		
		public static const LIST_NOTE_VERSIONS:String = "listNoteVersionsResult";		
		public static const LIST_NOTE_VERSIONS_FAULT:String = "listNoteVersionsFault";
		
		public static const GET_NOTE_VERSION:String = "getNoteVersionResult";		
		public static const GET_NOTE_VERSION_FAULT:String = "getNoteVersionFault";
		
		public static const GET_RESOURCE:String = "getResourceResult";		
		public static const GET_RESOURCE_FAULT:String = "getResourceFault";
		
		public static const UPDATE_RESOURCE:String = "updateResourceResult";		
		public static const UPDATE_RESOURCE_FAULT:String = "updateResourceFault";
		
		public static const GET_RESOURCE_DATA:String = "getResourceDataResult";		
		public static const GET_RESOURCE_DATA_FAULT:String = "getResourceDataFault";
		
		public static const GET_RESOURCE_BY_HASH:String = "getResourceByHashResult";		
		public static const GET_RESOURCE_BY_HASH_FAULT:String = "getResourceByHashFault";
		
		public static const GET_RESOURCE_RECOGNITION:String = "getResourceRecognitionResult";		
		public static const GET_RESOURCE_RECOGNITION_FAULT:String = "getResourceRecognitionFault";
		
		public static const GET_RESOURCE_ALTERNATE_DATA:String = "getResourceAlternateDataResult";		
		public static const GET_RESOURCE_ALTERNATE_DATA_FAULT:String = "getResourceAlternateDataFault";
		
		public static const GET_RESOURCE_ATTRIBUTES:String = "getResourceAttributesResult";		
		public static const GET_RESOURCE_ATTRIBUTES_FAULT:String = "getResourceAttributesFault";
		
		public static const GET_ADS:String = "getAdsResult";		
		public static const GET_ADS_FAULT:String = "getAdsFault";
		
		public static const GET_RANDOM_AD:String = "getRandomAdResult";		
		public static const GET_RANDOM_AD_FAULT:String = "getRandomAdFault";
		
		public static const GET_PUBLIC_NOTEBOOK:String = "getPublicNotebookResult";		
		public static const GET_PUBLIC_NOTEBOOK_FAULT:String = "getPublicNotebookFault";
		
		public static const CREATE_SHARED_NOTEBOOK:String = "createSharedNotebookResult";		
		public static const CREATE_SHARED_NOTEBOOK_FAULT:String = "createSharedNotebookFault";
		
		public static const EXPUNGE_SHARED_NOTEBOOKS:String = "expungeSharedNotebooksResult";		
		public static const EXPUNGE_SHARED_NOTEBOOKS_FAULT:String = "expungeSharedNotebooksFault";
		
		public static const CREATE_LINKED_NOTEBOOK:String = "createLinkedNotebookResult";		
		public static const CREATE_LINKED_NOTEBOOK_FAULT:String = "createLinkedNotebookFault";
		
		public static const UPDATE_LINKED_NOTEBOOK:String = "updateLinkedNoftebookResult";		
		public static const UPDATE_LINKED_NOTEBOOK_FAULT:String = "updateLinkedNotebookFault";
		
		public static const EXPUNGE_LINKED_NOTEBOOK:String = "expungeLinkedNotebookResult";		
		public static const EXPUNGE_LINKED_NOTEBOOK_FAULT:String = "expungeLinkedNotebookFault";
		
		public static const STRING:String = "stringResult";		
		public static const STRING_FAULT:String = "stringFault";
		
		public static const EMAIL_NOTE:String = "emailNoteResult";		
		public static const EMAIL_NOTE_FAULT:String = "emailNoteFault";
		
		private var _data:Object = new Object();;
		public function EvernoteServiceEvent(type:String, data_:Object = null)
		{
			this._data = data_;
	/*		for each ( var placement : Object in this.things ) 
			{
				if ( data_ is Class(getDefinitionByName(getQualifiedClassName(placement))) )
					placement = data_
			}*/
			//if ( _data is NoteCollectionCounts ) this.noteCollectionCounts = data_ as NoteCollectionCounts
			super(type ); //, true, true);
		}
/*
		public function get things()  : Array
		{
			return [ auth , adImpressions, adParameters, noteCollectionCounts, noteEmailParameters, noteFilter]
		}*/
		/*
		public var auth : AuthenticationResult;	
		
		public var adImpressions : AdImpressions; 
		public var adParameters : AdParameters; 
		public var noteCollectionCounts : NoteCollectionCounts; 
		public var noteEmailParameters : NoteEmailParameters; 		
		public var noteFilter : NoteFilter; 
		*/
		override public function clone() : Event
		{
			return new EvernoteServiceEvent(this.type, this._data);
		}
		
		public function get data():Object
		{
			return _data;
		}		
		
	}
}