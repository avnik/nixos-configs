# Migrate Shared Vim Configuration to nvf Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace shared Vim with a base nvf Neovim for all users and an extended nvf Neovim only for `avn` on bulldozer.

**Architecture:** Build two standalone nvf packages with `nvf.lib.neovimConfiguration`, sharing a base module and composing an extension module. Install the base system-wide and the richer build through Home Manager only for the selected user and host, avoiding importing both nvf system modules.

**Tech Stack:** Nix flakes, nvf, NixOS modules, Home Manager.

**Spec:** `docs/superpowers/specs/2026-10-26-nvf-neovim.md`

## Global Constraints

- Do not build, realize, download, or modify system configuration; use read-only Nix evaluation only.
- Base editor must reach all users on every host using the shared console role.
- Extended profile is exclusive to `avn` on `bulldozer`.
- Do not import nvf NixOS and Home Manager integration modules simultaneously.

## Review Focus

- A host without a special Home Manager user must still receive base Neovim: evaluate a non-bulldozer console-role host.
- Other users on bulldozer must not get the extended package: inspect Home Manager package selection for `olga` and `kris`.
- `vi`/`vim` aliases must not result in duplicate Vim executables: inspect package outputs and aliases.
- Extended profile must include base settings and plugins: evaluate the extended nvf configuration.
- Flake input lock must remain consistent: evaluate flake metadata without updating unrelated inputs.

---

### Task 1: Define shared nvf package configurations

**Files:**
- Create: `roles/neovim/base.nix`
- Create: `roles/neovim/avn-bulldozer.nix`
- Modify: `flake.nix`
- Modify: `flake.lock`

**Interfaces:**
- Produces `inputs.nvf.lib.neovimConfiguration` modules, a base package configuration and an extension module for broad languages/LSP and curated workflow plugins.
- Base module contains general editing, search, UTF-8, indentation, useful aliases, and supported Russian keyboard mapping.

- [ ] **Step 1: Check nvf options against the locked input revision**

Use read-only inspection of the nvf source after adding the input; identify valid options for aliases, editor defaults, languages, LSP, and selected plugins.

- [ ] **Step 2: Add nvf input and update only its lock node**

Use `github:NotAShelf/nvf`, set `inputs.nixpkgs.follows = "nixpkgs"`, and update the lock entry without changing unrelated nodes.

- [ ] **Step 3: Define base module and extension module**

Create `roles/neovim/base.nix` with useful base settings. Create `roles/neovim/avn-bulldozer.nix` for broad language/LSP support and modern plugins matching desired legacy workflows. Keep extension additive to the base.

- [ ] **Step 4: Verify Nix syntax and nvf options**

Run read-only parse/evaluation on the module option trees and confirm both configs expose a Neovim package. No builds or realization.

### Task 2: Install base Neovim for all users and hosts

**Files:**
- Create: `roles/neovim.nix`
- Modify: `roles/console.nix`
- Delete: `roles/vim.nix`
- Modify: `hosts/bulldozer/default.nix`

**Interfaces:**
- `roles/neovim.nix` builds base package with `nvf.lib.neovimConfiguration` using system `pkgs` and installs it via `environment.systemPackages`.
- Shared console role imports `roles/neovim.nix` instead of `roles/vim.nix`.

- [ ] **Step 1: Wire base package into shared console role**

Build base configuration from `roles/neovim/base.nix` and install its `.neovim` output system-wide. Enable appropriate aliases for `nvim`, `vim`, and `vi` without separate Vim package.

- [ ] **Step 2: Remove legacy Vim role and duplicate bulldozer package**

Remove `roles/vim.nix` import path via console update and delete the obsolete role. Remove the direct `neovim` package from bulldozer if present, retaining its configured base replacement.

- [ ] **Step 3: Verify base package appears on representative hosts**

Use read-only Nix evaluation for bulldozer and one other console-role host. Confirm the system package list contains base Neovim and no legacy configured Vim.

### Task 3: Install extended build for avn on bulldozer

**Files:**
- Modify: `users/avn/home.nix`
- Modify: `users/avn/home.nix` session variables or shared editor variables as needed

**Interfaces:**
- Conditional package selection uses existing `hostName` and only adds the extended nvf package when `hostName == "bulldozer"`.
- Extended build composes modules `[ base.nix avn-bulldozer.nix ]` using Home Manager `pkgs`, with no nvf Home Manager module import.

- [ ] **Step 1: Add host-conditional extended Neovim package**

Use `lib.optionals (hostName == "bulldozer")` to install the extended nvf package only in `avn`’s Home Manager configuration.

- [ ] **Step 2: Set editor environment variables**

Set `EDITOR` and `VISUAL` to `nvim` in avn’s session variables.

- [ ] **Step 3: Verify profile boundary and package composition**

Use read-only evaluation of Home Manager package sets for avn on bulldozer and avn on another host. Confirm extended package only appears on bulldozer and includes the base options. Confirm other users receive only system base package.

### Task 4: Final read-only verification

**Files:**
- No additional files.

- [ ] **Step 1: Check flake metadata and lock consistency**

Run `nix flake metadata --no-write-lock-file` and inspect focused lock diff; no unrelated lock changes.

- [ ] **Step 2: Evaluate representative system and Home Manager configuration values**

Run read-only `nix eval` for bulldozer, a second host, and conditional avn package selection. Do not run `./build.sh` because it invokes Nix builds.

- [ ] **Step 3: Review changed files and final diff**

Confirm each acceptance criterion in the spec and ensure existing user changes remain untouched.
