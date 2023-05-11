{ config, pkgs, user, inputs, ... }:

{
  imports =
    (import ../../../modules/hardware) ++
    [
      ../hardware-configuration.nix
      ../../../modules/fonts
    ] ++ [
      ../../../modules/desktop/hyprland
    ];

  # Configure keymap in X11
  #services.xserver = {
  #  layout = "ch";
  #  xkbVariant = "";
  #};

  # Configure console keymap
  console.keyMap = "sg";

  #users.users.root.initialHashedPassword = "$6$bxcw7rtt$gxhJo1QepAxJyzIQU7XpZVKrH./Ha1Q8rlzt9HR/lbb4QVww6DWX2AKSIiRAJdmU2RptKn1b62R2Rk5ZbPIjv/";
  
  users.users.${user} = {
    #initialHashedPassword = "$6$bxcw7rtt$gxhJo1QepAxJyzIQU7XpZVKrH./Ha1Q8rlzt9HR/lbb4QVww6DWX2AKSIiRAJdmU2RptKn1b62R2Rk5ZbPIjv/";
    initialPassword= "password";
    # shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
    packages = (with pkgs; [
      # ...
    ]) ++ (with config.nur.repos;[
      # ...
    ]);
  };
  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 3;
    };
    kernelParams = [
      #"quiet"
      #"splash"
      # "nvidia-drm.modeset=1"
    ];
    consoleLogLevel = 1;
    initrd.verbose = false;
  };

   i18n.inputMethod = {
     enabled = "fcitx5";
     fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons fcitx5-table-extra fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki ];
   };

  environment = {
    systemPackages = with pkgs; [
      libnotify
      wl-clipboard
      wlr-randr
      cinnamon.nemo
      networkmanagerapplet
      wev
      wf-recorder
      alsa-lib
      alsa-utils
      flac
      pulsemixer
      imagemagick
      pkgs.sway-contrib.grimshot
      flameshot
      grim
    ];
  };

  services = {
    dbus.packages = [ pkgs.gcr ];
    getty.autologinUser = "${user}";
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  security.polkit.enable = true;
  security.sudo = {
    enable = true;
    extraConfig = ''
      ${user} ALL=(ALL) NOPASSWD:ALL
    '';
  };
  security.doas = {
    enable = false;
    extraConfig = ''
      permit nopass :wheel
    '';
  };

}
