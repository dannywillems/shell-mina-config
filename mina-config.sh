## Mina specific aliases

MINA_ENV_SETUP=0

mina-grep() {
    git grep --recurse-submodules -n $1 -- ':!*.cjs' ':!*.bc.*' ':!*.html' ':!*.min.js'
}

mina-c-m-develop() {
    git merge-tree `git merge-base origin/develop HEAD` HEAD origin/develop | grep -A 25 "^+<<<<<<<"
}

mina-env() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    eval $(opam env)
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
  cd ${OPAM_SWITCH_PREFIX}/..
  dune runtest src/lib
  cd -
}

mina-build() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd ${OPAM_SWITCH_PREFIX}/..
  make build
  cd -
}

## Build specific libraries
snarky-build() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd ${OPAM_SWITCH_PREFIX}/../src/lib/snarky
  dune build
  cd -
}

snarkyjs-bindings-build() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd ${OPAM_SWITCH_PREFIX}/../src/lib/snarkyjs/src/bindings
  npm run bindings
  cd -
}

## Build specific libraries documentation
snarky-doc() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd ${OPAM_SWITCH_PREFIX}/../src/lib/snarky
  dune build @doc
  cd -
}

# Aliases to travel to different projects
## proof-systems
goto-proof-systems() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd ${OPAM_SWITCH_PREFIX}/../src/lib/crypto/proof-systems
}

## snarky
goto-snarky() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd ${OPAM_SWITCH_PREFIX}/../src/lib/snarky
}

## snarkyjs
goto-snarkyjs() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd ${OPAM_SWITCH_PREFIX}/../src/lib/snarkyjs
}

## snarkyjs
goto-snarkyjs-bindings() {
  if [ ${MINA_ENV_SETUP} -ne 1 ]
  then
    mina-env
  fi
  cd ${OPAM_SWITCH_PREFIX}/../src/lib/snarkyjs/src/bindings
}
