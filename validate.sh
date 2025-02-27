#!/bin/bash
set -e -x # exit on first error

###############################################################################
# VERIFICATION FUNCTION FOR FLUTTER APP/PACKAGES
###############################################################################
verifyFlutter () {
  cd $1
  echo "Checking `pwd`"
  flutter --version
  flutter clean
  flutter pub get
  sh ./scripts/format.sh --set-exit-if-changed
  flutter analyze --no-pub .

  ###############################################################################
  # CODE COVERAGE
  ###############################################################################
  dart pub global activate very_good_cli

  rm -rf coverage
  very_good test --no-optimization --coverage

  cd -
}

###############################################################################
# INVOKE VERIFICATION FUNCTIONS
###############################################################################
verifyFlutter "."
