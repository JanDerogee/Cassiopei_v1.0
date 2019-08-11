The firmware should only be programmed with the bootloader as found in this folder.

If you attempt to program the firmware into the Cassiopei using alternative software
other then found here damage might occur and the Cassiopei will be unusable!


Version overview:
-----------------

20160213.hex :

The new features are: 
- compressed TAP files, this means that you can store more then twice the amount of TAP files onto your Cassiopei!
- filesystem check can now also repair your filesystem or help you to solve the problem.
- less confusing computer model defintions for the PET series in the computermodel settings related tools.
- the LED flashes red,green,orange,red,green,orange,etc when the requested file is not found
- I2C address 0x78 is reserved SSD1306 OLED functionality (for debugging purposes only)
- minor bug fixes regarding TAP file playback related to the Cassiopei manager (TAP file control page)


Then there is also a preparation made for future functionality. This is D64 file handling, to create disk or make D64 images.
This will eventually allow users to create real disk (writing the D64 image to a real disk using a real drive) or to create a
D64 image (from a real disk in a real diskdrive). Please note that the D64 file format cannot be read by the Cassiopei directly,
so the Cassiopei will never be a replacement for a diskdrive, this functionality simply allows you to archive your existing disk collection.
Currently there is no Cassiopei software available that supports this functionality, but it is expected that it will become soon available.


20140529.hex :	Supports the PET-2001 (the firts version of the PET, you know, the one with the chicklet keyboard)
			Bugfix for the PET/CBM30XX, 40XX, 80XX (an error message might appear when RUN is executed,
			however the computer did not stop, it simply looks strange but was totally harmless).
			Also fixes a bug regarding speech and sample playback. When played back using PWM only (not via SID)
                then the CBM was instanly available and a next command could be given, this sometimes failed
                resulting in playing back the wrong sample or speech phrases.

20140209.hex : 	This update is only required for PET/CBM 4000 and 8000 users (and users that play audio samples using the Cassiopei)
			fastloader for the PET/CBM 3000,4000,8000 series no longer uses tapebuffer#2, because the 4000 and 8000 use this area
			to store OS variables and using this area screws these variables up. The previous version might caused problems on
                the 8000 when using disk commands in combination with the Cassiopei fastloader. The 4000 did not work at all, as it
                blocked all keyboard input preventing the user from typing RUN. Also a small bug fixed regarding file offset as used
                by sample playback. When an offset was chosen that was exactly on the flash block page filesystem data was returned
                instead of real data. Resulting in an allmost unnoticable "tick" in the audio signal. Chances in finding this bug are
                1 in 4092 (this bug did not affect speech synthesis)


20140112.hex : 	support for the PET/CBM 8000 series, more control over TAP file playback
			improved functionality of the Cassiopei manager for detection of incomplete files (files that were aborted by the user during copying)





