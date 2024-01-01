#!/bin/bash


BLUE='\033[0;34m'
NC='\033[0m'
target=0

echo -e "${BLUE}Domain Recon${NC}"

# Tên tệp lưu kết quả
result_file_do="domainresult.txt"



run_nmap_command() {
    local command=$1
    echo "Running Nmap command: ${BLUE}$command${NC}"
    eval $command | tee -a $result_file  # Chạy lệnh và lưu kết quả vào tệp
}
#----------------------------CHON CHUC NANG -------------------------------------
optionScan(){
   		echo "1. Quet Subdomains"
                echo "2. Thiet lap IP muc tieu"
		echo "99. Back"
	  }


#----------------------------CHON CHUC NANG QUET-------------------------------------
if [ "$target" = "0" ]; then
       echo -n "Nhap IP muc tieu [IP hoac domain]: "
       read target
    fi
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
	    echo -e "Nhap ten domain: \e[34m$target\e[0m"
            echo -e "\e[1mDang tim kiem subdomain...\e[0m"
            knockpy $target
	    echo "\e[1mBan co the xem lai ket qua trong file $result_file_do\e[0m"
	    ;;

        
       99) 
             f_main;;
              
       *) echo "Lua chon khong hop le. Vui long nhap lai.";;
        esac
    done
done

