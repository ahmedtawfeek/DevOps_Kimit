#!/bin/bash

case "$1" in
    start|Start)
        echo "Starting ssh service..."
        sudo systemctl start ssh
        ;;
    stop|Stop)
        echo "Stopping ssh service..."
        sudo systemctl stop ssh
        ;;
    restart|Restart)
        echo "Restarting ssh service..."
        sudo systemctl restart ssh
        ;;
    status|Status)
        sudo systemctl status ssh
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
