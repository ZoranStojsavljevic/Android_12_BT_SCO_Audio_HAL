### Conversion from Android.mk to Android.bp
https://stackoverflow.com/questions/51207766/where-can-i-find-androidmk-tool-to-convert-android-mk-to-android-bp

Clone the full android source and prepare for a build like
usual, using . build/envsetup.sh, then run make
blueprint_tools. Simply run androidmk and the command will
be in the PATH.

NOTE: build/ directory is in android $(root) directory

#### Method 1

	source build/envsetup.sh
	make blueprint_tools
	## Simply run androidmk and the command will be in the PATH
	androidmk Android.mk
	## Then Copy the output to Android.bp file
	androidmk Android.mk > Android.bp

#### Method 2 (?)

	source build/envsetup.sh
	## cd "the directory where android.mk to be converted is present"
	androidmk Android.mk
	## Then Copy the output to Android.bp file
	androidmk Android.mk > Android.bp
