# In this string we need to use -D__SOME__ command for define which platform we use
# And C preprocessor use only code for platform, we defined
# For example if we use Texas Instruments OMAP 3430 - we should use
# EXTRA_CFLAGS += -D__PLAT_QCOMM_APQ8064__
# Else if we need for Freescale i.MX31 - we should use
# EXTRA_CFLAGS += -D__PLAT_FREESCALE_IMX31__

# I don't yet have this fully set up for the droid x yet
# This line seems to work on my X, otherwise use the line
# That's commented out.
#EXTRA_CFLAGS += -D__PLAT_TI_OMAP3430__ -Wall -march=arm
EXTRA_CFLAGS += -mfpu=neon
EXTRA_CFLAGS += -D__KERNEL__ -DKERNEL -DCONFIG_KEXEC -march=armv7-a -mtune=cortex-a9

# Make this match the optimisation values of the kernel you're
# loading this into. Should work without changes, but it seems to
# crash on the Nexus One and Droid Pro. If you're compiling on an 
# Evo 4g, set this value to 1 and change the EXTRA_CFLAGS value to
# something appropriate to your phone
# EXTRA_CFLAGS += -O0

ARCH		= arm
KERNEL = /mnt/mnt/kernel-build
CONFIG = ford_cyanogenmod_defconfig
CROSS_COMPILE = /mnt/mnt/cyanogen/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-
#OBJDIR		= /mnt/Android/optimusg/kexec-git/kexec-tools/objdir-arm
#target		= arm-unknown-none
#host		= arm-unknown-none

# Compiler for building kexec
#CC		= /mnt/Android/heroc/new/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-gcc
#CPP		= /mnt/Android/heroc/new/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-gcc -E

CPPFLAGS	=  -I$(KERNEL)/

obj-m += selinux_permissive.o
selinux_permissive-objs := selinux-permissive.o

all: module push

module:
	ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) make -C $(KERNEL)/ M=$(PWD) modules

clean:
	ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) make -C $(KERNEL)/ M=$(PWD) clean
	rm -f *.order

prepare:
	ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) make -C $(KERNEL)/ $(CONFIG)
	ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) make -C $(KERNEL)/ modules_prepare

kernel_clean:
	ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) make -C $(KERNEL)/ mrproper
	ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) make -C $(KERNEL)/ clean

push:
	adb push selinux_permissive.ko /mnt/sdcard/
