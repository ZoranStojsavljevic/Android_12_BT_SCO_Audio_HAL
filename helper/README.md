### Conversion from Android.mk to Android.bp
https://stackoverflow.com/questions/51207766/where-can-i-find-androidmk-tool-to-convert-android-mk-to-android-bp

	source build/envsetup.sh
	cd "the directory where android.mk to be converted is present"
	androidmk Android.mk
	Then Copy the output to Android.bp file
	androidmk Android.mk > Android.bp

