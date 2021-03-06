#!/bin/bash
# Configuração de DHCP padrão
clear

#instalação do serviço de dhcp
apt install isc-dhcp-server -y
clear

if [ ! -f /etc/dhcp/dhcpd.conf.bk ]
then
        cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bk
fi

if [ ! -f /etc/default/isc-dhcp-server.bk ]
then
        cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bk
fi

echo "Rede (Ex. 192.168.1.0):"
read rede

echo "Mascara (Ex. 255.255.255.0):"
read mascara

echo "IP de inicio:"
read ip_inicio

echo "IP do fim:"
read ip_fim

echo "IP gateway:"
read ip_gateway

echo "IP DNS:"
read ip_dns

echo "option domain-name \"example.org\";
option domain-name-servers ns1.example.org, ns2.example.org;
default-lease-time 600;
max-lease-time 7200;
ddns-update-style none;" > /etc/dhcp/dhcpd.conf
echo "subnet $rede netmask $mascara{
        range $ip_inicio $ip_fim;        option routers $ip_gateway;
        option domain-name-servers $ip_dns;
}" >> /etc/dhcp/dhcpd.conf

ip addr show
echo "Nome da interface:"
read interface

echo  'INTERFACESv4="'$interface'"
INTERFACESv6=""
' > /etc/default/isc-dhcp-server

systemctl restart isc-dhcp-server
clear
systemctl status isc-dhcp-server
