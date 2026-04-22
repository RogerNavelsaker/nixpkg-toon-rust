{ bash, fetchFromGitHub, lib, runCommand, rustPlatform }:

let
  manifest = builtins.fromJSON (builtins.readFile ./package-manifest.json);
  upstreamSrc = fetchFromGitHub {
    owner = manifest.source.owner;
    repo = manifest.source.repo;
    rev = manifest.source.rev;
    hash = manifest.source.hash;
  };
  sourceRoot = runCommand "${manifest.binary.name}-${manifest.source.version}-src" {} ''
    mkdir -p "$out/src" "$out/benches"
    cp ${upstreamSrc}/Cargo.toml "$out/Cargo.toml"
    cp ${upstreamSrc}/Cargo.lock "$out/Cargo.lock"
    if [ -f ${upstreamSrc}/build.rs ]; then
      cp ${upstreamSrc}/build.rs "$out/build.rs"
    fi
    if [ -d ${upstreamSrc}/benches ]; then
      cp -R ${upstreamSrc}/benches/. "$out/benches/"
    fi
    cp -R ${upstreamSrc}/src/. "$out/src/"
  '';
  aliasOutputs = manifest.binary.aliases or [ ];
  aliasScripts = lib.concatMapStrings
    (
      alias:
      ''
        cat > "$out/bin/${alias}" <<EOF
#!${lib.getExe bash}
exec "$out/bin/${manifest.binary.name}" "\$@"
EOF
        chmod +x "$out/bin/${alias}"
      ''
    )
    aliasOutputs;
in
rustPlatform.buildRustPackage {
  pname = manifest.binary.name;
  version = manifest.source.version;
  src = sourceRoot;

  cargoLock = {
    lockFile = sourceRoot + "/Cargo.lock";
  };

  cargoBuildFlags = [ "--bin=${manifest.binary.name}" ];
  doCheck = false;

  env = {
    VERGEN_IDEMPOTENT = "1";
    VERGEN_GIT_SHA = manifest.source.rev;
    VERGEN_GIT_DIRTY = "false";
  };

  postInstall = ''
    ${aliasScripts}
  '';

  meta = with lib; {
    description = manifest.meta.description;
    homepage = manifest.meta.homepage;
    license = licenses.mit;
    mainProgram = manifest.binary.name;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
