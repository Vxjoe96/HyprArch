#!/bin/bash
Status = $?
#setting dns server
sudo sed -i '2 s/.*/nameserver 8.8.8.8/' etc/resolv.conf

##checking for yay
YAY=/sbin/yay
echo "Checking for yay!"
if [ -f "$YAY" ]; then 
	echo "yay was located and updating"
	yay -Suy
else 
	echo "yay was not found installing now"
	mkdir ~/git && cd ~/git
	git clone https://aur.archlinux.org/yay-git.git 
        cd yay-git
        makepkg -si --noconfirm
        cd ..
	[ $status -eq 0 ] && echo "yay was installed!" || echo "yay failed to install" && exit
fi
##nvidia drivers
echo "installing and setting up nvidia drivers"
yay -S --noconfirm linux-headers nvidia-dkms qt5-wayland qt5ct libva libva-nvidia-driver-git
sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf

fi 

exit
