{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig
}:

let
  inherit (builtins) substring;
in
buildDotnetModule rec {
  pname = "Aaru";
  version = "6.0.0";
  # actual version used is "v6.0.0-${substring 0 8 src.rev}"

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = "21368f00139e68586008d343e30243aeaf00bb66";
    hash = "sha256-17gF/0sF5KHIplftdczXWblpQ/huE0Xh/bVinilMGg8=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  buildType = "Debug";

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  nugetDeps = ./deps_git.json;
  projectFile = "Aaru/Aaru.csproj";
  dotnetBuildFlags = [ "--framework net9.0" ];
  dotnetInstallFlags = [ "--framework net9.0" ];
  selfContainedBuild = false;
  runtimeId = "linux-x64";
  executables = [ "aaru" ];

  runtimeDeps = [ fontconfig.lib ];

  postPatch = ''
    # Remove global.json to prevent build issues stemming from its existence.
    # We're pinning to an SDK version by using Nix anyway, so it's not super
    # important to worry about Upstream's set version.
    rm global.json

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
      --replace-fail '{chash:8}' "${substring 0 8 src.rev}"
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
