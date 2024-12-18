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

## Step2. Modify Repo Remote URL
Modify remote url to using another ssh account to push specs.
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
