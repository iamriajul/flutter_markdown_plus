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

  lcov --remove coverage/lcov.info 'lib/core/data/local_image_data_source' 'lib/utils/image_picker_utils.dart' 'lib/core/domain/repositories/theme_repository.dart' 'lib/features/health/data/datasources/health_local_datasource_impl.dart' 'lib/core/data/repository/secure_storage_impl.dart' 'lib/core/data/repository/remote_config_repository_impl.dart' 'lib/core/data/app_review_wrapper.dart' 'lib/core/data/environment_variables.dart' 'lib/*/*.g.dart' 'lib/*/presentation/*.dart' 'lib/di/*.dart' 'lib/*/models/*.dart' 'lib/*/data/repositories/*.dart' -o coverage/lcov.info
  genhtml -o coverage coverage/lcov.info

  cd -
}

###############################################################################
# INVOKE VERIFICATION FUNCTIONS
###############################################################################
verifyFlutter "."
}
