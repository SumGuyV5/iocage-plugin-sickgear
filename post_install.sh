#!/bin/sh -x
IP_ADDRESS=$(ifconfig | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}')


cd /usr/local/bin
ln -s python3.8 python
ln -s python3.8 python2

cd /usr/local && git clone https://github.com/SickGear/SickGear.git sickgear

pw user add media -c media -u 710 -d /nonexistent -s /usr/bin/nologin
chown -R media:media sickgear

cd sickgear
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

python -m pip install lxml
python -m pip install regex

cp /usr/local/sickgear/init-scripts/init.freebsd /usr/local/etc/rc.d/sickgear

sysrc sickgear_enable=YES
sysrc sickgear_user=media
sysrc sickgear_group=media

service sickgear start

echo -e "SickGear now installed.\n" > /root/PLUGIN_INFO
echo -e "\nGo to $IP_ADDRESS:8081\n" >> /root/PLUGIN_INFO