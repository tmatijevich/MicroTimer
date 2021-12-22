# MicroTimer

The MicroTimer library provide enhanced timer function blocks with microsecond resolution. 

The library includes the core MicroTimer function block as well as redefinition of standard function blocks: UTON "Switch on delay", UTOF "Switch off delay", and UTP "Pulse generator". The redefined stardard function blocks maintain I/O compatibility with the IEC basic data type TIME. However, TIME has a resolution of one millisecond and therefore weakens those function blocks' resolution.

**NOTE:** This is not an official library. MicroTimer is provide as is under the GPL-3.0 license.  
[Download the library here](https://github.com/tmatijevich/MicroTimer/releases/latest/download/MicroTimer.zip).

## Clone

Clone to a reference location

```
git clone https://github.com/tmatijevich/MicroTimer.git
```

Or, add as a submodule to your project's libraries

```
cd <project_root>
git submodule add https://github.com/tmatijevich/MicroTimer.git <apj_root>/Logical/Libraries/MicroTimer
```

Then add as an existing library with the Automation Studio toolbox.

## Dependencies

- brsystem
- AsIOTime
- AsIecCon

## Git

- [Install and setup Git](https://tmatijevich.github.io/gfw-tutorial/)
- [Setup gitignore for your repository](https://gist.github.com/tmatijevich/453436f1e6abc62a3d052d9b03f9db58)

## Authors

- [tmatijevich](https://github.com/tmatijevich)
