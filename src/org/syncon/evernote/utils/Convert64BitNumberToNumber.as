package   org.syncon.evernote.utils
{
 
	public class Convert64BitNumberToNumber
	{
	public function input2Ints(d : Object )  :  Number
	{
/*		var d : Object = {}
		d[0] = 298
		d[1] = 425887792*/
		var n1 : Number = d[0];
		var n2 : Number = d[1];
		
		var s1 : Object = n1.toString(2)
		var s2 : Object = n2.toString(2)
		//number to binary 
		//giant binary string
		var number : String = this.convertToString( [s1,s2], [4, 4] )
		var dbg : Array = [ number.length]
		//convert back to binary 
		var result : Number = this.convertBinaryStringToNumber( number ) 
		if ( n1 < 0 ) result *= -1 
		return result;
		//2^64 = 1.84467441 × 10^19
		//1 year = 3.1556926 × 10^10 milliseconds
		//billion years
		//Number is 2^54 -> 1.80143985 × 10^16, number gives you a milllion years without loss
	}
	/**
	 * For each string and length, add zero to begging of string 
	 * 
	 * */
	private function convertToString( strings : Array, lengths : Array ) : String
	{
		var combinedBinaryString : String = ''; 
		for ( var i : int = 0; i < strings.length; i++ )
		{
			var str : String = strings[i]
			var length : int = lengths[i] *8
			var properStr : String = str
			if  ( properStr.length < length ) 
			{
				for ( var add : int=properStr.length; add < length; add++ )
				{
					properStr = '0'+properStr
				}
			}
			combinedBinaryString += properStr
		}
		return combinedBinaryString
	}
	/**
	 * http://www.easycalculation.com/binary-converter.php
	 * Strip tarting zeros try to convert to number
	 * */
	private function convertBinaryStringToNumber( binaryString : String ) :  Number
	{
		var number : Number = 0; 
		var foundNonZeroDigit :  Boolean = false; 
		var binaryArray : Array = [] 
		for ( var i : int = 0; i < binaryString.length; i++ )
		{
			var char : String = binaryString.charAt(i) 
			var binary : int = int( char ) 
			if ( foundNonZeroDigit == false && binary==0)
				continue; 
			//if ( foundNonZeroDigit == false ) 
			foundNonZeroDigit = true
			binaryArray.push( binary ) 
		}
		var numberLength : int = binaryArray.length
		if ( numberLength > 54 ) 
			trace('cannot force into smaller number' ) ; 
		
		//make places 
		var places : Array = []
		for (   i = 0; i < binaryArray.length; i++ )
		{
			places.push(Math.pow( 2, i ) )
		}				
		//trace( 'places :' + places.join(', ' ) )
		/*
		//initialize your binary number 
		binary = [1, 1, 0, 0, 1, 1]; 
		//trace it as a string 
		trace(binary.join("")); 
		//convert it to a decimal number 
		decimalNumber = (place[0]*binary[0])+(place[1]*binary[1])+(place[2]*binary[2])+(place[3]*binary[3])+(place[4]*binary[4])+(place[5]*binary[5]);
		*/
		binaryArray = binaryArray.reverse()	
		for (   i = 0; i < binaryArray.length; i++ )
		{
			number+=binaryArray[i]*places[i]
		}				
		//trace( 'number: 	' + number )			
		
		return number
	}			
	}
	}