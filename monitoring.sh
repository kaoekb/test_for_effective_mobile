#!/bin/bash

LOG_FILE="/var/log/monitoring.log"
MONITOR_URL="https://test.com/monitoring/test/api"
PROCESS_NAME="test"

echo "Starting monitoring script at $(date)" >> /var/log/monitoring.log

if pgrep -x "$PROCESS_NAME" > /dev/null; then
    LAST_PID=$(pgrep -x "$PROCESS_NAME" | head -n 1)

    LAST_PERSISTED_PID=$(cat /var/run/test_pid.txt 2>/dev/null)

    if [ "$LAST_PID" != "$LAST_PERSISTED_PID" ]; then
        echo "$(date) - Process $PROCESS_NAME was restarted (PID: $LAST_PID)" >> "$LOG_FILE"
        echo "$LAST_PID" > /var/run/test_pid.txt
    fi

    if ! curl --silent --fail "$MONITOR_URL" > /dev/null; then
        echo "$(date) - Monitoring server is unreachable" >> "$LOG_FILE"
    fi
else
    exit 0
fi