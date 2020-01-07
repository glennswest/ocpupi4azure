./setup_azarm.sh gswx1
./setup_dns.sh gswx1 gw.ncc9.com
read -p "Press [Enter] to start deploy"
./deploy_azarm.sh gswx1

