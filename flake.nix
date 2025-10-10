{
  description = "A fully-featured media dump management solution.";

  inputs = {
    # The nixos-unstable branch of the NixOS/nixpkgs repository on GitHub.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
  {
    packages = {
      x86_64-linux = {
        default = self.packages.${system}.prerelease;
        git = pkgs.callPackage ./git.nix {};
        lts = pkgs.callPackage ./lts.nix {};
        prerelease = pkgs.callPackage ./prerelease.nix {};
      };
    };
  };
}
