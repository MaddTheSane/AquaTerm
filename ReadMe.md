#AquaTerm

your friendly plotting front-end

###Table of Contents

1. What is AquaTerm?
2. Who would use AquaTerm?
3. How do I install AquaTerm?
4. What gets installed where?
5. Is AquaTerm and clients aware of the environment?
6. What is in the Developer Extras folder?
7. How can I find out more?
8. How can I help in improving AquaTerm?
9. License terms

##What is AquaTerm?

It is a small application that acts as an output device for other programs (command line applications, CLI) that need to render vector and bitmap graphics in windows.  In order for that to work, the CLI need to be compiled with support for AquaTerm.

Currently Gnuplot 4.x and programs based on PGPLOT and PLplot are or can be made AquaTerm aware.

##Who would use AquaTerm?

First and foremost, AquaTerm is of no or very little use by itself… you need another application to provide input data.

The target audience is a user of plotting applications such as Gnuplot (directly or indirectly) or homebrew command line tools who would like a native Mac OS X display option with PDF and EPS export functionality

A developer who would like to provide graphics output on OS X for their application. The API is designed to fit well with procedural code, rather than OO-code.

##How do I install AquaTerm?

An end user only need to double-click the installer package and follow the instructions. 

Developers also need the stuff in the Developer Extras folder, which can be dragged to a convenient location.

##What gets installed where?

The installer will install the application AquaTerm in */Applications*.

It will place AquaTerm.framework in */Library/Frameworks*. 

In past symlinks to shared lib and headers (located inside AquaTerm.framework) used to be placed in */usr/local/lib* and */usr/local/include/aquaterm*.

##Is AquaTerm and clients aware of the environment?

Certainly. The following environment variables may be of interest:

General:

`AQUATERM_LOGLEVEL` — set in the range `0`-`4` to have increasing levels of logging to stdout, zero means no logging.

`AQUATERM_PATH` — set this to have a specific copy of AquaTerm.app e.g. */Users/you/source/build/AquaTerm.app* launched automatically from clients.

Clients:

*GNUTERM* — set this to "aqua" to make AquaTerm the default terminal in Gnuplot†

*PGPLOT_DEV* — set this to "/AQT" to make AquaTerm default output in PGPLOT


†Aquaterm is already the default terminal in Gnuplot as of version 4.1, if it was built with aquaterm support.      

##What is in the Developer Extras folder?

_The developer documentation is out of date, please use to the source code and mailing lists at http://sourceforge.net/mail/?group_id=39915 if you want the latest information._

Documentation for the Obj-C API is in *AQTAdapter.html*. 

The C API is unfortunately only documented by the header file aquaterm.h, but the calls are very similar to the methods described in AQTAdapter.html and it as a reference together with the C and Fortran examples should be enough to get you started. 

Examples of how to use AquaTerm from C, Python, and Fortran as well as a Perl module and an adapter for PGPLOT can be found in the adapters folder.

_NB. The gnuplot adapter is part of gnuplot 4.x sources and the PLplot adapter is part of PLplot as of version 5.5.3._

##How can I find out more?

Use the mailing lists and/or trackers at the [project website](http://aquaterm.sourceforge.net).

##How can I help in improving AquaTerm?

In many ways! Write code (core or adapters), write documentation, improve the website, test and report bugs, write supporting notes in email or sponsor the project with cash. 

##License terms

Copyright © 2001-20012, Per Persson, The AquaTerm Team

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
