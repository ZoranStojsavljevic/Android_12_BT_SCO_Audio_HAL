### Android 12 BT SCO Audio HAL source code

The source code (which I guess is generic) is taken from the very old
repository unchanged (as is). To prove theory that from changes which
introduced UNIX sockets to the code (with very little modifications)
can serve the purpose even with Android 12 Bluedroid/Fluoride BT SCO
stack.

Google introduced in Android 11 Gabeldorsche BT stack, which is using
binderized interface for IPC (across processes), instead UNIX socket
approach (saving some kernel space memory copying). In Android 13
Gabeldorsche (in real World kind of fish) became to be default stack.

The compilation command to make audio.sco.default.so is (from croot):

	source build/envsetup.sh
	mm audio.sco.default

### The source code itself

Here is the source directory:

	Android.bp
	README.md 
	audio_sco_hw.c 
	audio_sco_hw.h

The audio_sco_hw.h (as is) copied from:

https://github.com/jasonyuananbei/sunniwell_bluetooth/blob/release_custom/bluedroid/realtek/include/audio_sco_hw.h

The audio_sco_hw.c (as is) copied from:

https://github.com/jasonyuananbei/sunniwell_bluetooth/blob/release_custom/bluedroid/realtek/audio_hw/audio_sco_hw.c

### Adaptations to be made

	vendor/gtr/sg1001/audio/bt_sco_hal/audio_sco_hw.c:908:37: warning: incompatible pointer types
	adev->device.open_output_stream = adev_open_output_stream;
					^ ~~~~~~~~~~~~~~~~~~~~~~~

	vendor/gtr/sg1001/audio/bt_sco_hal/audio_sco_hw.c:910:36: warning: incompatible pointer types
	adev->device.open_input_stream  = adev_open_input_stream;
					^ ~~~~~~~~~~~~~~~~~~~~~~~

The adaptations to be made are to adjust interfaces of these two functions from:

	croot/hardware/libhardware/include/hardware/audio.h

In other words to adapt AUDIO_DEVICE_API_VERSION_2_0 to AUDIO_DEVICE_API_VERSION_3_2 .

As an example:

	int (*open_output_stream)(struct audio_hw_device *dev,
				  audio_io_handle_t handle,
				  audio_devices_t devices,
				  audio_output_flags_t flags,
				  struct audio_config *config,
				  struct audio_stream_out **stream_out,
				  const char *address);

Please, also pay attention that there are few deprecated functionalities.

