OBSOLETE - OBSOLETE - OBSOLETE - OBSOLETE - OBSOLETE - OBSOLETE - OBSOLETE


How to add extra components to the lazarus IDE
==============================================

Use the customidecomps.pas.template file and read the instructions carefully.

Some notes for component developers:

--------------------------------------------------------------------------------
Components at design time:
- csDesigning is set in ComponentState
- The component should be passive at design time. That means it should ignore
  most user events.
- csAcceptsControls in ControlStyle controls if the user can put components
  onto the component. Include or exclude this flag in the constructor.

--------------------------------------------------------------------------------
Providing an icon for a component:

The IDE searches for an XPM resource with the classname of the component. It
should not be bigger than 23x23 pixels.

For example:
Adding an icon for TCheckBook in checkbook.pas:
Use your favourite paint program to create a transparent image of size 23x23
or smaller. Save it as <classname>.xpm, where <classname> is the classname of
the component (e.g. TCheckBook.xpm). You can write it lowercase tcheckbook.xpm
or TCheckBook.xpm or whatever you like. Then use the tools/lazres program to
convert it into a lazarus resource file:
lazres checkbookicon.lrs TCheckBook.xpm
The name of the new resource file is up to you. Put this file into the
components/custom/ directory where the checkbook.pas is. Then include the
resource file in the initialization section of checkbook.pas:

initialization
  {$I checkbookicon.lrs}

!!! IMPORTANT: If there is already a resource file, then add your new file
               behind it. The IDE expects the first include file as the main
               resource file, where it stores the form data.
               
Hint:
  You can also copy the code from checkbookicon.lrs to the initialization
  section. This way you can provide your component in one file (checkbook.pas).
--------------------------------------------------------------------------------

