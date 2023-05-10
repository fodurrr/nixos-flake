# NixOs Flake setup

These steps are for a fresh installation. Not dual boot

## Partitioning the disk

You have to be root to use parted. You can use `sudo` or `sudo su -` to become root

```bash
# Create partition tables
parted /dev/sdc mklabel gpt # or 'msdos' for legacy boot
parted /dev/sdc -- mkpart primary 1MiB -8GiB (512MiB -8GiB for uefi)
parted /dev/sdc -- mkpart primary linux-swap -8GiB 100%

# Extra partitions for UEFI
parted /dev/sdc -- mkpart ESP fat32 1Mib 512MiB
parted /dev/sdc -- set 3 esp on

# Create the filesystems
mkfs.ext4 -L nixos /dev/sdc1
mkswap -L swap /dev/sdc2
# extra for UEFI 
mkfs.fat -F 32 -n boot /dev/sdc3
```

## Mounting the drives

```bash
# Mount the partitions
mount /dev/disk/by-label/nixos /mnt

# Extra for UEFI */
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# Switch the swap on
swapon /dev/sdc2
```

## Prepare the installation ISO 

Prepare a 64-bit nixos [minimal iso image](https://channels.nixos.org/nixos-22.11/latest-nixos-minimal-x86_64-linux.iso) 

## Generate a basic configuration 

```bash
nixos-generate-config --root /mnt
```
## Clone the repository locally 

```bash
nix-shell -p git
git clone https://github.com/fodurrr/nixos-flakes.git /mnt/etc/nixos/Flakes 

cd /mnt/etc/nixos/Flakes/

nix develop --extra-experimental-features nix-command --extra-experimental-features flakes 

# copy `hardware-configuration.nix` from /mnt/etc/nixos to /mnt/etc/nixos/Flakes/hosts/laptop/hardware-configuration.nix

cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/Flakes/hosts/laptop/hardware-configuration.nix
```
9. Select Window Manager

10. Select a theme 

11. Perform install
```bash
nixos-install --no-root-passwd --flake .#laptop
```

12. Reboot 
```bash
reboot
```

13. Enjoy it!

