#!/bin/bash -x

export DEBIAN_FRONTEND=noninteractive
USER_HOME=/home/ubuntu

mkdir -p $USER_HOME/setup && echo "step0" > $USER_HOME/setup/step0.txt
mkdir $USER_HOME/Downloads

apt-get update

# Pre-create system users (avoids tmpfiles warnings)
for u in gnome-remote-desktop speech-dispatcher colord rtkit; do
  if ! id "$u" >/dev/null 2>&1; then
    useradd -r -s /usr/sbin/nologin "$u"
  fi
done

# Prevent services starting during install
cat <<'EOF' >/usr/sbin/policy-rc.d
#!/bin/sh
exit 101
EOF
chmod +x /usr/sbin/policy-rc.d

echo "lightdm shared/default-x-display-manager select lightdm" | debconf-set-selections

echo "step1" > $USER_HOME/setup/step1.txt

# apt-get install -y lighttpd
# echo "step2" > $USER_HOME/step2.txt

apt-get install -y xserver-xorg-video-dummy lightdm
echo "step2" > $USER_HOME/setup/step2.txt

wget -O $USER_HOME/Downloads/rustdesk-1.4.5-x86_64.deb https://github.com/rustdesk/rustdesk/releases/download/1.4.5/rustdesk-1.4.5-x86_64.deb
echo "step3" > $USER_HOME/setup/step3.txt

apt-get install -f -y $USER_HOME/Downloads/rustdesk-1.4.5-x86_64.deb
rustdesk --option allow-linux-headless Y

apt-get install -y ubuntu-desktop-minimal

rm -f /usr/sbin/policy-rc.d

echo "step4" > $USER_HOME/setup/step4.txt

systemd-sysusers
systemd-tmpfiles --create

cat > /etc/X11/xorg.conf.d/10-dummy.conf << EOF
Section "Device"
  Identifier "Dummy Device"
  Driver "dummy"
  VideoRam 256000
EndSection

Section "Monitor"
  Identifier "Dummy Monitor"
  HorizSync 28.0-80.0
  VertRefresh 48.0-75.0
  Modeline "1920x1080"  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync
EndSection

Section "Screen"
  Identifier "Dummy Screen"
  Monitor "Dummy Monitor"
  Device "Dummy Device"
  DefaultDepth 24
  SubSection "Display"
    Depth 24
    Modes "1920x1080"
  EndSubSection
EndSection

Section "ServerLayout"
  Identifier "Dummy Layout"
  Screen "Dummy Screen"
EndSection
EOF

mkdir $USER_HOME/isaac-sim
wget -O $USER_HOME/Downloads/isaac-sim.zip https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone-5.1.0-linux-x86_64.zip
unzip $USER_HOME/Downloads/isaac-sim.zip -d $USER_HOME/isaac-sim/

echo "step5" > $USER_HOME/setup/step5.txt

mkdir -p $USER_HOME/miniconda3
sudo wget -O $USER_HOME/miniconda3/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
sudo bash $USER_HOME/miniconda3/miniconda.sh -b -u -p $USER_HOME/miniconda3
sudo rm -f $USER_HOME/miniconda3/miniconda.sh

echo "export PATH=$PATH:~/miniconda3/bin" >> $USER_HOME/.bashrc
source $USER_HOME/miniconda3/bin/activate
conda init --all

chmod -R 700 $USER_HOME/Downloads
setxkbmap -layout gb

echo "step6" > $USER_HOME/setup/step6.txt

reboot