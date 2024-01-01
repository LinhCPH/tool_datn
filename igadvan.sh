#!/bin/bash


BLUE='\033[0;34m'
NC='\033[0m'
target=0

echo -e "${BLUE}OS Information Recon${NC}"

# Tên tệp lưu kết quả
result_file_igad="igadvanresult.txt"
sysinfo="systeminfo.xml"

source $discover/sysinfo.sh
run_nmap_command() {
    local command=$1
    echo "Running Nmap command: ${BLUE}$command${NC}"
    eval $command | tee -a $result_file  # Chạy lệnh và lưu kết quả vào tệp
}
#----------------------------CHON CHUC NANG -------------------------------------
optionScan(){
   		echo "1. Thu thap thong tin qua SMB"
  		echo "2. Thu thap thong tin OS su dung NSE Script"
                echo "3. Thu thap thong tin NETBIOS"
		echo "4. Thu thap thong tin bang Metasploit"
		echo "5. Thu thap thong tin qua dich vu SNMP"
                echo "8. Thiet lap IP muc tieu"
		echo "99. Back"
	  }


#----------------------------CHON CHUC NANG QUET-------------------------------------
if [ "$target" = "0" ]; then
       echo -n "Nhap IP muc tieu [IP hoac domain]: "
       read target
    fi
create_sysxml    
while :
do
    
    optionScan
    echo -n "CHON CHUC NANG QUET: "
    yourOption=0
    while [ "$yourOption" = 0 ]; do
        read yourOption
    
    
    case $yourOption in        
        1)
            # smb_version payload
	    echo -e "Muc tieu: \e[34m$target\e[0m"
            echo -e "\e[1mDang thuc thi...\e[0m"
            enum4linux -a $target 
	    echo "Ban co the xem lai ket qua trong file $result_file_igad"
	    ;;

        2)
            # NSE script smb_os_discovery
            echo -e "Muc tieu: \e[34m$target\e[0m"
            echo -e "\e[1mDang thuc thi...\e[0m"
            run_nmap_command "nmap --script smb-os-discovery.nse -p 445 $target"
            echo -e "\e[1mBan co the xem lai ket qua trong file $result_file_igad\e[0m"
            ;;
        3)
            # nbtscan 
            echo -e "Muc tieu: \e[34m$target\e[0m"
            echo -e "\e[1mDang thuc thi...\e[0m"
	    nbtscan -r $target
            echo -e "\e[1mBan co the xem lai ket qua trong file $result_file_igad\e[0m"
            ;;
        4)
            # payload use auxiliary/scanner/ftp/anonymous
            echo -e "Muc tieu: \e[34m$target\e[0m"
            echo -e "\e[1mDang thuc thi...\e[0m"
            result3=$(msfconsole -q -x "use auxiliary/scanner/ftp/anonymous; set RHOST $target; run; exit" 2>&1)
	    echo "$result3" | tee "$result_file_igad"
            echo -e "\e[1mBan co the xem lai ket qua trong file $result_file_igad\e[0m"
            ;;
        5)
            # SNMP
            echo -e "Muc tieu: \e[34m$target\e[0m"
            echo -e "\e[1mDang thuc thi...\e[0m"
            snmpwalk -v2c -c public $target 1.3.6.1.2.1.1
            echo -e "\e[1mBan co the xem lai ket qua trong file $result_file_igad\e[0m"
            ;;
       99) 
             f_main;;
              
       *) echo "Lua chon khong hop le. Vui long nhap lai.";;
        esac
    done
done

