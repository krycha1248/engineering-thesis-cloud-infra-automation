# Automatyzacja infrastruktury – Terraform + Ansible

## Opis projektu

Projekt przedstawia automatyczne tworzenie oraz konfigurację infrastruktury serwerowej z wykorzystaniem Terraform i Ansible.

Celem jest:
- utworzenie maszyny wirtualnej w środowisku OpenStack,
- skonfigurowanie rekordów DNS,
- wdrożenie aplikacji na serwerze.

Całość opiera się na podejściu Infrastructure as Code, czyli zarządzanie infrastrukturą przy pomocy kodu zamiast ręcznej konfiguracji.

---

## Wykorzystane technologie

- Terraform – tworzenie infrastruktury  
- Ansible – konfiguracja serwera i deployment  
- OpenStack – środowisko chmurowe  
- Cloudflare – DNS  

---

# Część I – Terraform (infrastruktura)

Terraform odpowiada za przygotowanie całego środowiska pod wdrożenie aplikacji.

## Tworzenie maszyny wirtualnej

Tworzona jest instancja:
- system: Debian 13  
- flavor: d2-2 (CPU/RAM)
- sieć: Ext-Net  
- dostęp przez SSH (klucz)

Po utworzeniu maszyna dostaje adres IP, który jest dalej wykorzystywany w kolejnych krokach.

---

## Konfiguracja DNS

Tworzone są trzy rekordy:

- rekord A – wskazuje domenę na adres IP serwera (proxy z automatycznym certyfikatem SSL po stronie Cloudflare)
- rekord CNAME (www) – kieruje na domenę główną (proxy z automatycznym certyfikatem SSL po stronie Cloudflare)
- rekord pomocniczy (vps) – bez proxy, używany np. do SSH  

---

## Integracja z Ansible

Po utworzeniu infrastruktury Terraform uruchamia playbook Ansible.

Przekazywane są m.in.:
- adres IP serwera  
- użytkownik SSH  
- klucz prywatny  
- domena  
- dane użytkownika  

Dzięki temu nie trzeba ręcznie uruchamiać konfiguracji – wszystko dzieje się automatycznie.

---

## Output

Na końcu Terraform zwraca wynik działania Ansible, co pozwala sprawdzić, czy wszystko wykonało się poprawnie.

---

## Przebieg działania Terraform

1. Tworzenie maszyny w OpenStack  
2. Pobranie adresu IP  
3. Konfiguracja DNS  
4. Uruchomienie Ansible  

---

# Część II – Ansible (konfiguracja i deployment)

Ansible odpowiada za przygotowanie systemu i wdrożenie aplikacji.

## Zarządzanie użytkownikiem

Na początku sprawdzane jest, czy użytkownik i jego grupa istnieją:
- jeśli grupa nie istnieje – zostaje utworzona  
- jeśli użytkownik nie istnieje – zostaje dodany  

Użytkownik:
- trafia do grupy sudo  
- dostaje zahashowane hasło  
- korzysta z basha  

---

## Dostęp SSH

Do użytkownika dodawany jest klucz SSH, co umożliwia logowanie bez użycia hasła.

---

## Uprawnienia sudo

Dodawany jest wpis do `/etc/sudoers`, który pozwala wykonywać polecenia sudo bez podawania hasła.

---

## Fail2Ban

Instalowany i konfigurowany jest fail2ban, który zabezpiecza serwer przed próbami logowania brute-force.

---

## Konfiguracja środowiska (ZSH i VIM)

Instalowane są podstawowe narzędzia:
- zsh, vim, git, htop  

Następnie:
- instalowany jest Oh My Zsh  
- dodawane są pluginy i motyw  
- wgrywana jest konfiguracja użytkownika  
- zmieniana jest powłoka na zsh  

Dodatkowo konfiguracja jest linkowana do użytkownika root.

---

## Firewall (iptables)

Konfigurowane są podstawowe reguły:
- ruch lokalny dozwolony  
- istniejące połączenia dozwolone  
- SSH (port 22) dozwolony  
- reszta ruchu blokowana  

Reguły są zapisywane na stałe.

---

## Instalacja Node.js

- instalacja wymaganych pakietów  
- dodanie repozytorium NodeSource  
- instalacja Node.js 24  
- instalacja pnpm (jeśli brak)  

---

## Build aplikacji

- pobranie repozytorium aplikacji  
- instalacja zależności  
- build aplikacji  

Adres strony jest ustawiany dynamicznie przez zmienną środowiskową.

---

## Deployment

- utworzenie katalogu w `/var/www/<domena>`  
- skopiowanie plików aplikacji  
- ustawienie odpowiednich uprawnień  
- usunięcie katalogu tymczasowego  

---

## Apache

- instalacja apache2  
- wgranie konfiguracji strony  
- aktywacja konfiguracji  
- restart serwera  

---

## Otwarcie portów

Firewall zostaje rozszerzony o:
- port 80 (HTTP)  
- port 443 (HTTPS)  

---

## Pełny przebieg działania

1. Terraform tworzy serwer  
2. Terraform ustawia DNS  
3. Terraform uruchamia Ansible  
4. Ansible:
   - tworzy użytkownika  
   - konfiguruje dostęp SSH  
   - zabezpiecza serwer  
   - instaluje środowisko  
   - buduje aplikację  
   - wdraża aplikację  
   - konfiguruje Apache  
5. Aplikacja jest dostępna przez przeglądarkę  

---

## Podsumowanie

Projekt pokazuje pełny proces automatyzacji:
- od utworzenia infrastruktury  
- przez konfigurację systemu  
- aż po wdrożenie aplikacji  

Całość działa bez ręcznej ingerencji i może być łatwo odtworzona w dowolnym momencie.