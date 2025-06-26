

# Friday Night Funkin': Mado Mod

![Mado Mod logo](https://files.catbox.moe/5t3e6t.png)

### Current Version: *Snooze Demo*

Thank you for playing Mado Mod! We put a lot of time and effort into this mod and we thank you for playing it! :D

What you're viewing here is the **SOURCE CODE** for the mod, this contains all the code for the mod for your viewing. If you don't care about the code and want the actual mod download, you can download it at [here!](https://www.x.com/sillycodergirl).

The mod was coded using Alice's small fork of Psych Engine 0.7.3 called QualO Engine.
Psych Engine, and by extension QualO uses Haxe/HaxeFlixel (main game) and Lua (softcoded mid-song events) to run.

## Libraries
To compile, Friday Night Funkin' uses a multitude of libraries to run correctly, and some versions may not be compatible with the code base.

You must have Haxe installed to do anything seen below. Download it [here](https://haxe.org/).

It would be best to follow HaxeFlixel's own guide to do the next to install very needed things like `lime` and `openfl`. You can view that [here](https://haxeflixel.com/documentation/install-haxeflixel/).

**VERY IMPORTANT!**
> If you're targeting for C++ (which you most likely are), you need to download the c++ stuff for it. Download that stuff here: https://github.com/ShadowMario/FNF-PsychEngine/blob/main/setup/setup-msvc-win.bat


Please see the list of libraries that are best suited for the compilation of this mod:
```bash
flixel - 5.8.0
flixel-ui - 2.6.1
flixel-addons - 3.3.2
tjson - 1.4.0
linc_luajit - https://github.com/superpowers04/linc_luajit.git
SScript - **SEE COMMANDS BELOW**
hxvlc - https://github.com/MAJigsaw77/hxvlc
hxdiscord_rpc - https://github.com/MAJigsaw77/hxdiscord_rpc
flxanimate - https://github.com/Dot-Stuff/flxanimate/

// These should all be downloaded automatically but just incase.
lime - 8.2.2
openfl - 9.4.1
hxcpp - 4.3.2

```
See below for commands regarding installation of the libraries:
**#.#.#**
`haxelib install {name} {version}`

**Links**
`haxelib git {name} {link}`

**SScript**
SScript has deleted all of their public downloads of SScript so you need to add it manually.
To do so, you must [download this file](https://github.com/CCobaltDev/SScript-Archive/raw/refs/heads/main/archives/SScript-21,0,0.zip) and place it in a certain area.

After downloading:

 1. Go to your Haxe location (should be C:/HaxeToolkit by default)
 2. Navigate to `HaxeToolkit/haxe/lib/`
 3. Make a new folder called `SScript` and navigate into it.
 4. Inside the new folder, create a new folder called `21,0,0`
 5. Drop the contents of the downloaded file into the new folder you just made, this folder should contain everything needed. `21,0,0/src` should be a valid path.

## Building
After installing all the libraries, navigate to your project folder (the one containing `Project.xml`) within a command prompt / powershell. (use `cd PATH` to do so)

Once you're in the project directory, run `lime test windows` to start the game compilation.
The first time will take awhile (5-20 minutes depending on your hardware). After that, it should only take a matter of seconds.

## Credits
- [Eyeben](https://x.com/IBNVintage) - Director & Artist
- [Ultraweh](https://x.com/UltraWeh) - Co-Director, Artist, Musician, Charter
- [TheoryOfEverything](https://x.com/gdLevelTwelve) - Musician
- [Byzafyre](https://x.com/byzafyre) - Charter
- [SillyCoderGirl](https://x.com/sillycodergirl) - Coder
- [Ari_The_When](https://x.com/Ari_the_when) - Musician
- [L.Creeper](https://x.com/CartoonSpeed) - Charter
- [ItsSarah](https://x.com/themariogal) - Artist
- [JosephTL](https://x.com/TLimbless) - F.C. Sprites

**Special Thanks**

- [ItsSuperDude](https://x.com/Itssuperdude)
- [BillionSwing](https://x.com/Billion_Swing)
- LazyEric
- [IcePopLOL](https://x.com/icepoplolNG)
- [oatmealine](https://oat.zone/) - Creator of the shader used on the nexus BG (I found on [shadertoy](https://www.shadertoy.com/view/wtlyzH))

## Last Important Notes
I won't be taking the time to fix niche issues with your build or any modifications you do to this code. Don't try to get the attention of any of the developers for this purpose. The point of this code being open source is to share knowledge with anyone who may be curious. With that, enjoy!

- Love, Alice. <3
