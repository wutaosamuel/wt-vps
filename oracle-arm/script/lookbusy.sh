# /bin/bash

# denpandencies
echo "download denpandencies with apt"
sudo apt update -y && sudo apt install curl build-essential -y

# download lookbusy source code
echo ""
echo "download lookbusy"
curl -L http://www.devin.com/lookbusy/download/lookbusy-1.4.tar.gz -o lookbusy-1.4.tar.gz
if [ ! -f lookbusy-1.4.tar.gz ]; then
	echo "download lookbusy failed"
	exit 1
fi
tar -xzvf lookbusy-1.4.tar.gz

# build lookbusy
echo ""
echo "install lookbusy"
cd lookbusy-1.4
./configure
make
sudo make install

# create systemctl service
serviceStr=$(cat <<-END
[Unit]
Description=lookbusy service

[Service]
Type=simple
ExecStart=/usr/local/bin/lookbusy -c 20-30 -r curve -m 5120MB
Restart=always
RestartSec=10
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target

END
)

sudo bash -c "echo \"${serviceStr}\" > /etc/systemd/system/lookbusy.service"
sudo systemctl daemon-reload
sudo systemctl start lookbusy.service
sudo systemctl enable lookbusy.service

# clean up
echo ""
echo "clean up"
cd ..
rm lookbusy-1.4.tar.gz
rm -dr lookbusy-1.4
