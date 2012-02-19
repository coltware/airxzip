// ActionScript file
import com.coltware.airxzip.ZipEntry;
import com.coltware.airxzip.ZipError;
import com.coltware.airxzip.ZipFileReader;
import com.coltware.airxzip.*;

import flash.filesystem.File;
import flash.utils.ByteArray;

use namespace zip_internal;

public function unzip_init(filename:String):ZipFileReader{
	var reader:ZipFileReader = new ZipFileReader();
	var file:File = File.desktopDirectory.resolvePath(filename);
	reader.open(file);
	return reader;
}

public function unzip_sample1():void{
	var reader:ZipFileReader = unzip_init("new_airxzip.zip");
	var list:Array = reader.getEntries();
	
	for each(var entry:ZipEntry in list){
		
		if(entry.isDirectory()){
			log.debug("DIR  --->" + entry.getFilename());
		}
		else{
			log.debug("FILE --->" + entry.getFilename() + "(" + entry.getCompressRate() + ")");
		}
	}
}

public function unzip_sample2():void{
	var reader:ZipFileReader = unzip_init("new_airxzip.zip");
	var list:Array = reader.getEntries();
	
	for each(var entry:ZipEntry in list){
		if(!entry.isDirectory()){
			if(entry.getFilename() == "sample.txt"){
				var bytes:ByteArray = reader.unzip(entry);
				log.debug("sample.txt : " + bytes);
			}
		}
	}
}

public function unzip_sample3():void{
	var reader:ZipFileReader = unzip_init("crypto_airxzip.zip");
	reader.setPassword("pass");
	var list:Array = reader.getEntries();
	
	for each(var entry:ZipEntry in list){
		if(!entry.isDirectory()){
			if(entry.getFilename() == "sample.txt"){
				try{
					var bytes:ByteArray = reader.unzip(entry);
					log.debug("sample.txt : " + bytes);
				}
				catch(e:ZipError){
					log.warn(entry.getFilename() + ":" + e.message);
				}
			}
		}
	}
}
public function unzip_sample4():void{
	var reader:ZipFileReader = unzip_init("abc.zip");
	var list:Array = reader.getEntries();
	for each(var entry:ZipEntry in list){
		entry.dumpLogInfo();
	}
}