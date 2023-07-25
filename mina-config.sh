## Mina specific aliases

MINA_ENV_SETUP=0

mina-grep() {
    git grep --recurse-submodules -n $1 -- ':!*.cjs' ':!*.bc.*' ':!*.html' ':!*.min.js'
}

mina-c-m-develop() {
    git merge-tree "$(git merge-base origin/develop HEAD)" HEAD origin/develop | grep -A 25 "^+<<<<<<<"
}

mina-env() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    eval "$(opam env)"
    gvm use go1.18.10
    nvm use v19.3.0
    export MINA_BUILD_DIR=${OPAM_SWITCH_PREFIX}/../_build
    MINA_ENV_SETUP=1
  fi
}

mina-drl() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd "${OPAM_SWITCH_PREFIX}/.." || exit
  dune runtest src/lib
  cd - || exit
}

mina-build() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd "${OPAM_SWITCH_PREFIX}/.." || exit
  make build
  cd - || exi
}

## Build specific libraries
snarky-build() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd "${OPAM_SWITCH_PREFIX}/.." || exit
  dune build
  cd - || exit
}

snarkyjs-bindings-build() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd "${OPAM_SWITCH_PREFIX}/../src/lib/snarkyjs/src/bindings" || exit
  npm run bindings
  cd - || exit
}

## Build specific libraries documentation
snarky-doc() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd "${OPAM_SWITCH_PREFIX}/../src/lib/snarky" || exit
  dune build @doc
  cd - || exit
}

# Aliases to travel to different projects
## proof-systems
goto-proof-systems() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd "${OPAM_SWITCH_PREFIX}/../src/lib/crypto/proof-systems" || exit
}

## snarky
goto-snarky() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd "${OPAM_SWITCH_PREFIX}/../src/lib/snarky" || exit
}

## snarkyjs
goto-snarkyjs() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd "${OPAM_SWITCH_PREFIX}/../src/lib/snarkyjs" || exit
}

## snarkyjs
goto-snarkyjs-bindings() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd "${OPAM_SWITCH_PREFIX}/../src/lib/snarkyjs/src/bindings" || exit
}

snarkyjs-run-test() {
    goto-snarkyjs
    npm run build:node
    TEST_TYPE='Simple integration tests' bash run-ci-tests.sh
    TEST_TYPE='DEX integration tests' bash run-ci-tests.sh
    TEST_TYPE='DEX integration test with proofs' bash run-ci-tests.sh
    TEST_TYPE='Voting integration tests' bash run-ci-tests.sh
    TEST_TYPE='Unit tests' bash run-ci-tests.sh
    TEST_TYPE='Verification Key Regression Check' bash run-ci-tests.sh
    TEST_TYPE='CommonJS test' bash run-ci-tests.sh
}
