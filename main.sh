#!/bin/bash

#--------Global variables------------
checkSoftwareFlag=0
discover=$PWD
target=0
domain_name=0
yourOption=0
start_time=0
end_time=0


export discover
export target
export domain_name
export yourOption
export start_time
export end_time

#--------Global variables------------
#----------------------HEADER-----------------------------------------------------------------------------
headerSetting(){
        clear
        echo "++--------------------------------------------------------++"
        echo -e '\e[1m ____  __  ___      _______ __ __  ___  \e[1m'
	echo -e	     '|  _ \/_ |/ _ \  /\|__   __/_ /_ |/ _ \ \e[1m'
	echo -e	     '| |_) || | (_) |/  \  | |   | || | | | |\e[1m'
	echo -e	     '|  _ < | |\__, / /\ \ | |   | || | | | |\e[1m'
	echo -e	     '| |_) || |  / / ____ \| |   | || | |_| |\e[1m'
	echo -e	     '|____/ |_| /_/_/    \_\_|   |_||_|\___/ \e[1m'
        echo ""
        echo "                                      Version: 1.0"

        echo ""
        echo -e "Author: \e[31mChau Phan Hoai Linh\e[0m"

        echo ""
        echo ""
        echo "Tool do an tot nghiep D19."
        echo ""
        echo "++--------------------------------------------------------++"
        echo ""
        echo ""

}
export -f headerSetting
headerSettingAfter(){
        clear
        echo "++--------------------------------------------------------++"
        echo -e '\e[1m ____  __  ___      _______ __ __  ___  \e[1m'
	echo -e	     '|  _ \/_ |/ _ \  /\|__   __/_ /_ |/ _ \ \e[1m'
	echo -e	     '| |_) || | (_) |/  \  | |   | || | | | |\e[1m'
	echo -e	     '|  _ < | |\__, / /\ \ | |   | || | | | |\e[1m'
	echo -e	     '| |_) || |  / / ____ \| |   | || | |_| |\e[1m'
	echo -e	     '|____/ |_| /_/_/    \_\_|   |_||_|\___/ \e[1m'
        echo ""
        echo "                                      Version: 1.0"

        echo ""
        echo -e "Author: \e[31mChau Phan Hoai Linh\e[0m"

        echo ""
        echo ""
        echo "Tool do an tot nghiep D19."
        echo ""
        echo "++--------------------------------------------------------++"
        echo ""
        echo ""

}
export -f headerSettingAfter

#----------------------CHECK SOFTWARE-----------------------------------------------------------------------------
checkSoftwareInstalled(){
        echo -e "Cai dat day du cong cu co ma - \e[31mNOT OK\e[0m \e[1mben duoi"
        if command -v nmap &> /dev/null; then
          echo -e "\e[0mnmap...............\e[34m\e[1mOK\e[21m\e[0m"
        else
          echo -e "\e[0mnmap...............\e[31m\e[1mNOT OK\e[21m\e[0m"
          checkSoftwareFlag=$(($checkSoftwareFlag + 1))
        fi
 

        sleep 0.1
        if command -v python &> /dev/null; then
          echo -e "\e[0mpython.............\e[34m\e[1mOK\e[21m\e[0m"
        else
          echo -e "\e[0mpython.............\e[31m\e[1mNOT OK\e[21m\e[0m"
          checkSoftwareFlag=$(($checkSoftwareFlag + 1))
        fi


        echo ""
}

f_clean(){
	grep -v -E 'Starting Nmap|Host is up|SF|:$|Service detection performed|https' | sed '/^Nmap scan report/{n;d}' | sed 's/Nmap scan report for/Host:/g' 
}
export -f f_clean
#----------------------CHECK SOFTWARE DONE!-----------------------------------------------------------------------------
optionFunction(){
    echo -e "${BLUE}----------------------------OPTIONS------------------------------------${NC}"
    echo "1. Full Scan"
    echo "2. Custom Scan"
    echo -e "${BLUE}----------------------------OPTIONS-------------------------------------${NC}"
    
}
export -f optionFunction


#----------------------MAIN FUNCTION-----------------------------------------------------------------------------
headerSetting
checkSoftwareInstalled
#-----------------------------
if [ "$checkSoftwareFlag" -ne 0 ]; then
  echo -e "\e[31m\e[1mBan can cai dat day du cong cu de su dung tool nay\e[0m\e[21m\n"
  exit 0
fi
echo -e "\e[91m\e[1mPlease wait a moment....\e[39m\e[21m"
sleep 1
#------------------------------------

#------------------------------------



#-----------WHILE LOOP-------------------------
f_main(){
clear
while :
do
    headerSettingAfter
    optionFunction
    yourOption=0
    echo "CHOOSE YOUR OPTION: "
    while [ "$yourOption" = 0 ]; do
        read yourOption
    done
    headerSettingAfter
    
    #QUICK SCAN	
    if [ "$yourOption" = 1 ]; then
        echo "Nhap IP muc tieu: "
        read target
        # Check IP
        echo "Dang kiem tra muc tieu..."
        while true; do
	    ping -c 1 "$target" > /dev/null
	    if [ $? -eq 0 ]; then
	      echo "Thành công! Bắt đầu tiến trình quét...."
	      break
	    else
	      echo "Địa chỉ IP không chính xác hoặc không tồn tại!"
	      read -p "Nhập lại địa chỉ IP mục tiêu: " target
	    fi
	 done
	# Check IP
        clear
        headerSettingAfter  
        start_time=$(date +%s) 
        # Start quick scan
        $discover/nse.sh
    fi
    
    #CUSTOM TYPE SCAN	
    if [ "$yourOption" = 3 ]; then
    	clear
        headerSettingAfter
       echo "Che do tuy chinh!"
    fi
    
done 
 }

export -f f_main
while true; do f_main; done
