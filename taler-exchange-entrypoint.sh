sudo -u taler-exchange-httpd taler-exchange-dbinit
mkdir -p /var/log/nginx
"$1"/bin/taler-exchange-secmod-rsa -c /etc/taler/taler.conf -L INFO &
"$1"/bin/taler-exchange-secmod-cs -c /etc/taler/taler.conf -L INFO &
"$1"/bin/taler-exchange-secmod-eddsa -c /etc/taler/taler.conf -L INFO &
"$1"/bin/taler-exchange-httpd -c /etc/taler/taler.conf -L INFO &
"$1"/bin/taler-exchange-aggregator -c /etc/taler/taler.conf -L INFO &
"$1"/bin/taler-exchange-closer -c /etc/taler/taler.conf -L INFO &
"$1"/bin/taler-exchange-wirewatch -c /etc/taler/taler.conf -L INFO &
"$1"/bin/taler-exchange-transfer -c /etc/taler/taler.conf -L INFO &
"$2"/bin/nginx
"$3"/bin/tail -f /dev/null
