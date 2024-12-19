# Specs
Custom pod specs repository for mirror sdks &amp; private usage.

## Step1. Add Repo to your git repo list
```
$ pod repo add mine_specs git@github.com:MichaelLedger/Specs.git
Cloning spec repo `mine_specs` from `git@github.com:MichaelLedger/Specs.git`

$ pod repo list

master
- Type: git (remotes/origin/master)
- URL:  https://github.com/CocoaPods/Specs.git
- Path: /Users/gavinxiang/.cocoapods/repos/master

mine_specs
- Type: git (main)
- URL:  git@github.com:MichaelLedger/Specs.git
- Path: /Users/gavinxiang/.cocoapods/repos/mine_specs

trunk
- Type: CDN
- URL:  https://cdn.cocoapods.org/
- Path: /Users/gavinxiang/.cocoapods/repos/trunk

3 repos
```

## Step2. Modify Repo Remote URL(skip this step if repo is public && ssh is correct.)

```
$ pwd
/Users/gavinxiang/.ssh

$ ls
config           github-rsa       github-rsa-2     github-rsa-2.pub github-rsa.pub   known_hosts

$ cat config
# github
Host github.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/github-rsa

Host github2.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/github-rsa-2
```

Modify git remote url host to using another ssh account to push specs.
```
$ cd /Users/gavinxiang/.cocoapods/repos/mine_specs

$ git remote -v
origin    git@github.com:MichaelLedger/Specs.git (fetch)
origin    git@github.com:MichaelLedger/Specs.git (push)

$ git remote set-url origin git@github2.com:MichaelLedger/Specs.git

$ git remote -v
origin    git@github2.com:MichaelLedger/Specs.git (fetch)
origin    git@github2.com:MichaelLedger/Specs.git (push)
```

## Step3. pod repo push `.podspec`
```
$ pwd   
/Users/gavinxiang/Downloads/YYModel

$ pod repo push mine_specs 'YYModel.podspec' --sources='git@github.com:MichaelLedger/Specs.git' --allow-warnings --skip-import-validation --skip-tests

Validating spec
 -> YYModel (1.0.6)
    - NOTE  | xcodebuild:  note: Using codesigning identity override: -
    - NOTE  | xcodebuild:  note: Building targets in dependency order
    - NOTE  | xcodebuild:  note: Target dependency graph (1 target)
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:247:41: warning: a function declaration without a prototype is deprecated in all versions of C [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:272:56: warning: a function declaration without a prototype is deprecated in all versions of C [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:1065:49: warning: a block declaration without a prototype is deprecated  [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:1065:111: warning: a block declaration without a prototype is deprecated  [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:1067:49: warning: a block declaration without a prototype is deprecated  [-Wstrict-prototypes]
    - WARN  | xcodebuild:  YYModel/YYModel/NSObject+YYModel.m:1067:111: warning: a block declaration without a prototype is deprecated  [-Wstrict-prototypes]
    - NOTE  | xcodebuild:  note: Disabling previews because SWIFT_VERSION is set and SWIFT_OPTIMIZATION_LEVEL=-O, expected -Onone (in target 'YYModel' from project 'Pods')
    - NOTE  | xcodebuild:  note: Using codesigning identity override: 

Updating the `mine_specs' repo


Adding the spec to the `mine_specs' repo

 - [No change] YYModel (1.0.6)

Pushing the `mine_specs' repo
```

## Step4. add source to `Podfile`

```
# Podfile
source 'https://github.com/CocoaPods/Specs.git'
source 'git@github.com:MichaelLedger/Specs.git'

platform :ios, '15.0'

# ignore all warnings from all pods
inhibit_all_warnings!

ensure_bundler! '~> 2.5.0'

use_frameworks!

def ucd_pods
    pod 'SDWebImageSVGCoder',                '~> 1.7.0'
    pod 'JXSegmentedView',                   '~> 1.3.0'
    pod 'JXPagingView/Paging',               '~> 2.l.2'
end

def mine_pods
    pod 'YYModel',  '~> 1.0.6'
end

target 'XXX' do
  ucd_pods
  mine_pods
end

# Name | NSExtensionPointIdentifier
# NotificationExtension | com.apple.usernotifications.service
# NotificationContentExtension | com.apple.usernotifications.content-extension
target 'XXXNotificationContentExtension' do
  pod 'Appboy-Push-Story',                '~> 4.7.0'
end

pre_install do |installer|
  # localization: we only support english
  # delete (yes, filesystem delete!) any unwanted localization files that were
  # included with the pods
  supported_locales = ['base', 'en']
  Dir.glob(File.join(installer.sandbox.pod_dir('*'), '**', '*.lproj')).each do |bundle|
    if (!supported_locales.include?(File.basename(bundle, ".lproj").downcase))
      puts "Pod includes unsupported localization: #{File.basename(bundle)}"
      puts "Removing #{bundle}"
      puts " "
      FileUtils.rm_rf(bundle)
    end
  end
end

post_install do |installer|
  add_build_configurations(installer.pods_project)
  installer.pods_project.targets.each do |target|
    add_build_configurations(target)
  end
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
  end
end

post_integrate do |installer|
  workspace_path = 'XXX.xcworkspace'
  workspace = Xcodeproj::Workspace.new_from_xcworkspace(workspace_path)
  workspace.file_references.each do |file_reference|
    project = Xcodeproj::Project.open(file_reference.path)
    add_build_configurations(project)
    project.save()
  end
end


# Add "build configurations"
def add_build_configurations(project)
  project.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    config.build_settings["DEVELOPMENT_TEAM"] = "XXX4XXXXXX3"
    if config.name == 'Debug'
      config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'DEBUG SKIP_XX_BUILD'
    elsif config.name == 'TestFlight'
      config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'TESTFLIGHT SKIP_XX_BUILD'
    elsif config.name == 'Release'
      config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'RELEASE SKIP_XX_BUILD'
    end
  end
end
```

## Step5. Pod install
```
$ pod install --verbose

-> Installing YYModel (1.0.6)
 > Git download
 > Git download
     $ /usr/bin/git clone https://github.com/MichaelLedger/YYModel.git
     /var/folders/wk/frkkcch539lc6s2dk6dw9dy80000gn/T/d20241219-2751-i9h8eu --template= --single-branch --depth 1
     --branch 1.0.6
     Cloning into '/var/folders/wk/frkkcch539lc6s2dk6dw9dy80000gn/T/d20241219-2751-i9h8eu'...
     Note: switching to 'd928780e6d3f53467b9e38758eaf8f15a499fd11'.
     
  > Copying YYModel from `/Users/gavinxiang/Library/Caches/CocoaPods/Pods/Release/YYModel/1.0.6-ad2ab` to
  `Pods/YYModel`
```

## Step6. Open `XXX.xcworkspace` with Xcode.
That's all! 🎉🎉🎉🍺🍺🍺

## Bundle Commands
### bundle install
```
$ bundle install
Fetching git@github.com:MichaelLedger/cocoapods-packager.git
Fetching gem metadata from https://rubygems.org/.......
Resolving dependencies...
Using cocoapods-packager 2.0.1 (was 1.5.0) from git@github.com:MichaelLedger/cocoapods-packager.git (at master@4fbf72e)
Bundle complete! 4 Gemfile dependencies, 122 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

### fastlane ios release_pod
[FastlaneTools/blob/main/lib/fastlane/fastlane.pods.rb](https://github.com/MichaelLedger/FastlaneTools/blob/main/lib/fastlane/fastlane.pods.rb)
```
default_platform(:ios)
xcode_select(ENV["XCODE_SELECT"])

platform :ios do

  //...
  
  desc "Release a private pod"
  desc "Samples 1: fastlane ios release_pod type:major"
  desc "Samples 2: fastlane ios release_pod version:x.x.x"
  lane :release_pod do |options|
    lint
    bump_tag(options)
    repo_push
  end

end
```

Terminal practice:
```
$ cd scripts
$ sh release.sh YYModel
bundle exec fastlane ios release_pod --env YYModel
```

### pod package
An alternative to cocoapods-packager, adapted to the latest Xcode.
CocoaPods plugin which allows you to generate a framework or static library from a podspec.
```
$ cd scripts
$ sh package.sh YYModel.podspec 
bundle exec pod package YYModel.podspec --force --no-mangle --verbose
  Preparing

Analyzing dependencies

Fetching external sources
-> Fetching podspec for `YYModel` from `/Users/gavinxiang/Downloads/Specs/scripts/YYModel.podspec`

Resolving dependencies of 
  CDN: trunk Relative path: CocoaPods-version.yml exists! Returning local because checking is only performed in repo update

Comparing resolved specification to the sandbox manifest
  A YYModel

Downloading dependencies

-> Installing YYModel (1.0.6)
  > Copying YYModel from `/Users/gavinxiang/Library/Caches/CocoaPods/Pods/External/YYModel/ee0f5a9852640421aa1d7cf50052ad4a-69d41` to `Pods/YYModel`
  - Running pre install hooks
  - Running pre integrate hooks

Generating Pods project
  - Creating Pods project
  - Installing files into Pods project
    - Adding source files
    - Adding frameworks
    - Adding libraries
    - Adding resources
    - Linking headers
  - Installing Pod Targets
    - Installing target `YYModel` iOS 12.0
      - Generating dummy source at `Pods/Target Support Files/YYModel/YYModel-dummy.m`
  - Installing Aggregate Targets
    - Installing target `Pods-packager` iOS 12.0
      - Generating dummy source at `Pods/Target Support Files/Pods-packager/Pods-packager-dummy.m`
  - Stabilizing target UUIDs
  - Running post install hooks
  - Writing Xcode project file to `Pods/Pods.xcodeproj`
  Cleaning up sandbox directory

Skipping User Project Integration
  - Writing Lockfile in `Podfile.lock`
  - Writing Manifest in `Pods/Manifest.lock`
  CDN: trunk Relative path: CocoaPods-version.yml exists! Returning local because checking is only performed in repo update

-> Pod installation complete! There is 1 dependency from the Podfile and 1 total pod installed.
Building static framework YYModel (1.0.6) with configuration Release
Including dependencies
Vendored libraries: []
current xcode version: 16.2
Initial architectures: ["x86_64", "arm64", "arm64e"]
Final architectures: ["x86_64", "arm64", "arm64e"]
  Preparing

Analyzing dependencies

Fetching external sources
-> Fetching podspec for `YYModel` from `/Users/gavinxiang/Downloads/Specs/scripts/YYModel.podspec`

Resolving dependencies of 
  CDN: trunk Relative path: CocoaPods-version.yml exists! Returning local because checking is only performed in repo update

Comparing resolved specification to the sandbox manifest
  A YYModel

Downloading dependencies

-> Installing YYModel (1.0.6)
  > Copying YYModel from `/Users/gavinxiang/Library/Caches/CocoaPods/Pods/External/YYModel/ee0f5a9852640421aa1d7cf50052ad4a-69d41` to `Pods/YYModel`
  - Running pre install hooks
  - Running pre integrate hooks

Generating Pods project
  - Creating Pods project
  - Installing files into Pods project
    - Adding source files
    - Adding frameworks
    - Adding libraries
    - Adding resources
    - Linking headers
  - Installing Pod Targets
    - Installing target `YYModel` macOS 10.13
      - Generating dummy source at `Pods/Target Support Files/YYModel/YYModel-dummy.m`
  - Installing Aggregate Targets
    - Installing target `Pods-packager` macOS 10.13
      - Generating dummy source at `Pods/Target Support Files/Pods-packager/Pods-packager-dummy.m`
  - Stabilizing target UUIDs
  - Running post install hooks
  - Writing Xcode project file to `Pods/Pods.xcodeproj`
  Cleaning up sandbox directory

Skipping User Project Integration
  - Writing Lockfile in `Podfile.lock`
  - Writing Manifest in `Pods/Manifest.lock`

-> Pod installation complete! There is 1 dependency from the Podfile and 1 total pod installed.
Building static framework YYModel (1.0.6) with configuration Release
Including dependencies
Vendored libraries: []

$ ls
Package.swift   YYModel         YYModel-1.0.6   YYModel.podspec fastlane        package.sh      release.sh
$ cd YYModel-1.0.6 
$ ls
LICENSE         YYModel.podspec build           ios             osx
$ cd ios 
$ ls
YYModel.framework
```

## Other Tips
*GIT recommend every repository include a `README`, `LICENSE`, and `.gitignore`.*
### Git - create a new repository on the command line
```
echo "# cocoapods-packager" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:MichaelLedger/cocoapods-packager.git
git push -u origin main
```

### Git - push an existing repository from the command line
```
git remote add origin git@github.com:MichaelLedger/cocoapods-packager.git
git branch -M main
git push -u origin main
```
