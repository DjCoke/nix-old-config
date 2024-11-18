{ inputs
, outputs
, lib
, config
, userConfig
, pkgs
, ...
}: {
  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  # Register flake inputs for nix commands
  nix.registry = lib.mapAttrs (_: flake: { inherit flake; }) (lib.filterAttrs (_: lib.isType "flake") inputs);

  # Add inputs to legacy channels
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  # Nix settings
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "erwin" # I was thinking to dynamically set it to "${userConfig.name}", but that would be a security flaw
    ]; # Set users that are allowed to use the flake command
  };
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  # Boot settings
  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [ "quiet" "splash" ];
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
    loader.timeout = 0;
    plymouth.enable = true;
  };

  # Networking
  networking.networkmanager.enable = false;

  # Timezone
  time.timeZone = "Europe/Amsterdam";

  # Internationalization
  # Standaardlanguage en locale
  i18n.defaultLocale = "nl_NL.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # PATH configuration
  environment.localBinInPath = true;

  # Disable CUPS printing
  services.printing.enable = false;

  # Enable devmon for device management
  services.devmon.enable = true;

  # The programs.nix-ld.enable option in NixOS enables nix-ld, a compatibility tool that
  # allows you to run dynamically linked binaries that are not built using Nix.
  # This is particularly useful on NixOS, where the filesystem layout is different from standard
  # Linux distributions, often causing binaries not managed by Nix to fail due
  # to missing shared libraries.
  programs.nix-ld.enable = true;

  # decrypt ${userConfig.name}-password to /run/secrets-for-users so it can be used to create the user
  sops.secrets."${userConfig.name}-password".neededForUsers = true;
  # Required for password to be set via sops during system activation!
  users.mutableUsers = false;

  # User configuration
  users.users.${userConfig.name} = {
    description = userConfig.fullName;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "audio" "video" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./files/keys/id_${userConfig.name}.pub)
    ];
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."${userConfig.name}-password".path;
    shell = pkgs.zsh;
  };

  # Set User's avatar
  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp ${userConfig.avatar} /var/lib/AccountsService/icons/${userConfig.name}

    touch /var/lib/AccountsService/users/${userConfig.name}

    if ! grep -q "^Icon=" /var/lib/AccountsService/users/${userConfig.name}; then
      if ! grep -q "^\[User\]" /var/lib/AccountsService/users/${userConfig.name}; then
        echo "[User]" >> /var/lib/AccountsService/users/${userConfig.name}
      fi
      echo "Icon=/var/lib/AccountsService/icons/${userConfig.name}" >> /var/lib/AccountsService/users/${userConfig.name}
    fi
  '';

  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # System packages
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [ pip virtualenv ]))
    awscli2
    age
    brave
    delta
    dig
    docker-compose
    eza
    fd
    gcc
    glib
    gnumake
    jq
    killall
    kubectl
    nh
    pipenv
    ripgrep
    unzip
    go
    nodejs
    cargo
    sops
  ];

  # Docker configuration
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.rootless.setSocketVariable = true;

  # Zsh configuration
  programs.zsh.enable = true;

  # Fonts configuration
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" "JetBrainsMono" ]; })
    roboto
  ];

  # Additional services
  services.locate.enable = true;
  services.locate.localuser = null;

  # OpenSSH daemon
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

}
