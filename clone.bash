#!/bin/bash
# Copyright: Milan Oberkirch, 2013 (CC BY-SA 3.0).

function clone_setup() {
    git clone https://github.com/zvyn/user-configs.git $HOME/config
    echo "Run $HOME/config/setup_user_configs.bash to install the new configuration."
}
clone_setup
