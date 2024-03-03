# MNDLBRT
This is a monorepo of all my Mandelbrot Ports' Source Code.
Looking back, this was less of a testament to how portable my code was, but to how dedicated and talented the developers behind the Compilers for each of these platforms were/are.

You can also grab a few of these on my [Mandelbrot Ports Website](https://pixelbrush.dev/apps/mandelbrotPorts).

# Python
My first stab at a Mandelbrot Set Renderer.

# MSDOS
The origin for all my later C Mandelbrot Ports. I haven't touched this code in 2 years, so it's definitely not representative of what I'm capable of now.
Consists of a few files:
## MNDLOLD
This was my first stab at this, and eventually grew too messy.

## MNDLBRT8
I believe this is the last Version I made. It has a few neat features, like BMP Exports.

## MNDLBRTL
This one has increased precision, as it uses long doubles, but it reduces its speed tremendously.

## MNDLBRTC
No idea

## MNDLBRTT
Idk

## MNDL5151
A massively scaled down branch of this later became [MNDL5150](https://github.com/OfficialPixelBrush/MNDL5150).

# Nintendo GameBoy
This one was made for fun. It is based on my DOS Program, and uses fixed-point integers to be rendered, as GBDK didn't have float support at the time.

# Lua
## Computer Craft
A friend and I were invited to play on a heavily modded Minecraft Server, which introduced me to ComputerCraft. I ended up spending nearly 2 weeks learning Lua to make this Port.

One prints the mandelbrot set out on a screen, the other has a turtle build it.

## Pico-8
This one is based on the ComputerCraft Version, since it also uses Lua.

# WIN/Windows
This one is based on the DOS Version again, just that it spits it into the Windows CLI instead. I later modified it to be more quickly make nice BMP Exports of locations I found.

## CSharp
This appears to be one of the first projects I made to test out C#. 

# C64/Commodore 64
This was me attempting to push the limits of what I was doing, but not really. I just wanted to be able to claim that I ported a Program to lots of platforms. 

Later I made an attempt to do it properly in 6502/6510 Assembly, but that attempt remains unfinished. It's currently in a Repository labelled as [MDNLBRT64](https://github.com/OfficialPixelBrush/MNDLBRT64).

# Apple II
Same story as the Commodore Version.

# 3DS/Nintendo 3DS
This one is genuinely the best port of the DOS original, sporting various useful features, and being relatively performant.

I made lots of renders with this one, since I could use this version on car rides.

# DS/Nintendo DS
A derivative of the 3DS Port. It's sufficiently functional, just slower.

# NX/Nintendo Switch
Theoretically, this is a functional Mandelbrot Renderer for the Nintendo Switch. I just never did much more beyond testing it in an Emulator once.
