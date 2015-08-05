Zip library for ActionScript3 on AIR

# features #

## 1) Specialize in AIR ##

It becomes possible for the access to begin at the end of the file ( zip entry infomations ),

It does not to depend on the size of zip file.

So It is able to access information quickly,not loading it entire archive into memory.


## 2) Async/Sync upzip ##

Airxzip has 2 unzip method. ( unzip() and unzipAsync() )

## 3) PKWare encrypt/decrypt ##

## 4) File attribute ( Zip mode only) ##
Enable to set file attirbute.
ex) “0700″ “0755″

## 5) Japanese filename ##
Mac OS and Unix filename is UTF-8, Windows is Shift\_JIS.

And Mac OS UTF-8 and Unix UTF-8 is not same to handle Hankaku-kana.

So Airxzip resolve these difference automatically.

# sample code #

http://code.google.com/p/airxzip/source/browse/#svn/trunk/samples/src/scripts