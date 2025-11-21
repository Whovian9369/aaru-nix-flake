# Whovian's Aaru nix flake
I wanted to make a nix flake for [Aaru](https://github.com/aaru-dps/Aaru) to use it in my NixOS environment, and also gave me an oppourtunity to play with flakes on a "simpler" project. This is my first flake, so please let me know if you see ways that I can improve.
You should be able to build it by running `nix build github:Whovian9369/aaru-nix-flake#prerelease`.

[Aaru](https://github.com/aaru-dps/Aaru) is licensed under the GNU General Public License, Version 3.

There is a warning attached to Aaru v6.0.0 Alpha 12 from the developer on its [official pre-release page.](https://github.com/aaru-dps/Aaru/releases/tag/v6.0.0-alpha.12)
> WARNING THIS IS A PRE-RELEASE
> 
> Images created with this version are not guaranteed to work, be repairable, or contain correct information.

Notes:
- I have not been able to test this on a system that isn't `x86_64-linux`, so I have it hardcoded in the flake. 
