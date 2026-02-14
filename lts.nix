{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule rec {
  pname = "Aaru";
  version = "5.4.2";
  # actual version used is "v5.4.2"

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    tag = "v${version}";
    hash = "sha256-F+R45RAPdTdDr2KySOKeeNsS4mizgDNYeA1yuBVf9YA=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  # Build as "Debug" to give more descriptive error messages,e specially when crashes occur.
  # This *should* help reporting issues or crashes to upstream.
  buildType = "Debug";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps_lts.json;
  projectFile = "Aaru/Aaru.csproj";

  dotnetBuildFlags = [ "--framework net8.0" ];
  dotnetInstallFlags = [ "--framework net8.0" ];
  selfContainedBuild = false;
  # runtimeId = "linux-x64";
  executables = [ "aaru" ];

  postPatch = ''
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
      --replace-fail '{chash:8}' "${lib.substring 0 8 version}"
  '';

  meta = {
    homepage = "https://aaru.app";
    description = "LTS version of a fully-featured media dump management solution";
    # License confirmed via confirmation with claunia, and
    # https://github.com/aaru-dps/Aaru/blob/f4fef21d0d88b7931b95549782563db4da91a8f8/LICENSE
    license = lib.licenses.gpl3Only;
    mainProgram = "aaru";
    maintainers = with lib.maintainers; [ ];
  };
}
