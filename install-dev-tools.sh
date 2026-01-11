#!/bin/bash

# Script d'installation des outils de développement
# Installe: zsh, curl, git, Tailscale, Oh My Zsh (thème af-magic), uv, Neovim
# Configure: Git global (sondepoisson), Neovim config

set -e  # Arrêter en cas d'erreur

echo "🚀 Installation des outils de développement..."
echo ""

# Détection du système d'exploitation
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "📦 Système détecté: macOS"

    # Vérifier si Homebrew est installé
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew n'est pas installé. Installation en cours..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "✅ Homebrew déjà installé"
    fi

    # Installation des packages via Homebrew
    echo ""
    echo "📦 Installation de zsh, curl, git, tailscale..."
    brew install zsh curl git tailscale

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "📦 Système détecté: Linux"

    # Détecter le gestionnaire de paquets
    if command -v apt-get &> /dev/null; then
        echo "📦 Utilisation de apt-get..."
        sudo apt-get update
        sudo apt-get install -y zsh curl git

        # Installation de Tailscale
        echo "📦 Installation de Tailscale..."
        curl -fsSL https://tailscale.com/install.sh | sh
    elif command -v yum &> /dev/null; then
        echo "📦 Utilisation de yum..."
        sudo yum install -y zsh curl git

        # Installation de Tailscale
        echo "📦 Installation de Tailscale..."
        curl -fsSL https://tailscale.com/install.sh | sh
    elif command -v pacman &> /dev/null; then
        echo "📦 Utilisation de pacman..."
        sudo pacman -Sy --noconfirm zsh curl git

        # Installation de Tailscale
        echo "📦 Installation de Tailscale..."
        curl -fsSL https://tailscale.com/install.sh | sh
    else
        echo "❌ Gestionnaire de paquets non reconnu"
        exit 1
    fi
else
    echo "❌ Système d'exploitation non supporté: $OSTYPE"
    exit 1
fi

echo ""
echo "✅ zsh, curl, git, tailscale installés"

# Configuration Git globale
echo ""
echo "🔧 Configuration de Git..."
git config --global user.name "sondepoisson"
git config --global user.email "clement.poissoncornu@gmail.com"
echo "✅ Git configuré (user: sondepoisson, email: clement.poissoncornu@gmail.com)"

# Installation de Oh My Zsh
echo ""
echo "📦 Installation de Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "✅ Oh My Zsh installé"
else
    echo "✅ Oh My Zsh déjà installé"
fi

# Configuration du thème af-magic
echo ""
echo "🎨 Configuration du thème af-magic..."
if [ -f "$HOME/.zshrc" ]; then
    # Vérifier si le thème est déjà configuré
    if grep -q '^ZSH_THEME=' "$HOME/.zshrc"; then
        sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="af-magic"/' "$HOME/.zshrc"
        echo "✅ Thème af-magic configuré"
    else
        echo 'ZSH_THEME="af-magic"' >> "$HOME/.zshrc"
        echo "✅ Thème af-magic ajouté"
    fi
else
    echo "⚠️  Fichier .zshrc non trouvé, le thème sera configuré au premier lancement de zsh"
fi

# Installation de uv (gestionnaire de packages Python)
echo ""
echo "📦 Installation de uv..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo "✅ uv installé"
else
    echo "✅ uv déjà installé"
fi

# Installation de Neovim
echo ""
echo "📦 Installation de Neovim..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install neovim
elif command -v apt-get &> /dev/null; then
    sudo apt-get install -y neovim
elif command -v yum &> /dev/null; then
    sudo yum install -y neovim
elif command -v pacman &> /dev/null; then
    sudo pacman -Sy --noconfirm neovim
fi
echo "✅ Neovim installé"

# Installation de la configuration Neovim
echo ""
echo "📦 Installation de la configuration Neovim..."
NVIM_CONFIG_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo "⚠️  Configuration Neovim existante détectée, sauvegarde..."
    mv "$NVIM_CONFIG_DIR" "$NVIM_CONFIG_DIR.backup.$(date +%Y%m%d%H%M%S)"
fi
mkdir -p "$HOME/.config"
git clone https://github.com/SonDePoisson/NeoVim-Config.git "$NVIM_CONFIG_DIR"
echo "✅ Configuration Neovim installée"

# Configuration du shell par défaut
echo ""
read -p "Voulez-vous définir zsh comme shell par défaut ? (o/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[OoYy]$ ]]; then
    if [[ "$SHELL" != *"zsh"* ]]; then
        chsh -s $(which zsh)
        echo "✅ zsh défini comme shell par défaut"
        echo "⚠️  Veuillez vous déconnecter et vous reconnecter pour appliquer les changements"
    else
        echo "✅ zsh est déjà votre shell par défaut"
    fi
fi

# Création du dossier ~/Code
echo ""
echo "📁 Création du dossier ~/Code..."
if [ ! -d "$HOME/Code" ]; then
    mkdir -p "$HOME/Code"
    echo "✅ Dossier ~/Code créé"
else
    echo "✅ Dossier ~/Code déjà existant"
fi

echo ""
echo "🎉 Installation terminée !"
echo ""
echo "Outils installés:"
echo "  - zsh: $(which zsh)"
echo "  - curl: $(which curl)"
echo "  - git: $(which git) (user: sondepoisson)"
echo "  - tailscale: $(which tailscale 2>/dev/null || echo 'Redémarrez votre terminal')"
echo "  - Oh My Zsh: ~/.oh-my-zsh (thème: af-magic)"
echo "  - uv: $(which uv 2>/dev/null || echo 'Redémarrez votre terminal pour utiliser uv')"
echo "  - neovim: $(which nvim 2>/dev/null || echo 'Redémarrez votre terminal')"
echo "  - Config Neovim: ~/.config/nvim"
echo "  - Dossier ~/Code créé pour vos projets"
echo ""
echo "Pour commencer à utiliser zsh, exécutez: zsh"
echo "Pour démarrer Tailscale, exécutez: sudo tailscale up"
