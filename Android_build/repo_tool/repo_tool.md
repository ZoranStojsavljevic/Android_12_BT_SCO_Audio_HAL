## The Google Repo tool

The Google Repo tool is an essential utility for managing
Android's large source code, as the Android Open Source
Project (AOSP) is spread across multiple Git repositories.
It simplifies the process of fetching, managing, and syncing
these repositories. Below is provided a detailed, professional
overview of the repo tool, including commands and examples.

### 1. Overview of the Repo Tool

repo is a Python-based command-line tool developed by Google to
manage the Android source code. It helps in:

	- Fetching multiple Git repositories.
	- Syncing a local repository with upstream sources.
	- Managing different branches and revisions of Android.

### 2. Installation of Repo Tool

To install the repo tool, these steps are to be followed:

#### 2.1 Install Repo on Ubuntu (or other Linux)

	$ mkdir -p ~/bin
	$ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	$ chmod a+x ~/bin/repo

#### 2.2 Add to PATH

Add repo to the PATH environment variable by adding this to the
~/.bashrc (or ~/.zshrc if using Zsh):

	$ export PATH=~/bin:$PATH

Reload the shell:

	$ source ~/.bashrc  # or source ~/.zshrc

#### 2.3 Verify Installation

Check if the repo tool is correctly installed by running:

	$ repo --version

This should display the version of the repo tool installed.

### 3. Repo Commands and Usage

The repo tool operates with a variety of commands. Below are the
key commands and their examples.

### 4. Initializing a Repo Project

To fetch the Android source, the first thing which needs to be
done is to initialize the repo project. This configures the
local machine with information about the repositories which
needs to be downloaded.

#### 4.1 Initialize Repo with Manifest

	- Create a Directory for the Android Source.

	- Create a directory for the Android source code, and
	  navigate to it:

	  $ mkdir ~/android/14
	  $ cd ~/android/14

##### Initialize the Repo Tool:

To initialize repo, run the following command. This command
points to the manifest repository that defines all the
sub-repositories for Android source:

	$ repo init -u https://android.googlesource.com/platform/manifest.git -b android-14.0.0_r1

	  -u specifies the URL to the manifest repository.
	  -b specifies the branch to initialize (in this case,
	     android-14.0.0_r1 for Android 14).

The manifest repository contains XML files describing all the
other repositories required for the Android build.

##### Syncing with the Remote Repository:

After initialization, sync the project using the following
command. This fetches all the repositories defined in the
manifest.

	$ repo sync -j$(nproc)

	  -j$(nproc) uses all available CPU cores for a faster sync process.

### 5. Managing Repo Projects

#### 5.1 Checking the Status of Repositories

To check the status of the repo project (e.g., whether
repositories are up to date), use the repo status command:

	$ repo status

This will show the state of the repositories, whether they
are up-to-date or need changes.

#### 5.2 Listing All Repositories

The following command can list all the repositories in the
current repo project by running:

	$ repo list

This shows a list of all repositories that are part of the
current manifest.

#### 5.3 Fetching Specific Branches

To work with a different branch (e.g., android-14.0.0_r2), to
perform the switch to it will be:

	$ repo init -b android-14.0.0_r2

The sync of the project should be performed with:

	$ repo sync -j$(nproc)

#### 5.4 Updating All Repositories

To update all the repositories to their latest commits from the
remote, the repo sync command should be used. This will update
the local copies of each repository in the Android source:

	$ repo sync -j$(nproc)

This command will pull the latest changes from the remote
servers and update the local copies of all repositories in
the source tree.

### 6. Working with Multiple Projects

Android development uses multiple projects, and repo command
helps manage them.

#### 6.1 Syncing Specific Repositories

Sometimes, it might require to sync specific repositories rather
than all the projects. To do so:

	$ repo sync <repository_name>

For example, to sync the system/core repository:

	$ repo sync system/core

#### 6.2 Downloading New Repositories

To add new repositories to the project that are part of the same
manifest, please use:

	$ repo sync --fetch-submodules

This fetches submodules as well, ensuring that any nested
repositories are pulled into the local repo.

### 7. Branch Management with Repo

One of the powerful features of repo is its ability to manage
branches for multiple repositories at once. Here’s how to switch
branches and manage them.

#### 7.1 Creating a New Repo Branch

To create a new branch across all repositories, use:

	$ repo start <branch_name> --all

For example, to create a new branch named feature_branch:

	$ repo start feature_branch --all

This creates the branch and checks it out across all the
repositories involved in the current project.

#### 7.2 Switch Between Branches

To switch to a different branch, the following command should
be used:

	$ repo checkout <branch_name>

For example, to switch to android-14.0.0_r1:

	$ repo checkout android-14.0.0_r1

#### 7.3 Viewing Branches

To see all the branches available in the repo:

	$ repo branches

### 8. Repo Manifest Management

#### 8.1 Viewing the Current Manifest

To view the current manifest that repo isinitialized with, use
the following:

	$ repo manifest

This will display details about the current manifest, including
the repositories and their respective branches.

#### 8.2 Updating the Manifest

If the manifest changes (e.g., a new repository is added), update
the local manifest:

	$ repo sync --manifest-url=<new_manifest_url>

For example, if the manifest URL changes, a new one can be
pointed to:

repo sync --manifest-url=https://android.googlesource.com/platform/manifest.git

#### 8.3 Create a Local Manifest

If the repo needs to be customised (e.g. add custom repositories
or branches), a local manifest ca be created. This file is
typically stored at .repo/local_manifests/. The repository
configurations can be added in XML format.

For example, create a new file local_manifest.xml in the
.repo/local_manifests/ directory:

<?xml version="1.0" encoding="UTF-8"?>
<manifest>
	<project name="platform/system/core" path="system/core" revision="android-14.0.0_r1"/>
</manifest>

After creating this, it can be synced with:

	$ repo sync --local-only

### 9. Advanced Repo Commands

#### 9.1 Syncing with a Specific Commit

A specific commit can be synced in any repository using:

	$ repo sync <repo_name> --fetch-submodules --revision <commit_id>

#### 9.2 Repo Sync with New Changes Only

To sync only repositories that have changes and skip those that
are already up to date, use:

	$ repo sync --no-clone-bundle

#### 9.3 Managing Repositories in Multiple Directories

If there are different directories where the same set
of repositories should be synced, use repo in different
directories with different manifest files. Separate
projects in different directories with specific manifests
can be initialized.

### 10. Conclusion

The repo tool is a powerful utility designed for managing
large-scale projects like Android, which involve hundreds of
repositories. By understanding the key commands—initializing,
syncing, checking status, managing branches, and customizing
the manifest — the process of fetching and compiling Android
source code. can be streamlined. For professional Android
development, mastering the repo tool is an essential skill.

For more in-depth usage and advanced features, refer to the
official documentation: Google's Repo Tool:

repo - The Multiple Git Repository Tool
* [repo - The Multiple Git Repository Tool](https://gerrit.googlesource.com/git-repo)

repo Manifest Format
* [repo Manifest Format](https://gerrit.googlesource.com/git-repo/+/HEAD/docs/manifest-format.md)
