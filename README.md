# nix-pub

Minimal public bootstrap repository for NixOS fleet workstations.

## Purpose

`nix-pub` is an unencrypted, zero-secret public NixOS flake engineered to solve the chicken-and-egg bootstrap problem on freshly provisioned machines (WSL2, bare-metal workstations, and laptops).

It establishes:
1. **Nix Flakes Baseline**: Experimental features enabled (`nix-command`, `flakes`) and store auto-optimisation.
2. **Minimal Toolchain**: Essential tools required to bootstrap keys and clone private repositories (`git`, `gh`, `age`, `sops`, `curl`, `wget`, `openssh`, `zsh`).
3. **Hardened SSH & User Environment**: User `richard` with passwordless sudo, authorized SSH keys, default `zsh` shell, and hardened OpenSSH (`prohibit-password`, password authentication disabled).
4. **WSL2 Integration**: Ready-to-build WSL profile via `nixos-wsl`.

Once `nix-pub` is applied, the machine possesses all prerequisite tooling to authenticate with GitHub, decrypt age/sops secrets, and transition cleanly to the private fleet flake (`nix-priv` / `nixhome`).

---

## Repository Structure

```
.
├── flake.nix                  # Flake entrypoint & outputs
├── modules/
│   ├── base.nix               # Core baseline (flakes, packages, OpenSSH, user shell)
│   └── wsl.nix                # WSL2 runtime integration
├── hosts/
│   └── wsl/
│       └── configuration.nix  # Host-specific user configuration & shell aliases
├── .gitignore
└── README.md
```

---

## Machine Bootstrap Quickstart

### Step 1: Clone Public Bootstrap Flake

On a fresh NixOS installation or fresh WSL2 NixOS instance:

```bash
git clone https://github.com/rasmusson/nix-pub.git ~/nix-pub
cd ~/nix-pub
```

### Step 2: Build & Apply WSL Configuration

Verify and apply the minimal configuration:

```bash
# Verify flake evaluation
nix flake check ~/nix-pub

# Build and activate NixOS system configuration
sudo nixos-rebuild switch --flake ~/nix-pub#wsl
```

---

## Authenticating with GitHub

Authenticate with GitHub using the bundled GitHub CLI (`gh`):

```bash
# Interactive web or token login
gh auth login -s read:org,repo

# Verify authentication status
gh auth status

# Verify SSH authentication to GitHub
ssh -T git@github.com
```

---

## Unlocking Private Fleet Configuration (`nix-priv`)

With GitHub access established and secret tools (`age`, `sops`) pre-installed from `nix-pub`:

### 1. Provision Age Decryption Key

Place or restore your private age key into the standard SOPS key location:

```bash
mkdir -p ~/.config/sops/age
# Restore your age secret key to ~/.config/sops/age/keys.txt:
chmod 600 ~/.config/sops/age/keys.txt
```

### 2. Clone the Private Monorepo

Clone your private configuration repository (`nixhome` / `nix-priv`):

```bash
git clone git@github.com:rasmusson/nixhome.git ~/nixhome
cd ~/nixhome
```

### 3. Transition to Full Fleet System Configuration

Apply the full target host profile from the private flake:

```bash
# Build and switch to the private host configuration
sudo nixos-rebuild switch --flake ~/nixhome#wsl
```

---

## Maintenance & Flake Commands

- **Check Flake**:
  ```bash
  nix flake check ~/nix-pub
  ```
- **Evaluate Toplevel Derivation**:
  ```bash
  nix eval ~/nix-pub#nixosConfigurations.wsl.config.system.build.toplevel.drvPath
  ```
- **Update Flake Lock**:
  ```bash
  nix flake update --flake ~/nix-pub
  ```
