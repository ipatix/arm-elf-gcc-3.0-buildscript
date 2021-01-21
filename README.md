# arm-elf-gcc 3.0 buildscript

This provides a simple script to download and compile arm-elf-gcc 3.0 from source.

I initially went through a bit of trouble getting it to work, so I'm providing this to save your from the pain.
The key challange was to correctly install a binutils with the `arm-elf` prefix and to patch out a function from gcc 3.0 source which prevented it from compiling.

I tested this with gcc-10. I can't guarantee anything for other versions.
