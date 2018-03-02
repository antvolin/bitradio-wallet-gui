# bitradio-wallet-gui
Dockerized wallet Bitradio with graphical Interface

# Download and the first launch of the container

    # Allow access to the host screen
    xhost +si:localuser:root

    # Folder with wallet data will be created in the current location - "$(pwd)/bitradio-data/"
    docker run -d -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro -v $(pwd)/bitradio-data/:$HOME/bitradio-data/ --name=bitradio-wallet-gui antvolin/bitradio-wallet-gui
