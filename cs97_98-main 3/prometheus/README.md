put prometheus.yml in the same directory where prometheus is installed

for me, this is cd /opt/homebrew/etc if you installed prometheus with homebrew

Then run `./prometheus` You can also specify a specific yaml file location with
`--config.file` which can be used to avoid having to copy over the config file everytime you make changes. 