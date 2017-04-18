# Build

Contains scripts for building the Whalecore images. Run ./Build.ps1 for a complete build.

## Used tags

### latest

`latest` is used for the latest stable release (eg. master branch) of non-sitecore images. `latest` is also applied for local images during development when running with buildMode `local`.

### Sitecore Version

For sitecore images, the version will be used for tagging. This replaces the `latest` tag.

`8.2-rev-161221` - Sitecore 8.2 Update 2

## Build.ps1

Invokes a Build of all Whalecore images. Images will be tagged with the current version (semver/gitversion) and pushed to the defined registry.

### Params

#### buildMode

`local` - Images will not be pulled from the registry, built images will always be tagged with `latest` and not be pushed. Use this when developing.
Default: `local`