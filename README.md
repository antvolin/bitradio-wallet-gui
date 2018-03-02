# bitradio-wallet-gui
Dockerized wallet Bitradio with graphical Interface

# REQUIRED TO RUN

# Download and the first launch of the container
    # Allow access to the host screen
    xhost +si:localuser:root
    
    # Set runtime variable
    export BITRADIO_DATA="$HOME/bitradio-data/"

    # Folder with wallet data will be created in the location - "<HOME FOLDER YOUR USER>/bitradio-data/"
    mkdir -p $BITRADIO_DATA
    docker run -d -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro -v $BITRADIO_DATA/:$BITRADIO_DATA --name=bitradio-wallet-gui antvolin/bitradio-wallet-gui -datadir=$BITRADIO_DATA
    
# You can close the wallet by clicking the appropriate button in the wallet window or by running the command:
    docker stop bitradio-wallet-gui

# If you closed the wallet and want to reopen it - run the command:
    docker start bitradio-wallet-gui

# OPTIONAL

    # If you want to rebuild the container yourself, run the following two commands in turn:
    export BITRADIO_DATA="$HOME/bitradio-data/"
    docker build --build-arg USER_NAME=$USER --build-arg BITRADIO_DATA=$BITRADIO_DATA -t $USER/bitradio-wallet-gui .
