// ActionScript file
import com.coltware.airxzip.ZipEvent;
import com.coltware.airxzip.ZipFileWriter;

import flash.filesystem.File;
import flash.utils.ByteArray;

import mx.controls.Alert;
/**
 *  Make zip file
 * 
 */
public function zip_sample1():void{
	var writer:ZipFileWriter = new ZipFileWriter();
	writer.open(File.desktopDirectory.resolvePath("new_airxzip.zip"));
	
	//  Add ByteArray
	var data:ByteArray = new ByteArray();
	data.writeUTFBytes("SAMPLE");
	writer.addBytes(data,"sample.txt");
	
	//  Add Directory
	writer.addDirectory("Foo1");
	
	writer.addFile(File.desktopDirectory.resolvePath("image.jpg"),"Foo1/image.jpg");
	writer.close();
}
/**
 *  Make ZIP file
 *  ( async version )
 */
public function zip_sample2():void{
	var writer:ZipFileWriter = new ZipFileWriter();
	writer.addEventListener(ZipEvent.ZIP_FILE_CREATED,zipFileCreated);
	writer.openAsync(File.desktopDirectory.resolvePath("async_airxzip.zip"));
	
	//  Add ByteArray
	var data:ByteArray = new ByteArray();
	data.writeUTFBytes("SAMPLE");
	writer.addBytes(data,"sample.txt");
	
	//  Add Directory
	writer.addDirectory("Foo1");
	
	writer.addFile(File.desktopDirectory.resolvePath("image.jpg"),"Foo1/image.jpg");
	writer.close();
}
private function zipFileCreated(e:ZipEvent):void{
	Alert.show("zip file created !!");
}

/**
 *  Make zip file
 *  ( ZipCrypto )
 */
public function zip_sample3():void{
	var writer:ZipFileWriter = new ZipFileWriter();
	writer.setPassword("pass");
	writer.open(File.desktopDirectory.resolvePath("crypto_airxzip.zip"));
	
	//  Add ByteArray
	var data:ByteArray = new ByteArray();
	data.writeUTFBytes("SAMPLE");
	writer.addBytes(data,"sample.txt");
	
	//  Add Directory
	writer.addDirectory("Foo1");
	
	writer.addFile(File.desktopDirectory.resolvePath("image.jpg"),"Foo1/image.jpg");
	writer.close();
}
