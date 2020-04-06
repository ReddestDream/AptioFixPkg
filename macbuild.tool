	#!/bin/bash

package() {
  if [ ! -d "$1" ]; then
    echo "Missing package directory"
    exit 1
  fi

  local ver=$(cat Include/Protocol/AptioMemoryFix.h | grep APTIOMEMORYFIX_PROTOCOL_REVISION | cut -f4 -d' ' | cut -f2 -d'"' | grep -E '^[0-9.]+$')
  if [ "$ver" = "" ]; then
    echo "Invalid version $ver"
  fi

  pushd "$1" || exit 1
  rm -rf tmp || exit 1
  mkdir -p tmp/Drivers || exit 1
  mkdir -p tmp/Tools || exit 1
  cp AptioInputFix.efi tmp/Drivers/ || exit 1
  cp AptioMemoryFix.efi tmp/Drivers/ || exit 1
  cp CleanNvram.efi tmp/Tools/ || exit 1
  cp VerifyMsrE2.efi tmp/Tools/ || exit 1
  pushd tmp || exit 1
  zip -qry -FS ../"AptioFix-${ver}-${2}.zip" * || exit 1
  popd || exit 1
  rm -rf tmp || exit 1
  popd || exit 1
}

cd $(dirname "$0")
ARCHS=(X64)
SELFPKG=AptioFixPkg
DEPNAMES=('EfiPkg' 'OpenCorePkg')
DEPURLS=('https://github.com/acidanthera/EfiPkg' 'https://github.com/acidanthera/OpenCorePkg')
DEPBRANCHES=('master' 'master')
src=$(/usr/bin/curl -Lfs https://raw.githubusercontent.com/acidanthera/ocbuild/master/efibuild.sh) && eval "$src" || exit 1