# NixOs Flake setup

> This flake setup based on [Ruixi-rebirth](https://github.com/Ruixi-rebirth/flakes) works. All credit goes to him/her.


## Simple clone and install if you have already NixOs installed

```bash	
nix-shell -p git

git clone https://github.com/fodurrr/nixos-flake.git

cd nixos-flake

nix develop --extra-experimental-features nix-command --extra-experimental-features flakes

sudo nixos-rebuild switch --flake .#laptop
```

## Fresh installation. Not dual boot

Prepare and boot into a 64-bit nixos [minimal iso image](https://channels.nixos.org/?prefix=nixos-unstable/latest-nixos-minimal-x86_64-linux.iso).
Currently this is version 23.05


### Partitioning the disk

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

### Mounting the drives

```bash
# Mount the partitions
mount /dev/disk/by-label/nixos /mnt

# Extra for UEFI */
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# Switch the swap on
swapon /dev/sdc2
```

### Generate a basic NixOS configuration files 

```bash
nixos-generate-config --root /mnt
```

### Clone and install NixOS via flake.

```bash
# Start a new shell with git
nix-shell -p git
git clone https://github.com/fodurrr/nixos-flake.git /mnt/etc/nixos/Flakes 

cd /mnt/etc/nixos/Flakes/

# Start a new shell with flakes environment
nix develop --extra-experimental-features nix-command --extra-experimental-features flakes 

cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/Flakes/hosts/laptop/hardware-configuration.nix

nixos-install --no-root-passwd --flake .#laptop

reboot
```

### Enjoy it!

