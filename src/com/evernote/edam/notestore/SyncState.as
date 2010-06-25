/**
 * Autogenerated by Thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 */
package com.evernote.edam.notestore 
{


import org.apache.thrift.Set;
import flash.utils.Dictionary;

import org.apache.thrift.*;
import org.apache.thrift.meta_data.*;
import org.apache.thrift.protocol.*;

  /**
   *  This structure encapsulates the information about the state of the
   *  user's account for the purpose of "state based" synchronization.
   * <dl>
   *  <dt>currentTime</dt>
   *    <dd>
   *    The server's current date and time.
   *    </dd>
   * 
   *  <dt>fullSyncBefore</dt>
   *    <dd>
   *    The cutoff date and time for client caches to be
   *    updated via incremental synchronization.  Any clients that were last
   *    synched with the server before this date/time must do a full resync of all
   *    objects.  This cutoff point will change over time as archival data is
   *    deleted or special circumstances on the service require resynchronization.
   *    </dd>
   * 
   *  <dt>updateCount</dt>
   *    <dd>
   *    Indicates the total number of transactions that have
   *    been committed within the account.  This reflects (for example) the
   *    number of discrete additions or modifications that have been made to
   *    the data in this account (tags, notes, resources, etc.).
   *    This number is the "high water mark" for Update Sequence Numbers (USN)
   *    within the account.
   *    </dd>
   * 
   *  <dt>uploaded</dt>
   *    <dd>
   *    The total number of bytes that have been uploaded to
   *    this account in the current monthly period.  This can be compared against
   *    Accounting.uploadLimit (from the UserStore) to determine how close the user
   *    is to their monthly upload limit.
   *    </dd>
   *  </dl>
   */
  public class SyncState implements TBase   {
    private static const STRUCT_DESC:TStruct = new TStruct("SyncState");
    private static const CURRENT_TIME_FIELD_DESC:TField = new TField("currentTime", TType.DOUBLE, 1);
    private static const FULL_SYNC_BEFORE_FIELD_DESC:TField = new TField("fullSyncBefore", TType.DOUBLE, 2);
    private static const UPDATE_COUNT_FIELD_DESC:TField = new TField("updateCount", TType.I32, 3);
    private static const UPLOADED_FIELD_DESC:TField = new TField("uploaded", TType.DOUBLE, 4);

    private var _currentTime:Number;
    public static const CURRENTTIME:int = 1;
    private var _fullSyncBefore:Number;
    public static const FULLSYNCBEFORE:int = 2;
    private var _updateCount:int;
    public static const UPDATECOUNT:int = 3;
    private var _uploaded:Number;
    public static const UPLOADED:int = 4;

    private var __isset_currentTime:Boolean = false;
    private var __isset_fullSyncBefore:Boolean = false;
    private var __isset_updateCount:Boolean = false;
    private var __isset_uploaded:Boolean = false;

    public static const metaDataMap:Dictionary = new Dictionary();
    {
      metaDataMap[CURRENTTIME] = new FieldMetaData("currentTime", TFieldRequirementType.REQUIRED, 
          new FieldValueMetaData(TType.DOUBLE));
      metaDataMap[FULLSYNCBEFORE] = new FieldMetaData("fullSyncBefore", TFieldRequirementType.REQUIRED, 
          new FieldValueMetaData(TType.DOUBLE));
      metaDataMap[UPDATECOUNT] = new FieldMetaData("updateCount", TFieldRequirementType.REQUIRED, 
          new FieldValueMetaData(TType.I32));
      metaDataMap[UPLOADED] = new FieldMetaData("uploaded", TFieldRequirementType.OPTIONAL, 
          new FieldValueMetaData(TType.DOUBLE));
    }
    {
      FieldMetaData.addStructMetaDataMap(SyncState, metaDataMap);
    }

    public function SyncState() {
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

    public function get fullSyncBefore():Number {
      return this._fullSyncBefore;
    }

    public function set fullSyncBefore(fullSyncBefore:Number):void {
      this._fullSyncBefore = fullSyncBefore;
      this.__isset_fullSyncBefore = true;
    }

    public function unsetFullSyncBefore():void {
      this.__isset_fullSyncBefore = false;
    }

    // Returns true if field fullSyncBefore is set (has been asigned a value) and false otherwise
    public function isSetFullSyncBefore():Boolean {
      return this.__isset_fullSyncBefore;
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

    public function get uploaded():Number {
      return this._uploaded;
    }

    public function set uploaded(uploaded:Number):void {
      this._uploaded = uploaded;
      this.__isset_uploaded = true;
    }

    public function unsetUploaded():void {
      this.__isset_uploaded = false;
    }

    // Returns true if field uploaded is set (has been asigned a value) and false otherwise
    public function isSetUploaded():Boolean {
      return this.__isset_uploaded;
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

      case FULLSYNCBEFORE:
        if (value == null) {
          unsetFullSyncBefore();
        } else {
          this.fullSyncBefore = value;
        }
        break;

      case UPDATECOUNT:
        if (value == null) {
          unsetUpdateCount();
        } else {
          this.updateCount = value;
        }
        break;

      case UPLOADED:
        if (value == null) {
          unsetUploaded();
        } else {
          this.uploaded = value;
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
      case FULLSYNCBEFORE:
        return this.fullSyncBefore;
      case UPDATECOUNT:
        return this.updateCount;
      case UPLOADED:
        return this.uploaded;
      default:
        throw new ArgumentError("Field " + fieldID + " doesn't exist!");
      }
    }

    // Returns true if field corresponding to fieldID is set (has been asigned a value) and false otherwise
    public function isSet(fieldID:int):Boolean {
      switch (fieldID) {
      case CURRENTTIME:
        return isSetCurrentTime();
      case FULLSYNCBEFORE:
        return isSetFullSyncBefore();
      case UPDATECOUNT:
        return isSetUpdateCount();
      case UPLOADED:
        return isSetUploaded();
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
          case FULLSYNCBEFORE:
            if (field.type == TType.DOUBLE) {
              this.fullSyncBefore = iprot.readDouble();
              this.__isset_fullSyncBefore = true;
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
          case UPLOADED:
            if (field.type == TType.DOUBLE) {
              this.uploaded = iprot.readDouble();
              this.__isset_uploaded = true;
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
      if (!__isset_fullSyncBefore) {
        throw new TProtocolError(TProtocolError.UNKNOWN, "Required field 'fullSyncBefore' was not found in serialized data! Struct: " + toString());
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
      oprot.writeFieldBegin(FULL_SYNC_BEFORE_FIELD_DESC);
      oprot.writeDouble(this.fullSyncBefore);
      oprot.writeFieldEnd();
      oprot.writeFieldBegin(UPDATE_COUNT_FIELD_DESC);
      oprot.writeI32(this.updateCount);
      oprot.writeFieldEnd();
      oprot.writeFieldBegin(UPLOADED_FIELD_DESC);
      oprot.writeDouble(this.uploaded);
      oprot.writeFieldEnd();
      oprot.writeFieldStop();
      oprot.writeStructEnd();
    }

    public function toString():String {
      var ret:String = new String("SyncState(");
      var first:Boolean = true;

      ret += "currentTime:";
      ret += this.currentTime;
      first = false;
      if (!first) ret +=  ", ";
      ret += "fullSyncBefore:";
      ret += this.fullSyncBefore;
      first = false;
      if (!first) ret +=  ", ";
      ret += "updateCount:";
      ret += this.updateCount;
      first = false;
      if (isSetUploaded()) {
        if (!first) ret +=  ", ";
        ret += "uploaded:";
        ret += this.uploaded;
        first = false;
      }
      ret += ")";
      return ret;
    }

    public function validate():void {
      // check for required fields
      // alas, we cannot check 'currentTime' because it's a primitive and you chose the non-beans generator.
      // alas, we cannot check 'fullSyncBefore' because it's a primitive and you chose the non-beans generator.
      // alas, we cannot check 'updateCount' because it's a primitive and you chose the non-beans generator.
      // check that fields of type enum have valid values
    }

  }

}
