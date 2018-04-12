# Ruþycross

![](logo.png)

## Current project status

[![Build Status](https://travis-ci.com/valentinp72/picross.svg?token=zWdqvp6jX3Z664qx4QEk&branch=master)](https://travis-ci.com/valentinp72/picross)
[![Maintainability](https://api.codeclimate.com/v1/badges/ccc2c521ed263e2370a0/maintainability)](https://codeclimate.com/repos/5a624aeae596c21745002d54/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/ccc2c521ed263e2370a0/test_coverage)](https://codeclimate.com/repos/5a624aeae596c21745002d54/test_coverage)

## Installation 

```shell
git clone https://github.com/valentinp72/picross.git
# or:
# git clone git@github.com:valentinp72/picross.git

cd picross
gem install bundle
bundle install
```

### macOS installation
- Download the last release [here](https://github.com/valentinp72/picross/releases).
- Open the disk image (.dmg)
- Move the Rubycross application to the Application folder
- You can now play the game (available in the launchpad)

**Known bug**: the application crashes if there is a space character in the path to the application file. [see here](https://github.com/valentinp72/picross/issues/28)

## Documentation
[**Link to generated RDoc**](https://picross.vlntn.pw/doc/)

```
rake doc
```

## Unit tests and tests coverage
```shell
rake tests
```
