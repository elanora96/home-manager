{ config, ... }:
let
  dotDirCustom = "${config.home.homeDirectory}/.config/zsh";
  relToDotDirCustom = ".config/zsh";
in
{
  programs.zsh = {
    enable = true;
    dotDir = dotDirCustom;
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [ "zsh-users/zsh-autosuggestions" ];
    };
  };

  nmt.script = ''
    assertFileContains home-files/${relToDotDirCustom}/.zshrc \
      'source @antidote@/share/antidote/antidote.zsh'
    assertFileContains home-files/${relToDotDirCustom}/.zshrc \
      'antidote load'
    assertFileContains home-files/${relToDotDirCustom}/.zshrc \
      "zstyle ':antidote:bundle' use-friendly-names 'yes'"
  '';
}
