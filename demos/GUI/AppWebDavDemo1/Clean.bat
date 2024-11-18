@echo off
If exist LogDebugLAMW.txt erase LogDebugLAMW.txt

If exist gdb              rmdir /S /Q gdb
If exist obj              rmdir /S /Q obj
If exist out              rmdir /S /Q out
If exist build            rmdir /S /Q build
If exist jni\backup       rmdir /S /Q jni\backup

If exist libs\arm64-v8a.gdbserver         erase libs\arm64-v8a.gdbserver
If exist libs\arm64-v8a.libcontrols.dbg   erase libs\arm64-v8a.libcontrols.dbg

If exist libs\armeabi-v7a.gdbserver       erase libs\armeabi-v7a.gdbserver
If exist libs\armeabi-v7a.libcontrols.dbg erase libs\armeabi-v7a.libcontrols.dbg

If exist libs\x86.gdbserver               erase libs\x86.gdbserver
If exist libs\x86.libcontrols.dbg         erase libs\x86.libcontrols.dbg
