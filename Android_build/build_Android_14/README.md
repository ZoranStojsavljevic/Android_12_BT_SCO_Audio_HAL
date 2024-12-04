## Fetching and compiling the entire Android 14 source code

Fetching and compiling the entire Android 14 source code
involves several steps, which are detailed below. A suitable
development environmentis required, some knowledge of using
Git, and tools like repo and Android build system to download,
configure, and build the Android codebase.

Step-by-Step Guide to Fetch and Compile Android 14 Code!

Set Up Development Environment:

### 1. Prerequisites

#### System Requirements

Before start, ensure that your development machine meets the
following prerequisites:

	- Operating System: Ubuntu (or other Linux-based OS) is
	  preferred, though macOS or Windows with WSL (Windows
	  Subsystem for Linux) could be used.

	- Processor: A multi-core processor is recommended.

	- Disk Space: disk space (at least 200GB for the Android
	  source).

	- RAM: A minimum of 16GB of RAM is recommended for smooth
	  compilation.

#### Install Required Packages on Ubuntu

	$ sudo apt update
	$ sudo apt install -y \
	git \
	gnupg \
	flex \
	bison \
	gperf \
	build-essential \
	zip \
	curl \
	zlib1g-dev \
	libc6-dev \
	lib32z1-dev \
	lib32ncurses5-dev \
	lib32stdc++6 \
	lib32gcc1 \
	libx11-dev \
	libxml2-utils \
	xsltproc \
	unzip \
	python3 \
	python3-pexpect \
	python3-markdown \
	libssl-dev

#### Set Up Java Development Kit (JDK)

Android 14 requires JDK 11, so if there is none of JDK 11 on the
host, JDK 11 should be installed with the command:

	## Ubuntu install command
	$ sudo apt install openjdk-11-jdk

	## Fedora install command
	$ sudo dnf install java-11-openjdk.x86_64

Alternative command (independent of host distro used):

	$ sudo update-alternatives --config java	

Make sure the Java environment is set correctly by running:

	$ java -version

It should output the version of OpenJDK 11.

### 2. [OPTIONAL] Install Repo Tool (if does not exist)

If there is no ~/bin/repo tool installed, the next steps must be
performed!

The Android source code is managed using repo, a tool developed
by Google to simplify working with multiple Git repositories.
You need to install it first.

	$ mkdir -p ~/bin
	$ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	$ chmod a+x ~/bin/repo

Ensure that ~/bin is added to your PATH environment variable.

	$ export PATH=~/bin:$PATH

### 3. Initialize the Android 14 Source Repository

A directory for the Android source should be created and
the repo tool initialized. This will fetch the Android 14
repositories.

#### 1. Create a directory for the source code:

	$ mkdir -p ~/android/14
	$ cd ~/android/14

#### 2. Initialize the repository with the Android 14 code

Initialize the repository with the Android 14 code:

	$ repo init -u https://android.googlesource.com/platform/manifest.git -b android-14.0.0_r1

This command sets up the repo configuration, pointing to
Google's Android source and initializing the android-14
branch.

#### 3. Sync the Android 14 Source Code

The next step is to download the Android 14 source code.
This process will take a while since it fetches many Git
repositories.

Download the entire source code (~100GB+):

	$ repo sync -j$(nproc)

Add --no-clone-bundle if you face shallow clone issues:

	$ repo sync -j$(nproc) --no-clone-bundle

This command may take a few hours or more depending on the
internet speed and the number of repositories being fetched
(> 1000).

### 4. Set up and configure the Build Environment

#### 1. Set Up the Build Environment

From the root of the Android source tree:

	$ source build/envsetup.sh

#### 2. Select a Build Target

Use the lunch command to choose the target device and build variant:

	$ lunch <target_product>-<build_variant>

Example for a generic ARM64 device:

	$ lunch aosp_arm64-eng

Common build variants:

	user: Optimized for production (secure, no debug tools).

	userdebug: Debuggable version of user (for testing and debugging).

	eng: Full debugging features enabled (for development).

### 5. Build the Entire Android 14 System

#### 1. Start the Build:

To build the entire system:

	$ make -j$(nproc)

-j$(nproc) utilizes all available CPU cores for faster
compilation.

Alternatively, use:

	$ m

This is shorthand for the same build command.

#### 2. [OPTIONAL] to build specific components

To build only the system image:

	$ make systemimage

To build the boot image:

	$ make bootimage

#### 3. Monitor Build Progress

The build process can take 1-12 hours or more, depending on your
hardware.

Output files will be generated in the following directory:

	$(croot)/out/target/product/<device_name>/

### 6. Flash the Built Android 14 Image

Once the build process is complete, the compiled images are in
the following directory:

	$(croot)/out/target/product/<device_name>/

These images can be flashed to a supported (target) device using
fastboot. Assuming the target device is connected via USB (ADB),
the following command can be executed:

	$ fastboot flashall -w

The -w flag wipes the data partition, -w should be used with the
great caution!

The bootloader should be unlocked on the target device before
flashing.

### 7. Maintain and Customize the Code

After successfully compiled and flashed Android 14, the code can
be customized, add additional features, or create own Android
distribution (ROM).

#### 1. Make Modifications:

The Android codebase is modular. Frameworks, system apps etc.
can be modifid, or add a new functionality.

After making changes, rebuild the specific components (e.g.,
make systemimage) and flash them to your device.

#### 2. Contribute Back (Optional):

To contribute changes to the Android Open Source Project (AOSP),
the contribution guidelines should be followed provided by
Google on Android's AOSP Contribution Guide.

### 8. Advanced Tips for Professionals

#### 1. Optimize Build Time:

Enable caching to speed up future builds.

Use the distcc tool for distributed compilation across multiple
machines.

#### 2. Debugging:

Use adb logcat to view logs from the device for debugging.

Set up a debuggable build using the userdebug configuration for debugging.

#### 3. Build Variants:

Android supports different build variants, such as user,
userdebug, and eng. The userdebug variant is usually the
most suitable for development, as it allows debugging with
root access.

#### 4. Automate Builds:

Set up a CI/CD pipeline for automatic builds and testing using
services like Jenkins, GitHub Actions, or Google’s own Build
System.

### Conclusion

Fetching and compiling Android 14 from source requires an
understanding of the tools involved and careful setup of the
build environment. By following these professional steps, it
will be able to download, compile, and customize the Android 14
codebase for your specific needs. This process is invaluable
for deep customization, device support, and contributing to the
Android Open Source Project.
