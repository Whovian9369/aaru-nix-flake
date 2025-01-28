{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

let
  inherit (builtins) substring;
in
buildDotnetModule rec {
  pname = "Aaru";
  version = "5.3.2";
  # actual version used is "v5.3.2"

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = "f4fef21d0d88b7931b95549782563db4da91a8f8";
    hash = "sha256-f/8TXe02FXygmzHpf6h7mUdGmBq7pJS/ct9AeUg2lww=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;
  nugetDeps = ./deps_lts.json;
  projectFile = "Aaru/Aaru.csproj";

  dotnetBuildFlags = [ "--framework net7.0" ];
  dotnetInstallFlags = [ "--framework net7.0" ];
  selfContainedBuild = false;
  # runtimeId = "linux-x64";
  executables = [ "aaru" ];

  patches = [
    ./patches/lts/chash_to_shortrev.diff
      # Swap out uses of "git" with shortened version of src.rev
      # Used in "aaru --version" and during build.

    # ./patches/lts/build_with_net7.diff
      # Make this build via NET 7.0 instead of netcoreapp3.1

    # ./patches/lts/fix_net7_build.diff
      # Fix build on Net 7.0 by upgrading Microsoft.EntityFrameworkCore related
      # entries
  ];

  patchPhase = ''
    # Swap out uses of "git" with shortened version of src.rev
    # Used in "aaru --version" and during build.
    substituteInPlace \
      "Aaru/Aaru.csproj" \
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
      "Aaru.Helpers/Aaru.Helpers.csproj" \
      "Aaru.Images/Aaru.Images.csproj" \
      "Aaru.Partitions/Aaru.Partitions.csproj" \
      "Aaru.Settings/Aaru.Settings.csproj" \
      "Aaru.Tests.Devices/Aaru.Tests.Devices.csproj" \
      --replace-fail '{chash:8}' "${substring 0 8 src.rev}"
    # Make this build via NET 7.0 instead of netcoreapp3.1
    substituteInPlace \
      "Aaru/Aaru.csproj" \
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
      "Aaru.Helpers/Aaru.Helpers.csproj" \
      "Aaru.Images/Aaru.Images.csproj" \
      "Aaru.Partitions/Aaru.Partitions.csproj" \
      "Aaru.Settings/Aaru.Settings.csproj" \
      "Aaru.Tests/Aaru.Tests.csproj" \
      "Aaru.Tests.Devices/Aaru.Tests.Devices.csproj" \
      --replace-fail "netcoreapp3.1" "net7.0"
  '';

  meta = {
    homepage = "https://aaru.app";
    description = "The LTS version of a fully-featured media dump management solution";
    license = lib.licenses.gpl3Only;
      # License confirmed via confirmation with claunia, and
      # https://github.com/aaru-dps/Aaru/blob/f4fef21d0d88b7931b95549782563db4da91a8f8/LICENSE
    mainProgram = "aaru";
    maintainers = with lib.maintainers; [  ];
  };
}
