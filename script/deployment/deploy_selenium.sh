#!/bin/sh

# Usage: .deploy_selenium.sh {NOTHING for trunk|--branch branchname}

_write_stage_deploy_file()
{

  REPO=''
  if [ "$1" == "" ]; then
    REPO="https://kroogi/svn/krugi/trunk/src/main/krugi"
  else
    REPO="https://kroogi/svn/krugi/branches/$1"
  fi

  # Use remote_cache if possible, but export if deploying from a different branch
  DEPLOY_VIA=":remote_cache"
  if [ "$1" != "" ]; then
    DEPLOY_VIA=":export"
  fi

  env="selenium"
  echo "" > config/deploy/$env.rb
  echo "# =============================================================================" >> config/deploy/$env.rb
  echo "# REQUIRED VARIABLES" >> config/deploy/$env.rb
  echo "# =============================================================================" >> config/deploy/$env.rb
  echo "set :repository, '$REPO'" >> config/deploy/$env.rb
  echo "" >> config/deploy/$env.rb
  echo "set :deploy_via, $DEPLOY_VIA" >> config/deploy/$env.rb
  echo "# =============================================================================" >> config/deploy/$env.rb
  echo "# ROLES" >> config/deploy/$env.rb
  echo "# =============================================================================" >> config/deploy/$env.rb
  echo 'role :web, "proxy"' >> config/deploy/$env.rb
  echo 'role :app, "cc"' >> config/deploy/$env.rb
  echo 'role :db,  "cc", :primary => true' >> config/deploy/$env.rb
  echo 'role :sphinx, "cc"' >> config/deploy/$env.rb
}


if [ -f ~/seleniuming ]
then
  echo 'Somebody else is deploying ... wait or rm ~/seleniuming file and try again'
  exit
fi

cd ~/krugi_trunk
./latest.sh

case "$1" in
  --branch)
    echo "Deploying from branch $2 to selenium environment: "
    _write_stage_deploy_file "$2"
    ;;
  *)
    echo "Deploying trunk to selenium"
    _write_stage_deploy_file
		;;
esac

touch ~/seleniuming
cap selenium deploy:migrations

echo 'DONE'
rm -f ~/seleniuming
cd


