LOCAL_PATH := $(call my-dir)

# audio.sco.default.so
include $(CLEAR_VARS)

LOCAL_SRC_FILES := audio_sco_hw.c

LOCAL_SHARED_LIBRARIES := liblog libcutils

LOCAL_MODULE := audio.sco.default

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw

LOCAL_MODULE_TAGS := optional

LOCAL_CFLAGS += -Wno-unused-parameter

include $(BUILD_SHARED_LIBRARY)
