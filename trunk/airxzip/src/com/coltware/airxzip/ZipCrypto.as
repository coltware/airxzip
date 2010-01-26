/**
 *  Copyright (c)  2009 coltware@gmail.com
 *  http://www.coltware.com 
 *
 *  License: LGPL v3 ( http://www.gnu.org/licenses/lgpl-3.0-standalone.html )
 *
 * @author coltware@gmail.com
 */
package com.coltware.airxzip {
	
	import flash.utils.*;
	import mx.logging.*;
	
	public class ZipCrypto {
		
		private static var log:ILogger = Log.getLogger("com.coltware.airxzip.ZipCrypto");
		
		public static var CRYPTHEADLEN:int = 12;
        
        // Initial keys
        private static var S_KEY1:int = 305419896;
        private static var S_KEY2:int = 591751049;
        private static var S_KEY3:int = 878082192;
        
        private var _key:Array;
		
		public function ZipCrypto() {
			
		}
		/**
		*  暗号時に使用する初期化処理
		*
		*/
		public function initCrypt(password:ByteArray,crc32:uint):ByteArray{
            
            crc32 = crc32 >> 24;
            
            var ret:ByteArray = new ByteArray();
            _key = new Array(3);
            _key[0] = S_KEY1;
            _key[1] = S_KEY2;
            _key[2] = S_KEY3;
            
            password.position = 0;
            while(password.bytesAvailable > 0){
                var n:uint = password.readUnsignedByte();
                updateKeys(n);
            }
            
            var d:uint;
            for(var i:int=0; i< CRYPTHEADLEN ; i++){
                if( i == CRYPTHEADLEN - 1){
                    d = uint(crc32 & 0xff);                }
                else{
                    d = uint((crc32 >> 32) & 0xFF); 
                }
                d = zencode(d);
                ret.writeByte(d);
            }
            
            ret.position = 0;
            return ret;
        }
        
        /**
        *  データを暗号化する
        *
        */
        public function encrypt(data:ByteArray):ByteArray{
            
            var out:ByteArray = new ByteArray();
            data.position = 0;
            while(data.bytesAvailable){
                var n:uint = data.readUnsignedByte();
                out.writeByte(zencode(n));
            }
            out.position = 0;
            
            return out;
        }
        /**
        *  解凍時に使用する初期化処理
        *
        */
        public function initDecrypt(password:ByteArray,cryptHeader:ByteArray):uint{
            
            var ret:ByteArray = new ByteArray();
            _key = new Array(3);
            _key[0] = S_KEY1;
            _key[1] = S_KEY2;
            _key[2] = S_KEY3;
            
            password.position = 0;
            
            while(password.bytesAvailable > 0){
                var n:uint = password.readUnsignedByte();
                updateKeys(n);
            }
            cryptHeader.position = 0;
            
            for(var i:int=0; i< CRYPTHEADLEN; i++){
            	var b:uint = cryptHeader.readUnsignedByte();
                b = zdecode(b);
            }
            return b;
        }
        /**
        *  解凍処理
        *
        */
        public function decrypt(data:ByteArray):ByteArray{
        	        	
        	var out:ByteArray = new ByteArray();
        	while(data.bytesAvailable > 0 ){
        		var n:uint = data.readUnsignedByte();
        		n = zdecode(n);
        		out.writeByte(n);
        	}
        	out.position = 0;
        	return out;
        }
        
        
        /**
        *  解凍用
        */
        protected function zdecode(n:uint):uint{
        	var t:uint = n;
        	
        	var d:uint = decryptByte();
        	n ^= d;
        	updateKeys(n);
        	return n;
        }
        /**
        *  暗号用
        */
        protected function zencode(n:uint):uint{
            var t:uint = decryptByte();
            updateKeys(n);
            return (t ^ n);
        }
        
        /**
        *
        *  @return unsigned char
        */
        protected function decryptByte():int{
            var temp:uint = _key[2] & 0xFFFF | 2;
            var ret:int = ((temp * ( temp ^ 1 )) >> 8 ) & 0xFF;
            return ret;
        }
        /**
        *
        *
        */
        protected function updateKeys(uchar:uint):void{
        	
            _key[0] = ZipCRC32.getCRC32(_key[0],uchar);
            _key[1] = _key[1] + (_key[0] & 0xFF);
            
            //  ここで２つに分けるのは計算途中でNumber型になってしまい精度が落ちてしまうので・・・
            var k2:int = _key[1];
            var b1:int = 134775000;
            var b2:int = 813;
            var t:int = uint(k2 * b1) + uint(k2 * b2 )  + 1;
            _key[1] = t;
            
            var k3:int = _key[1];
            
            var tmp:int =  _key[1] >> 24 ;
            _key[2] = int(ZipCRC32.getCRC32(_key[2], tmp));
        }
	}
}