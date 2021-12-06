# unpubd
A docker container and management tools for running a local dart package respository.

Unpubd is essentially an installer for the unpub package.

The install creates two docker containers mongo, and unpubd.

Mongo provides the database for the packages and unpubd the web interface and api for the dart pub command.

Once installed and configured you can publish packages to a local repository.

Unpubd also acts as local proxy for pub.dev.

To use unpubd you can either use the unpub command in place of 'dart pub' or set up an environment variable PUB_HOSTED_URL which will cause dart pub to use your local repository.


# Installation

## Prerequisites
* Docker
* docker-compose

## To install unpubd
Start by installing the prequesites note above.

Then run.

```bash
dart pub global activate unpubd
unpubd install
```

When you install unpubd it will ask you for a port no. (defaults to 4000) to expose unpubd on.
You can changes this to any port between 1025 and 65000). Just make sure the port isn't already in use.

# Starting unpubd

To start unpubd in the foreground

```bash
unpubd up
```

To start unpubd in the background

```bash
unpub up --detach
```

# Stopping unpubd

If you are using unpubd in the foreground then just hit ctrl-c to terminate the app.

If th unpubd is running in the background run:
```bash
unpubd stop
```

# Using unpubd

The pub get/outdated/upgrade/publish commands all interact with pub.dev

Note: both `flutter pub` and `dart pub`  work the with the same changes desribed below.

Two methods are available to redirect the pub command to use your local package repository.

## 1) set PUB_HOSTED_URL environment variable

If you set the PUB_HOSTED_URL environment variable to point to your local repository then both dart pub and flutter pub will use your local repo.

You need to configure the environment variable so it is avialable in your shell.

Once PUB_HOSTED_URL is created you can run any pub command and your local repository will be used.

### On linux:
export PUB_HOSTED_URL=http://localhost:4000

### On Windows
Add the same URL to your PATH via the registry.

### On MacOS
Drop me a line if you know the details :)


## 2) use unpub
The unpub command (as opposed to unpubd which we used during the install) is simply a pass through mechanism to dart pub.
The unpub command dynamically sets the PUB_HOSTED_URL and then calls dart pub with the same arguments.

* unpub - for user of the Dart SDK use: 
* funpub - For users of the Flutter SDK use: 

This approach has the advantage in that if you need to revert to using pub.dev you can just revert to using dart pub/flutter pub  and you don't have to create any environment variables.

## Publishing to unpubd
To publish your packages to unpubd (rather than pub.dev) you need to add a 'publish_to' key to your packages pubspec.yaml.

```yaml
name: dcli
description: Dart console SDK
version: 1.0.0
repository: https://github.com/noojee/dcli
homepage: dcli.noojee.dev

publish_to: http://your-unpubd-server.com
```

Now when you run `pub publish` for your package it will be published to your unpubd server.

## Added dependencies
If you run dart pub with the PUB_HOSTED_URL or unpub then pub will automatically try to pull  dependencies from unpubd.

However you can also ensure that your package dependencies are always pulled from unpubd by altering the dependency in pubspec.yaml to a 'hosted' dependency.

```yaml
dependencies:
  dcli:
    hosted:
      url: http://your-unpubd-server.com
      version: ˆ1.0.0
```      

This technique is also useful if you are preparing a PR for a public package.
You can first publish it to your unpubd server and test it internally before pushing the PR.

I find this particularly useful while you are waiting for a public package to accept and publish your PR.

# unpubd Commands
unpubd suports a number of commands

## unpubd install
Installs unpubd and the docker containser

## unpubd reset
Deletes the docker containers and volumes.

WARNING: all of you local packages will be deleted.

## unpub up
Starts the unpubd and mongo docker containsers.

## unpub down
Shuts down the unpubd and mongo containers.


# Building
This section is for developers of unpubd.

## prerequisites
* Docker
* docker-compose
* dcli (pub global activate dcli)
* pub_release (pub global activate pub_release)
* critical_test (pub global activate critical_test)

## Release
To create a release of unpubd

```bash
dcli pack
tool/build.dart
pub_release
```

The release process builds and publishes docker images to the Noojee repository (you need to be an admin on the docker hub noojee repo) and publishes the package to pub.dev.

### faster docker builds

When making source code changes that need require a rebuild of you docker images you can use the --clone switch.

```bash
tool\build.dart --clone
```

This command will only re-clone the source from git hub and only rebuild the docker steps required.

If you need to force a full rebuild of the docker container use:

```bash
tool\build.dart --clean
```





