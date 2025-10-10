{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig
}:

buildDotnetModule rec {
  pname = "Aaru";
  version = "6.0.0-alpha.12";
  # actual version used is "v6.0.0-${substring 0 8 src.rev}"

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = "3b2cda2e312420038a40bd9a53f9a8334c38ca1b";
      /*
        This is technically pinned to the commit after the actual
        Pre-Release tag on GitHub.
        This is due to the build erroring, but the developer of Aaru made
        another commit after the Pre-Release tag fixes that exact issue.
      */
    hash = "sha256-onRCFQ0Iw01ZY1KLbK+iXNUZ9p79EWCzQrnW1Mfysho=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  buildType = "Debug";

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  nugetDeps = ./deps_prerelease.json;
  projectFile = "Aaru/Aaru.csproj";

  dotnetFlags = [ "-p:PublishSingleFile=false" ];
  dotnetBuildFlags = [ "--framework net10.0" ];
  dotnetInstallFlags = [ "--framework net10.0" ];
  selfContainedBuild = false;
  # runtimeId = "linux-x64";
  executables = [ "aaru" ];

  runtimeDeps = [ fontconfig.lib ];

  patches = [
  ];

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
    license = lib.licenses.gpl3Only;
      # License confirmed via confirmation with claunia, and
      # https://github.com/aaru-dps/Aaru/blob/f4fef21d0d88b7931b95549782563db4da91a8f8/LICENSE
    mainProgram = "aaru";
    maintainers = with lib.maintainers; [  ];
  };
}
