{
  description = "A fully-featured media dump management solution.";

  inputs = {
    # The nixos-unstable branch of the NixOS/nixpkgs repository on GitHub.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = self.packages.x86_64-linux.prerelease;
    packages.x86_64-linux.git = nixpkgs.legacyPackages.x86_64-linux.callPackage ./git.nix {};
    packages.x86_64-linux.lts = nixpkgs.legacyPackages.x86_64-linux.callPackage ./lts.nix {};
    packages.x86_64-linux.prerelease = nixpkgs.legacyPackages.x86_64-linux.callPackage ./prerelease.nix {};
  };
}
