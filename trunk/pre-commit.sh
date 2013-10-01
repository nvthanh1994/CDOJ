#!/bin/bash
PRE_COMMIT_ERRRO='pre-commit error!'
echo "\x1b[1;31mCheck: no entity used in DTO\x1b[m"
./src/test/python/check_dtos_not_contain_entities.py
if [ $? -ne 0 ]; then
  echo $PRE_COMMIT_ERRRO
  exit 1
fi
echo "\x1b[0;33mCheck: no entity used in DTO\x1b[m"
./src/test/python/check_controller_not_contain_daos.py
if [ $? -ne 0 ]; then
  echo $PRE_COMMIT_ERRRO
  exit 1
fi
echo "\x1b[0;33mrun integration tests\x1b[m"
mvn integration-test
if [ $? -ne 0 ]; then
  echo $PRE_COMMIT_ERRRO
  exit 1
fi
echo "\x1b[1;32mpre-commit successfully, you can use git commit to commit your code\x1b[m"
exit 0

