sudo apt update -y
sudo apt install openvpn easy-rsa -y
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
mv openssl-1.0.0.cnf openssl.cnf
source vars
./clean-all
./build-ca #Selecionar enter em todas as opcoes
./build-key-server server #Selecionar enter em todas as opcoes e 'y' para as duas ultimas
./build-dh
openvpn --genkey --secret keys/ta.key
cd ~/openvpn-ca
source vars
./build-key client1 #Selecionar enter em todas as opcoes e 'y' para as duas ultimas
cd ~/openvpn-ca/keys
sudo cp ca.crt server.crt server.key ta.key dh2048.pem /etc/openvpn
gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz | sudo tee /etc/openvpn/server.conf
sudo cp /config-openvpn/server.conf /etc/openvpn/server.conf
sudo cp /config-openvpn/sysctl.conf /etc/sysctl.conf
sudo sysctl -p
sudo cp /config-openvpn/before.rules /etc/ufw/before.rules
sudo cp /config-openvpn/ufw /etc/default/ufw
sudo ufw allow 443/tcp
sudo ufw allow OpenSSH
sudo ufw allow 5000/tcp
sudo ufw disable
sudo ufw enable #Responder 'y'
sudo systemctl start openvpn@server
sudo systemctl enable openvpn@server
mkdir -p ~/client-configs/files
chmod 700 ~/client-configs/files
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/client-configs/base.conf
cp /config-openvpn/base.conf ~/client-configs/base.conf
cp /config-openvpn/make_config.sh ~/client-configs/make_config.sh
chmod 700 ~/client-configs/make_config.sh
cd ~/client-configs
./make_config.sh client1







