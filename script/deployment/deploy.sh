#!/bin/sh

# Usage: .deploy.sh {NOTHING for trunk|--branch branchname}

_write_stage_deploy_file()
{

  REPO=''
  if [ "$1" == "" ]; then
    REPO="https://kroogi/svn/krugi/trunk/src/main/krugi"
  else
    REPO="https://kroogi/svn/krugi/branches/$1"
  fi

  # Use remote_cache if possible, but export if deploying from a different branch
  DEPLOY_VIA=":fast_remote_cache"
  if [ "$1" != "" ]; then
    DEPLOY_VIA=":export"
  fi

  echo "" > config/deploy/staging.rb
  echo "# =============================================================================" >> config/deploy/staging.rb
  echo "# REQUIRED VARIABLES" >> config/deploy/staging.rb
  echo "# =============================================================================" >> config/deploy/staging.rb
  echo "set :repository, '$REPO'" >> config/deploy/staging.rb
  echo "" >> config/deploy/staging.rb
  echo "set :deploy_via, $DEPLOY_VIA" >> config/deploy/staging.rb
  echo "# =============================================================================" >> config/deploy/staging.rb
  echo "# ROLES" >> config/deploy/staging.rb
  echo "# =============================================================================" >> config/deploy/staging.rb
  echo 'role :web, "proxy"' >> config/deploy/staging.rb
  echo 'role :app, "web03"' >> config/deploy/staging.rb
  echo 'role :db,  "web03", :primary => true' >> config/deploy/staging.rb
  echo 'role :sphinx, "cc"' >> config/deploy/staging.rb
}


if [ -f ~/deploying ]
then
  echo 'Somebody else is deploying ... wait or rm ~/deploying file and try again'
  exit
fi

cd ~/krugi_trunk
./latest.sh

case "$1" in
  --branch)
    echo "Deploying from branch $2 to staging environment: "
    _write_stage_deploy_file "$2"
    ;;
  *)
    echo "Deploying trunk to stage"
    _write_stage_deploy_file
		;;
esac

touch ~/deploying
cap staging deploy:migrations

echo 'DONE'
mv -f ~/deploying ~/deploying.last
cd


