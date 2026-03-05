#! /bin/sh
echo -e "1.Update \n2.Upgrade \n3.Autoclean \n4.Autoremove \n5.All"
read -p "Choose command number: " command

case $command in
        "1")
                sudo apt-get update
                ;;
        "2")
                sudo apt-get full-upgrade
                ;;
        "3")
                sudo apt autoclean
                ;;
        "4")
                sudo apt autoremove
                ;;
        "5")
                sudo apt-get update && sudo apt-get upgrade
                sudo apt autoclean && sudo apt autoremove
                ;;
        *)
                read -p "Choose command number: " command
                ;;
esac
