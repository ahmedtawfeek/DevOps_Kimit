#!/bin/bash

case "$1" in
    start)
        systemctl start ssh.service
        ;;
    stop)
        systemctl stop ssh.service
        ;;
    status)
        systemctl status ssh.service
        ;;
esac
