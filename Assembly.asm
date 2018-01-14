
.org 0
jmp main

main:
ldi r21,0x01 ; r21 registerının başlangıc degerini yükledik. 
out DDRC,r21 ; PortB nin data direction registeri DDRB ye r21 daki degeri yaziyoruz
ldi r17, 0x00 ; r17 registırına 0x00 yükledik butonlar için 
out DDRB, r17 ;
mainloop:
out PORTC,r21 ;PORTC ilgili pinlerini yakıyoruz.
rol r21; r21 deki değeri sürekli sola kaydırıyoruz
out DDRC,r21; tekrar pinleri yakıyoruz
call wait;wait fonksiyonunu çağırıyoruz
sbic PINB, 2; led sayısını arttırma butonu eger butona basarsak sayı fonksiyonuna atlıyor
jmp sayi;sayı fonksiyonuna atlıyor
sbic PINB, 1;butona basıldıgında ters yöne dondüreceğimiz fonksiyona atlıyor
jmp geri;geri fonksiyonuna atlıyor
sbic PINB, 0;hiz ayarı yaptığımız buton
jmp hiz;hız fonksiyonuna atlıyor
jmp mainloop ; programin mainloop etiketine giderek sonsuz dongude calismasini sagliyoruz.

hiz: ; 1. kademe hız fonksiyonu
out PORTC,r21 
rol r21
out DDRC,r21
call wait2 ; 2. kademe hız fonksiyonunu çağırıyoruz
sbic PINB, 2
jmp sayi
sbic PINB, 1
jmp geri
sbic PINB, 0
jmp hiz2
jmp hiz ; 

hiz2: ;2. kademe hız fonksiyonuz
out PORTC,r21 
rol r21
out DDRC,r21
call wait3 ;3. kademe hız fonsiyonunu çağırıyoruz
sbic PINB, 2
jmp sayi
sbic PINB, 1
jmp geri
sbic PINB, 0
jmp mainloop
jmp hiz2 ; sonsuz döngü olusturuyoruz (hız2 nin içinde)





geri: ; ledleri sola döndüren fonksiyon
out PORTC,r21 ; PORTC nin ilgili pinlerini gene çıkış yaptık
rol r21 ;ledleri sola döndüren komut
out DDRC,r21
call wait 
sbic PINB, 2
jmp sayi
sbic PINB, 1
jmp geri2
sbic PINB, 0
jmp hizters ; hız fonksiyonunun her iki yöndede çalışması için hızters fönksiyonuna atlıyor
jmp geri

hizters: ;ters yöndeki hızın 1. kademesi
out PORTC,r21 
ror r21
out DDRC,r21
call wait2 
sbic PINB, 2
jmp sayi
sbic PINB, 1
jmp geri
sbic PINB, 0;butana basıldıgında hızters2 ye atla
jmp hizters2
jmp hizters ;sonsuz döngüye sokuyoruz

hizters2:;ters yöndeki hızın 2. kademesi
out PORTC,r21 ; r17 deki degeri PORTB ye yaziyoruz.
ror r21
out DDRC,r21
call wait3 ; 700ms lik bekleme fonksiyonumuzu cagiriyoruz.
sbic PINB, 2
jmp sayi
sbic PINB, 1
jmp geri
sbic PINB, 0
jmp geri2
jmp hizters2 ; 


geri2:;ledleri sağa döndüren fonksiyon
out PORTC,r21 
ror r21
out DDRC,r21
call wait 
sbic PINB, 2
jmp sayi
sbic PINB, 1
jmp geri
sbic PINB, 0
jmp hizters
jmp geri2

mainloop2:;ledlerin sayısını arttırdıgımız fonksiyonları mainloop2 de döndürüyoruz
out PORTC,r21 
out DDRC,r21
call wait 
sbic PINB, 2
jmp sayi
sbic PINB, 1
jmp geri
sbic PINB, 0
jmp hizters
jmp mainloop 

sayi: ;2 tane led döndürdüğümüz fonksiyon
ldi r18,0x00 ; ledleri arttırırken kendi döndürdüğümüz led değerini tutmak için yeni bir register tanımlıyoruz,
add r18,r21; kendi döndürdüğümüz registerdaki değeri yeni tanımladıgımız registerin içine atıyoruz.
lsr r18; yeni tanımladığımız registerı bi kademe sağa kaydırıyoruz
adc r21,r18; ve kaydırdığımız değeri kendi döndürdüğümüz register ile topluyoruz.
out DDRC,r21;topladığımız son değeri çıkış pini olarak ayarlayıp 2 tane led yakmış oluyoruz
call wait;
sbic PINB,2;
jmp sayi2;
sbis PINB, 1;
jmp geri;
jmp mainloop2;

sayi2: ;yukardaki işlemleri 3 tane led için yaptığımız fonksiyon
ldi r19,0x00;
add r19,r21;
lsr r19;
adc r21,r19;
out DDRC,r21;
call wait
sbic PINB,2
jmp sayi3
sbis PINB, 1
jmp geri
jmp mainloop2

sayi3: ;yukardaki işlemleri 4 tane led için yaptığımız fonksiyon
ldi r20,0x00
add r20,r21
lsr r20
adc r21,r20
out DDRC,r21
call wait
sbic PINB,2
jmp sayi3
sbis PINB, 1
jmp geri
jmp mainloop2

wait:;1. kademe hız için çağıracağımız fonksiyon
push r21 ; mainloop icerisinde kullandigimiz r21 ve r17 nin degerlerini wait icinde de kullanmak istiyoruz.
push r17 ; bu nedenle push komutunu kullanarak bu registerlarin icindeki degerleri yigina kaydediyoruz

ldi r21,0x20 ;
ldi r17,0x80 ; 
ldi r18,0x10 ;
_w0:
dec r18 ; r18 deki degeri 1 azalt
brne _w0 ; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
dec r17 ; r17 deki degeri 1 azalt
brne _w0 ; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
dec r21 ; r21 daki degeri 1 azalt
brne _w0 ; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan

pop r17 ; fonksiyondan donmeden once en son push edilen r17 yi geri cek
pop r21 ; r21 yi geri cek

ret ; fonksiyondan geri don
wait3:    ; 3. kademe hız için çağıracağımız fonksiyon
   push r21  ; mainloop icerisinde kullandigimiz r21 ve r17 nin degerlerini wait icinde de kullanmak istiyoruz.
   push r17   ; bu nedenle push komutunu kullanarak bu registerlarin icindeki degerleri yigina kaydediyoruz
   

   ldi r21,0x10  ;
   ldi r17,0x80 ; 
   ldi r18,0x10  ; 
_w2:
   dec r18   ; r18 deki deback 1 azalt
   brne _w2   ; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r17   ; r17 deki deback 1 azalt
   brne _w2   ; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r21   ; r21 daki deback 1 azalt
   brne _w2   ; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan

   pop r17   ; fonksiyondan donmeden once en son push edilen r17 yi back cek
   pop r21   ; r21 yi back cek
   
   ret    ; fonksiyondan back don
 

wait2:    ; 3. kademe hız için çağıracağımız fonksiyon
   push r21   ; mainloop icerisinde kullandigimiz r21 ve r17 nin degerlerini wait icinde de kullanmak istiyoruz.
   push r17   ; bu nedenle push komutunu kullanarak bu registerlarin icindeki degerleri yigina kaydediyoruz
   

   ldi r21,0x30  ; 0x300000 kere dongu calistirilacak
   ldi r17,0x80 ; 
   ldi r18,0x10 ; 
_w1:
   dec r18   ; r18 deki deback 1 azalt
   brne _w1   ; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r17   ; r17 deki deback 1 azalt
   brne _w1   ; azaltma sonucu elde edilen deger 0 degilse _w0 a dallan
   dec r21   ; r21 daki deback 1 azalt
   brne _w1   ; azaltma sonuc


   pop r17   ; fonksiyondan donmeden once en son push edilen r17 yi back cek
   pop r21   ; r21 yi back cek
   
   ret    ; fonksiyondan back don

