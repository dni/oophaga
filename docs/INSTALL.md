# Installation

## Software Requirements

```sh
apt-get install npm phantomjs git mongodb imagemagick graphicsmagick zip
```

On Mac OSX use [Homebrew](http://brew.sh/)
```sh
brew install npm phantomjs git mongodb imagemagick graphicsmagick
```

Install node.js modules
```sh
npm i -g bower grunt-cli coffee-script
```

Make sure mongod process is running, you can start it with mongod


## Setup new Repository and Fork Oophaga
Best pratice is to setup up a new Github Repository, clone it  and add publish-cms as upstream, so you can sync updates from publish-cms.
```sh
git clone https://github.com/dni/mynewrepository
cd mynewrepository
git remote add upstream https://github.com/dni/oophaga
git fetch upstream
git checkout master
git merge upstream/master
```

## Updating publish
If your project is setted up right as a fork
```sh
git fetch upstream
git checkout master
git merge upstream/master
```

## Contribute back to publish
First commit all feature you want to contribute and use the SHA hash of the commit to your master branch
```sh
git checkout upstream
git cherry-pick <SHA hash of commit>
git push upstream upstream:master
git checkout master
```

## Install App
To Install the application just type the following
```sh
npm i
```
requirejs:cms can take a while

## Configuration
You can specify your database name and production port in this [config](configuration.json)
