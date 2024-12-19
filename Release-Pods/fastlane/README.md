fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios pod_install

```sh
[bundle exec] fastlane ios pod_install
```

pod install

Sample 1: fastlane ios pod_install

Sample 2: fastlane ios pod_install podfile:<podfile>

### ios pod_repo_add

```sh
[bundle exec] fastlane ios pod_repo_add
```

pod repo add <spec-name> <spec-git-url>

Sample: fastlane ios pod_repo_add

### ios git_fetch_tag_force

```sh
[bundle exec] fastlane ios git_fetch_tag_force
```

git_fetch_tag_force

Samples:fastlane ios git_fetch_tag_force

### ios lint

```sh
[bundle exec] fastlane ios lint
```

pod lib lint

Sample: fastlane ios lint

### ios bump_tag

```sh
[bundle exec] fastlane ios bump_tag
```

Bump podspec file version, bump_type: major, minor, patch

Samples: fastlane ios bump_tag type:major

Samples: fastlane ios bump_tag version:x.x.x

### ios repo_push

```sh
[bundle exec] fastlane ios repo_push
```

pod repo push

Samples: fastlane ios repo_push

### ios release_pod

```sh
[bundle exec] fastlane ios release_pod
```

Release a private pod

Samples 1: fastlane ios release_pod type:major

Samples 2: fastlane ios release_pod version:x.x.x

### ios build_frameworks

```sh
[bundle exec] fastlane ios build_frameworks
```

build frameworks for a pod

Sample 1: fastlane ios build_frameworks configuration:Debug/Release/Staging/Preproduction skds:iphoneos,iphonesimulator

Sample 2: fastlane ios build_frameworks

### ios build_iphoneos_frameworks

```sh
[bundle exec] fastlane ios build_iphoneos_frameworks
```

build frameworks for a pod by skd = iphoneos

Sample 1: fastlane ios build_iphoneos_frameworks configuration:Debug/Release/Staging/Preproduction

Sample 2: fastlane ios build_iphoneos_frameworks

### ios build_iphonesimulator_frameworks

```sh
[bundle exec] fastlane ios build_iphonesimulator_frameworks
```

build frameworks for a pod by skd = iphonesimulator

Sample 1: fastlane ios build_iphonesimulator_frameworks configuration:Debug/Release/Staging/Preproduction

Sample 2: fastlane ios build_iphonesimulator_frameworks

### ios create_united_frameworks

```sh
[bundle exec] fastlane ios create_united_frameworks
```

create united frameworks

Sample: fastlane ios create_united_frameworks sdks:iphoneos,iphonesimulator configurations:Debug,Release skip_build:true

### ios build_all_frameworks

```sh
[bundle exec] fastlane ios build_all_frameworks
```

build all frameworks

Sample: fastlane ios build_all_frameworks sdks:iphoneos,iphonesimulator configurations:Debug,Release

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
