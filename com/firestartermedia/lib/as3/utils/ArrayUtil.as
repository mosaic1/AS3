/**
 * @author			Ahmed Nuaman (http://www.ahmednuaman.com)
 * @langversion		3
 * 
 * This work is licenced under the Creative Commons Attribution-Share Alike 2.0 UK: England & Wales License. 
 * To view a copy of this licence, visit http://creativecommons.org/licenses/by-sa/2.0/uk/ or send a letter 
 * to Creative Commons, 171 Second Street, Suite 300, San Francisco, California 94105, USA.
*/
package com.firestartermedia.lib.as3.utils
{
	public class ArrayUtil
	{		
		public static function shuffle(array:Array):Array
		{
			var i:Number = array.length;
			var j:Number;
			var t1:*;
			var t2:*;
			
			if ( i == 0 )
			{
				return [ ];
			}
			else
			{
				while ( --i )
				{
					j = Math.floor( Math.random() * ( i + 1 ) );
					
					t1 = array[ i ];
					t2 = array[ j ];
					
					array[ i ] = t2;
					array[ j ] = t1;
				}
				
				return array;
			}
		}
		
		public static function search(array:Array, value:Object):Number
		{
			var found:Boolean = false;
			
			for ( var i:Number = 0; i < array.length; i++)
			{
				if ( array[ i ] == value )
				{
					found = true;
					
					break;
				}
			}
			
			return ( found ? i : -1 );
		}
	}
}