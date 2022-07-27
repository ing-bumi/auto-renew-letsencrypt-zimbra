# auto renew letsencrypt zimbra

auto-renew.sh adalah script yang gunakan untuk renew ssl letsencrypt pada mail server zimbra 

copy paste script auto-renew.sh lalu tambahkan cron job sesuai dengan kebutuhan 

contoh : jalankan script tersebut setiap minggu 
0 0 * * 0 root /root/auto-renew.sh
