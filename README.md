# Fedora Package and Copr Repository Manager

A powerful bash script for managing packages and Copr repositories on Fedora Linux. This script simplifies the process of enabling Copr repositories, installing/removing packages, and managing regular repositories with a single command.

## Features

- 📦 **Package Management**: Install and remove packages using DNF
- 🔧 **Copr Repository Support**: Enable and disable Copr repositories
- 🗂️ **Regular Repository Management**: Enable/disable standard Fedora repositories
- 🔄 **System Updates**: Update your system before performing operations
- 🎨 **Colored Output**: Clear, color-coded status messages
- 🛡️ **Safety Checks**: Validates Fedora OS and root privileges
- 📖 **Comprehensive Help**: Built-in help documentation

## Requirements

- Fedora Linux
- Root privileges (sudo access)
- DNF package manager (default on Fedora)

## Installation

1. Download the script:
```bash
wget https://raw.githubusercontent.com/your-repo/fedora-pkg-manager.sh
# or copy the script content to a local file
```

2. Make it executable:
```bash
chmod +x fedora-pkg-manager.sh
```

3. (Optional) Move to a system directory for global access:
```bash
sudo mv fedora-pkg-manager.sh /usr/local/bin/fedora-pkg-manager
```

## Usage

The script must be run with root privileges:

```bash
sudo ./fedora-pkg-manager.sh [OPTIONS]
```

### Command Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `-p, --packages PKG1,PKG2,...` | Packages to install | `-p git,vim,htop` |
| `-r, --remove PKG1,PKG2,...` | Packages to remove | `-r old-package,unused-app` |
| `-c, --copr REPO1,REPO2,...` | Copr repositories to enable | `-c copr.repo/user/project` |
| `--disable-copr REPO1,REPO2,...` | Copr repositories to disable | `--disable-copr copr.repo/user/project` |
| `--enable-repo REPO1,REPO2,...` | Regular repositories to enable | `--enable-repo rpmfusion-free` |
| `--disable-repo REPO1,REPO2,...` | Regular repositories to disable | `--disable-repo testing-repo` |
| `-u, --update` | Update system before operations | `-u` |
| `-h, --help` | Show help message | `-h` |

## Examples

### Basic Package Installation

Install multiple packages:
```bash
sudo ./fedora-pkg-manager.sh -p git,vim,htop,tree
```

### Copr Repository Management

Enable a Copr repository and install packages from it:
```bash
sudo ./fedora-pkg-manager.sh -c copr.repo/user/awesome-project -p awesome-app
```

Enable multiple Copr repositories:
```bash
sudo ./fedora-pkg-manager.sh -c copr.repo/user/project1,copr.repo/user/project2
```

Disable a Copr repository:
```bash
sudo ./fedora-pkg-manager.sh --disable-copr copr.repo/user/old-project
```

### Regular Repository Management

Enable RPM Fusion repositories (common for multimedia):
```bash
sudo ./fedora-pkg-manager.sh --enable-repo rpmfusion-free,rpmfusion-nonfree
```

Install packages after enabling repositories:
```bash
sudo ./fedora-pkg-manager.sh --enable-repo rpmfusion-free -p vlc,handbrake
```

### Package Removal

Remove single or multiple packages:
```bash
sudo ./fedora-pkg-manager.sh -r old-software,unused-library
```

### System Updates

Update system and install packages:
```bash
sudo ./fedora-pkg-manager.sh -u -p firefox,libreoffice
```

### Complex Operations

Combine multiple operations in one command:
```bash
sudo ./fedora-pkg-manager.sh \
  -u \
  -c copr.repo/user/modern-tools,copr.repo/user/dev-utils \
  --enable-repo rpmfusion-free \
  -p neovim,code,obs-studio \
  -r gedit,gedit-plugins
```

This command will:
1. Update the system
2. Enable two Copr repositories
3. Enable RPM Fusion repository
4. Install Neovim, VS Code, and OBS Studio
5. Remove Gedit and its plugins

## Common Use Cases

### Setting Up Development Environment

```bash
sudo ./fedora-pkg-manager.sh \
  -u \
  -c copr.repo/user/dev-tools \
  -p git,nodejs,python3,code,docker \
  --enable-repo rpmfusion-free
```

### Installing Multimedia Software

```bash
sudo ./fedora-pkg-manager.sh \
  --enable-repo rpmfusion-free,rpmfusion-nonfree \
  -p vlc,handbrake,audacity,gimp \
  -u
```

### Testing New Software from Copr

```bash
# Enable Copr and install software
sudo ./fedora-pkg-manager.sh -c copr.repo/user/experimental-app -p experimental-app

# Test the software...

# Remove software and disable Copr if not needed
sudo ./fedora-pkg-manager.sh -r experimental-app --disable-copr copr.repo/user/experimental-app
```

## Script Behavior

### Execution Order

The script performs operations in this specific order to ensure dependencies are properly resolved:

1. **System Update** (if `-u` flag is used)
2. **Enable Regular Repositories** (if `--enable-repo` is specified)
3. **Disable Regular Repositories** (if `--disable-repo` is specified)
4. **Enable Copr Repositories** (if `-c` is specified)
5. **Disable Copr Repositories** (if `--disable-copr` is specified)
6. **Install Packages** (if `-p` is specified)
7. **Remove Packages** (if `-r` is specified)

### Safety Features

- **Fedora Check**: Verifies the script is running on Fedora Linux
- **Root Check**: Ensures the script has root privileges
- **Error Handling**: Stops execution if any command fails
- **Input Validation**: Validates command-line arguments

### Output Colors

- 🟢 **Green**: Success messages and information
- 🟡 **Yellow**: Warning messages
- 🔴 **Red**: Error messages
- 🔵 **Blue**: Section headers

## Troubleshooting

### Common Issues

1. **Permission Denied**: Always run with `sudo`
   ```bash
   sudo ./fedora-pkg-manager.sh [options]
   ```

2. **Copr Repository Not Found**: Verify the Copr repository name
   ```bash
   # Correct format
   copr.repo/username/projectname
   ```

3. **Package Not Found**: Check package names and enabled repositories
   ```bash
   # Search for packages
   dnf search package-name
   ```

4. **Network Issues**: Ensure internet connection for repository access

### Debug Mode

For debugging, you can run the script with bash debug mode:
```bash
sudo bash -x ./fedora-pkg-manager.sh [options]
```

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve the script.

## License

This script is open source and available under the MIT License.

## Changelog

### v1.0.0
- Initial release
- Package installation/removal
- Copr repository management
- Regular repository management
- System update functionality
- Colored output and error handling