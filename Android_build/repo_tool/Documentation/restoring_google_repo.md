## Restoring a corrupt google repo

Android 12 Source tree @ ~/android/12

Working on corrupt ${CROOT}/frameworks/av git repo.

### Case #1

	- ~/android/12/frameworks (git av/ deleted)
	- ~/android/12/.repo/projects/frameworks (git av.git/ deleted)
	- ~/android/12/.repo/project-objects/platform/frameworks/av.git remains

#### [1] ~/android/12/.repo/manifests/default.xml

In the ~/android/12/.repo/manifests/default.xml the
frameworks/av git repo stays defined as:

	  <project path="frameworks/av" name="platform/frameworks/av" groups="pdk" />

#### [2] Remove av/ git repo (test)

	$ ls -al ~/android/12/frameworks
	$ rm -rf ~/android/12/frameworks/av
	$ ls -al ~/android/12/frameworks

#### [3] rm -rf ~/android/12/.repo/projects/frameworks/av.git (test)

	$ ls -al ~/android/12/.repo/projects/frameworks
	$ rm -rf ~/android/12/.repo/projects/frameworks/av.git
	$ ls -al ~/android/12/.repo/projects/frameworks

#### [4] Check if ~/android/12/.repo/project-objects/platform/frameworks/av.git exists?

	$ ls -al ~/android/12/.repo/project-objects/platform/frameworks

#### [5] Recover git repo frameworks/av:

	$ ~/android/12$ repo sync

	$ ~/android/12$ repo sync
	Fetching: 100% (1040/1040), done in 7m50.363s
	Updating files: 100% (4469/4469), done.xternal/zlibUpdating files:  86% (3844/4469)
	Checking out: 100% (1040/1040), done in 4m30.675s
	repo sync has finished successfully.

### Case #2

	- ~/android/12/frameworks (git av/ deleted)
	- ~/android/12/.repo/projects/frameworks (git av.git/ deleted)
	- ~/android/12/.repo/project-objects/platform/frameworks (git av.git/ deleted)

#### [1] ~/android/12/.repo/manifests/default.xml

In the ~/android/12/.repo/manifests/default.xml the
frameworks/av git repo stays defined as:

	  <project path="frameworks/av" name="platform/frameworks/av" groups="pdk" />

#### [2] Remove av/ git repo (test)

	$ ls -al ~/android/12/frameworks
	$ rm -rf ~/android/12/frameworks/av
	$ ls -al ~/android/12/frameworks

#### [3] rm -rf ~/android/12/.repo/projects/frameworks/av.git (test)

	$ ls -al ~/android/12/.repo/projects/frameworks
	$ rm -rf ~/android/12/.repo/projects/frameworks/av.git
	$ ls -al ~/android/12/.repo/projects/frameworks

#### [4] rm -rf ~/android/12/.repo/project-objects/platform/frameworks/av.git (test)

	$ ls -al ~/android/12/.repo/project-objects/platform/frameworks
	$ rm -rf ~/android/12/.repo/project-objects/platform/frameworks/av.git
	$ ls -al ~/android/12/.repo/project-objects/platform/frameworks

#### [5] Make attempt with repo sync command?

	$ ~/android/12$ repo sync --force-sync
	Fetching: 99% (1039/1040) 9:45 | 1 job | 9:45 platform/frameworks/av @ frameworks/av^CProcess ForkPoolWorker-5:
	Process ForkPoolWorker-4:
	Process ForkPoolWorker-6:
	Fetching:  99% (1039/1040), done in 9m46.562s
	^c (keyboard interrupt)
	================================================================================
	Repo command failed: RepoUnhandledExceptionError

Repeat repo sync --force-sync

	$ ~/android/12$ repo sync --force-sync 
	Fetching: 100% (1040/1040), done in 10m34.035s
	Updating files: 100% (4469/4469), done.xternal/zstdUpdating files:  60% (2722/4469)
	Checking out: 100% (1040/1040), done in 3m59.932s
	repo sync has finished successfully.

### Case #3

	- ~/android/12/frameworks (git av/ deleted)
	- ~/android/12/.repo/projects/frameworks (git av.git/ deleted)
	- ~/android/12/.repo/project-objects/platform/frameworks (git av.git/ deleted)

#### [1] Make attempt with repo sync --force-sync command?

	$ ~/android/12$ repo sync --force-sync

	Fetching:  0% (0/1040) 0:00 | ..working..error: hooks is different in
	/home/vuser/android/12/.repo/projects/frameworks/av.git vs
	/home/vuser/android/12/.repo/project-objects/platform/frameworks/av.git

	error.GitError: Cannot fetch --force-sync not enabled; cannot overwrite
	a local work tree. If you're comfortable with the possibility of losing
	the work tree's git metadata, use `repo sync --force-sync frameworks/av`
	to proceed.

#### [2] If repo sync --force-sync failed. then do git clone of av repo:

	$ ~/android/12/frameworks$ git clone https://android.googlesource.com/platform/frameworks/av

	Cloning into 'av'...
	remote: Sending approximately 247.22 MiB ...
	remote: Counting objects: 4830, done
	remote: Total 457454 (delta 309944), reused 457454 (delta 309944)
	Receiving objects: 100% (457454/457454), 247.21 MiB | 24.74 MiB/s, done.
	Resolving deltas: 100% (309944/309944), done.
	Updating files: 100% (5314/5314), done.

#### [3] Create proper ~/android/12/.repo/projects/frameworks/av.git

	$ ~/android/12/frameworks$ cd av
	$ ~/android/12/frameworks/av$ mv .git ../../.repo/projects/frameworks/av.git

#### [4] Make correct link to the ~/android/12/.repo/projects/frameworks/av.git

	$ ~/android/12/frameworks/av$ ln -s ../../.repo/projects/frameworks/av.git .git

	$ ~/android/12/frameworks/av$ ls -al
	total 100
	drwxr-xr-x. 11 vuser vboxusers  4096 Dec 11 11:32 .
	drwxr-xr-x. 16 vuser vboxusers  4096 Dec 11 11:28 ..
	drwxr-xr-x.  4 vuser vboxusers  4096 Dec 11 11:28 aidl
	-rw-r--r--.  1 vuser vboxusers  4462 Dec 11 11:28 Android.bp
	drwxr-xr-x.  4 vuser vboxusers  4096 Dec 11 11:28 apex
	drwxr-xr-x.  8 vuser vboxusers  4096 Dec 11 11:28 camera
	-rw-r--r--.  1 vuser vboxusers   291 Dec 11 11:28 .clang-format
	-rw-r--r--.  1 vuser vboxusers  5479 Dec 11 11:28 CleanSpec.mk
	drwxr-xr-x.  4 vuser vboxusers  4096 Dec 11 11:28 cmds
	drwxr-xr-x.  9 vuser vboxusers  4096 Dec 11 11:28 drm
	lrwxrwxrwx.  1 vuser vboxusers    38 Dec 11 11:32 .git -> ../../.repo/projects/frameworks/av.git
	drwxr-xr-x.  6 vuser vboxusers  4096 Dec 11 11:28 include
	-rw-r--r--.  1 vuser vboxusers  1198 Dec 11 11:28 MainlineFiles.cfg
	drwxr-xr-x. 35 vuser vboxusers  4096 Dec 11 11:28 media
	-rw-r--r--.  1 vuser vboxusers  1245 Dec 11 11:28 METADATA
	-rw-r--r--.  1 vuser vboxusers     0 Dec 11 11:28 MODULE_LICENSE_APACHE2
	-rw-r--r--.  1 vuser vboxusers 17680 Dec 11 11:28 NOTICE
	-rw-r--r--.  1 vuser vboxusers   561 Dec 11 11:28 OWNERS
	-rw-r--r--.  1 vuser vboxusers  1172 Dec 11 11:28 PREUPLOAD.cfg
	drwxr-xr-x. 13 vuser vboxusers  4096 Dec 11 11:28 services
	drwxr-xr-x.  2 vuser vboxusers  4096 Dec 11 11:28 tools

#### [5] Make attempt to repo sync again (eventualy with --force-sync)?

	$ ~/android/12$ repo sync
	Fetching: 100% (1040/1040), done in 6m11.213s
	Updating files: 100% (4469/4469), done.xternal/zstdUpdating files:  60% (2719/4469)
	Checking out: 100% (1040/1040), done in 3m53.775s
	repo sync has finished successfully.

### Case #4

Use an investigation and an imagination!

	$ ~/android/12$ find . -iname av.git
	./.repo/project-objects/projects/github/frameworks/av.git
	./.repo/project-objects/platform/hardware/google/av.git
	./.repo/project-objects/platform/frameworks/av.git
	./.repo/project-objects/frameworks/av.git
	./.repo/projects/hardware/google/av.git
	./.repo/projects/projects/github/frameworks/av.git
	./.repo/projects/platform/frameworks/av.git
	./.repo/projects/frameworks/av.git
