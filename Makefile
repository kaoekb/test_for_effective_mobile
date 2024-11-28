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

clean:
	@echo "Stopping and disabling the service and timer..."
	@sudo systemctl stop test-monitor.timer
	@sudo systemctl stop test-monitor.service
	@sudo systemctl disable test-monitor.timer
	@sudo systemctl disable test-monitor.service

	@echo "Removing service and timer files..."
	@sudo rm -f $(SERVICE_DEST)
	@sudo rm -f $(TIMER_DEST)
	@pkill -f test
	@sudo rm -f $(TEST_FILE)

	@echo "Removing logs..."
	@sudo rm -f $(LOG_FILE)

	@echo "System cleanup complete."

clear-logs:
	@echo "Clearing logs..."
	@sudo rm -f $(LOG_FILE)
	@echo "Logs cleared."
