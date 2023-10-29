{
  lib,
  autoPatchelfHook,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  gcc,
  stdenv,
}:

let
  inherit (builtins) substring;
  githash = "f4fef21d0d88b7931b95549782563db4da91a8f8";
in
buildDotnetModule {
  pname = "Aaru";
  version = "5.3.2";
  # actual version used is "v5.3.2"

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = githash;
    hash = "sha256-f/8TXe02FXygmzHpf6h7mUdGmBq7pJS/ct9AeUg2lww=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;
  nugetDeps = ./deps_lts.nix;
  projectFile = "Aaru/Aaru.csproj";
  selfContainedBuild = false;
  runtimeId = "linux-x64";
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc gcc.cc.libgcc];
  patchPhase = ''
    substituteInPlace "Aaru/Aaru.csproj" \
      "Aaru.Compression/Aaru.Compression.csproj" "Aaru.Core/Aaru.Core.csproj" \
      "Aaru.Database/Aaru.Database.csproj" "Aaru.Devices/Aaru.Devices.csproj" \
      "Aaru.Filesystems/Aaru.Filesystems.csproj" \
      "Aaru.Filters/Aaru.Filters.csproj" "Aaru.Images/Aaru.Images.csproj" \
      "Aaru.Partitions/Aaru.Partitions.csproj" \
      "Aaru.Settings/Aaru.Settings.csproj" \
      "Aaru.Tests.Devices/Aaru.Tests.Devices.csproj" --replace '{chash:8}' \
      "${substring 0 8 githash}"
  '';

  meta = {
    homepage = "https://aaru.app";
    description = "The LTS version of a fully-featured media dump management solution";
    license = [ lib.licenses.gpl3Only ];
    mainProgram = "aaru";
    maintainers = [ lib.maintainers.whovian9369 ];
  };
}
