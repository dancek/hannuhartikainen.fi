---
title: "Arch Linux on Windows 10"
date: 2018-04-18T22:40:17+03:00
tags: ["Arch Linux", "Windows", "WSL"]
---

I recently updated my gaming PC from Windows 7 to 10. I'd heard people talk about WSL (Windows Subsystem for Linux) so I wanted to try it out. I wasn't very keen on playing with Ubuntu, though. I used Debian as my main OS for a long time and as Ubuntu came along it felt like a watered-down misconfigured version of Debian (sorry---it's a great distro, just not my cup of tea). But I already have a real Debian installation in dual-boot, so why add another?

NixOS might be my favorite Linux distro these days, but it seemed to have issues on WSL. [Arch Linux](https://www.archlinux.org/) seemed like a good pick: not very difficult to set up and something people seem to enjoy using day-to-day. My previous experience with Arch was quite a letdown. I tried installing it on a desktop in about 2010. There was some bug in the installation process and people on the Arch IRC channel were quite unhelpful and rude. I probably came off as a stupid noob, English as a second language and all, so maybe that was warranted. But I digress.

Googling for installation instructions was a bit difficult as I knew very little about WSL and different Windows 10 updates. Arch doesn't have an official package in Windows Store as a couple of distros do, and there are some obsolete installation scripts around. Arch wiki used to have a WSL page but it's been deleted. Luckily, [ArchWSL](https://github.com/yuk7/ArchWSL) works just fine. More generally, [WSL-DistroLauncher](https://github.com/yuk7/WSL-DistroLauncher) by the same author can install a lot of distros (and you can find [many prebuilt rootfs tarballs](https://github.com/x-distro/x.distro/releases) online, though I can't vouch for them).

## Basic installation

**NOTE: This installation method is not supported by Arch Linux. Please don't blame them if this doesn't work.**

Someone might come here wishing for instructions on how to get Arch on WSL up and running, so here's what I did:

1. [Enable WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10), ie. run the following in an administrator PowerShell:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

2. Download [ArchWSL](https://github.com/yuk7/ArchWSL/releases/latest) and extract it to wherever you want to keep it (you can't move it after installation). I chose `C:\Linux\Arch`.
3. Run (double-click) `Arch.exe` to install it. This might need to be done as an administrator.
4. Run `Arch.exe` again to get a terminal.
    1. Initialize `pacman` keyring.

        ```
        $ pacman-key --init
        $ pacman-key --populate
        ```

    2. Update package lists and upgrade all packages: 
        
        ```
        $ pacman -Syu
        ```

    3. Install packages needed to build AUR packages. When asked, *don't install `fakeroot`*. You should already have `fakeroot-tcp` which works on Windows.

        ```
        $ pacman -S base-devel
        ```

    4. Create a non-root user, make it a member of the `wheel` group.
        
        ```
        $ useradd -m myuser -G wheel
        ```

    5. Allow `sudo` for members of `wheel`. I used `visudo` to add the line
        
        ```sudoers
        %wheel ALL=(ALL) NOPASSWD: ALL
        ```
        
        because passwords, Windows, nah. You could, of course, set a password to your user: `passwd myuser`.
    6. Log out of your console session: CTRL-D.
5. Change the default user by running `Arch.exe config --default-user myuser` in a command prompt.
6. Reboot your computer for the change to take effect! This is Windows, remember?

You should have a working system and a user with sudo privileges.

## Opinionated next steps

Now is a good time to install a better terminal, e.g. [wsl-terminal](https://github.com/goreliu/wsl-terminal). Open a terminal. It should be using your non-root user (check with `whoami`).

Let's set up some nice-to-have stuff.

1. Download and install `aurman`, an AUR helper. It's quite new but seems to be executed just about perfectly.

    ```shell
    $ curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/aurman.tar.gz
    $ tar -xvzf aurman.tar.gz
    $ cd aurman/
    $ less PKGBUILD  # read and ensure the package is safe
    $ makepkg -si
    ```

2. You can now replace all `pacman` commands with `aurman`. Start by upgrading everything with `aurman -Syu` (which will probably upgrade `aur/fakeroot-tcp`). Note that you don't need to run it with `sudo`.
3. Install stuff you always need.

    ```
    $ aurman -S zsh vim git openssh fzf ripgrep
    ```

4. Create ssh keys: `ssh-keygen`
5. Clone your [dotfiles](https://github.com/dancek/dotfiles).
6. Symlink `fzf` script where it should be. 

    ```
    $ ln -s /usr/share/fzf/key-bindings.zsh ~/.fzf.zsh
    ```

7. Set Zsh as your login shell. Watch Zgen install plugins.
8. Run `:PlugUpdate` in Vim to install plugins.
9. Add a machine in [Code::Stats](https://codestats.net/) and set the API key for [code-stats-zsh](https://gitlab.com/code-stats/code-stats-zsh) and [code-stats-vim](https://gitlab.com/code-stats/code-stats-vim). Don't store the API keys in your dotfiles repo!

There, all set up and ready to go.

## Thoughts about running Linux on Windows

This is probably the first time I felt like I can get basic day-to-day stuff done easily on Windows. Clone a git repo, `rg` for something, modify a bit with Vim, branch, commit, push, done. Easy.

I've dabbled with Cygwin a long time ago, then MSYS, then Git Bash. They were always kludgy. WSL seems to mostly work alright. I realize there are things like the standard `fakeroot` not working, but basic stuff works OK. Not brilliantly, as running commands seems quite slow compared to what I'm used to on Linux and MacOS machines. Probably because my shell config is on the complicated side[^footnote:1] and syscalls on WSL are expensive.

There are some issues. For example, I wrote this post on Windows using native Visual Studio Code, while running a Hugo server in WSL. The Hugo process didn't notice when the files were changed.[^footnote:1] It did notice changes made in Vim, so it looks like the issue is with Linux/Windows interop. I expect a lot of similar minor (but annoying) problems.

Now that I realize it's not horribly complicated, I wonder if I should try installing NixOS or GuixSD. Maybe if I actually use this a lot.

## Other thoughts

A nice unintended side effect of this post was documenting some things I like to do when setting up an OS. I like my (outdated) NixOS configs for a similar reason, but of course you don't mention SSH and API keys there, etc.

This is another blog post that took some time to write and is kind of meant to be helpful for other people. And it's still quite probable that not a single person will ever read this post and follow the steps. I've wondered what's the point when I've seen similar blog posts, but now I somewhat understand: if you want to be able to write about technical stuff, you gotta do it sometime. Sure, there's documentation at work, but I'm learning something trying to write informally about stuff I've done. Still, I probably won't be writing many posts like this one unless they really turn out to be useful to someone.

[^footnote:1]: **EDIT 2018-04-22:** The shell became much more responsive after I disabled git info in my prompt. Also the issue about Hugo not noticing updates was because I was using it wrong. Turns out opening the files inside the Linux rootfs using a Windows app was a bad idea to begin with. When I kept the files in a normal Windows directory and accessed them through `/mnt/c/...`, everything worked as expected.