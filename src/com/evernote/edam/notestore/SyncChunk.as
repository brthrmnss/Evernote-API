/**
 * Autogenerated by Thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 */
package com.evernote.edam.notestore 
{

import com.evernote.edam.type.Note;
import com.evernote.edam.type.Notebook;
import com.evernote.edam.type.Resource;
import com.evernote.edam.type.SavedSearch;
import com.evernote.edam.type.Tag;

import flash.utils.Dictionary;

import org.apache.thrift.*;
import org.apache.thrift.Set;
import org.apache.thrift.meta_data.*;
import org.apache.thrift.protocol.*;

  /**
   *  This structure is given out by the NoteStore when a client asks to
   *  receive the current state of an account.  The client asks for the server's
   *  state one chunk at a time in order to allow clients to retrieve the state
   *  of a large account without needing to transfer the entire account in
   *  a single message.
   * 
   *  The server always gives SyncChunks using an ascending series of Update
   *  Sequence Numbers (USNs).
   * 
   * <dl>
   *  <dt>currentTime</dt>
   *    <dd>
   *    The server's current date and time.
   *    </dd>
   * 
   *  <dt>chunkHighUSN</dt>
   *    <dd>
   *    The highest USN for any of the data objects represented
   *    in this sync chunk.  If there are no objects in the chunk, this will not be
   *    set.
   *    </dd>
   * 
   *  <dt>updateCount</dt>
   *    <dd>
   *    The total number of updates that have been performed in
   *    the service for this account.  This is equal to the highest USN within the
   *    account at the point that this SyncChunk was generated.  If updateCount
   *    and chunkHighUSN are identical, that means that this is the last chunk
   *    in the account ... there is no more recent information.
   *    </dd>
   * 
   *  <dt>notes</dt>
   *    <dd>
   *    If present, this is a list of non-expunged notes that
   *    have a USN in this chunk.  This will include notes that are "deleted"
   *    but not expunged (i.e. in the trash).  The notes will include their list
   *    of tags and resources, but the resource content and recognition data
   *    will not be supplied.
   *    </dd>
   * 
   *  <dt>notebooks</dt>
   *    <dd>
   *    If present, this is a list of non-expunged notebooks that
   *    have a USN in this chunk.  This will include notebooks that are "deleted"
   *    but not expunged (i.e. in the trash).
   *    </dd>
   * 
   *  <dt>tags</dt>
   *    <dd>
   *    If present, this is a list of the non-expunged tags that have a
   *    USN in this chunk.
   *    </dd>
   * 
   *  <dt>searches</dt>
   *    <dd>
   *    If present, this is a list of non-expunged searches that
   *    have a USN in this chunk.
   *    </dd>
   * 
   *  <dt>resources</dt>
   *    <dd>
   *    If present, this is a list of the non-expunged resources
   *    that have a USN in this chunk.  This will include the metadata for each
   *    resource, but not its binary contents or recognition data, which must be
   *    retrieved separately.
   *    </dd>
   * 
   *  <dt>expungedNotes</dt>
   *    <dd>
   *    If present, the GUIDs of all of the notes that were
   *    permanently expunged in this chunk.
   *    </dd>
   * 
   *  <dt>expungedNotebooks</dt>
   *    <dd>
   *    If present, the GUIDs of all of the notebooks that
   *    were permanently expunged in this chunk.  When a notebook is expunged,
   *    this implies that all of its child notes (and their resources) were
   *    also expunged.
   *    </dd>
   * 
   *  <dt>expungedTags</dt>
   *    <dd>
   *    If present, the GUIDs of all of the tags that were
   *    permanently expunged in this chunk.
   *    </dd>
   * 
   *  <dt>expungedSearches</dt>
   *    <dd>
   *    If present, the GUIDs of all of the saved searches
   *    that were permanently expunged in this chunk.
   *    </dd>
   *  </dl>
   */
  public class SyncChunk implements TBase   {
    private static const STRUCT_DESC:TStruct = new TStruct("SyncChunk");
    private static const CURRENT_TIME_FIELD_DESC:TField = new TField("currentTime", TType.DOUBLE, 1);
    private static const CHUNK_HIGH_USN_FIELD_DESC:TField = new TField("chunkHighUSN", TType.I32, 2);
    private static const UPDATE_COUNT_FIELD_DESC:TField = new TField("updateCount", TType.I32, 3);
    private static const NOTES_FIELD_DESC:TField = new TField("notes", TType.LIST, 4);
    private static const NOTEBOOKS_FIELD_DESC:TField = new TField("notebooks", TType.LIST, 5);
    private static const TAGS_FIELD_DESC:TField = new TField("tags", TType.LIST, 6);
    private static const SEARCHES_FIELD_DESC:TField = new TField("searches", TType.LIST, 7);
    private static const RESOURCES_FIELD_DESC:TField = new TField("resources", TType.LIST, 8);
    private static const EXPUNGED_NOTES_FIELD_DESC:TField = new TField("expungedNotes", TType.LIST, 9);
    private static const EXPUNGED_NOTEBOOKS_FIELD_DESC:TField = new TField("expungedNotebooks", TType.LIST, 10);
    private static const EXPUNGED_TAGS_FIELD_DESC:TField = new TField("expungedTags", TType.LIST, 11);
    private static const EXPUNGED_SEARCHES_FIELD_DESC:TField = new TField("expungedSearches", TType.LIST, 12);

    private var _currentTime:Number;
    public static const CURRENTTIME:int = 1;
    private var _chunkHighUSN:int;
    public static const CHUNKHIGHUSN:int = 2;
    private var _updateCount:int;
    public static const UPDATECOUNT:int = 3;
    private var _notes:Array;
    public static const NOTES:int = 4;
    private var _notebooks:Array;
    public static const NOTEBOOKS:int = 5;
    private var _tags:Array;
    public static const TAGS:int = 6;
    private var _searches:Array;
    public static const SEARCHES:int = 7;
    private var _resources:Array;
    public static const RESOURCES:int = 8;
    private var _expungedNotes:Array;
    public static const EXPUNGEDNOTES:int = 9;
    private var _expungedNotebooks:Array;
    public static const EXPUNGEDNOTEBOOKS:int = 10;
    private var _expungedTags:Array;
    public static const EXPUNGEDTAGS:int = 11;
    private var _expungedSearches:Array;
    public static const EXPUNGEDSEARCHES:int = 12;

    private var __isset_currentTime:Boolean = false;
    private var __isset_chunkHighUSN:Boolean = false;
    private var __isset_updateCount:Boolean = false;

	public static const metaDataMap:Dictionary = new Dictionary();
    {
      metaDataMap[CURRENTTIME] = new FieldMetaData("currentTime", TFieldRequirementType.REQUIRED, 
          new FieldValueMetaData(TType.DOUBLE));
      metaDataMap[CHUNKHIGHUSN] = new FieldMetaData("chunkHighUSN", TFieldRequirementType.OPTIONAL, 
          new FieldValueMetaData(TType.I32));
      metaDataMap[UPDATECOUNT] = new FieldMetaData("updateCount", TFieldRequirementType.REQUIRED, 
          new FieldValueMetaData(TType.I32));
      metaDataMap[NOTES] = new FieldMetaData("notes", TFieldRequirementType.OPTIONAL, 
          new ListMetaData(TType.LIST, 
              new StructMetaData(TType.STRUCT, Note)));
      metaDataMap[NOTEBOOKS] = new FieldMetaData("notebooks", TFieldRequirementType.OPTIONAL, 
          new ListMetaData(TType.LIST, 
              new StructMetaData(TType.STRUCT, Notebook)));
      metaDataMap[TAGS] = new FieldMetaData("tags", TFieldRequirementType.OPTIONAL, 
          new ListMetaData(TType.LIST, 
              new StructMetaData(TType.STRUCT, Tag)));
      metaDataMap[SEARCHES] = new FieldMetaData("searches", TFieldRequirementType.OPTIONAL, 
          new ListMetaData(TType.LIST, 
              new StructMetaData(TType.STRUCT, SavedSearch)));
      metaDataMap[RESOURCES] = new FieldMetaData("resources", TFieldRequirementType.OPTIONAL, 
          new ListMetaData(TType.LIST, 
              new StructMetaData(TType.STRUCT, Resource)));
      metaDataMap[EXPUNGEDNOTES] = new FieldMetaData("expungedNotes", TFieldRequirementType.OPTIONAL, 
          new ListMetaData(TType.LIST, 
              new FieldValueMetaData(TType.STRING)));
      metaDataMap[EXPUNGEDNOTEBOOKS] = new FieldMetaData("expungedNotebooks", TFieldRequirementType.OPTIONAL, 
          new ListMetaData(TType.LIST, 
              new FieldValueMetaData(TType.STRING)));
      metaDataMap[EXPUNGEDTAGS] = new FieldMetaData("expungedTags", TFieldRequirementType.OPTIONAL, 
          new ListMetaData(TType.LIST, 
              new FieldValueMetaData(TType.STRING)));
      metaDataMap[EXPUNGEDSEARCHES] = new FieldMetaData("expungedSearches", TFieldRequirementType.OPTIONAL, 
          new ListMetaData(TType.LIST, 
              new FieldValueMetaData(TType.STRING)));
    }
    {
      FieldMetaData.addStructMetaDataMap(SyncChunk, metaDataMap);
    }

    public function SyncChunk() {
    }

    public function get currentTime():Number {
      return this._currentTime;
    }

    public function set currentTime(currentTime:Number):void {
      this._currentTime = currentTime;
      this.__isset_currentTime = true;
    }

    public function unsetCurrentTime():void {
      this.__isset_currentTime = false;
    }

    // Returns true if field currentTime is set (has been asigned a value) and false otherwise
    public function isSetCurrentTime():Boolean {
      return this.__isset_currentTime;
    }

    public function get chunkHighUSN():int {
      return this._chunkHighUSN;
    }

    public function set chunkHighUSN(chunkHighUSN:int):void {
      this._chunkHighUSN = chunkHighUSN;
      this.__isset_chunkHighUSN = true;
    }

    public function unsetChunkHighUSN():void {
      this.__isset_chunkHighUSN = false;
    }

    // Returns true if field chunkHighUSN is set (has been asigned a value) and false otherwise
    public function isSetChunkHighUSN():Boolean {
      return this.__isset_chunkHighUSN;
    }

    public function get updateCount():int {
      return this._updateCount;
    }

    public function set updateCount(updateCount:int):void {
      this._updateCount = updateCount;
      this.__isset_updateCount = true;
    }

    public function unsetUpdateCount():void {
      this.__isset_updateCount = false;
    }

    // Returns true if field updateCount is set (has been asigned a value) and false otherwise
    public function isSetUpdateCount():Boolean {
      return this.__isset_updateCount;
    }

    public function get notes():Array {
      return this._notes;
    }

    public function set notes(notes:Array):void {
      this._notes = notes;
    }

    public function unsetNotes():void {
      this.notes = null;
    }

    // Returns true if field notes is set (has been asigned a value) and false otherwise
    public function isSetNotes():Boolean {
      return this.notes != null;
    }

    public function get notebooks():Array {
      return this._notebooks;
    }

    public function set notebooks(notebooks:Array):void {
      this._notebooks = notebooks;
    }

    public function unsetNotebooks():void {
      this.notebooks = null;
    }

    // Returns true if field notebooks is set (has been asigned a value) and false otherwise
    public function isSetNotebooks():Boolean {
      return this.notebooks != null;
    }

    public function get tags():Array {
      return this._tags;
    }

    public function set tags(tags:Array):void {
      this._tags = tags;
    }

    public function unsetTags():void {
      this.tags = null;
    }

    // Returns true if field tags is set (has been asigned a value) and false otherwise
    public function isSetTags():Boolean {
      return this.tags != null;
    }

    public function get searches():Array {
      return this._searches;
    }

    public function set searches(searches:Array):void {
      this._searches = searches;
    }

    public function unsetSearches():void {
      this.searches = null;
    }

    // Returns true if field searches is set (has been asigned a value) and false otherwise
    public function isSetSearches():Boolean {
      return this.searches != null;
    }

    public function get resources():Array {
      return this._resources;
    }

    public function set resources(resources:Array):void {
      this._resources = resources;
    }

    public function unsetResources():void {
      this.resources = null;
    }

    // Returns true if field resources is set (has been asigned a value) and false otherwise
    public function isSetResources():Boolean {
      return this.resources != null;
    }

    public function get expungedNotes():Array {
      return this._expungedNotes;
    }

    public function set expungedNotes(expungedNotes:Array):void {
      this._expungedNotes = expungedNotes;
    }

    public function unsetExpungedNotes():void {
      this.expungedNotes = null;
    }

    // Returns true if field expungedNotes is set (has been asigned a value) and false otherwise
    public function isSetExpungedNotes():Boolean {
      return this.expungedNotes != null;
    }

    public function get expungedNotebooks():Array {
      return this._expungedNotebooks;
    }

    public function set expungedNotebooks(expungedNotebooks:Array):void {
      this._expungedNotebooks = expungedNotebooks;
    }

    public function unsetExpungedNotebooks():void {
      this.expungedNotebooks = null;
    }

    // Returns true if field expungedNotebooks is set (has been asigned a value) and false otherwise
    public function isSetExpungedNotebooks():Boolean {
      return this.expungedNotebooks != null;
    }

    public function get expungedTags():Array {
      return this._expungedTags;
    }

    public function set expungedTags(expungedTags:Array):void {
      this._expungedTags = expungedTags;
    }

    public function unsetExpungedTags():void {
      this.expungedTags = null;
    }

    // Returns true if field expungedTags is set (has been asigned a value) and false otherwise
    public function isSetExpungedTags():Boolean {
      return this.expungedTags != null;
    }

    public function get expungedSearches():Array {
      return this._expungedSearches;
    }

    public function set expungedSearches(expungedSearches:Array):void {
      this._expungedSearches = expungedSearches;
    }

    public function unsetExpungedSearches():void {
      this.expungedSearches = null;
    }

    // Returns true if field expungedSearches is set (has been asigned a value) and false otherwise
    public function isSetExpungedSearches():Boolean {
      return this.expungedSearches != null;
    }

    public function setFieldValue(fieldID:int, value:*):void {
      switch (fieldID) {
      case CURRENTTIME:
        if (value == null) {
          unsetCurrentTime();
        } else {
          this.currentTime = value;
        }
        break;

      case CHUNKHIGHUSN:
        if (value == null) {
          unsetChunkHighUSN();
        } else {
          this.chunkHighUSN = value;
        }
        break;

      case UPDATECOUNT:
        if (value == null) {
          unsetUpdateCount();
        } else {
          this.updateCount = value;
        }
        break;

      case NOTES:
        if (value == null) {
          unsetNotes();
        } else {
          this.notes = value;
        }
        break;

      case NOTEBOOKS:
        if (value == null) {
          unsetNotebooks();
        } else {
          this.notebooks = value;
        }
        break;

      case TAGS:
        if (value == null) {
          unsetTags();
        } else {
          this.tags = value;
        }
        break;

      case SEARCHES:
        if (value == null) {
          unsetSearches();
        } else {
          this.searches = value;
        }
        break;

      case RESOURCES:
        if (value == null) {
          unsetResources();
        } else {
          this.resources = value;
        }
        break;

      case EXPUNGEDNOTES:
        if (value == null) {
          unsetExpungedNotes();
        } else {
          this.expungedNotes = value;
        }
        break;

      case EXPUNGEDNOTEBOOKS:
        if (value == null) {
          unsetExpungedNotebooks();
        } else {
          this.expungedNotebooks = value;
        }
        break;

      case EXPUNGEDTAGS:
        if (value == null) {
          unsetExpungedTags();
        } else {
          this.expungedTags = value;
        }
        break;

      case EXPUNGEDSEARCHES:
        if (value == null) {
          unsetExpungedSearches();
        } else {
          this.expungedSearches = value;
        }
        break;

      default:
        throw new ArgumentError("Field " + fieldID + " doesn't exist!");
      }
    }

    public function getFieldValue(fieldID:int):* {
      switch (fieldID) {
      case CURRENTTIME:
        return this.currentTime;
      case CHUNKHIGHUSN:
        return this.chunkHighUSN;
      case UPDATECOUNT:
        return this.updateCount;
      case NOTES:
        return this.notes;
      case NOTEBOOKS:
        return this.notebooks;
      case TAGS:
        return this.tags;
      case SEARCHES:
        return this.searches;
      case RESOURCES:
        return this.resources;
      case EXPUNGEDNOTES:
        return this.expungedNotes;
      case EXPUNGEDNOTEBOOKS:
        return this.expungedNotebooks;
      case EXPUNGEDTAGS:
        return this.expungedTags;
      case EXPUNGEDSEARCHES:
        return this.expungedSearches;
      default:
        throw new ArgumentError("Field " + fieldID + " doesn't exist!");
      }
    }

    // Returns true if field corresponding to fieldID is set (has been asigned a value) and false otherwise
    public function isSet(fieldID:int):Boolean {
      switch (fieldID) {
      case CURRENTTIME:
        return isSetCurrentTime();
      case CHUNKHIGHUSN:
        return isSetChunkHighUSN();
      case UPDATECOUNT:
        return isSetUpdateCount();
      case NOTES:
        return isSetNotes();
      case NOTEBOOKS:
        return isSetNotebooks();
      case TAGS:
        return isSetTags();
      case SEARCHES:
        return isSetSearches();
      case RESOURCES:
        return isSetResources();
      case EXPUNGEDNOTES:
        return isSetExpungedNotes();
      case EXPUNGEDNOTEBOOKS:
        return isSetExpungedNotebooks();
      case EXPUNGEDTAGS:
        return isSetExpungedTags();
      case EXPUNGEDSEARCHES:
        return isSetExpungedSearches();
      default:
        throw new ArgumentError("Field " + fieldID + " doesn't exist!");
      }
    }

    public function read(iprot:TProtocol):void {
      var field:TField;
      iprot.readStructBegin();
      while (true)
      {
        field = iprot.readFieldBegin();
        if (field.type == TType.STOP) { 
          break;
        }
        switch (field.id)
        {
          case CURRENTTIME:
            if (field.type == TType.DOUBLE) {
              this.currentTime = iprot.readDouble();
              this.__isset_currentTime = true;
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case CHUNKHIGHUSN:
            if (field.type == TType.I32) {
              this.chunkHighUSN = iprot.readI32();
              this.__isset_chunkHighUSN = true;
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case UPDATECOUNT:
            if (field.type == TType.I32) {
              this.updateCount = iprot.readI32();
              this.__isset_updateCount = true;
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case NOTES:
            if (field.type == TType.LIST) {
              {
                var _list16:TList = iprot.readListBegin();
                this.notes = new Array();
                for (var _i17:int = 0; _i17 < _list16.size; ++_i17)
                {
                  var _elem18:Note;
                  _elem18 =  new  Note()
                  _elem18.read(iprot);
                  this.notes.push(_elem18);
                }
                iprot.readListEnd();
              }
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case NOTEBOOKS:
            if (field.type == TType.LIST) {
              {
                var _list19:TList = iprot.readListBegin();
                this.notebooks = new Array();
                for (var _i20:int = 0; _i20 < _list19.size; ++_i20)
                {
                  var _elem21:Notebook;
                  _elem21 = new Notebook();
                  _elem21.read(iprot);
                  this.notebooks.push(_elem21);
                }
                iprot.readListEnd();
              }
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case TAGS:
            if (field.type == TType.LIST) {
              {
                var _list22:TList = iprot.readListBegin();
                this.tags = new Array();
                for (var _i23:int = 0; _i23 < _list22.size; ++_i23)
                {
                  var _elem24:Tag;
                  _elem24 = new Tag();
                  _elem24.read(iprot);
                  this.tags.push(_elem24);
                }
                iprot.readListEnd();
              }
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case SEARCHES:
            if (field.type == TType.LIST) {
              {
                var _list25:TList = iprot.readListBegin();
                this.searches = new Array();
                for (var _i26:int = 0; _i26 < _list25.size; ++_i26)
                {
                  var _elem27:SavedSearch;
                  _elem27 = new SavedSearch();
                  _elem27.read(iprot);
                  this.searches.push(_elem27);
                }
                iprot.readListEnd();
              }
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case RESOURCES:
            if (field.type == TType.LIST) {
              {
                var _list28:TList = iprot.readListBegin();
                this.resources = new Array();
                for (var _i29:int = 0; _i29 < _list28.size; ++_i29)
                {
                  var _elem30:Resource;
                  _elem30 = new Resource();
                  _elem30.read(iprot);
                  this.resources.push(_elem30);
                }
                iprot.readListEnd();
              }
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case EXPUNGEDNOTES:
            if (field.type == TType.LIST) {
              {
                var _list31:TList = iprot.readListBegin();
                this.expungedNotes = new Array();
                for (var _i32:int = 0; _i32 < _list31.size; ++_i32)
                {
                  var _elem33:String;
                  _elem33 = iprot.readString();
                  this.expungedNotes.push(_elem33);
                }
                iprot.readListEnd();
              }
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case EXPUNGEDNOTEBOOKS:
            if (field.type == TType.LIST) {
              {
                var _list34:TList = iprot.readListBegin();
                this.expungedNotebooks = new Array();
                for (var _i35:int = 0; _i35 < _list34.size; ++_i35)
                {
                  var _elem36:String;
                  _elem36 = iprot.readString();
                  this.expungedNotebooks.push(_elem36);
                }
                iprot.readListEnd();
              }
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case EXPUNGEDTAGS:
            if (field.type == TType.LIST) {
              {
                var _list37:TList = iprot.readListBegin();
                this.expungedTags = new Array();
                for (var _i38:int = 0; _i38 < _list37.size; ++_i38)
                {
                  var _elem39:String;
                  _elem39 = iprot.readString();
                  this.expungedTags.push(_elem39);
                }
                iprot.readListEnd();
              }
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          case EXPUNGEDSEARCHES:
            if (field.type == TType.LIST) {
              {
                var _list40:TList = iprot.readListBegin();
                this.expungedSearches = new Array();
                for (var _i41:int = 0; _i41 < _list40.size; ++_i41)
                {
                  var _elem42:String;
                  _elem42 = iprot.readString();
                  this.expungedSearches.push(_elem42);
                }
                iprot.readListEnd();
              }
            } else { 
              TProtocolUtil.skip(iprot, field.type);
            }
            break;
          default:
            TProtocolUtil.skip(iprot, field.type);
            break;
        }
        iprot.readFieldEnd();
      }
      iprot.readStructEnd();


      // check for required fields of primitive type, which can't be checked in the validate method
      if (!__isset_currentTime) {
        throw new TProtocolError(TProtocolError.UNKNOWN, "Required field 'currentTime' was not found in serialized data! Struct: " + toString());
      }
      if (!__isset_updateCount) {
        throw new TProtocolError(TProtocolError.UNKNOWN, "Required field 'updateCount' was not found in serialized data! Struct: " + toString());
      }
      validate();
    }

    public function write(oprot:TProtocol):void {
      validate();

      oprot.writeStructBegin(STRUCT_DESC);
      oprot.writeFieldBegin(CURRENT_TIME_FIELD_DESC);
      oprot.writeDouble(this.currentTime);
      oprot.writeFieldEnd();
      oprot.writeFieldBegin(CHUNK_HIGH_USN_FIELD_DESC);
      oprot.writeI32(this.chunkHighUSN);
      oprot.writeFieldEnd();
      oprot.writeFieldBegin(UPDATE_COUNT_FIELD_DESC);
      oprot.writeI32(this.updateCount);
      oprot.writeFieldEnd();
      if (this.notes != null) {
        oprot.writeFieldBegin(NOTES_FIELD_DESC);
        {
          oprot.writeListBegin(new TList(TType.STRUCT, this.notes.length));
          for each (var elem43:* in this.notes)          {
            elem43.write(oprot);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      if (this.notebooks != null) {
        oprot.writeFieldBegin(NOTEBOOKS_FIELD_DESC);
        {
          oprot.writeListBegin(new TList(TType.STRUCT, this.notebooks.length));
          for each (var elem44:* in this.notebooks)          {
            elem44.write(oprot);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      if (this.tags != null) {
        oprot.writeFieldBegin(TAGS_FIELD_DESC);
        {
          oprot.writeListBegin(new TList(TType.STRUCT, this.tags.length));
          for each (var elem45:* in this.tags)          {
            elem45.write(oprot);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      if (this.searches != null) {
        oprot.writeFieldBegin(SEARCHES_FIELD_DESC);
        {
          oprot.writeListBegin(new TList(TType.STRUCT, this.searches.length));
          for each (var elem46:* in this.searches)          {
            elem46.write(oprot);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      if (this.resources != null) {
        oprot.writeFieldBegin(RESOURCES_FIELD_DESC);
        {
          oprot.writeListBegin(new TList(TType.STRUCT, this.resources.length));
          for each (var elem47:* in this.resources)          {
            elem47.write(oprot);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      if (this.expungedNotes != null) {
        oprot.writeFieldBegin(EXPUNGED_NOTES_FIELD_DESC);
        {
          oprot.writeListBegin(new TList(TType.STRING, this.expungedNotes.length));
          for each (var elem48:* in this.expungedNotes)          {
            oprot.writeString(elem48);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      if (this.expungedNotebooks != null) {
        oprot.writeFieldBegin(EXPUNGED_NOTEBOOKS_FIELD_DESC);
        {
          oprot.writeListBegin(new TList(TType.STRING, this.expungedNotebooks.length));
          for each (var elem49:* in this.expungedNotebooks)          {
            oprot.writeString(elem49);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      if (this.expungedTags != null) {
        oprot.writeFieldBegin(EXPUNGED_TAGS_FIELD_DESC);
        {
          oprot.writeListBegin(new TList(TType.STRING, this.expungedTags.length));
          for each (var elem50:* in this.expungedTags)          {
            oprot.writeString(elem50);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      if (this.expungedSearches != null) {
        oprot.writeFieldBegin(EXPUNGED_SEARCHES_FIELD_DESC);
        {
          oprot.writeListBegin(new TList(TType.STRING, this.expungedSearches.length));
          for each (var elem51:* in this.expungedSearches)          {
            oprot.writeString(elem51);
          }
          oprot.writeListEnd();
        }
        oprot.writeFieldEnd();
      }
      oprot.writeFieldStop();
      oprot.writeStructEnd();
    }

    public function toString():String {
      var ret:String = new String("SyncChunk(");
      var first:Boolean = true;

      ret += "currentTime:";
      ret += this.currentTime;
      first = false;
      if (isSetChunkHighUSN()) {
        if (!first) ret +=  ", ";
        ret += "chunkHighUSN:";
        ret += this.chunkHighUSN;
        first = false;
      }
      if (!first) ret +=  ", ";
      ret += "updateCount:";
      ret += this.updateCount;
      first = false;
      if (isSetNotes()) {
        if (!first) ret +=  ", ";
        ret += "notes:";
        if (this.notes == null) {
          ret += "null";
        } else {
          ret += this.notes;
        }
        first = false;
      }
      if (isSetNotebooks()) {
        if (!first) ret +=  ", ";
        ret += "notebooks:";
        if (this.notebooks == null) {
          ret += "null";
        } else {
          ret += this.notebooks;
        }
        first = false;
      }
      if (isSetTags()) {
        if (!first) ret +=  ", ";
        ret += "tags:";
        if (this.tags == null) {
          ret += "null";
        } else {
          ret += this.tags;
        }
        first = false;
      }
      if (isSetSearches()) {
        if (!first) ret +=  ", ";
        ret += "searches:";
        if (this.searches == null) {
          ret += "null";
        } else {
          ret += this.searches;
        }
        first = false;
      }
      if (isSetResources()) {
        if (!first) ret +=  ", ";
        ret += "resources:";
        if (this.resources == null) {
          ret += "null";
        } else {
          ret += this.resources;
        }
        first = false;
      }
      if (isSetExpungedNotes()) {
        if (!first) ret +=  ", ";
        ret += "expungedNotes:";
        if (this.expungedNotes == null) {
          ret += "null";
        } else {
          ret += this.expungedNotes;
        }
        first = false;
      }
      if (isSetExpungedNotebooks()) {
        if (!first) ret +=  ", ";
        ret += "expungedNotebooks:";
        if (this.expungedNotebooks == null) {
          ret += "null";
        } else {
          ret += this.expungedNotebooks;
        }
        first = false;
      }
      if (isSetExpungedTags()) {
        if (!first) ret +=  ", ";
        ret += "expungedTags:";
        if (this.expungedTags == null) {
          ret += "null";
        } else {
          ret += this.expungedTags;
        }
        first = false;
      }
      if (isSetExpungedSearches()) {
        if (!first) ret +=  ", ";
        ret += "expungedSearches:";
        if (this.expungedSearches == null) {
          ret += "null";
        } else {
          ret += this.expungedSearches;
        }
        first = false;
      }
      ret += ")";
      return ret;
    }

    public function validate():void {
      // check for required fields
      // alas, we cannot check 'currentTime' because it's a primitive and you chose the non-beans generator.
      // alas, we cannot check 'updateCount' because it's a primitive and you chose the non-beans generator.
      // check that fields of type enum have valid values
    }

  }

}
