### Android 12 BT SCO Audio_HAL

[IMPORTANT] It supposed to be NXP implementation of the Android 12 BT SCO
Audio HAL. The whole Android 12 tree is in fact downloaded from the NXP site!

Initially approximately (Android 12) 150 mio lines of code downloded... What
a lovely mess!

I sincerely hope that this vendor BT SCO Audio HAL implementation, shown
here, is a very generic one (NOT bound to the specific vendor code
modifications)!

#### System Architecture

The sketch of the BT SCO Audio HAL system architecture is shown here:

        Audio Policy Service
                |
                V
        Audio Flinger Service
                |
                V
          BT SCO Audio HAL
                |                                  +------> Host Controler Interface
                V                                  |                  |
        Unix Socket Client                 Unix Socket Server         V
      (SCO and data sockets)             (SCO and data sockets)       |
                |                                  ^                  V
                V                                  |                  |
           Linux Kernel   (context switch)    Linux Kernel            V
                |                                  ^                  |
                | (PID1) UNIX Domain Socket (PID2) |                  V
                V     Only local communication     |                  |
                +----------------------------------+                  V
                                                                UART/SPI/USB

#### Interface definitions

The intention of the repo author is to write some meaningful documentation
about the very small part of the croot/system/bt, the Android 12 BT SCO
Audio HAL which finalizes xfer of the CTRL Synchronous Connection-Oriented
(SCO) and audio (data) channels.

The  story should start from the interfaces definitions. The best place to
start are the interface definitions, which are placed in this file:

	croot/hardware/libhardware/include/hardware/audio.h

Here is the typical example, which will be shown through this document in
various places in the contex of Audio Flinger. One of the very important
interfaces in audio.h which will and is serving as an example:

	/*
	 * This method creates and opens the audio hardware output stream.
	 * The "address" parameter qualifies the "devices" audio device type
	 * if needed.
	 * The format format depends on the device type:
	 * - Bluetooth devices use the MAC address of the device in the form
	     "00:11:22:AA:BB:CC"
	 * - USB devices use the ALSA card and device numbers in the form
	    "card=X;device=Y"
	 * - Other devices may use a number or any other string.
	 */

	int (*open_output_stream)(struct audio_hw_device *dev,
				  audio_io_handle_t handle,
				  audio_devices_t devices,
				  audio_output_flags_t flags,
				  struct audio_config *config,
				  struct audio_stream_out **stream_out,
				  const char *address);

Please, do note that the version of this interface definition for Android 12 is
the following:

	61	#define AUDIO_DEVICE_API_VERSION_CURRENT AUDIO_DEVICE_API_VERSION_3_2

Here, the very important fact to mention is that BT SCO Audio HAL runs in
the contex of Audio Flinger (the same process PID), where the context switch
happens in the form of UNUX sockets (two channels, SCO CTRL and Audio data).

This fact will be reiterated couple of times in this document.

#### Audio Flinger

The Android 12 Audio Flinger is defined in the following directory:

	croot/frameworks/av/services/audioflinger

Two very important files from the directory (essence):

	 43928 Feb 18 02:55 AudioFlinger.h
	165390 Feb 18 02:55 AudioFlinger.cpp

##### Audio Flinger: AudioFlinger.h

The Android 12 location:

	croot/frameworks/av/services/audioflinger/AudioFlinger.h

To be up to the metal, the important part of this presentation is given here
(if you know what I am writing 'bout, you are on the right track):

	879    // for dump, indicates which hardware operation is currently in progress (but not stream ops)
	880    enum hardware_call_state {
	881         AUDIO_HW_IDLE = 0,              // no operation in progress
	882         AUDIO_HW_INIT,                  // init_check
	883         AUDIO_HW_OUTPUT_OPEN,           // open_output_stream
	884         AUDIO_HW_OUTPUT_CLOSE,          // unused
	885         AUDIO_HW_INPUT_OPEN,            // unused
	886         AUDIO_HW_INPUT_CLOSE,           // unused
	887         AUDIO_HW_STANDBY,               // unused
	888         AUDIO_HW_SET_MASTER_VOLUME,     // set_master_volume
	889         AUDIO_HW_GET_ROUTING,           // unused
	890         AUDIO_HW_SET_ROUTING,           // unused
	891         AUDIO_HW_GET_MODE,              // unused
	892         AUDIO_HW_SET_MODE,              // set_mode
	893         AUDIO_HW_GET_MIC_MUTE,          // get_mic_mute
	894         AUDIO_HW_SET_MIC_MUTE,          // set_mic_mute
	895         AUDIO_HW_SET_VOICE_VOLUME,      // set_voice_volume
	896         AUDIO_HW_SET_PARAMETER,         // set_parameters
	897         AUDIO_HW_GET_INPUT_BUFFER_SIZE, // get_input_buffer_size
	898         AUDIO_HW_GET_MASTER_VOLUME,     // get_master_volume
	899         AUDIO_HW_GET_PARAMETER,         // get_parameters
	900         AUDIO_HW_SET_MASTER_MUTE,       // set_master_mute
	901         AUDIO_HW_GET_MASTER_MUTE,       // get_master_mute
	902         AUDIO_HW_GET_MICROPHONES,       // getMicrophones
	903     };

We'll all see (later on) what is this table about, and what is really
happening in here!

##### Audio Flinger: AudioFlinger.cpp

Yes, this is a very important momentum! How the Android 12 Audio Flinger
manages this!

The function of the extreme importance... AudioFlinger.cpp!

	croot/frameworks/av/services/audioflinger/AudioFlinger.cpp

In the function: openOutput_l() :

	2502  sp<AudioFlinger::ThreadBase> AudioFlinger::openOutput_l(
			audio_module_handle_t module,
	2503		audio_io_handle_t *output,
	2504		audio_config_t *config,
	2505		audio_devices_t deviceType,
	2506		const String8& address,
	2507		audio_output_flags_t flags)

And here it is... The beloved Example (from above function: openOutput_l)!

	2546	AudioStreamOut *outputStream = NULL;
	2547	status_t status = outHwDev->openOutputStream(
	2548		&outputStream,
	2549		*output,
	2550		deviceType,
	2551		flags,
	2552		config,
	2553		address.string());

This is actually a callback from Audio Flinger to the BT SCO Audio HAL.

Precisely, to this source code location (we are tracking here):

	/vendor/nxp-opensource/imx/audio/bt_sco_hal/audio_sco_hw.c

To this function in BT SCO Audio HAL via the following setup:

	912	adev->device.open_output_stream = adev_open_output_stream;

Described here:

	612  static int adev_open_output_stream(struct audio_hw_device *dev,
	613					audio_io_handle_t handle,
	614					audio_devices_t devices,
	615					audio_output_flags_t flags,
	616					struct audio_config *config,
	617					struct audio_stream_out **stream_out,
	618					const char *address)

Please, do remember! BT SCO Audio HAL runs in the contex of Audio Flinger
(the same process PID), where the context change happens in the form of
UNIX sockets (two channels, SCO CTRL and Audio data).

The UNIX sockets are (by example) shown here:

UNIX Socket Client:
https://github.com/ZoranStojsavljevic/test-socket-if/tree/master/UNIX_socket/unix_client

UNIX Socket Server:
https://github.com/ZoranStojsavljevic/test-socket-if/tree/master/UNIX_socket/unix_server



#### Layer beneath Audio Flinger: Android 12 BT SCO Audio HAL

The default (some ideas required for true porting) location in Android 12.

BT SCO Audio HAL:

	croot/vendor/nxp-opensource/imx/audio

	./bt_sco_hal
	./bt_sco_hal/audio_sco_hw.h
	./bt_sco_hal/audio_sco_hw.c
	./bt_sco_hal/Android.bp

Initial porting location example.

What all of these do mean? This is the last phase of porting ./bt_sco_hal
to Bluedroid... In other words, the same as Bluedroid: Fluoride!

And here are the callbacks (as you read all above, just some of them are
implemented in the Audio Flinger)!

From: /vendor/nxp-opensource/imx/audio/bt_sco_hal/audio_sco_hw.c

	875 static int adev_open(const hw_module_t* module, const char* name,
	876                      hw_device_t** device)

	893     adev->device.common.tag = HARDWARE_DEVICE_TAG;
	894     adev->device.common.version = AUDIO_DEVICE_API_VERSION_CURRENT;
	895     adev->device.common.module = (struct hw_module_t *) module;
	896     adev->device.common.close = adev_close;
	897
	898     // Audio HAL implementations started with AUDIO_DEVICE_API_VERSION_2_0 do not supprot this interface.
	899     // adev->device.get_supported_devices  = adev_get_supported_devices;
	900     adev->device.init_check = adev_init_check;
	901     adev->device.set_voice_volume = adev_set_voice_volume;
	902     adev->device.set_master_volume = adev_set_master_volume;
	903     adev->device.get_master_volume = adev_get_master_volume;
	904     adev->device.set_master_mute = adev_set_master_mute;
	905     adev->device.get_master_mute = adev_get_master_mute;
	906     adev->device.set_mode = adev_set_mode;
	907     adev->device.set_mic_mute = adev_set_mic_mute;
	908     adev->device.get_mic_mute = adev_get_mic_mute;
	909     adev->device.set_parameters = adev_set_parameters;
	910     adev->device.get_parameters = adev_get_parameters;
	911     adev->device.get_input_buffer_size = adev_get_input_buffer_size;
	912     adev->device.open_output_stream = adev_open_output_stream;	<<======= example =======
	913     adev->device.close_output_stream = adev_close_output_stream;
	914     adev->device.open_input_stream = adev_open_input_stream;
	915     adev->device.close_input_stream = adev_close_input_stream;
	916     adev->device.dump = adev_dump;

As stated above!

	612  static int adev_open_output_stream(struct audio_hw_device *dev,
	613					audio_io_handle_t handle,
	614					audio_devices_t devices,
	615					audio_output_flags_t flags,
	616					struct audio_config *config,
	617					struct audio_stream_out **stream_out,
	618					const char *address)

##### Context switch (UNIX client)

Context switch is done via the following function (audio_sco_hw.c):

	119  static int skt_connect(char *path,
				    int sndbufsize,
				    int rcvbufsize,
				    int sndto,
				    int rcvto)
	171  return skt_fd;

File descriptor skt_fd is used for send() and recv() to UNIX socket server.

There are two copies in the kernel space per send()/recv() transaction.

One copy is done by client to client kernel space, the second one is done
from client kernel space to server kernel space, from were server reads
the data.

	186  static uint32_t sco_get_sample_rate(struct sco_audio_device * dev)
	187  {
	188	 char response[64];
	189	 int res;
	190	 uint32_t samplerate = SCO_SAMPLE_RATE_8K;
	191
	192	 if(dev) {
	193	     pthread_mutex_lock(&(dev->lock));
	194	     if (dev->ctrlfd <= 0)
	195		  dev->ctrlfd = skt_connect(SCO_CTRL_PATH, 0, 0, 0, 2000000);
	196	     if (dev->ctrlfd > 0) {
	197		  memset(response,0,sizeof(response));
	198		  res = send(dev->ctrlfd, SCO_CTRL_GETSAMPLERATE, strlen(SCO_CTRL_GETSAMPLERATE),0);
	199		  res = recv(dev->ctrlfd, response, sizeof(response),0);

#### Host Controller Interface (HCI)

The host controller interface (HCI) layer is a thin layer which transports
commands and events between the host and controller elements of the Bluetooth
protocol stack. In a pure network processor application the HCI layer is
implemented through a transport protocol such as SPI or UART.

In embedded wireless MCU projects the HCI layer is implemented through
function calls and callbacks within the wireless MCU. All of the commands
and events discussed that communicate with the controller, such as ATT,
GAP, etc, will eventually call an HCI API to pass from the upper layers
of the protocol stack through the HCI layer to the controller.
Likewise, the controller sends received data and events to the host and
upper layers through HCI.

#### HCI layer (UNIX server)

Here, the SCO and data messages come through server sockets to the Bluetooth
HCI layer.

	croot/system/bt/hci/src/hci_inject.cc

	89:  if (!socket_listen(listen_socket, LISTEN_PORT)) goto error;

The messages are read by HCI layer and send to the UART/SPI/USB (to be
passed to the Bluetooth controller).

Author

