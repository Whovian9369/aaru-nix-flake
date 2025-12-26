{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig
}:

buildDotnetModule rec {
  pname = "Aaru";
  # actual version used is "v6.0.0-${substring 0 8 src.rev}"
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = "4f68b6e2befac159115609ef80177ffd9e7fde4c";
    hash = "sha256-zC+O8oXGZJtEFbS5Ctn9JXhGm/caVMFa1pesX+i2Es8=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  buildType = "Debug";

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  nugetDeps = ./deps_git.json;
  projectFile = "Aaru/Aaru.csproj";

  dotnetFlags = [ "-p:PublishSingleFile=false" ];
  dotnetBuildFlags = [ "--framework net10.0" ];
  dotnetInstallFlags = [ "--framework net10.0" ];
  selfContainedBuild = false;
  # runtimeId = "linux-x64";
  executables = [ "aaru" ];

  runtimeDeps = [ fontconfig.lib ];

  postPatch = ''
    # Remove global.json to prevent build issues stemming from its existence.
    # We're pinning to an SDK version by using Nix anyway, so it's not super
    # important to worry about Upstream's set version.
    rm global.json

    # Swap out uses of "git" with shortened version of src.rev
    # Used in "aaru --version" and during build.
    substituteInPlace \
      "Directory.Build.props" \
      "Aaru.Archives/Aaru.Archives.csproj" \
      "Aaru.Checksums/Aaru.Checksums.csproj" \
      "Aaru.CommonTypes/Aaru.CommonTypes.csproj" \
      "Aaru.Compression/Aaru.Compression.csproj" \
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
      "Aaru.Logging/Aaru.Logging.csproj" \
      "Aaru.Partitions/Aaru.Partitions.csproj" \
      "Aaru.Settings/Aaru.Settings.csproj" \
      "Aaru.Tests.Devices/Aaru.Tests.Devices.csproj" \
      --replace-fail '{chash:8}' "${lib.substring 0 8 src.rev}"
  '';
  # substituteStream(): WARNING: '--replace' is deprecated, use --replace-{fail,warn,quiet}.

  meta = {
    homepage = "https://aaru.app";
    description = "The Pre-Release version of a fully-featured media dump management solution";
    # License confirmed via confirmation with claunia, and
    # https://github.com/aaru-dps/Aaru/blob/f4fef21d0d88b7931b95549782563db4da91a8f8/LICENSE
    license = lib.licenses.gpl3Only;
    mainProgram = "aaru";
    maintainers = with lib.maintainers; [  ];
  };
}
