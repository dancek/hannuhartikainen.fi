+++
title = "Hacking DDR3 SPD"
date = 2018-05-27T13:20:10+03:00
tags = ["hardware", "EEPROM", "RAM", "I2C"]
+++

**I was upgrading an old laptop with two 4GB PC3-10600 memory modules and it turned out PC3-8500 was absolutely needed instead. What's a man to do? Of course rewrite the EEPROM to re-bin the memory module as a slower model!**
<!--more-->

{{ image(path="blog/hacking-ddr3-spd/images/work-area.jpg", title="Work area. The Thinkpad used for flashing on the right, the MBP that caused the whole problem on the left.") }}

*Be very careful if you try this at home. You may obviously damage or permanently write-protect your DIMM. More subtle possible accidents include messing up your battery logic circuit or even [bricking your motherboard](http://www.thinkwiki.org/wiki/Problem_with_lm-sensors).*

## How this came to be

I have a mid-2010 13" MacBook Pro. Its filesystem got corrupted in a normal reboot and Disk Utility (from the recovery partition) could do nothing about it. Well, this is what I'd been waiting for: time to change to an SSD and add some more RAM.

I bought an SSD and had the luck to find some broken laptops with suitable RAM modules in electronics garbage. Put the SSD and 2x4GB in, try Internet Recovery and expect to have a running system in an hour. Nope. The bootup just freezes. Not sure about this RAM, after all it was found in garbage. So do what anyone would: make a USB pendrive with memtest86 and run it all night. Great, the memory works perfectly. Cue hours of trying different installation methods for different macOS versions and the eventual discovery that everything works perfectly if I just put the old RAM back in.[^1]

## Aside: the root cause

After knowing what the issue was, I quickly found out that [MacBook Pros from 2009-2010 actually don't work with anything faster than PC3-8500](https://apple.stackexchange.com/a/83842/12443) and that [you can work around this by altering RAM metadata with a Windows program called Thaiphoon Burner](http://www.softnology.biz/tips_macbookpro.html).

The trouble with the hardware is the GeForce 320M integrated GPU that uses shared memory, ie. normal RAM. It can only work up to PC3-8500 (aka DDR3-1066, ie. 533Mhz DRAM clock frequency), but the system memory controller doesn't know about that and picks the highest available speed up to 667Mhz (ie. PC3-10600 aka DDR3-1333). The rest of the components work with that, and so does the GPU with VESA modes (I think).

I haven't heard of any other hardware that fails with RAM that's *capable* of higher speeds than the hardware can use. Of course aftermarket vendors would tell a prospective customer which modules work with Apple hardware, so it wasn't an issue for consumers buying memory upgrades back then. And it's still much better than soldering RAM as Apple has done since 2012.

## Flashing setup

The root cause figured out, I installed one original 2GB PC3-8500 module and one new 4GB module and put the machine back together. But re-binning a DDR3 module seemed like a nice project so I had to try it.

Of course, I'm not going to install Windows just to flash some EEPROM and I'm not going to buy fancy software if it can be done manually. I thought it obvious I can do this with Linux and possibly some custom software. I didn't want to install Linux on the MBP just for this, either. My old trusty Thinkpad X220 with [NixOS](https://nixos.org/) was perfect, though. Took a bit of work to update it as I hadn't booted the thing in a year or so.

Then it was time to choose which module I'd try first. The Thinkpad already had 2x4GB and I'd found four 4GB modules so I had what to choose from. I chose to start with the odd one out, a module built by Micron. All the others were Samsung. One had a Lenovo sticker, too.

## Reading SPD

Memory modules come with an EEPROM chip that contains metadata about the module, called [Serial presence detect](https://en.wikipedia.org/wiki/Serial_presence_detect#DDR3_SDRAM). The format itself is simple and the EEPROM can be accessed via [SMBus](https://en.wikipedia.org/wiki/System_Management_Bus) which is basically [I2C](https://en.wikipedia.org/wiki/I%C2%B2C).[^2]

Luckily there are kernel drivers and ready-made software for interfacing with SMBus and even reading the DDR3 EEPROMs.

First, to see what's on the bus you need `i2c-tools` and some kernel modules.

```console
$ nix-shell -p i2c-tools
$ modprobe i2c-dev
$ modprobe i2c-i801
$ i2cdetect -l
i2c-0	unknown   	i915 gmbus ssc                  	N/A
i2c-1	unknown   	i915 gmbus vga                  	N/A
i2c-2	unknown   	i915 gmbus panel                	N/A
i2c-3	unknown   	i915 gmbus dpc                  	N/A
i2c-4	unknown   	i915 gmbus dpb                  	N/A
i2c-5	unknown   	i915 gmbus dpd                  	N/A
i2c-6	unknown   	DPDDC-B                         	N/A
i2c-7	unknown   	DPDDC-C                         	N/A
i2c-8	unknown   	DPDDC-D                         	N/A
i2c-9	unknown   	SMBus I801 adapter at efa0      	N/A
```

The interesting one is the SMBus adapter, `i2c-9` in my case.

The `i2c-tools` package even comes with the tool `decode-dimms` for reading RAM information in a human-readable format. It requires the `eeprom` kernel module. Other I2C access doesn't work (for me) when it's loaded.

```console
$ modprobe eeprom
$ decode-dimms
$ modprobe -r eeprom
```

Here's the part of the output referring to a single memory module:

```
Memory Serial Presence Detect Decoder
By Philip Edelbrock, Christian Zuckschwerdt, Burkart Lingner,
Jean Delvare, Trent Piepho and others


Decoding EEPROM: /sys/bus/i2c/drivers/eeprom/9-0050
Guessing DIMM is in                              bank 1

---=== SPD EEPROM Information ===---
EEPROM CRC of bytes 0-116                        OK (0xAEA4)
# of bytes written to SDRAM EEPROM               176
Total number of bytes in EEPROM                  256
Fundamental Memory type                          DDR3 SDRAM
Module Type                                      SO-DIMM

---=== Memory Characteristics ===---
Maximum module speed                             1333 MHz (PC3-10600)
Size                                             4096 MB
Banks x Rows x Columns x Bits                    8 x 15 x 10 x 64
Ranks                                            2
SDRAM Device Width                               8 bits
Bus Width Extension                              0 bits
tCL-tRCD-tRP-tRAS                                9-9-9-24
Supported CAS Latencies (tCL)                    10T, 9T, 8T, 7T, 6T, 5T

---=== Timings at Standard Speeds ===---
tCL-tRCD-tRP-tRAS as DDR3-1333                   9-9-9-24
tCL-tRCD-tRP-tRAS as DDR3-1066                   7-7-7-20
tCL-tRCD-tRP-tRAS as DDR3-800                    6-6-6-15

---=== Timing Parameters ===---
Minimum Cycle Time (tCK)                         1.500 ns
Minimum CAS Latency Time (tAA)                   13.125 ns
Minimum Write Recovery time (tWR)                15.000 ns
Minimum RAS# to CAS# Delay (tRCD)                13.125 ns
Minimum Row Active to Row Active Delay (tRRD)    6.000 ns
Minimum Row Precharge Delay (tRP)                13.125 ns
Minimum Active to Precharge Delay (tRAS)         36.000 ns
Minimum Active to Auto-Refresh Delay (tRC)       49.125 ns
Minimum Recovery Delay (tRFC)                    160.000 ns
Minimum Write to Read CMD Delay (tWTR)           7.500 ns
Minimum Read to Pre-charge CMD Delay (tRTP)      7.500 ns
Minimum Four Activate Window Delay (tFAW)        30.000 ns

---=== Optional Features ===---
Operable voltages                                1.5V
RZQ/6 supported?                                 No
RZQ/7 supported?                                 Yes
DLL-Off Mode supported?                          Yes
Operating temperature range                      0-95 degrees C
Refresh Rate in extended temp range              2X
Auto Self-Refresh?                               Yes
On-Die Thermal Sensor readout?                   No
Partial Array Self-Refresh?                      No
Module Thermal Sensor                            Yes
SDRAM Device Type                                Standard Monolithic

---=== Physical Characteristics ===---
Module Height                                    30 mm
Module Thickness                                 2 mm front, 2 mm back
Module Width                                     67.6 mm
Module Reference Card                            F revision 0
Rank 1 Mapping                                   Standard

---=== Manufacturer Data ===---
Module Manufacturer                              Micron Technology
DRAM Manufacturer                                Micron Technology
Manufacturing Location Code                      0x0F
Manufacturing Date                               2011-W23
Assembly Serial Number                           0xFB5C7F1A
Part Number                                      16JSF51264HZ-1G4D1
Revision Code                                    0x4431
```

Quite a lot of data. Some of the information is computed from the data. For example, timings at standard speeds (ie. cycle counts) are computed from the nanosecond-resolution timing parameters. Even those are saved as multiples of a time base unit configured elsewhere on the EEPROM, but that's beside the point. This RAM unit could do 7-7-7-20 at DDR3-1066, which is the DDR3-1066F JEDEC standard. Don't ask me what JEDEC is, but this would faster than the cheapest DDR3-1066G bin.

I spent a lot of time confirming my deduction: the only important number when trying to re-bin memory is the minimum cycle time (tCK). Here it's 1.5ns, i.e. 667MHz.

Let's look at the raw data.

```console
$ i2cdump 9 0x50
No size specified (using byte-data access)
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-9, address 0x50, mode byte
Continue? [Y/n]
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 92 10 0b 03 03 19 00 09 03 52 01 08 0c 00 7e 00    ??????.??R???.~.
10: 69 78 69 30 69 11 20 89 00 05 3c 3c 00 f0 82 05    ixi0i? ?.?<<.???
20: 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ?...............
30: 00 00 00 00 00 00 00 00 00 00 00 00 0f 11 05 00    ............???.
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
70: 00 00 00 00 00 80 2c 0f 11 23 fb 5c 7f 1a a4 ae    .....?,??#?\????
80: 31 36 4a 53 46 35 31 32 36 34 48 5a 2d 31 47 34    16JSF51264HZ-1G4
90: 44 31 44 31 80 2c 00 00 00 00 00 00 00 00 00 00    D1D1?,..........
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
```

The spec says the minimum clock time is at address 0x0c. Look it up, it's on the first row (`00:`) under the `c` column. Incidentally its value is also 0x0c, or 12. That's multiples of medium time base (MTB), which is (value in 0x0a) / (value in 0x0b) nanoseconds, here 1/8 ns. So 12 MTB = 1.5ns.

## Planning the changes

To get down to DDR3-1066 we'd need 533Mhz, which is 1.875ns or 15 MTB, or 0x0f. That is, we want to write 0x0f to address 0x0c.

But wait, there's obviously error correction. There's CRC of the first 116 bytes saved in 0x7e-7f. I looked there and saw `a4 ae`, then went looking for a calculator that would give me that result with the initial data. It took me surprisingly long to find a workable CRC calculator. I tried several command-line ones but finally settled for the online calculator at http://crccalc.com/. Then I found out the variant is called CRC-16/XMODEM and the checksum is actually 0xAEA4. Endianness and stuff, right. I should have noticed from the `decode-dimms` output.

So the needed writes are the new minimum cycle time (0x0f) written to 0x0c and the new checksum to 0x7e as a word.

## Writing SPD

Now that I knew what to write I finally dared try it. With shaking hands I typed `y` and pressed enter to the final confirmation and...

```console
$ i2cset 9 0x50 0x0c 0x0f
WARNING! This program can confuse your I2C bus, cause data loss and worse!
DANGEROUS! Writing to a serial EEPROM on a memory DIMM
may render your memory USELESS and make your system UNBOOTABLE!
I will write to device file /dev/i2c-9, chip address 0x50, data address
0x0c, data 0x0f, mode byte.
Continue? [y/N] y
Error: Write failed
```

Error. Wait, what?

Being the thorough guy that I am, I read some source code for i2cset and the relevant kernel modules. At some point I realized this might be caused by write protection.

I took the memory module out, looked at it and recognized the EEPROM chip. It read `97B`, `321` and some other stuff. Googling around I found out it's the [SE97B](https://www.nxp.com/docs/en/data-sheet/SE97B.pdf) chip. I skimmed through the datasheet and read the section on write protection carefully multiple times. I took a couple of software-based tries at removing temporary write protection but failed. The write protection was probably permanent, though, so I just decided to look for a module that doesn't have write protection.

Fun fact, btw, is that permanent write protection is enabled by writing anything to a specific address. I don't think `i2cdetect` does this normally, but running `i2cget 9 0x30 <any-address>` would probably set permanent write protection, which is actually permanent. I didn't try it.

The next module I tried, there was no error message. The EEPROM just didn't change.

## Finally, success!

The third module I tried was successful. I calculated the CRC and wrote it along with the cycle time. Loading up the `eeprom` kernel module and running `decode-dimms` the module looked like an ordinary 4GB PC3-8500. When I installed it in the MacBook Pro I finally had the system boot up with 8GB memory.

{{ image(path="blog/hacking-ddr3-spd/images/rebinned-ddr3.jpg", title="A re-binned DDR3 SODIMM ready to go in the MacBook Pro.") }}

### Before: the original DDR3-1333
```
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 92 10 0b 03 03 19 00 09 03 52 01 08 0c 00 3e 00    ??????.??R???.>.
10: 69 78 69 30 69 11 20 89 00 05 3c 3c 00 f0 83 01    ixi0i? ?.?<<.???
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
30: 00 00 00 00 00 00 00 00 00 00 00 00 0f 11 45 00    ............??E.
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
70: 00 00 00 00 00 80 ce 02 11 30 b1 5b 13 a1 0e 59    .....????0?[???Y
80: 4d 34 37 31 42 35 32 37 33 43 48 30 2d 43 48 39    M471B5273CH0-CH9
90: 20 20 00 00 80 ce 00 00 00 53 31 42 4e 30 30 30      ..??...S1BN000
a0: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 03    ?.?............?
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 32 59 00    .............2Y.
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
```

### After: what looks like a DDR3-1066
```
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 92 10 0b 03 03 19 00 09 03 52 01 08 0f 00 3e 00    ??????.??R???.>.
10: 69 78 69 30 69 11 20 89 00 05 3c 3c 00 f0 83 01    ixi0i? ?.?<<.???
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
30: 00 00 00 00 00 00 00 00 00 00 00 00 0f 11 45 00    ............??E.
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
70: 00 00 00 00 00 80 ce 02 11 30 b1 5b 13 a1 06 54    .....????0?[???T
80: 4d 34 37 31 42 35 32 37 33 43 48 30 2d 43 48 39    M471B5273CH0-CH9
90: 20 20 00 00 80 ce 00 00 00 53 31 42 4e 30 30 30      ..??...S1BN000
a0: 01 00 01 00 00 00 00 00 00 00 00 00 00 00 00 03    ?.?............?
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 32 59 00    .............2Y.
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00    ................
```

If you can't spot the difference instantly, you haven't looked at these dumps like I have.

## My thoughts

Worth it? Financially, certainly not!

This was fun and I learned a lot. I have no idea where *exactly this* knowledge could prove useful, but if my experience is correct it *will* be at some point. And just experiencing that you can get stuff done is really nice and builds confidence.


[^1]: My assumption that RAM works on given hardware if it passes memtest86 was obviously wrong. Still, even in hindsight, I think I wasn't stupid to think so. Based on experience, it's not very rare to have a weird combination of hardware that a common piece of software crashes on.

[^2]: I recently learned about I2C related to another project I should blog about. I think I could have read and written the EEPROM using self-written software on a Cortex-M microcontroller, but in practice soldering the connector would have been very difficult and writing the code would have been too much work for me to bother. Still, I'm really happy to possibly be theoretically capable of doing that!
