# Raspberry Pi Setup
Requirements: Pi Imager, MicroSD Card


WARNING: This script is intended to be run on RBP. If you would like to run on a different device,
(eg. for testing), use the Instructions at the bottom.

To run a raspberry pi, simply add its url (which is configured in Pi Imager) into
prometheus.yml as url:8080 (localhost:8080 if done locally).

To get the RBP code, run 
```
git clone https://github.com/hahearn73/cs97_98.git
```

Then, from inside `/rbp`,
<!-- ```
sudo ./start.sh -use_apt 1 -run_in_background 1
```
This will install necessary requirements and run the python script.

### Running locally
Use the script with different flags
```
sudo ./start.sh -use_apt 0 -run_in_background 0
```
in order to use pip3 to install packages (as opposed to apt), and to keep the program on your terminal window.
Manual execution can be done by installing the requirements in `rbp/requirements.txt` and running
```
python3 main.py
``` -->
install all the packages in requirements.txt. I recommend using a virtual environment
```
python3 venv venv
source venv/bin/activate
python3 -m pip install -r requirements.txt
```
and run the program using
```
python3 main.py
```
The RBP itself can't use pip to install packages, but it does spit out
an error message detailing how to install each package using apt.
```
sudo apt install python3-xyz
```
where xyz is the package you want to install is the typical method. Future updates to start.sh will address this issue