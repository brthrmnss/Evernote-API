package com.coderanger
{
	import com.evernote.edam.notestore.NoteStore;
	import com.evernote.edam.notestore.NoteStoreImpl;
	import com.evernote.edam.type.User;
	import com.evernote.edam.userstore.AuthenticationResult;
	import com.evernote.edam.userstore.Constants;
	import com.evernote.edam.userstore.UserStore;
	import com.evernote.edam.userstore.UserStoreImpl;
	
	import flash.net.URLRequest;
	
	import org.apache.thrift.protocol.TBinaryProtocol;
	import org.apache.thrift.protocol.TProtocol;
	import org.apache.thrift.transport.THttpClient;
	import org.apache.thrift.transport.TTransport;

	public class EvernoteAPI
	{
		/*
		﻿using System;
		using System.Collections.Generic;
		using System.Linq;
		using System.Text;
		using Evernote.EDAM.UserStore;
		using Evernote.EDAM.Type;
		using Thrift.Protocol;
		using Thrift.Transport;
		using Evernote.EDAM.NoteStore;
		*//*
				public static var consumerKey : String = "olinbg";
				public static var consumerSecret : String = "f079dcde30a914f0";
				public static var edamBaseUrl  : String = "https://lb.evernote.com";
				*/
				public static var consumerKey : String = "brthrmnss";
				public static var consumerSecret : String = "770a8c70efe93e94";
				public static var edamBaseUrl  : String = "https://sandbox.evernote.com";
								
				
				public static var xmlHeader  : String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
				public static var docType  : String = "<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">";
				public static var tNoteOpen  : String = "<en-note>";
				public static var tNoteClose  : String = "</en-note>";
				
				public var userStore : UserStore; 
				public var  noteStore : NoteStore ;
				public var user : User; 
				public var  auth : AuthenticationResult;
				
	 
				public var username : String = ''; 
				public var password : String = ''; 
				
				public function EvernoteAPI( login : String, password : String)
				{
					
					//noteStore = getStore();
					this.username = login
						this.password = password
						getAuth( );
				}
				
				private function  getAuth(/* login : String, pwrd : String */) : void//; // AuthenticationResult
				{
					var  userStoreUrl :String= edamBaseUrl + "/edam/user";
				/*	var username  : String  = login;
					var password  : String  = pwrd;*/
					var  userStoreTransport : TTransport = new THttpClient( new URLRequest(userStoreUrl) );
					var  userStoreProtocol :  TProtocol = new TBinaryProtocol(userStoreTransport);
					userStore = new UserStoreImpl(userStoreProtocol)
					  userStore.checkVersion("Evernote Windows/3.0.1; Windows/XP SP3",
						Constants.EDAM_VERSION_MAJOR,
						Constants.EDAM_VERSION_MINOR, this.handleCheckVersionFault, this.handleCheckVersionResult  );
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
					trace();		
					userStore.authenticate(username, 
						password, consumerKey, consumerSecret,  handleAuthenticateFault, handleAuthenticateOk );					
				}
				
				public function handleCheckVersionFault(e:Object=null):void
				{
					trace();
				}				
				
				
				public function handleAuthenticateOk(e: AuthenticationResult=null):void
				{
					this.auth = e
					this.getStore()
				}
				
				public function handleAuthenticateFault(e:Object=null):void
				{
				}
				
 				private function getStore() : void
				{
					var  noteStoreUrl : String = edamBaseUrl + "/edam/note/" + this.auth.user.shardId
				//		.shardId;
					var noteStoreTransport : TTransport  = new THttpClient( new URLRequest(noteStoreUrl));
					var  noteStoreProtocol : TProtocol = new TBinaryProtocol(noteStoreTransport);
					this.noteStore =  new NoteStoreImpl(noteStoreProtocol);
					//this.noteStore.listNotebooks(this.user)
					this.noteStore.listNotebooks( this.auth.authenticationToken, this.handleListNotebooksFault , this.handleListNotebooksResult )
				}
				
				
				public function handleListNotebooksResult(e:Object=null):void
				{
					trace();					
				}
				
				public function handleListNotebooksFault(e:Object=null):void
				{
				}
								
				/*
				public void refreshAuth(string old_auth) 
				{
					userStore.refreshAuthentication(old_auth);
				}
				
				public void checkToken() 
				{
					// Time checking here
				}
				
				public List<Notebook> getNotebooks()
				{
				
					return noteStore.listNotebooks(auth.authenticationToken);
				}
				
				public Notebook getDefaultNotebook()
				{
					List<Notebook> notebooks = getNotebooks();
					Notebook first = notebooks[0];
					foreach (Notebook notebook in notebooks)
					{
						if (notebook.DefaultNotebook)
						{
							return notebook;
						}
					}
					return first;
				}
				
				public Note createNote(Notebook destination)
				{
					Note note = new Note();
					note.NotebookGuid = destination.Guid;
					note.Title = "Test Note";
					
					note.Created = getTime();
					note.Updated = note.Created;
					
					String insertContent = "Here is the test text in the note.  Yes!";
					
					note.Content = xmlHeader + docType + tNoteOpen;
					note.Content += insertContent;
					note.Content += tNoteClose;
					
					Note createdNote = noteStore.createNote(auth.authenticationToken, note);
					return createdNote;
				}
				
				public long getTime()
				{
					DateTime epoch = new DateTime(1970, 1, 1);
					TimeSpan systemTime = DateTime.Now - epoch;
					return (long)systemTime.TotalMilliseconds;
				}*/
		
	}
}