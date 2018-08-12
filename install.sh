#!/bin/bash

#colors
black="\033[0;30m"
red="\033[0;31m"
green="\033[0;32m"
brown_orange="\033[0;33m"
blue="\033[0;34m"
purple="\033[0;35m"
cyan="\033[0;36m"
light_gray="\033[0;37m"
dark_gray="\033[1;30m"
light_red="\033[1;31m"
light_green="\033[1;32m"
yellow="\033[1;33m"
light_blue="\033[1;34m"
light_purple="\033[1;35"
light_cyan="\033[1;36m"
white="\033[1;37m"
nocolor="\033[0m"

#installing apktoolx

clear
echo -e $white "
 ___           _        _ _ _                   
|_ _|____  ___| |_ ____| | (_)____   ____       
 | ||  _ \/ __| __/ _  | | | |  _ \ / _  |      
 | || | | \__ \ || (_| | | | | | | | (_| |_ _ _ 
|___|_| |_|___/\__\__,_|_|_|_|_| |_|\__, (_|_|_)
                                    |___/       

$nocolor"

done=True
if [ "$(whoami)" == "root" ];then
    echo -e $yellow "[!] Don't change name of apktoolx file. Put apktoolx near installing file in one directory!"
    echo -e $light_blue "[*] Updating repository..."
    ping 8.8.8.8 -c 5 &> /dev/null
    if [ $? != 0 ];then
        echo -e $light_red "[-] Can not update repository!\n [-] No internet connection!\n"
        exit 1
    else
        apt update -y &> /dev/null
        if [ $? -eq 0 ];then
            echo -e $light_green "[✔] Repository updated successfully!\n"
        else
            echo -e $light_red "[-] Can not update repository!\n"
        fi
    fi

    echo -e $light_blue "[*] Checking Apktool..."
    which apktool &> /dev/null
    if [ $? -eq 0 ];then
         apkver=`apktool --version`
         echo -e $light_green "[✔] Apktool $apkver founded!\n"
    else
         echo -e $yellow "[!] Not founded!"
         echo -e $light_blue "[*] Installing Apktool..."
         apt install apktool -y &> /dev/null
         if [ $? -eq 0 ];then
            echo -e $light_green "[✔] Installing complete!\n"    
         else
            echo -e $light_red "[-] Installing failed!\n"
            done=False
         fi
    fi

    echo -e $light_blue "[*] Checking Apksigner..."
    which apksigner &> /dev/null
    if [ $? -eq 0 ];then
        apksign=`apksigner --version`
        echo -e $light_green "[✔] Apksigner $apksign founded!\n"
    else
         echo -e $yellow "[!] Not founded!"
         echo -e $light_blue "[*] Installing Apksigner..."
         apt install apksigner -y &> /dev/null
         if [ $? -eq 0 ];then
            echo -e $light_green "[✔] Installing complete!\n"    
         else
            echo -e $light_red "[-] Installing failed!\n"
            done=False
         fi     
    fi

    echo -e $light_blue "[*] Checking required libraries..."
    ls /usr/share/doc | grep lib32stdc++6 &> /dev/null
    if [ $? -eq 0 ];then
         echo -e $light_green "[✔] lib32stdc++6 founded!"
    else    
         echo -e $yellow "[!] lib32stdc++6 not founded!"
         echo -e $light_blue "[*] Installing lib32stdc++6..."
         apt install lib32stdc++6 -y &> /dev/null
         if [ $? -eq 0 ];then
            echo -e $light_green "[✔] Installing complete!\n"    
         else
            echo -e $light_red "[-] Installing failed!\n"
            done=False
         fi
    fi

    ls /usr/share/doc | grep lib32ncurses6 &> /dev/null
    if [ $? -eq 0 ];then
        echo -e $light_green "[✔] lib32ncurses6 founded!"
    else 
        echo -e $yellow "[!] lib32ncurses6 not founded!"
        echo -e $light_blue "[*] Installing lib32ncurses6..."
        apt install lib32ncurses5 -y &> /dev/null
        if [ $? -eq 0 ];then
            echo -e $light_green "[✔] Installing complete!\n"    
        else
            echo -e $light_red "[-] Installing failed!\n"
            done=False
        fi
    fi

    ls /usr/share/doc | grep lib32z1 &> /dev/null
    if [ $? -eq 0 ];then
        echo -e $light_green "[✔] lib32z1 founded!\n"
    else 
        echo -e $yellow "[!] lib32z1 not founded!"
        echo -e $light_blue "[*] Installing lib32z1..."
        apt install lib32z1 -y &> /dev/null
        if [ $? -eq 0 ];then
            echo -e $light_green "[✔] Installing complete!\n"
        else
            echo -e $light_red "[-] Installing failed!\n$nocolor"    
            done=False
        fi
    fi
    
    #installing required files
    echo -e $light_blue "[*] Installing required files..."
    wd=$(pwd)
    mkdir /opt/apktoolx 2> /dev/null ; cd /opt/apktoolx
    if [ ! -d certificate-keystore ];then
        git clone https://github.com/GoldenEagle-BlackHat/certificate-keystore.git > /dev/null 2>> /var/log/apktoolx.log
        cp -p certificate-keystore/*.pem certificate-keystore/*.pk8 .
        if [ "$?" != "0" ];then
            done=False
            echo -e "${light_red} [-] An error occurred!\n$yellow [!] See logs in /var/log/apktoolx.log${nocolor}\n"
        else
            echo -e $light_green "[✔] Required files installed successfully!\n"
        fi
    else
        echo -e $yellow "[!] Directory exist!\n"
    fi
    
    cd $wd

    if [ $done == True ];then
        #Add apktoolx to /usr/bin
        echo -e $light_blue "[*] Adding apktoolx to /usr/bin...\n"
        if [ -f apktoolx ];then
            chmod 755 apktoolx
            cp -p apktoolx /usr/bin
            if [ "$?" != "0" ];then
                echo -e $light_red "[-] Copy failed!\n" 
            fi
        else
            echo -e $light_red "[-] The file can't be found!\n"
            echo -e $light_red"\n[-] Installing not completed!\n"
            exit 1
        fi
        echo -e $light_green "\n[✔] Installing completed successfully!\n"
    else
        echo -e $light_red"\n[-] Installing not completed!\n"
    fi
else
    echo -e $yellow "[!] your not superuser! Privilage your access.\n$nocolor"
fi
