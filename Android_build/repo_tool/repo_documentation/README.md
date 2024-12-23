## Intent is to create external repos documentation

Since author tried to find a satisfactory description how to
create and maintain external git repos out of the Android 1x
tree, but in his seraches was unsuccesful.

The best explanation author found so far is the following:

reference/article to read: AOSP - manifests and repo tool

* [manifest](https://blog.udinic.com/2014/05/24/aosp-part-1-get-the-code-using-the-manifest-and-repo/)

Author was not satisfied with the content and deepness of the
explanation/documentation, so author decided to make his own
documentation for his own use.

For other people, it is the Best Effort Documentation!

### Manifest file default.xml

File default.xml is an original manifest for the
~/android/12 Android 12 tree!

It is located in author's rootfs:

	~/android/12/.repo/manifests/default.xml

### Creating a github Android 12 external git repo frameworks/av

The internal frameworks/av git is located at:

	~/android/12/frameworks/av

This external platform_frameworks_av git repo is located in the
author's github as a public repo on the:

* [platform_frameworks_av](https://github.com/ZoranStojsavljevic/platform_frameworks_av)

The description of the nontrivial operations which author tried
to depict is located in the following file:

* [creating_external_repos.md](https://github.com/ZoranStojsavljevic/Android_12_Bluedroid_BT_SCO_Audio_HAL/blob/main/Android_build/repo_tool/repo_documentation/creating_external_repos.md)

### YET TO DO (put manifest, controlling the Android 12 tree, under the git repo control)!

To put current manifest, controlling the Android 12 tree, under
the git repo control (should say: Android 1x tree)!

The default manifest is given in:

* [default manifest](https://github.com/ZoranStojsavljevic/Android_12_Bluedroid_BT_SCO_Audio_HAL/blob/main/Android_build/repo_tool/repo_documentation/default.xml)

This manifest repo created for the purpose of tracking manifest
changes SHOULD be set OUTSIDE the Android 1x tree!
