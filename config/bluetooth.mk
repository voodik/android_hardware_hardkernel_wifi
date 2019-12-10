#
# Copyright (C) 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$(warning BOARD_HAVE_BLUETOOTH is $(BOARD_HAVE_BLUETOOTH))
$(warning BLUETOOTH_MODULE is $(BLUETOOTH_MODULE))

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
    PRODUCT_PROPERTY_OVERRIDES += config.disable_bluetooth=false
else
    PRODUCT_PROPERTY_OVERRIDES += config.disable_bluetooth=true
endif

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
#BOARD_HAVE_BLUETOOTH_BCM := true

BT += Bluetooth

ifeq ($(BOARD_HAVE_BLUETOOTH_BCM), true)
BT += libbt-vendor
else
BT += libbt-hci
endif

ifeq ($(BOARD_HAVE_BLUETOOTH_BCM), true)
    PRODUCT_PROPERTY_OVERRIDES += ro.bt.service=service
else
    PRODUCT_PROPERTY_OVERRIDES += ro.bt.service=service.btlinux
endif

# Bluetooth HAL
BT += android.hardware.bluetooth@1.0-impl

ifeq ($(BOARD_HAVE_BLUETOOTH_BCM), true)
BT += android.hardware.bluetooth@1.0-service
else
BT += android.hardware.bluetooth@1.0-service.btlinux
endif

# Bluetooth configs
BT += \
    bt_vendor.conf \
    bt_stack.conf \
    bt_did.conf

ifeq ($(BOARD_HAVE_BLUETOOTH_BCM),)
# Bluetooth misc (deprecated?)
BT += auto_pair_devlist.conf

BT += \
    bluetooth.default \
    libbt-client-api \
    com.broadcom.bt \
    com.broadcom.bt.xml

PRODUCT_COPY_FILES += \
    hardware/amlogic/bluetooth/broadcom/vendor/data/auto_pairing.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/auto_pairing.conf \
    hardware/amlogic/bluetooth/broadcom/vendor/data/blacklist.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/blacklist.conf
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

PRODUCT_PACKAGES += $(BT)

ifeq ($(BOARD_HAVE_BLUETOOTH_BCM), true)
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/hardkernel/common/bluetooth

$(call inherit-product, device/hardkernel/common/bluetooth_modules.mk )
else
ifneq ($(wildcard device/hardkernel/$(TARGET_PRODUCT)/bluetooth),)
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/hardkernel/$(TARGET_PRODUCT)/bluetooth
endif
endif

endif
