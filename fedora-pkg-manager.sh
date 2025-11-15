#!/bin/bash

# Fedora Package and Copr Repository Manager
# Usage: ./fedora-pkg-manager.sh [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
PACKAGES=()
COPR_REPOS=()
REMOVE_PACKAGES=()
ENABLE_REPOS=()
DISABLE_REPOS=()
ACTION=""

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to check if running on Fedora
check_fedora() {
    if [[ ! -f /etc/fedora-release ]]; then
        print_error "This script is designed for Fedora Linux only!"
        exit 1
    fi
    
    local fedora_version=$(rpm -E %fedora)
    print_status "Running on Fedora $fedora_version"
}

# Function to check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script requires root privileges!"
        print_status "Please run with: sudo $0 $*"
        exit 1
    fi
}

# Function to update system
update_system() {
    print_header "Updating System"
    dnf update -y
    print_status "System updated successfully"
}

# Function to enable Copr repository
enable_copr_repo() {
    local repo=$1
    print_status "Enabling Copr repository: $repo"
    dnf copr enable -y "$repo"
    print_status "Copr repository '$repo' enabled successfully"
}

# Function to disable Copr repository
disable_copr_repo() {
    local repo=$1
    print_status "Disabling Copr repository: $repo"
    dnf copr disable -y "$repo"
    print_status "Copr repository '$repo' disabled successfully"
}

# Function to install packages
install_packages() {
    local packages=("$@")
    if [[ ${#packages[@]} -eq 0 ]]; then
        print_warning "No packages specified for installation"
        return
    fi
    
    print_header "Installing Packages"
    print_status "Installing: ${packages[*]}"
    dnf install -y "${packages[@]}"
    print_status "Packages installed successfully"
}

# Function to remove packages
remove_packages() {
    local packages=("$@")
    if [[ ${#packages[@]} -eq 0 ]]; then
        print_warning "No packages specified for removal"
        return
    fi
    
    print_header "Removing Packages"
    print_status "Removing: ${packages[*]}"
    dnf remove -y "${packages[@]}"
    print_status "Packages removed successfully"
}

# Function to enable regular repositories
enable_repos() {
    local repos=("$@")
    if [[ ${#repos[@]} -eq 0 ]]; then
        print_warning "No repositories specified for enabling"
        return
    fi
    
    print_header "Enabling Repositories"
    for repo in "${repos[@]}"; do
        print_status "Enabling repository: $repo"
        dnf config-manager --set-enabled "$repo"
    done
    print_status "Repositories enabled successfully"
}

# Function to disable regular repositories
disable_repos() {
    local repos=("$@")
    if [[ ${#repos[@]} -eq 0 ]]; then
        print_warning "No repositories specified for disabling"
        return
    fi
    
    print_header "Disabling Repositories"
    for repo in "${repos[@]}"; do
        print_status "Disabling repository: $repo"
        dnf config-manager --set-disabled "$repo"
    done
    print_status "Repositories disabled successfully"
}

# Function to show help
show_help() {
    cat << EOF
Fedora Package and Copr Repository Manager

USAGE:
    sudo $0 [OPTIONS]

OPTIONS:
    -p, --packages PKG1,PKG2,...    Packages to install
    -r, --remove PKG1,PKG2,...      Packages to remove
    -c, --copr REPO1,REPO2,...      Copr repositories to enable
    --disable-copr REPO1,REPO2,...  Copr repositories to disable
    --enable-repo REPO1,REPO2,...    Regular repositories to enable
    --disable-repo REPO1,REPO2,...   Regular repositories to disable
    -u, --update                    Update system before operations
    -h, --help                      Show this help message

EXAMPLES:
    # Install packages with Copr repository
    sudo $0 -c copr.repo/user/project -p package1,package2

    # Remove packages and disable Copr repository
    sudo $0 -r package1,package2 --disable-copr copr.repo/user/project

    # Enable regular repository and install packages
    sudo $0 --enable-repo rpmfusion-free -p vlc,handbrake

    # Update system and install packages
    sudo $0 -u -p git,vim,htop

    # Complex example with multiple operations
    sudo $0 -c copr.repo/user/project1,copr.repo/user/project2 \\
           -p package1,package2,package3 \\
           --enable-repo rpmfusion-free,rpmfusion-nonfree \\
           -u

NOTE:
    - This script requires root privileges
    - Designed specifically for Fedora Linux
    - All operations are performed automatically

EOF
}

# Function to parse comma-separated values
parse_csv() {
    local input=$1
    IFS=',' read -ra array <<< "$input"
    echo "${array[@]}"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--packages)
            IFS=',' read -ra PACKAGES <<< "$2"
            shift 2
            ;;
        -r|--remove)
            IFS=',' read -ra REMOVE_PACKAGES <<< "$2"
            shift 2
            ;;
        -c|--copr)
            IFS=',' read -ra COPR_REPOS <<< "$2"
            shift 2
            ;;
        --disable-copr)
            IFS=',' read -ra DISABLE_COPR_REPOS <<< "$2"
            shift 2
            ;;
        --enable-repo)
            IFS=',' read -ra ENABLE_REPOS <<< "$2"
            shift 2
            ;;
        --disable-repo)
            IFS=',' read -ra DISABLE_REPOS <<< "$2"
            shift 2
            ;;
        -u|--update)
            UPDATE_SYSTEM=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_header "Fedora Package and Copr Repository Manager"
    
    # Check prerequisites
    check_fedora
    check_root
    
    # Update system if requested
    if [[ "$UPDATE_SYSTEM" == true ]]; then
        update_system
    fi
    
    # Enable regular repositories first
    if [[ ${#ENABLE_REPOS[@]} -gt 0 ]]; then
        enable_repos "${ENABLE_REPOS[@]}"
    fi
    
    # Disable regular repositories
    if [[ ${#DISABLE_REPOS[@]} -gt 0 ]]; then
        disable_repos "${DISABLE_REPOS[@]}"
    fi
    
    # Enable Copr repositories
    if [[ ${#COPR_REPOS[@]} -gt 0 ]]; then
        for repo in "${COPR_REPOS[@]}"; do
            enable_copr_repo "$repo"
        done
    fi
    
    # Disable Copr repositories
    if [[ ${#DISABLE_COPR_REPOS[@]} -gt 0 ]]; then
        for repo in "${DISABLE_COPR_REPOS[@]}"; do
            disable_copr_repo "$repo"
        done
    fi
    
    # Install packages
    if [[ ${#PACKAGES[@]} -gt 0 ]]; then
        install_packages "${PACKAGES[@]}"
    fi
    
    # Remove packages
    if [[ ${#REMOVE_PACKAGES[@]} -gt 0 ]]; then
        remove_packages "${REMOVE_PACKAGES[@]}"
    fi
    
    print_header "Operations Completed Successfully"
    print_status "All requested operations have been completed!"
}

# Run main function
main "$@"