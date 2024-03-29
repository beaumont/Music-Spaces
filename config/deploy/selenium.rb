# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :repository, "https://kroogi/svn/krugi/trunk/src/main/krugi"

# =============================================================================
# ROLES
# =============================================================================
role :web, "proxy"
role :app, "cc"
role :db,  "cc", :primary => true
role :sphinx, "cc"
