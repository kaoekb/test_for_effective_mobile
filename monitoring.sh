#!/bin/bash

LOG_FILE="/var/log/monitoring.log"
MONITOR_URL="https://test.com/monitoring/test/api"
PROCESS_NAME="test.sh"
PID_FILE="/var/run/test_pid.txt"

log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE" 2>&1
}

log_message "Starting monitoring script"

                                                            # Проверяем наличие процесса
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    LAST_PID=$(pgrep -x "$PROCESS_NAME" | head -n 1)
    log_message "Process found with PID: $LAST_PID"

                                                            # Проверяем файл с последним PID
    if [ -f "$PID_FILE" ]; then
        LAST_PERSISTED_PID=$(cat "$PID_FILE")
    else
        LAST_PERSISTED_PID=""
    fi

                                                            # Если PID изменился, логируем это
    if [ "$LAST_PID" != "$LAST_PERSISTED_PID" ]; then
        log_message "Process $PROCESS_NAME was restarted (PID: $LAST_PID)"
        echo "$LAST_PID" > "$PID_FILE"
    fi

                                                            # Проверяем доступность сервера
    if ! curl --silent --fail "$MONITOR_URL" > /dev/null; then
        log_message "Monitoring server is unreachable"
    else
        log_message "Monitoring server contacted successfully"
    fi
else
    log_message "Process $PROCESS_NAME is not running"
    exit 0
fi
