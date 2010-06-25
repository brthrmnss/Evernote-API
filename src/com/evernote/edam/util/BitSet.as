package com.evernote.edam.util {
/**
 * Minimal BitSet implementation to support Evernote's EDAM protocol.
 * Not a general replacement for java.util.BitMap, but this version will
 * work for our classes, and will be serializable over Google Web Toolkit.
 */
public class BitSet implements java.io.Serializable {

  private var word:Number;
  
  public function BitSet() {
  }
  
  public function BitSet(size:int) {
    if (size > 63) {
      throw new RuntimeException("BitSet limited to 64 bits");
    }
  }

  public function clear():void {
    word = 0;
  }
  
  public function or(other:BitSet):void {
    word |= other.word;
  }
  
  public function clear(index:int):void {
    word &= ~(1L<< index);
  }
  
  public function get(index:int):Boolean {
    return ((word >> index) & 1) == 1;
  }
  
  public function set(index:int, value:Boolean):void {
    if (value) {
      word |= (1L<< index);
    } else {
      clear(index);
    }
  }
  
}
}