# Pre-Release notes
- `89ae5e8d8b7aa47ca1e2573cf13ed37df5f34e8f` is commit used for `${version}` release tag (on GH)
- `e10c237ebd879041f49b6f1d58d643a14e901995` is commit used for `${version}` release Windows binary ( via `aaru --version`)
- Those commits were ~3.5 hrs apart
  - Is `e10c...` the actual build time commit while claunia fixed issues with the build environment, etc? 
  - Maybe `e10c...` was built as a test of the build scripts that Claunia then refined further or something? Not positive...)

```
89ae5e8d8b7aa47ca1e2573cf13ed37df5f34e8f (tag: v6.0.0-alpha9)
Date:   Fri Dec 23 17:38:12 2022 +0000
    Update changelog.
3b8aac514384341201e37a106a4f4398469de9b0
Date:   Fri Dec 23 17:38:04 2022 +0000
    Bump version to v6.0.0-alpha9.
89ea1b2b3e1c6865379adcb25e9f70ea35c3af9e
Date:   Fri Dec 23 17:37:31 2022 +0000
    Update build scripts for .NET 7.0.
e10c237ebd879041f49b6f1d58d643a14e901995
Date:   Fri Dec 23 14:04:59 2022 +0000
    Update release checklist.
```
