{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

let
  inherit (builtins) substring;
  githash = "89ae5e8d8b7aa47ca1e2573cf13ed37df5f34e8f";
in
buildDotnetModule {
  pname = "Aaru";
  version = "6.0.0-alpha9";
  # actual version used is "v6.0.0-alpha9"

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = githash;
    hash = "sha256-cYvkCG7mc30RxHMeNvUvUov8ubtNmR4d6F2UkJmfHx0=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;
  nugetDeps = ./deps_prerelease.nix;
  projectFile = "Aaru/Aaru.csproj";
  selfContainedBuild = false;

  patchPhase = ''
    substituteInPlace "Aaru/Aaru.csproj" "Aaru.Archives/Aaru.Archives.csproj" \
      "Aaru.Compression/Aaru.Compression.csproj" "Aaru.Core/Aaru.Core.csproj" \
      "Aaru.Database/Aaru.Database.csproj" "Aaru.Devices/Aaru.Devices.csproj" \
      "Aaru.Filesystems/Aaru.Filesystems.csproj" \
      "Aaru.Filters/Aaru.Filters.csproj" "Aaru.Gui/Aaru.Gui.csproj" \
      "Aaru.Images/Aaru.Images.csproj" \
      "Aaru.Partitions/Aaru.Partitions.csproj" \
      "Aaru.Settings/Aaru.Settings.csproj" \
      "Aaru.Tests.Devices/Aaru.Tests.Devices.csproj" --replace '{chash:8}' \
      "${substring 0 8 githash}"
  '';

  meta = {
    homepage = "https://aaru.app";
    description = "The Pre-Release version of a fully-featured media dump management solution";
    license = [ lib.licenses.gpl3Only ];
    mainProgram = "aaru";
    maintainers = [ lib.maintainers.whovian9369 ];
  };
}
