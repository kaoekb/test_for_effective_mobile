SERVICE_FILE = test-monitor.service
TIMER_FILE = test-monitor.timer
SERVICE_DEST = /etc/systemd/system/test-monitor.service
TIMER_DEST = /etc/systemd/system/test-monitor.timer
LOG_FILE = /var/log/monitoring.log
TEST_FILE = test.sh

install: copy-files enable-service start-service

copy-files:
	@echo "Copying service and timer files..."
	@cp $(SERVICE_FILE) $(SERVICE_DEST)
	@cp $(TIMER_FILE) $(TIMER_DEST)
	@chmod +x $(TEST_FILE)

enable-service:
	@echo "Reloading systemd daemon and enabling service..."
	@sudo systemctl daemon-reload
	@sudo systemctl enable test-monitor.timer

start-service:
	@echo "Starting the timer and service..."
	@sudo systemctl start test-monitor.timer
	@sudo systemctl start test-monitor.service
	@sudo ./$(TEST_FILE) || echo "Failed to start test process" >> $(LOG_FILE)

status:
	@echo "Checking the status of the service..."
	@sudo systemctl status test-monitor.service
	@sudo journalctl -u test-monitor.service

logs:
	@sudo tail -f /var/log/monitoring.log
clean:
	@echo " "
	@echo "Stopping and disabling the service and timer..."
	@sudo systemctl stop test-monitor.timer || echo "Failed to stop test-monitor.timer"
	@sudo systemctl stop test-monitor.service || echo "Failed to stop test-monitor.service"
	@sudo systemctl disable test-monitor.timer || echo "Failed to disable test-monitor.timer"
	@sudo systemctl disable test-monitor.service || echo "Failed to disable test-monitor.service"
	@sudo systemctl daemon-reload || echo "Failed to reload systemd daemon"

	@echo "Removing service and timer files..."
	@sudo rm -f $(SERVICE_DEST) || echo "Failed to remove service file"
	@sudo rm -f $(TIMER_DEST) || echo "Failed to remove timer file"

	@echo "Killing any processes related to $(TEST_FILE)..."
	@pkill -f $(TEST_FILE) || echo "No processes to kill for $(TEST_FILE)"

	@echo "Removing test script..."
	@sudo rm -f $(TEST_FILE) || echo "Failed to remove test file"

	@echo "Removing logs..."
	@sudo rm -f $(LOG_FILE) || echo "Failed to remove log file"

	@echo "System cleanup complete."


clear-logs:
	@echo "Clearing logs..."
	@sudo rm -f $(LOG_FILE)
	@echo "Logs cleared."
