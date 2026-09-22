#!/usr/bin/python3

import sys
import traceback

import gi

gi.require_version("FPrint", "2.0")
from gi.repository import FPrint, GLib

sys.excepthook = lambda *args: (traceback.print_exception(*args), sys.exit(1))

context = GLib.main_context_default()
fprint_context = FPrint.Context()
fprint_context.enumerate()
devices = fprint_context.get_devices()

device = devices[0]
assert device.get_driver() == "elanmoc2"
assert not device.has_feature(FPrint.DeviceFeature.CAPTURE)
assert device.has_feature(FPrint.DeviceFeature.IDENTIFY)
assert device.has_feature(FPrint.DeviceFeature.VERIFY)
assert device.has_feature(FPrint.DeviceFeature.DUPLICATES_CHECK)
assert device.has_feature(FPrint.DeviceFeature.STORAGE)
assert not device.has_feature(FPrint.DeviceFeature.STORAGE_LIST)
assert not device.has_feature(FPrint.DeviceFeature.STORAGE_DELETE)
assert device.has_feature(FPrint.DeviceFeature.STORAGE_CLEAR)

device.open_sync()
device.clear_storage_sync()
device.close_sync()

del device
del devices
del fprint_context
del context
