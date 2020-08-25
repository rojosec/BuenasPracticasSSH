#!/bin/bash
# Autor: ErickWhiteHat

green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"


# TITULO SCRIPT
clear
echo -e "${green}----------------------------------------"
echo -e "\t BUENAS PRACTICAS SSH"
echo -e "----------------------------------------${end}"

#EXPRESIONES REGULARES
NUMEROS=^[0-9]
LETRAS=^[a-Z]*$

# FUNCION DE ANIMACION DE CARGA
function Loading(){
gui=("-" "-" "-")

for n in ${gui[@]}; do
    tput civis; sleep 1
    echo "$n"
    
done
}

#VERIFICACION DE NIVEL DE USUARIO
if [ "$(id -u)" = 0 ]; then

    # VERIFICACIÓN DE SERVICIO SSH
    echo -e "\t VERIFICANDO EL SERVICIO"

    if [ -d /etc/ssh ]; then
        Loading;sleep 2
        clear
        echo -e "\t ${green}SERVICIO DISPONIBLE ${end} \n";sleep 2
    else
        Loading
        clear
        echo -e "\t ${red} NO EXISTE EL SERVICIO ${end} \n"
        read -p "¿Desea instalar el servicio SSH? [S/n]: " OPCION
        
        case $OPCION in
            s|S)
                apt-get install openssh-server -y > /dev/null 2>&1
            ;;
            n|N)
                exit 0
            ;;
        esac
        
        Loading
    fi 
else
    clear
    echo -e "${red}\n \t EJECUTE EL SCRIPT COMO ROOT \n${end}"
    exit 1
fi

# FUNCIONES DE BUENAS PRACTICAS

function Constrasena(){
    echo -e "${green}[1] CONTRASEÑA SSH \n ${end}"
    passwd sshd ; tput cnorm
    echo  -e "\n"
}


function CambiodePuerto(){
    echo -e "${green}[2] PUERTO (por defecto esta establecido el #22) \n ${end}" 
    read -p "# " PUERTO
    
    while [[ $PUERTO -eq "" || $PUERTO =~ $LETRAS || $PUERTO -le 22 || $PUERTO -le 1024 ]]; do
       read -p "# " PUERTO
    done

    if [[ $PUERTO != $LETRAS || $PUERTO != "" ]];then
        echo -e "#Nuevo Puerto \nPort $PUERTO" >> /etc/ssh/sshd_config 
        echo -e "${yellow}[i]${end} Nuevo puerto => ${yellow}$PUERTO${end}"
        sleep 2
    fi  
    echo -e "\n"
}

function DesactivarAccesoRoot(){
    echo -e "${green}[3] Desactivar el acceso como root. \n${end}"
    echo -e "#Desactivar el acceso como root \nPermitRootLogin no" >> /etc/ssh/sshd_config 
    echo -e "${yellow}[i]${end} Desactivado \n"
    sleep 2
}

function AutenticaciondeLlaves(){
    echo  -e "${green}[4] Autenticación mediante llave publica y privada\n${end}"
    echo -e "${yellow}[i]${end} Generando Llaves"
    Loading
    ssh-keygen
    echo -e "\n"
}

function LimiteUsuarios(){
    echo -e "${green}[5] Limitación de acceso por usuarios.\n${end}"
    read -p "Desea limitar acceso a usuarios [S/n]: " ACCESO 

case $ACCESO in
    s|S) 
        # INGRESO DE USUARIOS
        read -p "¿Cuantos usuarios desea limitar? " USUARIOS 

        # VALIDACION DE USUARIOS
        while [[ $USUARIOS -le 0 || $USUARIOS = "" || $USUARIOS =~ $LETRAS ]]; do
            read -p "¿Cuantos usuarios desea limitar? " USUARIOS
        done

        # ARREGLO PARA ALMACENAR USUARIOS
        declare -a LIMITE=()
        declare -a STORAGE=()

        # COMPARACION E 
        if [[ $USUARIOS != $LETRAS && $USUARIOS != 0 && $USUARIOS != "" ]];then
            for u in $(seq 1 $USUARIOS);do
               read -p "Usuario #$u: " USUARIO
               LIMITE+=($USUARIO)
            done
        # ITERACIÓN DEL ARREGLO LIMITE
            for n in "${LIMITE[@]}";do
                STORAGE+=($n)
            done
            echo -e "#Limitación de acceso por usuarios." >> /etc/ssh/sshd_config
            echo -n "AllowUsers ${STORAGE[@]}" >> /etc/ssh/sshd_config
        fi
    ;;

    n|N)
       exit 0
    ;;

esac

}

function ReiniciarServicioSSH(){
    systemctl restart ssh
    exit 0
}

Constrasena
CambiodePuerto
DesactivarAccesoRoot
AutenticaciondeLlaves
LimiteUsuarios
ReiniciarServicioSSH