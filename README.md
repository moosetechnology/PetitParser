# PetitParser
Petit Parser is a framework for building parsers.

## About Petit Parser
Petit Parser is a framework for building parsers. It was originally developed by Lukas Renggli.

Basic information about PetitParser can be found here:

- [Writing Parsers with PetitParser](http://www.lukas-renggli.ch/blog/petitparser-1)
- [Composite Grammars with PetitParser](http://www.lukas-renggli.ch/blog/petitparser-2)
- [Petit Parser in Deep into Pharo Book](http://pharobooks.gforge.inria.fr/PharoByExampleTwo-Eng/latest/PetitParser.pdf)

This repository is a port from the [Smalltalkhub repository](http://smalltalkhub.com/#!/~Moose/PetitParser). However, further contributions to this project should take place on this Github repository.

## Install
```
Metacello new
   baseline: 'PetitParser';
   repository: 'github://moosetechnology/PetitParser/src';
   load.
```

### Groups
It is possible to load subpart(s) of this project using groups:
- `Core`: Contains the core of the framework, without tests.
- `Tests`: Contains extensions to SUnit to make parsers testing easier.
- `Parsers`: Contains a collection of various parsers.
- `PetitIDE`: Contains graphical tools to develop and debug parsers.

## Version management

This project use semantic versionning to define the releases. This mean that each stable release of the project will get associate a version number of the form `vX.Y.Z`.

- **X** define the major version number
- **Y** define the minor version number
- **Z** define the patch version number

When a release contains only bug fixes, the patch number increase. When the release contains new features backward compatibles, the minor version increase. When the release contains breaking changes, the major version increase.

Thus, it should be safe to depend on a fixed major version and moving minor version of this project.

The first release on this Github repository matches with the last release that happened on Smalltalkhub (v1.9.2).
