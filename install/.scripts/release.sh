#!/bin/bash

version=$(node -e "console.log(require('./package.json').version)")

rm -rf _zip

mkdir -p _zip/hydejack-pro-$version/.ssh
cp ~/.ssh/hydejack_8_pro _zip/hydejack-pro-$version/.ssh

mkdir -p _zip/hydejack-pro-$version/install
mkdir -p _zip/hydejack-pro-$version/upgrade

# Make install folder
cp -r \
  $(find . \
    ! -name .git \
    ! -name .sass-cache \
    ! -name .bundle \
    ! -name node_modules \
    ! -name vendor\
    ! -name _zip  \
    ! -name '*.gemspec'  \
    ! -name '*.gem'  \
    ! -name '*~' \
    ! -name '_site*' \
    -mindepth 1 \
    -maxdepth 1) \
  _zip/hydejack-pro-$version/install

# Make upgrade folder
cp -r \
  _includes \
  _layouts \
  _sass \
  assets \
  Gemfile* \
  package* \
  _zip/hydejack-pro-$version/upgrade

rm -r \
  _zip/hydejack-pro-$version/upgrade/assets/icomoon \
  _zip/hydejack-pro-$version/upgrade/assets/icons \
  _zip/hydejack-pro-$version/upgrade/assets/img \
  _zip/hydejack-pro-$version/upgrade/assets/ieconfig.xml \
  _zip/hydejack-pro-$version/upgrade/assets/manifest.json \
  _zip/hydejack-pro-$version/upgrade/assets/resume.json

find _zip/hydejack-pro-$version/upgrade/ -name 'my-*' -delete
find _zip/hydejack-pro-$version/ -name '.DS_Store' -delete

# Generate PDFs.
# This assumes the next version is already online at qwtel.com
# This also assumes macOS with chrome installed...
function pdfprint {
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --headless \
    --disable-gpu \
    --disable-translate \
    --disable-extensions \
    --disable-background-networking \
    --safebrowsing-disable-auto-update \
    --disable-sync \
    --metrics-recording-only \
    --disable-default-apps \
    --no-first-run \
    --mute-audio \
    --hide-scrollbars \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=10000 \
    --print-to-pdf="_zip/hydejack-pro-$version/$1.pdf" $2
}

pdfprint "PRO License" "https://hydejack.com/licenses/PRO/" &
pdfprint "PRO–hy-drawer License" "https://qwtel.com/hy-drawer/licenses/hydejack/" &
pdfprint "PRO–hy-push-state License" "https://qwtel.com/hy-push-state/licenses/hydejack/" &
pdfprint "PRO–hy-img License" "https://qwtel.com/hy-img/licenses/hydejack/" &
pdfprint "Documentation" "https://hydejack.com/docs/print/" &
pdfprint "NOTICE" "https://hydejack.com/NOTICE/" &
pdfprint "CHANGELOG" "https://hydejack.com/CHANGELOG/" &
wait

# Genrate git diffs
# TODO
# git diff pro/v$version pro/v7.5.1 > v$version-to-v7.5.1.diff

# Generate the zip
cd _zip; zip -q -r hydejack-pro-$version.zip hydejack-pro-$version/
