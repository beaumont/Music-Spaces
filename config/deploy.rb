# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :application, "kroogi"
set :user,        'sasha'
# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set(:deploy_to) {"/mnt/krugi/#{application}/#{stage}/"}  # must be a proc, cause stage is defined late
set(:rails_env) {"#{stage}"}
set :deploy_via, :fast_remote_cache
set :use_sudo, false
set :keep_releases, 2
set :gateway, "dev.kroogi.com"  # default to dev gateway

# =============================================================================
# SSH OPTIONS
# =============================================================================
# add your key path and uncomment this if you get password promt when deploying from local - means cap is having trouble finding right cert
# ssh_options[:keys] = %w(/home/sasha/.ssh/id_dsa /Users/sasha/.ssh/id_dsa)
ssh_options[:paranoid] = false


# Add the path to your ssh key here if running from local
# ssh_options[:keys] = %w(/Users/kali/.ssh/id_kali_dsa /home/sasha/.ssh/id_dsa /mnt/krugi/home/sasha/.ssh/id_dsa)