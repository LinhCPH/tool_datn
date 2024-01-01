#!/bin/bash

#--------Global variables------------
checkSoftwareFlag=0
discover=$PWD
duration=$((end_time - start_time))
hours=$((duration / 3600))
minutes=$(( (duration % 3600) / 60 ))
seconds=$((duration % 60))
time="${hours} h ${minutes} p ${seconds} s"

export discover


#--------Global variables------------
#----------------------HEADER-----------------------------------------------------------------------------
headerSetting(){
        clear
        echo -e "++--------------------------------------------------------++"
        echo -e '\e[1m  ____  __  ___      _______ __ __  ___  \e[1m'
	echo -e	'      |  _ \/_ |/ _ \  /\|__   __/_ /_ |/ _ \ \e[1m'
	echo -e	'      | |_) || | (_) |/  \  | |   | || | | | |\e[1m'
	echo -e	'      |  _ < | |\__, / /\ \ | |   | || | | | |\e[1m'
	echo -e	'      | |_) || |  / / ____ \| |   | || | |_| |\e[1m'
	echo -e	'      |____/ |_| /_/_/    \_\_|   |_||_|\___/ \e[1m'
        echo ""
        echo "                                      Version: 1.0"

        echo ""
        echo -e "Author: \e[31mChau Phan Hoai Linh\e[0m"

        echo ""
        echo ""
        echo "Tool do an tot nghiep D19."
        echo ""
        echo -e "++--------------------------------------------------------++"
        echo ""
        echo ""

}
export -f headerSetting
headerSettingAfter(){
       clear
        echo -e "++--------------------------------------------------------++"
        echo -e '\e[1m  ____  __  ___      _______ __ __  ___  \e[1m'
	echo -e	'      |  _ \/_ |/ _ \  /\|__   __/_ /_ |/ _ \ \e[1m'
	echo -e	'      | |_) || | (_) |/  \  | |   | || | | | |\e[1m'
	echo -e	'      |  _ < | |\__, / /\ \ | |   | || | | | |\e[1m'
	echo -e	'      | |_) || |  / / ____ \| |   | || | |_| |\e[1m'
	echo -e	'      |____/ |_| /_/_/    \_\_|   |_||_|\___/ \e[1m'
        echo ""
        echo "                                      Version: 1.0"

        echo ""
        echo -e "Author: \e[31mChau Phan Hoai Linh\e[0m"

        echo ""
        echo ""
        echo "Tool do an tot nghiep D19."
        echo ""
        echo -e "++--------------------------------------------------------++"
        echo ""
        echo ""
}
export -f headerSettingAfter

optionFunction(){
    echo -e "${BLUE}Ban muon thoat khong?${NC}"
    echo -e "${BLUE}Xem bao cao ${NC}"   
    echo -e "${BLUE}Xem bao cao chi tiet${NC}"
    
}
export -f optionFunction
draw_score() {
  local score=$1
  local index=$2
  local color=""
  local score_color="\e[32m"  
  local temp1=$((score*50))
  local temp2=$((index*10))
  if [ $temp1 -eq 0 ] && [ $temp2 -eq 0 ]; then
	  temp1=1
	  temp2=1
  fi
  local rounded_score=$((temp1/temp2))

  if [ $rounded_score -lt 15 ]; then
    color="\e[32m"  
  elif [ $rounded_score -ge 15 ] && [ $rounded_score -lt 35 ]; then
    color="\e[33m"  
  else
    color="\e[31m" 
  fi
    printf "${score_color}	Score: \e[1m${color}$rounded_score\e[0m\n"
   #ve
   for i in $(seq 1 $((4))); do
    if [[ $i -eq 1 || $i -eq 4 ]]; then
	      for j in $(seq 1 $((50))); do
		    printf "${color}*\e[0m"
	      done
    else
	      for j in $(seq 1 $((50))); do
		if [ $j -le $rounded_score ]; then
		    printf "${color}*\e[0m"
	        elif [[ $j -eq 50 ]]; then
		    printf "${color}*\e[0m"
	        else
		    echo -n " "  
	      fi
      	      done
    	 fi
     echo
  done
  
}

get_vulns(){
    if [ ! -f "Vul_Scan/vuln_$target.txt" ]; then
        exit 1
    fi
    result=""
    while IFS= read -r cve; do
        IFS= read -r severity
        result+="\e[32m$cve ($severity), \e[0m"
    done < "Vul_Scan/vuln_$target.txt"
    
    echo "$result"
}



#----------------------REPORT-----------------------------------------------------------------------------
    report(){
    headerSetting
    echo -e "\e[33mDang tinh toan ket qua.....\e[0m"
    sleep 3
    headerSettingAfter
    echo -e "\e[33m-------------------------~~~~~~~~~~-------------------------\e[0m"
    echo -e "\e[32m	IP: $target\e[0m"
    echo -e "\e[32m	$version\e[0m"
    echo -e "\e[32m	Thoi gian quet: $time\e[0m"
    vulns=$(get_vulns)
    echo -e "\e[32m	Lo hong tim thay: $vulns\e[0m" 
    echo ""
    echo ""
    echo ""
    draw_score $score $index
    echo ""
    echo ""
    echo ""
    echo -e "\e[33m-------------------------~~~~~~~~~~-------------------------\e[0m"
    echo ""
    echo ""
    echo ""
    echo "Bạn muốn thoát không? (Y)"
    read response
    if [ "$response" == "y" ]; then
	    exit 0
    else
        sleep 100
    fi
    }
    
    while true; do report; done
  	
	
    
    
    
    
    
    
    
    
    
    
