#!/bin/bash

case "$1" in
    start)
        echo "Starting ssh service..."
        sudo systemctl start ssh
        ;;
    stop)
        echo "Stopping ssh service..."
        sudo systemctl stop ssh
        ;;
    restart)
        echo "Restarting ssh service..."
        sudo systemctl restart ssh
        ;;
    status)
        sudo systemctl status ssh
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
