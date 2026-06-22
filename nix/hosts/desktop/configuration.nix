{ pkgs, inputs, hostname, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/d41b96be-10b5-4d3b-ac04-6d81ec4323b4";
    fsType = "ext4";
    options = [ "nofail" "x-systemd.autmount" ];
  };

  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true;
  
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    open = true;
    nvidiaSettings = true;
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = true;

  services.openssh.enable = true;
  services.udisks2.enable = true;
  services.flatpak.enable = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gnome.evolution-data-server.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd start-hyprland --remember --remember-session --user-menu";
      };
      initial_session = {
        user = username;
        command = "start-hyprland";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  programs.kdeconnect.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    description = "Casey";
    shell = pkgs.nushell;
    hashedPasswordFile = "/etc/nixos/secrets/${username}-password.hash";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
      "dialout"
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  environment.systemPackages = 
    (import ../../packages/core.nix { inherit pkgs inputs; })
    ++
    (with pkgs; [
      # compilers
      gcc

      # gui apps
      ghostty
      protonup-qt

      # flakes
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

      # Noctalia with calendar support
      (inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        calendarSupport = true;
      })
    ]);

  systemd.user.services.vicinae = {
    description = "Vicinae";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${inputs.vicinae.packages.${pkgs.system}.default}/bin/vicinae";
      Environment = "USE_LAYER_SHELL=1";
      Restart = "on-failure";
    };
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "zen-browser";
    TERMINAL = "ghostty";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    GTK_USE_PORTAL = "1";
  };

  system.stateVersion = "25.05";
}

