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
    -> Download XCTU
    -> XCTU v. 6.4.1.7 Linux x64 (64bit Linux için...)

### Local download link
http://172.22.9.204/taliabee/40002881_S.run   # ibm306 makinesi
http://172.22.9.204/taliabee/zigbee_xctu.run  # son surume linkli
http://172.22.9.204/taliabee/legacy_fw.zip    # legacy firmwares

### XCTU-NG kurulum
Masaüstü açıkken konsol açılıp normal kullanıcı hesabı ile kurulum yapılır.

```bash
mkdir -p ~/Desktop
wget -O /tmp/40002881_S.run http://172.22.9.204/taliabee/40002881_S.run
chmod u+x /tmp/40002881_S.run

rm -rf /tmp/xctung
rm /tmp/bitrock_installer*
/tmp/40002881_S.run --installdir ~/digi
```

### XCTU-NG kaldırma
Desktop açıkken konsoldan

```bash
~/digi/XCTU-NG/uninstall
```

### Ayarlar
Seri port erişimi için kullanıcıyı **dialout** grubuna eklemek gerekiyor.
Ayarın aktif hale gelebilmesi için yeniden login olmak gerekli.

```bash
su -l
adduser kullanici_adi dialout
```

### Grafik ortamda çalıştırma
/tmp klasöründe yeterince yer olduğunu ve ```/tmp/xctung``` klasörüne
yazabildiğini kontrol et. Çalıştırmak için path

```bash
~/digi/XCTU-NG/app
```

- İlk açılışta güncellemelerin tamamlanmasını bekle.
- XCTU -> Preferences -> Automatic Updates -> False
                       -> Radio Firmware Library -> False
- Tools -> Firmware Explorer -> Can't find your firmware? Click Here
        -> Install firmware from file (eğer legacy_fw.zip dosyası varsa)
        -> Install legacy firmware package

Coordinator Zigbee
==================
Master makineye bağlı olan zigbee.  Giden paketler için ana makineye bir tane
takılı olacak.

### Coordinator profile oluşturma
- XCTU -> Discover Radio Modules -> Default seçenekler uygun
- Tools -> Working modes -> Configuration Working mode
- Tools -> Firmware Explorer -> XBP24BZ7 - Zigbee Coordinator API - 21A7 (newest)

    ID : 0 -> X     # rastgele tam sayi, butun cihazlarda aynı olmalı.
                    # Zigbee agina, disaridan erisimi engellemek için gerekli.
    DL : 0 -> FFFF  # Gelen tüm paketleri alabilmesi için gerekli.
    EE : Disabled   # Gelen paketleri izleyebilmek için ağ güvenliği
                    # devredışı bırakılmalı.
    BD : 9600 -> 115200
    AO : Explicit   # API çıktılarını rx_explicit data formatında almak
                    # alabilmek için bütün cihazlarda bu şekilde düzenlenmeli.

- Write

- Working modes -> Network Working mode -> Scan
  Test için... Modulun bulunması lazım.

### Konsoldan coordinator profile yükleme
```bash
~/digi/XCTU-NG/XCTUcmd update_firmware -v -p /dev/ttyUSB0 -b 9600 \
    -f ~/digi/XCTU-NG/radio_firmwares/xbee_zb/XBP24-ZB_21A7_S2B.xml
~/digi/XCTU-NG/XCTUcmd load_profile  -v -p /dev/ttyUSB0 -b 9600 \
    -f custom_profile_23A7.xml
```

Router Zigbee
=============
Sahadaki makinelere bağlı olan zigbee.

### Router profile oluşturma
- XCTU -> Discover Radio Modules -> Default seçenekler uygun
- Tools -> Firmware Explorer -> XBP24BZ7 - Zigbee Router API - 23A7 (newest)

    ID : 0 -> X     # rastgele tam sayi, butun cihazlarda aynı olmalı.
                    # Zigbee agina, disaridan erisimi engellemek için gerekli.
    JV : Enabled    # Router'ın doğru kanalı seçebilmesi için gerekli.
    DL : 0 -> FFFF  # yönlendirilen paketleri alabilmesi için gerekli.
                    # sadece koordinatörden alacaksa 0 kalacak.
    EE : Disabled   # Gelen paketleri izleyebilmek için ağ güvenliği
                    # devredışı bırakılmalı.
    BD : 9600 -> 115200
    AP : 1          # API Modunu etkinleştirmek için bütün cihazlarda
                    # değiştirilmeli.
    AO : Explicit   # API çıktılarını rx_explicit data formatında almak
                    # alabilmek için bütün cihazlarda bu şekilde düzenlenmeli.

- Write

- Working modes -> Network Working mode -> Scan
  Test için... Modulun bulunması lazım.

### Konsoldan router profile yükleme
```bash
~/digi/XCTU-NG/XCTUcmd update_firmware -v -p /dev/ttyUSB0 -b 9600 \
    -f ~/digi/XCTU-NG/radio_firmwares/xbee_zb/XBP24-ZB_23A7_S2B.xml
~/digi/XCTU-NG/XCTUcmd load_profile  -v -p /dev/ttyUSB0 -b 9600 \
    -f custom_profile_23A7.xml
```
