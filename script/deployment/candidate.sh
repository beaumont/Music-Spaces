#!/bin/sh
if [ -f ~/candidating ]
then
  echo 'Somebody else is deploying ... wait or rm ~/candidating file and try again'
  exit
fi
cd ~/krugi_trunk
./latest.sh

case "$1" in
  --trunk)
	  echo "Creating RC branch from trunk and deploying: "
	  cap rc kroogi:rc_from_trunk
	  ;;
  --self)
	  echo "Deploying RC branch: "
	  ;;
  --tag)
	  echo "Creating RC branch from tag $2 and deploying: "
	  cap rc kroogi:rc_from_tag -s tag=$2
	  ;;
  --branch)
	  echo "Creating RC branch from branch $2 and deploying: "
	  cap rc kroogi:rc_from_branch -s branch=$2
	  ;;
  *)
    echo "Usage: .candidate.sh {--trunk|--self|--tag tagname|--branch branchname}" >&2
   	cd 
	exit 1
  	;;
esac

touch ~/candidating
cap rc deploy:migrations

echo 'DONE'
rm -f ~/candidating
