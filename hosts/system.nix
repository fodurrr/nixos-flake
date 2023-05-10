# This is basicly the same as the default configuration.nix file
# but only those options are included here which are common for all hosts.

{ config, pkgs, lib, inputs, user, ... }:

{
  nixpkgs.system = "x86_64-linux";

  networking = {
    hostName = "hp-laptop-nixos"; # Define your hostname.
    networkmanager.enable = true;
  };

  # Boot options are defined in the hosts (ex.in the laptop/wayland/default.nix file)


  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };


  
  security.rtkit.enable = true;
  services = {
    openssh = {
      enable = true;
    };
  };
  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    shells = with pkgs; [ fish ];
    systemPackages = with pkgs; [
      git
      neovim
      wget
      neofetch
      exa
      ranger
      killall
      socat
    ];
  };
  services.dbus.enable = true;

  nix = {
    settings = {
      auto-optimise-store = true; # Optimise syslinks
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;

  system = {
    autoUpgrade = {
      enable = false;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "23.05";
  };
}
