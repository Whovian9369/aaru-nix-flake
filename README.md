# Whovian's Aaru nix flake
I wanted to make a nix flake for [Aaru](https://github.com/aaru-dps/Aaru) to use it in my NixOS environment, and also gave me an oppourtunity to play with flakes on a "simpler" project. This is my first flake, so please let me know if you see ways that I can improve.
You should be able to build it by running `nix build "git+https://github.com/Whovian9369/aaru-nix-flake.git"`.

[Aaru](https://github.com/aaru-dps/Aaru) is licensed under the GNU General Public License, Version 3.

Warning about Aaru v6.0.0 Alpha 9 from the developer on its [official pre-release page.](https://github.com/aaru-dps/Aaru/releases/tag/v6.0.0-alpha9)
> WARNING THIS IS A PRE-RELEASE
> 
> Images created with this version are not guaranteed to work, be repairable, or contain correct information.

Notes:
- I have not been able to test this on a system that isn't `x86_64-linux`, so I have it hardcoded in the flake. 
- The version number that you see when running `aaru --version` will just show `6.0.0-alpha9`, when it normally shows `6.0.0-alpha9-XXXXXXXX` where `XXXXXXXX` is a short `git` commit hash. For this derivation since we don't keep the `.git` directory, I disabled the commit hash portiion of the version number by suggestion of the main developer.
  - You can see which commit this flake was made with in `package.nix` anyway, so it's not an issue that I'm personally as worried about.
