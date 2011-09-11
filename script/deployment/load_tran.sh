if [ "$1" ]
then
  echo ""
else
  echo "Usage: ./load_tran.sh {staging|rc|production}" >&2
  exit 1
fi

cd ~/krugi_trunk/
svn up
cap staging translations:load_latest TARGET=$1
cap $1 deploy:restart
