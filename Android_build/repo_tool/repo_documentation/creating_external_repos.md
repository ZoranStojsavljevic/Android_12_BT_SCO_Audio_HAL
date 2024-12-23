## Creating/Handling external git repositories, taken out of the Android tree

In this real example, the following is used:

The Android 12 tree original path is croot=~/android/12 .

The Android 12 external path is ext_croot=~/projects/github/ .

As the generic approach is preffered, variables $croot and
$ext_croot are used.

Example used (original line from $croot/.repo/manifests/default.xml):

	<project path="frameworks/av" name="platform/frameworks/av" groups="pdk" />

### Android 12 Manifest

```
<?xml version="1.0" encoding="UTF-8"?>
<manifest>

  <remote  name="aosp"
           fetch="https://android.googlesource.com/"/>
  <remote  name="ZoranStojsavljevic"
           fetch="https://github.com/ZoranStojsavljevic/"/>
  <default revision="refs/tags/android-12.0.0_r1"
           remote="aosp"
           sync-j="4" />

Current line 67x (internal android 12 tree):
  <project path="frameworks/av" name="platform/frameworks/av" groups="pdk" />

Change to the following line (out of the internal android 12 tree):
  <project path="frameworks/av" name="platform_frameworks_av" remote="ZoranStojsavljevic"/>

```

### Creating a github Android 12 external git repo

Please, consider reading (as education material) the following
article!
* [git push to remote branch](https://phoenixnap.com/kb/git-push-to-remote-branch)

Using a github GUI interface, create a github (external) git
platform_frameworks_av repo. Please, leave this repo empty.

Go to the workspace directory where platform/frameworks/av will
be created ($ext_croot). This will be a local git repo reflecting
a remote git repo. Please, do the following commands.

Find the current tag for Android 12 tree git repo frameworks/av:

Execute, before starting, just to check android 12 integrity:

	$croot/frameworks/av$ repo status

If this passes clean, the operation create external repo can
start:

	$croot/frameworks/av$ git status
	Not currently on any branch.
	nothing to commit, working tree clean

	$croot/frameworks/av$ git describe
	android-12.0.0_r34

Remove Android 12 tree frameworks/av git:

	$croot/frameworks/av$ cd ..

	$croot/frameworks$ rm -rf av

Here the manifest line swap operation for frameworks/av should
take place:

```
File default.xml is an original manifest for the $croot Android
12 tree!

It is located here: $croot/.repo/manifests/default.xml

Current line 67x (internal android 12 tree):
  <project path="frameworks/av" name="platform/frameworks/av" groups="pdk" />

Change to the following line (out of the internal android 12 tree):
  <project path="frameworks/av" name="platform_frameworks_av" remote="ZoranStojsavljevic"/>
```

Switch to the $ext_croot directory:

	$croot/frameworks$ cd $ext_croot

	$ext_croot$ git clone https://android.googlesource.com/platform/frameworks/av

	$ext_croot$ mv av/ platform_frameworks_av$

	$ext_croot$ cd platform_frameworks_av/

	$ext_croot/platform_frameworks_av$ git status
	On branch main
	Your branch is up to date with 'origin/main'.

Check remote repositories which should be deleted and replaced.

	$ext_croot/platform_frameworks_av$ git remote -v
	origin	https://android.googlesource.com/platform/frameworks/av (fetch)
	origin	https://android.googlesource.com/platform/frameworks/av (push)

Please, delete remote repositories referring to the google repos:

	$ext_croot/platform_frameworks_av$ git remote rm origin

	$ext_croot/platform_frameworks_av$ git remote -v

Add a relevant remote repositories, so it will reflect external
git:

	$ext_croot/platform_frameworks_av$ git remote add origin https://github.com/ZoranStojsavljevic/platform_frameworks_av.git

Please, do note that word origin is just an alias (could be ANY
name)!

	$ext_croot/platform_frameworks_av$ git remote -v
	origin	https://github.com/ZoranStojsavljevic/platform_frameworks_av.git (fetch)
	origin	https://github.com/ZoranStojsavljevic/platform_frameworks_av.git (push)

	$ext_croot/platform_frameworks_av$ git checkout android-12.0.0_r34
	Note: switching to 'android-12.0.0_r34'.
	You are in 'detached HEAD' state...
	...

	$ext_croot/platform_frameworks_av$ git status
	HEAD detached at android-12.0.0_r34
	nothing to commit, working tree clean

	$ext_croot/platform_frameworks_av$ git describe 
	android-12.0.0_r34

Check the latest commit log to ensure that the setup is correct!

	$ext_croot/platform_frameworks_av$ git log
	commit 28c005633b2b3867d403ee0ceb8fded4b319e3ad (HEAD, tag: android-vts-12.0_r1, tag: androi
	d-platform-12.0.0_r1, tag: android-cts-12.0_r1, tag: android-12.0.0_r9, tag: android-12.0.0_
	r8, tag: android-12.0.0_r34, tag: android-12.0.0_r33, tag: android-12.0.0_r31, tag: android-
	12.0.0_r30, tag: android-12.0.0_r3, tag: android-12.0.0_r25, tag: android-12.0.0_r2, tag: an
	droid-12.0.0_r11, tag: android-12.0.0_r10, tag: android-12.0.0_r1, origin/android12-s5-relea
	se, origin/android12-s4-release, origin/android12-s3-release, origin/android12-s2-release, o
	rigin/android12-s1-release, origin/android12-release)
	Merge: e7b14ac46b e315a070dd
	Author: Android Build Coastguard Worker <android-build-coastguard-worker@google.com>
	Date:   Tue Aug 17 01:12:19 2021 +0000
	...

Before pushing a relevant branch android-12.0.0_r34 to the
remote, delete main branch, since it is not needed!

	$ext_croot/platform_frameworks_av$ git branch -D main
	Deleted branch main (was 28c005633b).

Push the relevant branch to the remote repo:

	$ext_croot/platform_frameworks_av$ git push -u origin android-12.0.0_r34
	Enumerating objects: 315942, done.
	Counting objects: 100% (315942/315942), done.
	Delta compression using up to 4 threads
	Compressing objects: 100% (80486/80486), done.
	Writing objects: 100% (315942/315942), 156.58 MiB | 12.67 MiB/s, done.
	Total 315942 (delta 229375), reused 315185 (delta 229000), pack-reused 0 (from 0)
	remote: Resolving deltas: 100% (229375/229375), done.
	To https://github.com/ZoranStojsavljevic/platform_frameworks_av.git
	 * [new tag]               android-12.0.0_r34 -> android-12.0.0_r34

#### [OPTIONAL]

	$ext_croot/platform_frameworks_av$ git push origin --tags
	Username for 'https://github.com': zoran.stojsavljevic@gmail.com
	Password for 'https://zoran.stojsavljevic@gmail.com@github.com':
	Enumerating objects: 152979, done.
	Counting objects: 100% (144929/144929), done.
	Delta compression using up to 4 threads
	Compressing objects: 100% (61264/61264), done.
	Writing objects: 100% (140410/140410), 72.86 MiB | 12.17 MiB/s, done.
	Total 140410 (delta 82792), reused 133332 (delta 76642), pack-reused 0 (from 0)
	remote: Resolving deltas: 100% (82792/82792), completed with 1477 local objects.
	To https://github.com/ZoranStojsavljevic/platform_frameworks_av.git
	[list of new tags]

Create a branch android-12.0.0_r34, and checkout to it:

	$ext_croot/platform_frameworks_av$ git branch android-12.0.0_r34

	$ext_croot/platform_frameworks_av$ git checkout android-12.0.0_r34
	Switched to branch 'android-12.0.0_r34'

Delete the android-12.0.0_r34 tag:

	$ext_croot/platform_frameworks_av$ git tag -d android-12.0.0_r34
	Deleted tag 'android-12.0.0_r34' (was 423a100627)

	$ext_croot/platform_frameworks_av$ git push origin android-12.0.0_r34
	Total 0 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
	To https://github.com/ZoranStojsavljevic/platform_frameworks_av.git
	 * [new branch]            android-12.0.0_r34 -> android-12.0.0_r34

Delete the local repo at $ext_croot/platform_frameworks_av:

	$ext_croot/platform_frameworks_av$ cd ..

	$ext_croot$ rm -rf platform_frameworks_av/

There is still an unfinished job to be done in Android 12 source
code (please, again note that croot=~/android/12):

	$ext_croot$ cd $croot

In order to finish a minimum job required, and achieve a
success, the following must be done:

	$croot$ repo sync --force-sync

	... A new version of repo (2.50) is available.
	... You should upgrade soon:
	    cp /home/vuser/android/12/.repo/repo/repo /home/vuser/bin/repo

	Fetching:  0% (0/1040) 0:00 | ..working..error: hooks is different in
	/home/vuser/android/12/.repo/projects/frameworks/av.git
	vs
	/home/vuser/android/12/.repo/project-objects/platform_frameworks_av.git
	error: hooks is different in
	/home/vuser/android/12/.repo/projects/frameworks/av.git
	vs
	/home/vuser/android/12/.repo/project-objects/platform_frameworks_av.git
	Retrying clone after deleting
	/home/vuser/android/12/.repo/projects/frameworks/av.git
	($croot$ rm /home/vuser/android/12/.repo/projects/frameworks/av.git)

Must repeat repo sync --force-sync command:

	$croot$ repo sync --force-sync 

	... A new version of repo (2.50) is available.
	... You should upgrade soon:
	    cp /home/vuser/android/12/.repo/repo/repo /home/vuser/bin/repo

	Fetching: 100% (1040/1040), done in 5m38.805s
	Updating files: 100% (4469/4469), done.xternal/zxingUpdating files:  60% (2720/4469)
	Checking out: 86% (897/1040) platform/prebuilts/gcc/darwin-x86/aarch64/aarch64-linux-androidChecking out: 86% (903/1040) platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-Checking out: 87% (907/1040) platform/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.Checking out: 100% (1040/1040), done in 2m43.251s
	repo sync has finished successfully.

### Upgrade to the new repo version (2.50), available:

	$croot$ cp /home/vuser/android/12/.repo/repo/repo /home/vuser/bin/repo

	$croot$ repo --version
	repo version v2.50.1
	       (from https://gerrit.googlesource.com/git-repo)
	       (tracking refs/heads/stable)
	       (Wed, 18 Dec 2024 09:23:49 -0800)
	repo launcher version 2.50
	       (from /home/vuser/bin/repo)
	       (currently at 2.50.1)
	repo User-Agent git-repo/2.50.1 (Linux) git/2.47.1 Python/3.13.0
	git 2.47.1
	git User-Agent git/2.47.1 (Linux) git-repo/2.50.1
	Python 3.13.0 (main, Oct  8 2024, 00:00:00) [GCC 14.2.1 20240912 (Red Hat 14.2.1-3)]
	OS Linux 6.11.11-300.fc41.x86_64 (#1 SMP PREEMPT_DYNAMIC Thu Dec  5 18:38:25 UTC 2024)
	CPU x86_64 (unknown)
	Bug reports: https://issues.gerritcodereview.com/issues/new?component=1370071

### YET TO DO (put manifest, controlling the Android 12 tree, under the git repo control)!

To put current manifest, controlling the Android 12 tree, under
the git repo control (should say: Android 1x tree)!

This manifest repo created for the purpose of tracking manifest
changes SHOULD be set OUTSIDE the Android 1x tree!

### Reference/article to read: AOSP - manifests and repo tool
* [manifest](https://blog.udinic.com/2014/05/24/aosp-part-1-get-the-code-using-the-manifest-and-repo/)
