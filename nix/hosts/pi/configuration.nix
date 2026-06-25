{ pkgs, modulesPath, hostname, username, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  networking.hostName = hostname;
  time.timeZone = "America/Chicago";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" username ];
  };

  hardware.enableRedistributableFirmware = true;

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.networkmanager.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNvlOFyYFiaJi7qFgpy0fJxqEsMAGtJZDsNZYVCYPHe casey@desktop"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true; # set false after SSH key works
      PermitRootLogin = "no";
    };
  };

  services.tailscale.enable = true;

  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  networking.firewall.allowedTCPPorts = [
    22   # SSH
    53   # DNS TCP
    80   # AdGuard setup UI, if using port 80
    3000 # AdGuard first-run UI/default admin UI
  ];

  networking.firewall.allowedUDPPorts = [
    53   # DNS UDP
    5353 # mDNS
  ];

  environment.systemPackages = 
		(import ../../packages/core.nix { inherit pkgs; })
		++ 
		(with pkgs; [
			curl
			wget
			wakeonlan
		]);

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.settings.auto-optimise-store = true;

  system.stateVersion = "25.11";
}
