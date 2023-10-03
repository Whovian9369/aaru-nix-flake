{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
}:

buildDotnetModule {
  pname = "Aaru";
  version = "6.0.0-alpha9";
  # version used is "v6.0.0-alpha9"

  src = fetchFromGitHub {
    owner = "aaru-dps";
    repo = "Aaru";
    rev = "89ae5e8d8b7aa47ca1e2573cf13ed37df5f34e8f";
    hash = "sha256-cYvkCG7mc30RxHMeNvUvUov8ubtNmR4d6F2UkJmfHx0=";
    fetchSubmodules = true;
    leaveDotGit = false;
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;
  nugetDeps = ./deps_prerelease.nix;
  projectFile = "Aaru/Aaru.csproj";
  selfContainedBuild = false;
  patches = [ ./remove_short_commit_hash.diff ];

  meta = {
    homepage = "https://aaru.app";
    description = "A fully-featured media dump management solution";
    license = [ lib.licenses.gpl3Only ];
    mainProgram = "aaru";
    maintainers = [ lib.maintainers.whovian9369 ];
  };
}
