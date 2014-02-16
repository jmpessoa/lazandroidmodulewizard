Version 0.3 - revision 0.2 - 29 December 2013 -

      :: New! Support for Linux! Thanks to Leledumbo! 

           by Leledumbo for Linux users:
              1. Build all libraries in the  ./dummylibs
              2. Put it somewhere ldconfig can find (or just run ldconfig with their directories as arguments)

                "The idea of this is just to make the package installable in the [Lazarus for Linux] IDE,
                  applications will still use the android version of the libraries."
  
              ref. http://forum.lazarus.freepascal.org/index.php/topic,21919.msg137216/topicseen.html



Suggestion: By Leledumbo - February 15, 2014

http://forum.lazarus.freepascal.org/index.php/topic,21919.75.html


Open tfpandroidbridge_pack.lpk->Package Options->Usage->Add paths to dependent 
packages/projects->Library,  then add linux/dummylibs. 

This will make installation easier on Linux but shouldn't hurt on Windows 
(but please test, I don't have windows). 
Anyway, since these libraries are not meant to be used in actual program, 
I think it's OK to provide a precompiled version of them in the same directory.
Or otherwise, provide additional instruction in the readme /fast tutorial 
to compile these libs before installing the .lpk.