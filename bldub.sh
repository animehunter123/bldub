#!/bin/bash

# Description: Bash Script to build a Dev Ubuntu Coding Host with DockerCE/Ansible, as well as... 3 containers for testing anything via a bash menu!!!!!!!!!
# Source: https://github.dev/animehunter123/bldub

# TODO - I want a lxc build docker01, with dockerce ready to go... 
# TODO there is another problem, i noticed if you do lxd init, it will say job systemd-networkd-wait-online on a reboot, i need to FORCE ERASE THIS
# TODO Make a GuiDevApps Menu for VSCode and Meteor + Lazyvim, @@AND@@ prompt which USER to run these installs as, and that way they arent root!!
# TODO I need to make PORTABLE VSCODE HERE, then chmod and allow ANYONE TO USE IT!!! <---------------- - -- -this is cool idea
# TODO: Curl docker01:5000 as user lmadmin NOT WORKING B/c ETC HOSTS, but IT WORKS AS ROOT WHY!?!?!?
# TODO: Sometimes ub01/ub02 changes ip addresses after reboot, how do i cronjob or fix this?
# TODO: I NEED TO MAKE SUDO PASSWORDLESS 
# TODO: Need Neovim + Lazyvim
# TODO: Need to pin Brave/VSCode/Terminator/Kate to your KDE panel at the bottom of the screen, desktop shortcut atm is OK
# todo allow running the script multiple times without breaking .bashrc and fishrc
# todo add a check if lxd init isnt done, do it before launching ub01lxc

# Exit if not root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

echo "
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
This script makes the kubuntu host a docker_or_lxd server with ansible cli ready to go. 
(NOTE THIS REQUIRES: UBUNTU >=2404 FLAVOR + SNAPD (VSCode/Brave) if you want)
- Read the menu below carefully!!! (Launching: ~~MAIN MENU~~ in bash code.)
- Follow the prompts and watch your shell, i.e. lightdm/sddm install prompts etc.
- Make sure you DO NOT HAVE /mnt/hgfs mounted for step1 (OS Prep)
- Remember that MAC OS will GET HOT so ENABLE SLEEP AFTER 20 MIN OF IDLE OR SHUTDOWN IN THE VM??????????????????CMD W in UTM FTW!
- NOTE I DISABLED: /mnt/hgfs b/c sometimes uses 100% cpu, so this should be optional
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
"

run_build_development_environment() {
    echo "Building the Host OS Dev Environment with Docker CE and Ansible..."

    read -p "READ THE FOLLOWING CAREFULLY
    * This will update and install YOUR HOST 
    * You may need to answer prompts, or ctrl+C and restart this script as needed. 
    * VERY IMPORTANT ====> Make sure you DO NOT HAVE /mnt/hgfs VMWARE SHARED DATA ===> WE WILL FORCE UNMOUNT IT NOW JUST IN CASE SO REBOOT AFTER THIS COMMAND!!!!!!!!!!!
    mounted for step1 (OS Prep) !!!!!!!!!!!!!!!!

    PRESS ENTER TO CONTINUE or CTRL C TO QUIT"

    # Begin of Setup for docker host, ansible, and terminator/vscode/byobu.
    echo "OK: Starting to prepare the DEVELOPMENT ENVIRONMENT CONFIGURATION for this HOST..."

    # VERBOS INSTALLS: Install a package but with normal prompt wizards. (So that I can get this prompt over with faster)
    sudo DEBIAN_FRONTEND=noninteractive apt install -y iperf3

    echo "SNAP: Installing vscode via snap/snapd!!!"
    snap install code --classic


    # TODO THIS WONT WORK< I NEED TO USE A PORTABLE ZIP FILE AND ALLOW IT FOR EVERY USER 
    # vscode_extension_list="vscodevim.vim aaron-bond.better-comments ahmadawais.shades-of-purple akamud.vscode-theme-onedark anbuselvanrocky.bootstrap5-vscode arcticicestudio.nord-visual-studio-code azemoh.one-monokai batisteo.vscode-django bwildeman.tabulous christian-kohler.path-intellisense cstrap.flask-snippets danielpinto8zz6.c-cpp-compile-run daylerees.rainglow dracula-theme.theme-dracula dracula-theme.theme-dracula eamodio.gitlens emmanuelbeziat.vscode-great-icons enkia.tokyo-night esbenp.prettier-vscode file-icons.file-icons formulahendry.code-runner gep13.chocolatey-vscode github.github-vscode-theme grapecity.gc-excelviewer hoovercj.vscode-power-mode idleberg.hopscotch johnpapa.winteriscoming jolaleye.horizon-theme-vscode jprestidge.theme-material-theme Kelvin.vscode-sshfs Kipjr.vscode-language-ipxe liviuschera.noctis magicstack.magicpython mariorodeghiero.vue-theme mechatroner.rainbow-csv monokai.theme-monokai-pro-vscode ms-azuretools.vscode-docker MS-CEINTL.vscode-language-pack-ja ms-edgedevtools.vscode-edge-devtools ms-mssql.mssql ms-python.python ms-python.vscode-pylance ms-python.vscode-pylance ms-toolsai.jupyter ms-vscode-remote.remote-ssh-edit ms-vscode-remote.remote-ssh ms-vscode-remote.remote-wsl ms-vscode-remote.vscode-remote-extensionpack ms-vscode.cpptools-extension-pack ms-vscode.cpptools ms-vscode.hexeditor ms-vscode.hexeditor ms-vscode.powershell noxiz.jinja-snippets pdconsec.vscode-print pkief.material-icon-theme Remisa.shellman ritwickdey.LiveServer robbowen.synthwave-vscode sdras.night-owl swyphcosmo.spellchecker teabyii.ayu thekalinga.bootstrap4-vscode tommasov.hosts vangware.dark-plus-material vscjava.vscode-java-pack vscode-icons-team.vscode-icons wesbos.theme-cobalt2 whizkydee.material-palenight-theme wholroyd.jinja wraith13.unsaved-files-vscode wyattferguson.jinja2-snippet-kit zhuangtongfa.material-theme ms-python.autopep8 sainnhe.gruvbox-material RoweWilsonFrederiskHolme.wikitext ms-vscode.makefile-tools mark-wiemer.vscode-autohotkey-plus-plus eliostruyf.vscode-hide-comments hediet.vscode-drawio rangav.vscode-thunder-client Postman.postman-for-vscode rjmacarthy.twinny alefragnani.Bookmarks oderwat.indent-rainbow johnpapa.vscode-peacock ms-vscode.live-server tomoki1207.pdf vscode-org-mode.org-mode"
    # IFS=' ' read -ra extensions <<< "$vscode_extension_list"
    # VSCODE_DATA='/VSCODE-DATA'
    # mkdir $VSCODE_DATA
    # for extension in "${extensions[@]}"
    # do
    #     echo "Installing $extension..."
    #     code --install-extension "$extension" --no-sandbox --user-data-dir $VSCODE_DATA
    #     # code --install-extension "$extension"
    # done
    # echo "@@@ DISABLING VIM MODE IN VSCODE!!!"
    # code --disable-extension vscodevim.vim    --no-sandbox --user-data-dir $VSCODE_DATA
    # chmod 777 -R $VSCODE_DATA
    # echo "All VSCode extensions have been installed. (ALIAS WILL BE ADDED AT THE END)"


    snap install brave #Webdev most def.

    #Just in case mlocate3/locate is still trying to index your MOUNTPOINTS
    umount /mnt/hgfs 2>/dev/null 1>/dev/null
    dpkg --configure -a

    echo "SNAP: Installing lxd because it just rocks (without running 'lxd init')"
    snap install lxd

    # export DEBIAN_FRONTEND=noninteractive # I DISABLED THIS TO ENSURE THAT YOU FOLLOW THE PROMPTS!!!!!!!!!!!
    export ACCEPT_EULA=Y

    # yes | NEEDRESTART_MODE=a DEBIAN_FRONTEND=noninteractive apt remove -y needrestart
    yes | NEEDRESTART_MODE=a apt remove -y needrestart

    # Pre-seed Postfix configuration (To prevent Kub2404 from prompting for the Postfix options during upgrade)
    echo "postfix postfix/main_mailer_type select No configuration" | debconf-set-selections
    echo "postfix postfix/mailname string $(hostname -f)" | debconf-set-selections
    # DEBIAN_FRONTEND=noninteractive apt-get remove -y needrestart
    apt-get remove -y needrestart
    apt-get update -y
    apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

    # yes | DEBIAN_FRONTEND=noninteractive apt-get update -y --fix-missing
    yes | apt-get update -y --fix-missing
    # yes | DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
    yes | apt-get upgrade -y

    # Wireshark ignoring the prompt, workaround
    sudo echo wireshark-common wireshark-common/install-setuid boolean true | sudo debconf-set-selections
    # sudo DEBIAN_FRONTEND=noninteractive apt-get install --force-confold -y wireshark-common
    sudo apt-get install --force-confold -y wireshark-common

    # SILENT INSTALLS: Create the list of packages
    packages=(
        vim vim-gtk3 python3-pip p7zip-full ansible apt-utils arping baobab build-essential byobu bzip2
        cifs-utils cmake cockpit curl dos2unix emacs expect ffmpeg findutils firefox ftp g++ gcc git
        glances gparted gzip gpg htop iotop k3b krdc less logrotate lshw lsof make meld
        mlocate mtr mysql-client nano ncdu neofetch net-tools nethogs nfs-common nfs-kernel-server nginx
        nmap open-vm-tools open-vm-tools-desktop openssh-server partitionmanager pssh python-is-python3 python3-pip python3-venv qdirstat kate
        remmina rsync sed ssh sshfs sudo tcpdump telnet terminator timeshift tshark tcpdump usb-creator-gtk
        wget whois wireshark xclip xz-utils rofi locate docker-compose 
    )

    # Iterate through the list and install each package (Future proofing this script in case pknames chnge)
    for package in "${packages[@]}"; do
        echo "Installing $package..."
        # yes | NEEDRESTART_MODE=a DEBIAN_FRONTEND=noninteractive sudo apt install -y --fix-missing "$package" || echo "Failed to install $package"
        NEEDRESTART_MODE=a sudo apt install -y --fix-missing "$package" || echo "Failed to install $package"
    done





    echo "%%% PHASE 1 ROOT IS GETTING METEOR/NPX/NODEJS via FNM.... %%%%"
#    curl -fsSL https://fnm.vercel.app/install | bash
#    source ~/.bashrc
#    source /root/.config/fish/conf.d/fnm.fish
    #fnm install --lts
#    /root/.local/share/fnm/fnm install --lts

apt install -y npm nodejs


    rm -rf .meteor
    # npx -y meteor
    bash -c 'SUDO_USER="" npx -y meteor'
    export PATH=/root/.meteor:$PATH
    set PATH=/root/.meteor:$PATH
    echo "Finished running commands as root"






    # RUN A SET OF COMMANDS FOR EACH USER
    echo "%%% PHASE 2 EACH_USER IS GETTING METEOR/NPX/NODEJS via FNM.... %%%%"
    run_commands_for_user() {
        local user=$1
        local home_dir=$2
        echo "Running commands for user: $user"
        # Run commands as the user
    su - $user << EOF
    USER=`whoami`
rm -rf /home/$user/.local/share/fnm
sed -i 's/^# fnm.*¥n.*¥n.*¥nfi$//' /home/$user/.bashrc
rm -f /home/$user/.bash_profile

cd
rm -rf .meteor

#bash -c 'SUDO_USER="" npx -y meteor'
#source /home/$user/.bashrc || shift || SUDO_USER="" npx -y meteor
bash -c 'SUDO_USER="" npx -y meteor'

#export PATH=/home/$user/.meteor:$PATH
#set PATH=/home/$user/.meteor:$PATH
#echo "export PATH=~/.meteor:$user" >> ~/.bashrc && echo "fish_add_path ~/.meteor" >> ~/.config/fish/config.fish
EOF
        new_password="P@ssw0rd"
        set new_password P@ssw0rd
        echo Launching... "$user:$new_password" 
        echo "$user:$new_password" | chpasswd
        echo "Finished running commands for user: $user"
        echo "----------------------------------------"
    }   
    for user_home in /home/*; do
        if [ -d "$user_home" ]; then
            user=$(basename "$user_home")
            run_commands_for_user $user $user_home
            echo OK RUNNING chown -R $user:$user /home/$user 
            chown -R $user:$user /home/$user 2>/dev/null
        fi
    done






# NOW THAT FNM/NPX/NODEJS AND METEOR FINISHE INSTALLING, ITS SAFE TO INSTALL FISH!!
apt install -y fish






    # Allow VMWARE TOOLS to work with KUBUNTU 2404 and onwards to show /mnt/hgfs correctly
    mkdir /mnt/hgfs
    # sudo vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other -o uid=1000

    # Now, lets install DOCKER CE (USING OFFICIAL DOCS)
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

    sudo apt-get -y install ca-certificates curl
    sudo install -y -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker

    # Pip Installs for Flask Coding Projects
    yes | sudo apt install -y sqlite3
    pip3 install requests autopep8 flask flask_sqlalchemy flask_admin flask_cors wtforms flask_migrate flask_wtf flask_socketio flask_login virtualenv email_validator --break-system-packages

    #Install my plotly/dash stuff
    pip3 install plotly numpy pandas dash --break-system-packages

    #Install the best python3 repl command line i think. Latest python no worky on: setuptools-rust docker-compose
    pip3 install ipython --break-system-packages

    # The next thing is very common if you ANSIBLE from UB2204 to CONTROL a UB2404! The error
    # will be like: ModuleNotFoundError: No module named 'ansible.module_utils.six.moves', So we...:
    pip install --upgrade ansible



    # Fish Shell Disable Greeting
    printf '\n\nset fish_greeting ""' >>/etc/fish/config.fish
    chsh -s /usr/bin/fish
    echo "Step: run_build_development_environment completed successfully!"

    # Setup SSHD PERFECTLY
cat <<EOF >> /etc/ssh/sshd_config
# @@ baselineUbContainer DOCKER SPECIFIC SECTION @@
PasswordAuthentication yes
PermitRootLogin yes
UsePAM no
UseDNS no
#NOTE UNCOMMENT THE BELOW IF YOU WANT VSCODE TO SSH IN (AND COMMENT THE ABOVE ORIGINAL)
#Subsystem sftp internal-sftp
# @@ END baselineUbContainer DOCKER SPECIFIC SECTION @@
EOF
systemctl restart ssh
new_password="P@ssw0rd"
echo "root:$new_password" | chpasswd


    # DISABLE SSH WARNING FOR "THIS HOST CHANGED" and "THiS IS THE FIRST TIME TO CONNECT"
    SSH_CONFIG="$HOME/.ssh/config"
    # Create the .ssh directory if it doesn't exist
    mkdir -p "$HOME/.ssh" 2>/dev/null 1>/dev/null
    # Check if the config file exists, create it if not
    touch "$SSH_CONFIG"
    # Add the configuration if it doesn't already exist
    # if ! grep -q "Host 10.199.179.*" "$SSH_CONFIG"; then
    cat <<EOF >>"$SSH_CONFIG"
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
    echo "Configuration added to $SSH_CONFIG"
    # Set appropriate permissions
    chmod 600 "$SSH_CONFIG"

    echo "Generating/SSH KEY..."
    # SSH key path
    ssh_key_path="$HOME/.ssh/id_rsa"
    # Generate SSH key if it doesn't exist
    if [ ! -f "$ssh_key_path" ]; then
        echo "Generating new SSH key..."
        ssh-keygen -t rsa -b 4096 -f "$ssh_key_path" -N ""
    else
        echo "SSH key already exists."
    fi

    echo "Adding NOPASSWD: to everyone in sudoers/sudoers.d"
    sed -i 's/ ALL$/ NOPASSWD: ALL/' /etc/sudoers
    sed -i 's/ ALL$/ NOPASSWD: ALL/' /etc/sudoers.d/*

    # To fix sudo -i from hanging on the host
    printf '\n # To fix sudo -i from hanging on the host. ;\nDefaults !fqdn\n\n' >> /etc/sudoers

    # Add VMware Wkstn Host of /mnt/hgfs (since open-vm-tools and open-vm-tools-desktop didnt have it)
    # (crontab -l 2>/dev/null; echo "@reboot sudo vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other -o uid=1000") | crontab -    

    # Ensure that /etc/hosts has localhost IN IT AT THE TOP OF THE FILE
    HOSTS_FILE="/etc/hosts"
    TEMP_FILE="/tmp/hosts_temp"
    ESSENTIAL_ENTRIES=(
        "127.0.0.1\tlocalhost"
        "::1\tlocalhost ip6-localhost ip6-loopback"
        "fe00::0\tip6-localnet"
        "ff00::0\tip6-mcastprefix"
        "ff02::1\tip6-allnodes"
        "ff02::2\tip6-allrouters"
    )
    touch "$TEMP_FILE"
    for entry in "${ESSENTIAL_ENTRIES[@]}"; do
        echo -e "$entry" >> "$TEMP_FILE"
    done
    # Append existing entries from /etc/hosts, excluding the essential ones
    grep -vE "^(127\.0\.0\.1|::1|fe00::0|ff00::0|ff02::1|ff02::2)" "$HOSTS_FILE" >> "$TEMP_FILE"
    mv "$TEMP_FILE" "$HOSTS_FILE"
    chmod 777 /etc/hosts

    # bash script, for every username found in /home/*, chsh -s that user to fish as the default shell
    # Get the path to fish shell
    FISH_PATH=$(which fish)
    # Check if fish is in /etc/shells
    if ! grep -q "^$FISH_PATH$" /etc/shells; then
        echo "Adding $FISH_PATH to /etc/shells"
        echo "$FISH_PATH" >> /etc/shells
    fi

    # for every user in /home/* // Add them to the docker and lxd groups
    add_user_to_group() {
        local username="$1"
        local groupname="$2"
        if getent group "$groupname" > /dev/null; then
            if ! groups "$username" | grep -q "\b$groupname\b"; then
                usermod -aG "$groupname" "$username"
                echo "Added $username to $groupname group"
            else
                echo "$username is already in $groupname group"
            fi
        else
            echo "Group $groupname does not exist"
        fi
    }
    for USER_HOME in /home/*; do
        USERNAME=$(basename "$USER_HOME")
        if [ -d "$USER_HOME" ]; then
            echo "Processing user: $USERNAME"
            # Add user to docker group
            add_user_to_group "$USERNAME" "docker"
            # Add user to lxd group
            add_user_to_group "$USERNAME" "lxd"
            echo "-------------------"
        fi
    done

    # ensure that the system fish config has 'lxc' aliased to 'sudo lxc' and the same for 'sudo docker
    printf 'alias lxc "sudo lxc"\n' >> /etc/fish/config.fish
    printf 'alias lxcl "sudo lxc list -c nst4sS"\n' >> /etc/fish/config.fish  #This is a nice shorthand!
    printf 'alias docker "sudo docker"\n' >> /etc/fish/config.fish
    printf 'echo PS Grepping for lxc running containers...\n' >> /etc/fish/config.fish
    printf 'ps -efawww|grep -i "lxc mon" | sed "s/.*containers /container running: /" | grep -v " grep "\n' >> /etc/fish/config.fish
    
    # printf 'echo Launching: lxc list -c nst4sS\n' >> /etc/fish/config.fish
    # printf 'lxc list -c nst4sS\n' >> /etc/fish/config.fish

    # FISH_CONFIG="/etc/fish/config.fish"
    # add_or_update_alias() {
    #     local alias_name="$1"
    #     local alias_command="$2"
    #     if grep -q "alias $alias_name" "$FISH_CONFIG"; then
    #         sed -i "s|alias $alias_name.*|alias $alias_name '$alias_command'|" "$FISH_CONFIG"
    #         echo "Updated alias: $alias_name"
    #     else
    #         echo "alias $alias_name '$alias_command'" >> "$FISH_CONFIG"
    #         echo "Added new alias: $alias_name"
    #     fi
    # }
    # touch "$FISH_CONFIG"
    # add_or_update_alias "lxc" "sudo lxc"
    # add_or_update_alias "docker" "sudo docker"

    # Add Shortcuts to desktop
    # for i in /home/* ; do echo $i ;  pushd . ; cd $i/Desktop ; locate -i brave | grep "brave\.desktop$" | sort | tail -n 1 | xargs ln -s ; chmod 777 brave.desktop ; popd ;   done
    # for i in /home/* ; do echo $i ;  pushd . ; cd $i/Desktop ; locate -i terminator | grep "terminator\.desktop$" | sort | tail -n 1 | xargs ln -s ; chmod 777 terminator.desktop ; popd ;   done
    # for i in /home/* ; do echo $i ;  pushd . ; cd $i/Desktop ; locate -i kate | grep "kate\.desktop$" | sort | tail -n 1 | xargs ln -s ; chmod 777 kate.desktop ; popd ;   done
    # for i in /home/* ; do echo $i ;  pushd . ; cd $i/Desktop ; locate -i code | grep "code\.desktop$" | sort | tail -n 1 | xargs ln -s ; chmod 777 code.desktop ; popd ;   done
    for i in /home/*; do
        echo $i
        pushd .
        cd $i/Desktop
        for app in brave terminator kate code; do
            locate -i $app | grep "${app}\.desktop$" | sort | tail -n 1 | xargs ln -s
        done
        popd
    done


    # SET THE FISH PROMPT TO A NONSTANDARD SO I KNOW IM SSHd into it, non default
    # Function to generate a random, readable color
    generate_readable_color() {
        # Use brighter colors (181-255) for better readability on dark backgrounds
        echo $((RANDOM % 75 + 181))
    }
    # Function to create or update Fish config with a random color
    update_fish_config() {
        local config_dir="$1/.config/fish"
        local config_file="$config_dir/config.fish"
        # Generate random colors
        local user_color=$(generate_readable_color)
        local host_color=$(generate_readable_color)
        local pwd_color=$(generate_readable_color)
        local prompt_color=$(generate_readable_color)
        # Create config directory if it doesn't exist
        mkdir -p "$config_dir"
        # Backup existing config if it exists
        if [ -f "$config_file" ]; then
            cp "$config_file" "${config_file}.backup"
        fi
        # Write new Fish configuration
        cat << EOF > "$config_file"
function fish_prompt
    set_color $user_color
    echo -n (whoami)
    set_color normal
    echo -n "@"
    set_color $host_color
    echo -n (hostname)
    set_color normal
    echo -n ":"
    set_color $pwd_color
    echo -n (prompt_pwd)
    set_color $prompt_color
    echo -n " > "
    set_color normal
end
EOF
        echo "Updated Fish config for $(basename "$1") with random colors"
    }
    # Update root's Fish config
    update_fish_config "/root"
    # Update Fish config for all users with a home directory
    for user_home in /home/*; do
        if [ -d "$user_home" ]; then
            update_fish_config "$user_home"
        fi
    done
    echo "Fish configuration update complete with random colors for each user."




    # Now finally, lets add the meteor configuration from bashrc to fishrc FOR ROOT
    for i in /home/* ; do
        username=$(echo $i | sed 's/\/home\///'  )
        su - $username -c grep 'meteor' .bashrc | sed 's/export PATH=/set PATH /' >> $user_home/.config/fish/config.fish 
    done
    echo 'set PATH /home/kenshin/.meteor:$PATH' >> /home/kenshin/.config/fish/config.fish
    # Now do it for root #TODO Still not working for root but idgaf atm.
    grep 'meteor' .bashrc | sed 's/export PATH=/set PATH /' >> /root/.config/fish/config.fish 2>/dev/null 1>/dev/null













    # FINALLY Loop through all directories in /home, set to FISH, AND CHOWN FIX ANY BUGS
    FISH_PATH="`which fish`"
    for USER_HOME in /home/*; do
        # Get the username from the directory name
        USERNAME=$(basename "$USER_HOME")
        # Check if it's a directory and not a file
        if [ -d "$USER_HOME" ]; then
            echo "Changing default shell to fish for user: $USERNAME"
            chsh -s "$FISH_PATH" "$USERNAME"
            chown -R $USERNAME:$USERNAME /home/$USERNAME
        fi
    done
    sed -i 's/set fish_greeting ""alias lxc "sudo lxc"/set fish_greeting ""/' /etc/fish/config.fish

    updatedb &
} # END OF run_build_development_environment







run_build_docker_ub2404_baseline() {
    echo "Building the docker container for ub2404 VIA INTERNET and tagging it..."

    echo "Now lets build a docker ubuntu template to use for our testing..."
    bash_command="echo hiiiiiiiiiiiii ; ls -l /"
    docker rm -f baselineUbContainer
    docker run --name baselineUbContainer -h baselineUbContainer -dit ubuntu:latest
    docker exec -it baselineUbContainer bash -c "$bash_command"

    echo "At this point baselineUbContainer is running, can echo to the screen and ls -l /; worked ok! Lets now launch the master script."
    baselineUbContainer_baseline_cmd='
#############################
#Install all Baseline Apps
#############################
export DEBIAN_FRONTEND=noninteractive
export ACCEPT_EULA="y"

apt update
yes | unminimize            # For `man curl` to work correctly

# Note "7zip" package is only in UB2404, not ub2004. Same for mlocate3=>locate
packages=(
  7zip lsof byobu curl cifs-utils fish glances htop inetutils-ftp 
  inetutils-traceroute inetutils-telnet iputils-arping iputils-ping 
  iputils-tracepath locate net-tools nfs-common nmap man-db 
  openssh-client-ssh1 openssh-client openssh-server procps python3-pip 
  p7zip p7zip-full p7zip-rar python3-virtualenv samba smbclient tcpdump 
  ufw vim wget unzip git ssh whois iotop nethogs python-is-python3 sudo
)

for package in "${packages[@]}"; do
  apt install -y "$package"
done

apt-get install -y --no-install-recommends systemd systemd-sysv dbus dbus-user-session

#############################
#Setup the sshd/rc files...
#############################
cat <<EOF >> /etc/ssh/sshd_config
# @@ baselineUbContainer DOCKER SPECIFIC SECTION @@
PasswordAuthentication yes
PermitRootLogin yes
UsePAM no
UseDNS no
#NOTE UNCOMMENT THE BELOW IF YOU WANT VSCODE TO SSH IN (AND COMMENT THE ABOVE ORIGINAL)
#Subsystem sftp internal-sftp
# @@ END baselineUbContainer DOCKER SPECIFIC SECTION @@
EOF

mkdir -p /run/sshd
cat <<EOF >> /root/.bashrc
pkill sshd &>/dev/null
/usr/sbin/sshd -D &>/dev/null &
EOF

mkdir -p /root/.config/fish/
touch /root/.config/fish/config.fish
cat <<EOF >> /root/.config/fish/config.fish
echo "This is UB2404.... and httpserver is built in (non-pip)...: python3 -m http.server"
echo "...you dont need to pip install it"
EOF

cat <<EOF >> /etc/bash.bashrc
#MY WELCOME SCREEN
#echo "This is UB2404.... and httpserver is built in (non-pip)...: python3 -m http.server"
#echo "NOTE: Restarting /usr/sbin/sshd -D (which requires /run/sshd to exist)..."

export HISTSIZE=9999999
sh -c "pkill sshd &>/dev/null"     &
mkdir /run/sshd &>/dev/null    
sh -c "/usr/sbin/sshd -D &>/dev/null"     &

#echo "Todo goals for this container... how to do mount -t nfs blah... it didnt work with TrueNAS Scale"
EOF

#############################
#Final tweaks...
#############################
# Set the new password
new_password="P@ssw0rd"
# Use chpasswd to change the root password
echo "root:$new_password" | chpasswd


mkdir /run/sshd &>/dev/null    
#chsh -s /usr/bin/fish &>/dev/null   # Commented out so that I can SCP into docker.

exit
'

    docker exec -it baselineUbContainer bash -c "$baselineUbContainer_baseline_cmd"

    echo "OK so now we basically are going to...
docker commit ub01
docker images (to get the new id, example is  eeb1301ee626)
docker tag eeb1301ee626 ub2404  (to tag it)
"
    CONTAINER_NAME='baselineUbContainer'
    NEW_IMAGE_NAME="ub2404"

    echo "Ensuring container $CONTAINER_NAME is running..."
    docker start $CONTAINER_NAME

    echo "Committing changes from $CONTAINER_NAME to new image $NEW_IMAGE_NAME:latest..."
    docker commit $CONTAINER_NAME $NEW_IMAGE_NAME:latest

    echo "Listing new image..."
    docker images | grep $NEW_IMAGE_NAME

    # I DECIDED TO LEAVE THIS SO THAT I CAN DEBUG THE BASELINE LATER
    echo "Removing the original template... baselineUbContainer"
    docker rm -f baselineUbContainer

    echo "Setup of baselineUbContainer BASELINE CONTAINER of root/P@ is... complete!"
    echo "Step: run_build_docker_ub2404_baseline completed successfully!"

} # END OF  run_build_docker_ub2404_baseline

# #TODO need to have ability for 3 more etc read -p, and use num_ubuntu_containers everywhere
run_launch_3_ubuntu_containers() {
    echo "Removing ub01/ub02/ub03 and launching 3 new ones!"

    echo "Ok starting ub01/ub02/ub03 from the new container image called $NEW_IMAGE_NAME..."

    # Number of containers to start
    num_ubuntu_containers=3
    # Image name to use
    image_name="ub2404"
    # Hostname prefix
    hostname_prefix="ub"

    # SETUP MYYYYYYY Make a dev_network
    docker network create --subnet=172.16.99.0/24 dev_network 2>/dev/null

    # Ensure that live-restore to keep the same IP address is installed
    DAEMON_JSON="/etc/docker/daemon.json"
    # Function to check if jq is installed
    check_jq() {
        if ! command -v jq &>/dev/null; then
            echo "jq is not installed. Installing..."
            sudo apt-get update && sudo apt-get install -y jq
        fi
    }
    check_jq
    if [ ! -f "$DAEMON_JSON" ]; then
        echo "Creating $DAEMON_JSON with live-restore enabled"
        echo '{"live-restore": true}' | sudo tee "$DAEMON_JSON" >/dev/null
    else
        if jq -e '.["live-restore"]' "$DAEMON_JSON" >/dev/null 2>&1; then
            echo "live-restore is already set in $DAEMON_JSON"
            if [ "$(jq -r '.["live-restore"]' "$DAEMON_JSON")" != "true" ]; then
                echo "Updating live-restore to true"
                sudo jq '.["live-restore"] = true' "$DAEMON_JSON" >"$DAEMON_JSON.tmp" && sudo mv "$DAEMON_JSON.tmp" "$DAEMON_JSON"
            fi
        else
            echo "Adding live-restore to $DAEMON_JSON"
            sudo jq '. + {"live-restore": true}' "$DAEMON_JSON" >"$DAEMON_JSON.tmp" && sudo mv "$DAEMON_JSON.tmp" "$DAEMON_JSON"
        fi
    fi
    sudo systemctl reload docker
    echo "Docker daemon configuration updated successfully"

    # Loop to start containers
    for i in $(seq 1 $num_ubuntu_containers); do
        # Create hostname (ub01, ub02, ub03)
        hostname="${hostname_prefix}0${i}"
        echo "Starting fresh new container... ${hostname}"
        # Stop container if it exists
        docker stop ${hostname} >/dev/null 2>&1
        # Remove container if it exists
        docker rm -f ${hostname} >/dev/null 2>&1
        # Start new container
        # docker run -d -t -h ${hostname} --name ${hostname} ${image_name} >/dev/null 2>&1
        # docker run -dit --network my_network --ip 172.18.0.2 your_image
        # docker run -d -t -h ${hostname} --name ${hostname} --restart=always ${image_name} >/dev/null 2>&1

        echo launching.... docker run -d -t -h ${hostname} --name ${hostname} --network dev_network --ip 172.16.99.$(($i + 100)) --restart=always ${image_name}
        docker run -d -t -h ${hostname} --name ${hostname} --network dev_network --ip 172.16.99.$(($i + 100)) --restart=always ${image_name} >/dev/null #2>&1
        if [ $? -eq 0 ]; then
            echo "Container ${hostname} started successfully."
        else
            echo "Failed to start container ${hostname}."
        fi
    done

    echo "All ub01/ub02/ub03 containers with root/P@ started."
    for i in $(seq 1 $num_ubuntu_containers); do
        printf "ub0$i = $(docker inspect ub0$i | grep IPAddress | grep -v SecondaryIPAddresses | sed 's/.* //' | uniq | sed 's/,$//')\n"
    done

    echo "Adding the ub01/ub02/ub03 to /etc/hosts now..."

    # Temporary file for hosts
    temp_hosts="/tmp/hosts.new"
    # Copy current hosts file to temp file
    cp /etc/hosts $temp_hosts
    # Function to update hosts file
    update_hosts() {
        local hostname=$1
        local ip=$2
        # Remove existing entry if it exists
        sed -i "/ $hostname$/d" $temp_hosts
        # Add new entry
        echo "$ip $hostname" >>$temp_hosts
    }
    echo "Updating /etc/hosts with container IP addresses..."
    for i in $(seq 1 $num_ubuntu_containers); do
        hostname="ub0$i"
        # Get container IP
        ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $hostname)
        if [ -n "$ip" ]; then
            update_hosts $hostname $ip
            echo "Updated $hostname with IP $ip"
        else
            echo "Failed to get IP for $hostname"
        fi
    done
    # Replace /etc/hosts with our updated version
    sudo mv $temp_hosts /etc/hosts
    echo "Finished updating /etc/hosts"
    # Display the updated entries
    echo "Updated entries in /etc/hosts:"
    grep "ub0" /etc/hosts
    chmod 777 /etc/hosts


    # Get the public key content
    public_key=$(cat "${ssh_key_path}.pub")
    # Function to add SSH key to a container
    add_ssh_key_to_container() {
        local container_name=$1
        echo "Adding SSH key to $container_name..."
        # Ensure .ssh directory exists and has correct permissions
        docker exec $container_name mkdir -p /root/.ssh
        docker exec $container_name chmod 700 /root/.ssh
        # Add the public key to authorized_keys
        echo "$public_key" | docker exec -i $container_name tee -a /root/.ssh/authorized_keys >/dev/null
        # Set correct permissions for authorized_keys
        docker exec $container_name chmod 600 /root/.ssh/authorized_keys
        echo "SSH key added to $container_name"
    }

    # Add SSH key to each container
    for i in $(seq 1 $num_ubuntu_containers); do
        container_name="ub0$i"
        add_ssh_key_to_container $container_name
    done

    echo "SSH key has been added to all containers."

    echo "Next, this script.... removes existing fingerprints for ub01, ub02, and ub03 from ~/.ssh/known_hosts, and then adds them back to avoid future prompts"

    # Function to remove existing fingerprints
    remove_fingerprints() {
        for i in {1..3}; do
            ssh-keygen -R "ub0$i" 2>/dev/null
            ssh-keygen -R "$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ub0$i)" 2>/dev/null
        done
        echo "Removed existing fingerprints for ub01, ub02, and ub03"
    }
    # Function to add new fingerprints
    add_fingerprints() {
        for i in {1..3}; do
            container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ub0$i)
            ssh-keyscan -H "ub0$i" >>~/.ssh/known_hosts 2>/dev/null
            ssh-keyscan -H "$container_ip" >>~/.ssh/known_hosts 2>/dev/null
        done
        echo "Added new fingerprints for ub01, ub02, and ub03"
    }
    # Main execution
    echo "Removing existing fingerprints..."
    remove_fingerprints
    echo "Adding new fingerprints..."
    add_fingerprints
    echo "Fingerprint update complete. You should now be able to SSH without prompts."

    echo "OK YOUR ENVIRONMENT IS NOW DONE! 
    You can ssh root@ub01/ub02/ub03 and run anything you want via ansible from this host!!!
    
    Feel free to make a test ansible like: mkdir ansTest01; cd andTest01; touch hosts; touch ansible.cfg; ...
    "
    echo "Step: run_launch_3_ubuntu_containers completed successfully!"

} # END OF run_launch_3_ubuntu_containers

run_launch_1_ubuntu_container() {

    CONTAINER_NAME="ub01"
    NEW_IMAGE_NAME="ub2404"
    # read -p "Enter the name of the $NEW_IMAGE_NAME you would like to create: " CONTAINER_NAME

    while true; do
        read -p "Enter the name of the $NEW_IMAGE_NAME you would like to create: " CONTAINER_NAME
        docker rm -f $CONTAINER_NAME
        if [[ "$CONTAINER_NAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9_.-]+$ ]]; then
            if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
                echo "Error: A container with the name '$CONTAINER_NAME' already exists. Please choose a different name."
            else
                break
            fi
        else
            echo "Error: Invalid container name. Use only alphanumeric characters, underscores, dots, and hyphens. The name must start with an alphanumeric character."
        fi
    done
    echo "Container name '$CONTAINER_NAME' is valid and available. Continuing..."

    echo "Ok starting '$CONTAINER_NAME' from the new container image called $NEW_IMAGE_NAME..."

    # Number of containers to start
    num_ubuntu_containers=3
    # Image name to use
    image_name="ub2404"
    # Hostname prefix
    hostname_prefix="ub"

    # SETUP MYYYYYYY Make a dev_network
    docker network create --subnet=172.16.99.0/24 dev_network 2>/dev/null

    # Ensure that live-restore to keep the same IP address is installed
    DAEMON_JSON="/etc/docker/daemon.json"
    # Function to check if jq is installed
    check_jq() {
        if ! command -v jq &>/dev/null; then
            echo "jq is not installed. Installing..."
            sudo apt-get update && sudo apt-get install -y jq
        fi
    }
    check_jq
    if [ ! -f "$DAEMON_JSON" ]; then
        echo "Creating $DAEMON_JSON with live-restore enabled"
        echo '{"live-restore": true}' | sudo tee "$DAEMON_JSON" >/dev/null
    else
        if jq -e '.["live-restore"]' "$DAEMON_JSON" >/dev/null 2>&1; then
            echo "live-restore is already set in $DAEMON_JSON"
            if [ "$(jq -r '.["live-restore"]' "$DAEMON_JSON")" != "true" ]; then
                echo "Updating live-restore to true"
                sudo jq '.["live-restore"] = true' "$DAEMON_JSON" >"$DAEMON_JSON.tmp" && sudo mv "$DAEMON_JSON.tmp" "$DAEMON_JSON"
            fi
        else
            echo "Adding live-restore to $DAEMON_JSON"
            sudo jq '. + {"live-restore": true}' "$DAEMON_JSON" >"$DAEMON_JSON.tmp" && sudo mv "$DAEMON_JSON.tmp" "$DAEMON_JSON"
        fi
    fi
    sudo systemctl reload docker
    echo "Docker daemon configuration updated successfully"

    # Loop to start containers
    # for i in $(seq 1 $num_ubuntu_containers); do
    # Create hostname (ub01, ub02, ub03)
    hostname="${hostname_prefix}0${i}"
    hostname=$CONTAINER_NAME
    # echo "Starting fresh new container... ${hostname}"
    # Stop container if it exists
    # docker stop ${hostname} >/dev/null 2>&1
    # Remove container if it exists
    docker rm -f ${hostname} >/dev/null 2>&1
    # Start new container
    # docker run -d -t -h ${hostname} --name ${hostname} ${image_name} >/dev/null 2>&1
    # docker run -dit --network my_network --ip 172.18.0.2 your_image
    # docker run -d -t -h ${hostname} --name ${hostname} --restart=always ${image_name} >/dev/null 2>&1

    echo launching.... docker run -d -t -h ${hostname} --name ${hostname} --network dev_network --restart=always ${image_name}
    docker run -d -t -h ${hostname} --name ${hostname} --network dev_network --restart=always ${image_name} >/dev/null #2>&1
    if [ $? -eq 0 ]; then
        echo "Container ${hostname} started successfully."
    else
        echo "Failed to start container ${hostname}."
    fi
    # done

    echo "New: $hostname containers with root/P@ started."
    # for i in $(seq 1 $num_ubuntu_containers); do
    printf "$hostname = $(docker inspect $hostname | grep IPAddress | grep -v SecondaryIPAddresses | sed 's/.* //' | uniq | sed 's/,$//')\n"
    # done

    echo "Adding the $hostname to /etc/hosts now..."

    # Temporary file for hosts
    temp_hosts="/tmp/hosts.new"
    # Copy current hosts file to temp file
    cp /etc/hosts $temp_hosts
    # Function to update hosts file
    update_hosts() {
        local hostname=$1
        local ip=$2
        # Remove existing entry if it exists
        sed -i "/ $hostname$/d" $temp_hosts
        # Add new entry
        echo "$ip $hostname" >>$temp_hosts
    }
    echo "Updating /etc/hosts with container IP addresses..."
    # for i in $(seq 1 $num_ubuntu_containers); do
    # hostname="ub0$i"
    # Get container IP
    ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $hostname)
    if [ -n "$ip" ]; then
        update_hosts $hostname $ip
        echo "Updated $hostname with IP $ip"
    else
        echo "Failed to get IP for $hostname"
    fi
    # done
    # Replace /etc/hosts with our updated version
    sudo mv $temp_hosts /etc/hosts
    echo "Finished updating /etc/hosts"
    # Display the updated entries
    echo "Updated entries in /etc/hosts:"
    grep "$hostname" /etc/hosts
    chmod 777 /etc/hosts

    echo "Generating or re-using your SSH KEY and adding it to all the 3 ubuntu container targets..."

    # SSH key path
    ssh_key_path="$HOME/.ssh/id_rsa"
    # Generate SSH key if it doesn't exist
    if [ ! -f "$ssh_key_path" ]; then
        echo "Generating new SSH key..."
        ssh-keygen -t rsa -b 4096 -f "$ssh_key_path" -N ""
    else
        echo "SSH key already exists."
    fi
    # Get the public key content
    public_key=$(cat "${ssh_key_path}.pub")
    # Function to add SSH key to a container
    add_ssh_key_to_container() {
        local container_name=$1
        echo "Adding SSH key to $container_name..."
        # Ensure .ssh directory exists and has correct permissions
        docker exec $container_name mkdir -p /root/.ssh
        docker exec $container_name chmod 700 /root/.ssh
        # Add the public key to authorized_keys
        echo "$public_key" | docker exec -i $container_name tee -a /root/.ssh/authorized_keys >/dev/null
        # Set correct permissions for authorized_keys
        docker exec $container_name chmod 600 /root/.ssh/authorized_keys
        echo "SSH key added to $container_name"
    }

    # Add SSH key to each container
    # for i in $(seq 1 $num_ubuntu_containers); do
    container_name=$hostname
    add_ssh_key_to_container $container_name
    # done

    echo "SSH key has been added to all containers."

    echo "Next, this script.... removes existing fingerprints for $hostname from ~/.ssh/known_hosts, and then adds them back to avoid future prompts"

    # Function to remove existing fingerprints
    remove_fingerprints() {
        # for i in {1..3}; do
        ssh-keygen -R "$hostname" 2>/dev/null
        ssh-keygen -R "$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $hostname)" 2>/dev/null
        # done
        echo "Removed existing fingerprints for $hostname"
    }
    # Function to add new fingerprints
    add_fingerprints() {
        # for i in {1..3}; do
        container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $hostname)
        ssh-keyscan -H "$hostname" >>~/.ssh/known_hosts 2>/dev/null
        ssh-keyscan -H "$container_ip" >>~/.ssh/known_hosts 2>/dev/null
        # done
        echo "Added new fingerprints for $hostname"
    }
    # Main execution
    echo "Removing existing fingerprints..."
    remove_fingerprints
    echo "Adding new fingerprints..."
    add_fingerprints
    echo "Fingerprint update complete. You should now be able to SSH without prompts."

    echo "OK YOUR ENVIRONMENT IS NOW DONE! 
    You can ssh root@$hostname and run anything you want via ansible from this host!!!
    
    Feel free to make a test ansible like: mkdir ansTest01; cd andTest01; touch hosts; touch ansible.cfg; ...
    "
    echo "Step: run_launch_1_ubuntu_container completed successfully!"

} # END OF run_launch_1_ubuntu_container

launch_lxd_init() {
    echo "Cleaning /etc/hosts from any ub01/ub02/ub03 ..."
    sed -i 's/.*ub0[123].*//' /etc/hosts
    sed -i "s/.*$container_name.*//" /etc/hosts
    chmod 777 /etc/hosts
    echo "Launching: lxd init --minimal ..."
    lxd init --minimal
} # END OF launch_lxd_init


launch_ubuntu_1_lxc_container() { #STILL NEED TO FIX SSH KEY
    local default_name="ub01"
    local image="ubuntu:24.04"
    local root_password="P@ssw0rd"
    local public_key=$(cat ~/.ssh/id_rsa.pub)

    read -p "Enter a name for the $image container (default: $default_name): " container_name
    container_name=${container_name:-$default_name}
    lxc delete $container_name --force 2>/dev/null 1>/dev/null
    sed -i "s/.*$container_name.*//" /etc/hosts

    echo "Cleaning any ub01/ub02/ub03 and $container_name from /etc/hosts"
    sed -i 's/.*ub0[123].*//' /etc/hosts
    sed -i "s/.*$container_name.*//" /etc/hosts
    chmod 777 /etc/hosts

    echo "@@ Launching Ubuntu container named $container_name @@"
    
    # SAFE WAY IS:
    # lxc launch $image $container_name # Safe normal way!

    # UNSAFE WAY IS:
    lxc launch $image $container_name  -c security.nesting=true -c security.privileged=true # UNSAFE WAY! 
    lxc config set $container_name raw.lxc "lxc.apparmor.profile=unconfined" # UNSAFE WAY! 
    lxc stop $container_name
    lxc start $container_name

    echo "Setting root password..."
    lxc exec $container_name -- bash -c "echo root:$root_password | chpasswd"

    echo "Adding SSH key..."
    lxc exec $container_name -- bash -c "mkdir -p /root/.ssh && chmod 700 /root/.ssh"
    echo "$public_key" | lxc exec $container_name -- tee -a /root/.ssh/authorized_keys >/dev/null
    lxc exec $container_name -- bash -c "chmod 600 /root/.ssh/authorized_keys"

    echo "Enabling password and pubkey auth in sshd_config..."
    lxc exec $container_name -- bash -c "echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config"
    lxc exec $container_name -- bash -c "echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config ; systemctl restart ssh"

    echo "ADDING IT, and ensuring ALL OTHER LXC's are in /etc/hosts... now..."
    temp_hosts=$(mktemp)
    cp /etc/hosts $temp_hosts

    echo "SLEEPING for 5... to ENSURE THE CONTAINER IS FULLY UP BEFORE ATTEMPTING TO ADD IP ADDRESS"
    sleep 5
    update_hosts() {
        local hostname=$1
        local ip=$2

        sed -i "/$hostname/d" $temp_hosts
        echo "$ip $hostname" >>$temp_hosts
    }

    echo "Updating /etc/hosts with LXC container IP addresses..."
    for container in $(lxc list --format csv -c n); do
        # Get container IP
        # ip=$(lxc list $container -c 4 --format csv | cut -d' ' -f1)
        ip=$(lxc list $container -c 4 --format csv | grep -v '(docker' | grep -v '(br-' | cut -d' ' -f1)
        echo "For container $container, found ip address: $ip"
        if [ -n "$ip" ]; then
            update_hosts $container $ip
            echo "Updated $container with IP $ip"
        else
            echo "Failed to get IP for $container"
        fi
    done

    # Replace /etc/hosts with our updated version
    sudo mv $temp_hosts /etc/hosts

    # Display the updated entries PRINT IT OUT FOR THEM
    echo "Updated entries in /etc/hosts:"
    grep -E "$(lxc list --format csv -c n | tr '\n' '|' | sed 's/|$//')" /etc/hosts
    chmod 777 /etc/hosts
    echo "Finished updating /etc/hosts"

    echo "Container $container_name successfully launched and configured"
    echo "Root password set to: $root_password"
    echo "SSH key added to container"
    echo "To enter the container, use: lxc exec $container_name bash"
} # End of launch_ubuntu_1_lxc_container

# ~~MAIN MENU~~
echo "Please select an option (ONLY USE ROOT NOBODY ELSE):"
echo "[1]. Build Host OS with DockerCE/Ansible/Lxd"
echo "[2]. Docker: Build ub2404 fresh container from internet"
echo "[3]--[d] Docker: CREATE 1 freshubXX (docker container, sshkeygen'ed, root/P@)"
echo "[4]. Docker: CREATE 3 fresh ub0123  (docker container, sshkeygen'ed, root/P@)"
echo "[5]. Lxd: Install 'lxd init --minimal' for standard lxd host"
echo "[6]--[l] Lxc: CREATE 1 fresh ubXX   (lxc **UNSAFE ROOTED** container, sshkeygen'ed, root/P@), use sudo -i... then everything is GOOD, plus the .ssh is ONLY FOR ROOT and autoignore warningified!!!"
echo "[7]--[r] Lxc: REMOVE ALL LXC CONTAINERS"
echo "8. EXIT SCRIPT! Try deploying admindash/copypasta/remoteshell-api!"

read -p "Enter your choice (1-5): " choice

case $choice in
1)
    run_build_development_environment
    echo "Finished launching: run_build_development_environment"
    ;;
2)
    run_build_docker_ub2404_baseline
    echo "Finished launching: run_build_docker_ub2404_baseline"
    ;;
3|d|D)
    run_launch_1_ubuntu_container
    echo "Finished launching: run_launch_1_ubuntu_container"
    ;;
4)
    run_launch_3_ubuntu_containers
    echo "Finished launching: run_launch_3_ubuntu_containers"
    ;;
5)
    launch_lxd_init
    echo "Finished launching: launch_lxd_init"
    ;;
6|l|L)
    launch_ubuntu_1_lxc_container
    echo "Finished launching: launch_ubuntu_1_lxc_container"
    ;;
7|r|R)
    echo "Deleting ALL LXC Containers!!!"
    lxc list
    read -p "PRESS ENTER TO DELETE THEM OR CTRL C TO EXIST" ;
    lxc list -c n --format csv | xargs -I {} lxc delete {} --force
    ;;
8)
    echo "Exiting..."
    exit 0
    ;;
*)
    echo "Invalid option. Please try again. Exiting"
    exit 1
    ;;
esac

echo "Script complete."
