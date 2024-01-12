{ lib
, python3
, melpaBuild
, fetchFromGitHub
, substituteAll
, acm
, markdown-mode
, git
, go
, gopls
, pyright
, ruff
, tempel
, writeText
, unstableGitUpdater
, nodejs
, wmctrl
, xdotool
  # eaf-browser
, aria
  # eaf-file-manager
, fd
}:

let
  rev = "d55fef029d9a8fa529d2290f2da178dc8ff3d6f7";
  python = python3.withPackages (ps: with ps; [
    epc
    orjson
    paramiko
    rapidfuzz
    sexpdata
    six
  ]);
in
melpaBuild {
  pname = "eaf";
  version = "20240105.1940"; # 3:09 UTC

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "emacs-application-framework";
    inherit rev;
    hash = "sha256-0UGeo4I4JB95A8W870x4IS6Syh6roMomjTTNQNGbS3E=";
  };

  commit = rev;

  patches = [
    # Hardcode the python dependencies needed for lsp-bridge, so users
    # don't have to modify their global environment
    # (substituteAll {
    #   src = ./hardcode-dependencies.patch;
    #   python = python.interpreter;
    # })
  ];

  packageRequires = [
    acm
    markdown-mode
  ];

  buildInputs = [
    git
    nodejs
    wmctrl
    xdotool
    # eaf-browser
    aria
    # eaf-file-manager
    fd
  ];

  recipe = writeText "recipe" ''
    (lsp-bridge
      :repo "emacs-eaf/emacs-application-framework"
      :fetcher github
      :files
      ("*.el"
)
  '';

  # passthru.updateScript = unstableGitUpdater { };


  checkInputs = [
    git
    go
    gopls
    pyright
    python
    ruff
    tempel
  ];

  # doCheck = true;
  # checkPhase = ''
  #   runHook preCheck

  #   cd "$sourceRoot"
  #   ./install-eaf.py --ignore-core-deps

  #   runHook postCheck
  # '';

  # buildPhase = "";


  meta = with lib; {
    description = "A blazingly fast LSP client for Emacs";
    homepage = "https://github.com/manateelazycat/lsp-bridge";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fxttr kira-bruneau ];
  };
}
