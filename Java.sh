#!/bin/bash

if [ -e "/roms/tools/j2me/Java.sh" ] ; then
    JAVA_FOLDER="/roms/tools/j2me"
elif [ -e "/roms2/tools/j2me/Java.sh" ] ; then
    JAVA_FOLDER="/roms2/tools/j2me"
else
    echo "Неверная папка скрипта"
	exit 1
fi


# Устанавливаем расположение файла журнала
LOG_FILE="setup_log_$(date +"%Y-%m-%d_%H-%M-%S").txt"

# Функция для записи сообщений в файл журнала
log_message() {
  local timestamp
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] $1" >> "$JAVA_FOLDER/$LOG_FILE"
}

CUR_TTY=/dev/tty0
$ESUDO chmod 666 $CUR_TTY

# Регистрируем начальное сообщение в файле журнала
log_message "Запуск скрипта"
echo "Запуск скрипта"

# Ищем зависимости
if [ -e "/roms/tools/j2me/dep/freej2me_libretro.so" ] && [ -e "/roms/tools/j2me/dep/freej2me_libretro.info" ] && [ -e "/roms/tools/j2me/dep/freej2me-lr.jar" ] && [ -e "/roms/tools/j2me/dep/asound.conf" ]; then
    log_message "Найдены зависимости на карте 1"
	echo "Найдены зависимости на карте 1"
	sleep 3
	DEP_FOLDER="/roms/tools/j2me/dep"
	JAVA_FOLDER="/roms/tools/j2me"
else
    log_message "Не найдены зависимости на карте 1"
	echo "Не найдены зависимости на карте 1"
	sleep 3
fi

if [ -e "/roms2/tools/j2me/dep/freej2me_libretro.so" ] && [ -e "/roms2/tools/j2me/dep/freej2me_libretro.info" ] && [ -e "/roms2/tools/j2me/dep/freej2me-lr.jar" ] && [ -e "/roms2/tools/j2me/dep/asound.conf" ]; then
    log_message "Найдены зависимости на карте 2"
	echo "Найдены зависимости на карте 2"
	sleep 3
	DEP_FOLDER="/roms2/tools/j2me/dep" 
	JAVA_FOLDER="/roms2/tools/j2me"
else
    log_message "Не найдены зависимости на карте 2"
	echo "Не найдены зависимости на карте 2"
	sleep 3
    #exit 1
fi

log_message "$DEP_FOLDER"

# Сканируем и создаем целевые папки, если это необходимо
DEST_FOLDER="/home/ark/.config/retroarch/cores"
if [ ! -d "$DEST_FOLDER" ]; then
    log_message "Целевая папка не найдена, создание..."
    sudo mkdir -p "$DEST_FOLDER"
fi

if [ -e "/roms/tools/j2me/dep/freej2me_libretro.so" ] && [ -e "/roms/tools/j2me/dep/freej2me_libretro.info" ] && [ -e "/roms/tools/j2me/dep/freej2me-lr.jar" ] && [ -e "/roms/tools/j2me/dep/asound.conf" ]; then 
BIOS_FOLDER="/roms/bios"; 
elif [ -e "/roms2/tools/j2me/dep/freej2me_libretro.so" ] && [ -e "/roms2/tools/j2me/dep/freej2me_libretro.info" ] && [ -e "/roms2/tools/j2me/dep/freej2me-lr.jar" ] && [ -e "/roms2/tools/j2me/dep/asound.conf" ] ;
then BIOS_FOLDER="/roms2/bios";
fi

log_message "$BIOS_FOLDER"

if [ ! -d "$BIOS_FOLDER" ]; then
    log_message "Целевая папка не найдена, создание..."
    sudo mkdir -p "$BIOS_FOLDER"
fi

# Установка пакета java-common.deb
log_message "Установка пакета java-common.deb"
echo "Установка пакета java-common.deb"
sleep 3
sudo dpkg -i "$DEP_FOLDER/java-common.deb" >> "$LOG_FILE" 2>&1

# Регистрируем сообщение о перемещении файлов в папку RetroArch в файле журнала
log_message "Перемещение файлов в папку с RetroArch"
echo "Перемещение файлов в папку с RetroArch"
sleep 3
sudo mv "$DEP_FOLDER/freej2me_libretro.so" "$DEST_FOLDER/freej2me_libretro.so"
sudo mv "$DEP_FOLDER/freej2me_libretro.info" "$DEST_FOLDER/freej2me_libretro.info"

# Регистрируем сообщение о перемещении из файла freej2me-lr.jar в папку /roms/bios в файле журнала
log_message "Перемещение файла freej2me-lr.jar в /roms/bios и roms2/bios"
echo "Перемещение файла freej2me-lr.jar в /roms/bios и roms2/bios"
sleep 3
log_message "$BIOS_FOLDER"
sudo mv "$DEP_FOLDER/freej2me-lr.jar" "$BIOS_FOLDER/freej2me-lr.jar"

# Записываем сообщение об установке пакета JDK в файл журнала
log_message "Установка пакета JDK"
echo "Установка пакета JDK"
sleep 3
sudo dpkg -i "$DEP_FOLDER/zulu21.32.17-ca-jdk21.0.2-linux_arm64.deb" >> "$LOG_FILE" 2>&1

# Копирование файла конфигурации звука
log_message "Копирование файла asound.conf"
echo "Копирование файла asound.conf"
sleep 3
if [ -e "/roms/tools/j2me/dep/asound.conf" ] ; then 
sudo mv "$DEP_FOLDER/asound.conf" "/roms/tools/PortMaster/libs/" ;
elif [ -e "/roms2/tools/j2me/dep/asound.conf" ] ; then
sudo mv "$DEP_FOLDER/asound.conf" "/roms2/tools/PortMaster/libs/"
fi

# Удаление файлов zulu21.32.17-ca-jdk21.0.2-linux_arm64.deb и java-common.deb
log_message "Удаление файлов zulu21.32.17-ca-jdk21.0.2-linux_arm64.deb и java-common.deb"
echo "Удаление файлов zulu21.32.17-ca-jdk21.0.2-linux_arm64.deb и java-common.deb"
sleep 3
log_message "$DEP_FOLDER"
sudo rm -f "$DEP_FOLDER/zulu21.32.17-ca-jdk21.0.2-linux_arm64.deb"
sudo rm -f "$DEP_FOLDER/java-common.deb"

# Удаление папки dep из j2me
log_message "Удаление папки dep в j2me"
echo "Удаление папки dep в j2me"
sleep 3
log_message "$DEP_FOLDER"
sudo rm -rf "$DEP_FOLDER"


# Добавление настроек в файл es_systems.cfg
echo "Добавление настроек в файл es_systems.cfg"
sleep 3
if [ "$DEP_FOLDER" = "/roms/tools/j2me/dep" ]; then 
  CONFIG_LINES="<system>\n    <name>J2ME</name>\n    <fullname>Java 2 MicroEdition</fullname>\n    <path>/roms/j2me</path>\n    <extension>.jar</extension>\n    <command>cp \"/roms/tools/PortMaster/libs/asound.conf\" \"/etc/\" cp \"/roms2/tools/PortMaster/libs/asound.conf\" \"/etc/\" sudo perfmax %GOVERNOR%; nice -n -19 /usr/local/bin/retroarch -L /home/ark/.config/retroarch/cores/freej2me_libretro.so %ROM%; sudo perfnorm</command>\n    <platform>j2me</platform>\n    <theme>j2me</theme>\n   <emulators>\n          <emulator name=\"retroarch\">\n       <cores>\n         <core>freej2me</core>\n         </cores>\n          </emulator>\n       </emulators>\n  </system>"
elif [ "$DEP_FOLDER" = "/roms2/tools/j2me/dep" ]; then 
  CONFIG_LINES="<system>\n    <name>J2ME</name>\n    <fullname>Java 2 MicroEdition</fullname>\n    <path>/roms2/j2me</path>\n    <extension>.jar</extension>\n    <command>cp \"/roms/tools/PortMaster/libs/asound.conf\" \"/etc/\" cp \"/roms2/tools/PortMaster/libs/asound.conf\" \"/etc/\" sudo perfmax %GOVERNOR%; nice -n -19 /usr/local/bin/retroarch -L /home/ark/.config/retroarch/cores/freej2me_libretro.so %ROM%; sudo perfnorm</command>\n    <platform>j2me</platform>\n    <theme>j2me</theme>\n   <emulators>\n          <emulator name=\"retroarch\">\n       <cores>\n         <core>freej2me</core>\n         </cores>\n          </emulator>\n       </emulators>\n  </system>"
fi
sudo sed -i "/<\/systemList>/i $CONFIG_LINES" /etc/emulationstation/es_systems.cfg >> "$LOG_FILE" 2>&1


# Записываем сообщение о перезагрузке системы в файл журнала
log_message "Перезагрузка системы"
echo "Перезагрузка системы"
sleep 7
#sudo reboot >> "$LOG_FILE" 2>&1

#touch "${JAVA_FOLDER}/{$LOG_FILE}"
sudo systemctl restart emulationstation
printf "\033c" >> $CUR_TTY

