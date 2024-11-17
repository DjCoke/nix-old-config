{ ... }: {
  # Install bat via home-manager module

  # TODO: see if we need to add this?

  # home.file.".config/bat/config".text = ''
  #    --theme="Dracula"
  #
  #    # Show line numbers, Git modifications and file header (but no grid)
  #    --style="numbers,changes,header"
  #  '';


  programs.bat = {
    enable = true;
    catppuccin.enable = true;
  };
}
