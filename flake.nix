{
  description = "A fully-featured media dump management solution.";

  inputs = {
    # The nixos-unstable branch of the NixOS/nixpkgs repository on GitHub.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      dotnet7-pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "dotnet-runtime-wrapped-7.0.20"
          "dotnet-runtime-7.0.20"
          "dotnet-sdk-wrapped-7.0.410"
          "dotnet-sdk-7.0.410"
        ];
      };
    in
  {
    packages = {
      x86_64-linux = {
        default = self.packages.${system}.prerelease;
        git = nixpkgs.legacyPackages.${system}.callPackage ./git.nix {};
        # lts = dotnet7-pkgs.callPackage ./lts.nix {};
          # As of 2025-01-26, this build seems to be horribly broken beyond what I am able to fix myself.
          # If you can, please feel free to open a PR!
        prerelease = dotnet7-pkgs.callPackage ./prerelease.nix {};
      };
    };
  };
}
