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
		public static const NOTEBOOKS_LIST:String = "NOTEBOOKS_LIST";
		public static const SEARCHES_LIST:String = "SEARCHES_LIST";
		public static const TAGS_LIST:String = "TAGS_LIST";

		public static const NOTE_CREATED:String = "NOTE_CREATED";
		public static const NOTE_CREATED_FAULT:String = "NOTE_CREATED_FAULT";		
		public static const NOTEBOOK_CREATED:String = "NOTEBOOK_CREATED";
		public static const SEARCH_CREATED:String = "SEARCH_CREATED";
		public static const SHARED_NOTEBOOK_CREATED:String = "SHARED_NOTEBOOK_CREATED";
		public static const TAG_CREATED:String = "TAG_CREATED";
		
		public static const NOTE_UPDATED:String = "NOTE_UPDATED";
		public static const NOTE_UPDATED_FAULT:String = "NOTE_UPDATED_FAULT";		
		public static const NOTEBOOK_UPDATED:String = "NOTEBOOK_UPDATED";
		public static const SEARCH_UPDATED:String = "SEARCH_UPDATED";
		public static const SHARED_NOTEBOOK_UPDATED:String = "SHARED_NOTEBOOK_UPDATED";
		public static const TAG_UPDATED:String = "TAG_UPDATED";
			
		public static const NOTE_DELETED:String = "NOTE_DELETED";
		public static const NOTE_DELETED_FAULT:String = "NOTE_DELETED_FAULT";		
		public static const NOTE_EXPUNGED:String = "NOTE_EXPUNGED";
		public static const NOTE_EXPUNGED_FAULT:String = "NOTE_EXPUNGED_FAULT";	
		public static const NOTE_GET:String = "NOTE_GET";
		public static const NOTE_GET_FAULT:String = "NOTE_GET_FAULT";				
		public static const NOTES_INACTIVE_EXPUNGED:String = "NOTES_INACTIVE_EXPUNGED";
		public static const NOTES_INACTIVE_EXPUNGED_FAULT:String = "NOTES_INACTIVE_EXPUNGED_FAULT";			
		public static const NOTEBOOK_DELETED:String = "NOTEBOOK_DELETED";
		public static const SEARCH_DELETED:String = "SEARCH_DELETED";
		public static const SHARED_NOTEBOOK_DELETED:String = "SHARED_NOTEBOOK_DELETED";
		public static const TAG_DELETED:String = "TAG_DELETED";		
		
		public static const NOTES_FOUND:String = "NOTE_FOUND";
		public static const NOTEBOOKS_FOUND:String = "NOTEBOOK_FOUND";
		public static const SEARCHS_FOUND:String = "SEARCH_FOUND";
		public static const SHAREDS_NOTEBOOK_FOUND:String = "SHARED_NOTEBOOK_FOUND";
		public static const TAGS_FOUND:String = "TAG_FOUND";		
		
		public static const NOTES_COUNTED:String = "NOTES_COUNTED";		
		public static const NOTES_COUNTED_FAULT:String = "NOTES_COUNTED_FAULT";		
		
		public static const GET_NOTE_TAG_NAMES:String = "GET_NOTE_TAG_NAMES";		
		public static const GET_NOTE_TAG_NAMES_FAULT:String = "GET_NOTE_TAG_NAMES_FAULT";		
				
		public static const FIND_NOTES:String = "FIND_NOTES";		
		public static const FIND_NOTES_FAULT:String = "FIND_NOTES_FAULT";				
		
		
		
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