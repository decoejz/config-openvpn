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
#Substituir o arquivo /etc/openvpn/server.conf pelo da minha maquina COM SUDO
#Substituir o arquivo /etc/sysctl.conf pelo da minha maquina COM SUDO
sudo sysctl -p
#Substituir o arquivo /etc/ufw/before.rules pelo da minha maquina COM SUDO
#Substituir o arquivo /etc/default/ufw pelo da minha maquina COM SUDO
sudo ufw allow 443/tcp
sudo ufw allow OpenSSH
sudo ufw disable
sudo ufw enable -y
sudo systemctl start openvpn@server
sudo systemctl enable openvpn@server
mkdir -p ~/client-configs/files
chmod 700 ~/client-configs/files
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/client-configs/base.conf
#Substituir o arquivo ~/client-configs/base.conf pelo da minha maquina
#Passar o arquivo make_config.sh para dentro de ~/client-configs/
chmod 700 ~/client-configs/make_config.sh
cd ~/client-configs
./make_config.sh client1







