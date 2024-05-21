#!/bin/bash
# Step 1: download node_exporter to the Pi

wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-armv7.tar.gz
tar -xvzf node_exporter-0.18.1.linux-armv7.tar.gz

#Step 2: Install node_exporter binary and create required directories
sudo cp node_exporter-0.18.1.linux-armv7/node_exporter /usr/local/bin
# Make the binary executable
chmod +x /usr/local/bin/node_exporter
# Create a new user for node_exporter
sudo useradd -m -s /bin/bash node_exporter
# Create a directory for node_exporter
sudo mkdir /var/lib/node_exporter
# Change the owner of the directory to node_exporter
chown -R node_exporter:node_exporter /var/lib/node_exporter

#Step 3: Create a systemd service file.
# The unit file will allow us to control the service via the systemctl command.
# Additionally it will ensure node_exporter starts on boot.
FILE_PATH="/etc/systemd/system/node_exporter.service"
cat << EOF > $FILE_PATH
[Unit]
Description=Node Exporter

[Service]
# Provide a text file location for https://github.com/fahlke/raspberrypi_exporter data with the
# --collector.textfile.directory parameter.
ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory /var/lib/node_exporter/textfile_collector

[Install]
WantedBy=multi-user.target
EOF
# Reload the systemd daemon to recognize the new service
sudo systemctl daemon-reload 
# Enable the service to start at boot
sudo systemctl enable node_exporter.service
# Start the service
sudo systemctl start node_exporter.service

#verify that node exporter is running with systemctl status node_exporter