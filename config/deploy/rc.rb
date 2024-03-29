# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :repository, "https://kroogi/svn/krugi/branches/rc"

# =============================================================================
# ROLES
# =============================================================================
role :web, "proxy"
role :app, "web05"
role :db,  "web05", :primary => true
role :sphinx, "cc"
