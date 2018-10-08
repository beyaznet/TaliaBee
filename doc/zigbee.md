ZIGBEE
======
Zigbee is a low-cost, low-power, wireless mesh network standard targeted at the
wide development of long battery life devices in wireless control and
monitoring applications.

---

XCTU
====
Zigbee modülü ayarlamak için bu yazılıma ihtiyaç vardır.

### Download link
https://www.digi.com/products/xbee-rf-solutions/xctu-software/xctu
http://ftp1.digi.com/support/utilities/40002881_redirect.htm

### Local download link
http://172.22.9.204/taliabee/40002881_J.run   # ibm306 makinesi
http://172.22.9.204/taliabee/zigbee_xctu.run  # son surume linkli

### XCTU-NG kurulum
mkdir ~/Desktop
chmod u+x 40002881_J.run
./40002881_J.run
    /home/kullanici_adi/digi  # kurulum klasoru

### info
vim /home/kullanici_adi/digi/XCTU-NG/radio_firmwares/xbee_zb/xbee_zb.txt

### Ayarlar
Seri port erişimi için kullanıcıyı "dialout" grubuna eklemek gerekiyor. Ayarın
aktif hale gelebilmesi için yeniden login olmak gerekli.

su -l
adduser kullanici_adi dialout

### Grafik ortamda çalıştırma
~/digi/XCTU-NG/app

    ID - PAN ID -> Koordinator cihazdaki PAN ID, router cihazlara set edilecek.
    NI - Node Identifier -> Cihazlara isim vermek istenirse kullanılabilir.
    DL - Destination Address Low -> Router cihazlarda her yerden paket
                                    alabilsin diye 'FFFF' yapılıyor.

### profile_20A7.xml
Koorinatör profili. Default ayarlı koordinatör Zigbee cihazdan profil alınarak
oluşturulur.
    ID : 0 -> X     # rastgele tam sayi, butun cihazlarda aynı olmalı
                    # Zigbee agina, disaridan erisimi engellemek için gerekli.

### profile_22A7.xml
Router profili. Default ayarlı router Zigbee cihazdan profil alınarak
oluşturulur.
    ID : 0 -> X     # rastgele tam sayi, butun cihazlarda aynı olmalı.
                    # Zigbee agina, disaridan erisimi engellemek için gerekli.
    DL : 0 -> FFFF  # yönlendirilen paketleri alabilmesi için gerekli.
                    # sadece koordinatörden alacaksa 0 kalacak.

### Koordinatör Zigbee kurulumu
20A7 - ZigBee Coordinator AT
radio_firmwares/xbee_zb/XBP24-ZB_20A7_S2B.xml
radio_firmwares/xbee_zb/XBP24-ZB_20A7_S2B.ehx2

Giden paketler için ana makineye bir tane takılı olacak.

cd ~/digi/XCTU-NG
./XCTUcmd update_firmware -f radio_firmwares/xbee_zb/XBP24-ZB_20A7_S2B.xml \
    -v -p /dev/ttyUSB0
./XCTUcmd load_profile -f profile_20A7.xml -v -p /dev/ttyUSB0

### Router Zigbee kurulumu
22A7 - ZigBee Router AT
radio_firmwares/xbee_zb/XBP24-ZB_22A7_S2B.xml
radio_firmwares/xbee_zb/XBP24-ZB_22A7_S2B.ehx2

Raspberry Pi cihazlara ve dönen paketler için ana makineye birer tane takılı
olacak.

cd ~/digi/XCTU-NG
./XCTUcmd update_firmware -f radio_firmwares/xbee_zb/XBP24-ZB_22A7_S2B.xml \
    -v -p /dev/ttyUSB0
./XCTUcmd load_profile -f profile_22A7.xml -v -p /dev/ttyUSB0
