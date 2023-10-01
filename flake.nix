{
  description = "A fully-featured media dump management solution.";

  inputs = {
    # The nixos-23.05 branch of the NixOS/nixpkgs repository on GitHub.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = self.packages.x86_64-linux.aaru;
    packages.x86_64-linux.aaru = nixpkgs.legacyPackages.x86_64-linux.callPackage ./package.nix {};
  };
}
