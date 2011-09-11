#!/bin/sh

case "$1" in
  --self)
      sudo cat /dev/null
      if [ $? -ne 0 ] ; then exit 1; fi
          export KEEP_ALIVE=1
	  echo "Redeploying RELEASE tag to production: "
	  ;;
  --rc)
      sudo cat /dev/null
      if [ $? -ne 0 ] ; then exit 1; fi
	  echo "Creating RELEASE tag from RC and deploying to production: "
	  cd ~/krugi_trunk
	  cap production kroogi:tag_release
	  ;;
  *)
    echo "Usage: ./release.sh {--rc|--self}" >&2
   	cd
	exit 1
  	;;
esac

cd ~/krugi_trunk

cap production deploy:migrations
echo 'DONE'
cd
