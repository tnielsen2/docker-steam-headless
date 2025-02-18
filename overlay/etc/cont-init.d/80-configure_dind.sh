
echo "**** Configure Dockerd ****"

if ([ "${MODE}" != "s" ] && [ "${MODE}" != "secondary" ]); then
    if [ ! -S /var/run/docker.sock ]; then
        echo "Enable Dockerd daemon"
        sed -i 's|^autostart.*=.*$|autostart=true|' /etc/supervisor.d/dind.ini
    else
        echo "Docker socket has been passed in from host. Using that instead"
    fi
    # Configure 'default' user to run docker commands without sudo
    if ! getent group docker &> /dev/null; then
        echo "Add user '${USER}' to docker group for sudoless execution"
        groupadd docker
        usermod -aG docker ${USER}
        mkdir -p ${USER_HOME:?}/.docker
        chown -R ${PUID}:${PGID} ${USER_HOME:?}/.docker
        chmod -R g+rwx ${USER_HOME:?}/.docker
    fi
else
    echo "Dockerd daemon not available when container is run in 'secondary' mode"
fi

echo "DONE"
