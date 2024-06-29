{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

let
  inherit (builtins) substring;
  githash = "ae8d6e385459c0607a137693eca96eb397f89598";
in
buildDotnetModule {
  pname = "Aaru";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = githash;
    hash = "sha256-MkkAEcPdg3Fzz0TLMlKkcvhwe+6ZXvOfdp7ZQogWaho=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps_git.nix;
  projectFile = "Aaru/Aaru.csproj";
  dotnetBuildFlags = [
  "--framework net8.0"
  ];
  dotnetInstallFlags = [
  "--framework net8.0"
  ];
  buildType = "Debug";
  selfContainedBuild = false;
  runtimeId = "linux-x64";

  patchPhase = ''
    substituteInPlace \
      "Aaru/Aaru.csproj" \
      "Aaru.Archives/Aaru.Archives.csproj" \
      "Aaru.Checksums/Aaru.Checksums.csproj" \
      "Aaru.CommonTypes/Aaru.CommonTypes.csproj" \
      "Aaru.Compression/Aaru.Compression.csproj" \
      "Aaru.Console/Aaru.Console.csproj" \
      "Aaru.Core/Aaru.Core.csproj" \
      "Aaru.Database/Aaru.Database.csproj" \
      "Aaru.Decoders/Aaru.Decoders.csproj" \
      "Aaru.Decryption/Aaru.Decryption.csproj" \
      "Aaru.Devices/Aaru.Devices.csproj" \
      "Aaru.Dto/Aaru.Dto.csproj" \
      "Aaru.Filesystems/Aaru.Filesystems.csproj" \
      "Aaru.Filters/Aaru.Filters.csproj" \
      "Aaru.Gui/Aaru.Gui.csproj" \
      "Aaru.Helpers/Aaru.Helpers.csproj" \
      "Aaru.Images/Aaru.Images.csproj" \
      "Aaru.Partitions/Aaru.Partitions.csproj" \
      "Aaru.Settings/Aaru.Settings.csproj" \
      "Aaru.Tests.Devices/Aaru.Tests.Devices.csproj" \
      --replace-fail '{chash:8}' "${substring 0 8 githash}"
  '';
  # substituteStream(): WARNING: '--replace' is deprecated, use --replace-{fail,warn,quiet}.

  meta = {
    homepage = "https://aaru.app";
    description = "The Pre-Release version of a fully-featured media dump management solution";
    license = [ lib.licenses.gpl3Only ];
    mainProgram = "aaru";
    maintainers = with lib.maintainers; [  ];
  };
}
